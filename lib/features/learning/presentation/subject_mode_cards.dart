import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../domain/subject_adventures.dart';
import 'subject_adventure_hub.dart';

class SubjectModeCards extends StatelessWidget {
  const SubjectModeCards({
    required this.subject,
    required this.accent,
    required this.onClassicTap,
    super.key,
  });

  final String subject;
  final Color accent;
  final VoidCallback onClassicTap;

  @override
  Widget build(BuildContext context) {
    final adventure = SubjectAdventures.forSubject(subject);
    final classic = _ModeCard(
      title: 'Classic Lessons',
      description: 'Learn step by step. Choose your grade below.',
      status: 'Available offline',
      icon: Icons.menu_book_rounded,
      accent: accent,
      onTap: onClassicTap,
    );
    if (adventure == null) return classic;
    final adventureCard = _ModeCard(
      title: 'Adventure Mode',
      description: adventure.playable
          ? 'Investigate a Science mystery with Norie.'
          : 'Explore the planned ${adventure.title} idea.',
      status: adventure.playable ? '1 experimental pilot' : 'Planned preview',
      icon: Icons.explore_rounded,
      accent: NorieColors.cyan,
      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => SubjectAdventureHub(
          adventure: adventure,
          accent: accent,
        ),
      )),
    );
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 560 &&
          MediaQuery.textScalerOf(context).scale(1) <= 1.3) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: classic),
            const SizedBox(width: 12),
            Expanded(child: adventureCard),
          ],
        );
      }
      return Column(children: [
        classic,
        const SizedBox(height: 12),
        adventureCard,
      ]);
    });
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.description,
    required this.status,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title, description, status;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withValues(alpha: .45)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: accent, size: 30),
                const SizedBox(height: 10),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(description,
                    style: const TextStyle(
                        color: NorieColors.textSecondary, height: 1.4)),
                const SizedBox(height: 10),
                Text(status,
                    style:
                        TextStyle(color: accent, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      );
}
