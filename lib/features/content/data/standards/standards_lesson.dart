import '../../domain/norie_content_models.dart';
import '../authored/authored_lesson_visual.dart';
import '../authored_topic_builder.dart';

class StandardsLesson {
  const StandardsLesson({
    required this.title,
    required this.objectives,
    required this.explanation,
    required this.model,
    required this.worked,
    required this.guided,
    required this.solution,
    required this.mistake,
    required this.recap,
    required this.questions,
  });

  final String title;
  final List<String> objectives;
  final String explanation;
  final Map<String, String> model;
  final String worked;
  final String guided;
  final String solution;
  final String mistake;
  final String recap;

  /// Prompt, correct answer, three distractors, then an answer explanation.
  final List<List<String>> questions;

  String visualId(String subject, String grade, int order) =>
      'standards-${subject.toLowerCase()}-$grade-$order';

  AuthoredLessonVisual get visual => AuthoredLessonVisual(
        title: title,
        labels: List.unmodifiable(model.keys),
        details: List.unmodifiable(model.values),
        note: recap,
      );

  NorieTopicContent build({
    required String subject,
    required String grade,
    required String course,
    required int order,
    required String? prerequisite,
  }) {
    final accent = switch (subject) {
      'Mathematics' => 'cyan',
      'English' => 'orange',
      _ => 'green',
    };
    NorieLessonSection section(String title, String body,
            {bool reveal = false}) =>
        NorieLessonSection(
          title: title,
          symbol: '',
          accent: accent,
          points: const [],
          body: body,
          reveal: reveal,
        );
    return authoredTopic(
      subject: subject,
      accent: accent,
      visualType: 'authored-path',
      grade: grade,
      order: order,
      title: title,
      subtitle: course,
      minutes: '25-35 minutes',
      objectives: objectives,
      introduction: explanation,
      sections: [
        NorieLessonSection(
          title: 'Model and evidence',
          symbol: '',
          accent: accent,
          points: const [],
          visualType: visualId(subject, grade, order),
          visualCaption: recap,
        ),
        section('Worked example: follow the reasoning', worked),
        section('Guided practice: try first', guided),
        section('Guided solution', solution, reveal: true),
        section('Common mistake', mistake),
        section('Recap', recap),
      ],
      keyConcept: recap,
      questions: questions.map((row) => [...row, title]).toList(),
      prerequisiteTopicId: prerequisite,
      practiceQuestionCount: 8,
    );
  }
}

List<NorieTopicContent> buildStandardsCourse({
  required String subject,
  required String grade,
  required String course,
  required List<StandardsLesson> lessons,
}) {
  final topics = <NorieTopicContent>[];
  for (var i = 0; i < lessons.length; i++) {
    topics.add(lessons[i].build(
      subject: subject,
      grade: grade,
      course: course,
      order: i + 1,
      prerequisite: topics.isEmpty ? null : topics.last.id,
    ));
  }
  return List.unmodifiable(topics);
}
