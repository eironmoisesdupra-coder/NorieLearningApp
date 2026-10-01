import 'dart:convert';
import 'package:flutter/services.dart';

class AtlasStructure {
  AtlasStructure.fromJson(Map<String, dynamic> value)
      : id = value['id'] as String,
        name = value['name'] as String,
        reference = value['reference'] as String,
        systems = Set<String>.from(value['systems'] as List),
        asset = value['asset'] as String,
        source = value['source'] as String,
        ontology = value['ontology'] as String? ?? '';
  final String id, name, reference, asset, source, ontology;
  final Set<String> systems;
}

class AtlasReference {
  AtlasReference.fromJson(Map<String, dynamic> value)
      : id = value['id'] as String,
        label = value['label'] as String,
        description = value['description'] as String;
  final String id, label, description;
}

class AnatomyAtlasCatalog {
  AnatomyAtlasCatalog._(this.references, this.structures);
  final List<AtlasReference> references;
  final List<AtlasStructure> structures;
  static Future<AnatomyAtlasCatalog>? _cached;
  static Future<AnatomyAtlasCatalog> load() => _cached ??= _load();
  static Future<AnatomyAtlasCatalog> _load() async {
    try {
      return AnatomyAtlasCatalog.fromJson(jsonDecode(
        await rootBundle.loadString('assets/anatomy/atlas-catalog.json'),
      ) as Map<String, dynamic>);
    } catch (_) {
      _cached = null;
      rethrow;
    }
  }

  factory AnatomyAtlasCatalog.fromJson(Map<String, dynamic> value) {
    if (value['schemaVersion'] != 1) {
      throw const FormatException('Unsupported atlas schema');
    }
    final references = (value['references'] as List)
        .map((v) => AtlasReference.fromJson(v as Map<String, dynamic>))
        .toList();
    final structures = (value['structures'] as List)
        .map((v) => AtlasStructure.fromJson(v as Map<String, dynamic>))
        .toList();
    final ids = <String>{};
    for (final structure in structures) {
      if (!ids.add(structure.id)) {
        throw const FormatException('Duplicate atlas structure ID');
      }
      if (!references.any((r) => r.id == structure.reference) ||
          structure.systems.isEmpty) {
        throw const FormatException(
            'Invalid atlas structure reference or systems');
      }
    }
    return AnatomyAtlasCatalog._(
        List.unmodifiable(references), List.unmodifiable(structures));
  }

  List<AtlasStructure> search(
      String reference, Set<String> systems, String query) {
    final term = query.trim().toLowerCase();
    return structures
        .where((s) =>
            s.reference == reference &&
            s.systems.intersection(systems).isNotEmpty &&
            (term.isEmpty ||
                s.name.toLowerCase().contains(term) ||
                s.ontology.toLowerCase().contains(term)))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }
}
