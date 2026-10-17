import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Object? _immutableJson(Object? value, [int depth = 0]) {
  if (depth > 8) {
    throw const FormatException('Sync event is too deeply nested.');
  }
  if (value == null || value is bool || value is int) return value;
  if (value is double && value.isFinite) return value;
  if (value is String && value.length <= 4096) return value;
  if (value is List && value.length <= 512) {
    return List<Object?>.unmodifiable(
        value.map((item) => _immutableJson(item, depth + 1)));
  }
  if (value is Map && value.length <= 128) {
    if (value.keys.any((key) => key is! String || key.length > 128)) {
      throw const FormatException('Invalid sync event data key.');
    }
    final keys = value.keys.cast<String>().toList()..sort();
    return Map<String, dynamic>.unmodifiable({
      for (final key in keys) key: _immutableJson(value[key], depth + 1),
    });
  }
  throw const FormatException('Sync event data must be bounded JSON.');
}

/// An operational receipt. These facts never replay XP or economy mutators.
class NorieSyncEvent {
  factory NorieSyncEvent({
    required String id,
    required String type,
    required String entityId,
    required DateTime occurredAt,
    required Map<String, dynamic> data,
  }) =>
      NorieSyncEvent.fromJson({
        'id': id,
        'type': type,
        'entity_id': entityId,
        'occurred_at': occurredAt.toUtc().toIso8601String(),
        'data': data,
      });

  const NorieSyncEvent._(
      this.id, this.type, this.entityId, this.occurredAt, this.data);

  final String id;
  final String type;
  final String entityId;
  final DateTime occurredAt;
  final Map<String, dynamic> data;

  static const types = {
    'lesson_completed',
    'challenge_completed',
    'assessment_claimed',
    'reward_claimed',
    'classroom_assignment',
    'classroom_submission',
    'season_reward_earned',
  };

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'entity_id': entityId,
        'occurred_at': occurredAt.toUtc().toIso8601String(),
        'data': data,
      };

  static NorieSyncEvent fromJson(Object? raw) {
    const keys = {'id', 'type', 'entity_id', 'occurred_at', 'data'};
    if (raw is! Map ||
        raw.length != keys.length ||
        raw.keys.any((key) => !keys.contains(key))) {
      throw const FormatException('Invalid sync event fields.');
    }
    final id = raw['id'];
    final type = raw['type'];
    final entity = raw['entity_id'];
    final at = raw['occurred_at'];
    final data = raw['data'];
    if (id is! String ||
        id.trim().isEmpty ||
        id.length > 512 ||
        type is! String ||
        !types.contains(type) ||
        entity is! String ||
        entity.trim().isEmpty ||
        entity.length > 512 ||
        at is! String ||
        at.length > 64 ||
        !RegExp(r'(Z|[+-]\d\d:\d\d)$').hasMatch(at) ||
        data is! Map) {
      throw const FormatException('Invalid sync event.');
    }
    final timestamp = DateTime.tryParse(at);
    if (timestamp == null) throw const FormatException('Invalid event date.');
    final immutable = _immutableJson(data) as Map<String, dynamic>;
    final event =
        NorieSyncEvent._(id, type, entity, timestamp.toUtc(), immutable);
    if (utf8.encode(jsonEncode(event.toJson())).length > 16384) {
      throw const FormatException('Sync event is too large.');
    }
    return event;
  }
}

/// Bounded immutable receipts beside the guarded progression snapshot.
///
/// Ownership is coordinated by the account lifecycle: replace/reset invalidates
/// outstanding reads and queued writes. The active account must be checked by
/// that coordinator before applying any remote state. No compaction is safe
/// until all returning devices can recognize an acknowledged checkpoint.
class NorieSyncEventJournal extends ChangeNotifier {
  NorieSyncEventJournal({
    Future<String?> Function()? read,
    Future<bool> Function(String value)? write,
  })  : _read = read ?? _readPreferences,
        _write = write ?? _writePreferences;

  static final instance = NorieSyncEventJournal();
  static const _key = 'norie.sync.events.v1';
  static const maxEvents = 10000;
  static const maxBytes = 2 * 1024 * 1024;
  static const Map<String, dynamic> emptyState = {'version': 1, 'events': []};

