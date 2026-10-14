import 'package:flutter/material.dart';
import '../../../core/theme/norie_theme.dart';
import '../domain/norie_adaptive_learning.dart';

class NorieAdaptivePracticeCard extends StatelessWidget {
  const NorieAdaptivePracticeCard(
      {super.key,
      required this.recommendation,
      required this.accent,
      required this.onStart});
  final NorieAdaptiveRecommendation recommendation;
  final Color accent;
  final VoidCallback onStart;
  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(
                  switch (recommendation.band) {
                    NorieAdaptiveBand.guided => Icons.handyman_outlined,
                    NorieAdaptiveBand.standard => Icons.school_outlined,
                    NorieAdaptiveBand.stretch => Icons.rocket_launch_outlined,
                  },
                  color: accent),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(recommendation.title,
                      style: const TextStyle(fontWeight: FontWeight.w900))),
            ]),
            const SizedBox(height: 8),
            Text(recommendation.reason,
                style: const TextStyle(
                    color: NorieColors.textSecondary, height: 1.4)),
            const SizedBox(height: 10),
            OutlinedButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Start adaptive practice')),
          ])));
}
