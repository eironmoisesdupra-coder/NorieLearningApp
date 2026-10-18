import 'package:flutter/material.dart';
import '../domain/anatomy_atlas_catalog.dart';
import '../domain/anatomy_models.dart';

/// Source metadata only: names are never used to infer a medical description.
class AnatomyAtlasDetails extends StatelessWidget {
  const AnatomyAtlasDetails(
      {super.key,
      required this.structure,
      required this.reference,
      required this.advanced});
  final AtlasStructure structure;
  final AtlasReference reference;
  final bool advanced;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(structure.name, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Text('Reference: ${reference.label}'),
        Text(
            'Systems: ${structure.systems.map((id) => AnatomyCatalog.systems.where((s) => s.id.name == id).firstOrNull?.label ?? 'Unreviewed system').join(', ')}'),
        if (advanced) ...[
          const SizedBox(height: 12),
          SelectableText('Model part ID: ${structure.id}'),
          SelectableText(
              'Source ID: ${structure.ontology.isEmpty ? 'Not supplied' : structure.ontology}'),
          SelectableText('Source: ${structure.source}'),
        ],
        const SizedBox(height: 16),
        const Text(
            'Educational description unavailable. New location and function descriptions need source checks and anatomy editorial review.'),
        const SizedBox(height: 12),
        const Text(
            'Each selectable part belongs to the source reference shown above. Different references use separate coordinate frames.'),
      ]);
}
