import '../domain/norie_content_models.dart';

class NorieGradeLevel {
  const NorieGradeLevel(this.id, this.label, this.shortLabel);
  final String id;
  final String label;
  final String shortLabel;
}

abstract final class NorieFoundationCurriculum {
  static const gradeLevels = <NorieGradeLevel>[
    NorieGradeLevel('g1', 'Grade 1', 'G1'),
    NorieGradeLevel('g2', 'Grade 2', 'G2'),
    NorieGradeLevel('g3', 'Grade 3', 'G3'),
    NorieGradeLevel('g4', 'Grade 4', 'G4'),
    NorieGradeLevel('g5', 'Grade 5', 'G5'),
    NorieGradeLevel('g6', 'Grade 6', 'G6'),
    NorieGradeLevel('g7', 'Grade 7', 'G7'),
    NorieGradeLevel('g8', 'Grade 8', 'G8'),
    NorieGradeLevel('g9', 'Grade 9', 'G9'),
    NorieGradeLevel('g10', 'Grade 10', 'G10'),
    NorieGradeLevel('g11', 'Grade 11', 'G11'),
    NorieGradeLevel('g12', 'Grade 12', 'G12'),
    NorieGradeLevel('college', 'College', 'College'),
  ];

  static const _math = <String, List<String>>{
    'g1': ['Counting to 100', 'Place Value', 'Addition Basics', 'Subtraction Basics', 'Shapes & Patterns'],
    'g2': ['Place Value to 1000', 'Addition Strategies', 'Subtraction Strategies', 'Equal Groups', 'Length, Time & Money'],
    'g3': ['Multiplication Facts', 'Division Facts', 'Fractions', 'Area & Perimeter', 'Data & Graphs'],
    'g4': ['Multi-Digit Operations', 'Factors & Multiples', 'Equivalent Fractions', 'Decimals', 'Angles & Symmetry'],
    'g5': ['Fraction Operations', 'Decimal Operations', 'Volume', 'Coordinate Plane', 'Numerical Expressions'],
    'g6': ['Ratios & Rates', 'Percent', 'Integers', 'Expressions & Variables', 'Statistics'],
    'g7': ['Rational Numbers', 'Proportions', 'Algebraic Expressions', 'Equations & Inequalities', 'Geometry & Probability'],
    'g8': ['Linear Equations', 'Functions', 'Systems of Equations', 'Exponents & Radicals', 'Pythagorean Theorem'],
    'g9': ['Polynomials', 'Quadratic Foundations', 'Coordinate Geometry', 'Similarity & Congruence', 'Intro Statistics'],
    'g10': ['Quadratic Equations', 'Functions & Graphs', 'Trigonometry Basics', 'Circles', 'Probability & Combinatorics'],
    'g11': ['Advanced Algebra', 'Sequences & Series', 'Trigonometric Functions', 'Analytic Geometry', 'Intro Calculus'],
    'g12': ['Limits', 'Derivatives', 'Integrals', 'Probability Distributions', 'Applied Mathematics'],
    'college': ['College Algebra', 'Precalculus', 'Differential Calculus', 'Integral Calculus', 'Linear Algebra'],
  };

  static const _english = <String, List<String>>{
    'g1': ['Letters & Sounds', 'Sight Words', 'Nouns', 'Action Words', 'Simple Sentences'],
    'g2': ['Phonics Patterns', 'Pronouns', 'Present & Past Verbs', 'Adjectives', 'Story Sequence'],
    'g3': ['Parts of Speech', 'Subject & Predicate', 'Verb Tenses', 'Context Clues', 'Paragraph Basics'],
    'g4': ['Sentence Types', 'Subject–Verb Agreement', 'Adverbs', 'Main Idea & Details', 'Paragraph Organization'],
    'g5': ['Grammar Review', 'Complex Sentences', 'Vocabulary Strategies', 'Text Structure', 'Opinion Writing'],
    'g6': ['Clauses & Phrases', 'Pronoun Agreement', 'Figurative Language', 'Inference', 'Essay Foundations'],
    'g7': ['Sentence Variety', 'Verb Voice', 'Vocabulary in Context', 'Literary Elements', 'Expository Writing'],
    'g8': ['Grammar & Usage', 'Active & Passive Voice', 'Rhetorical Devices', 'Reading Arguments', 'Argument Writing'],
    'g9': ['Advanced Grammar', 'Academic Vocabulary', 'Literary Analysis', 'Evidence & Citation', 'Analytical Essays'],
    'g10': ['Style & Syntax', 'Research Skills', 'Critical Reading', 'Persuasive Techniques', 'Research Writing'],
    'g11': ['Academic Reading', 'Rhetoric', 'Source Evaluation', 'Argumentation', 'Research Paper Structure'],
    'g12': ['College-Ready Grammar', 'Critical Analysis', 'Synthesis of Sources', 'Academic Writing', 'Oral Communication'],
    'college': ['Academic English', 'Critical Reading', 'Research & Citation', 'Argumentative Writing', 'Professional Communication'],
  };

