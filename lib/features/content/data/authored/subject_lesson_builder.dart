import '../../domain/norie_content_models.dart';
import '../authored_topic_builder.dart';
import 'authored_lesson_visual.dart';

NorieTopicContent subjectLesson({
  required String subject,
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
  required AuthoredLessonVisual visual,
  required List<String> questions,
}) {
  final accent = subject == 'Mathematics' ? 'cyan' : 'orange';
  NorieLessonSection section(String title, String body,
          {bool reveal = false}) =>
      NorieLessonSection(
          title: title,
          symbol: '',
          accent: accent,
          points: const [],
          body: body,
          reveal: reveal);
  return authoredTopic(
    subject: subject,
    accent: accent,
    visualType: 'authored-path',
    grade: grade,
    order: 6,
    title: title,
    subtitle: objectives.first,
    minutes: '20–30 minutes',
    objectives: objectives,
    introduction: introduction,
    sections: [
      section('Explore the idea', explanation),
      NorieLessonSection(
          title: 'Diagram',
          symbol: '',
          accent: accent,
          points: const [],
          visualType: '${subject.toLowerCase()}-$grade-authored',
          visualCaption: visual.note),
      section('Apply the idea', application),
      section('Worked example — reason step by step', worked),
      section('Guided example — try before revealing', guided),
      section('Guided solution', solution, reveal: true),
      section('Common mistakes', mistakes),
      section('Lesson recap', recap),
    ],
    keyConcept: recap,
    questions: questions.map((row) => row.split('|')).toList(),
    prerequisiteTopicId: prerequisite,
    practiceQuestionCount: 8,
  );
}
