import '../../domain/norie_content_models.dart';
import '../authored/authored_lesson_visual.dart';
import '../authored_topic_builder.dart';

/// Original teaching text, not a reproduction of a curriculum or textbook.
class DepedEnglishUnit {
  const DepedEnglishUnit({
    required this.title,
    required this.quarter,
    required this.passage,
    required this.objectives,
    required this.teaching,
    required this.worked,
    required this.guided,
    required this.solution,
    required this.mistakes,
    required this.recap,
    required this.model,
    required this.questions,
  });

  final String title;
  final String quarter;
  final String passage;
  final List<String> objectives;
  final String teaching;
  final String worked;
  final String guided;
  final String solution;
  final String mistakes;
  final String recap;

  /// Each entry is label | passage evidence and explanation.
  final List<String> model;

  /// prompt | answer | distractor | distractor | distractor | explanation.
  /// The first eight are practice; the final three are mastery.
  final List<String> questions;
}

String depedEnglishId(String grade, DepedEnglishUnit unit) =>
    'english.$grade.${unit.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}';

String depedEnglishVisualId(String grade, DepedEnglishUnit unit) =>
    'deped-${depedEnglishId(grade, unit)}-model';

AuthoredLessonVisual englishUnitVisual(DepedEnglishUnit unit) =>
    AuthoredLessonVisual(
      title: '${unit.title}: passage model',
      labels: unit.model.map((row) => row.split('|').first).toList(),
      details: unit.model.map((row) => row.split('|').last).toList(),
      note: 'Read the passage, then follow each label back to its words.',
    );

List<NorieTopicContent> englishGrade(
    String grade, List<DepedEnglishUnit> units) {
  return List.unmodifiable([
    for (var i = 0; i < units.length; i++)
      authoredTopic(
        subject: 'English',
        accent: 'cyan',
        visualType: depedEnglishVisualId(grade, units[i]),
        grade: grade,
        order: i + 1,
        title: units[i].title,
        subtitle:
            '${units[i].quarter} · Original passage and language practice',
        minutes:
            grade == 'g1' ? '12–18 minutes with a helper' : '20–30 minutes',
        objectives: units[i].objectives,
        introduction: grade == 'g1'
            ? 'Language-area support in English, not a standalone MATATAG '
                'Grade 1 English course. A helper may read aloud and invite '
                'answers in the child’s familiar language before trying English.'
            : 'Read or ask a helper to read the original text. '
                'Use its words as evidence for your answers.',
        sections: [
          _section('Read or listen', units[i].passage),
          _section('Learn the language', units[i].teaching),
          _section('Worked reasoning', units[i].worked),
          _section('Guided task — try first', units[i].guided),
          _section('Guided solution', units[i].solution),
          _section('Common mistakes', units[i].mistakes),
          NorieLessonSection(
            title: 'Labeled passage model',
            symbol: '',
            accent: 'cyan',
            points: const [],
            body: units[i]
                .model
                .map((row) => row.replaceFirst('|', ': '))
                .join('\n\n'),
            visualType: depedEnglishVisualId(grade, units[i]),
          ),
          _section('Recap', units[i].recap),
        ],
        keyConcept: units[i].recap,
        questions: [
          for (final encoded in units[i].questions)
            _question(units[i], encoded),
        ],
        prerequisiteTopicId:
            i == 0 ? null : depedEnglishId(grade, units[i - 1]),
        practiceQuestionCount: 8,
      ),
  ]);
}

NorieLessonSection _section(String title, String body) => NorieLessonSection(
      title: title,
      symbol: '',
      accent: 'cyan',
      points: const [],
      body: body,
    );

List<String> _question(DepedEnglishUnit unit, String encoded) {
  final row = encoded.split('|');
  if (row.length != 6) {
    throw ArgumentError('${unit.title}: question needs six fields: $encoded');
  }
  return [
    'Read or listen:\n${unit.passage}\n\n${row[0]}',
    ...row.skip(1),
    unit.title,
  ];
}
