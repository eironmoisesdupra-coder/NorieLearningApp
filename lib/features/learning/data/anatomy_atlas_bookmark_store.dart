import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/anatomy_atlas_catalog.dart';
import 'anatomy_backup_persistence.dart';

const _views = {'front', 'back', 'left', 'right', 'top', 'reset'};

/// A bookmark contains only validated catalog identity and a named camera view.
/// It never persists arbitrary transforms or claims calibrated physical units.
class AnatomyAtlasBookmark {
  const AnatomyAtlasBookmark({
    required this.reference,
    required this.structureId,
    required this.view,
  });
  final String reference, structureId, view;
  String get id => jsonEncode([reference, structureId, view]);
  Map<String, dynamic> toJson() => {
        'reference': reference,
        'structureId': structureId,
        'view': view,
      };
}

/// Immutable owner: construct a fresh store when learner generation changes.
/// Pass captureLearnerGuard(), plus screen lifetime, as stillCurrent.
class AnatomyAtlasBookmarkStore extends ChangeNotifier {
  AnatomyAtlasBookmarkStore(
    this.ownerId,
    this.catalog, {
    bool Function()? stillCurrent,
    Future<String?> Function(String)? read,
    Future<bool> Function(String, String)? write,
    AnatomyBackupPersistence? persistence,
  })  : _stillCurrent = stillCurrent ?? (() => true),
        _read = read ?? _readPreferences,
        _write = write ?? _writePreferences,
        _persistence = persistence ??
            (read == null && write == null
                ? AnatomyBackupPersistence.instance
                : null) {
    if (ownerId.trim().isEmpty ||
        ownerId.length > 256 ||
        RegExp(r'[\x00-\x1f\x7f]').hasMatch(ownerId)) {
      throw ArgumentError.value(ownerId, 'ownerId');
    }
    _persistence?.register(this,
        owner: () => isCurrent ? ownerId : null,
        flush: () async {
          await (_queues[_key] ?? Future<void>.value());
        },
        restored: (parts) {
          if (!isCurrent) return;
          _bookmarks = _decode(parts['bookmarks']);
          _loaded = true;
          notifyListeners();
        },
        transactionChanged: () {
          if (!_disposed) notifyListeners();
        });
  }

  static const maxBookmarks = 100;
  static const maxPerReference = 32;
  static const maxBytes = 64 * 1024;
  static final _queues = <String, Future<void>>{};
  final String ownerId;
  final AnatomyAtlasCatalog catalog;
  final bool Function() _stillCurrent;
  final Future<String?> Function(String) _read;
  final Future<bool> Function(String, String) _write;
  final AnatomyBackupPersistence? _persistence;
  List<AnatomyAtlasBookmark> _bookmarks = [];
  bool _loaded = false, _disposed = false;
  bool get loaded =>
      _loaded && isCurrent && !(_persistence?.isRestoring(ownerId) ?? false);
  bool get isCurrent => !_disposed && _stillCurrent();
  List<AnatomyAtlasBookmark> get bookmarks =>
      isCurrent ? List.unmodifiable(_bookmarks) : const [];
  String get _key =>
      'norie.anatomy.bookmarks.v1.${Uri.encodeComponent(ownerId)}';

  static Future<String?> _readPreferences(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);
  static Future<bool> _writePreferences(String key, String value) async =>
      (await SharedPreferences.getInstance()).setString(key, value);

  Future<T> _serial<T>(Future<T> Function() action) {
    final future = (_queues[_key] ?? Future<void>.value())
        .catchError((Object _) {})
        .then((_) => action());
    final tail =
        future.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    _queues[_key] = tail;
    // Remove only our tail; a newer owner instance may already have queued work.
    unawaited(tail.then((_) {
      if (identical(_queues[_key], tail)) _queues.remove(_key);
    }));
    return future;
  }

  AnatomyAtlasBookmark _validate(
      String reference, String structureId, String view) {
    if (!_views.contains(view) ||
        !catalog.structures
            .any((s) => s.reference == reference && s.id == structureId)) {
      throw const FormatException(
          'Choose a valid structure, reference and named view.');
    }
    return AnatomyAtlasBookmark(
        reference: reference, structureId: structureId, view: view);
  }

