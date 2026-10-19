import 'dart:convert';
import 'dart:math' as math;

import '../../features/learning/domain/anatomy_atlas_catalog.dart';
import '../../features/learning/domain/anatomy_guided_learning.dart';
import 'norie_progress_backup.dart';

/// Unverified local activity only; importing this evidence never grants rewards.
/// Kept separate from cloud/progression state until their transaction boundaries
/// can participate in one recoverable restore.
abstract final class AnatomyProgressBackup {
  static const catalogPath = 'assets/anatomy/atlas-catalog.json';
  static const maxBytes = 384 * 1024;
  static const _keys = {
    'version',
    'catalog',
    'catalogVersion',
    'contentVersion',
    'owner',
    'provenance',
    'exportedAt',
    'selected',
    'study',
    'bookmarks'
  };
  static const _studyKeys = {
    'id',
    'reference',
    'step',
    'done',
    'skipped',
    'identified',
    'studied',
    'answersRevealed',
    'assisted',
    'attempts',
    'correct'
  };
  static const _views = {'front', 'back', 'left', 'right', 'top', 'reset'};

  static String ownerKey(String? owner) =>
      owner == null ? 'guest' : 'account.$owner';

  static dynamic _parse(String text, int limit) {
    if (utf8.encode(text).length > limit) {
      throw const FormatException('Anatomy backup exceeds the size limit.');
    }
    // Bound nesting before decoding untrusted input (including ignored fields).
    var depth = 0;
    var quoted = false, escaped = false;
    for (final unit in text.codeUnits) {
      if (quoted) {
        if (escaped) {
          escaped = false;
          continue;
        }
        if (unit == 92) {
          escaped = true;
          continue;
        }
        if (unit == 34) quoted = false;
      } else if (unit == 34) {
        quoted = true;
      } else if (unit == 123 || unit == 91) {
        if (++depth > 8) {
          throw const FormatException('Anatomy backup is too deeply nested.');
        }
      } else if (unit == 125 || unit == 93) {
        depth--;
      }
    }
    return jsonDecode(text);
  }

  static Map<String, dynamic> decode(
    String text, {
    required AnatomyAtlasCatalog catalog,
    String? currentOwner,
  }) {
    final value =
        _parse(text, math.min(maxBytes, NorieProgressBackup.maxBytes));
    if (value is! Map<String, dynamic>) {
      throw const FormatException('Invalid Anatomy backup.');
    }
    validate(value, catalog: catalog, currentOwner: currentOwner);
    return value;
  }

  static String encode(
    Map<String, dynamic> value, {
    required AnatomyAtlasCatalog catalog,
    String? currentOwner,
  }) {
    validate(value, catalog: catalog, currentOwner: currentOwner);
    final text = jsonEncode(value);
    if (utf8.encode(text).length > maxBytes) {
      throw const FormatException('Anatomy backup exceeds the size limit.');
    }
    return text;
  }

