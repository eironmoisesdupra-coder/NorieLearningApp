import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import 'chemistry_screen.dart';

class ScienceScreen extends StatelessWidget {
  const ScienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Science'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF064E3B),
                        Color(0xFF0F766E),
                        Color(0xFF164E63),
                      ],
                    ),
                    border: Border.all(
                      color: NorieColors.green.withValues(alpha: .7),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SCIENCE PATH',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.5,
                                color: Color(0xFFB7F7E3),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Understand the world from atoms to ecosystems.',
                              style: TextStyle(
                                fontSize: 25,
                                height: 1.15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Choose a field and progress through lessons, quizzes, and interactive challenges.',
                              style: TextStyle(
                                color: Color(0xFFD6FFF2),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        Icons.science_rounded,
                        size: 70,
                        color: Color(0xFF9FFFE0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Fields',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                _FieldCard(
                  title: 'Chemistry',
                  subtitle: 'Matter, atoms, reactions, equilibrium, and more',
                  icon: Icons.hub_outlined,
                  color: NorieColors.violet,
                  progress: .72,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ChemistryScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const _FieldCard(
                  title: 'Biology',
                  subtitle: 'Cells, genetics, organisms, and body systems',
                  icon: Icons.biotech_rounded,
                  color: NorieColors.green,
                  progress: .31,
                ),
                const SizedBox(height: 12),
                const _FieldCard(
                  title: 'Physics',
                  subtitle: 'Motion, forces, energy, waves, and electricity',
                  icon: Icons.bolt_rounded,
                  color: NorieColors.orange,
                  progress: .18,
                ),
                const SizedBox(height: 12),
                const _FieldCard(
                  title: 'Earth Science',
                  subtitle: 'Geology, climate, oceans, and space',
                  icon: Icons.public_rounded,
                  color: NorieColors.cyan,
                  progress: .08,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.progress,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NorieColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: .45)),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 29),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: NorieColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(99),
                      color: color,
                      backgroundColor: color.withValues(alpha: .14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                onTap == null ? Icons.lock_outline_rounded : Icons.chevron_right,
                color: NorieColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
