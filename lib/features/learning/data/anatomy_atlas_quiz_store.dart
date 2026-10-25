import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:uuid/uuid.dart';
import '../domain/anatomy_atlas_catalog.dart';
import '../domain/anatomy_atlas_quiz_snapshot.dart';

/// One active device-local round per learner. Currency remains in the economy.
class AtlasQuizStore {
  AtlasQuizStore({required String? owner, bool Function()? stillCurrent})
      : owner =
            owner == null ? 'guest' : 'account.${Uri.encodeComponent(owner)}',
        _stillCurrent = stillCurrent ?? _always;
  static bool _always() => true;
  final String owner;
  final bool Function() _stillCurrent;
  String get storageKey => 'norie.atlasQuiz.round.v1.$owner';
  String get _epochKey => 'norie.atlasQuiz.epoch.v1.$owner';
  static final _queues = <String, Future<void>>{};
  Future<T> _serial<T>(Future<T> Function() action) {
    final result = (_queues[owner] ?? Future<void>.value())
        .catchError((Object _) {})
        .then((_) => action());
    final tail =
        result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    _queues[owner] = tail;
    unawaited(tail.then((_) {
      if (identical(_queues[owner], tail)) _queues.remove(owner);
    }));
    return result;
  }

  void _guard() {
    if (!_stillCurrent()) {
      throw StateError('Learner or progress changed; reopen the saved quiz.');
    }
  }

  Future<Map<String, Object>> _disk() async {
    _guard();
    final raw = await SharedPreferencesStorePlatform.instance.getAll();
    _guard();
    return raw;
  }

  String _epoch(Map<String, Object> raw) {
    final value = raw['flutter.$_epochKey'];
    if (value == null) return 'initial';
    if (value is! String || !AtlasSavedRound.uuid.hasMatch(value)) {
      throw const FormatException('Atlas recovery marker needs repair.');
    }
    return value;
  }

  AtlasSavedRound? _decode(
      AnatomyAtlasCatalog catalog, Map<String, Object> disk,
      {bool validateEpoch = true}) {
    final raw = disk['flutter.$storageKey'];
    if (raw == null) return null;
    if (raw is! String || utf8.encode(raw).length > 262144) {
      throw const FormatException('Invalid saved Atlas data.');
    }
    final doc = jsonDecode(raw);
    if (doc is! Map ||
        doc.length != 3 ||
        doc['schema'] != 1 ||
        doc['owner'] != owner ||
        doc['round'] is! Map) {
      throw const FormatException('Invalid saved Atlas owner.');
    }
    final round = AtlasSavedRound.restore(
        catalog, Map<String, dynamic>.from(doc['round'] as Map));
    if (validateEpoch && round.epoch != _epoch(disk)) {
      throw StateError(
          'Learning progress was restored. This saved round cannot safely resume grading. Start a new round explicitly.');
    }
    return round;
  }

  Future<AtlasSavedRound?> read(AnatomyAtlasCatalog catalog) =>
      _serial(() async => _decode(catalog, await _disk()));

  /// Retiring a round for explicit backup restore waits for accepted effects.
  /// Acknowledgement remains a separate durable step and can be retried.
  Future<void> reconcileEffect(AnatomyAtlasCatalog catalog,
          AtlasSavedRound round, Future<void> Function() effect) =>
      _serial(() async {
        final current = _decode(catalog, await _disk());
        if (current == null ||
            current.attemptId != round.attemptId ||
            current.revision != round.revision) {
          throw StateError('Saved round changed before applying progress.');
        }
        await effect();
        _guard();
      });

  Future<void> _write(String key, String value, Object? previous) async {
    _guard();
    final prefs = await SharedPreferences.getInstance();
    _guard();
    try {
      if (!await prefs.setString(key, value)) {
        throw StateError('Local quiz save failed.');
      }
    } on Object {
      try {
        if (previous == null) {
          await prefs.remove(key);
        } else if (previous is String) {
          await prefs.setString(key, previous);
        } else if (previous is bool) {
          await prefs.setBool(key, previous);
        } else if (previous is int) {
          await prefs.setInt(key, previous);
        } else if (previous is double) {
          await prefs.setDouble(key, previous);
        } else if (previous is List<String>) {
          await prefs.setStringList(key, previous);
        }
      } on Object {
        /* Preserve the original failure; backend reads never trust the optimistic cache. */
      }
      rethrow;
    }
    _guard();
  }

  String _encode(AtlasSavedRound round) =>
      jsonEncode({'schema': 1, 'owner': owner, 'round': round.toJson()});
  Future<AtlasSavedRound> save(
          AnatomyAtlasCatalog catalog, AtlasSavedRound round) =>
      _serial(() async {
        final disk = await _disk();
        final current = _decode(catalog, disk);
        if (current == null ||
            current.attemptId != round.attemptId ||
            current.revision != round.revision ||
            round.epoch != _epoch(disk)) {
          throw StateError('Saved round changed. Reopen it before continuing.');
        }
        final next = round.atRevision(catalog, round.revision + 1);
        final value = _encode(next);
        if (utf8.encode(value).length > 262144) {
          throw StateError('Saved round exceeds storage limits.');
        }
        await _write(storageKey, value, disk['flutter.$storageKey']);
        return next;
      });
  Future<AtlasSavedRound> start(
          AnatomyAtlasCatalog catalog, AtlasQuizRequest request,
          {bool discard = false}) =>
      _serial(() async {
        final disk = await _disk();
        final previous = disk['flutter.$storageKey'];
        AtlasSavedRound? current;
        try {
          current = _decode(catalog, disk, validateEpoch: false);
        } on FormatException {
          if (!discard) rethrow;
        }
        if (current != null &&
            current.epoch == _epoch(disk) &&
            current.finished &&
            !current.rewardAck) {
          throw StateError(
              'Finish saving the previous round reward before starting another.');
        }
        if (previous != null && !discard) {
          throw StateError(
              'A saved round exists; resume or explicitly start a new round.');
        }
        if (previous != null) {
          await _write(
              'norie.atlasQuiz.quarantine.v1.$owner.${const Uuid().v4()}',
              previous is String ? previous : jsonEncode(previous),
              null);
        }
        final round = AtlasSavedRound.create(catalog, request, _epoch(disk))
            .atRevision(catalog, 1);
        await _write(storageKey, _encode(round), previous);
        return round;
      });
  static Future<void> invalidateOwner(String? owner,
      {required bool Function() stillCurrent}) {
    final store = AtlasQuizStore(owner: owner, stillCurrent: stillCurrent);
    return store._serial(() async {
      final disk = await store._disk();
      await store._write(store._epochKey, const Uuid().v4(),
          disk['flutter.${store._epochKey}']);
    });
  }
}
