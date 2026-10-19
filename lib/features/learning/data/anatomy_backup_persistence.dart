import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class _AnatomyBackupClient {
  _AnatomyBackupClient(
      this.owner, this.flush, this.restored, this.transactionChanged);
  final String? Function() owner;
  final Future<void> Function() flush;
  final void Function(Map<String, String?>) restored;
  final void Function()? transactionChanged;
}

/// One owner-bound persistence envelope for both Anatomy stores. The pending
/// checkpoint is rolled back before readers can observe an interrupted restore.
/// All instances share each owner's queue, including identity compensation.
class AnatomyBackupPersistence {
  AnatomyBackupPersistence({
    Future<String?> Function(String)? read,
    Future<bool> Function(String, String)? write,
  })  : _read = read ?? _readPreferences,
        _write = write ?? _writePreferences;

  static final instance = AnatomyBackupPersistence();
  static final _tails = <String, Future<void>>{};
  static final _revisions = <String, int>{};
  final _clients = <Object, _AnatomyBackupClient>{};
  final _restoring = <String>{};
  final _studyReveals = <String, ({int revision, Set<String> ids})>{};
  final Future<String?> Function(String) _read;
  final Future<bool> Function(String, String) _write;

  static Future<String?> _readPreferences(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);
  static Future<bool> _writePreferences(String key, String value) async =>
      (await SharedPreferences.getInstance()).setString(key, value);

  String _key(String owner) =>
      'norie.anatomy.owner.v1.${Uri.encodeComponent(owner)}';
  String _legacyStudy(String owner) => owner == 'guest'
      ? 'norie.anatomy.study.v1.guest'
      : owner.startsWith('account.')
          ? 'norie.anatomy.study.v1.account.${Uri.encodeComponent(owner.substring(8))}'
          : 'norie.anatomy.study.v1.${Uri.encodeComponent(owner)}';
  String _legacyBookmarks(String owner) =>
      'norie.anatomy.bookmarks.v1.${Uri.encodeComponent(owner)}';

  void _validateOwner(String owner) {
    if (owner.trim().isEmpty ||
        owner == 'account.' ||
        owner.length > 264 ||
        RegExp(r'[\x00-\x1f\x7f]').hasMatch(owner)) {
      throw const FormatException('Invalid Anatomy learner identity.');
    }
  }

  int revision(String owner) => _revisions[owner] ?? 0;
  bool isRestoring(String owner) => _restoring.contains(owner);

  Set<String> _revealedFor(String owner) {
    final currentRevision = revision(owner);
    final known = _studyReveals[owner];
    if (known != null && known.revision == currentRevision) return known.ids;
    final ids = <String>{};
    _studyReveals[owner] = (revision: currentRevision, ids: ids);
    return ids;
  }

  /// Shared before awaiting disk: a second live screen must not treat an answer
  /// already exposed to this learner as fresh independent evidence. A restore
  /// revision starts a new set, which the committed study state then reseeds.
  bool wasAnswerRevealed(String owner, String structureId) =>
      _revealedFor(owner).contains(structureId);

  void noteAnswerRevealed(String owner, String structureId) =>
      _revealedFor(owner).add(structureId);

  void register(
    Object token, {
    required String? Function() owner,
    required Future<void> Function() flush,
    required void Function(Map<String, String?>) restored,
    void Function()? transactionChanged,
  }) =>
      _clients[token] =
          _AnatomyBackupClient(owner, flush, restored, transactionChanged);
  void unregister(Object token) => _clients.remove(token);

  void _notifyTransaction(String owner) {
    for (final client in List.of(_clients.values)) {
      if (client.owner() == owner) client.transactionChanged?.call();
    }
  }

  Future<T> _serial<T>(String owner, Future<T> Function() action) {
    late Future<void> tail;
    void releaseIfDrained() {
      if (identical(_tails[owner], tail)) _tails.remove(owner);
    }

    final operation =
        (_tails[owner] ?? Future<void>.value()).then((_) => action());
    // Remove a drained queue before the caller observes completion. A later
    // owner session (or widget test zone) must not inherit a completed queue's
    // deferred bookkeeping callbacks; pending same-owner work still keeps its
    // newer tail and remains serialized behind compensation.
    final result = operation.then<T>((value) {
      releaseIfDrained();
      return value;
    }, onError: (Object error, StackTrace stack) {
      releaseIfDrained();
      Error.throwWithStackTrace(error, stack);
    });
    tail = result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    _tails[owner] = tail;
    return result;
  }

  Future<void> _flushClients(String owner) async {
    for (final client in List.of(_clients.values)) {
      if (client.owner() == owner) await client.flush();
    }
  }

