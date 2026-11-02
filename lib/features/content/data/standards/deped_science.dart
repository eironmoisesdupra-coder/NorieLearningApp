import '../../domain/norie_content_models.dart';
import '../authored/authored_lesson_visual.dart';
import '../authored_topic_builder.dart';

part 'science_primary.dart';
part 'science_elementary.dart';
part 'science_secondary.dart';

const _matatag =
    'https://www.deped.gov.ph/wp-content/uploads/MATATAG-Science-CG-Grade-4-and-7.pdf';
const _legacy =
    'https://www.deped.gov.ph/wp-content/uploads/2019/01/Science-CG_with-tagged-sci-equipment_revised.pdf';

/// References, not a standards certification. Page numbers are PDF page numbers.
/// The 2016 guide is deliberately identified as legacy, not current MATATAG.
final Map<String, List<String>> depedScienceSources = {
  for (final grade in ['g1', 'g2'])
    grade: [
      '$_legacy | ${grade.toUpperCase()}, PDF p.5 grade-level exploratory outcomes; '
          'integrated early-grade science, NOT a standalone Science subject. '
          'The four exploration blocks are Norie sequencing, not official quarters.',
      if (grade == 'g1')
        'https://www.deped.gov.ph/matatagcurriculumk147/ | Grade 1 current '
            'MATATAG subject list includes Makabansa, not standalone Science. '
            'These explorations are not claimed as a Makabansa competency mapping.',
    ],
  'g3': [
    '$_legacy | Grade 3 LEGACY 2016: Q1 Matter pp.17-21; Q2 Living Things '
        'pp.22-35; Q3 Force and Motion pp.36-39; Q4 Earth and Space pp.40-46. '
        'Current grade-specific MATATAG competencies have not been verified.',
  ],
  'g4': [
    '$_matatag | Grade 4 MATATAG: Q1 Materials p.24; Q2 Living Things p.25; '
        'Q3 Force, Motion, and Energy pp.26-27; Q4 Earth and Space pp.27-28. '
        'Read from the user-supplied sci_cg.pdf; selected competency coverage only.',
  ],
  'g5': [
    '$_legacy | Grade 5 LEGACY 2016: Q1 Matter pp.64-66; Q2 Living Things '
        'pp.66-70; Q3 Force, Motion, and Energy pp.70-75; Q4 Earth and Space '
        'pp.75-79. Current grade-specific MATATAG mapping remains unverified.',
  ],
  'g6': [
    '$_legacy | Grade 6 LEGACY 2016: Q1 Matter pp.80-83; Q2 Living Things '
        'pp.84-93; Q3 Force, Motion, and Energy pp.94-98; Q4 Earth and Space '
        'pp.98-105. Current grade-specific MATATAG mapping remains unverified.',
  ],
  'g7': [
    '$_matatag | Grade 7 MATATAG: Q1 Science of Materials pp.29-30; Q2 Life '
        'Science pp.30-31; Q3 Force, Motion, and Energy pp.31-32; Q4 Earth '
        'and Space Science pp.33-34. Read from sci_cg.pdf; selected coverage.',
  ],
  'g8': [
    '$_legacy | Grade 8 LEGACY 2016: Q1 Force, Motion, and Energy pp.125-136; '
        'Q2 Earth and Space pp.137-142; Q3 Matter pp.143-147; Q4 Living Things '
        'pp.148-153. These are legacy quarter assignments, NOT MATATAG order.',
  ],
  'g9': [
    '$_legacy | Grade 9 LEGACY 2016: Q1 Living Things pp.154-158; Q2 Matter '
        'pp.159-165; Q3 Earth and Space pp.165-168; Q4 Force, Motion, and '
        'Energy pp.169-175. NOT a verified current MATATAG quarter mapping.',
  ],
  'g10': [
    '$_legacy | Grade 10 LEGACY 2016: Q1 Earth and Space pp.176-181; Q2 Force, '
        'Motion, and Energy pp.182-187; Q3 Living Things pp.187-195; Q4 Matter '
        'pp.196-199. NOT a verified current MATATAG quarter mapping.',
  ],
};

/// Original, offline lessons. G1/G2 are integrated explorations, not an invented
/// official standalone Science course. G3/G5/G6/G8/G9/G10 use legacy references.
final Map<String, List<NorieTopicContent>> depedScience = {
  for (final entry in _units.entries)
    entry.key: List.unmodifiable([
      for (var index = 0; index < entry.value.length; index++)
        _build(entry.key, index, entry.value),
    ]),
};

