import 'anatomy_hint_record.dart';

const anatomyHintSystems = {
  'skeletal',
  'articular',
  'muscular',
  'cardiovascular',
  'arterial',
  'venous',
  'nervous',
  'lymphatic',
  'respiratory',
  'digestive',
  'urinary',
  'reproductive',
  'endocrine',
  'integumentary',
  'sensory',
};

class AnatomyHintGeometryPart {
  AnatomyHintGeometryPart(
      this.identity, this.canonicalName, Iterable<String> systems)
      : systems = Set.unmodifiable(systems);
  final AnatomyHintIdentity identity;
  final String canonicalName;
  final Set<String> systems;
}

/// Inventory of the existing atlas catalog. This checks metadata consistency;
/// scripts/anatomy/catalog.py additionally verifies actual GLB checksums/nodes.
/// Neither check establishes the medical identity of geometry.
class AnatomyHintGeometryIndex {
  AnatomyHintGeometryIndex._(Map<String, AnatomyHintGeometryPart> parts)
      : parts = Map.unmodifiable(parts);
  final Map<String, AnatomyHintGeometryPart> parts;

  factory AnatomyHintGeometryIndex.fromCatalogJson(Map<String, dynamic> json) {
    try {
      if (json['schemaVersion'] != 1) {
        throw const FormatException('Unsupported atlas schema');
      }
      final references = <String>{};
      for (final ref in json['references'] as List) {
        if (ref['id'] is! String || !references.add(ref['id'] as String)) {
          throw const FormatException('Invalid or duplicate reference');
        }
      }
      final assets = <String, String>{};
      final assetFiles = <String>{};
      for (final asset in json['assets'] as List) {
        final id = asset['id'] as String;
        final hash = asset['sha256'] as String;
        if (id.isEmpty ||
            assets.containsKey(id) ||
            !assetFiles.add(asset['file'] as String) ||
            !RegExp(r'^[a-zA-Z0-9_-]+\.glb$')
                .hasMatch(asset['file'] as String) ||
            !RegExp(r'^[0-9a-f]{64}$').hasMatch(hash)) {
          throw const FormatException('Invalid or duplicate model asset');
        }
        assets[id] = hash;
      }
      final parts = <String, AnatomyHintGeometryPart>{};
      final meshOwners = <String>{};
      for (final part in json['structures'] as List) {
        final id = part['id'] as String;
        final reference = part['reference'] as String;
        final assetId = part['asset'] as String;
        final name = part['name'] as String;
        final meshes = List<String>.from(part['meshes'] as List);
        final systems = Set<String>.from(part['systems'] as List);
        if (id.isEmpty ||
            parts.containsKey(id) ||
            name.trim().isEmpty ||
            !references.contains(reference) ||
            !assets.containsKey(assetId) ||
            systems.isEmpty ||
            !anatomyHintSystems.containsAll(systems) ||
            meshes.isEmpty ||
            meshes.any((m) => m.trim().isEmpty) ||
            meshes.toSet().length != meshes.length) {
          throw const FormatException('Invalid or duplicate part mapping');
        }
        for (final mesh in meshes) {
          // A GLB node cannot belong to two selectable parts, even across scenes.
          if (!meshOwners.add('$assetId/$mesh')) {
            throw const FormatException('Shared selectable mesh');
          }
        }
        parts[id] = AnatomyHintGeometryPart(
          AnatomyHintIdentity(
              structureId: id,
              reference: reference,
              assetId: assetId,
              assetSha256: assets[assetId]!,
              meshIds: meshes),
          name,
          systems,
        );
      }
      return AnatomyHintGeometryIndex._(parts);
    } on Object catch (error) {
      throw FormatException('Invalid anatomy hint geometry inventory: $error');
    }
  }
}
