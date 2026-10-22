import 'package:flutter/material.dart';

/// A static, qualitative comparison; mission state remains with the caller.
class DiscoveryExperiment extends StatelessWidget {
  const DiscoveryExperiment({
    required this.warmTrial,
    required this.coolTrial,
    required this.onRunTrial,
    this.enabled = true,
    super.key,
  });

  final bool warmTrial;
  final bool coolTrial;
  final ValueChanged<bool> onRunTrial;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Widget dish(bool warm) => _TrialDish(
          warm: warm,
          hasRun: warm ? warmTrial : coolTrial,
          onRun: enabled && !(warm ? warmTrial : coolTrial)
              ? () => onRunTrial(warm)
              : null,
        );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          key: const ValueKey('discovery-experiment-content'),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('A fair comparison', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              const Text(
                'Conceptual illustration: not calibrated. These drawings '
                'show a pattern, not a numerical lab measurement.',
              ),
              const SizedBox(height: 16),
              Text(
                'Only temperature changes.',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Keep the same starting water, exposure to air, exposed '
                'surface area, duration, airflow and humidity. Both dishes '
                'are open to the air.',
              ),
              const SizedBox(height: 8),
              const Text(
                'Run each trial to see the water level after the same '
                'amount of time. Compare the two observations.',
              ),
              const SizedBox(height: 20),
              LayoutBuilder(builder: (context, constraints) {
                // Stack before enlarged text would crowd the dish labels.
                final fitsSideBySide = constraints.maxWidth /
                        MediaQuery.textScalerOf(context).scale(1) >=
                    560;
                if (fitsSideBySide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: dish(true)),
                      const SizedBox(width: 16),
                      Expanded(child: dish(false)),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    dish(true),
                    const SizedBox(height: 16),
                    dish(false),
                  ],
                );
              }),
              if (warmTrial && coolTrial) ...[
                const SizedBox(height: 20),
                Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'What does the comparison show?',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Under typical otherwise equal conditions, '
                          'warmer water evaporates faster. The warmer dish '
                          'lost more liquid water during the same time.',
                          style: TextStyle(color: scheme.onPrimaryContainer),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Liquid water changes into invisible water vapor '
                          'and mixes with the surrounding air. The water '
                          'is not destroyed.',
                          style: TextStyle(color: scheme.onPrimaryContainer),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Why did we keep the other conditions the same?',
                          style: TextStyle(color: scheme.onPrimaryContainer),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TrialDish extends StatelessWidget {
  const _TrialDish({
    required this.warm,
    required this.hasRun,
    required this.onRun,
  });

  final bool warm;
  final bool hasRun;
  final VoidCallback? onRun;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = warm ? 'Warm' : 'Cool';
    final observation = !hasRun
        ? 'Same starting water level'
        : warm
            ? 'More water evaporated'
            : 'Less water evaporated';
    final waterHeight = !hasRun
        ? 58.0
        : warm
            ? 22.0
            : 43.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$name dish', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(warm ? 'Warmer location' : 'Cooler location'),
          const SizedBox(height: 16),
          Semantics(
            key: ValueKey(warm ? 'warm-dish' : 'cool-dish'),
            image: true,
            label: hasRun
                ? '$name dish: $observation after the same time.'
                : '$name dish: same starting water level. Trial not run.',
            child: ExcludeSemantics(
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.onSurface, width: 2),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 8,
                      right: 8,
                      bottom: 6,
                      child: Container(
                        key: ValueKey(warm ? 'warm-water' : 'cool-water'),
                        height: waterHeight,
                        decoration: BoxDecoration(
                          color: scheme.secondary,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      right: 8,
                      bottom: 64,
                      child: Container(height: 2, color: scheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Line = starting level',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Semantics(
            liveRegion: hasRun,
            child: Text(observation, style: theme.textTheme.titleSmall),
          ),
          if (hasRun) ...[
            const SizedBox(height: 4),
            const Text('Observed after the same time'),
          ],
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRun,
            style: FilledButton.styleFrom(
              minimumSize: const Size(48, 48),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            child: Text(
              warm ? 'Run warm trial' : 'Run cool trial',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
