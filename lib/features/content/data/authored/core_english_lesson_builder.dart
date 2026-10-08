import '../../domain/norie_content_models.dart';
import '../authored_topic_builder.dart';
import 'authored_lesson_visual.dart';
import 'core_english_contexts.dart';

/// Each record supplies authored instruction and eleven individually keyed items.
class CoreEnglishLesson {
  const CoreEnglishLesson(
      this.grade,
      this.order,
      this.title,
      this.objectives,
      this.explanation,
      this.worked,
      this.guided,
      this.solution,
      this.mistakes,
      this.recap,
      this.labels,
      this.details,
      this.questions);
  final String grade,
      title,
      explanation,
      worked,
      guided,
      solution,
      mistakes,
      recap;
  final int order;
  final List<String> objectives, labels, details, questions;
  String get figureKey => 'english-core-$grade-$order';
  AuthoredLessonVisual get figure => AuthoredLessonVisual(
      title: title, labels: labels, details: details, note: recap);
  NorieTopicContent build(String? prerequisite) {
    NorieLessonSection section(String title, String body,
            {bool reveal = false}) =>
        NorieLessonSection(
            title: title,
            symbol: '',
            accent: 'orange',
            points: const [],
            body: body,
            reveal: reveal);
    return authoredTopic(
        subject: 'English',
        accent: 'orange',
        visualType: 'authored-path',
        grade: grade,
        order: order,
        title: title,
        subtitle: objectives.first,
        minutes: const ['g1', 'g2'].contains(grade)
            ? '10–15 minutes'
            : '20–30 minutes',
        objectives: objectives,
        introduction: explanation,
        sections: [
          section('Explore the language', explanation),
          NorieLessonSection(
              title: 'Language model',
              symbol: '',
              accent: 'orange',
              points: const [],
              visualType: figureKey,
              visualCaption: recap),
          section('Worked example — reason step by step', worked),
          section('Guided example — try first', guided),
          section('Guided solution', solution, reveal: true),
          section('Common mistakes', mistakes),
          section('Lesson recap', recap)
        ],
        keyConcept: recap,
        prerequisiteTopicId: prerequisite,
        practiceQuestionCount: 8,
        questions: questions.map((row) {
          final fields = row.split('|');
          if (fields.length != 6) {
            throw ArgumentError('Six fields required: $title: $row');
          }
          final context = coreEnglishContexts['$grade.$order'];
          if (context != null) fields[0] = '$context\n\n${fields[0]}';
          return [...fields, title];
        }).toList());
  }
}

Map<String, List<NorieTopicContent>> buildCoreEnglish(
    List<CoreEnglishLesson> lessons) {
  final grades = <String, List<NorieTopicContent>>{};
  for (final lesson in lessons) {
    final list = grades.putIfAbsent(lesson.grade, () => []);
    list.add(lesson.build(list.isEmpty ? null : list.last.id));
  }
  return grades.map((k, v) => MapEntry(k, List.unmodifiable(v)));
}
