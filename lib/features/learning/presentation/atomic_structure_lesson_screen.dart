import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import 'atomic_structure_quiz_screen.dart';

class AtomicStructureLessonScreen extends StatelessWidget {
  const AtomicStructureLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atomic Structure'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
              children: [
                const Row(
                  children: [
                    _Badge(
                      text: 'Chemistry',
                      color: NorieColors.violet,
                    ),
                    const SizedBox(width: 8),
                    _Badge(
                      text: 'Lesson 1',
                      color: NorieColors.cyan,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Inside the atom',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Atoms are made of smaller particles. Understanding how those particles are arranged explains atomic number, charge, ions, isotopes, and much more.',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    height: 1.55,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
                const _ConceptCard(
                  title: 'Proton',
                  symbol: '+',
                  color: NorieColors.magenta,
                  points: const [
                    'Positive electric charge',
                    'Located in the nucleus',
                    'Number of protons determines the element',
                  ],
                ),
                const SizedBox(height: 12),
                const _ConceptCard(
                  title: 'Neutron',
                  symbol: '0',
                  color: NorieColors.cyan,
                  points: const [
                    'No electric charge',
                    'Located in the nucleus',
                    'Changes in neutron count create isotopes',
                  ],
                ),
                const SizedBox(height: 12),
                const _ConceptCard(
                  title: 'Electron',
                  symbol: '−',
                  color: NorieColors.green,
                  points: const [
                    'Negative electric charge',
                    'Occupies regions around the nucleus',
                    'Electron changes are involved in ion formation and bonding',
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF131A35),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: NorieColors.primary.withValues(alpha: .7),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KEY CONCEPT',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.4,
                          color: NorieColors.cyan,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Atomic number = number of protons',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'For a neutral atom, the number of electrons equals the number of protons.',
                        style: TextStyle(
                          color: NorieColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AtomicStructureQuizScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.quiz_rounded),
                  label: const Text('Start 5-question quiz'),
                  style: FilledButton.styleFrom(
                    backgroundColor: NorieColors.cyan,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _ConceptCard extends StatelessWidget {
  const _ConceptCard({
    required this.title,
    required this.symbol,
    required this.color,
    required this.points,
  });

  final String title;
  final String symbol;
  final Color color;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .16),
              shape: BoxShape.circle,
            ),
            child: Text(
              symbol,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                ...points.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      '• $point',
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
