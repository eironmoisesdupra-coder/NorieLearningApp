import 'dart:convert';
import 'dart:io';

const storeGateIds = <String>[
  'production_android_signing',
  'production_windows_signing',
  'physical_device_matrix',
  'preview_to_production_migration',
  'classroom_real_wifi',
  'privacy_policy_published',
  'account_deletion_flow',
  'content_rating_completed',
  'store_graphics_ready',
  'support_contact_ready',
  'package_size_reviewed',
  'accessibility_regression',
  'data_safety_privacy_declarations',
];

Never _invalid(String message) => throw FormatException(message);

Map<String, dynamic> _object(dynamic value, Set<String> keys, String label) {
  if (value is! Map<String, dynamic> ||
      value.length != keys.length ||
      !value.keys.toSet().containsAll(keys)) {
    _invalid('$label requires exactly: ${keys.join(', ')}');
  }
  return value;
}

String _text(dynamic value, String label) {
  if (value is! String || value.trim().isEmpty || value.length > 65536) {
    _invalid('$label must be bounded nonempty text');
  }
  return value;
}

/// Validates declarations and evidence bindings, never certifies their truth.
/// Pending external gates are valid schema and remain explicit blockers.
Map<String, dynamic> validateStoreReadiness(File manifest) {
  if (manifest.lengthSync() > 2 * 1024 * 1024) {
    _invalid('Manifest exceeds 2 MiB');
  }
  final raw = _object(
      jsonDecode(manifest.readAsStringSync()),
      {
        'format',
        'version',
        'source_revision',
        'app_version',
        'artifact_sha256',
        'gates',
      },
      'Manifest');
  if (raw['format'] != 'norie-store-readiness' ||
      raw['version'] is! int ||
      raw['version'] != 1) {
    _invalid('Unsupported store-readiness format/version');
  }
  final revision = raw['source_revision'];
  final version = raw['app_version'];
  if (revision is! String ||
      (revision.isNotEmpty && !RegExp(r'^[0-9a-f]{40}$').hasMatch(revision)) ||
      version is! String ||
      (version.isNotEmpty &&
          !RegExp(r'^\d+\.\d+\.\d+\+\d+$').hasMatch(version))) {
    _invalid(
        'Expected exact source revision and version+build, or empty pending values');
  }
  final artifacts = _object(
      raw['artifact_sha256'], {'android', 'windows'}, 'Artifact digests');
  for (final digest in artifacts.values) {
    if (digest is! String ||
        (digest.isNotEmpty && !RegExp(r'^[0-9a-f]{64}$').hasMatch(digest))) {
      _invalid('Expected SHA256 artifact digests or empty pending values');
    }
  }
  final gates = raw['gates'];
  if (gates is! List || gates.length != storeGateIds.length) {
    _invalid('Exact required store gate set expected');
  }
  final seen = <String>{};
  final blockers = <String>[];
  for (final value in gates) {
    final gate = _object(
        value, {'id', 'required', 'status', 'evidence', 'review'}, 'Gate');
    final id = gate['id'];
    if (id is! String || !storeGateIds.contains(id) || !seen.add(id)) {
      _invalid('Unknown or duplicate gate ID: $id');
    }
    if (gate['required'] != true ||
        !const ['not_tested', 'blocked', 'fail', 'pass']
            .contains(gate['status'])) {
      _invalid('$id must be required with a supported status');
    }
    if (gate['status'] != 'pass') {
      if (gate['evidence'] != null || gate['review'] != null) {
        _invalid(
            '$id: pending/failing gates must have null evidence/review; keep working notes separately');
      }
      blockers.add(id);
      continue;
    }
    if (revision.isEmpty ||
        version.isEmpty ||
        artifacts.values.any((v) => v == '')) {
      _invalid(
          '$id pass requires source, version and both signed artifact digests');
    }
    final relative = _text(gate['evidence'], '$id evidence');
    if (relative.contains('\\') ||
        relative.startsWith('/') ||
        relative.contains(':') ||
        relative.split('/').any((v) => v == '..' || v == '.' || v.isEmpty)) {
      _invalid(
          '$id evidence must use a relative path inside the manifest directory');
    }
    final evidence =
        File('${manifest.parent.path}${Platform.pathSeparator}$relative');
    final parent = manifest.parent.resolveSymbolicLinksSync();
    if (!evidence.existsSync() ||
        evidence.lengthSync() > 65536 ||
        !evidence
            .resolveSymbolicLinksSync()
            .startsWith('$parent${Platform.pathSeparator}') ||
        evidence.resolveSymbolicLinksSync() ==
            manifest.resolveSymbolicLinksSync()) {
      _invalid(
          '$id requires separate evidence within the manifest directory, at most 64 KiB');
    }
    final text = _text(evidence.readAsStringSync(), '$id evidence content');
    final review = _object(
        gate['review'],
        {
          'origin',
          'reviewer',
          'reviewed_at',
          'decision',
          'gate_id',
          'source_revision',
          'app_version',
          'artifact_sha256',
          'evidence_path',
          'evidence_text',
        },
        '$id review');
    _text(review['reviewer'], '$id reviewer');
    final dateText = _text(review['reviewed_at'], '$id reviewed_at');
    final date = DateTime.tryParse(dateText);
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$').hasMatch(dateText) ||
        date == null ||
        date.toIso8601String() != dateText.replaceFirst('Z', '.000Z') ||
        date.isAfter(DateTime.now().toUtc())) {
      _invalid('$id requires a real nonfuture UTC review timestamp');
    }
    final reviewedArtifacts = _object(review['artifact_sha256'],
        {'android', 'windows'}, '$id reviewed artifacts');
    if (review['origin'] != 'human' ||
        review['decision'] != 'pass' ||
        review['gate_id'] != id ||
        review['source_revision'] != revision ||
        review['app_version'] != version ||
        review['evidence_path'] != relative ||
        review['evidence_text'] != text ||
        artifacts.keys.any((k) =>
            reviewedArtifacts[k] != artifacts[k] ||
            !text.contains(artifacts[k] as String))) {
      _invalid(
          '$id human review must bind gate, source, build, signed digests and exact evidence text');
    }
  }
  return {
    'schema_valid': true,
    'ready': blockers.isEmpty,
    'source_revision': revision,
    'app_version': version,
    'artifact_sha256': artifacts,
    'blockers': blockers,
    'errors': <String>[],
    'notice':
        'Structural validation only. Human claims and store approval require independent review.',
  };
}
