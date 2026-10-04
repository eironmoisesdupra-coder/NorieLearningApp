import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';
import 'grade_9_plate_tectonics.dart';

final List<NorieTopicContent> grade9ScienceTopics = [
  _biologyFoundations,
  _atomicStructure,
  _chemicalBonding,
  _motionForces,
  grade9PlateTectonicsTopic,
];

const Map<String, ScienceFigure> grade9ScienceFigures = {
  'sci-g9-1-feedback': ScienceFigure(
      picture: 'g9-biology',
      title: 'A response reduces the original temperature disturbance',
      kind: 'process',
      labels: [
        'Temperature rises',
        'Control signals',
        'Heat loss increases',
        'Response decreases'
      ],
      details: [
        'Receptors detect departure from the regulated range.',
        'The control center signals effectors including sweat glands.',
        'Evaporation of sweat transfers heat away from skin.',
        'As temperature returns toward its range, the cooling response diminishes.'
      ],
      note:
          'A simplified negative-feedback model, not a medical temperature guide. Negative means opposing the disturbance.'),
  'sci-g9-1-transport': ScienceFigure(
      title: 'Identify what moves and what supplies the energy',
      kind: 'comparison',
      labels: ['Diffusion', 'Osmosis', 'Active transport'],
      details: [
        'Net particle movement down a concentration gradient; some substances use membrane proteins.',
        'Net water movement across a selectively permeable membrane toward the more concentrated nonpenetrating solute solution in this model.',
        'An energy-coupled protein can move a substance against its gradient.'
      ],
      note:
          'For the osmosis comparison, equal pressure and a membrane impermeable to the solute are assumed. Charged particles also respond to electrical gradients.'),
  'sci-g9-1-energy': ScienceFigure(
      title: 'Connect matter exchange with cellular work',
      kind: 'process',
      labels: ['Photosynthesis', 'Aerobic respiration', 'ATP-supported work'],
      details: [
        'Light energy helps build sugars from carbon dioxide and water, releasing oxygen.',
        'Glucose and oxygen are used; carbon dioxide and water form, and some released energy supports ATP production.',
        'ATP turnover supports transport and synthesis; energy ultimately disperses as heat.'
      ],
      note:
          'Plants carry out both photosynthesis and respiration. Matter cycles; energy must enter and eventually leaves as heat. These are overall summaries, not single reaction steps.'),
  'sci-g9-2-particles': ScienceFigure(
      title: 'Count charge and mass separately',
      kind: 'comparison',
      labels: ['Proton', 'Neutron', 'Electron'],
      details: [
        'Charge +1; located in the nucleus; about 1 u.',
        'Charge 0; located in the nucleus; about 1 u.',
        'Charge −1; occupies regions outside the nucleus; much less than 1 u.'
      ],
      note:
          'Atomic number counts protons. Mass number counts protons plus neutrons, not electron shells.'),
  'sci-g9-2-isotopes': ScienceFigure(
      picture: 'g9-atom',
      title: 'Carbon identity survives a neutron change',
      kind: 'comparison',
      labels: ['Neutral carbon-12', 'Neutral carbon-14', 'Same element'],
      details: [
        '6 protons, 6 neutrons and 6 electrons: mass number 12.',
        '6 protons, 8 neutrons and 6 electrons: mass number 14.',
        'Both have atomic number 6; differing neutron counts make them isotopes.'
      ],
      note:
          'Particle symbols and electron regions are schematic, not scale or fixed planetary orbits. Carbon-14 is radioactive; isotope does not mean every isotope is radioactive.'),
  'sci-g9-2-mass': ScienceFigure(
      title: 'Weight isotope masses by their abundance',
      kind: 'comparison',
      labels: ['75% at 20.0 u', '25% at 22.0 u', 'Mean = 20.5 u'],
      details: [
        '0.75 × 20.0 contributes 15.0 u to the weighted mean.',
        '0.25 × 22.0 contributes 5.5 u to the weighted mean.',
        '15.0 + 5.5 = 20.5 u, closer to the more abundant isotope.'
      ],
      note:
          'Invented two-isotope element and approximate masses for arithmetic. No individual atom needs to have the mean mass.'),
  'sci-g9-3-valence': ScienceFigure(
      title: 'Track outer-shell electrons in simple models',
      kind: 'comparison',
      labels: ['Sodium: 2,8,1', 'Chlorine: 2,8,7', 'Hydrogen: 1'],
      details: [
        'Losing one electron produces Na+ with a filled outer shell in this model.',
        'Gaining one electron produces Cl− with a filled outer shell in this model.',
        'Two H atoms can share one pair, giving each access to two electrons.'
      ],
      note:
          'Shell counts are introductory models for these examples. The octet rule is useful but has exceptions; hydrogen uses a two-electron first shell.'),
  'sci-g9-3-ionic': ScienceFigure(
      picture: 'g9-bonding',
      title: 'A lattice ratio differs from a discrete molecule',
      kind: 'comparison',
      labels: [
        'Sodium chloride lattice',
        'Hydrogen molecule',
        'Read the formula'
      ],
      details: [
        'Many alternating Na+ and Cl− ions attract in an extended structure.',
        'Two H atoms share an electron pair within a discrete H2 molecule.',
        'NaCl gives a 1:1 ionic ratio; H2 gives two atoms in each molecule.'
      ],
      note:
          'A flat lattice is a small slice of a three-dimensional structure. Neighboring ions are not isolated NaCl molecules; symbols do not show actual particle size.'),
  'sci-g9-3-covalent': ScienceFigure(
      title: 'One, two or three shared electron pairs',
      kind: 'comparison',
      labels: ['H–H: single bond', 'O=O: double bond', 'N≡N: triple bond'],
      details: [
        'One shared pair links the two hydrogen atoms.',
        'Two shared pairs link the oxygen atoms.',
        'Three shared pairs link the nitrogen atoms.'
      ],
      note:
          'Each line represents a shared electron pair. Unshared pairs are omitted here; lines are not physical sticks.'),
  'sci-g9-4-vectors': ScienceFigure(
      title: 'A return journey can have zero displacement',
      kind: 'comparison',
      labels: ['6 m east', '6 m west', 'Whole trip in 8 s'],
      details: [
        'The first leg changes position by +6 m if east is positive.',
        'The return leg changes position by −6 m.',
        'Distance is 12 m; displacement is 0 m. Average speed is 1.5 m/s and average velocity is 0 m/s.'
      ],
      note:
          'One-dimensional motion and the same start/end point are assumed. Zero average velocity does not imply no motion.'),
  'sci-g9-4-acceleration': ScienceFigure(
      title: 'Read changes in signed velocity',
      kind: 'comparison',
      labels: [
        '+2 to +8 m/s in 3 s',
        '+8 to +2 m/s in 3 s',
        '−2 to −8 m/s in 3 s'
      ],
      details: [
        'Average acceleration = (8 − 2)/3 = +2 m/s².',
        'Average acceleration = (2 − 8)/3 = −2 m/s²; speed falls.',
        'Average acceleration = (−8 − (−2))/3 = −2 m/s²; speed rises.'
      ],
      note:
          'Positive is right. Negative acceleration names a direction, not automatically slowing down.'),
  'sci-g9-4-newton': ScienceFigure(
      picture: 'g9-motion',
      title: 'Sum forces on one cart before dividing by mass',
      kind: 'comparison',
      labels: ['8 N right and 2 N left', '2 kg cart', '3 m/s² right'],
      details: [
        'Net horizontal force = 8 − 2 = 6 N right.',
        'The stated mass is the mass of this whole cart system.',
        'a = Fnet/m = 6/2 = 3 m/s² right.'
      ],
      note:
          'Vertical forces balance. Arrows represent forces on this cart, not a third-law pair. Acceleration direction alone does not specify the current velocity.'),
  ...grade9PlateTectonicsFigures,
};