  static void validate(
    Map<String, dynamic> value, {
    required AnatomyAtlasCatalog catalog,
    String? currentOwner,
  }) {
    if (value.length != _keys.length ||
        value.keys.any((k) => !_keys.contains(k)) ||
        value['version'] is! int ||
        value['version'] != 1 ||
        value['catalog'] != catalogPath ||
        value['catalogVersion'] is! int ||
        value['catalogVersion'] != 1 ||
        value['contentVersion'] is! int ||
        value['contentVersion'] != AnatomyGuidedModule.contentVersion ||
        value['provenance'] != 'local-learner-activity-unverified' ||
        value['exportedAt'] is! String ||
        DateTime.tryParse(value['exportedAt'] as String) == null) {
      throw const FormatException('Invalid or incompatible Anatomy backup.');
    }
    final owner = value['owner'];
    if (owner != currentOwner ||
        (owner != null &&
            (owner is! String ||
                owner.isEmpty ||
                owner.length > 256 ||
                RegExp(r'[\x00-\x1f\x7f]').hasMatch(owner)))) {
      throw const FormatException(
          'Open Anatomy backup with the same learner account or guest.');
    }
    final rows = value['study'], bookmarks = value['bookmarks'];
    if (rows is! List ||
        rows.length > 128 ||
        bookmarks is! List ||
        bookmarks.length > 100) {
      throw const FormatException('Invalid Anatomy entry count.');
    }
    final parts = {for (final part in catalog.structures) part.id: part};
    final ids = <String>{};
    for (final row in rows) {
      if (row is! Map<String, dynamic> ||
          row.length != _studyKeys.length ||
          row.keys.any((k) => !_studyKeys.contains(k)) ||
          parts[row['id']]?.reference != row['reference'] ||
          !ids.add(row['id']?.toString() ?? '') ||
          AnatomyStudyProgress.restore(row, parts.keys.toSet()) == null) {
        throw const FormatException('Invalid Anatomy study entry.');
      }
      for (final key in ['done', 'skipped']) {
        final steps = row[key] as List;
        if (steps.toSet().length != steps.length) {
          throw const FormatException('Duplicate Anatomy study step.');
        }
      }
    }
    final selected = value['selected'];
    if (selected != null && (selected is! String || !ids.contains(selected))) {
      throw const FormatException('Invalid selected Anatomy entry.');
    }
    final views = <String>{}, counts = <String, int>{};
    for (final row in bookmarks) {
      if (row is! Map<String, dynamic> ||
          row.length != 3 ||
          row.keys.any(
              (k) => !const {'reference', 'structureId', 'view'}.contains(k)) ||
          row['reference'] is! String ||
          row['structureId'] is! String ||
          !_views.contains(row['view']) ||
          !parts.containsKey(row['structureId']) ||
          parts[row['structureId']]!.reference != row['reference'] ||
          !views.add(jsonEncode(
              [row['reference'], row['structureId'], row['view']]))) {
        throw const FormatException('Invalid or duplicate Anatomy saved view.');
      }
      final reference = row['reference'] as String;
      counts.update(reference, (n) => n + 1, ifAbsent: () => 1);
      if (counts[reference]! > 32) {
        throw const FormatException(
            'Too many Anatomy views for one reference.');
      }
    }
    if (utf8.encode(jsonEncode(value)).length > maxBytes) {
      throw const FormatException('Anatomy backup exceeds the size limit.');
    }
  }

  static Map<String, dynamic> fromLocalParts(
    Map<String, String?> parts, {
    required AnatomyAtlasCatalog catalog,
    String? currentOwner,
  }) {
    final studyRaw = parts['study'], bookmarksRaw = parts['bookmarks'];
    final study = studyRaw == null
        ? <String, dynamic>{
            'version': 1,
            'contentVersion': 1,
            'selected': null,
            'entries': []
          }
        : _parse(studyRaw, 262144);
    final bookmarks = bookmarksRaw == null
        ? <String, dynamic>{
            'version': 1,
            'owner': ownerKey(currentOwner),
            'bookmarks': []
          }
        : _parse(bookmarksRaw, 65536);
    if (study is! Map<String, dynamic> ||
        study.length != 4 ||
        study.keys.any((key) => !const {
              'version',
              'contentVersion',
              'selected',
              'entries'
            }.contains(key)) ||
        study['version'] is! int ||
        study['version'] != 1 ||
        study['contentVersion'] is! int ||
        study['contentVersion'] != AnatomyGuidedModule.contentVersion ||
        study['entries'] is! List ||
        bookmarks is! Map<String, dynamic> ||
        bookmarks.length != 3 ||
        bookmarks['version'] is! int ||
        bookmarks['version'] != 1 ||
        bookmarks['owner'] != ownerKey(currentOwner) ||
        bookmarks['bookmarks'] is! List) {
      throw const FormatException(
          'Invalid saved Anatomy evidence. Existing data was preserved.');
    }
    final byId = {for (final part in catalog.structures) part.id: part};
    final rows = <Map<String, dynamic>>[];
    for (final raw in study['entries'] as List) {
      if (raw is! Map<String, dynamic> ||
          raw.keys
              .any((key) => !_studyKeys.contains(key) || key == 'reference')) {
        throw const FormatException('Invalid saved Anatomy study entry.');
      }
      final restored = AnatomyStudyProgress.restore(raw, byId.keys.toSet());
      if (restored == null) {
        throw const FormatException('Invalid saved Anatomy study entry.');
      }
      // Validate original step lists before restoration can collapse duplicates.
      for (final key in ['done', 'skipped']) {
        final list = raw[key] as List;
        if (list.toSet().length != list.length) {
          throw const FormatException('Duplicate saved Anatomy step.');
        }
      }
      rows.add({
        ...restored.toJson(),
        'reference': byId[restored.structureId]!.reference
      });
    }
    final result = <String, dynamic>{
      'version': 1,
      'catalog': catalogPath,
      'catalogVersion': 1,
      'contentVersion': AnatomyGuidedModule.contentVersion,
      'owner': currentOwner,
      'provenance': 'local-learner-activity-unverified',
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'selected': study['selected'],
      'study': rows,
      'bookmarks': bookmarks['bookmarks'],
    };
    validate(result, catalog: catalog, currentOwner: currentOwner);
    return result;
  }

