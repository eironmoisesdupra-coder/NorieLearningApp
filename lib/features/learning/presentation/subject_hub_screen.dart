import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../../common/presentation/coming_soon_screen.dart';
import 'science_screen.dart';

class SubjectHubScreen extends StatelessWidget {
  const SubjectHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
              children: [
                const Text(
                  'Explore your subjects',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose a learning area, then narrow down into topics and mastery paths.',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                _SubjectTile(
                  title: 'Mathematics',
                  subtitle: 'Subject lessons in development',
                  icon: Icons.calculate_rounded,
                  color: NorieColors.primary,
                  progress: .68,
                  onTap: () => _openUpcoming(
                    context,
                    'Mathematics',
                    'The Mathematics learning path is the next major subject expansion.',
                    Icons.calculate_rounded,
                  ),
                ),
                const SizedBox(height: 13),
                _SubjectTile(
                  title: 'Science',
                  subtitle: 'Chemistry · Biology · Physics · Earth Science',
                  icon: Icons.science_rounded,
                  color: NorieColors.green,
                  progress: .72,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ScienceScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 13),
                _SubjectTile(
                  title: 'English',
                  subtitle: 'Subject lessons in development',
                  icon: Icons.menu_book_rounded,
                  color: NorieColors.orange,
                  progress: .45,
                  onTap: () => _openUpcoming(
                    context,
                    'English',
                    'The English proficiency path will include grammar, vocabulary, reading, and communication practice.',
                    Icons.menu_book_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _openUpcoming(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ComingSoonScreen(
          title: title,
          subtitle: subtitle,
          icon: icon,
        ),
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.progress,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NorieColors.surface,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: color.withValues(alpha: .45),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(icon, color: color, size: 30),
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
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: NorieColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(99),
                      color: color,
                      backgroundColor: color.withValues(alpha: .13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right_rounded,
                color: NorieColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
