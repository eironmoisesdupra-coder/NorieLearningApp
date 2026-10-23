import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../../content/presentation/norie_grade_select_screen.dart';

/// Kept for older navigation entry points; uses the same current subject pages.
class SubjectHubScreen extends StatelessWidget {
  const SubjectHubScreen({super.key});

  static const _subjects = [
    ('Mathematics', Icons.calculate_rounded, NorieColors.primary),
    ('Science', Icons.science_rounded, NorieColors.green),
    ('English', Icons.menu_book_rounded, NorieColors.orange),
    ('Filipino', Icons.translate_rounded, NorieColors.violet),
    ('Araling Panlipunan', Icons.public_rounded, NorieColors.cyan),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Subjects')),
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                children: [
                  const Text('Explore your subjects',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose a subject for Classic Lessons and Adventure Mode.',
                    style: TextStyle(
                        color: NorieColors.textSecondary, height: 1.45),
                  ),
                  const SizedBox(height: 24),
                  for (final (subject, icon, accent) in _subjects)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Icon(icon, color: accent),
                          title: Text(subject,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800)),
                          subtitle: Text(
                            subject == 'Filipino' ||
                                    subject == 'Araling Panlipunan'
                                ? 'Grade 1 pilot lessons · available offline'
                                : 'Grades 1 to College · available offline',
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => NorieGradeSelectScreen(
                                subject: subject,
                                icon: icon,
                                accent: accent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
