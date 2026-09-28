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
          prompt:
              'A neutral atom has 8 protons. How many electrons does it have?',
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
          prompt:
              'I am negative and occupy regions around the nucleus.',
          options: ['Proton', 'Neutron', 'Electron'],
          correctIndex: 2,
          explanation:
              'Electrons carry negative charge and occupy regions around the nucleus.',
        ),
      ],
    ),
  );

  static const periodicTable = NorieTopicContent(
    id: 'science.chemistry.periodic-table',
    subject: 'Science',
    category: 'Chemistry',
    title: 'Periodic Table',
    subtitle: 'Elements, groups, periods, and recurring trends',
    order: 2,
    accent: 'green',
    prerequisiteTopicId: 'science.chemistry.atomic-structure',
    lesson: NorieLessonContent(
      heading: 'Reading the periodic table',
      introduction:
          'The periodic table organizes elements by increasing atomic number and places elements with recurring chemical behavior into useful patterns.',
      sections: [
        NorieLessonSection(
          title: 'Periods',
          symbol: '↔',
          accent: 'cyan',
          points: [
            'Periods are horizontal rows',
            'Atomic number increases as you move across a period',
            'Properties change in patterns from left to right',
          ],
        ),
        NorieLessonSection(
          title: 'Groups',
          symbol: '↕',
          accent: 'green',
          points: [
            'Groups are vertical columns',
            'Elements in the same group often have similar chemical behavior',
            'Main-group elements often share related valence-electron patterns',
          ],
        ),
        NorieLessonSection(
          title: 'Regions',
          symbol: '▦',
          accent: 'orange',
          points: [
            'Most metals are on the left and center',
            'Nonmetals are mainly on the upper right',
            'Metalloids lie near the stair-step boundary',
          ],
        ),
      ],
      keyConceptTitle: 'Position helps predict properties',
      keyConceptBody:
          'An element\'s group, period, and region provide clues about its electron arrangement and chemical behavior.',
    ),
    quiz: NorieQuizContent(
      questions: [
        NorieQuestionContent(
          id: 'periodic-q1',
          prompt:
              'What is a horizontal row on the periodic table called?',
          options: ['Group', 'Period', 'Family block', 'Series column'],
          correctIndex: 1,
          explanation: 'A horizontal row is called a period.',
        ),
        NorieQuestionContent(
          id: 'periodic-q2',
          prompt:
              'Elements in the same vertical group often have what in common?',
          options: [
            'Exactly the same mass',
            'Similar chemical behavior',
            'The same atomic number',
            'The same number of neutrons',
          ],
          correctIndex: 1,
          explanation:
              'Elements in the same group often have related valence-electron patterns and similar chemical behavior.',
        ),
        NorieQuestionContent(
          id: 'periodic-q3',
          prompt:
              'The periodic table is arranged primarily by increasing...',
          options: ['Atomic number', 'Mass number', 'Neutron count', 'Density'],
          correctIndex: 0,
          explanation:
              'Modern periodic order follows increasing atomic number, the number of protons.',
        ),
        NorieQuestionContent(
          id: 'periodic-q4',
          prompt: 'Which group contains the halogens?',
          options: ['Group 1', 'Group 2', 'Group 17', 'Group 18'],
          correctIndex: 2,
          explanation:
              'The halogens occupy Group 17 of the periodic table.',
        ),
        NorieQuestionContent(
          id: 'periodic-q5',
          prompt:
              'Where are most metals located on the periodic table?',
          options: [
            'Left and center',
            'Upper-right corner only',
            'Along Group 18 only',
            'Outside the main table',
          ],
          correctIndex: 0,
          explanation:
              'Most metals occupy the left side and center of the periodic table.',
        ),
      ],
    ),
    challenge: NorieChallengeContent(
      title: 'Periodic Pattern Challenge',
      description:
          'Match each clue to the periodic-table idea it describes.',
      rounds: [
        NorieQuestionContent(
          id: 'periodic-c1',
          prompt:
              'I am a vertical column whose elements often share similar chemical behavior.',
          options: ['Group', 'Period', 'Atomic number'],
          correctIndex: 0,
          explanation: 'A vertical column is a group.',
        ),
        NorieQuestionContent(
          id: 'periodic-c2',
          prompt: 'I am a horizontal row across the periodic table.',
          options: ['Group', 'Period', 'Atomic number'],
          correctIndex: 1,
          explanation: 'A horizontal row is a period.',
        ),
        NorieQuestionContent(
          id: 'periodic-c3',
          prompt:
              'I equal the number of protons and determine an element\'s identity.',
          options: ['Group', 'Period', 'Atomic number'],
          correctIndex: 2,
          explanation: 'Atomic number equals the proton count.',
        ),
      ],
    ),
  );

  static const chemicalBonding = NorieTopicContent(
    id: 'science.chemistry.chemical-bonding',
    subject: 'Science',
    category: 'Chemistry',
    title: 'Chemical Bonding',
    subtitle: 'Ionic, covalent, and metallic bonding',
    order: 3,
    accent: 'orange',
    prerequisiteTopicId: 'science.chemistry.periodic-table',
    lesson: NorieLessonContent(
      heading: 'Why atoms bond',
      introduction:
          'Chemical bonds form through interactions involving valence electrons. Different electron behaviors produce ionic, covalent, and metallic bonding.',
      sections: [
        NorieLessonSection(
          title: 'Ionic bonding',
          symbol: '±',
          accent: 'magenta',
          points: [
            'Commonly forms between metals and nonmetals',
            'Electrons are transferred between atoms',
            'Oppositely charged ions attract each other',
          ],
        ),
        NorieLessonSection(
          title: 'Covalent bonding',
          symbol: '—',
          accent: 'cyan',
          points: [
            'Commonly forms between nonmetals',
            'Atoms share one or more pairs of electrons',
            'Shared electrons help atoms reach more stable arrangements',
          ],
        ),
        NorieLessonSection(
          title: 'Metallic bonding',
          symbol: 'M',
          accent: 'orange',
          points: [
            'Occurs among metal atoms',
            'Valence electrons are delocalized through the metal',
            'Mobile electrons help explain conductivity and malleability',
          ],
        ),
      ],
      keyConceptTitle: 'Bond type depends on electron behavior',
      keyConceptBody:
          'Electron transfer leads to ionic attraction, electron sharing forms covalent bonds, and delocalized electrons characterize metallic bonding.',
    ),
    quiz: NorieQuizContent(
      questions: [
        NorieQuestionContent(
          id: 'bond-q1',
          prompt:
              'Which compound is a common example of ionic bonding?',
          options: ['NaCl', 'O₂', 'CH₄', 'H₂'],
          correctIndex: 0,
          explanation:
              'Sodium chloride consists of oppositely charged ions formed after electron transfer.',
        ),
        NorieQuestionContent(
          id: 'bond-q2',
          prompt: 'What happens to electrons in a covalent bond?',
          options: [
            'They are shared',
            'They disappear',
            'They become neutrons',
            'They remain only in one nucleus',
          ],
          correctIndex: 0,
          explanation:
              'Covalent bonds involve sharing electron pairs between atoms.',
        ),
        NorieQuestionContent(
          id: 'bond-q3',
          prompt:
              'Ionic bonding is best described as attraction between...',
          options: [
            'Neutral molecules only',
            'Oppositely charged ions',
            'Two neutron clouds',
            'Identical nuclei',
          ],
          correctIndex: 1,
          explanation:
              'Positive and negative ions attract electrostatically in ionic compounds.',
        ),
        NorieQuestionContent(
          id: 'bond-q4',
          prompt:
              'Which feature is characteristic of metallic bonding?',
          options: [
            'Localized proton pairs',
            'Delocalized valence electrons',
            'Transferred neutrons',
            'No electron interaction',
          ],
          correctIndex: 1,
          explanation:
              'Metallic bonding involves valence electrons that are mobile and delocalized across many metal atoms.',
        ),
        NorieQuestionContent(
          id: 'bond-q5',
          prompt:
              'A bond between two nonmetal atoms is most commonly...',
          options: ['Covalent', 'Metallic', 'Nuclear', 'Gravitational'],
          correctIndex: 0,
          explanation:
              'Nonmetal atoms commonly share electrons and form covalent bonds.',
        ),
      ],
    ),
    challenge: NorieChallengeContent(
      title: 'Bond Type Challenge',
      description:
          'Classify each clue by its dominant bonding model.',
      rounds: [
        NorieQuestionContent(
          id: 'bond-c1',
          prompt:
              'Electrons are transferred, producing positive and negative ions.',
          options: ['Ionic', 'Covalent', 'Metallic'],
          correctIndex: 0,
          explanation:
              'Electron transfer and ion attraction describe ionic bonding.',
        ),
        NorieQuestionContent(
          id: 'bond-c2',
          prompt: 'Two nonmetal atoms share electron pairs.',
          options: ['Ionic', 'Covalent', 'Metallic'],
          correctIndex: 1,
          explanation:
              'Electron sharing describes covalent bonding.',
        ),
        NorieQuestionContent(
          id: 'bond-c3',
          prompt:
              'Many metal atoms share a mobile pool of delocalized electrons.',
          options: ['Ionic', 'Covalent', 'Metallic'],
          correctIndex: 2,
          explanation:
              'Delocalized electrons are central to metallic bonding.',
        ),
      ],
    ),
  );

  static const acidsBases = NorieTopicContent(
    id: 'science.chemistry.acids-bases',
    subject: 'Science',
    category: 'Chemistry',
    title: 'Acids & Bases',
    subtitle: 'Proton transfer, pH, and acid–base behavior',
    order: 4,
    accent: 'magenta',
    prerequisiteTopicId: 'science.chemistry.chemical-bonding',
    lesson: NorieLessonContent(
      heading: 'Understanding acids and bases',
      introduction:
          'Acid–base chemistry can be described through how substances behave in water and how they transfer protons. pH provides a useful measure of acidity or basicity in aqueous solutions.',
      sections: [
        NorieLessonSection(
          title: 'Brønsted acid',
          symbol: 'H⁺',
          accent: 'magenta',
          points: [
            'A Brønsted–Lowry acid donates a proton',
            'Acids can transfer H⁺ to a base',
            'Acid strength is related to extent of ionization, not simply concentration',
          ],
        ),
        NorieLessonSection(
          title: 'Brønsted base',
          symbol: 'B',
          accent: 'cyan',
          points: [
            'A Brønsted–Lowry base accepts a proton',
            'Bases react with proton donors',
            'A base may be neutral or negatively charged',
          ],
        ),
        NorieLessonSection(
          title: 'pH',
          symbol: 'pH',
          accent: 'green',
          points: [
            'At 25 °C, pH below 7 is acidic',
            'At 25 °C, pH 7 is neutral for pure water',
            'At 25 °C, pH above 7 is basic',
          ],
        ),
      ],
      keyConceptTitle: 'Acid donates H⁺; base accepts H⁺',
      keyConceptBody:
          'In Brønsted–Lowry theory, acid–base reactions are proton-transfer reactions.',
    ),
    quiz: NorieQuizContent(
      questions: [
        NorieQuestionContent(
          id: 'acid-q1',
          prompt:
              'In Brønsted–Lowry theory, an acid is a substance that...',
          options: [
            'Donates a proton',
            'Accepts a proton',
            'Donates a neutron',
            'Accepts an electron pair only',
          ],
          correctIndex: 0,
          explanation: 'A Brønsted–Lowry acid donates H⁺.',
        ),
        NorieQuestionContent(
          id: 'acid-q2',
          prompt:
              'In Brønsted–Lowry theory, a base is a substance that...',
          options: [
            'Accepts a proton',
            'Donates a proton',
            'Creates protons',
            'Always contains OH⁻',
          ],
          correctIndex: 0,
          explanation:
              'A Brønsted–Lowry base accepts H⁺; it does not have to contain hydroxide.',
        ),
        NorieQuestionContent(
          id: 'acid-q3',
          prompt: 'At 25 °C, which pH value is acidic?',
          options: ['3', '7', '9', '12'],
          correctIndex: 0,
          explanation:
              'At 25 °C, aqueous solutions with pH below 7 are acidic.',
        ),
        NorieQuestionContent(
          id: 'acid-q4',
          prompt: 'At 25 °C, pure water is approximately...',
          options: ['pH 2', 'pH 5', 'pH 7', 'pH 12'],
          correctIndex: 2,
          explanation:
              'Pure water is neutral and has pH about 7 at 25 °C.',
        ),
        NorieQuestionContent(
          id: 'acid-q5',
          prompt:
              'Which statement best distinguishes acid strength from concentration?',
          options: [
            'Strength describes extent of ionization; concentration describes amount per volume',
            'Strength and concentration always mean the same thing',
            'Strong acids must always be concentrated',
            'Weak acids cannot be concentrated',
          ],
          correctIndex: 0,
          explanation:
              'Strength concerns ionization behavior, while concentration concerns how much solute is present per volume.',
        ),
      ],
    ),
    challenge: NorieChallengeContent(
      title: 'Acid–Base Identity Challenge',
      description:
          'Use each clue to identify whether it describes an acid, base, or neutral water at 25 °C.',
      rounds: [
        NorieQuestionContent(
          id: 'acid-c1',
          prompt: 'I donate H⁺ in a Brønsted–Lowry reaction.',
          options: ['Acid', 'Base', 'Neutral'],
          correctIndex: 0,
          explanation:
              'A proton donor is a Brønsted–Lowry acid.',
        ),
        NorieQuestionContent(
          id: 'acid-c2',
          prompt: 'I accept H⁺ in a Brønsted–Lowry reaction.',
          options: ['Acid', 'Base', 'Neutral'],
          correctIndex: 1,
          explanation:
              'A proton acceptor is a Brønsted–Lowry base.',
        ),
        NorieQuestionContent(
          id: 'acid-c3',
          prompt:
              'I describe pure water at about pH 7 at 25 °C.',
          options: ['Acid', 'Base', 'Neutral'],
          correctIndex: 2,
          explanation:
              'Pure water at 25 °C is neutral at approximately pH 7.',
        ),
      ],
    ),
  );

  static const chemistryTopics = <NorieTopicContent>[
    atomicStructure,
    periodicTable,
    chemicalBonding,
    acidsBases,
  ];

  static const science = NorieSubjectContent(
    id: 'science',
    title: 'Science',
    description: 'Understand the world from atoms to ecosystems.',
    categories: [
      NorieCategoryContent(
        id: 'chemistry',
        title: 'Chemistry',
        description:
            'Matter, atoms, bonding, acids and bases, and more',
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
          if (group.title == category || group.id == category) ...group.topics,
    ];
  }
}