  Map<String, String?> _pair(dynamic value) {
    if (value is! Map ||
        value.length != 2 ||
        !value.containsKey('study') ||
        !value.containsKey('bookmarks') ||
        value['study'] != null && value['study'] is! String ||
        value['bookmarks'] != null && value['bookmarks'] is! String) {
      throw const FormatException('Invalid saved Anatomy envelope.');
    }
    final result = Map<String, String?>.from(value);
    if (utf8.encode(result['study'] ?? '').length > 262144 ||
        utf8.encode(result['bookmarks'] ?? '').length > 65536) {
      throw const FormatException(
          'Saved Anatomy evidence exceeds the size limit.');
    }
    return result;
  }

  String _encode(String owner, Map<String, String?> committed,
          [Map<String, String?>? pending]) =>
      jsonEncode({
        'version': 1,
        'owner': owner,
        'committed': committed,
        'pending': pending
      });

  Future<void> _save(String owner, Map<String, String?> committed,
      [Map<String, String?>? pending]) async {
    if (!await _write(_key(owner), _encode(owner, committed, pending))) {
      throw StateError(
          'Could not save Anatomy evidence. Retry before continuing.');
    }
  }

  Future<Map<String, String?>> _readPair(String owner) async {
    _validateOwner(owner);
    final raw = await _read(_key(owner));
    if (raw == null) {
      return _pair({
        'study': await _read(_legacyStudy(owner)),
        'bookmarks': await _read(_legacyBookmarks(owner))
      });
    }
    if (utf8.encode(raw).length > 2 * 400 * 1024) {
      throw const FormatException(
          'Saved Anatomy envelope exceeds the size limit.');
    }
    final value = jsonDecode(raw);
    if (value is! Map ||
        value.length != 4 ||
        value['version'] is! int ||
        value['version'] != 1 ||
        value['owner'] != owner ||
        !value.containsKey('pending')) {
      throw const FormatException(
          'Invalid saved Anatomy envelope. Existing data was preserved.');
    }
    final committed = _pair(value['committed']);
    if (value['pending'] != null) {
      _pair(value['pending']);
      // A crash after staging cannot expose half a restore. Repair the durable
      // checkpoint before a study/bookmark read or another mutation proceeds.
      await _save(owner, committed);
    }
    return committed;
  }

  Future<String?> readPart(String owner, String part) =>
      _serial(owner, () async => (await _readPair(owner))[part]);

  Future<Map<String, String?>> capture(String owner) async {
    await _flushClients(owner);
    return _serial(owner, () => _readPair(owner));
  }

  Future<bool> writePart(
    String owner,
    String part,
    String value, {
    required bool Function() stillCurrent,
    int? expectedRevision,
    String Function(String? current)? mergeWithCurrent,
  }) =>
      _serial(owner, () async {
        if (part != 'study' && part != 'bookmarks') {
          throw ArgumentError.value(part);
        }
        bool valid() =>
            stillCurrent() &&
            (expectedRevision == null || revision(owner) == expectedRevision);
        if (!valid()) return false;
        final previous = await _readPair(owner);
        if (!valid()) return false;
        final next = _pair({
          ...previous,
          part: mergeWithCurrent == null
              ? value
              : mergeWithCurrent(previous[part])
        });
        await _save(owner, next);
        if (!valid()) {
          await _save(owner, previous);
          return false;
        }
        return true;
      });

  Future<bool> restore(
    String owner,
    Map<String, String?> parts, {
    required bool Function() stillCurrent,
    Map<String, String?> Function(Map<String, String?> current)?
        mergeWithCurrent,
  }) async {
    final validated = _pair(parts);
    if (!_restoring.add(owner)) {
      throw StateError(
          'Anatomy backup is already being restored. Please wait.');
    }
    _notifyTransaction(owner);
    try {
      // Mutations created before the freeze retain their place in the queues.
      // Only new user actions are rejected while these queues drain.
      await _flushClients(owner);
      return await _serial(owner, () async {
        if (!stillCurrent()) return false;
        final previous = await _readPair(owner);
        if (!stillCurrent()) return false;
        final next = mergeWithCurrent == null
            ? validated
            : _pair(mergeWithCurrent(Map.unmodifiable(previous)));
        // First durable write contains the previous visible pair and pending pair.
        // Only the second write publishes both stores together.
        await _save(owner, previous, next);
        try {
          if (!stillCurrent()) {
            await _save(owner, previous);
            return false;
          }
          await _save(owner, next);
          if (!stillCurrent()) {
            await _save(owner, previous);
            return false;
          }
        } catch (_) {
          // Leave the checkpoint intact if storage remains unavailable. The next
          // read retries recovery before returning any state.
          await _save(owner, previous);
          rethrow;
        }
        _revisions[owner] = revision(owner) + 1;
        for (final client in List.of(_clients.values)) {
          if (client.owner() == owner) client.restored(Map.unmodifiable(next));
        }
        return true;
      });
    } finally {
      _restoring.remove(owner);
      _notifyTransaction(owner);
    }
  }
}
