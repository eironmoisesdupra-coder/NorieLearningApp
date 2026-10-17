import 'package:flutter/material.dart';
import '../../content/domain/norie_content_models.dart';
import '../../content/data/authored/authored_subject_curriculum.dart';
import '../../content/data/science/science_curriculum.dart';
import '../../content/presentation/authored_lesson_visual_view.dart';
import '../../content/presentation/science_figure_view.dart';
import '../../content/presentation/norie_grade1_science_visual.dart';

/// Required source context is always available, independent of hint policy.
class NorieClassroomQuestionContext extends StatelessWidget {
  const NorieClassroomQuestionContext({required this.topic, super.key});
  final NorieTopicContent topic;
  @override
  Widget build(BuildContext context) => ExpansionTile(
          title: const Text('Reference passage and diagrams'),
          childrenPadding: const EdgeInsets.all(12),
          children: [
            SelectableText(topic.lesson.introduction),
            for (final s in topic.lesson.sections) ...[
              const SizedBox(height: 12),
              Text(s.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              if (s.visualType != null)
                if (AuthoredSubjectCurriculum.visuals.containsKey(s.visualType))
                  AuthoredLessonVisualView(
                      visual: AuthoredSubjectCurriculum.visuals[s.visualType]!,
                      accent: Theme.of(context).colorScheme.primary)
                else if (ScienceCurriculum.figures.containsKey(s.visualType))
                  ScienceFigureView(
                      figure: ScienceCurriculum.figures[s.visualType]!)
                else
                  NorieGrade1ScienceVisual(
                      type: s.visualType!, caption: s.visualCaption ?? ''),
              if (s.visualCaption?.isNotEmpty ?? false)
                SelectableText(s.visualCaption!),
              if (s.body?.isNotEmpty ?? false) SelectableText(s.body!),
              for (final p in s.points) SelectableText(p),
            ],
          ]);
}
