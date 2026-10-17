import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/account/norie_account_service.dart';
import '../domain/norie_classroom_models.dart';
import '../domain/norie_classroom_resolver.dart';
import 'norie_classroom_codec.dart';

/// Durable, bounded offline practice. Scores are recomputed from installed content.
class NorieClassroomStore extends ChangeNotifier {
  NorieClassroomStore(
      {Future<String?> Function()? read, Future<bool> Function(String)? write})
      : _read = read ?? _readPreferences,
        _write = write ?? _writePreferences;
  static final instance = NorieClassroomStore();
  static const storageKey = 'norie.classroom.phase_a.v1';
  static const maxAssignments = 200,
      maxSubmissions = 2000,
      maxStateBytes = 4 * 1024 * 1024;
  static Map<String, dynamic> get emptyState =>
      {'version': 1, 'assignments': <dynamic>[], 'submissions': <dynamic>[]};
  final Future<String?> Function() _read;
  final Future<bool> Function(String) _write;
  Future<void> _tail = Future.value();

  /// Test fixtures must drain writes before replacing their asynchronous zone.
  @visibleForTesting
  void resetAsyncQueuesForTesting() {
    _tail = Future<void>.value();
    _pendingApply = null;
  }

  Map<String, dynamic> _state = emptyState;
  bool _loaded = false;
  int _epoch = 0;
  static Future<String?> _readPreferences() async =>
      (await SharedPreferences.getInstance()).getString(storageKey);
  static Future<bool> _writePreferences(String value) async =>
      (await SharedPreferences.getInstance()).setString(storageKey, value);
  List<NorieClassroomAssignment> get assignments => List.unmodifiable(
      (_state['assignments'] as List).map(NorieClassroomAssignment.fromJson));
  List<NorieClassroomSubmission> get submissions => List.unmodifiable(
      (_state['submissions'] as List).map(NorieClassroomSubmission.fromJson));
  Map<String, dynamic> exportState() =>
      jsonDecode(jsonEncode(_state)) as Map<String, dynamic>;
  static Map<String, dynamic> validatedState(Object? raw) {
    final m = classroomMap(raw);
    final aa = m['assignments'], ss = m['submissions'];
    if (m['version'] != 1 ||
        aa is! List ||
        ss is! List ||
        aa.length > maxAssignments ||
        ss.length > maxSubmissions) {
      throw const FormatException('Unsupported or oversized classroom state.');
    }
    if (utf8.encode(jsonEncode(m)).length > maxStateBytes) {
      throw const FormatException(
          'Classroom storage is full. Export reports before adding more work.');
    }
    final assignments = <String, NorieClassroomAssignment>{};
    for (final raw in aa) {
      final parsed = NorieClassroomAssignment.fromJson(raw);
      NorieClassroomResolver.questionsFor(parsed);
      final a = NorieClassroomResolver.withSignature(parsed);
      if (assignments.containsKey(a.id)) {
        throw const FormatException('Duplicate classroom assignment.');
      }
      assignments[a.id] = a;
    }
    final submissions = <String, NorieClassroomSubmission>{};
    final attempts = <String, Set<int>>{};
    for (final raw in ss) {
      final s = NorieClassroomSubmission.fromJson(raw);
      final a = assignments[s.assignmentId];
      if (a == null) {
        throw const FormatException('Submission has no matching assignment.');
      }
      final scored = NorieClassroomResolver.score(a, s);
      if (submissions.containsKey(s.id)) {
        throw const FormatException('Duplicate classroom submission.');
      }
      final key = jsonEncode([s.assignmentId, s.learnerAlias.toLowerCase()]);
      final seen = attempts.putIfAbsent(key, () => {});
      if (!seen.add(s.attemptNumber)) {
        throw const FormatException('Conflicting classroom attempt.');
      }
      submissions[s.id] = scored;
    }
    return {
      'version': 1,
      'assignments': assignments.values.map((a) => a.toJson()).toList(),
      'submissions': submissions.values.map((s) => s.toJson()).toList()
    };
  }

  static Map<String, dynamic> merge(Object? primary, Object? secondary) {
    final p = validatedState(primary), s = validatedState(secondary);
    List<dynamic> union(String key) {
      final values = <String, Map<String, dynamic>>{};
      for (final raw in [...p[key] as List, ...s[key] as List]) {
        final value = classroomMap(raw);
        final id = value['id'] as String;
        final old = values[id];
        if (old != null && jsonEncode(old) != jsonEncode(value)) {
          throw const FormatException('Conflicting classroom package ID.');
        }
        values[id] = value;
      }
      final ids = values.keys.toList()..sort();
      return [for (final id in ids) values[id]!];
    }

    return validatedState({
      'version': 1,
      'assignments': union('assignments'),
      'submissions': union('submissions')
    });
  }

  Future<T> _queue<T>(Future<T> Function() action) {
    final operation = _tail.then((_) => action());
    _tail = operation.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return operation;
  }