  static const _science = <String, List<String>>{
    'g1': ['Living & Nonliving Things', 'Plants & Animals', 'Our Body & Senses', 'Weather', 'Materials Around Us'],
    'g2': ['Life Cycles', 'Habitats', 'States of Matter', 'Light & Sound', 'Earth & Sky'],
    'g3': ['Plant Parts', 'Animal Adaptations', 'Matter & Changes', 'Force & Motion', 'Weather Patterns'],
    'g4': ['Ecosystems', 'Human Body Systems', 'Energy', 'Rocks & Minerals', 'Earth, Moon & Sun'],
    'g5': ['Cells Introduction', 'Food Webs', 'Properties of Matter', 'Simple Machines', 'Water Cycle'],
    'g6': ['Organisms & Classification', 'Mixtures & Solutions', 'Electricity', 'Plate Tectonics', 'Solar System'],
    'g7': ['Scientific Investigation', 'Cells & Microscopy', 'Matter & Particles', 'Force & Motion', 'Earth Systems'],
    'g8': ['Genetics Basics', 'Chemical Reactions', 'Work & Energy', 'Waves', 'Weather & Climate'],
    'g9': ['Biology Foundations', 'Atomic Structure', 'Chemical Bonding', 'Motion & Forces', 'Plate Tectonics'],
    'g10': ['Evolution', 'Periodic Table', 'Acids & Bases', 'Electricity & Magnetism', 'Ecosystems'],
    'g11': ['Cell Biology', 'Stoichiometry', 'Mechanics', 'Earth Materials', 'Scientific Data Analysis'],
    'g12': ['Genetics & Molecular Biology', 'Chemical Equilibrium', 'Electric Fields', 'Geologic Processes', 'Ecology'],
    'college': ['General Biology', 'General Chemistry', 'University Physics', 'Earth Science', 'Scientific Research'],
  };

  static List<String> lessonTitles(String subject, String gradeId) {
    final source = switch (subject.toLowerCase()) {
      'mathematics' => _math,
      'english' => _english,
      _ => _science,
    };
    return source[gradeId] ?? const <String>[];
  }

  static List<NorieTopicContent> topicsFor(String subject, String gradeId) {
    final level = gradeLevels.firstWhere((item) => item.id == gradeId);
    final titles = lessonTitles(subject, gradeId);
    return [
      for (var i = 0; i < titles.length; i++)
        _topic(subject, level, titles[i], i + 1),
    ];
  }