  final Future<String?> Function() _read;
  final Future<bool> Function(String) _write;
  final Map<String, NorieSyncEvent> _events = {};
  Map<String, dynamic> _loadedBase = emptyState;
  Future<void>? _loading;
  Future<void> _writes = Future<void>.value();
  bool _loaded = false;
  int _generation = 0;
  int _revision = 0;
  int _savedRevision = 0;
  int _pendingWrites = 0;
  Object? _writeError;
  Object? _lastError;

  Object? get lastError => _lastError;

  /// Test fixtures must drain writes before replacing their asynchronous zone.
  @visibleForTesting
  void resetAsyncQueuesForTesting() {
    _writes = Future<void>.value();
    _loading = null;
  }

  bool get hasPendingWrites =>
      _pendingWrites > 0 || _savedRevision < _revision || _writeError != null;

  List<NorieSyncEvent> get events =>
      List.unmodifiable(_events.values.toList()..sort(_compareEvents));

  /// Deterministic monotonic fact projection only; deliberately excludes scalar
  /// XP/credits and never calls progression reward methods.
  Map<String, List<String>> get permanentFacts {
    final facts = <String, Set<String>>{};
    for (final event in events) {
      facts.putIfAbsent(event.type, () => <String>{}).add(event.entityId);
    }
    final keys = facts.keys.toList()..sort();
    return Map.unmodifiable({
      for (final key in keys)
        key: List<String>.unmodifiable(facts[key]!.toList()..sort()),
    });
  }

  static Future<String?> _readPreferences() async =>
      (await SharedPreferences.getInstance()).getString(_key);

  static Future<bool> _writePreferences(String value) async =>
      (await SharedPreferences.getInstance()).setString(_key, value);

  static int _compareEvents(NorieSyncEvent a, NorieSyncEvent b) {
    final timestamp = a.occurredAt.compareTo(b.occurredAt);
    return timestamp == 0 ? a.id.compareTo(b.id) : timestamp;
  }

  Map<String, dynamic> exportState() => {
        'version': 1,
        'events': events.map((event) => event.toJson()).toList(),
      };

  static Map<String, dynamic> validateState(Object? raw) {
    if (raw is! Map ||
        raw.length != 2 ||
        raw['version'] != 1 ||
        !raw.containsKey('events') ||
        raw['events'] is! List) {
      throw const FormatException('Invalid event journal.');
    }
    final items = raw['events'] as List;
    if (items.length > maxEvents) {
      throw const FormatException(
          'Event journal is full; no receipts removed.');
    }
    final ids = <String>{};
    final validated = <NorieSyncEvent>[];
    for (final item in items) {
      final event = NorieSyncEvent.fromJson(item);
      if (!ids.add(event.id)) {
        throw const FormatException('Duplicate sync event ID.');
      }
      validated.add(event);
    }
    validated.sort(_compareEvents);
    final state = <String, dynamic>{
      'version': 1,
      'events': validated.map((event) => event.toJson()).toList(),
    };
    if (utf8.encode(jsonEncode(state)).length > maxBytes) {
      throw const FormatException(
          'Event journal is too large; receipts retained.');
    }
    return state;
  }

  static Map<String, dynamic> merge(Object? a, Object? b) {
    final first = validateState(a ?? emptyState);
    final second = validateState(b ?? emptyState);
    final merged = <String, Map<String, dynamic>>{};
    for (final state in [first, second]) {
      for (final event
          in (state['events'] as List).cast<Map<String, dynamic>>()) {
        final id = event['id'] as String;
        final previous = merged[id];
        if (previous != null) {
          if (previous['type'] != event['type'] ||
              previous['entity_id'] != event['entity_id'] ||
              jsonEncode(previous['data']) != jsonEncode(event['data'])) {
            throw const FormatException('Conflicting immutable sync event ID.');
          }
          // Two offline devices can independently claim the same stable fact.
          // Payloads must agree; their wall clocks are descriptive metadata.
          final oldTime = DateTime.parse(previous['occurred_at'] as String);
          final newTime = DateTime.parse(event['occurred_at'] as String);
          if (!newTime.isBefore(oldTime)) continue;
        }
        merged[id] = event;
      }
    }
    return validateState({'version': 1, 'events': merged.values.toList()});
  }

