import 'dart:convert';
import 'dart:io';

import 'store_readiness_report.dart';
import 'store_readiness_schema.dart';

void main(List<String> args) {
  String? input;
  String? reportPath;
  var schemaOnly = false;
  var explicitReady = false;
  var usageValid = true;
  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--check-schema':
        schemaOnly = true;
      case '--require-ready':
        explicitReady = true;
      case '--json-report':
        if (reportPath != null ||
            i + 1 >= args.length ||
            args[i + 1].startsWith('--')) {
          usageValid = false;
        } else {
          reportPath = args[++i];
        }
      default:
        if (args[i].startsWith('--') || input != null) {
          usageValid = false;
        } else {
          input = args[i];
        }
    }
  }
  Map<String, dynamic> report;
  try {
    if (!usageValid || input == null || (schemaOnly && explicitReady)) {
      throw const FormatException(
          'Usage: dart tool/store_readiness.dart <manifest.json> [--check-schema | --require-ready] [--json-report <output.json>]');
    }
    report = validateStoreReadiness(File(input));
    exitCode = schemaOnly || report['ready'] == true ? 0 : 1;
  } on Object catch (error) {
    report = {
      'schema_valid': false,
      'ready': false,
      'blockers': <String>[],
      'errors': [error.toString()],
    };
    exitCode = 2;
  }
  if (reportPath != null) {
    try {
      final output = File(reportPath);
      if (input != null) {
        protectStoreReportInputs(File(input), output);
      }
      output.writeAsStringSync(
          '${const JsonEncoder.withIndent('  ').convert(report)}\n');
    } on Object catch (error) {
      stderr.writeln('Cannot write JSON report: $error');
      report['ready'] = false;
      (report['errors'] as List<String>)
          .add('Cannot write JSON report: $error');
      exitCode = 2;
    }
  }
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(report));
}