final _biologyFoundations = scienceTopic(
  grade: 'g9',
  order: 1,
  title: 'Biology Foundations',
  subtitle: 'Explain how cells regulate exchange and obtain usable energy.',
  minutes: 'About 30–35 minutes',
  prerequisiteTopicId: null,
  objectives: [
    'Trace a negative-feedback response from disturbance to reduced response.',
    'Predict net diffusion and osmosis under stated membrane conditions.',
    'Distinguish passive transport from energy-coupled active transport.',
    'Connect photosynthesis, respiration and ATP-supported cell work.',
  ],
  introduction:
      'A person sitting quietly is still exchanging gases, moving ions and producing heat. Living systems maintain organization through continuing activity. This lesson connects the cell membrane to energy transformations and to the regulation of internal conditions: three systems that must work together even when an organism appears still.',
  sections: [
    scienceSection('Cells operate as connected systems',
        '''A cell is an organized chemical system enclosed by a selectively permeable membrane. Selectively permeable means that substances cross at different rates or require particular pathways. Oxygen can cross the lipid part of a membrane relatively easily; many ions require proteins. A membrane is therefore neither a completely sealed wall nor an unrestricted opening.

In a multicellular organism, specialized cells form tissues and organs that exchange materials through larger systems. The digestive system supplies absorbed nutrients, gas exchange supplies oxygen, and circulation carries these materials to cells. Cells release carbon dioxide that circulation carries toward gas-exchange surfaces. Naming an organ is only the beginning: explain the material it transfers and the cellular process that uses or produces that material.'''),
    scienceSection('Homeostasis is regulation within a range',
        '''Homeostasis maintains internal conditions within workable ranges despite disturbances. It does not freeze every measurement at one exact value. Enzymes, biological catalysts that speed reactions without being consumed overall, work under particular conditions. Large departures in temperature or pH can disrupt protein shape and cellular reactions. Regulation therefore supports the chemistry of life.

In negative feedback, a response opposes the original departure. If body temperature rises, receptors detect the change, a control center coordinates signals, and effectors such as sweat glands respond. Evaporation transfers heat away from the skin. As the departure becomes smaller, the cooling response decreases. Negative describes the relationship between response and disturbance; it does not mean harmful. A falling variable can also trigger a negative-feedback response that raises it. A mechanism that reinforces its initial disturbance would instead be positive feedback.'''),
    scienceVisual('sci-g9-1-feedback',
        'Follow the original disturbance and ask whether the response reduces it.'),
    scienceSection('Passive movement: random motion, predictable net flow',
        '''Particles are in continual random motion. When more particles of a diffusible substance occupy one region, more tend to leave that region than enter it. Diffusion is the resulting net movement down a concentration gradient, from higher to lower concentration. Individual particles can travel either way; net movement describes the difference between the two flows.

Passive transport across a membrane does not require the cell to supply energy directly to drive the movement. Facilitated diffusion uses membrane proteins while still proceeding down the relevant gradient. At dynamic equilibrium, particles continue crossing both ways at equal average rates; net movement is zero. A diagram showing an arrow toward lower concentration summarizes net flow, not a rule forcing every particle to follow that arrow. For ions, electrical attraction also matters, so concentration alone may be insufficient without further information.'''),
    scienceSection('Osmosis and energy-coupled transport',
        '''Osmosis is net movement of water across a selectively permeable membrane. Consider equal-pressure solutions separated by a membrane that passes water but blocks the dissolved solute. Water moves net toward the side with the higher solute concentration. If the surrounding solution has a higher concentration of nonpenetrating solute than an animal cell, water tends to leave and the cell shrinks. With a lower concentration outside, water tends to enter and the cell may swell. Equal effective concentrations give no net water movement, although water molecules still exchange.

Active transport uses an energy-coupled mechanism to move substances against their relevant gradients. A membrane pump can use energy from ATP turnover to maintain unequal ion concentrations. ATP is a molecule that helps couple energy-releasing processes to cellular work. Using a protein does not automatically make transport active: facilitated diffusion also uses proteins. Identify both the movement relative to the gradient and whether an energy source drives it.'''),
    scienceVisual('sci-g9-1-transport',
        'Compare movement, membrane conditions and energy requirements.'),
    scienceSection('Bioenergy links food, gases and cell work',
        '''Metabolism is the collection of chemical reactions in an organism. Building larger molecules requires energy input; breakdown reactions can release energy that is transferred to useful processes. In aerobic cellular respiration, the overall inputs include glucose and oxygen; carbon dioxide and water are products. Some released energy supports ATP production, while some disperses as heat. Breathing moves air; respiration is a set of cellular chemical reactions, so the two terms are related but not interchangeable.

Photosynthesis uses light energy to help build sugars from carbon dioxide and water and releases oxygen. Plant cells also carry out respiration, including when light is available. Chloroplasts perform photosynthesis, while mitochondria carry out major stages of aerobic respiration in eukaryotic cells; respiration also has steps in the cytoplasm. These overall summaries omit many intermediate reactions. Matter can be recycled between processes, but useful energy must enter the system and eventually disperses as heat. ATP is continually regenerated and used rather than acting as a permanent store of all the energy in food.'''),
    scienceVisual('sci-g9-1-energy',
        'Trace carbon-containing matter separately from energy transfer.'),
    scienceSection('Worked example: a pump loses its energy supply',
        '''Suppose a model cell keeps a neutral substance more concentrated inside than outside using a pump. Its membrane also has a passive route for that substance. First identify the gradient: passive net movement would be outward. Next identify the pump direction: it moves material inward against this gradient, requiring energy coupling. If its energy supply stops, the pump cannot continue its usual operation, but passive motion does not suddenly stop. The concentration difference tends to decrease over time through the passive route.

This is a conditional prediction, not a claim that every real cell immediately reaches equal concentrations. Real membranes have multiple transport pathways and changing reactions. A good explanation names the assumptions that make a prediction possible.'''),
    scienceSection('Guided example: interpret a cell-volume record',
        '''A model membrane passes water but blocks the solute. The outside nonpenetrating-solute concentration is higher than inside, and initial pressure is equal. Predict the initial water movement before considering measurements. Water should leave net, reducing cell volume. A volume change from 100 arbitrary units to 85 supports that prediction. It does not mean 15 solute units crossed or that every water molecule moved outward.

For an offline activity, draw two equal-sized compartments, with six solute marks in one and two in the other. Label the membrane water-permeable and solute-impermeable. Draw a large arrow for net water movement toward the six-mark side and small arrows both ways. Change the concentrations to equal values and redraw equal opposing arrows. This model requires no biological samples, tasting or chemical handling.'''),
    scienceSection('Common mistakes',
        'Homeostasis allows fluctuations. Negative feedback opposes a departure, not necessarily a high value. Osmosis concerns water, not solute flowing through an impermeable barrier. Equilibrium still includes molecular motion. A transport protein may be passive or active. Plants respire as well as photosynthesize, and cells transform energy rather than creating it.'),
    scienceSection('Quick check',
        'A membrane passes water but not a neutral solute, with equal initial pressure on both sides. Outside solute concentration is lower. Which way does water move net initially? Does a protein channel necessarily consume ATP? Why should a cooling response decline as temperature recovers?'),
    scienceSection('Check your thinking',
        'Water moves net inward under the stated equal-pressure model. A channel can support passive transport, so protein involvement alone does not show ATP use. Negative feedback reduces the original temperature departure; as that departure diminishes, the corrective signal and response diminish.',
        reveal: true),
    scienceSection('Recap',
        'Explain regulation through disturbance, detection, response and feedback. Explain transport using the membrane, gradient and energy source. Connect food and gas exchange to respiration, ATP turnover and heat. These links explain how ongoing cellular activity supports stable conditions in a changing environment.'),
  ],
  keyConcept:
      'Homeostasis emerges from regulated cellular processes. Selective transport controls material exchange, while energy transformations support the work required to maintain organized living systems.',
  questions: [
    [
      'What does homeostasis maintain?',
      'Internal conditions within workable ranges',
      'Every measurement at an unchanging exact value',
      'A permanent halt to cellular reactions',
      'Identical conditions inside and outside every cell',
      'Homeostasis regulates internal conditions dynamically within ranges.',
      'Homeostasis'
    ],
    [
      'Why is a cooling response called negative feedback?',
      'It opposes the original temperature rise',
      'It always damages the responding cells',
      'It makes the initial rise larger',
      'It prevents receptors from detecting change',
      'Negative feedback reduces the departure that originally triggered the response.',
      'Feedback'
    ],
    [
      'What is selective permeability?',
      'Different substances cross a membrane differently',
      'All substances cross equally fast',
      'No substance can cross a living membrane',
      'Only substances with no biological use can cross',
      'Membrane structure and proteins determine which substances cross and how.',
      'Membranes'
    ],
    [
      'A neutral substance diffuses passively. Which direction describes its net movement?',
      'Down its concentration gradient',
      'Toward its higher concentration',
      'Only toward the center of the cell',
      'Only away from all membrane proteins',
      'Diffusion gives net movement from higher to lower concentration.',
      'Diffusion'
    ],
    [
      'Which substance moves in osmosis?',
      'Water',
      'Only dissolved salt ions',
      'Only glucose molecules',
      'Only membrane proteins',
      'Osmosis describes net water movement across a selectively permeable membrane.',
      'Osmosis'
    ],
    [
      'Which process can drive a substance against its gradient?',
      'Energy-coupled active transport',
      'Simple diffusion alone',
      'Unassisted movement at equilibrium',
      'Passive facilitated diffusion alone',
      'Active transport couples an energy source to movement against a gradient.',
      'Active transport'
    ],
    [
      'What is one role of ATP turnover?',
      'Coupling energy transfer to cellular work',
      'Creating energy from nothing',
      'Preventing all heat production',
      'Replacing every nutrient and membrane',
      'ATP turnover helps supply energy for transport and other cellular work.',
      'ATP'
    ],
    [
      'At diffusion equilibrium, what continues?',
      'Particle crossing in both directions at equal average rates',
      'Net flow entirely toward one side',
      'A total stop in particle motion',
      'Conversion of every particle into a membrane',
      'Dynamic equilibrium has continuing motion but no net transport.',
      'Dynamic equilibrium'
    ],
    [
      'A protein moves a neutral solute down its gradient without energy coupling. What is this?',
      'Facilitated diffusion',
      'Active pumping against the gradient',
      'Photosynthesis',
      'A failure of particle motion',
      'Facilitated diffusion uses a protein while remaining passive.',
      'Facilitated diffusion'
    ],
    [
      'Outside nonpenetrating solute concentration exceeds that inside an animal cell at equal initial pressure. What is predicted initially?',
      'Net water loss and shrinking',
      'Net water gain and swelling',
      'Net solute entry through the solute-impermeable membrane',
      'No water movement in either direction',
      'Water tends to move toward the higher concentration of nonpenetrating solute.',
      'Osmotic prediction'
    ],
    [
      'Which overall input pair belongs to aerobic respiration?',
      'Glucose and oxygen',
      'Carbon dioxide and light alone',
      'Water and carbon dioxide alone',
      'ATP and oxygen as the only possible inputs',
      'Aerobic respiration uses glucose and oxygen in its overall summary.',
      'Respiration inputs'
    ],
    [
      'Which statement connects plant energy processes correctly?',
      'Plants perform respiration as well as photosynthesis',
      'Plants stop respiration whenever light is present',
      'Plants obtain all ATP without chemical reactions',
      'Plants use respiration only after becoming animals',
      'Plant cells require respiration, including in periods when photosynthesis occurs.',
      'Plant metabolism'
    ],
    [
      'How do enzymes help metabolism?',
      'They speed reactions without being consumed overall',
      'They remove the need for all energy inputs',
      'They make every reaction independent of temperature',
      'They change all products back into identical reactants',
      'Enzymes are biological catalysts and their function depends on conditions.',
      'Enzymes'
    ],
    [
      'As regulated temperature returns toward its normal range, what should happen to the corrective cooling response?',
      'It should diminish',
      'It should grow indefinitely',
      'It should reverse the direction of every water molecule',
      'It should permanently destroy the receptors',
      'A smaller departure produces a smaller corrective response in negative feedback.',
      'Response regulation'
    ],
    [
      'A pump maintains more neutral solute inside a cell, and an outward passive pathway exists. If pump energy stops, what tendency follows?',
      'The concentration difference decreases through passive transport',
      'The inward pump continues unchanged forever',
      'All molecular movement instantly stops',
      'The concentration difference must increase without energy',
      'The passive outward route remains available after the inward pump loses its supply.',
      'Pump reasoning'
    ],
    [
      'A membrane passes water but blocks solute. A model cell shrinks after transfer. Which explanation fits equal initial pressure?',
      'The outside had a higher nonpenetrating-solute concentration',
      'The outside necessarily had a lower nonpenetrating-solute concentration',
      'Water could not cross the membrane at all',
      'Shrinking proves every solute molecule left the cell',
      'Net water loss explains shrinking in the stated osmosis model.',
      'Volume evidence'
    ],
    [
      'A learner labels every membrane protein an ATP pump. Which observation would refute that classification?',
      'A protein permits passive movement down a gradient',
      'A pump moves material against a gradient',
      'An energy source supports a pump',
      'A membrane separates two solutions',
      'Protein-mediated passive movement is facilitated diffusion, not necessarily active transport.',
      'Transport evidence'
    ],
    [
      'Which distinction between breathing and respiration is accurate?',
      'Breathing moves air; cellular respiration transforms substances and energy',
      'Both mean only the movement of air outside cells',
      'Respiration occurs only in the lungs',
      'Breathing creates glucose inside mitochondria',
      'Gas movement supports respiration but is different from cellular chemical reactions.',
      'System connections'
    ],
    [
      'Why is continual energy input needed even if biological matter is recycled?',
      'Useful energy eventually disperses as heat',
      'Matter recycling creates unlimited usable energy',
      'ATP molecules cannot be regenerated',
      'Every carbon atom disappears after respiration',
      'Matter can cycle while energy transfers ultimately disperse energy as heat.',
      'Energy flow'
    ],
    [
      'What does a volume drop from 100 to 85 arbitrary units show directly?',
      'A decrease in cell volume',
      'Exactly 15 solute molecules crossed',
      'Every water molecule left the cell',
      'The cell stopped all metabolism',
      'Volume data show a volume change; molecule counts require additional measurements.',
      'Evidence limits'
    ],
    [
      'A model variable falls below its target and a response raises it toward the target. Which classification fits?',
      'Negative feedback despite the upward response',
      'Positive feedback because every increase is positive feedback',
      'Diffusion equilibrium because all values are fixed',
      'No feedback because only decreases can regulate',
      'The response opposes the initial fall, so it is negative feedback.',
      'Feedback mastery'
    ],
    [
      'Two compartments have equal pressure, equal effective solute concentrations and a water-permeable membrane. What best represents their exchange?',
      'Equal opposing water flows with zero net flow',
      'No water molecule can move at all',
      'A permanent one-way stream without a gradient',
      'All solute must pass because water passes',
      'Equal effective conditions give dynamic water exchange without net osmosis.',
      'Osmosis mastery'
    ],
    [
      'An illuminated plant makes sugar while its cells use ATP for transport. Which explanation joins both processes?',
      'Photosynthesis stores light-derived energy in sugars, and respiration supports ATP regeneration',
      'Photosynthesis eliminates the need for respiration and ATP',
      'Active transport supplies the sunlight that chloroplasts create',
      'The plant creates new energy whenever it needs a pump',
      'Photosynthesis, respiration and ATP-supported work are connected energy transformations.',
      'Bioenergy mastery'
    ],
  ],
);

