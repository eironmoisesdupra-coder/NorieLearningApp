import 'dart:convert';

/// Portable accidental-corruption/version fingerprint, not authentication.
String classroomChecksum(String text) {
  var hash = 0x811c9dc5;
  for (final b in utf8.encode(text)) {
    hash ^= b;
    final low = hash & 0xffff, high = (hash >> 16) & 0xffff;
    hash =
        ((low * 0x0193) + (((high * 0x0193 + low * 0x0100) & 0xffff) << 16)) &
            0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}

String classroomCanonical(Object? v) {
  Object? normalize(Object? x) {
    if (x is Map) {
      final keys = x.keys.cast<String>().toList()..sort();
      return {for (final k in keys) k: normalize(x[k])};
    }
    if (x is List) return x.map(normalize).toList();
    return x;
  }

  return jsonEncode(normalize(v));
}
