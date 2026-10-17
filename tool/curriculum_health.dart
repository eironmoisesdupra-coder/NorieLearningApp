import 'dart:convert';
import 'dart:io';
import 'package:norie_learning/features/content/quality/published_curriculum_quality.dart';

/// dart run tool/curriculum_health.dart [--json] [--output path]
/// Errors fail CI (exit 1); editorial warnings remain visible without blocking.
void main(List<String> args) {
  String? output;
  var json = false;
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--json') {
      json = true;
    } else if (args[i] == '--output' && i + 1 < args.length) {
      output = args[++i];
    } else {
      stderr.writeln(
          'Usage: dart run tool/curriculum_health.dart [--json] [--output path]');
      exitCode = 64;
      return;
    }
  }
  final report =
      scanPublishedCurriculum(assetExists: (path) => File(path).existsSync());
  final rendered = json
      ? const JsonEncoder.withIndent('  ').convert(report.toJson())
      : [
          'Curriculum: ${report.topicCount} topics, ${report.errors.length} errors, ${report.warnings.length} editorial warnings',
          for (final issue in report.errors)
            'ERROR ${issue.code} ${issue.location}: ${issue.message}',
          for (final issue in report.warnings)
            'WARNING ${issue.code} ${issue.location}: ${issue.message}',
        ].join('\n');
  if (output != null) {
    final file = File(output);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync('$rendered\n');
  }
  stdout.writeln(rendered);
  exitCode = report.errors.isEmpty ? 0 : 1;
}