final _atomicStructure = scienceTopic(
  grade: 'g9',
  order: 2,
  title: 'Atomic Structure',
  subtitle: 'Use particle counts to distinguish elements, isotopes and ions.',
  minutes: 'About 30–35 minutes',
  prerequisiteTopicId: 'science.g9.biology-foundations',
  objectives: [
    'Calculate proton, neutron and electron counts from atomic notation.',
    'Distinguish an isotope change from ion formation and element change.',
    'Calculate a weighted mean atomic mass from a supplied isotope mixture.',
    'Explain the usefulness and limits of a shell model.'
  ],
  introduction:
      'A periodic-table mass often contains decimals, although an atom cannot contain half a proton. The apparent puzzle disappears when we separate three questions: which element is present, which isotope is present, and what mixture of isotopes was measured. Particle counting provides the tools to answer each question without confusing mass and electrical charge.',
  sections: [
    scienceSection('A small nucleus and an electron region',
        '''An atom contains a nucleus with positively charged protons and electrically neutral neutrons. Negatively charged electrons occupy regions around that nucleus. A proton and a neutron each have a mass close to one atomic mass unit, written u; an electron has a much smaller mass. Most atomic mass is therefore concentrated in the nucleus, while the electron region accounts for most of the size.

A drawing with visible nucleons and electrons cannot usually show both particle structure and realistic distances on a small screen. Treat its spacing and colored circles as symbols. Electrons are not tiny planets traveling along the precise circular tracks often used in introductory diagrams. Modern models describe regions where electrons are likely to be found. We will use simple shell populations to track electrons, while remembering that this model leaves out important detail.'''),
    scienceVisual('sci-g9-2-particles',
        'Mass contribution, charge and location are separate properties.'),
    scienceSection('Atomic number establishes element identity',
        '''The atomic number Z is the number of protons. Every carbon atom has six protons, and every sodium atom has eleven. An object with seven protons is nitrogen, even if it has the same total number of nucleons as some carbon isotope. Changing the proton count changes the element; ordinary ion formation does not do that.

The mass number A is the whole-number total of protons and neutrons in one nucleus: A = Z + N. Rearranging gives neutron count N = A − Z. Carbon-12 has Z = 6 and A = 12, so N = 12 − 6 = 6. Carbon-14 has the same Z but A = 14, so it has eight neutrons. The number following an element name is a mass number, not the element charge. Nuclear notation may place A above Z to the left of the element symbol; a charge, if present, appears separately at the upper right.'''),
    scienceSection('Isotopes preserve proton count',
        '''Isotopes are forms of the same element with different neutron counts. Carbon-12 and carbon-14 therefore belong to one element while having different mass numbers. Isotopes often have very similar chemical behavior because neutral atoms of the same element have the same electron count and comparable electron arrangements. They can differ strongly in nuclear stability: carbon-14 is radioactive, while carbon-12 is stable. The word isotope does not mean radioactive.

Changing neutrons is a nuclear change, not the usual outcome of dissolving, melting or making a chemical bond. Chemical reactions mainly rearrange electrons and connections between atoms while nuclei retain their identities. This distinction helps explain why counting atoms of each element is useful when balancing chemical equations. It also prevents the mistaken inference that two objects with the same mass number must be the same element.'''),
    scienceVisual('sci-g9-2-isotopes',
        'Compare proton counts first, then neutron and electron counts.'),
    scienceSection('Ions change electron count',
        '''A neutral atom has equal numbers of protons and electrons, so their charges cancel. If it loses an electron, it has one more positive proton charge than negative electron charge and becomes a +1 ion. If it gains an electron, it becomes a −1 ion. A positive ion is a cation; a negative ion is an anion. In these ordinary ion changes, protons and neutrons remain in the nucleus.

Count charge in elementary-charge units with q = proton count − electron count. Sodium-23 has eleven protons and twelve neutrons. Neutral sodium has eleven electrons; Na+ has ten electrons but still eleven protons and twelve neutrons. The + symbol indicates a missing electron relative to the neutral atom, not an added proton. An ion with eight protons and ten electrons has charge −2 and is an oxygen ion. Its neutron count cannot be found unless a mass number or other nuclear information is also supplied.'''),
    scienceSection('Worked example: decode one species',
        '''A particle is specified as magnesium-24, atomic number twelve, with charge +2. Step one: atomic number fixes twelve protons. Step two: subtract Z from A, so 24 − 12 gives twelve neutrons. Step three: a +2 charge means two fewer electrons than protons, giving ten electrons. Finally check: +12 plus −10 equals +2. The counts are therefore 12 protons, 12 neutrons and 10 electrons.

Compare it with neutral magnesium-25. That atom still has twelve protons, now thirteen neutrons, and twelve electrons. Two changes occurred in the comparison: isotope and charge state. These labels are independent; an isotope can be neutral or ionized. A reliable solution records all three particle counts rather than relying on one label to answer every question.'''),
    scienceSection('Why atomic masses can be decimals',
        '''A sample of an element may contain several isotopes. Its average atomic mass depends on both isotope masses and their relative abundances. A weighted mean gives common isotopes more influence than rare isotopes. Multiply each isotope mass by its fractional abundance, then add the contributions. Fractions must total one, or percentages must total 100% before dividing by 100.

For an invented element with 75% of atoms at 20.0 u and 25% at 22.0 u, calculate (0.75 × 20.0) + (0.25 × 22.0) = 15.0 + 5.5 = 20.5 u. This answer lies between the two masses and is closer to 20.0 u, the more abundant isotope. No atom in this two-isotope model has mass 20.5 u. The mean describes the collection. Real isotope masses are not generally exact whole numbers, so use measured masses when supplied rather than silently replacing them with mass numbers.'''),
    scienceVisual('sci-g9-2-mass',
        'Check the fractions, contributions and position of the mean.'),
    scienceSection('Guided calculation and a paper model',
        '''Try a second hypothetical mixture: 40% of atoms have mass 30.0 u and 60% have mass 32.0 u. Convert percentages to 0.40 and 0.60. Calculate the contributions 12.0 u and 19.2 u, giving 31.2 u. It should lie closer to 32.0 u because that isotope is more abundant. An unweighted mean of 31.0 u would incorrectly assume equal numbers of the two isotopes.

For a paper activity, draw ten isotope cards: four labeled 30.0 u and six labeled 32.0 u. Add their masses and divide by ten to check the weighted calculation. Change two cards from the heavier isotope to the lighter one and predict that the mean decreases before doing any arithmetic. No radioactive material or laboratory apparatus is involved.'''),
    scienceSection('Electron shells prepare for bonding',
        '''In a simplified introductory shell model, neutral sodium has electron populations 2, 8, 1 and neutral chlorine has 2, 8, 7. The outer occupied shell contains valence electrons, which are especially important in bonding. Losing one electron leaves sodium with 2, 8; gaining one leaves chlorine with 2, 8, 8. These examples connect charge counting with the next lesson on chemical bonds.

Do not extend this simple pattern into a universal claim that every shell can hold only eight electrons, or that every atom must obey an octet rule. More advanced electron arrangements need additional models. Here, the shell notation is useful because it makes electron gains and losses visible while leaving the nucleus unchanged.'''),
    scienceSection('Common mistakes',
        'Atomic number counts protons; mass number counts protons plus neutrons. Ion charge depends on electrons relative to protons. Isotopes differ in neutrons, and not all are radioactive. A sample average is not a fractional nucleon count in one atom. An unweighted mean works only when the isotope abundances are equal.'),
    scienceSection('Quick check',
        'A species has 9 protons, 10 neutrons and 10 electrons. What are its mass number and charge? If its electron count changes to 9, does its element identity change?'),
    scienceSection('Check your thinking',
        'Mass number is 9 + 10 = 19 and charge is 9 − 10 = −1. With nine electrons it becomes neutral. Its nine protons remain, so its element identity stays the same.',
        reveal: true),
    scienceSection('Recap',
        'Begin with the nucleus to identify the element and isotope. Compare electrons with protons to identify charge. For a sample, weight isotope masses by abundance and check that the mean lies between the contributing masses. Keep every number tied to the property it measures.'),
  ],
  keyConcept:
      'Proton count identifies an element, neutron count distinguishes its isotopes, and electron count determines its charge state. Average atomic mass describes an isotope mixture through a weighted mean.',
  questions: [
    [
      'Which particle count defines atomic number?',
      'Protons',
      'Neutrons alone',
      'Electrons plus neutrons',
      'All particles in all shells',
      'Atomic number is the proton count and establishes element identity.',
      'Atomic number'
    ],
    [
      'Which expression gives mass number?',
      'Protons plus neutrons',
      'Protons minus electrons',
      'Electrons plus shell count',
      'Neutrons minus protons',
      'Mass number counts the nucleons: protons and neutrons.',
      'Mass number'
    ],
    [
      'Which particle carries a negative elementary charge?',
      'Electron',
      'Proton',
      'Neutron',
      'A neutral atom as a whole',
      'An electron has charge −1 in elementary-charge units.',
      'Particle charges'
    ],
    [
      'What makes carbon-12 and carbon-14 isotopes?',
      'Equal proton counts and different neutron counts',
      'Equal neutron counts and different proton counts',
      'Both having fourteen electrons',
      'Both necessarily having a positive charge',
      'Isotopes share element identity but have different neutron counts.',
      'Isotopes'
    ],
    [
      'What characterizes a neutral atom?',
      'Equal proton and electron counts',
      'No protons anywhere',
      'Equal neutron and electron counts in every case',
      'No charged particles inside it',
      'Positive proton and negative electron charges balance in a neutral atom.',
      'Neutrality'
    ],
    [
      'An ordinary atom loses one electron. What charge change results?',
      'Its charge increases by +1',
      'Its charge decreases by −1',
      'Its proton count decreases by one',
      'Its neutron count increases by one',
      'Losing a negative electron leaves one additional net positive charge.',
      'Ion formation'
    ],
    [
      'Where is most atomic mass concentrated?',
      'In the nucleus',
      'Uniformly throughout empty space',
      'Only in the outer electron shell',
      'In the electric charge symbol',
      'Protons and neutrons account for nearly all atomic mass.',
      'Atomic model'
    ],
    [
      'A neutral carbon-14 atom has Z = 6. How many neutrons does it contain?',
      '8',
      '6',
      '14',
      '20',
      'Neutron count is A − Z = 14 − 6 = 8.',
      'Neutron calculation'
    ],
    [
      'How many electrons are in Na+ when sodium has atomic number 11?',
      '10',
      '11',
      '12',
      '23',
      'A +1 sodium ion has one fewer electron than its eleven protons.',
      'Cation count'
    ],
    [
      'An oxygen species has 8 protons and 10 electrons. What is its charge?',
      '−2',
      '+2',
      '0',
      '+18',
      'Charge is proton count minus electron count: 8 − 10 = −2.',
      'Anion count'
    ],
    [
      'Magnesium-24 with Z = 12 has charge +2. Which counts fit?',
      '12 protons, 12 neutrons, 10 electrons',
      '10 protons, 14 neutrons, 12 electrons',
      '12 protons, 24 neutrons, 14 electrons',
      '14 protons, 10 neutrons, 12 electrons',
      'Z fixes protons, A − Z gives neutrons, and +2 means two fewer electrons.',
      'Notation decoding'
    ],
    [
      'In the 75% at 20.0 u and 25% at 22.0 u model, what is the weighted mean?',
      '20.5 u',
      '21.0 u',
      '42.0 u',
      '5.5 u',
      '0.75 × 20.0 + 0.25 × 22.0 = 20.5 u.',
      'Weighted mass'
    ],
    [
      'What fraction should replace an isotope abundance of 40% in a weighted mean?',
      '0.40',
      '40',
      '4.0',
      '0.004',
      'Divide the percentage by 100 to obtain the fractional abundance.',
      'Abundance conversion'
    ],
    [
      'In the shell pattern 2, 8, 7, how many valence electrons are represented?',
      '7',
      '2',
      '8',
      '17',
      'The outer occupied shell contains seven electrons in this model.',
      'Valence shells'
    ],
    [
      'A species keeps six protons but changes from six to eight neutrons. What changes?',
      'Its isotope, while its element remains carbon',
      'Its element to oxygen',
      'Its charge necessarily to +2',
      'Its proton identity to an electron',
      'Neutron changes distinguish isotopes without changing the proton-defined element.',
      'Nuclear comparison'
    ],
    [
      'An atom and another species have the same mass number but different proton counts. What follows?',
      'They are different elements',
      'They must be isotopes of one element',
      'They must have identical neutron counts',
      'They must both be neutral',
      'Equal mass number does not override a difference in atomic number.',
      'Identity reasoning'
    ],
    [
      'Why is 31.0 u wrong for a mixture of 40% at 30.0 u and 60% at 32.0 u?',
      'It treats unequal abundances as equal',
      'It includes the heavier isotope at all',
      'Every atomic mean must be a whole number',
      'It counts electrons instead of any mass',
      'The weighted mean is 31.2 u because the heavier isotope is more abundant.',
      'Weighting reasoning'
    ],
    [
      'A two-isotope mixture has masses 18 u and 22 u. Which proposed mean is impossible?',
      '24 u',
      '19 u',
      '20 u',
      '21 u',
      'A weighted mean of these two masses must lie between 18 and 22 u.',
      'Mean plausibility'
    ],
    [
      'What can be determined from 11 protons and 10 electrons without a neutron count?',
      'The species has charge +1',
      'The species has exactly twelve neutrons',
      'Its mass number must be 23',
      'Its isotope must be radioactive',
      'Charge follows from protons and electrons; isotope information needs neutrons.',
      'Information limits'
    ],
    [
      'Which correction improves a circular-orbit atom drawing?',
      'Label electron paths as a simplified model rather than exact trajectories',
      'Claim its spacing is always drawn to real scale',
      'Place all atomic mass in the orbital lines',
      'Say electrons are motionless planets',
      'Introductory shells track populations but do not show exact electron trajectories.',
      'Model limits'
    ],
    [
      'An ion has Z = 13, A = 27 and charge +3. How many electrons and neutrons does it have?',
      '10 electrons and 14 neutrons',
      '16 electrons and 14 neutrons',
      '10 electrons and 27 neutrons',
      '13 electrons and 10 neutrons',
      'Electrons are 13 − 3 = 10; neutrons are 27 − 13 = 14.',
      'Particle mastery'
    ],
    [
      'An invented mixture is 20% at 50.0 u and 80% at 55.0 u. What is its mean atomic mass?',
      '54.0 u',
      '52.5 u',
      '51.0 u',
      '105.0 u',
      '0.20 × 50.0 + 0.80 × 55.0 = 10.0 + 44.0 = 54.0 u.',
      'Mass mastery'
    ],
    [
      'Neutral magnesium-24 becomes magnesium-24 with charge +2. Which description is correct?',
      'Two electrons were lost while proton and neutron counts stayed fixed',
      'Two protons were added while electrons stayed fixed',
      'Two neutrons were lost so the isotope changed',
      'Its atomic number increased by two',
      'Ordinary ion formation changes electron count without changing the nucleus.',
      'Ion mastery'
    ],
  ],
);

