class ChallengeQuestion {
  const ChallengeQuestion({
    required this.id,
    required this.category,
    required this.topic,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;
  final String category;
  final String topic;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

abstract final class NorieChallengeBank {
  static const questions = <ChallengeQuestion>[
    ChallengeQuestion(
      id: 'science_atomic_number',
      category: 'Science',
      topic: 'Atomic Structure',
      prompt: 'What determines an element’s atomic number?',
      options: [
        'Number of neutrons',
        'Number of protons',
        'Number of electron shells',
        'Total number of particles',
      ],
      correctIndex: 1,
      explanation:
          'Atomic number is defined by the number of protons in the nucleus.',
    ),
    ChallengeQuestion(
      id: 'math_linear_equation',
      category: 'Mathematics',
      topic: 'Algebra',
      prompt: 'Solve: 3(x + 2) = 15',
      options: ['x = 2', 'x = 3', 'x = 5', 'x = 7'],
      correctIndex: 1,
      explanation:
          'Divide both sides by 3 to get x + 2 = 5, then subtract 2. So x = 3.',
    ),
    ChallengeQuestion(
      id: 'english_their',
      category: 'English',
      topic: 'Grammar',
      prompt: 'Which sentence uses “their” correctly?',
      options: [
        'Their going to study later.',
        'The books are over their.',
        'They brought their books.',
        'Their is a quiz tomorrow.',
      ],
      correctIndex: 2,
      explanation:
          '“Their” shows possession, as in “their books.”',
    ),
    ChallengeQuestion(
      id: 'biology_chloroplast',
      category: 'Science',
      topic: 'Cell Biology',
      prompt: 'Which organelle carries out photosynthesis in plant cells?',
      options: ['Mitochondrion', 'Nucleus', 'Chloroplast', 'Ribosome'],
      correctIndex: 2,
      explanation:
          'Chloroplasts contain chlorophyll and are the main site of photosynthesis.',
    ),
    ChallengeQuestion(
      id: 'math_percent',
      category: 'Mathematics',
      topic: 'Percentages',
      prompt: 'What is 25% of 80?',
      options: ['15', '20', '25', '30'],
      correctIndex: 1,
      explanation: '25% is one-fourth, and one-fourth of 80 is 20.',
    ),
    ChallengeQuestion(
      id: 'science_neutral_atom',
      category: 'Science',
      topic: 'Atomic Structure',
      prompt: 'In a neutral atom, the number of electrons equals the number of…',
      options: ['Protons', 'Neutrons', 'Shells', 'Isotopes'],
      correctIndex: 0,
      explanation:
          'A neutral atom has equal positive and negative charge, so protons equal electrons.',
    ),
    ChallengeQuestion(
      id: 'english_synonym_rapid',
      category: 'English',
      topic: 'Vocabulary',
      prompt: 'Which word is closest in meaning to “rapid”?',
      options: ['Slow', 'Fast', 'Quiet', 'Heavy'],
      correctIndex: 1,
      explanation: '“Rapid” means happening very quickly or fast.',
    ),
    ChallengeQuestion(
      id: 'math_square_root',
      category: 'Mathematics',
      topic: 'Number Sense',
      prompt: 'What is √144?',
      options: ['10', '11', '12', '14'],
      correctIndex: 2,
      explanation: '12 × 12 = 144, so √144 = 12.',
    ),
    ChallengeQuestion(
      id: 'earth_crust',
      category: 'Science',
      topic: 'Earth Science',
      prompt: 'What is Earth’s outermost solid layer called?',
      options: ['Core', 'Mantle', 'Crust', 'Outer core'],
      correctIndex: 2,
      explanation:
          'The crust is Earth’s thin, outermost solid layer.',
    ),
    ChallengeQuestion(
      id: 'chemistry_water_formula',
      category: 'Science',
      topic: 'Chemistry Basics',
      prompt: 'Which chemical formula represents water?',
      options: ['CO₂', 'O₂', 'H₂O', 'NaCl'],
      correctIndex: 2,
      explanation:
          'A water molecule contains two hydrogen atoms and one oxygen atom: H₂O.',
    ),
  ];

  static List<ChallengeQuestion> dailyQuestions() =>
      questions.take(5).toList(growable: false);

  static List<ChallengeQuestion> speedQuestions() =>
      questions.take(10).toList(growable: false);
}
