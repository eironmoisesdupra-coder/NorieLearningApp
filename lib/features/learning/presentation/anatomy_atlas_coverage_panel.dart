import 'package:flutter/material.dart';

import '../domain/anatomy_atlas_catalog.dart';
import '../domain/anatomy_atlas_coverage.dart';
import '../domain/anatomy_models.dart';

/// Scrollable dialog/sheet content; the caller supplies navigation and dismissal.
class AnatomyAtlasCoveragePanel extends StatelessWidget {
  const AnatomyAtlasCoveragePanel({
    required this.catalog,
    required this.reference,
    super.key,
  });

  final AnatomyAtlasCatalog catalog;
  final String reference;

  @override
  Widget build(BuildContext context) {
    final coverage = AnatomyAtlasCoverage.fromCatalog(catalog, reference);
    final label = catalog.references
        .where((item) => item.id == reference)
        .firstOrNull
        ?.label;
    final theme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label ?? 'Unknown reference', style: theme.titleLarge),
          const SizedBox(height: 12),
          Text(
            '${coverage.selectedCount} selectable model parts in this reference',
          ),
          Text(
            '${coverage.totalCount} selectable model parts across all references',
          ),
          const SizedBox(height: 8),
          const Text(
            'A part can appear in more than one system. Zero means no catalog parts in this reference, not that the body lacks that system.',
          ),
          const SizedBox(height: 16),
          Text('Parts by system', style: theme.titleMedium),
          const SizedBox(height: 8),
          for (final system in AnatomyCatalog.systems)
            Semantics(
              label:
                  '${system.label}: ${coverage.systemCounts[system.id.name]} model parts',
              excludeSemantics: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(child: Text(system.label)),
                    const SizedBox(width: 12),
                    Text('${coverage.systemCounts[system.id.name]}'),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text('Source catalog records', style: theme.titleMedium),
          const SizedBox(height: 8),
          for (final source in coverage.sourceCounts.entries)
            Text('${source.key}: ${source.value} model parts'),
          Text(
            '${coverage.ontologyMissingCount} parts have no source ontology identifier supplied.',
          ),
          const SizedBox(height: 16),
          Text('Coverage boundaries', style: theme.titleMedium),
          const SizedBox(height: 8),
          for (final limitation in AnatomyAtlasCoverage.limitations)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(limitation),
            ),
        ],
      ),
    );
  }
}
