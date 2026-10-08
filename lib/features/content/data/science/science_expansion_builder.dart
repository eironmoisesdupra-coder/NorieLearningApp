import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

/// A focused additional unit. The instructional text and every assessment row
/// are authored in its grade pack; this helper only assembles existing models.
NorieTopicContent expansionLesson({
  required String grade,
  required String title,
  required String prerequisite,
  required List<String> objectives,
  required String introduction,
  required String explanation,
  required String application,
  required String worked,
  required String guided,
  required String solution,
  required String mistakes,
  required String recap,
  required ScienceFigure figure,
  required List<String> questions,
}) =>
    scienceTopic(
      grade: grade,
      order: 6,
      title: title,
      subtitle: objectives.first,
      minutes: '20–30 minutes',
      objectives: objectives,
      introduction: introduction,
      sections: [
        scienceSection('Explore the idea', explanation),
        scienceVisual('sci-$grade-expansion', figure.note),
        scienceSection('Apply the idea', application),
        scienceSection('Worked example — reason step by step', worked),
        scienceSection('Guided example — try before revealing', guided),
        scienceSection('Guided solution', solution, reveal: true),
        scienceSection('Common mistakes', mistakes),
        scienceSection('Lesson recap', recap),
      ],
      keyConcept: recap,
      questions: questions.map((row) => row.split('|')).toList(),
      prerequisiteTopicId: prerequisite,
      practiceQuestionCount: 8,
    );