  List<AnatomyAtlasBookmark> _decode(String? raw) {
    if (raw == null) return [];
    if (utf8.encode(raw).length > maxBytes) {
      throw const FormatException('Saved views exceed the local size limit.');
    }
    final value = jsonDecode(raw);
    if (value is! Map<String, dynamic> ||
        value['version'] != 1 ||
        value['owner'] != ownerId ||
        value['bookmarks'] is! List ||
        (value['bookmarks'] as List).length > maxBookmarks) {
      throw const FormatException(
          'Saved views are invalid. Existing data was preserved.');
    }
    final result = <AnatomyAtlasBookmark>[];
    final ids = <String>{};
    final counts = <String, int>{};
    for (final row in value['bookmarks'] as List) {
      if (row is! Map ||
          row.length != 3 ||
          row['reference'] is! String ||
          row['structureId'] is! String ||
          row['view'] is! String) {
        throw const FormatException('Saved view is invalid.');
      }
      final bookmark = _validate(row['reference'] as String,
          row['structureId'] as String, row['view'] as String);
      if (!ids.add(bookmark.id)) {
        throw const FormatException('Duplicate saved view.');
      }
      counts.update(bookmark.reference, (n) => n + 1, ifAbsent: () => 1);
      if (counts[bookmark.reference]! > maxPerReference) {
        throw const FormatException('Too many saved views for this reference.');
      }
      result.add(bookmark);
    }
    return result;
  }

  String _encode(List<AnatomyAtlasBookmark> bookmarks) => jsonEncode({
        'version': 1,
        'owner': ownerId,
        'bookmarks': bookmarks.map((b) => b.toJson()).toList(),
      });

  Future<void> load() => _serial(() async {
        if (!isCurrent) return;
        final raw = _persistence == null
            ? await _read(_key)
            : await _persistence.readPart(ownerId, 'bookmarks');
        if (!isCurrent) return;
        final restored = _decode(raw);
        if (!isCurrent) return;
        _bookmarks = restored;
        _loaded = true;
        notifyListeners();
      });

  Future<bool> save(
      {required String reference,
      required String structureId,
      required String view}) {
    final bookmark = _validate(reference, structureId, view);
    return _mutate((rows) {
      if (rows.any((b) => b.id == bookmark.id)) return;
      if (rows.length >= maxBookmarks ||
          rows.where((b) => b.reference == reference).length >=
              maxPerReference) {
        throw StateError(
            'Saved views are full. Delete a view before saving another.');
      }
      rows.add(bookmark);
    });
  }

  Future<bool> delete(AnatomyAtlasBookmark bookmark) =>
      _mutate((rows) => rows.removeWhere((b) => b.id == bookmark.id));

  /// Clears this owner's views only. Corrupt data can be explicitly reset.
  Future<bool> reset() => _mutate((rows) => rows.clear(), reset: true);

  Future<bool> _mutate(void Function(List<AnatomyAtlasBookmark>) edit,
      {bool reset = false}) {
    if (_persistence?.isRestoring(ownerId) ?? false) {
      return Future<bool>.error(
          StateError('Anatomy backup is being restored. Please wait.'));
    }
    final revision = _persistence?.revision(ownerId);
    return _serial(() async {
      if (!isCurrent) return false;
      final previousRaw = _persistence == null
          ? await _read(_key)
          : await _persistence.readPart(ownerId, 'bookmarks');
      if (!isCurrent) return false;
      final rows = reset ? <AnatomyAtlasBookmark>[] : _decode(previousRaw);
      edit(rows);
      final payload = _encode(rows);
      if (utf8.encode(payload).length > maxBytes) {
        throw StateError('Saved views exceed the local size limit.');
      }
      if (!isCurrent) return false;
      if (_persistence != null) {
        final saved = await _persistence.writePart(
            ownerId, 'bookmarks', payload,
            stillCurrent: () => isCurrent, expectedRevision: revision);
        if (!saved) return false;
      } else if (!await _write(_key, payload)) {
        throw StateError('Could not save views on this device. Please retry.');
      }
      if (!isCurrent) {
        // Account changes cannot cancel an in-flight platform write. Per-key
        // serialization keeps a newer store behind this compensation.
        if (_persistence == null &&
            !await _write(_key, previousRaw ?? _encode([]))) {
          throw StateError(
              'Could not restore views after the learner changed.');
        }
        return false;
      }
      _bookmarks = rows;
      _loaded = true;
      notifyListeners();
      return true;
    });
  }

  String exportJson() {
    if (!isCurrent) throw StateError('Learner changed. Reopen Explorer tools.');
    if (!_loaded) throw StateError('Load saved views before exporting.');
    return _encode(_bookmarks);
  }

  @override
  void dispose() {
    _disposed = true;
    _persistence?.unregister(this);
    super.dispose();
  }
}
