import '../../domain/norie_content_models.dart';

/// Assemble authored Science content without changing progression or rewards.
NorieTopicContent scienceTopic({
  required String grade,
  required int order,
  required String title,
  required String subtitle,
  required String minutes,
  required List<String> objectives,
  required String introduction,
  required List<NorieLessonSection> sections,
  required String keyConcept,
  required List<List<String>> questions,
  required String? prerequisiteTopicId,
}) {
  if (objectives.length < 3 ||
      objectives.length > 5 ||
      objectives.any((objective) => objective.trim().isEmpty)) {
    throw ArgumentError('Provide three to five nonempty learning objectives.');
  }
  if (minutes.trim().isEmpty || keyConcept.trim().isEmpty) {
    throw ArgumentError('Provide a lesson duration and key concept.');
  }
  if (questions.length != 23) {
    throw ArgumentError.value(questions.length, 'questions',
        'Provide 20 practice questions and 3 independent mastery questions.');
  }
  final slug = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  final id = 'science.$grade.$slug';
  final category =
      grade == 'college' ? 'College' : 'Grade ${grade.substring(1)}';
  final assessment = <NorieQuestionContent>[];
  for (var index = 0; index < questions.length; index++) {
    final row = questions[index];
    if (row.length != 7 || row.any((value) => value.trim().isEmpty)) {
      throw ArgumentError('Question ${index + 1} needs seven nonempty fields.');
    }
    final answers = row.sublist(1, 5);
    if (answers.map((answer) => answer.trim().toLowerCase()).toSet().length !=
        4) {
      throw ArgumentError('Question ${index + 1} needs four distinct options.');
    }
    final correctIndex = index % 4;
    final options = List<String>.generate(
        4, (optionIndex) => answers[(optionIndex - correctIndex + 4) % 4]);
    final isMastery = index >= 20;
    assessment.add(NorieQuestionContent(
      id: '$id.${isMastery ? 'mastery' : 'q'}.${isMastery ? index - 19 : index + 1}',
      prompt: row[0],
      options: List.unmodifiable(options),
      correctIndex: correctIndex,
      explanation: row[5],
      difficulty: index < 7
          ? 'foundation'
          : index < 14
              ? 'intermediate'
              : 'advanced',
      conceptId:
          '$id.${row[6].toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}',
      conceptLabel: row[6],
    ));
  }
  return NorieTopicContent(
    id: id,
    subject: 'Science',
    category: category,
    gradeLevel: grade,
    title: title,
    subtitle: subtitle,
    order: order,
    accent: 'green',
    visualType: 'science-path',
    prerequisiteTopicId: prerequisiteTopicId,
    lesson: NorieLessonContent(
      heading: title,
      introduction: '$introduction\n\n$minutes',
      sections: List.unmodifiable([
        NorieLessonSection(
          title: 'Learning objectives',
          symbol: '',
          accent: 'green',
          points: List.unmodifiable(objectives),
          body: objectives.map((objective) => '• $objective').join('\n\n'),
        ),
        ...sections,
      ]),
      keyConceptTitle: 'Key concept',
      keyConceptBody: keyConcept,
    ),
    quiz: NorieQuizContent(questions: List.unmodifiable(assessment.take(20))),
    challenge: NorieChallengeContent(
      title: '$title Mastery',
      description: 'Apply the lesson in three independent checks.',
      rounds: List.unmodifiable(assessment.skip(20)),
    ),
  );
}

NorieLessonSection scienceSection(String title, String body,
        {bool reveal = false}) =>
    NorieLessonSection(
      title: title,
      symbol: '',
      accent: 'green',
      points: const [],
      body: body,
      reveal: reveal,
    );

NorieLessonSection scienceVisual(String id, String caption) =>
    NorieLessonSection(
      title: 'Diagram',
      symbol: '',
      accent: 'green',
      points: const [],
      visualType: id,
      visualCaption: caption,
    );