  static Map<String, String?> toLocalParts(
    Map<String, dynamic> value, {
    required AnatomyAtlasCatalog catalog,
    String? currentOwner,
  }) {
    validate(value, catalog: catalog, currentOwner: currentOwner);
    return {
      'study': jsonEncode({
        'version': 1,
        'contentVersion': AnatomyGuidedModule.contentVersion,
        'selected': value['selected'],
        'entries': [
          for (final raw in value['study'] as List)
            Map<String, dynamic>.from(raw as Map)..remove('reference'),
        ]
      }),
      'bookmarks': jsonEncode({
        'version': 1,
        'owner': ownerKey(currentOwner),
        'bookmarks': value['bookmarks']
      }),
    };
  }

  static Map<String, dynamic> merge(
    Map<String, dynamic> local,
    Map<String, dynamic> incoming, {
    required AnatomyAtlasCatalog catalog,
    String? currentOwner,
  }) {
    validate(local, catalog: catalog, currentOwner: currentOwner);
    validate(incoming, catalog: catalog, currentOwner: currentOwner);
    final rows = <String, Map<String, dynamic>>{};
    for (final raw in [
      ...local['study'] as List,
      ...incoming['study'] as List
    ]) {
      final row = Map<String, dynamic>.from(raw as Map),
          id = raw['id'] as String;
      final previous = rows[id];
      if (previous == null) {
        rows[id] = row;
        continue;
      }
      for (final key in ['step', 'assisted', 'attempts', 'correct']) {
        row[key] = math.max(previous[key] as int, row[key] as int);
      }
      for (final key in ['identified', 'studied', 'answersRevealed']) {
        row[key] = previous[key] == true || row[key] == true;
      }
      final done = {...previous['done'] as List, ...row['done'] as List};
      row['done'] = done.toList()..sort();
      row['skipped'] = ({
        ...previous['skipped'] as List,
        ...row['skipped'] as List
      }..removeAll(done))
          .toList()
        ..sort();
      rows[id] = row;
    }
    final views = <String, dynamic>{};
    for (final raw in [
      ...local['bookmarks'] as List,
      ...incoming['bookmarks'] as List
    ]) {
      views[jsonEncode([raw['reference'], raw['structureId'], raw['view']])] =
          raw;
    }
    final result = <String, dynamic>{
      ...local,
      'selected': local['selected'] ?? incoming['selected'],
      'study': rows.values.toList(),
      'bookmarks': views.values.toList()
    };
    validate(result, catalog: catalog, currentOwner: currentOwner);
    return result;
  }
}
