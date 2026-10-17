import 'package:flutter/material.dart';

import '../../../core/account/norie_account_service.dart';
import '../../../core/progression/norie_lesson_journey.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../content/data/norie_foundation_curriculum.dart';
import '../../content/presentation/norie_lesson_screen.dart';

/// Reading bookmarks are separate from mastery and assessment completion.
class LearnContinueCard extends StatelessWidget {
  const LearnContinueCard({super.key, required this.onChooseSubject});

  final VoidCallback onChooseSubject;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge([
          NorieLessonJourney.instance,
          NorieProgression.instance,
          NorieAccountService.instance,
        ]),
        builder: (context, _) {
          final journey = NorieLessonJourney.instance;
          final topic = journey.lastTopic;
          final owner = journey.ownershipRevision;
          final guard = NorieAccountService.instance.captureLearnerGuard();
          final completed = topic != null &&
              NorieProgression.instance.isTopicCompleted(topic.id);
          final grade = topic == null
              ? null
              : NorieFoundationCurriculum.gradeLevels
                  .where((g) => g.id == topic.gradeLevel)
                  .firstOrNull;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Continue Learning',
                      style: TextStyle(
                          color: NorieColors.cyan,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text(topic?.title ?? 'Your first lesson awaits',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(topic == null
                      ? 'Choose a subject and grade to start learning offline.'
                      : '${topic.subject} / ${grade?.label ?? topic.category}'),
                  if (topic != null) ...[
                    const SizedBox(height: 8),
                    Text(completed
                        ? 'Lesson completed. Review anytime.'
                        : 'Reading saved. Complete the lesson practice to record completion.'),
                  ],
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: topic == null
                        ? onChooseSubject
                        : () {
                            if (!guard() ||
                                owner != journey.ownershipRevision) {
                              return;
                            }
                            Navigator.of(context).push(MaterialPageRoute<void>(
                                builder: (_) =>
                                    NorieLessonScreen(topic: topic)));
                          },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(topic == null
                        ? 'Choose a lesson'
                        : completed
                            ? 'Review Lesson'
                            : 'Resume Lesson'),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
