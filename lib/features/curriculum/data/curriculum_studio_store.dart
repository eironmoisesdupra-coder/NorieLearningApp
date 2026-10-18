import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/curriculum_revision.dart';
import '../domain/curriculum_path.dart';
import 'curriculum_registry.dart';

/// Local authoring only: does not write runtime content or progress caches.
class CurriculumStudioStore {
  CurriculumStudioStore(this.ownerId, {bool Function()? stillCurrent})
      : _stillCurrent = stillCurrent ?? _alwaysCurrent {
    if (ownerId.trim().isEmpty || ownerId.length > 256) {
      throw ArgumentError.value(
          ownerId, 'ownerId', 'Provide a stable local/account owner ID.');
    }
  }
  final String ownerId;
  final bool Function() _stillCurrent;
  static bool _alwaysCurrent() => true;
  void _guard() {
    if (!_stillCurrent()) {
      throw const FormatException('Learner changed. Reopen the studio.');
    }
  }

  String get _key =>
      'norie.curriculum.studio.v1.${Uri.encodeComponent(ownerId)}';
  static final Map<String, Future<void>> _queues = {};
  static const maxBytes = 4 * 1024 * 1024;
  Future<Map<String, dynamic>> _read() async {
    _guard();
    final preferences = await SharedPreferences.getInstance();
    _guard();
    final source = preferences.getString(_key);
    if (source == null) {
      return {
        'version': 1,
        'owner': ownerId,
        'history': <String, dynamic>{},
        'paths': <String, dynamic>{}
      };
    }
    if (utf8.encode(source).length > maxBytes) {
      throw const FormatException('Local studio exceeds its size budget.');
    }
    final doc = jsonDecode(source);
    if (doc is! Map<String, dynamic> ||
        doc['version'] != 1 ||
        doc['owner'] != ownerId ||
        doc['history'] is! Map ||
        doc['paths'] is! Map) {
      throw const FormatException(
          'Local studio data is invalid; existing data was preserved.');
    }
    return doc;
  }

  Future<void> _mutate(void Function(Map<String, dynamic>) edit) {
    final previous = _queues[_key] ?? Future<void>.value();
    final next = previous.catchError((Object _) {}).then((_) async {
      final doc = await _read();
      _guard();
      edit(doc);
      final source = jsonEncode(doc);
      if (utf8.encode(source).length > maxBytes) {
        throw const FormatException(
            'Local studio is full. Export drafts before adding more.');
      }
      _guard();
      final preferences = await SharedPreferences.getInstance();
      _guard();
      if (!await preferences.setString(_key, source)) {
        throw StateError('Could not save the local draft.');
      }
    });
    _queues[_key] = next;
    return next;
  }

  Future<List<CurriculumRevision>> load() async {
    await (_queues[_key] ?? Future<void>.value()).catchError((Object _) {});
    final doc = await _read();
    final history = doc['history'] as Map;
    return [
      for (final entries in history.values)
        if ((entries as List).isNotEmpty)
          CurriculumRevision.fromJson(
              Map<String, dynamic>.from(entries.last as Map))
    ];
  }

  Future<List<CurriculumRevision>> history(String id) async {
    await (_queues[_key] ?? Future<void>.value()).catchError((Object _) {});
    final doc = await _read();
    return [
      for (final item in (doc['history'] as Map)[id] as List? ?? [])
        CurriculumRevision.fromJson(Map<String, dynamic>.from(item as Map))
    ];
  }

  Future<void> save(CurriculumRevision revision) => saveAll([revision]);

  /// All revisions are staged in one durable write, or none are changed.
  Future<void> saveAll(List<CurriculumRevision> revisions) => _mutate((doc) {
        final histories = doc['history'] as Map;
        for (final revision in revisions) {
          final history = histories[revision.id] as List? ?? [];
          history.add(revision.asDraft(revision: history.length + 1).toJson());
          histories[revision.id] = history;
        }
      });
  Future<void> rollback(String id) => _mutate((doc) {
        final history = (doc['history'] as Map)[id] as List? ?? [];
        if (history.length < 2) {
          throw const FormatException(
              'There is no earlier revision to restore.');
        }
        final previous = CurriculumRevision.fromJson(
            Map<String, dynamic>.from(history[history.length - 2] as Map));
        history.add(previous.asDraft(revision: history.length + 1).toJson());
      });
  Future<List<CurriculumPath>> paths() async {
    await (_queues[_key] ?? Future<void>.value()).catchError((Object _) {});
    final doc = await _read();
    return [
      for (final path in (doc['paths'] as Map).values)
        CurriculumPath.fromJson(Map<String, dynamic>.from(path as Map))
    ];
  }

  Future<void> savePath(CurriculumPath path, CurriculumRegistry registry) {
    final issues = path.validate(registry);
    if (issues.isNotEmpty) throw FormatException(issues.join('\n'));
    return _mutate((doc) => (doc['paths'] as Map)[path.id] = path.toJson());
  }
}
