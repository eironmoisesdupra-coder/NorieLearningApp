import '../../domain/norie_content_models.dart';
import '../authored_topic_builder.dart';
import 'authored_lesson_visual.dart';

/// Assembly only: all teaching, models and assessment rows are authored in the
/// grade files. No question or explanation is generated from a topic name.
class CoreMathUnit {
  const CoreMathUnit(
      {required this.title,
      required this.objectives,
      required this.focus,
      required this.explanation,
      required this.model,
      required this.worked,
      required this.guided,
      required this.solution,
      required this.mistakes,
      required this.recap,
      required this.questions});
  final String title;
  final List<String> objectives;
  final String focus;
  final String explanation;
  final Map<String, String> model;
  final String worked;
  final String guided;
  final String solution;
  final String mistakes;
  final String recap;

  /// prompt | correct answer | three semicolon-separated distractors | reason
  final List<String> questions;

  String id(String grade) =>
      'mathematics.$grade.${title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}';
  String visualId(String grade, int order) => 'mathematics-core-$grade-$order';
  AuthoredLessonVisual get visual => AuthoredLessonVisual(
      title: '$title — mathematical model',
      labels: List.unmodifiable(model.keys),
      details: List.unmodifiable(model.values),
      note: recap);

  NorieTopicContent build(String grade, int order, String? prerequisite) {
    NorieLessonSection section(String title, String body,
            {bool reveal = false}) =>
        NorieLessonSection(
            title: title,
            symbol: '',
            accent: 'cyan',
            points: const [],
            body: body,
            reveal: reveal);
    final rows = questions.map((row) {
      final fields = row.split('|');
      if (fields.length != 4 || fields[2].split(';').length != 3) {
        throw ArgumentError('Invalid authored Mathematics row in $title.');
      }
      return [fields[0], fields[1], ...fields[2].split(';'), fields[3], title];
    }).toList();
    return authoredTopic(
        subject: 'Mathematics',
        accent: 'cyan',
        visualType: 'authored-path',
        grade: grade,
        order: order,
        title: title,
        subtitle: focus,
        minutes: '20–30 minutes',
        objectives: objectives,
        introduction: focus,
        sections: [
          section('Explore the idea', explanation),
          NorieLessonSection(
              title: 'Diagram and model',
              symbol: '',
              accent: 'cyan',
              points: const [],
              visualType: visualId(grade, order),
              visualCaption: visual.note),
          section('Worked example — four reasoning steps', worked),
          section('Guided example — try before revealing', guided),
          section('Guided solution', solution, reveal: true),
          section('Common mistakes', mistakes),
          section('Lesson recap', recap),
        ],
        keyConcept: recap,
        questions: rows,
        prerequisiteTopicId: prerequisite,
        practiceQuestionCount: 8);
  }
}

List<NorieTopicContent> buildCoreMathGrade(
        String grade, List<CoreMathUnit> units) =>
    List.unmodifiable([
      for (var i = 0; i < units.length; i++)
        units[i].build(grade, i + 1, i == 0 ? null : units[i - 1].id(grade)),
    ]);

Map<String, AuthoredLessonVisual> coreMathVisuals(
        String grade, List<CoreMathUnit> units) =>
    {
      for (var i = 0; i < units.length; i++)
        units[i].visualId(grade, i + 1): units[i].visual,
    };
