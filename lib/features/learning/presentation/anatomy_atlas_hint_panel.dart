import 'package:flutter/material.dart';
import '../../../core/theme/norie_theme.dart';
import '../domain/anatomy_hint_library.dart';

/// Free progressive assistance. A result can carry content only after the domain
/// library's complete eligibility checks. This widget has no payment operation.
class AnatomyAtlasHintPanel extends StatefulWidget {
  const AnatomyAtlasHintPanel(
      {this.assistance,
      this.stillCurrent,
      this.showSourceAfterAnswer = false,
      this.generalGuidance = AnatomyHintLibrary.generalGuidance,
      super.key});
  final AnatomyHintResult? assistance;
  // Source titles/URLs can contain the answer. Reveal provenance after grading.
  final bool showSourceAfterAnswer;
  final bool Function()? stillCurrent;
  final String generalGuidance;
  @override
  State<AnatomyAtlasHintPanel> createState() => _AnatomyAtlasHintPanelState();
}

class _AnatomyAtlasHintPanelState extends State<AnatomyAtlasHintPanel> {
  bool _structureRequested = false;
  @override
  Widget build(BuildContext context) {
    final record = widget.assistance?.record;
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                    container: true,
                    header: true,
                    label: 'General guidance, free',
                    child: const ExcludeSemantics(
                        child: Text('General guidance · Free',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                const SizedBox(height: 8),
                Text(widget.generalGuidance),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 4, children: [
                  TextButton.icon(
                      icon: const Icon(Icons.lightbulb_outline),
                      label: const Text('Structure clue · Free'),
                      onPressed: () {
                        if (!mounted || widget.stillCurrent?.call() == false) {
                          return;
                        }
                        setState(() => _structureRequested = true);
                      }),
                  TextButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.lock_outline),
                      label: const Text('Detailed hint · Locked')),
                ]),
                if (_structureRequested)
                  Semantics(
                      container: true,
                      liveRegion: true,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(record?.structuralHint ??
                              'This structure’s clue is not ready. Try the free general guidance above.'))),
                if (_structureRequested &&
                    record != null &&
                    widget.showSourceAfterAnswer)
                  Text('Source: ${record.sourceUrl}\n${record.sourceLocation}',
                      style: const TextStyle(
                          fontSize: 12, color: NorieColors.textSecondary)),
                const Text(
                    'Detailed hints (5 Credits) are not enabled. No Credits are spent.',
                    style: TextStyle(
                        fontSize: 12, color: NorieColors.textSecondary)),
              ],
            )));
  }
}
