import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/content/data/norie_content_catalog.dart';
import '../../features/content/data/norie_foundation_curriculum.dart';
import '../../features/content/domain/norie_content_models.dart';

/// Reading bookmarks, deliberately separate from assessment completion and XP.
class NorieLessonJourney extends ChangeNotifier {
  NorieLessonJourney._();
  static final instance = NorieLessonJourney._();
  static const storageKey = 'norie.lessonJourney.v1';
  String? _lastTopicId;
  Map<String, double> _offsets = {};
  Map<String, double> _mapOffsets = {};
  Future<void> _replacements = Future<void>.value();
  int _ownershipRevision = 0;
  int get ownershipRevision => _ownershipRevision;
  Timer? _debounce;
  bool _dirty = false;
  Future<void> _writes = Future<void>.value();

  /// Test fixtures must drain pending writes before resetting zone-bound queues.
  @visibleForTesting
  void resetAsyncQueuesForTesting() {
    _debounce?.cancel();
    _debounce = null;
    _writes = Future<void>.value();
    _replacements = Future<void>.value();
  }

  String? get lastTopicId => _lastTopicId;
  NorieTopicContent? get lastTopic => resolveTopic(_lastTopicId);
  double offsetFor(String topicId) => _offsets[topicId] ?? 0;
  double? mapOffsetFor(String mapId) => _mapOffsets[mapId];

  Future<void> saveMapOffset(String mapId, double offset) async {
    if (mapId.isEmpty ||
        mapId.length > 240 ||
        !offset.isFinite ||
        offset < 0 ||
        offset > 10000000 ||
        _mapOffsets[mapId] == offset) {
      return;
    }
    _mapOffsets[mapId] = offset;
    _dirty = true;
    await flush();
  }

  static NorieTopicContent? resolveTopic(String? id) {
    if (id == null) return null;
    for (final subject in ['Science', 'Mathematics', 'English']) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        for (final topic
            in NorieFoundationCurriculum.topicsFor(subject, grade.id)) {
          if (topic.id == id && topic.available) return topic;
        }
      }
    }
    final legacy = NorieContentCatalog.topicById(id);
    return legacy?.available == true ? legacy : null;
  }

  Future<void> load() async {
    await flush();
    final prefs = await SharedPreferences.getInstance();
    try {
      final raw = prefs.getString(storageKey);
      _apply(validateState(raw == null ? emptyState : jsonDecode(raw)));
    } on FormatException {
      _apply(emptyState);
    }
    notifyListeners();
  }

  static Map<String, dynamic> get emptyState => {
        'last_topic_id': null,
        'reading_offsets': <String, double>{},
        'map_offsets': <String, double>{},
      };

  static Map<String, dynamic> validateState(dynamic value) {
    if (value is! Map) throw const FormatException('Invalid lesson journey.');
    if (value.keys.any((key) => !const {
          'last_topic_id',
          'reading_offsets',
          'map_offsets'
        }.contains(key))) {
      throw const FormatException('Unexpected lesson journey field.');
    }
    final id = value['last_topic_id'];
    if (id != null && (id is! String || id.isEmpty || id.length > 240)) {
      throw const FormatException('Invalid last lesson ID.');
    }
    final offsets = value['reading_offsets'];
    if (offsets is! Map || offsets.length > 10000) {
      throw const FormatException('Invalid reading bookmarks.');
    }
    final normalized = <String, double>{};
    for (final entry in offsets.entries) {
      final key = entry.key;
      final offset = entry.value;
      if (key is! String ||
          key.isEmpty ||
          key.length > 240 ||
          offset is! num ||
          !offset.isFinite ||
          offset < 0 ||
          offset > 10000000) {
        throw const FormatException('Invalid reading bookmark.');
      }
      normalized[key] = offset.toDouble();
    }
    final maps = value['map_offsets'] ?? <String, double>{};
    final normalizedMaps = _validateOffsets(maps);
    return {
      'last_topic_id': id,
      'reading_offsets': normalized,
      'map_offsets': normalizedMaps
    };
  }

  static Map<String, double> _validateOffsets(dynamic offsets) {
    if (offsets is! Map || offsets.length > 10000) {
      throw const FormatException('Invalid map bookmarks.');
    }
    final result = <String, double>{};
    for (final entry in offsets.entries) {
      if (entry.key is! String ||
          (entry.key as String).isEmpty ||
          (entry.key as String).length > 240 ||
          entry.value is! num ||
          !(entry.value as num).isFinite ||
          entry.value < 0 ||
          entry.value > 10000000) {
        throw const FormatException('Invalid map bookmark.');
      }
      result[entry.key as String] = (entry.value as num).toDouble();
    }
    return result;
  }

  Map<String, dynamic> exportState() => {
        'last_topic_id': _lastTopicId,
        'reading_offsets': Map<String, double>.of(_offsets),
        'map_offsets': Map<String, double>.of(_mapOffsets),
      };

  void _apply(Map<String, dynamic> state) {
    _ownershipRevision++;
    _lastTopicId = state['last_topic_id'] as String?;
    _offsets = Map<String, double>.from(state['reading_offsets'] as Map);
    _mapOffsets = Map<String, double>.from(state['map_offsets'] as Map);
  }

  Future<bool> replaceState(
    Map<String, dynamic> state, {
    bool Function()? stillCurrent,
    void Function()? onApply,
  }) async {
    final validated = validateState(state);
    final operation = _replacements.catchError((Object _) {}).then((_) async {
      if (stillCurrent != null && !stillCurrent()) return false;
      await flush();
      await SharedPreferences.getInstance();
      if (stillCurrent != null && !stillCurrent()) return false;
      _debounce?.cancel();
      _apply(validated);
      _dirty = true;
      // Commit related progression synchronously with the journey. No account
      // switch can split their in-memory state across an asynchronous boundary.
      onApply?.call();
      await flush();
      // A later reading edit is serialized after the replacement snapshot.
      if (stillCurrent == null || stillCurrent()) notifyListeners();
      return true;
    });
    _replacements = operation;
    return operation;
  }

  Future<bool> reset(
          {bool Function()? stillCurrent, void Function()? onApply}) =>
      replaceState(emptyState, stillCurrent: stillCurrent, onApply: onApply);

  void openTopic(String topicId) {
    if (_lastTopicId == topicId) return;
    _lastTopicId = topicId;
    _dirty = true;
    unawaited(flush());
  }

  void recordOffset(String topicId, double offset) {
    if (!offset.isFinite ||
        offset < 0 ||
        offset > 10000000 ||
        offsetFor(topicId) == offset) {
      return;
    }
    _offsets[topicId] = offset;
    _dirty = true;
    _debounce?.cancel();
    _debounce =
        Timer(const Duration(milliseconds: 400), () => unawaited(flush()));
  }

  Future<void> flush() async {
    _debounce?.cancel();
    if (!_dirty) return _writes;
    _dirty = false;
    final encoded = jsonEncode(exportState());
    _writes = _writes.catchError((Object _) {}).then((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(storageKey, encoded);
    });
    await _writes;
    notifyListeners();
  }
}
