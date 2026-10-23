import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../learning/presentation/subject_mode_cards.dart';
import '../data/norie_foundation_curriculum.dart';
import 'norie_grade_lessons_screen.dart';

class NorieGradeSelectScreen extends StatelessWidget {
  const NorieGradeSelectScreen({
    required this.subject,
    required this.icon,
    required this.accent,
    super.key,
  });

  final String subject;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final gradesKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: .13),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(icon, color: accent, size: 30),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$subject Learning Path',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              NorieFoundationCurriculum.availableGradeLevels(
                                              subject)
                                          .length ==
                                      NorieFoundationCurriculum
                                          .gradeLevels.length
                                  ? 'Authored learning journeys. Choose a grade or course level.'
                                  : 'Grade 1 pilot lessons. More grades will appear as lessons are published.',
                              style: const TextStyle(
                                color: NorieColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  SubjectModeCards(
                    subject: subject,
                    accent: accent,
                    onClassicTap: () => Scrollable.ensureVisible(
                      gradesKey.currentContext!,
                      alignment: 0,
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : const Duration(milliseconds: 250),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Choose a grade',
                      key: gradesKey,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  for (final grade
                      in NorieFoundationCurriculum.availableGradeLevels(
                          subject)) ...[
                    _GradeCard(
                      subject: subject,
                      grade: grade,
                      accent: accent,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => NorieGradeLessonsScreen(
                              subject: subject,
                              grade: grade,
                              accent: accent,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 9),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  const _GradeCard({
    required this.subject,
    required this.grade,
    required this.accent,
    required this.onTap,
  });

  final String subject;
  final NorieGradeLevel grade;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final topics = NorieFoundationCurriculum.topicsFor(subject, grade.id);
    final progression = NorieProgression.instance;
    final completed =
        topics.where((topic) => progression.isTopicCompleted(topic.id)).length;

    return Material(
      color: NorieColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: NorieColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: accent.withValues(alpha: .12),
                foregroundColor: accent,
                child: Text(
                  grade.shortLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grade.label,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${NorieFoundationCurriculum.coverageLabel(subject, grade.id)} · '
                      '$completed/${topics.length} completed',
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
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
