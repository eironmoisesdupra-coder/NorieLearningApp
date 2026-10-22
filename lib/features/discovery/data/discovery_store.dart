import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/account/norie_account_service.dart';
import '../domain/discovery_mission.dart';

/// Local, unverified learning activity. Never an authority for course rewards.
class DiscoveryStore extends ChangeNotifier {
  DiscoveryStore(
      {String? Function()? ownerId,
      Listenable? ownerChanges,
      Future<String?> Function(String)? read,
      Future<void> Function(String, String)? write})
      : _ownerId = ownerId ?? (() => NorieAccountService.instance.user?.id),
        _ownerChanges = ownerChanges ??
            (ownerId == null ? NorieAccountService.instance : null),
        _read = read ?? _readPreference,
        _write = write ?? _writePreference {
    _ownerChanges?.addListener(_synchronize);
  }

  static const missionId = 'vanishing-water';
  static const missionRevision = 1;
  static final _queues = <String, Future<void>>{};
  // Failed compensation must survive route/store disposal within this process.
  // Access remains blocked until the prior snapshot can be restored. This is
  // recovery for observed write failures, not a crash/fsync guarantee.
  static final _recoveries = <String, String>{};
  final String? Function() _ownerId;
  final Listenable? _ownerChanges;
  final Future<String?> Function(String) _read;
  final Future<void> Function(String, String) _write;
  String? _owner, _error;
  bool _started = false, _ready = false, _disposed = false, _temporary = false;
  int _generation = 0;
  final _busy = <int, int>{};
  _Snapshot _snapshot = _Snapshot.initial();
  Future<void> _loading = Future.value(), _pending = Future.value();
  _Change Function(_Snapshot)? _failed;

  DiscoveryMissionState get state => _snapshot.state;
  Map<String, dynamic>? get journalEntry => _snapshot.journal == null
      ? null
      : jsonDecode(jsonEncode(_snapshot.journal)) as Map<String, dynamic>;
  bool get ready => _ready && !_disposed;
  bool get busy => (_busy[_generation] ?? 0) > 0;
  bool get temporary => _temporary;
  bool get assisted => _snapshot.assisted;
  int get applicationAttempts => _snapshot.attempts;
  String? get error => _error;

  static String storageKeyFor(String? owner) =>
      'norie.discovery.v1.${owner == null ? 'guest' : 'account.${Uri.encodeComponent(owner)}'}';
  static Future<String?> _readPreference(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);
  static Future<void> _writePreference(String key, String value) async {
    if (!await (await SharedPreferences.getInstance()).setString(key, value)) {
      throw StateError('Discovery save failed');
    }
  }

  static Future<T> _serial<T>(String key, Future<T> Function() work) {
    final result = (_queues[key] ?? Future.value()).then((_) => work());
    final tail =
        result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    _queues[key] = tail;
    return result.whenComplete(() {
      if (identical(_queues[key], tail)) _queues.remove(key);
    });
  }

