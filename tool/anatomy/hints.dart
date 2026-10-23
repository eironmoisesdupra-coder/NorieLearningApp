// Development-only authoring inventory. Never imported by the application.
import 'dart:convert';
import 'dart:io';
import 'package:norie_learning/features/learning/domain/anatomy_hint_library.dart';

void main(List<String> arguments) {
  try {
    if (arguments.isEmpty || arguments.first == '--help') {
      stdout.writeln(
          'hints.dart templates|report|validate --catalog PATH --output PATH '
          '[--structures ID,ID] [--records PATH]');
      return;
    }
    final command = arguments.first;
    if (!{'templates', 'report', 'validate'}.contains(command) ||
        arguments.length.isEven) {
      throw const FormatException('Use --help for authoring commands');
    }
    final options = <String, String>{};
    for (var i = 1; i < arguments.length; i += 2) {
      final option = arguments[i];
      if (!{'--catalog', '--output', '--structures', '--records'}
              .contains(option) ||
          options.containsKey(option)) {
        throw const FormatException('Invalid or repeated option');
      }
      options[option] = arguments[i + 1];
    }
    Map<String, dynamic> read(String path) =>
        jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
    final geometry = AnatomyHintGeometryIndex.fromCatalogJson(
        read(options['--catalog'] ?? 'assets/anatomy/atlas-catalog.json'));
    final output = options['--output'];
    if (output == null) throw const FormatException('--output is required');
    final recordsPath = options['--records'];
    if (command == 'templates' && recordsPath != null) {
      throw const FormatException('Templates never import authored content');
    }
    if (command != 'templates' && options.containsKey('--structures')) {
      throw const FormatException(
          'Structure selection applies only to templates');
    }
    final records = <AnatomyHintRecord>[];
    if (recordsPath != null) {
      final data = read(recordsPath);
      if (data['schemaVersion'] != 1) {
        throw const FormatException('Unsupported authoring schema');
      }
      records.addAll((data['records'] as List)
          .map((j) => AnatomyHintRecord.fromJson(j as Map<String, dynamic>)));
    } else if (command != 'templates') {
      throw const FormatException('--records is required');
    }
    if (command == 'templates') {
      final ids =
          options['--structures']?.split(',') ?? geometry.parts.keys.toList();
      if (ids.toSet().length != ids.length ||
          ids.any((id) => !geometry.parts.containsKey(id))) {
        throw const FormatException('Unknown or duplicate requested structure');
      }
      for (final id in ids) {
        final part = geometry.parts[id]!;
        // The catalog contains no reviewed laterality metadata. Do not guess it.
        final json = <String, dynamic>{
          'schemaVersion': 1,
          'revision': 1,
          'identity': part.identity.toJson(),
          'canonicalName': part.canonicalName,
          'synonyms': <String>[],
          'system': (part.systems.toList()..sort()).first,
          'laterality': 'unknown',
          'generalHint': '',
          'structuralHint': '',
          'detailedHint': '',
          'source': {'url': '', 'location': ''},
          'contentHash': '',
          'status': 'draft',
          'reviewerId': null,
          'approvedAt': null,
          'approvalHash': null,
        };
        json['contentHash'] = AnatomyHintRecord.fromJson(json).computedHash;
        records.add(AnatomyHintRecord.fromJson(json));
      }
      _write(output, {
        'schemaVersion': 1,
        'records': records.map((r) => r.toJson()).toList()
      });
      stdout
          .writeln('Exported ${records.length} empty drafts; zero approvals.');
      return;
    }
    // Deliberately no --approve command or JSON-supplied approval registry.
    final library = AnatomyHintLibrary(geometry: geometry, records: records);
    final reports = [
      for (final record in records)
        {
          'structureId': record.identity.structureId,
          'status': record.status.name,
          'contentHash': record.contentHash,
          'eligible': library.validate(record).eligible,
          'issues': library.validate(record).issues,
          'humanReviewRequired': library
              .validate(record)
              .humanReviewRequired
              .map((c) => c.name)
              .toList(),
        }
    ];
    final byId = <String, List<AnatomyHintRecord>>{};
    for (final record in records) {
      byId.putIfAbsent(record.identity.structureId, () => []).add(record);
    }
    final awaiting = [
      for (final part in geometry.parts.values)
        {
          'structureId': part.identity.structureId,
          'name': part.canonicalName,
          'identity': part.identity.toJson(),
          'systems': part.systems.toList()..sort(),
          'statuses': byId[part.identity.structureId]
                  ?.map((r) => r.status.name)
                  .toList() ??
              ['missing'],
        }
    ];
    final systems = <String, Object?>{};
    for (final system in anatomyHintSystems.toList()..sort()) {
      final parts = geometry.parts.values
          .where((p) => p.systems.contains(system))
          .toList();
      systems[system] = {
        'totalParts': parts.length,
        'missing': parts
            .where((p) => !byId.containsKey(p.identity.structureId))
            .length,
        'eligible':
            0, // No independent review authority exists in authoring tools.
        for (final status in AnatomyHintStatus.values)
          status.name: parts
              .where((p) =>
                  byId[p.identity.structureId]
                      ?.any((r) => r.status == status) ??
                  false)
              .length,
      };
    }
    final duplicates = byId.entries
        .where((e) => e.value.length > 1)
        .map((e) => e.key)
        .toList()
      ..sort();
    _write(output, {
      'schemaVersion': 1,
      'notice': 'Automated metadata inventory only. Not medical verification. '
          'GLB integrity and qualified source/geometry review remain required.',
      'eligibleRecords': reports.where((r) => r['eligible'] == true).length,
      'duplicateStructureIds': duplicates,
      'systems': systems,
      'records': reports,
      'awaitingReview': awaiting,
    });
    stdout
        .writeln('Reported ${records.length} records; zero trusted approvals.');
    if (command == 'validate' && reports.any((r) => r['eligible'] != true)) {
      exitCode = 1;
    }
  } on Object catch (error) {
    stderr.writeln('Authoring failed: $error');
    exitCode = 2;
  }
}

void _write(String path, Map<String, Object?> value) {
  final output = File(path);
  // Never overwrite a catalog or another input accidentally.
  if (output.existsSync()) {
    throw const FormatException('Choose a new output path');
  }
  output.parent.createSync(recursive: true);
  output.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(value)}\n');
}
