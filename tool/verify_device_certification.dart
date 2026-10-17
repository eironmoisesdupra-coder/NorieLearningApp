import 'dart:convert';
import 'dart:io';
import 'device_certification_schema.dart';

Never invalid(String message) => throw FormatException(message);
String requiredText(Map<dynamic, dynamic> map, String key) {
  final value = map[key];
  if (value is! String || value.trim().isEmpty) {
    invalid('Missing $key');
  }
  return value;
}

void verifyCertification(List<String> args) {
  if (args.length != 5) {
    invalid(
        'Usage: dart tool/verify_device_certification.dart <report.json> <revision> <version+build> <android-sha256> <windows-sha256>');
  }
  if (Platform.environment['CI'] == 'true' ||
      Platform.environment['GITHUB_ACTIONS'] == 'true') {
    invalid(
        'CI cannot issue physical-device certification. Review human evidence outside CI.');
  }
  if (!RegExp(r'^[0-9a-f]{40}$').hasMatch(args[1]) ||
      !RegExp(r'^\d+\.\d+\.\d+\+\d+$').hasMatch(args[2]) ||
      !args.skip(3).every((s) => RegExp(r'^[0-9a-f]{64}$').hasMatch(s))) {
    invalid(
        'Expected exact source revision, build version and artifact digests');
  }
  final file = File(args[0]);
  final raw = jsonDecode(file.readAsStringSync());
  if (raw is! Map ||
      raw['format'] != 'norie-device-certification' ||
      raw['version'] != 2) {
    invalid('Unsupported report');
  }
  if (raw['origin'] != 'human_physical' ||
      raw['source_revision'] != args[1] ||
      raw['app_version'] != args[2]) {
    invalid('Human origin, source or version mismatch');
  }
  requiredText(raw, 'operator');
  final started = DateTime.parse(requiredText(raw, 'started_at'));
  final ended = DateTime.parse(requiredText(raw, 'completed_at'));
  if (!ended.isAfter(started) ||
      ended.isAfter(DateTime.now().toUtc().add(const Duration(minutes: 5)))) {
    invalid('Invalid observation times');
  }
  final devices = raw['devices'];
  if (devices is! List || devices.length != deviceClasses.length) {
    invalid('All five physical device classes required');
  }
  final seen = <String>{};
  for (final device in devices) {
    if (device is! Map) {
      invalid('Invalid device');
    }
    final type = requiredText(device, 'class');
    if (!deviceClasses.containsKey(type) ||
        !seen.add(type) ||
        deviceClasses[type] != device['platform'] ||
        device['physical'] != true) {
      invalid('Duplicate, unknown or nonphysical device');
    }
    for (final key in ['label', 'os_version', 'screen']) {
      requiredText(device, key);
    }
    if (device['ram_gb'] is! num || (device['ram_gb'] as num) <= 0) {
      invalid('Measured device RAM required');
    }
    if (device['artifact_sha256'] !=
        args[device['platform'] == 'android' ? 3 : 4]) {
      invalid('Device artifact digest mismatch');
    }
    final results = device['results'];
    if (results is! List || results.length != certificationScenarios.length) {
      invalid('Complete scenario set required');
    }
    final checks = <String>{};
    for (final result in results) {
      if (result is! Map) {
        invalid('Invalid scenario');
      }
      final id = requiredText(result, 'id');
      if (!certificationScenarios.contains(id) ||
          !checks.add(id) ||
          result['status'] != 'pass') {
        invalid('Required scenario missing or not passed');
      }
      requiredText(result, 'notes');
      if (result['elapsed_ms'] is! int || (result['elapsed_ms'] as int) <= 0) {
        invalid('Measured elapsed_ms required');
      }
      final relative = requiredText(result, 'evidence');
      final evidence =
          File('${file.parent.path}${Platform.pathSeparator}$relative');
      final parent = file.parent.resolveSymbolicLinksSync();
      if (!evidence.existsSync() ||
          evidence.lengthSync() == 0 ||
          !evidence
              .resolveSymbolicLinksSync()
              .startsWith('$parent${Platform.pathSeparator}')) {
        invalid('Nonempty evidence within report directory required');
      }
    }
  }
  if (seen.length != deviceClasses.length ||
      !seen.containsAll(deviceClasses.keys)) {
    invalid('Exact physical device matrix required');
  }
}

void main(List<String> args) {
  try {
    verifyCertification(args);
    stdout.writeln(
        'Report structure and build bindings accepted. Human review of the physical evidence is still required.');
  } on Object catch (error) {
    stderr.writeln('Certification rejected: $error');
    exitCode = 1;
  }
}
