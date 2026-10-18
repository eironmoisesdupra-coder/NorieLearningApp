import 'anatomy_atlas_catalog.dart';
import 'anatomy_models.dart';

enum AtlasTeachingStatus { missing, review, approved, unreviewed }

/// Counts catalog metadata without inferring missing anatomy or human approval.
class AnatomyAtlasCoverage {
  AnatomyAtlasCoverage._({
    required this.totalCount,
    required this.selectedCount,
    required this.knownReference,
    required this.systemCounts,
    required this.sourceCounts,
    required this.ontologyMissingCount,
    required Set<String> knownIds,
  }) : _knownIds = Set.unmodifiable(knownIds);

  factory AnatomyAtlasCoverage.fromCatalog(
    AnatomyAtlasCatalog catalog,
    String reference,
  ) {
    final known = catalog.references.any((item) => item.id == reference);
    final parts = catalog.structures
        .where((part) => known && part.reference == reference)
        .toList();
    final systems = {
      for (final system in AnatomySystemId.values) system.name: 0,
    };
    final sources = <String, int>{};
    for (final part in parts) {
      for (final system in part.systems) {
        if (systems.containsKey(system)) {
          systems[system] = systems[system]! + 1;
        }
      }
      sources.update(part.source, (count) => count + 1, ifAbsent: () => 1);
    }
    return AnatomyAtlasCoverage._(
      totalCount: catalog.structures.length,
      selectedCount: parts.length,
      knownReference: known,
      systemCounts: Map.unmodifiable(systems),
      sourceCounts: Map.unmodifiable(sources),
      ontologyMissingCount: parts
          .where(
            (part) =>
                part.ontology.trim().isEmpty || part.ontology.trim() == '-',
          )
          .length,
      knownIds: catalog.structures.map((part) => part.id).toSet(),
    );
  }

  final int totalCount, selectedCount, ontologyMissingCount;
  final bool knownReference;
  final Map<String, int> systemCounts, sourceCounts;
  final Set<String> _knownIds;

  // No trusted per-structure teaching approval registry is bundled yet.
  // A source/catalog ID alone cannot confer a medical review status.
  AtlasTeachingStatus statusFor(String id) => _knownIds.contains(id)
      ? AtlasTeachingStatus.missing
      : AtlasTeachingStatus.unreviewed;

  static const limitations = <String>[
    'Counts are selectable model parts, including segments, groups and alternative references. They are not counts of unique whole organs.',
    'Neither body reference is an exhaustive anatomy atlas. The female reference has partial musculoskeletal coverage.',
    'Lymphatic references do not include the complete distributed lymph-vessel network.',
    'Sensory detail includes a combined labyrinth, not separately segmented cochlear microanatomy.',
    'Skin is modeled at body and organ scale, without complete follicle or sweat-gland microanatomy.',
    'Detail scenes keep separate source coordinates and are not superimposed on the body references.',
    'Per-structure teaching review metadata is missing. Automated/source checks do not establish medical accuracy or human subject-matter approval. Unknown anatomical IDs remain unreviewed.',
  ];
}