  Future<_Snapshot> _readSafely(String key, String? owner) async {
    final previous = _recoveries[key];
    if (previous != null) {
      await _write(key, previous);
      if (_recoveries[key] == previous) _recoveries.remove(key);
    }
    return _decode(await _read(key), owner);
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  bool _current(int generation) =>
      generation == _generation && _ownerId() == _owner;
  bool Function() captureOwnerGuard() {
    _synchronize();
    final generation = _generation;
    return () => !_disposed && _current(generation);
  }

  Future<void> initialize() {
    _synchronize();
    return _loading;
  }

  void _synchronize() {
    final owner = _ownerId();
    if (_started && owner == _owner) return;
    _started = true;
    _owner = owner;
    _generation++;
    _ready = false;
    _temporary = false;
    _error = null;
    _failed = null;
    _snapshot = _Snapshot.initial();
    if (!_disposed) {
      final generation = _generation, key = storageKeyFor(owner);
      _loading = _serial(key, () async {
        try {
          final snapshot = await _readSafely(key, owner);
          if (!_current(generation) || _disposed) return;
          _snapshot = snapshot;
          _ready = true;
        } catch (_) {
          if (_current(generation)) {
            _error =
                'Saved case could not be read. Retry, or play temporarily without replacing it.';
          }
        }
        _notify();
      });
      _notify();
    }
  }

  Future<bool> _mutate(_Change Function(_Snapshot) edit) async {
    if (_disposed) return false;
    _synchronize();
    final generation = _generation, owner = _owner;
    await _loading;
    if (!_current(generation) || !ready) return false;
    if (_temporary) {
      final change = edit(_snapshot);
      _snapshot = change.snapshot;
      _notify();
      return change.accepted;
    }
    _busy[generation] = (_busy[generation] ?? 0) + 1;
    _notify();
    final operation = _serial(storageKeyFor(owner), () async {
      if (!_current(generation)) return false;
      try {
        final original = await _readSafely(storageKeyFor(owner), owner);
        if (!_current(generation)) return false;
        final change = edit(original);
        final encoded = _encode(change.snapshot, owner);
        if (encoded != _encode(original, owner)) {
          await _write(storageKeyFor(owner), encoded);
        }
        if (!_current(generation)) {
          // The owner queue is still held: no newer generation can read or
          // overwrite this key until the stale write has been compensated.
          if (encoded != _encode(original, owner)) {
            final key = storageKeyFor(owner),
                previous = _encode(original, owner);
            _recoveries[key] = previous;
            await _write(key, previous);
            if (_recoveries[key] == previous) _recoveries.remove(key);
          }
          return false;
        }
        _snapshot = change.snapshot;
        _error = null;
        _failed = null;
        return change.accepted;
      } catch (_) {
        if (_current(generation)) {
          _error =
              'Case save was not confirmed. Retry saving or play temporarily without replacing saved data.';
          _failed = edit;
        }
        return false;
      }
    });
    _pending = operation.then<void>((_) {});
    try {
      return await operation;
    } finally {
      final remaining = (_busy[generation] ?? 1) - 1;
      if (remaining == 0) {
        _busy.remove(generation);
      } else {
        _busy[generation] = remaining;
      }
      _notify();
    }
  }

  Future<bool> _transition(
          DiscoveryMissionState Function(DiscoveryMissionState) action) =>
      _mutate((s) {
        final state = action(s.state);
        return _Change(s.withState(state), !identical(state, s.state));
      });
  Future<bool> inspect(DiscoveryClue clue) =>
      _transition((s) => s.inspect(clue));
  Future<bool> continueMission() => _transition((s) => switch (s.stage) {
        DiscoveryStage.inspect => s.continueFromClues(),
        DiscoveryStage.experiment => s.continueFromExperiment(),
        _ => s,
      });
  Future<bool> runTrial({required bool warm}) =>
      _transition((s) => s.runTrial(warm: warm));
  Future<bool> conclude(
          {required bool evaporation, required DiscoveryEvidence evidence}) =>
      _transition((s) =>
          s.submitConclusion(evaporation: evaporation, evidence: evidence));
  Future<bool> applyAnswer({required bool correct}) => _mutate((s) {
        if (s.state.stage != DiscoveryStage.apply || s.attempts >= 1000000) {
          return _Change(s, false);
        }
        final state = s.state.submitApplication(correct: correct);
        final attempts = s.attempts + 1;
        final journal = s.journal ??
            (state.complete
                ? {
                    'mission': missionId,
                    'revision': missionRevision,
                    'state': state.toJson(),
                    'assisted': s.assisted,
                    'attempts': attempts,
                  }
                : null);
        return _Change(
            _Snapshot(state, journal, s.assisted, attempts), correct);
      });
  Future<bool> requestHint() => _mutate((s) =>
      s.state.stage.index < DiscoveryStage.apply.index && !s.assisted
          ? _Change(_Snapshot(s.state, s.journal, true, s.attempts), true)
          : _Change(s, false));
  Future<bool> reset() => _mutate((s) => _Change(
      _Snapshot(DiscoveryMissionState(), s.journal, s.assisted, s.attempts),
      true));
  Future<bool> retry() async {
    _synchronize();
    if (_disposed || _temporary) return false;
    final failed = _failed;
    if (failed != null) return _mutate(failed);
    _started = false;
    await initialize();
    return ready;
  }

  void continueTemporarily() {
    _synchronize();
    if (_disposed || busy || _error == null) return;
    _temporary = true;
    _ready = true;
    _failed = null;
    _notify();
  }

  static String _encode(_Snapshot s, String? owner) => jsonEncode({
        'schema': 1,
        'mission': missionId,
        'revision': missionRevision,
        'owner': owner,
        'state': s.state.toJson(),
        'journal': s.journal,
        'assisted': s.assisted,
        'attempts': s.attempts,
      });
  static _Snapshot _decode(String? raw, String? owner) {
    if (raw == null) return _Snapshot.initial();
    if (raw.length > 32768) throw const FormatException('Case too large');
    final value = jsonDecode(raw);
    const fields = {
      'schema',
      'mission',
      'revision',
      'owner',
      'state',
      'journal',
      'assisted',
      'attempts'
    };
    if (value is! Map ||
        value.length != fields.length ||
        value.keys.any((k) => !fields.contains(k)) ||
        value['schema'] is! int ||
        value['schema'] != 1 ||
        value['revision'] is! int ||
        value['revision'] != missionRevision ||
        value['mission'] != missionId ||
        value['owner'] != owner ||
        value['assisted'] is! bool ||
        value['attempts'] is! int) {
      throw const FormatException('Invalid case envelope');
    }
    final state = DiscoveryMissionState.fromJson(value['state']);
    final attempts = value['attempts'] as int;
    if (attempts < 0 ||
        attempts > 1000000 ||
        (state.complete && attempts == 0)) {
      throw const FormatException('Invalid attempts');
    }
    final journal = value['journal'];
    if (journal != null) {
      const keys = {'mission', 'revision', 'state', 'assisted', 'attempts'};
      if (journal is! Map<String, dynamic> ||
          journal.length != keys.length ||
          journal.keys.any((k) => !keys.contains(k)) ||
          journal['mission'] != missionId ||
          journal['revision'] is! int ||
          journal['revision'] != missionRevision ||
          journal['assisted'] is! bool ||
          journal['attempts'] is! int ||
          journal['attempts'] < 1 ||
          journal['attempts'] > 1000000 ||
          !DiscoveryMissionState.fromJson(journal['state']).complete) {
        throw const FormatException('Invalid journal evidence');
      }
    }
    if (state.complete && journal == null) {
      throw const FormatException('Missing journal');
    }
    return _Snapshot(state, journal as Map<String, dynamic>?,
        value['assisted'] as bool, attempts);
  }

  @override
  void dispose() {
    _disposed = true;
    // Accepted writes may finish after a route closes. Keep identity observation
    // until they drain so even A -> B -> A invalidates delayed callbacks.
    unawaited(_pending
        .whenComplete(() => _ownerChanges?.removeListener(_synchronize)));
    super.dispose();
  }
}

class _Snapshot {
  _Snapshot(this.state, this.journal, this.assisted, this.attempts);
  factory _Snapshot.initial() =>
      _Snapshot(DiscoveryMissionState(), null, false, 0);
  final DiscoveryMissionState state;
  final Map<String, dynamic>? journal;
  final bool assisted;
  final int attempts;
  _Snapshot withState(DiscoveryMissionState state) =>
      _Snapshot(state, journal, assisted, attempts);
}

class _Change {
  _Change(this.snapshot, this.accepted);
  final _Snapshot snapshot;
  final bool accepted;
}
