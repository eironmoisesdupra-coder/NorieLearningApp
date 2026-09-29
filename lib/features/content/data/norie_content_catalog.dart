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

        NorieQuestionContent(id: 'atomic-q6', prompt: 'Which particle has no electric charge?', options: ['Electron', 'Neutron', 'Proton', 'Ion'], correctIndex: 1, explanation: 'A neutron is electrically neutral.'),
        NorieQuestionContent(id: 'atomic-q7', prompt: 'An atom becomes a positive ion when it...', options: ['Gains electrons', 'Loses electrons', 'Gains neutrons', 'Loses protons'], correctIndex: 1, explanation: 'Losing electrons leaves a net positive charge.'),
        NorieQuestionContent(id: 'atomic-q8', prompt: 'An atom becomes a negative ion when it...', options: ['Gains electrons', 'Loses electrons', 'Gains protons', 'Loses neutrons'], correctIndex: 0, explanation: 'Gaining electrons produces a net negative charge.'),
        NorieQuestionContent(id: 'atomic-q9', prompt: 'Mass number equals the number of...', options: ['Protons + neutrons', 'Protons + electrons', 'Neutrons + electrons', 'Electrons only'], correctIndex: 0, explanation: 'Mass number is the sum of protons and neutrons.'),
        NorieQuestionContent(id: 'atomic-q10', prompt: 'An atom has 6 protons and 7 neutrons. Its mass number is...', options: ['6', '7', '13', '42'], correctIndex: 2, explanation: '6 + 7 = 13.'),
        NorieQuestionContent(id: 'atomic-q11', prompt: 'Which change creates a different isotope of the same element?', options: ['Changing neutron count', 'Changing proton count', 'Removing the nucleus', 'Changing atomic number'], correctIndex: 0, explanation: 'Isotopes retain the same proton count but differ in neutrons.'),
        NorieQuestionContent(id: 'atomic-q12', prompt: 'Atomic number 12 means the atom contains how many protons?', options: ['6', '12', '18', '24'], correctIndex: 1, explanation: 'Atomic number equals proton count.'),
        NorieQuestionContent(id: 'atomic-q13', prompt: 'Which particle has far less mass than a proton?', options: ['Electron', 'Neutron', 'Nucleus', 'Alpha particle'], correctIndex: 0, explanation: 'Electron mass is much smaller than proton mass.'),
        NorieQuestionContent(id: 'atomic-q14', prompt: 'What determines an element\'s identity?', options: ['Proton count', 'Neutron count', 'Ion charge', 'Mass number alone'], correctIndex: 0, explanation: 'The proton count uniquely determines the element.'),
        NorieQuestionContent(id: 'atomic-q15', prompt: 'A neutral atom has 11 electrons. It has how many protons?', options: ['10', '11', '12', '22'], correctIndex: 1, explanation: 'Neutral atoms have equal proton and electron counts.'),
        NorieQuestionContent(id: 'atomic-q16', prompt: 'Nearly all atomic mass is concentrated in the...', options: ['Nucleus', 'Electron cloud', 'Outer shell', 'Bond'], correctIndex: 0, explanation: 'The nucleus contains massive protons and neutrons.'),
        NorieQuestionContent(id: 'atomic-q17', prompt: 'An ion has 9 protons and 10 electrons. Its charge is...', options: ['1+', '1−', '9+', 'Neutral'], correctIndex: 1, explanation: 'One extra electron gives a 1− charge.'),
        NorieQuestionContent(id: 'atomic-q18', prompt: 'Electrons are found primarily...', options: ['In regions around the nucleus', 'Inside protons', 'Inside neutrons', 'Only between atoms'], correctIndex: 0, explanation: 'Electrons occupy regions around the nucleus.'),
        NorieQuestionContent(id: 'atomic-q19', prompt: 'Carbon-12 and carbon-14 differ in their number of...', options: ['Neutrons', 'Protons', 'Atomic numbers', 'Element symbols'], correctIndex: 0, explanation: 'They are isotopes with different neutron counts.'),
        NorieQuestionContent(id: 'atomic-q20', prompt: 'A neutral atom has 15 protons. How many electrons does it have?', options: ['15', '16', '30', '1'], correctIndex: 0, explanation: 'A neutral atom has equal proton and electron counts.'),
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

        NorieQuestionContent(id: 'periodic-q6', prompt: 'A vertical column on the periodic table is a...', options: ['Period', 'Group', 'Shell', 'Series'], correctIndex: 1, explanation: 'Vertical columns are groups.'),
        NorieQuestionContent(id: 'periodic-q7', prompt: 'The noble gases occupy...', options: ['Group 1', 'Group 2', 'Group 17', 'Group 18'], correctIndex: 3, explanation: 'Noble gases are Group 18.'),
        NorieQuestionContent(id: 'periodic-q8', prompt: 'The alkali metals occupy...', options: ['Group 1', 'Group 2', 'Group 17', 'Group 18'], correctIndex: 0, explanation: 'Alkali metals are Group 1 elements.'),
        NorieQuestionContent(id: 'periodic-q9', prompt: 'Most nonmetals are found toward the...', options: ['Upper right', 'Lower left', 'Center only', 'Bottom rows only'], correctIndex: 0, explanation: 'Most nonmetals occur toward the upper-right region.'),
        NorieQuestionContent(id: 'periodic-q10', prompt: 'Metalloids lie near the...', options: ['Stair-step boundary', 'Far-left edge', 'Group 18 only', 'Bottom edge'], correctIndex: 0, explanation: 'Metalloids cluster near the stair-step boundary.'),
        NorieQuestionContent(id: 'periodic-q11', prompt: 'Consecutive atomic numbers differ by how many protons?', options: ['1', '2', '8', '18'], correctIndex: 0, explanation: 'Each next atomic number adds one proton.'),
        NorieQuestionContent(id: 'periodic-q12', prompt: 'Elements in one period have the same number of occupied...', options: ['Principal electron shells', 'Protons', 'Neutrons', 'Valence electrons'], correctIndex: 0, explanation: 'Period number corresponds to occupied principal shells for ground-state atoms.'),
        NorieQuestionContent(id: 'periodic-q13', prompt: 'The center of the periodic table is dominated by...', options: ['Transition metals', 'Noble gases', 'Halogens', 'Nonmetals'], correctIndex: 0, explanation: 'Transition metals occupy the central d-block.'),
        NorieQuestionContent(id: 'periodic-q14', prompt: 'Atomic number uniquely fixes an element\'s...', options: ['Identity', 'Isotope', 'Physical state', 'Neutron count'], correctIndex: 0, explanation: 'Atomic number is proton count and identifies the element.'),
        NorieQuestionContent(id: 'periodic-q15', prompt: 'Which pair is in the same group?', options: ['Lithium and sodium', 'Sodium and magnesium', 'Carbon and nitrogen', 'Fluorine and neon'], correctIndex: 0, explanation: 'Lithium and sodium are both in Group 1.'),
        NorieQuestionContent(id: 'periodic-q16', prompt: 'Which pair consists of halogens?', options: ['Fluorine and chlorine', 'Helium and neon', 'Lithium and sodium', 'Magnesium and calcium'], correctIndex: 0, explanation: 'Fluorine and chlorine are Group 17 halogens.'),
        NorieQuestionContent(id: 'periodic-q17', prompt: 'Which pair consists of noble gases?', options: ['Neon and argon', 'Fluorine and chlorine', 'Sodium and potassium', 'Oxygen and sulfur'], correctIndex: 0, explanation: 'Neon and argon are Group 18 noble gases.'),
        NorieQuestionContent(id: 'periodic-q18', prompt: 'Across a period from left to right, atomic number...', options: ['Increases', 'Decreases', 'Stays constant', 'Becomes zero'], correctIndex: 0, explanation: 'Periodic-table order follows increasing atomic number.'),
        NorieQuestionContent(id: 'periodic-q19', prompt: 'Periodicity means that element properties...', options: ['Recur in patterns', 'Are all identical', 'Never change', 'Depend only on neutrons'], correctIndex: 0, explanation: 'Periodic properties recur in recognizable patterns.'),
        NorieQuestionContent(id: 'periodic-q20', prompt: 'Calcium in Group 2 is classified as a...', options: ['Metal', 'Nonmetal', 'Noble gas', 'Halogen'], correctIndex: 0, explanation: 'Calcium is an alkaline-earth metal.'),
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

        NorieQuestionContent(id: 'bond-q6', prompt: 'Which bonding model involves electron transfer?', options: ['Ionic', 'Covalent', 'Metallic', 'Nuclear'], correctIndex: 0, explanation: 'Ionic bonding follows electron transfer and ion attraction.'),
        NorieQuestionContent(id: 'bond-q7', prompt: 'Which bonding model involves shared electron pairs?', options: ['Covalent', 'Ionic', 'Metallic', 'Nuclear'], correctIndex: 0, explanation: 'Covalent bonds involve shared electron pairs.'),
        NorieQuestionContent(id: 'bond-q8', prompt: 'Electrical conductivity in solid metals is explained by...', options: ['Delocalized electrons', 'Transferred neutrons', 'Fixed electrons only', 'Shared protons'], correctIndex: 0, explanation: 'Mobile delocalized electrons carry charge through metals.'),
        NorieQuestionContent(id: 'bond-q9', prompt: 'A sodium atom that loses one electron becomes...', options: ['Na⁺', 'Na⁻', 'Cl⁺', 'Neutral Na'], correctIndex: 0, explanation: 'Losing one electron gives sodium a +1 charge.'),
        NorieQuestionContent(id: 'bond-q10', prompt: 'A chlorine atom that gains one electron becomes...', options: ['Cl⁻', 'Cl⁺', 'Na⁺', 'Neutral Cl'], correctIndex: 0, explanation: 'Gaining one electron gives chlorine a −1 charge.'),
        NorieQuestionContent(id: 'bond-q11', prompt: 'Which pair is most likely to form an ionic compound?', options: ['Sodium and chlorine', 'Hydrogen and oxygen', 'Carbon and oxygen', 'Nitrogen and oxygen'], correctIndex: 0, explanation: 'A metal and nonmetal commonly form an ionic compound.'),
        NorieQuestionContent(id: 'bond-q12', prompt: 'Which pair is most likely to form a covalent bond?', options: ['Carbon and oxygen', 'Sodium and chlorine', 'Magnesium and oxygen', 'Potassium and bromine'], correctIndex: 0, explanation: 'Two nonmetals commonly share electrons.'),
        NorieQuestionContent(id: 'bond-q13', prompt: 'Why can many metals be bent without immediately breaking?', options: ['Metal ions can shift while delocalized electrons maintain attraction', 'Neutrons transfer between atoms', 'Metals contain no electrons', 'Protons leave the nuclei'], correctIndex: 0, explanation: 'Metallic bonding remains attractive as layers of metal ions shift.'),
        NorieQuestionContent(id: 'bond-q14', prompt: 'Which substance has covalent bonds within its molecules?', options: ['H₂O', 'NaCl', 'MgO', 'KBr'], correctIndex: 0, explanation: 'Water has covalent O–H bonds.'),
        NorieQuestionContent(id: 'bond-q15', prompt: 'What holds ions together in an ionic solid?', options: ['Electrostatic attraction', 'Shared neutrons', 'Gravity alone', 'Nuclear fusion'], correctIndex: 0, explanation: 'Oppositely charged ions attract electrostatically.'),
        NorieQuestionContent(id: 'bond-q16', prompt: 'A single covalent bond contains...', options: ['One shared electron pair', 'Two shared electron pairs', 'Three shared electron pairs', 'One transferred proton'], correctIndex: 0, explanation: 'A single bond is one shared electron pair.'),
        NorieQuestionContent(id: 'bond-q17', prompt: 'A double covalent bond contains...', options: ['Two shared electron pairs', 'One shared electron pair', 'Three shared electron pairs', 'Two transferred protons'], correctIndex: 0, explanation: 'A double bond is two shared electron pairs.'),
        NorieQuestionContent(id: 'bond-q18', prompt: 'A triple covalent bond contains...', options: ['Three shared electron pairs', 'One shared electron pair', 'Two shared electron pairs', 'Three transferred protons'], correctIndex: 0, explanation: 'A triple bond is three shared electron pairs.'),
        NorieQuestionContent(id: 'bond-q19', prompt: 'Ionic compounds are composed primarily of...', options: ['Cations and anions', 'Only neutral metal atoms', 'Only neutrons', 'Free nuclei'], correctIndex: 0, explanation: 'Ionic compounds contain positively and negatively charged ions.'),
        NorieQuestionContent(id: 'bond-q20', prompt: 'Valence electrons are the electrons...', options: ['Most directly involved in bonding', 'Inside the nucleus', 'That determine neutron count', 'With positive charge'], correctIndex: 0, explanation: 'Valence electrons are the outer electrons most involved in bonding.'),
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

        NorieQuestionContent(id: 'acid-q6', prompt: 'At 25 °C, which pH is basic?', options: ['10', '7', '5', '2'], correctIndex: 0, explanation: 'At 25 °C, pH above 7 is basic.'),
        NorieQuestionContent(id: 'acid-q7', prompt: 'A Brønsted–Lowry reaction transfers a...', options: ['Proton', 'Neutron', 'Photon', 'Nucleus'], correctIndex: 0, explanation: 'Brønsted–Lowry acid–base reactions transfer H⁺.'),
        NorieQuestionContent(id: 'acid-q8', prompt: 'After an acid donates H⁺, it becomes its...', options: ['Conjugate base', 'Conjugate acid', 'Isotope', 'Catalyst'], correctIndex: 0, explanation: 'Loss of H⁺ converts an acid into its conjugate base.'),
        NorieQuestionContent(id: 'acid-q9', prompt: 'After a base accepts H⁺, it becomes its...', options: ['Conjugate acid', 'Conjugate base', 'Isotope', 'Metal'], correctIndex: 0, explanation: 'Acceptance of H⁺ converts a base into its conjugate acid.'),
        NorieQuestionContent(id: 'acid-q10', prompt: 'A strong acid is one that...', options: ['Ionizes extensively in water', 'Must always be concentrated', 'Has no conjugate base', 'Cannot react with bases'], correctIndex: 0, explanation: 'Strength describes extent of ionization.'),
        NorieQuestionContent(id: 'acid-q11', prompt: 'A weak acid generally...', options: ['Ionizes only partially in water', 'Can never be concentrated', 'Always has pH 7', 'Contains no hydrogen'], correctIndex: 0, explanation: 'Weak acids ionize only partially.'),
        NorieQuestionContent(id: 'acid-q12', prompt: 'Amount of solute per unit volume describes...', options: ['Concentration', 'Acid strength', 'Conjugate pairing', 'Proton identity'], correctIndex: 0, explanation: 'Concentration measures amount per volume.'),
        NorieQuestionContent(id: 'acid-q13', prompt: 'Which can act as a Brønsted–Lowry base?', options: ['A proton acceptor', 'Only a substance containing OH⁻', 'Only a metal', 'Only a neutral molecule'], correctIndex: 0, explanation: 'Any species capable of accepting H⁺ can be a Brønsted–Lowry base.'),
        NorieQuestionContent(id: 'acid-q14', prompt: 'At 25 °C, a solution at pH 7 is classified as...', options: ['Neutral', 'Acidic', 'Basic', 'Always concentrated'], correctIndex: 0, explanation: 'At 25 °C, pH 7 is neutral.'),
        NorieQuestionContent(id: 'acid-q15', prompt: 'At 25 °C, a solution at pH 4 is...', options: ['Acidic', 'Neutral', 'Basic', 'A metal'], correctIndex: 0, explanation: 'At 25 °C, pH below 7 is acidic.'),
        NorieQuestionContent(id: 'acid-q16', prompt: 'At 25 °C, a solution at pH 11 is...', options: ['Basic', 'Neutral', 'Acidic', 'An isotope'], correctIndex: 0, explanation: 'At 25 °C, pH above 7 is basic.'),
        NorieQuestionContent(id: 'acid-q17', prompt: 'In HCl + H₂O → H₃O⁺ + Cl⁻, HCl acts as the...', options: ['Acid', 'Base', 'Conjugate acid', 'Neutral salt'], correctIndex: 0, explanation: 'HCl donates H⁺ to water, so it acts as the acid.'),
        NorieQuestionContent(id: 'acid-q18', prompt: 'In HCl + H₂O → H₃O⁺ + Cl⁻, H₂O acts as the...', options: ['Base', 'Acid', 'Conjugate base', 'Metal'], correctIndex: 0, explanation: 'Water accepts H⁺, so it acts as the base.'),
        NorieQuestionContent(id: 'acid-q19', prompt: 'Which statement is correct?', options: ['A dilute acid can still be strong', 'Every concentrated acid is strong', 'Every weak acid is dilute', 'Strength equals concentration'], correctIndex: 0, explanation: 'Strength and concentration describe different properties.'),
        NorieQuestionContent(id: 'acid-q20', prompt: 'Which statement best describes conjugate acid–base pairs?', options: ['They differ by one H⁺', 'They differ by one neutron', 'They always have equal pH', 'They must both be neutral'], correctIndex: 0, explanation: 'A conjugate acid–base pair differs by one proton.'),
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
