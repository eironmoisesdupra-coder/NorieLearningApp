import '../domain/norie_content_models.dart';

/// Assemble authored subject content without changing progression or rewards.
NorieTopicContent authoredTopic({
  required String subject,
  required String accent,
  required String visualType,
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
  int practiceQuestionCount = 20,
}) {
  if (objectives.length < 3 ||
      objectives.length > 5 ||
      objectives.any((objective) => objective.trim().isEmpty)) {
    throw ArgumentError('Provide three to five nonempty learning objectives.');
  }
  if (minutes.trim().isEmpty || keyConcept.trim().isEmpty) {
    throw ArgumentError('Provide a lesson duration and key concept.');
  }
  if (practiceQuestionCount < 5 ||
      questions.length != practiceQuestionCount + 3) {
    throw ArgumentError.value(questions.length, 'questions',
        'Provide at least five practice questions and three mastery questions.');
  }
  final slug = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  final id = '${subject.toLowerCase()}.$grade.$slug';
  final category =
      grade == 'college' ? 'College' : 'Grade ${grade.substring(1)}';
  final assessment = <NorieQuestionContent>[];
  for (var index = 0; index < questions.length; index++) {
    final row = questions[index];
    if (row.length != 7 || row.any((value) => value.trim().isEmpty)) {
      throw ArgumentError(
          '$id question ${index + 1} needs seven nonempty fields.');
    }
    final answers = row.sublist(1, 5);
    if (answers.map((answer) => answer.trim().toLowerCase()).toSet().length !=
        4) {
      throw ArgumentError(
          '$id question ${index + 1} needs four distinct options.');
    }
    final correctIndex = index % 4;
    final options = List<String>.generate(
        4, (optionIndex) => answers[(optionIndex - correctIndex + 4) % 4]);
    final isMastery = index >= practiceQuestionCount;
    assessment.add(NorieQuestionContent(
      id: '$id.${isMastery ? 'mastery' : 'q'}.${isMastery ? index - practiceQuestionCount + 1 : index + 1}',
      prompt: row[0],
      options: List.unmodifiable(options),
      correctIndex: correctIndex,
      explanation: row[5],
      difficulty: index < (practiceQuestionCount + 2) ~/ 3
          ? 'foundation'
          : index < (2 * practiceQuestionCount + 2) ~/ 3
              ? 'intermediate'
              : 'advanced',
      conceptId:
          '$id.${row[6].toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}',
      conceptLabel: row[6],
    ));
  }
  return NorieTopicContent(
    id: id,
    subject: subject,
    category: category,
    gradeLevel: grade,
    title: title,
    subtitle: subtitle,
    order: order,
    accent: accent,
    visualType: visualType,
    prerequisiteTopicId: prerequisiteTopicId,
    lesson: NorieLessonContent(
      heading: title,
      introduction: '$introduction\n\n$minutes',
      sections: List.unmodifiable([
        NorieLessonSection(
          title: 'Learning objectives',
          symbol: '',
          accent: accent,
          points: List.unmodifiable(objectives),
          body: objectives.map((objective) => '• $objective').join('\n\n'),
        ),
        ...sections,
      ]),
      keyConceptTitle: 'Key concept',
      keyConceptBody: keyConcept,
    ),
    quiz: NorieQuizContent(
        questions: List.unmodifiable(assessment.take(practiceQuestionCount))),
    challenge: NorieChallengeContent(
      title: '$title Mastery',
      description: 'Apply the lesson in three independent checks.',
      rounds: List.unmodifiable(assessment.skip(practiceQuestionCount)),
    ),
  );
}
