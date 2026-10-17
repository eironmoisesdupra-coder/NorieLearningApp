import 'dart:convert';
import 'dart:io';
import 'device_certification_schema.dart';

void main(List<String> args) {
  if (args.length != 1) {
    stderr.writeln('Usage: dart tool/device_certification.dart <output.json>');
    exitCode = 2;
    return;
  }
  final report = {
    'format': 'norie-device-certification',
    'version': 2,
    'origin': 'not_tested',
    'operator': '',
    'source_revision': '',
    'app_version': '',
    'started_at': '',
    'completed_at': '',
    'devices': [
      for (final entry in deviceClasses.entries)
        {
          'class': entry.key,
          'platform': entry.value,
          'label': '',
          'os_version': '',
          'ram_gb': null,
          'screen': '',
          'physical': false,
          'artifact_sha256': '',
          'results': [
            for (final id in certificationScenarios)
              {
                'id': id,
                'status': 'not_tested',
                'elapsed_ms': null,
                'notes': '',
                'evidence': '',
              }
          ],
        }
    ],
  };
  final file = File(args.single);
  file.parent.createSync(recursive: true);
  // Never overwrite a report containing a human's measurements.
  file.createSync(exclusive: true);
  file.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(report)}\n');
  stdout.writeln('Uncertified template written: ${args.single}');
}