final _chemicalBonding = scienceTopic(
  grade: 'g9',
  order: 3,
  title: 'Chemical Bonding',
  subtitle:
      'Connect valence electrons, attractive forces and chemical formulas.',
  minutes: 'About 30–35 minutes',
  prerequisiteTopicId: 'science.g9.atomic-structure',
  objectives: [
    'Explain ionic and covalent bonding through electrons and attraction.',
    'Determine simplest ionic formulas from supplied ion charges.',
    'Distinguish an ionic formula unit from a discrete molecule.',
    'Interpret shared electron pairs and link mobile charges to conductivity.'
  ],
  introduction:
      'Table salt and hydrogen gas both contain bonded particles, but their formulas describe different structures. NaCl records a ratio in an extended ionic arrangement; H2 counts atoms in a discrete molecule. Understanding this difference makes formulas explanations of matter rather than strings of letters to memorize.',
  sections: [
    scienceSection('Valence electrons and an energy explanation',
        '''Valence electrons occupy the outer region of an atom and are especially involved in chemical bonding. In the simple shell model used here, sodium has 2, 8, 1 electrons and chlorine has 2, 8, 7. Their outer populations help explain the ions they commonly form. Sodium can lose one electron to form Na+, while chlorine can gain one to form Cl−. The nuclei retain their proton counts, so these are ion changes rather than changes of element.

Atoms do not think, choose partners or literally want a full shell. Bonded arrangements form when the overall interaction and conditions favor them energetically. The octet rule is a useful pattern for many simple main-group examples: an outer population of eight often appears in stable arrangements. It is not a universal law. Hydrogen uses a first shell that holds two electrons, and other elements and compounds can depart from an octet. Use the stated model instead of forcing every substance into one rule.'''),
    scienceVisual('sci-g9-3-valence',
        'Keep track of the electrons while preserving each nuclear identity.'),
    scienceSection('Ionic bonding is attraction throughout a lattice',
        '''An ionic bond is electrostatic attraction between oppositely charged ions. A transfer-of-electrons drawing helps explain how neutral sodium and chlorine atoms can become Na+ and Cl−. The attraction between the resulting ions is the bonding interaction; the transfer arrow is not itself the force holding the solid together. Positive and negative charges attract, while like charges repel.

Solid sodium chloride consists of an extended three-dimensional arrangement of ions called a lattice. Each ion interacts with several neighbors. A formula unit expresses the simplest whole-number ratio: NaCl means one sodium ion for each chloride ion overall. It does not mean that the crystal is a pile of separate NaCl molecules. An illustrative two-dimensional checkerboard is only a slice through a larger structure and should not be read as a complete arrangement or as exact particle sizes.'''),
    scienceVisual('sci-g9-3-ionic',
        'Compare a repeating ionic structure with a separate two-atom molecule.'),
    scienceSection('Worked example: build a neutral ionic ratio',
        '''Consider magnesium ions Mg2+ and chloride ions Cl−. One magnesium ion contributes +2 and one chloride contributes −1. A one-to-one pair would total +1, so it would not give a neutral ionic compound. Two chloride ions provide −2, balancing one Mg2+. The smallest neutral ratio is therefore one magnesium to two chloride, written MgCl2. The subscript 2 applies only to chlorine; an omitted subscript means one.

Now consider Al3+ and O2−. One of each gives +1, not zero. Two aluminum ions total +6 and three oxide ions total −6. The formula is Al2O3, with a 2:3 ratio. Check a proposed formula by multiplying each ion charge by its count and adding. Start with charges, not a memorized crossing trick: a trick can hide whether a ratio is neutral or whether it has been reduced to its simplest form.'''),
    scienceSection('Guided formula decisions',
        '''For Ca2+ and O2−, one of each already balances: +2 + (−2) = 0. Write CaO, not Ca2O2, because the simplest ratio is one to one. For K+ and S2−, two potassium ions balance one sulfide ion, giving K2S. Charges belong to ions; subscripts count their relative numbers. Writing MgCl2 does not change chloride into a −2 ion.

During an offline activity, make paper cards marked +1, +2, +3, −1 and −2. Form groups with total charge zero, then label their smallest ratios using the ions above. A neutral group with two Ca2+ and two O2− has the same 1:1 composition as one of each. Dividing both counts by the same factor preserves the composition. This card model teaches electrical balance but does not show the spatial lattice or the energy needed to form the ions.'''),
    scienceSection('Covalent bonds share electron pairs',
        '''A covalent bond involves a shared pair of electrons attracted to both nuclei. Two hydrogen atoms can share one pair, giving a single bond in H2. Each hydrogen counts the shared pair in its two-electron shell description; there are only two shared electrons altogether, not four newly created electrons. A line such as H–H represents that shared pair and is not a rigid physical stick.

A double bond represents two shared pairs, as in the introductory O=O model; a triple bond represents three shared pairs, as in N≡N. These abbreviated drawings omit unshared pairs. Many covalent substances consist of discrete molecules, such as H2 and H2O. Water has two hydrogen atoms and one oxygen atom per molecule. Some covalent substances instead form extended networks, so covalent does not automatically mean separate molecules in every material.'''),
    scienceVisual('sci-g9-3-covalent',
        'Count shared pairs from the bond lines without creating extra electrons.'),
    scienceSection('Sharing may be unequal',
        '''When atoms attract shared electrons equally, a bond is nonpolar in this introductory model; H–H is an example because the atoms are identical. When one atom attracts the shared electrons more strongly, the bond can be polar. In an O–H bond, oxygen attracts the shared electrons more strongly than hydrogen, producing partial charges: oxygen is partly negative and hydrogen partly positive.

Partial charges in a polar covalent bond do not mean a complete transfer has produced isolated full-charge ions. The electrons are still shared. Also distinguish a polar bond from the polarity of an entire molecule: the directions and arrangement of multiple bonds matter. This lesson compares individual H–H and O–H bonds and does not ask you to predict whole-molecule polarity without a shape model.'''),
    scienceSection('Structure explains a conductivity change',
        '''Electrical conduction requires charges that can move through the material. Ions in a solid ionic lattice are held in positions and cannot freely carry charge through the solid, so an ordinary solid ionic compound such as sodium chloride does not conduct well. When melted, its ions can move, allowing conduction. When sodium chloride dissolves in water, mobile ions also allow the solution to conduct.

The reason is mobility, not the creation of charge during melting. The solid already contains charged ions. Avoid saying every liquid conducts or every covalent substance is nonconducting: structure and charge carriers differ among substances, and extended materials can behave differently. These are explanatory comparisons, not instructions to melt salts or test substances with electrical equipment. Reading supplied observations is enough to link particle structure to a measurable property.'''),
    scienceSection('Energy and model limits',
        '''Breaking a bond requires energy input; forming a bond releases energy. A chemical reaction includes both processes, so its overall energy change depends on their balance. Do not claim that breaking the bonds in food directly releases energy by itself. Respiration releases energy overall because the complete rearrangement, including forming product bonds, has an energy balance that allows energy transfer to cellular processes.

Ionic and covalent categories are useful models, not a claim that all real bonds fit perfectly into two completely isolated boxes. Electron density and interactions are more detailed than a dot diagram. For Grade 9, explain the central mechanisms accurately, state the structure represented, and use charge and atom counts to check each formula.'''),
    scienceSection('Common mistakes',
        'NaCl is an ionic ratio, not a discrete molecule label in the crystal. A subscript counts particles; it is not an ion charge. MgCl2 contains two chloride ions for each magnesium ion, each chloride still −1. Sharing a pair does not duplicate electrons. Bond breaking requires energy, and conductivity depends on mobile charge carriers.'),
    scienceSection('Quick check',
        'What formula balances Li+ with O2−? Does a single covalent line represent one electron or one pair? Why can molten sodium chloride conduct when its solid form conducts poorly?'),
    scienceSection('Check your thinking',
        'Li2O uses two +1 ions for one −2 ion. A single line represents one shared electron pair. Melting makes the already charged ions mobile, so they can carry charge through the material.',
        reveal: true),
    scienceSection('Recap',
        'Start with valence electrons, identify attraction or sharing, and specify the structure produced. Check ionic formulas using neutral total charge and simplest ratios. Read molecular formulas as atom counts within molecules. Explain properties through the arrangement and mobility of particles rather than through the formula alone.'),
  ],
  keyConcept:
      'Bonding involves attractions associated with valence electrons. Ionic formulas express charge-balanced lattice ratios, while molecular formulas count atoms in discrete covalently bonded groups.',
  questions: [
    [
      'Which electrons are especially involved in ordinary chemical bonding?',
      'Valence electrons',
      'Only electrons replaced by protons',
      'Only particles inside neutrons',
      'Only electrons with no electrical charge',
      'Valence electrons occupy the outer region and are central to bonding.',
      'Valence electrons'
    ],
    [
      'What interaction holds oppositely charged ions together?',
      'Electrostatic attraction',
      'Repulsion between all unlike charges',
      'Gravity as the main microscopic bonding force',
      'The permanent disappearance of both nuclei',
      'Ionic bonding is electrical attraction between opposite charges.',
      'Ionic attraction'
    ],
    [
      'What does NaCl express for a sodium chloride crystal?',
      'The simplest 1:1 ratio of sodium and chloride ions',
      'A separate two-atom molecule at every location',
      'One neutron for every electron',
      'Two sodium ions for each chloride ion',
      'NaCl is a formula-unit ratio within an extended ionic lattice.',
      'Formula units'
    ],
    [
      'What does a single covalent bond line represent?',
      'One shared electron pair',
      'One transferred proton',
      'Two shared electron pairs',
      'An empty space containing no electrons',
      'A single line represents two electrons shared between atoms.',
      'Covalent pairs'
    ],
    [
      'How many shared pairs does a triple bond represent?',
      '3',
      '1',
      '2',
      '6',
      'A triple bond contains three shared pairs, totaling six shared electrons.',
      'Bond order'
    ],
    [
      'Which first-shell pattern applies to hydrogen in H2?',
      'Access to two electrons through sharing',
      'A required octet around each hydrogen',
      'Loss of its proton to the other atom',
      'Eight separate unshared pairs per atom',
      'Hydrogen uses a two-electron first shell rather than an octet.',
      'Hydrogen shell'
    ],
    [
      'Which change requires energy input?',
      'Breaking a chemical bond',
      'Forming a chemical bond in isolation',
      'Writing an element symbol',
      'Counting an unchanged formula unit',
      'Bond breaking requires energy; bond formation releases energy.',
      'Bond energy'
    ],
    [
      'What simplest formula balances Mg2+ and Cl−?',
      'MgCl2',
      'MgCl',
      'Mg2Cl',
      'Mg2Cl3',
      'One +2 ion balances two −1 ions in MgCl2.',
      'Magnesium chloride'
    ],
    [
      'What simplest formula balances Al3+ and O2−?',
      'Al2O3',
      'AlO',
      'Al3O2',
      'AlO3',
      'Two +3 ions and three −2 ions sum to zero.',
      'Aluminum oxide'
    ],
    [
      'What simplest formula balances Ca2+ and O2−?',
      'CaO',
      'Ca2O',
      'CaO2',
      'Ca2O2',
      'A one-to-one ratio already balances and must be written in its simplest form.',
      'Reducing ratios'
    ],
    [
      'What simplest formula balances K+ and S2−?',
      'K2S',
      'KS',
      'KS2',
      'K2S2',
      'Two potassium ions contribute +2 to balance one sulfide ion at −2.',
      'Potassium sulfide'
    ],
    [
      'What does the 2 in MgCl2 count?',
      'Two chloride ions per magnesium ion',
      'A −2 charge on each chloride ion',
      'Two magnesium ions per chloride ion',
      'Two additional protons in chlorine',
      'The subscript records the relative ion count, not the charge of each chloride.',
      'Subscripts'
    ],
    [
      'Why can molten sodium chloride conduct electricity?',
      'Its ions are mobile',
      'Its ions become uncharged',
      'Its nuclei turn into electrons',
      'Its solid form contained no charges',
      'Melting frees ions to move and carry charge; the ions were already charged.',
      'Conductivity'
    ],
    [
      'Which comparison of H–H and O–H bonds is correct?',
      'H–H shares equally in this model; O–H shares unequally',
      'Both necessarily transfer electrons completely',
      'O–H is nonpolar because the atoms differ',
      'H–H creates a full-charge hydrogen ion pair',
      'Identical H atoms share equally; oxygen attracts O–H shared electrons more strongly.',
      'Bond polarity'
    ],
    [
      'A learner proposes MgCl because both ions appear once. What test rejects it?',
      'The total charge is +1 rather than zero',
      'It has too many chloride ions to balance magnesium',
      'A formula can never omit a subscript 1',
      'Magnesium and chlorine must have identical charges',
      'Mg2+ plus one Cl− leaves +1, so another chloride is required.',
      'Formula checking'
    ],
    [
      'A paper group has four Al3+ cards and six O2− cards. What formula describes its simplest ratio?',
      'Al2O3',
      'Al4O6',
      'Al3O2',
      'AlO',
      'Divide both counts by two to obtain the neutral simplest ratio 2:3.',
      'Ratio reasoning'
    ],
    [
      'What observation supports the mobile-ion explanation of conductivity?',
      'The same salt conducts when molten but poorly when solid',
      'The solid contains no charged particles whatsoever',
      'Every liquid conducts equally regardless of its particles',
      'Melting changes chloride nuclei into sodium nuclei',
      'A change in ion mobility explains the contrast without changing the ions themselves.',
      'Property evidence'
    ],
    [
      'Why is it misleading to say atoms want full shells?',
      'It replaces an energy-based explanation with human intention',
      'It correctly describes a conscious decision inside atoms',
      'It proves the octet rule has no exceptions',
      'It means nuclei disappear during all bonds',
      'Atoms have no intentions; bonding must be explained through interactions and energy.',
      'Model language'
    ],
    [
      'Which statement about a polar O–H bond is justified?',
      'Shared electrons are drawn more strongly toward oxygen',
      'No electrons are shared at all',
      'Partial charges require isolated full-charge ions',
      'Its bond alone determines every possible molecule shape',
      'Polar covalent bonding retains sharing but distributes electrons unequally.',
      'Unequal sharing'
    ],
    [
      'Why does respiration releasing energy not imply bond breaking releases energy?',
      'The overall reaction includes energy-releasing formation of product bonds',
      'Respiration never changes any bonds',
      'Breaking bonds creates energy without input',
      'Product bond formation always consumes all energy',
      'Overall energy change includes both bond breaking and bond formation.',
      'Reaction energy'
    ],
    [
      'For supplied ions Ba2+ and F−, which smallest neutral ratio is correct?',
      'One barium ion to two fluoride ions',
      'Two barium ions to one fluoride ion',
      'One barium ion to one fluoride ion',
      'Three barium ions to two fluoride ions',
      'The +2 charge requires two −1 fluoride ions to balance.',
      'Charge mastery'
    ],
    [
      'Which explanation correctly distinguishes H2 from NaCl in their usual molecular and crystalline forms?',
      'H2 is a discrete molecule; NaCl expresses a repeating ionic ratio',
      'Both labels always denote isolated two-atom molecules',
      'H2 is a lattice ratio while NaCl is only an electron pair',
      'Neither formula contains information about particle counts',
      'Molecular atom counts and ionic formula-unit ratios describe different structures.',
      'Structure mastery'
    ],
    [
      'A drawing shows O=O. How many electrons belong to the shared pairs represented by those lines?',
      '4',
      '2',
      '6',
      '8',
      'Two lines represent two shared pairs, and each pair contains two electrons.',
      'Sharing mastery'
    ],
  ],
);

