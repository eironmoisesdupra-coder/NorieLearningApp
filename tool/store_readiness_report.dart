import 'dart:convert';
import 'dart:io';

String _normalized(String path) {
  final normalized = File(path).absolute.uri.normalizePath().toFilePath();
  return Platform.isWindows ? normalized.toLowerCase() : normalized;
}

String _canonical(File file) {
  if (file.existsSync()) {
    return _normalized(file.resolveSymbolicLinksSync());
  }
  // Resolve a linked parent even when the final evidence/output does not exist.
  if (file.parent.existsSync()) {
    return _normalized('${file.parent.resolveSymbolicLinksSync()}'
        '${Platform.pathSeparator}${file.uri.pathSegments.last}');
  }
  return _normalized(file.path);
}

/// Protects inputs independently of whether their readiness schema passed.
/// Existing-file identity also catches hard links, beyond normalized paths.
void protectStoreReportInputs(File manifest, File output) {
  final protected = <File>[manifest];
  if (manifest.existsSync()) {
    if (manifest.lengthSync() > 2 * 1024 * 1024) {
      throw const FileSystemException(
          'Cannot safely inspect oversized manifest for report input aliases');
    }
    dynamic raw;
    try {
      raw = jsonDecode(manifest.readAsStringSync());
    } on FormatException {
      // Malformed JSON cannot supply parseable evidence references. Still
      // protect the manifest, while allowing a separate invalid-schema report.
    }
    if (raw is Map && raw['gates'] is List) {
      void addReference(dynamic path) {
        if (path is String && path.isNotEmpty) {
          final reference = File(path);
          protected.add(reference.isAbsolute
              ? reference
              : File('${manifest.parent.path}${Platform.pathSeparator}$path'));
        }
      }

      for (final gate in raw['gates'] as List) {
        if (gate is Map) {
          addReference(gate['evidence']);
          if (gate['review'] is Map) {
            addReference((gate['review'] as Map)['evidence_path']);
          }
        }
      }
    }
  }
  for (final input in protected) {
    if (_canonical(output) == _canonical(input) ||
        (output.existsSync() &&
            input.existsSync() &&
            FileSystemEntity.identicalSync(output.path, input.path))) {
      throw const FileSystemException(
          'Report path aliases manifest or referenced evidence');
    }
  }
}