final Map<String, AuthoredLessonVisual> depedScienceVisuals = {
  for (final entry in _units.entries)
    for (final unit in entry.value)
      _visualId(entry.key, unit): AuthoredLessonVisual(
        title: '${unit.title}: labeled comparison model',
        labels: List.unmodifiable(unit.labels),
        details: List.unmodifiable(unit.details),
        note: 'Read each label with its explanation. This is a comparison '
            'model, not a drawing to scale. ${unit.recap}',
      ),
};

final _units = <String, List<_ScienceUnit>>{
  'g1': _g1,
  'g2': _g2,
  'g3': _g3,
  'g4': _g4,
  'g5': _g5,
  'g6': _g6,
  'g7': _g7,
  'g8': _g8,
  'g9': _g9,
  'g10': _g10,
};

String _slug(String title) =>
    title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
String _topicId(String grade, _ScienceUnit unit) =>
    'science.$grade.${_slug(unit.title)}';
String _visualId(String grade, _ScienceUnit unit) =>
    'deped-science-$grade-${_slug(unit.title)}';

NorieLessonSection _section(String title, String body, {bool reveal = false}) =>
    NorieLessonSection(
      title: title,
      symbol: '',
      accent: 'green',
      points: const [],
      body: body,
      reveal: reveal,
    );

NorieTopicContent _build(
    String grade, int index, List<_ScienceUnit> gradeUnits) {
  final unit = gradeUnits[index];
  if (unit.prompts.length != 11 ||
      unit.labels.length != 4 ||
      unit.details.length != 4) {
    throw StateError(
        '${unit.title}: four model labels and eleven checks needed');
  }
  final integrated = grade == 'g1' || grade == 'g2';
  final current = grade == 'g4' || grade == 'g7';
  final basis = integrated
      ? 'Integrated exploratory science; Norie block ${unit.quarter}, '
          'not an official standalone Science quarter'
      : '${current ? 'MATATAG' : 'Legacy 2016 reference'} '
          'Q${unit.quarter}: ${unit.domain}';
  return authoredTopic(
    subject: 'Science',
    accent: 'green',
    visualType: _visualId(grade, unit),
    grade: grade,
    order: index + 1,
    title: unit.title,
    subtitle: basis,
    minutes:
        integrated ? '12-18 minutes with an adult reader' : '20-30 minutes',
    objectives: unit.objectives.split('|'),
    introduction: '$basis. ${unit.recap} Use the labeled model, then reason '
        'through the examples before answering. All checks work offline.',
    sections: [
      for (var i = 0; i < unit.labels.length; i++)
        _section(unit.labels[i], unit.details[i]),
      NorieLessonSection(
        title: 'Labeled model',
        symbol: '',
        points: const [],
        accent: 'green',
        visualType: _visualId(grade, unit),
        visualCaption: unit.recap,
      ),
      _section('Worked example: follow the reasoning', unit.worked),
      _section('Guided question', unit.guided),
      _section('Guided solution', unit.solution, reveal: true),
      _section('Common mistake and correction', unit.mistake),
      _section('Recap', unit.recap),
      _section(
          'Safe observation',
          'Use drawings, supplied data, or safe everyday observations. '
              'Never taste unknown things, stare at the Sun, handle chemicals, '
              'use flames, or touch sockets. Ask a trusted adult for help. '
              'Do not collect wild animals or damage their homes.'),
    ],
    keyConcept: unit.recap,
    prerequisiteTopicId:
        index == 0 ? null : _topicId(grade, gradeUnits[index - 1]),
    practiceQuestionCount: 8,
    questions: [
      for (final encoded in unit.prompts) _question(unit, encoded),
    ],
  );
}

// Each check has an independently authored situation. Options identify the
// applicable part of the labeled model; explanations teach the causal link.
List<String> _question(_ScienceUnit unit, String encoded) {
  final fields = encoded.split('|');
  if (fields.length < 2 || fields.length > 3) {
    throw StateError('${unit.title}: malformed question $encoded');
  }
  final correct = int.parse(fields[0]);
  return [
    fields[1],
    unit.labels[correct],
    for (var i = 0; i < 4; i++)
      if (i != correct) unit.labels[i],
    '${fields.length == 3 ? '${fields[2]} ' : ''}${unit.details[correct]}',
    unit.labels[correct],
  ];
}

class _ScienceUnit {
  const _ScienceUnit(
    this.quarter,
    this.domain,
    this.title,
    this.objectives,
    this.labels,
    this.details,
    this.worked,
    this.guided,
    this.solution,
    this.mistake,
    this.recap,
    this.prompts,
  );
  final int quarter;
  final String domain;
  final String title;
  final String objectives;
  final List<String> labels;
  final List<String> details;
  final String worked;
  final String guided;
  final String solution;
  final String mistake;
  final String recap;
  final List<String> prompts;
}
