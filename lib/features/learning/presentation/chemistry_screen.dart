import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import 'atomic_structure_lesson_screen.dart';

class ChemistryScreen extends StatelessWidget {
  const ChemistryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chemistry'),
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
                        Color(0xFF312E81),
                        Color(0xFF5B21B6),
                        Color(0xFF701A75),
                      ],
                    ),
                    border: Border.all(
                      color: NorieColors.violet.withValues(alpha: .7),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CHEMISTRY',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.5,
                          color: Color(0xFFE9D5FF),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Build understanding from atoms upward.',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: .28,
                              minHeight: 7,
                              borderRadius: BorderRadius.all(
                                Radius.circular(99),
                              ),
                              color: NorieColors.cyan,
                              backgroundColor: Color(0x445B5CE2),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            '28% path mastery',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFE9D5FF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Learning path',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                _TopicCard(
                  number: '01',
                  title: 'Atomic Structure',
                  subtitle: 'Protons, neutrons, electrons, and atomic number',
                  color: NorieColors.cyan,
                  status: 'Continue',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AtomicStructureLessonScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const _TopicCard(
                  number: '02',
                  title: 'Periodic Table',
                  subtitle: 'Elements, groups, periods, and trends',
                  color: NorieColors.green,
                  status: 'Locked',
                  locked: true,
                ),
                const SizedBox(height: 12),
                const _TopicCard(
                  number: '03',
                  title: 'Chemical Bonding',
                  subtitle: 'Ionic, covalent, metallic, and intermolecular forces',
                  color: NorieColors.orange,
                  status: 'Locked',
                  locked: true,
                ),
                const SizedBox(height: 12),
                const _TopicCard(
                  number: '04',
                  title: 'Chemical Reactions',
                  subtitle: 'Equations, reaction types, and stoichiometry',
                  color: NorieColors.magenta,
                  status: 'Locked',
                  locked: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.status,
    this.locked = false,
    this.onTap,
  });

  final String number;
  final String title;
  final String subtitle;
  final Color color;
  final String status;
  final bool locked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: locked ? .58 : 1,
      child: Material(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: .4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    number,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w900,
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
                      const SizedBox(height: 8),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          color: locked ? NorieColors.textSecondary : color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  locked ? Icons.lock_rounded : Icons.chevron_right_rounded,
                  color: NorieColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
