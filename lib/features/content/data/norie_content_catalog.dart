import '../domain/norie_content_models.dart';

abstract final class NorieContentCatalog {
  static const atomicStructure = NorieTopicContent(
    id: 'science.chemistry.atomic-structure',
    subject: 'Science',
    category: 'Chemistry',
    title: 'Atomic Structure',
    subtitle: 'Protons, neutrons, electrons, and atomic number',
    order: 1,
    accent: 'cyan',
    lesson: NorieLessonContent(
      heading: 'Inside the atom',
      introduction:
          'Atoms are made of smaller particles. Understanding how those particles are arranged explains atomic number, charge, ions, isotopes, and much more.',
      sections: [
        NorieLessonSection(
          title: 'Proton',
          symbol: '+',
          accent: 'magenta',
          points: [
            'Positive electric charge',
            'Located in the nucleus',
            'Number of protons determines the element',
          ],
        ),
        NorieLessonSection(
          title: 'Neutron',
          symbol: '0',
          accent: 'cyan',
          points: [
            'No electric charge',
            'Located in the nucleus',
            'Changes in neutron count create isotopes',
          ],
        ),
        NorieLessonSection(
          title: 'Electron',
          symbol: '−',
          accent: 'green',
          points: [
            'Negative electric charge',
            'Occupies regions around the nucleus',
            'Electron changes are involved in ion formation and bonding',
          ],
        ),
      ],
      keyConceptTitle: 'Atomic number = number of protons',
      keyConceptBody:
          'For a neutral atom, the number of electrons equals the number of protons.',
      completionXp: 50,
    ),
    quiz: NorieQuizContent(
      xpPerCorrect: 20,
      questions: [
        NorieQuestionContent(
          id: 'atomic-q1',
          prompt: 'Which particle determines an element\'s atomic number?',
          options: ['Electron', 'Proton', 'Neutron', 'Ion'],
          correctIndex: 1,
          explanation:
              'Atomic number is defined by the number of protons in the nucleus.',
        ),
        NorieQuestionContent(
          id: 'atomic-q2',
          prompt: 'Which subatomic particle has a negative charge?',
          options: ['Proton', 'Neutron', 'Electron', 'Nucleus'],
          correctIndex: 2,
          explanation:
              'Electrons carry negative charge and occupy regions around the nucleus.',
        ),
        NorieQuestionContent(
          id: 'atomic-q3',
          prompt: 'Where are protons and neutrons located?',
          options: [
            'Electron cloud',
            'Nucleus',
            'Outer shell only',
            'Between atoms',
          ],
          correctIndex: 1,
          explanation:
              'Protons and neutrons are concentrated in the atomic nucleus.',
        ),
        NorieQuestionContent(
          id: 'atomic-q4',
          prompt: 'A neutral atom has 8 protons. How many electrons does it have?',
          options: ['4', '8', '10', '16'],
          correctIndex: 1,
          explanation:
              'A neutral atom has equal numbers of positive protons and negative electrons.',
        ),
        NorieQuestionContent(
          id: 'atomic-q5',
          prompt:
              'Atoms of the same element with different neutron counts are called...',
          options: ['Ions', 'Compounds', 'Isotopes', 'Molecules'],
          correctIndex: 2,
          explanation:
              'Isotopes have the same proton count but different numbers of neutrons.',
        ),
      ],
    ),
    challenge: NorieChallengeContent(
      title: 'Atom Builder Challenge',
      description:
          'Use each clue to identify the correct subatomic particle.',
      xpPerCorrect: 25,
      rounds: [
        NorieQuestionContent(
          id: 'atomic-c1',
          prompt: 'I am positive and found in the nucleus.',
          options: ['Proton', 'Neutron', 'Electron'],
          correctIndex: 0,
          explanation:
              'A proton has positive charge and is located in the nucleus.',
        ),
        NorieQuestionContent(
          id: 'atomic-c2',
          prompt: 'I have no charge and can change the isotope.',
          options: ['Proton', 'Neutron', 'Electron'],
          correctIndex: 1,
          explanation:
              'Neutrons are uncharged, and different neutron counts create isotopes.',
        ),
        NorieQuestionContent(
          id: 'atomic-c3',
          prompt: 'I am negative and occupy regions around the nucleus.',
          options: ['Proton', 'Neutron', 'Electron'],
          correctIndex: 2,
          explanation:
              'Electrons carry negative charge and occupy regions around the nucleus.',
        ),
      ],
    ),
  );

  static const chemistryTopics = <NorieTopicContent>[
    atomicStructure,
    NorieTopicContent(
      id: 'science.chemistry.periodic-table',
      subject: 'Science',
      category: 'Chemistry',
      title: 'Periodic Table',
      subtitle: 'Elements, groups, periods, and trends',
      order: 2,
      accent: 'green',
      available: false,
      lesson: NorieLessonContent(
        heading: 'Periodic Table',
        introduction: '',
        sections: [],
        keyConceptTitle: '',
        keyConceptBody: '',
      ),
      quiz: NorieQuizContent(questions: []),
      challenge: NorieChallengeContent(
        title: 'Periodic Table Challenge',
        description: '',
        rounds: [],
      ),
    ),
    NorieTopicContent(
      id: 'science.chemistry.chemical-bonding',
      subject: 'Science',
      category: 'Chemistry',
      title: 'Chemical Bonding',
      subtitle: 'Ionic, covalent, metallic, and intermolecular forces',
      order: 3,
      accent: 'orange',
      available: false,
      lesson: NorieLessonContent(
        heading: 'Chemical Bonding',
        introduction: '',
        sections: [],
        keyConceptTitle: '',
        keyConceptBody: '',
      ),
      quiz: NorieQuizContent(questions: []),
      challenge: NorieChallengeContent(
        title: 'Chemical Bonding Challenge',
        description: '',
        rounds: [],
      ),
    ),
    NorieTopicContent(
      id: 'science.chemistry.chemical-reactions',
      subject: 'Science',
      category: 'Chemistry',
      title: 'Chemical Reactions',
      subtitle: 'Equations, reaction types, and stoichiometry',
      order: 4,
      accent: 'magenta',
      available: false,
      lesson: NorieLessonContent(
        heading: 'Chemical Reactions',
        introduction: '',
        sections: [],
        keyConceptTitle: '',
        keyConceptBody: '',
      ),
      quiz: NorieQuizContent(questions: []),
      challenge: NorieChallengeContent(
        title: 'Chemical Reactions Challenge',
        description: '',
        rounds: [],
      ),
    ),
  ];

  static const science = NorieSubjectContent(
    id: 'science',
    title: 'Science',
    description: 'Understand the world from atoms to ecosystems.',
    categories: [
      NorieCategoryContent(
        id: 'chemistry',
        title: 'Chemistry',
        description: 'Matter, atoms, reactions, equilibrium, and more',
        topics: chemistryTopics,
      ),
    ],
  );

  static const subjects = <NorieSubjectContent>[science];

  static NorieTopicContent? topicById(String id) {
    for (final subject in subjects) {
      for (final category in subject.categories) {
        for (final topic in category.topics) {
          if (topic.id == id) return topic;
        }
      }
    }
    return null;
  }

  static List<NorieTopicContent> topicsForCategory(String category) {
    return [
      for (final subject in subjects)
        for (final group in subject.categories)
          if (group.title == category) ...group.topics,
    ];
  }
}