  void _check(bool Function() guard) {
    if (!guard()) throw StateError('The learner changed. Reopen Classroom.');
  }

  Future<void> load({bool force = false}) {
    final epoch = _epoch;
    final guard = NorieAccountService.instance.captureLearnerGuard();
    return _queue(() async {
      if (epoch != _epoch) return;
      if (_loaded && !force) return;
      final raw = await _read();
      if (raw != null) {
        NorieClassroomCodec.checkBoundedJson(raw, byteLimit: maxStateBytes);
      }
      final state = raw == null ? emptyState : validatedState(jsonDecode(raw));
      _check(guard);
      if (epoch != _epoch) return;
      _state = state;
      _loaded = true;
      notifyListeners();
    });
  }

  Future<void> _commit(
      Map<String, dynamic> state, bool Function() guard, int epoch,
      {bool allowSupersededApply = false}) async {
    if (allowSupersededApply && epoch != _epoch) return;
    _check(guard);
    if (epoch != _epoch) throw StateError('Classroom ownership changed.');
    final encoded = jsonEncode(state);
    if (!await _write(encoded)) {
      throw StateError('Classroom data could not be saved. Please retry.');
    }
    if (!guard() || epoch != _epoch) {
      // The shared preference key may already contain the departed learner's
      // write. Restore the currently authorized captured state before yielding
      // to another queued operation or allowing a restart to read this key.
      int restoredEpoch;
      do {
        restoredEpoch = _epoch;
        final restore = jsonEncode(_state);
        if (!await _write(restore)) {
          throw StateError(
              'Could not restore classroom storage after learner change.');
        }
      } while (restoredEpoch != _epoch);
      if (allowSupersededApply && epoch != _epoch) return;
      throw StateError('Classroom ownership changed.');
    }
    _state = state;
    _loaded = true;
    notifyListeners();
  }

  Future<void> applyState(Object? raw, {bool Function()? stillCurrent}) {
    final state = validatedState(raw);
    final guard =
        stillCurrent ?? NorieAccountService.instance.captureLearnerGuard();
    final epoch = _epoch;
    return _queue(() => _commit(state, guard, epoch));
  }

  void applyValidatedState(Object? raw, {bool Function()? stillCurrent}) {
    final next = validatedState(raw);
    final guard =
        stillCurrent ?? NorieAccountService.instance.captureLearnerGuard();
    _check(guard);
    final epoch = ++_epoch;
    // Owner lifecycle must stop exposing the previous learner synchronously.
    // Listeners publish only after this captured replacement is durable.
    _state = next;
    _loaded = true;
    _pendingApply =
        _queue(() => _commit(next, guard, epoch, allowSupersededApply: true));
  }

  Future<void>? _pendingApply;
  Future<void> flush() async {
    final pending = _pendingApply;
    await _tail;
    if (pending != null) await pending;
  }

  Future<void> reset({bool Function()? stillCurrent}) =>
      applyState(emptyState, stillCurrent: stillCurrent);
  Future<void> importAssignment(NorieClassroomAssignment source,
      {bool Function()? stillCurrent}) {
    final parsed = NorieClassroomAssignment.fromJson(source.toJson());
    NorieClassroomResolver.questionsFor(parsed);
    final a = NorieClassroomResolver.withSignature(parsed);
    final guard =
        stillCurrent ?? NorieAccountService.instance.captureLearnerGuard();
    final epoch = _epoch;
    return _queue(() async {
      _check(guard);
      if (epoch != _epoch) throw StateError('Classroom ownership changed.');
      final next = merge(_state, {
        'version': 1,
        'assignments': [a.toJson()],
        'submissions': []
      });
      await _commit(next, guard, epoch);
    });
  }

  int attemptsFor(String assignment, String alias) => submissions
      .where((s) =>
          s.assignmentId == assignment &&
          s.learnerAlias.toLowerCase() == alias.trim().toLowerCase())
      .length;
  Future<bool> recordSubmission(NorieClassroomSubmission source,
      {bool Function()? stillCurrent}) async {
    final s = NorieClassroomSubmission.fromJson(source.toJson());
    final guard =
        stillCurrent ?? NorieAccountService.instance.captureLearnerGuard();
    final epoch = _epoch;
    return _queue(() async {
      _check(guard);
      if (epoch != _epoch) throw StateError('Classroom ownership changed.');
      final a = assignments.where((a) => a.id == s.assignmentId).firstOrNull;
      if (a == null) {
        throw const FormatException(
            'Import the assignment before its submission.');
      }
      final scored = NorieClassroomResolver.score(a, s);
      final old = submissions.where((v) => v.id == s.id).firstOrNull;
      if (old != null) {
        if (jsonEncode(old.toJson()) != jsonEncode(scored.toJson())) {
          throw const FormatException('Conflicting submission ID.');
        }
        return false;
      }
      final next = exportState();
      (next['submissions'] as List).add(scored.toJson());
      await _commit(validatedState(next), guard, epoch);
      return true;
    });
  }
}