final _motionForces = scienceTopic(
  grade: 'g9',
  order: 4,
  title: 'Motion & Forces',
  subtitle:
      'Use signed motion quantities and net force to explain acceleration.',
  minutes: 'About 30–35 minutes',
  prerequisiteTopicId: 'science.g9.chemical-bonding',
  objectives: [
    'Distinguish distance and speed from displacement and velocity.',
    'Calculate average acceleration using signed velocities.',
    'Combine one-dimensional forces and apply Fnet = ma.',
    'Distinguish balanced forces on one object from a third-law interaction pair.'
  ],
  introduction:
      'A cart can travel to the right while accelerating to the left, and a moving object can have zero net force. These statements sound contradictory only if speed, velocity and acceleration are treated as the same quantity. A consistent direction convention allows us to describe the motion first and then explain its change using forces.',
  sections: [
    scienceSection('Specify the object and the reference direction',
        '''Position tells where an object is relative to a chosen origin. In one dimension, choose a positive direction such as east or right. A position of −3 m then means three meters on the negative side of the origin, not a negative physical length. State the convention before substituting numbers into an equation.

A scalar has magnitude without a direction; distance, time and speed are examples. A vector has magnitude and direction; displacement, velocity, acceleration and force are examples. In straight-line problems, a positive or negative sign can represent direction. The sign belongs to the chosen coordinate system. Another observer could choose west as positive and assign opposite signs while describing the same physical event. Consistency matters more than choosing one special positive direction.'''),
    scienceSection('Distance and displacement answer different questions',
        '''Distance is the total path length traveled. Displacement is final position minus initial position: Δx = xf − xi. Walk six meters east and then six meters west to the starting point. Your distance is twelve meters, but displacement is zero. The return journey does not erase the path already traveled; it cancels the signed change in position.

Average speed is total distance divided by elapsed time. Average velocity is displacement divided by elapsed time. If that twelve-meter return trip takes eight seconds, average speed is 12/8 = 1.5 m/s, while average velocity is 0/8 = 0 m/s. Zero average velocity therefore does not mean the object remained still. Average values describe the complete interval and need not equal the speed or velocity at every instant.'''),
    scienceVisual('sci-g9-4-vectors',
        'Keep the total route separate from the change in position.'),
    scienceSection('Acceleration measures velocity change',
        '''Average acceleration is change in velocity divided by elapsed time: aavg = (vf − vi)/Δt. Its unit is m/s², read meters per second per second. A constant acceleration of +2 m/s² means signed velocity increases by 2 m/s during each second. It does not mean the object travels only two meters every second.

Take right as positive. A velocity change from +2 to +8 m/s in three seconds gives (8 − 2)/3 = +2 m/s². A change from +8 to +2 gives (2 − 8)/3 = −2 m/s². This second object is moving right but slowing down. Now change from −2 to −8 m/s in three seconds: (−8 − (−2))/3 = −2 m/s². This time the object moves left and speeds up. Negative acceleration specifies direction; whether speed increases depends on the relationship between velocity and acceleration.'''),
    scienceVisual('sci-g9-4-acceleration',
        'A negative acceleration can accompany either rising or falling speed.'),
    scienceSection('Read motion records and changing direction',
        '''On a position–time graph, the slope gives velocity for a straight segment: position change divided by time change. A steeper positive slope means a greater positive velocity, while a horizontal segment means constant position. On a velocity–time graph, slope gives acceleration. A horizontal velocity line means zero acceleration, even if it sits above or below zero and the object is moving.

Velocity also changes when direction changes. A vehicle following a curved path at constant speed accelerates because its direction of motion changes. This broader definition is why scalar speed alone is insufficient for describing forces. Our numerical exercises stay in one dimension, but the direction-change example shows the limit of reasoning only with how fast an object moves.'''),
    scienceSection('Draw forces on one chosen system',
        '''A force is an interaction that can affect an object's motion. Select a system, such as the entire cart, and include the external forces acting on that system. Represent each force with an arrow showing its direction. Add forces as vectors to obtain net force, Fnet. For horizontal one-dimensional motion, rightward forces can be positive and leftward forces negative.

Newton's first law says that when the net force is zero, velocity remains constant in an inertial reference frame. A cart may remain at rest or continue moving in a straight line at constant speed. Zero net force is not the same as zero forces: equal opposing forces can balance. Conversely, a force arrow pointing right does not prove the cart currently moves right. Force determines acceleration, and the cart may already be moving in another direction.'''),
    scienceSection('Worked example: use the resultant, not one arrow',
        '''A two-kilogram cart experiences an 8 N force right and a 2 N resistance force left. Vertical forces balance. With right positive, the horizontal net force is +8 + (−2) = +6 N. Newton's second law for this constant-mass system is Fnet = ma. Divide by mass: a = 6/2 = +3 m/s², so acceleration is rightward.

The unit check is useful: one newton equals one kilogram meter per second squared, so N/kg gives m/s². Using 8/2 would ignore the resistance and overestimate acceleration. If the cart initially moves left, this rightward acceleration first reduces its leftward speed. If it starts at rest and these forces remain constant for two seconds, vf = vi + aΔt = 0 + 3 × 2 = +6 m/s. A change of force or mass requires reconsidering the model.'''),
    scienceVisual('sci-g9-4-newton',
        'Combine forces on the cart and then calculate its acceleration.'),
    scienceSection('Guided example: reverse the unknown',
        '''A three-kilogram trolley accelerates left at 2 m/s². Taking right positive gives a = −2 m/s², so Fnet = 3 × (−2) = −6 N. This is a net force of six newtons left. Suppose a four-newton rightward force also acts and the only other horizontal force is leftward. The leftward force must be ten newtons, because +4 + (−10) = −6. Net force is the sum, not automatically the size of each individual force.

For fixed mass, doubling net force doubles acceleration. For fixed net force, doubling mass halves acceleration. These comparisons describe proportional relationships under stated conditions; they do not mean that every heavier object always accelerates less regardless of the forces on it.'''),
    scienceSection('Interaction pairs do not cancel on one object',
        '''Newton's third law states that when object A exerts a force on object B, B exerts an equal-magnitude, opposite-direction force on A. A hand pushing a cart and the cart pushing the hand form one pair. They act on different objects, so they do not cancel in a force sum for the cart alone.

Weight downward on a cart and support upward from a level floor can balance on the cart, but they are not a third-law pair. Their interaction partners involve different sources: Earth pulls on the cart and the cart pulls on Earth; the floor pushes on the cart and the cart pushes on the floor. A force diagram must identify both the object receiving the force and the object exerting it.'''),
    scienceSection('Activity: investigate a supplied record',
        '''Use a paper table with times 0, 1, 2 and 3 s and velocities 1, 3, 5 and 7 m/s to the right. Calculate the change over each one-second interval: every change is +2 m/s. The record supports constant acceleration of +2 m/s² during the sampled intervals. For a mass of four kilograms, the corresponding net force is +8 N if the constant-acceleration model applies between samples.

Sketch the velocity points and connect them with a straight line for that model. Explain the distinction between the measured samples and the assumed behavior between them. You need no road experiment, fast-moving object or heavy load to test the arithmetic and the reasoning.'''),
    scienceSection('Common mistakes',
        'Distance is not displacement. Negative acceleration is not automatically slowing down. A horizontal velocity graph can represent motion. Use net force in Fnet = ma. Balanced forces act on one object; a third-law pair acts on different objects. Acceleration direction does not by itself identify current velocity.'),
    scienceSection('Quick check',
        'With right positive, a cart changes from −6 to −2 m/s in two seconds. What is its average acceleration, and is its speed rising or falling? What net force produces this acceleration for a 5 kg cart?'),
    scienceSection('Check your thinking',
        'Acceleration is (−2 − (−6))/2 = +2 m/s², rightward. Speed falls from 6 to 2 m/s while the cart still moves left. Net force is 5 × 2 = +10 N, also rightward.',
        reveal: true),
    scienceSection('Recap',
        'Choose a system and direction convention. Calculate signed displacement, velocity change and acceleration, then add forces on that system. Use Fnet = ma to link the force result to acceleration. Keep current motion, change of motion and interaction partners distinct.'),
  ],
  keyConcept:
      'Velocity includes direction, acceleration measures its change, and net force causes acceleration. Signed quantities and a clearly chosen system prevent confusion between motion, balance and interaction pairs.',
  questions: [
    [
      'Which quantity is a vector?',
      'Displacement',
      'Distance',
      'Elapsed time',
      'Speed',
      'Displacement includes direction as well as magnitude.',
      'Vectors'
    ],
    [
      'How is displacement calculated in one dimension?',
      'Final position minus initial position',
      'Total path length plus elapsed time',
      'Initial speed multiplied by mass in every case',
      'The sum of all positions without signs',
      'Displacement is the signed change in position, xf − xi.',
      'Displacement'
    ],
    [
      'Which expression gives average velocity?',
      'Displacement divided by elapsed time',
      'Distance divided by mass',
      'Net force divided by elapsed time',
      'Speed multiplied by distance',
      'Average velocity uses displacement, unlike average speed which uses distance.',
      'Average velocity'
    ],
    [
      'What is the SI unit of acceleration?',
      'm/s²',
      'm/s',
      'N/s',
      'kg/m',
      'Acceleration measures velocity change per second, giving m/s².',
      'Acceleration units'
    ],
    [
      'A horizontal velocity–time segment represents what?',
      'Constant velocity and zero acceleration',
      'A steadily increasing velocity',
      'An object necessarily at rest',
      'A changing velocity with zero elapsed time',
      'Zero slope on a velocity graph means zero acceleration, even at nonzero velocity.',
      'Graph meaning'
    ],
    [
      'Which quantity belongs in Fnet = ma?',
      'The vector sum of forces on the chosen system',
      'Only the largest force arrow',
      'Only a force on a different object',
      'The distance the system has traveled',
      'Newton’s second law uses the net force on the selected system.',
      'Net force'
    ],
    [
      'On which objects do the two forces of a third-law pair act?',
      'Different interacting objects',
      'Only one shared object',
      'Neither object until motion starts',
      'Only whichever object has more mass',
      'Each force in an interaction pair acts on the other interacting object.',
      'Third law'
    ],
    [
      'A learner travels 6 m east and 6 m west in 8 s. What is average speed?',
      '1.5 m/s',
      '0 m/s',
      '0.75 m/s',
      '12 m/s',
      'Total distance is 12 m, so average speed is 12/8 = 1.5 m/s.',
      'Return speed'
    ],
    [
      'For that 6 m east then 6 m west trip, what is average velocity over the complete 8 s?',
      '0 m/s',
      '1.5 m/s east',
      '1.5 m/s west',
      '6 m/s east',
      'Returning to the initial position gives zero displacement and average velocity.',
      'Return velocity'
    ],
    [
      'Right is positive. Velocity changes from +2 to +8 m/s in 3 s. What is average acceleration?',
      '+2 m/s²',
      '+6 m/s²',
      '−2 m/s²',
      '+10 m/s²',
      'The change is +6 m/s over 3 s, giving +2 m/s².',
      'Acceleration calculation'
    ],
    [
      'Right is positive. Velocity changes from −2 to −8 m/s in 3 s. What happens?',
      'Acceleration is −2 m/s² and speed increases',
      'Acceleration is +2 m/s² and speed decreases',
      'Acceleration is zero because both velocities are negative',
      'Acceleration is −2 m/s² and speed must decrease',
      'The signed change is −6 m/s, while speed increases from 2 to 8 m/s.',
      'Negative acceleration'
    ],
    [
      'A 2 kg cart has 8 N right and 2 N left acting horizontally. What is its acceleration?',
      '3 m/s² right',
      '4 m/s² right',
      '5 m/s² right',
      '3 m/s² left',
      'Net force is 6 N right, and 6/2 gives 3 m/s² right.',
      'Second law'
    ],
    [
      'What net force gives a 3 kg trolley an acceleration of 2 m/s² left?',
      '6 N left',
      '1.5 N left',
      '6 N right',
      '5 N left',
      'Fnet = ma = 3 × 2 = 6 N in the acceleration direction.',
      'Force calculation'
    ],
    [
      'If net force remains fixed while mass doubles, what happens to acceleration?',
      'It halves',
      'It doubles',
      'It stays unchanged',
      'It necessarily becomes zero',
      'From a = Fnet/m, doubling mass at fixed net force halves acceleration.',
      'Mass dependence'
    ],
    [
      'A cart moves right while its net force points left. What follows at that instant?',
      'Its rightward speed is decreasing',
      'It must already be moving left',
      'Its acceleration points right',
      'Its net force must actually be zero',
      'Acceleration opposes the current velocity, reducing its speed initially.',
      'Motion reasoning'
    ],
    [
      'A cart travels straight at constant nonzero velocity. Which force conclusion is valid?',
      'Its net force is zero',
      'No individual force can act on it',
      'Its net force points forward',
      'Its mass must be zero',
      'Constant velocity means zero acceleration and therefore zero net force.',
      'Balanced motion'
    ],
    [
      'Why are upward floor support and downward cart weight not a third-law pair?',
      'They both act on the cart and come from different interactions',
      'They can never have equal magnitudes',
      'Gravity never has an interaction partner',
      'Support force exists only when the cart accelerates',
      'Third-law partners act on different objects within one interaction.',
      'Force pair reasoning'
    ],
    [
      'A 3 kg trolley has 4 N rightward force and accelerates 2 m/s² left. What is the only other horizontal force?',
      '10 N left',
      '6 N left',
      '2 N left',
      '10 N right',
      'Required net force is −6 N; +4 − 10 = −6 N.',
      'Missing force'
    ],
    [
      'A vehicle follows a curved path at constant speed. Why can it accelerate?',
      'Its velocity direction changes',
      'Acceleration only measures distance traveled',
      'Constant speed always implies constant velocity',
      'A curved path removes all net forces',
      'Velocity includes direction, so turning changes velocity even at constant speed.',
      'Direction change'
    ],
    [
      'A table gives velocities 1, 3, 5 and 7 m/s at 0, 1, 2 and 3 s. What does a constant-acceleration model predict for a 4 kg object?',
      'A net force of 8 N in the positive direction',
      'A net force of 4 N in the positive direction',
      'A net force of zero throughout',
      'A net force of 28 N throughout',
      'Velocity increases by 2 m/s each second; Fnet = 4 × 2 = 8 N.',
      'Data interpretation'
    ],
    [
      'With east positive, velocity changes from −9 to −3 m/s in 3 s. Which description is correct?',
      'Acceleration is +2 m/s² while westward speed decreases',
      'Acceleration is −2 m/s² while westward speed decreases',
      'Acceleration is +4 m/s² while eastward speed increases',
      'Acceleration is zero because the object remains westbound',
      'The velocity change is +6 m/s in 3 s, and speed falls from 9 to 3 m/s.',
      'Signed motion mastery'
    ],
    [
      'A 5 kg cart experiences 17 N right and 7 N left. Starting from rest, what velocity follows after 3 s of these constant forces?',
      '6 m/s right',
      '10 m/s right',
      '2 m/s right',
      '6 m/s left',
      'Net force is 10 N right, acceleration is 2 m/s², and velocity gain is 6 m/s.',
      'Force motion mastery'
    ],
    [
      'A hand pushes a cart with 12 N rightward. Which is the third-law partner?',
      'The cart pushes the hand with 12 N leftward',
      'The floor pushes the cart upward with 12 N',
      'Earth pulls the cart downward with 12 N',
      'Resistance pushes the cart leftward with any magnitude',
      'The partner reverses source and receiver within the hand–cart interaction.',
      'Interaction mastery'
    ],
  ],
);