  /// Force reload is for a deliberate storage/owner replacement. Drain writes
  /// first, and await the reload before recording more operations.
  Future<void> load({bool force = false}) {
    if (force) {
      if (hasPendingWrites) {
        return Future<void>.error(
            StateError('Flush sync receipts before reloading.'));
      }
      _generation++;
      _loaded = false;
      _loading = null;
      return _loading = _load(_generation, replaceRevision: _revision);
    }
    if (_loaded) return Future<void>.value();
    return _loading ??= _load(_generation);
  }

  Future<void> _load(int generation, {int? replaceRevision}) async {
    try {
      final encoded = await _read();
      if (generation != _generation) return;
      if (encoded != null && utf8.encode(encoded).length > maxBytes) {
        throw const FormatException('Saved sync journal is too large.');
      }
      final disk =
          validateState(encoded == null ? emptyState : jsonDecode(encoded));
      if (replaceRevision != null && replaceRevision != _revision) {
        throw StateError('Sync receipts changed during storage reload.');
      }
      final combined =
          replaceRevision == null ? merge(disk, exportState()) : disk;
      if (generation != _generation) return;
      _replaceEvents(combined);
      _loadedBase = disk;
      _loaded = true;
      notifyListeners();
    } catch (error) {
      if (generation == _generation) {
        _lastError = error;
        notifyListeners();
        rethrow;
      }
    } finally {
      if (generation == _generation) _loading = null;
    }
  }

  NorieSyncEvent record({
    required String type,
    required String entityId,
    Map<String, dynamic> data = const {},
    String? eventId,
  }) {
    try {
      final event = NorieSyncEvent(
        id: eventId ?? const Uuid().v4(),
        type: type,
        entityId: entityId,
        occurredAt: DateTime.now().toUtc(),
        data: data,
      );
      final existing = _events[event.id];
      if (existing != null) {
        if (existing.type != event.type ||
            existing.entityId != event.entityId ||
            jsonEncode(existing.data) != jsonEncode(event.data)) {
          throw const FormatException('Conflicting immutable sync receipt.');
        }
        return existing;
      }
      final next = validateState({
        'version': 1,
        'events': [...events.map((event) => event.toJson()), event.toJson()],
      });
      _events[event.id] = event;
      _revision++;
      _queueSave(next);
      notifyListeners();
      return event;
    } catch (error) {
      _lastError = error;
      notifyListeners();
      rethrow;
    }
  }

  /// Replacement is intentional (cloud restore/reset), unlike union merge.
  /// Invalidate an older account's delayed load and queued captured saves.
  void applyValidatedState(Object? raw) {
    final state = validateState(raw);
    _generation++;
    _loading = null;
    _loaded = true;
    _loadedBase = emptyState;
    _writeError = null;
    _lastError = null;
    _replaceEvents(state);
    _revision++;
    _queueSave(state);
    notifyListeners();
  }

  void reset() => applyValidatedState(emptyState);

  void _replaceEvents(Map<String, dynamic> state) {
    _events
      ..clear()
      ..addEntries((state['events'] as List).map((raw) {
        final event = NorieSyncEvent.fromJson(raw);
        return MapEntry(event.id, event);
      }));
  }

  void _queueSave(Map<String, dynamic> captured, {bool retry = false}) {
    final generation = _generation;
    final revision = _revision;
    _pendingWrites++;
    _writes = _writes.then((_) async {
      try {
        if (generation != _generation) return;
        await load();
        if (generation != _generation) return;
        // A record may race initial disk loading. Preserve existing disk facts
        // in every queued snapshot, including snapshots captured before load.
        final state = merge(_loadedBase, captured);
        final saved = await _write(jsonEncode(state));
        if (generation != _generation) return;
        if (!saved) throw StateError('Sync receipts could not be saved.');
        _savedRevision = revision;
        if (retry) {
          _writeError = null;
          _lastError = null;
        }
      } catch (error) {
        if (generation == _generation) {
          _writeError ??= error;
          _lastError = error;
        }
      } finally {
        _pendingWrites--;
        notifyListeners();
      }
    });
  }

  Future<void> flush({bool retry = false}) async {
    if (retry) _queueSave(exportState(), retry: true);
    // Include mutations queued while a prior asynchronous write was running.
    while (true) {
      final pending = _writes;
      await pending;
      if (identical(pending, _writes)) break;
    }
    if (_writeError != null) {
      Error.throwWithStackTrace(_writeError!, StackTrace.current);
    }
  }
}