  static NorieTopicContent _topic(
    String subject,
    NorieGradeLevel level,
    String title,
    int order,
  ) {
    final slug = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    final subjectSlug = subject.toLowerCase();
    final accent = switch (subjectSlug) {
      'mathematics' => 'cyan',
      'english' => 'orange',
      _ => 'green',
    };
    final visual = switch (subjectSlug) {
      'mathematics' => 'math',
      'english' => 'language',
      _ => title.toLowerCase().contains('atom') ? 'atom' : 'science',
    };

    final core = _coreIdeas(subject, title, level.label);
    return NorieTopicContent(
      id: '$subjectSlug.${level.id}.$slug',
      subject: subject,
      category: level.label,
      gradeLevel: level.id,
      title: title,
      subtitle: 'Foundation lesson · ${level.label}',
      order: order,
      accent: accent,
      visualType: visual,
      prerequisiteTopicId: order == 1
          ? null
          : '$subjectSlug.${level.id}.${lessonTitles(subject, level.id)[order - 2].toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}',
      lesson: NorieLessonContent(
        heading: title,
        introduction:
            'Build a clear ${level.label} foundation in $title through short explanations, visual cues, examples, and active recall.',
        sections: [
          NorieLessonSection(
            title: 'Understand',
            symbol: '1',
            accent: accent,
            points: core.take(2).toList(),
          ),
          NorieLessonSection(
            title: 'Connect',
            symbol: '2',
            accent: 'violet',
            points: core.skip(2).take(2).toList(),
          ),
          NorieLessonSection(
            title: 'Apply',
            symbol: '3',
            accent: 'orange',
            points: [
              'Explain the idea in your own words before checking an answer.',
              'Use the worked visual as a guide, then solve or classify a new example.',
            ],
          ),
        ],
        keyConceptTitle: 'Foundation checkpoint',
        keyConceptBody:
            'Master the meaning and basic application of $title before moving to the next lesson.',
      ),
      quiz: NorieQuizContent(
        questions: _questions(subject, level.label, title, core),
      ),
      challenge: NorieChallengeContent(
        title: '$title Challenge',
        description: 'Finish three quick checks without relying on hints.',
        xpPerCorrect: 25,
        rounds: _questions(subject, level.label, title, core).take(3).toList(),
      ),
    );
  }

  static List<String> _coreIdeas(String subject, String title, String level) {
    if (subject == 'Mathematics') {
      return [
        '$title is learned by identifying the quantities, relationships, or patterns in a problem.',
        'Use symbols, models, or diagrams to represent the information before calculating.',
        'Check each step and compare the result with the original conditions.',
        'A correct solution should be explainable, not only memorized.',
      ];
    }
    if (subject == 'English') {
      return [
        '$title develops accurate reading, writing, speaking, or language use at the $level level.',
        'Meaning depends on how words and sentences work together in context.',
        'Examples help reveal patterns in grammar, vocabulary, and communication.',
        'Strong language skills combine accuracy, clarity, and understanding.',
      ];
    }
    return [
      '$title is studied by observing evidence, identifying patterns, and connecting causes with effects.',
      'Scientific explanations should match observations and measurable evidence.',
      'Models and diagrams can make structures, systems, and processes easier to understand.',
      'New evidence can refine a scientific explanation.',
    ];
  }

  static List<NorieQuestionContent> _questions(
    String subject,
    String level,
    String title,
    List<String> ideas,
  ) {
    final questions = <NorieQuestionContent>[];
    for (var i = 0; i < 20; i++) {
      final idea = ideas[i % ideas.length];
      final type = i % 4;
      final prompt = switch (type) {
        0 => 'Which study habit best supports learning $title?',
        1 => 'What should you focus on first when working with $title?',
        2 => 'Which statement best describes a strong $level learning approach to $title?',
        _ => 'Why are examples and checks useful when learning $title?',
      };
      final correct = switch (subject) {
        'Mathematics' => type == 0
            ? 'Represent the information and check each step'
            : type == 1
                ? 'The quantities, relationships, and conditions'
                : type == 2
                    ? 'Understand the reasoning behind each step'
                    : 'They help test whether the reasoning fits the problem',
        'English' => type == 0
            ? 'Read examples in context and explain the pattern'
            : type == 1
                ? 'Meaning and how language is used in context'
                : type == 2
                    ? 'Combine accuracy with clear understanding'
                    : 'They show how language patterns work in context',
        _ => type == 0
            ? 'Connect observations with evidence'
            : type == 1
                ? 'Evidence, patterns, causes, and effects'
                : type == 2
                    ? 'Use evidence to support explanations'
                    : 'They help compare a model or explanation with evidence',
      };
      questions.add(
        NorieQuestionContent(
          id: '${title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}-q${i + 1}',
          prompt: prompt,
          options: [
            correct,
            'Memorize a choice without understanding it',
            'Ignore the conditions and examples',
            'Choose the longest answer automatically',
          ],
          correctIndex: 0,
          explanation: idea,
          difficulty: i < 7 ? 'foundation' : i < 15 ? 'intermediate' : 'advanced',
        ),
      );
    }
    return questions;
  }
}
