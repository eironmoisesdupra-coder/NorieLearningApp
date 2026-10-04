import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';
import 'grade_10_ecosystems.dart';

final List<NorieTopicContent> grade10ScienceTopics = [
  _evolution,
  _periodicTable,
  _acidsBases,
  _electricityMagnetism,
  grade10EcosystemsTopic
];

const Map<String, ScienceFigure> grade10ScienceFigures = {
  'sci-g10-1-selection': ScienceFigure(
      picture: 'g10-selection',
      title: 'Compare generations, not changing individuals',
      kind: 'comparison',
      labels: [
        'Earlier: 10 of 100',
        'Selection and inheritance',
        'Later: 40 of 100'
      ],
      details: [
        '10% have the inherited resistance trait.',
        'Under exposure, resistant organisms contribute more descendants on average.',
        '40% have the trait in the sampled later generation.'
      ],
      note:
          'Invented equal-size samples. The increase is 30 percentage points; the proportion is four times the earlier proportion.'),
  'sci-g10-1-mechanisms': ScienceFigure(
      title: 'Different mechanisms can change allele frequency',
      kind: 'comparison',
      labels: ['Selection', 'Drift', 'Gene flow'],
      details: [
        'Heritable differences affect reproductive success in the current environment.',
        'Chance sampling changes which alleles are passed on, especially in small populations.',
        'Migrants reproduce and introduce or remove alleles.'
      ],
      note:
          'A frequency change alone does not identify its cause. Mechanisms may operate together.'),
  'sci-g10-1-evidence': ScienceFigure(
      title: 'Test ancestry with independent evidence',
      kind: 'comparison',
      labels: ['Fossils', 'Homologous structures', 'DNA comparisons'],
      details: [
        'Dated sequences document past organisms and transitions.',
        'Shared underlying arrangements can persist despite different functions.',
        'Corresponding inherited sequences can reveal relatedness.'
      ],
      note:
          'Agreement among independent observations strengthens an ancestry explanation; similar function alone is insufficient.'),
  'sci-g10-2-shells': ScienceFigure(
      picture: 'g10-periodic',
      title: 'A shared period can contain different valence counts',
      kind: 'comparison',
      labels: ['Na: 2,8,1', 'Mg: 2,8,2', 'Cl: 2,8,7'],
      details: [
        'Atomic number 11; period 3; group 1.',
        'Atomic number 12; period 3; group 2.',
        'Atomic number 17; period 3; group 17.'
      ],
      note:
          'Neutral ground-state atoms in a simplified shell model; shells are not fixed planetary paths.'),
  'sci-g10-2-trends': ScienceFigure(
      title: 'Explain trends using attraction and shielding',
      kind: 'comparison',
      labels: [
        'Across a main-group period',
        'Down a main-group family',
        'Check the property'
      ],
      details: [
        'Atomic radius generally decreases as nuclear attraction on outer electrons increases.',
        'Additional occupied shells and shielding generally increase atomic radius.',
        'First ionization energy generally rises across and falls down, with exceptions.'
      ],
      note:
          'These are general trends for neutral atoms, not an exception-free ranking of every neighboring element.'),
  'sci-g10-2-ions': ScienceFigure(
      title: 'An ion changes electrons, not element identity',
      kind: 'comparison',
      labels: ['Na becomes Na+', 'Mg becomes Mg2+', 'Cl becomes Cl−'],
      details: [
        '11 protons remain; electrons decrease from 11 to 10.',
        '12 protons remain; electrons decrease from 12 to 10.',
        '17 protons remain; electrons increase from 17 to 18.'
      ],
      note:
          'These common ion charges help predict simple ionic ratios: MgCl2 balances +2 with two −1 charges.'),
  'sci-g10-3-ph': ScienceFigure(
      picture: 'g10-ph',
      title: 'Two pH steps correspond to a hundredfold ratio',
      kind: 'comparison',
      labels: ['pH 3', 'pH 5', 'Compare concentration'],
      details: [
        'Approximate hydronium concentration: 10⁻³ mol/L.',
        'Approximate hydronium concentration: 10⁻⁵ mol/L.',
        'The pH 3 solution has 100 times the hydronium concentration.'
      ],
      note:
          'Dilute aqueous model. Equal volumes are illustrated, but pH itself describes a concentration-related quantity, not total volume.'),
  'sci-g10-3-strength': ScienceFigure(
      title: 'Strength and concentration answer different questions',
      kind: 'comparison',
      labels: ['Strong acid', 'Weak acid', 'Concentration'],
      details: [
        'Ionizes essentially completely in the introductory aqueous model.',
        'Only a fraction of dissolved acid molecules ionize at equilibrium.',
        'Amount of dissolved acid per solution volume, independent of the strength label.'
      ],
      note:
          'A strong acid may be dilute; a weak acid may be concentrated. Neither label by itself establishes safe handling.'),
  'sci-g10-3-neutralization': ScienceFigure(
      title: 'Count reacting ions before predicting leftovers',
      kind: 'process',
      labels: ['Hydronium plus hydroxide', 'Water forms', 'Check excess'],
      details: [
        'H3O+ + OH− → 2H2O.',
        'Equal amounts of these reacting ions consume each other.',
        'Excess acid or base changes the final solution; equal volumes alone do not guarantee equal amounts.'
      ],
      note:
          'For a strong monoprotic acid and strong hydroxide base at equivalence, neutral pH is approximately 7 at 25 °C. Other acid/base salts can affect pH.'),
  'sci-g10-4-circuit': ScienceFigure(
      picture: 'g10-circuit',
      title: 'Connect voltage, resistance, current and power',
      kind: 'process',
      labels: ['12 V supply', '6 Ω resistor', '2 A; 24 W'],
      details: [
        'The ideal supply maintains a 12 V potential difference.',
        'At fixed temperature, I = V/R = 12/6 = 2 A.',
        'P = VI = 12 × 2 = 24 W.'
      ],
      note:
          'An ideal closed circuit with negligible wire resistance. Charge circulates; electrical energy is transferred to thermal energy.'),
  'sci-g10-4-branches': ScienceFigure(
      title: 'Follow paths before choosing circuit rules',
      kind: 'comparison',
      labels: ['Series', 'Parallel', 'Conservation'],
      details: [
        'One path; same current; voltage drops add; resistances add.',
        'Multiple paths; each branch spans the same two connection points and has the same voltage.',
        'At a junction, total current entering equals total current leaving.'
      ],
      note:
          'Ideal steady direct-current circuits. Opening one series path stops its current; another intact parallel branch can still conduct.'),
  'sci-g10-4-fields': ScienceFigure(
      title: 'Current creates fields; changing flux induces voltage',
      kind: 'comparison',
      labels: [
        'Current-carrying coil',
        'Reverse current',
        'Move a magnet relative to a coil'
      ],
      details: [
        'A magnetic field is produced; more current generally strengthens it for the same coil.',
        'The magnetic field direction reverses.',
        'Changing magnetic flux through the coil can induce voltage and current in a closed circuit.'
      ],
      note:
          'A stationary magnet and stationary coil with unchanging flux do not sustain induction. A generator transfers mechanical energy into electrical energy.'),
  ...grade10EcosystemsFigures,
};

final _evolution = scienceTopic(
  grade: 'g10',
  order: 1,
  title: 'Evolution',
  subtitle: 'Explain inherited population change with evidence',
  minutes: '25–30 minutes',
  prerequisiteTopicId: null,
  objectives: [
    'Explain natural selection using variation, inheritance and reproductive success.',
    'Calculate trait and allele frequencies with appropriate denominators.',
    'Distinguish selection, genetic drift and gene flow.',
    'Connect independent evidence to shared ancestry.'
  ],
  introduction:
      'Two insect populations can contain the same inherited color variants yet change differently after their environments diverge. Explaining that difference requires more than saying that organisms adapt. We need to track generations, ask which differences are inherited, and test why some variants become more common. Evolution provides a framework for making these explanations measurable.',
  sections: [
    scienceSection('The population is the unit of evolutionary change',
        '''Biological evolution is change in inherited characteristics of populations across generations. In population genetics, a useful measurement is allele frequency: the fraction of copies of a gene that are a particular variant. A population consists of members of the same species living in an area and potentially reproducing with one another. An individual can grow, learn or acclimatize during its lifetime without its population evolving.

Suppose sunlight causes a person to tan. That observation concerns a response within one body; it does not demonstrate a changing frequency of inherited variants across generations. Conversely, an inherited variant may become more common without every individual visibly changing. Separate the time scale of an individual response from the time scale of parent-to-offspring transmission.'''),
    scienceSection('How natural selection connects causes',
        '''Natural selection requires variation, inheritance, and differences in reproductive success associated with that variation. Individuals already differ. Some differences have a genetic basis that can be passed to descendants. Under particular conditions, individuals carrying certain variants leave more surviving reproductive offspring on average. Those variants can consequently become more common over generations.

Fitness in this context is relative reproductive contribution, not simply strength, speed or long life. A long-lived organism that leaves no descendants contributes less directly to the next generation than one that successfully reproduces. A trait can help in one setting and impose a cost in another. Selection has no foresight and no goal of producing a perfect organism. Mutation supplies new alleles, but mutations do not appear because an organism consciously needs them. Selection acts on available inherited variation.'''),
    scienceVisual('sci-g10-1-selection',
        'Read each group as a sample from a different generation.'),
    scienceSection('Resistance: survivors have descendants',
        '''Imagine bacteria with inherited differences in susceptibility to an antibiotic. Before exposure, a small fraction already carries resistance. Exposure reduces reproduction or survival of susceptible bacteria more strongly, while resistant bacteria can contribute disproportionately to subsequent generations. The proportion resistant may rise. This is a population explanation, not a story in which every exposed bacterium learns to resist.

Resistance can also spread when bacteria acquire genes from other bacteria. Our simple model holds that process aside to isolate selection. It also does not claim that resistance always increases or that all resistant bacteria survive every condition. When comparing cultures, scientists control exposure and measure reproduction rather than infer mechanism from a single photograph. Antibiotics act against bacteria; this lesson is an evolutionary model, not an instruction to grow microbes or choose treatment.'''),
    scienceSection('Worked example: choose the denominator',
        '''In an earlier sample, 10 of 100 organisms possess an inherited resistance trait. Its observed frequency is 10/100 = 0.10, or 10%. In a later-generation sample, 40 of 100 possess it: 40/100 = 0.40, or 40%. The change is 40% − 10% = 30 percentage points. The later proportion is 40/10 = 4 times the earlier one. Percentage-point change and multiplicative change answer different questions.

Trait frequency is not automatically allele frequency. For a diploid gene, each individual contributes two allele copies. If 50 individuals carry 30 copies of allele A in total, the denominator is 100 copies, giving 30/100 = 0.30. We cannot usually count a dominant-looking trait and assume that count equals the number of dominant alleles: different genotypes may produce the same phenotype.'''),
    scienceSection('Change can happen without an advantage',
        '''Genetic drift is change in allele frequency caused by chance sampling of which alleles survive or reproduce. Its effects are particularly strong in small populations. A storm that randomly removes organisms regardless of their inherited color can alter color-allele frequencies among survivors. If a few individuals establish a new population, their allele proportions may differ by chance from the source population; this is the founder effect.

Gene flow occurs when movement between populations is followed by reproduction that transfers alleles. Migration without reproductive contribution need not produce gene flow. Selection, drift, mutation and gene flow can act together, so detecting frequency change alone does not prove selection. To support selection specifically, look for a repeatable connection between inherited variation and reproductive success under the relevant conditions.'''),
    scienceVisual('sci-g10-1-mechanisms',
        'Identify the process responsible for the change, not merely its direction.'),
    scienceSection('Evidence connects living and extinct organisms',
        '''Fossils provide evidence of past organisms and their sequence through time. In undisturbed sedimentary layers, lower layers generally formed earlier; dating methods provide additional time constraints. Gaps in preservation mean that the fossil record is incomplete, but incompleteness does not erase the patterns that are preserved.

Homologous structures share an underlying inherited arrangement even when their present functions differ. Corresponding forelimb bones in mammals support common ancestry; similar function alone, such as flight, is weaker evidence because similar environments can favor similar solutions independently. Comparisons of corresponding DNA sequences provide another line of evidence. Scientists compare suitable sequences and many characters, not merely overall appearance. Agreement among fossils, anatomy and molecular evidence strengthens an explanation of descent with modification. A branching family tree represents shared ancestors; a living species is not automatically the direct ancestor of another living species.'''),
    scienceVisual('sci-g10-1-evidence',
        'Look for agreement among independent observations.'),
    scienceSection('Guided investigation: distinguish drift from selection',
        '''Draw twenty paper circles representing individuals, ten striped and ten plain. Assume the difference is inherited. First remove five circles by drawing covered labels blindly. Record the survivor proportions and repeat with a reset population. Differences among trials demonstrate sampling variation, not that stripes cause survival. Next model a stated environment by deliberately removing more visible plain circles, then let each survivor contribute the same number of descendants. Explain why that rule represents differential survival linked to an inherited trait.

Neither paper model establishes what occurs in a real species. The first assumes random removal; the second builds a selective difference into its rules. In real investigations, compare repeated populations, measure environmental conditions, and test inheritance. If a color becomes more common after one storm, both selective survival and chance may remain possible until more evidence separates them.'''),
    scienceSection('Common mistakes',
        'Individuals do not evolve a needed allele by wishing. Selection does not mean all change is beneficial. Survival matters evolutionarily through reproductive contribution. A larger count is not necessarily a larger proportion if population size also changes. Frequency change supports evolution but does not alone distinguish drift from selection. Shared ancestry does not place modern species on a ladder from inferior to superior.'),
    scienceSection('Quick check',
        'A trait occurs in 12 of 60 organisms and later 30 of 100. What are the two frequencies? Does this alone show selection? What additional observation would strengthen a selection explanation?'),
    scienceSection('Check your thinking',
        'The frequencies are 20% and 30%, a rise of 10 percentage points. If the trait is inherited, the change is consistent with evolutionary change, but the counts alone do not identify its mechanism. Evidence that the trait predicts greater reproductive success under the changed conditions would support selection.',
        reveal: true),
    scienceSection('Recap',
        'Track inherited variants through generations. Calculate proportions using the correct total, then evaluate mechanisms using evidence about reproduction, migration and chance. Connect population change to the broader evidence for shared ancestry without assuming that organisms change because they need to.'),
  ],
  keyConcept:
      'Evolution changes inherited population characteristics across generations. Natural selection is differential reproductive success associated with heritable variation; drift and gene flow can also change allele frequencies.',
  questions: [
    [
      'Which observation directly concerns biological evolution?',
      'An inherited variant changes frequency across generations',
      'One person learns a new route',
      'One plant wilts during an afternoon',
      'One animal grows heavier after feeding',
      'Evolution concerns inherited population change across generations.',
      'Evolution'
    ],
    [
      'What does an allele frequency count?',
      'A particular allele as a fraction of all copies of that gene',
      'Only the oldest individuals in a population',
      'The number of species in an ecosystem',
      'Only individuals showing a dominant phenotype',
      'Allele frequency uses gene copies, not simply visible trait counts.',
      'Allele frequency'
    ],
    [
      'Which combination is necessary for natural selection in this model?',
      'Heritable variation and differing reproductive success',
      'Identical individuals and identical reproduction',
      'A conscious decision to change DNA',
      'A guaranteed improvement in every environment',
      'Selection connects inherited differences with reproductive contribution.',
      'Natural selection'
    ],
    [
      'What does evolutionary fitness emphasize?',
      'Relative reproductive contribution',
      'Maximum body size regardless of offspring',
      'Longest lifespan regardless of reproduction',
      'Ability to learn every new skill',
      'Fitness concerns contribution to later generations in a particular environment.',
      'Fitness'
    ],
    [
      'Which process changes allele frequencies through chance sampling?',
      'Genetic drift',
      'Deliberate mutation',
      'Acclimatization within one body',
      'Learning by observation',
      'Genetic drift reflects chance differences in which alleles are passed on.',
      'Drift'
    ],
    [
      'When does migration produce gene flow?',
      'Migrants reproduce and transfer alleles into the population',
      'Visitors leave without reproducing',
      'An individual merely crosses a boundary',
      'All migrants lose every inherited variant',
      'Reproductive contribution is needed to transfer alleles between populations.',
      'Gene flow'
    ],
    [
      'Which observation is an individual response rather than evidence of evolution?',
      'One person tans during summer',
      'An inherited allele increases over ten generations',
      'A founder population has changed allele proportions',
      'Resistance becomes more common among descendants',
      'Tanning within one lifetime does not establish inherited population change.',
      'Time scales'
    ],
    [
      'A trait occurs in 18 of 60 organisms. What is its frequency?',
      '30%',
      '18%',
      '60%',
      '3%',
      'Divide 18 by 60 to obtain 0.30, or 30 percent.',
      'Trait frequency'
    ],
    [
      'A population has 40 diploid individuals. How many copies of one autosomal gene are counted?',
      '80',
      '40',
      '20',
      '160',
      'Each diploid individual contributes two copies: 40 × 2 = 80.',
      'Allele denominator'
    ],
    [
      'Resistance rises from 10% to 40%. What is the percentage-point increase?',
      '30 percentage points',
      '4 percentage points',
      '50 percentage points',
      '400 percentage points',
      'Subtract the percentages: 40 − 10 = 30 percentage points.',
      'Frequency change'
    ],
    [
      'Why can an inherited trait be favored in one environment but not another?',
      'Its effects on reproductive success depend on conditions',
      'Fitness always means the same physical strength',
      'Alleles understand the future environment',
      'Every trait helps equally in every setting',
      'Costs and benefits depend on the conditions affecting survival and reproduction.',
      'Context'
    ],
    [
      'A few colonists carry unusual allele proportions by chance. Which mechanism fits?',
      'Founder effect',
      'Selection proven by large body size',
      'Acquired knowledge becoming an allele',
      'Identical sampling from the entire species',
      'A small founding sample may differ randomly from its source population.',
      'Founder effect'
    ],
    [
      'Why are homologous mammal forelimbs evidence for ancestry?',
      'They retain corresponding underlying bone arrangements',
      'They must perform exactly the same task',
      'They show that living mammals never change',
      'They prove one living mammal is the parent of every other',
      'Shared inherited structural arrangements support descent from common ancestors.',
      'Homology'
    ],
    [
      'What strengthens an ancestry explanation most?',
      'Agreement among fossils, corresponding anatomy and DNA',
      'One superficial similarity with no other comparison',
      'A claim that every fossil must be preserved',
      'A ranking based only on body size',
      'Independent evidence that converges on relatedness strengthens the explanation.',
      'Evidence'
    ],
    [
      'A resistance allele becomes common after exposure. Which finding specifically supports selection?',
      'Carriers leave more reproductive descendants during exposure',
      'The organisms wanted to survive',
      'Population size was measured only once',
      'Every individual had an identical genotype',
      'Differential reproductive success linked to an inherited variant supports selection.',
      'Testing selection'
    ],
    [
      'A storm removes colors randomly in a small population. Frequencies change. Which inference fits?',
      'Drift can explain the shift without a color advantage',
      'The surviving color must be better camouflaged',
      'Every lost allele was harmful',
      'The storm taught survivors a new allele',
      'Random removal can change allele proportions without a selective advantage.',
      'Drift inference'
    ],
    [
      'In 50 diploid individuals there are 30 copies of A. What is the A frequency?',
      '0.30',
      '0.60',
      '0.15',
      '1.67',
      'There are 100 total copies, so 30/100 = 0.30.',
      'Counting alleles'
    ],
    [
      'A trait count rises from 20 of 100 to 30 of 200. What happened to its proportion?',
      'It fell from 20% to 15%',
      'It rose from 20% to 30%',
      'It stayed at 20%',
      'It doubled from 10% to 20%',
      'Compare proportions: 20/100 = 20%, while 30/200 = 15%.',
      'Changing totals'
    ],
    [
      'Why does counting a dominant phenotype not always reveal allele frequency?',
      'Different genotypes can produce the same phenotype',
      'Dominant phenotypes have no inherited basis',
      'Every dominant individual has only one gene copy',
      'All recessive alleles vanish when unexpressed',
      'A dominant-looking individual may carry one or two copies of the dominant allele.',
      'Phenotype limitation'
    ],
    [
      'Two populations show the same frequency increase. What can be concluded from that alone?',
      'The same numerical change can arise through different mechanisms',
      'Both changes must be caused by selection',
      'Both changes must be caused by gene flow',
      'Neither population can have evolved',
      'Frequency data describe change but do not by themselves identify its cause.',
      'Mechanism evidence'
    ],
    [
      'An inherited variant occurs in 16 of 80 organisms, then 24 of 80 next generation. Which statement is correct?',
      'Its frequency rose by 10 percentage points',
      'Its frequency rose by 8 percentage points',
      'Its frequency doubled',
      'Its frequency stayed unchanged',
      'The proportions are 20% and 30%; their difference is 10 percentage points.',
      'Mastery frequency'
    ],
    [
      'After exposure, susceptible bacteria are rarer among descendants. Which explanation matches selection?',
      'Pre-existing inherited resistance increased reproductive contribution',
      'Each susceptible bacterium intentionally changed its genes',
      'Antibiotic exposure gave every cell equal reproductive success',
      'Resistance necessarily appeared because the cells wished for it',
      'Selection changes proportions through unequal reproductive success of inherited variants.',
      'Mastery resistance'
    ],
    [
      'A random sample of founders differs genetically from its source. No trait advantage is observed. What is best supported?',
      'Chance sampling can explain the founder difference',
      'The founders must be superior in all environments',
      'Shared ancestry is disproven by different frequencies',
      'The sample proves deliberate adaptive mutation',
      'Founder effects arise from chance sampling and do not require a selective advantage.',
      'Mastery drift'
    ],
  ],
);

final _periodicTable = scienceTopic(
  grade: 'g10',
  order: 2,
  title: 'Periodic Table',
  subtitle: 'Use position and electron structure to explain patterns',
  minutes: '25–30 minutes',
  prerequisiteTopicId: 'science.g10.evolution',
  objectives: [
    'Use atomic number, period and group to interpret representative elements.',
    'Relate outer electrons to common ion charges in specified examples.',
    'Explain general radius and ionization-energy trends with limitations.',
    'Use charge balance to predict a simple ionic formula.'
  ],
  introduction:
      'Sodium and chlorine occupy the same row of the periodic table, but one commonly loses an electron while the other commonly gains one. Their positions organize more than names: they connect nuclear charge, electron arrangement and chemical behavior. This lesson uses a small set of representative elements to reason from those connections without pretending that every trend has no exceptions.',
  sections: [
    scienceSection('Read identity before predicting behavior',
        '''The modern periodic table orders elements by increasing atomic number, the number of protons in a nucleus. Every sodium atom has 11 protons, every magnesium atom has 12, and every chlorine atom has 17. A neutral atom has equal proton and electron counts. Changing electron count produces an ion; changing neutron count produces an isotope. Neither change alters the element while the proton count stays fixed.

The decimal atomic mass printed in a table commonly represents an abundance-weighted value for isotopes, not the proton count or a required whole-number mass for every atom. Read the label attached to each number. To identify an element, use atomic number. To determine a particular isotope's neutron count, use its mass number minus its atomic number. The table's organizing order is not a rule that atomic mass must increase without exception.'''),
    scienceSection('Rows, columns and outer electrons',
        '''A horizontal row is a period; a vertical column is a group, numbered 1 through 18. For the neutral ground-state main-group atoms used here, period corresponds to the highest occupied electron shell. Sodium, magnesium and chlorine occupy period 3. In our introductory shell model their electron counts are 2,8,1; 2,8,2; and 2,8,7 respectively. Each has three occupied shells, but their outer-shell counts differ.

Valence electrons are the outer electrons most involved in bonding in these examples. Main-group elements within a group have related valence arrangements and often related chemical behavior. Group 1 examples lithium and sodium have one valence electron; group 2 magnesium has two; group 17 fluorine and chlorine have seven. Group 18 neon and argon have filled outer shells. Helium is also group 18 but its filled first shell contains two electrons, not eight. Do not apply a simple group-number rule indiscriminately to transition metals.'''),
    scienceVisual('sci-g10-2-shells',
        'Compare the shared shell count with the differing outer-electron counts.'),
    scienceSection('From valence to common ions',
        '''Sodium commonly forms Na+ by losing one electron; 11 protons and 10 electrons leave net charge +1. Magnesium commonly forms Mg2+ by losing two; 12 protons and 10 electrons leave +2. Chlorine commonly forms Cl− by gaining one; 17 protons and 18 electrons leave −1. In each case the element name remains appropriate because the proton count has not changed.

These examples connect group position with useful predictions, but an atom does not decide that it wants a full shell. Chemical outcomes depend on energy changes and interactions with other particles. Filled-shell reasoning is an introductory pattern, not a universal explanation of all compounds. Many transition metals form more than one common ion charge, so a charge supplied in a question must be used rather than guessed from a simple outer-shell slogan.'''),
    scienceVisual('sci-g10-2-ions',
        'Verify net charge by subtracting electron count from proton count.'),
    scienceSection('Atomic radius: attraction competes with shell structure',
        '''Atomic radius is a measure of atomic size; because electron clouds have no sharp solid edge, definitions depend on how atoms are compared. For consistent comparisons of neutral main-group atoms, radius generally decreases from left to right across a period. Proton number rises while added electrons enter the same principal shell. The increasing effective attraction tends to pull the outer electron cloud closer.

Down a main-group family, atoms generally become larger. Additional occupied shells put outer electrons farther from the nucleus, and inner electrons shield some nuclear attraction. Sodium is therefore larger than lithium, while chlorine is smaller than sodium in the period-3 comparison. More protons alone do not guarantee a smaller atom: shell number and shielding also matter. These are general trends with a specified comparison, not precise measured radii calculated just by counting protons.'''),
    scienceSection('Ionization energy asks a different question',
        '''First ionization energy is the energy needed to remove the first electron from each neutral gaseous atom. A larger value means more energy is required for that removal; it does not mean a larger atomic radius. Across a main-group period, first ionization energy generally rises as outer electrons experience stronger attraction. Down a group, it generally falls as distance and shielding make an outer electron easier to remove.

The pattern has exceptions between some neighbors because electron configurations and electron pairing matter. For the specified comparisons here, sodium has a lower first ionization energy than chlorine, and sodium has a lower first ionization energy than lithium. Use the broad trend to explain those comparisons, but consult measured values when a problem asks for exact ordering of neighboring elements. Radius and ionization energy are different properties linked by the underlying attraction, not interchangeable names.'''),
    scienceVisual('sci-g10-2-trends',
        'Name the property, direction and assumptions before making a prediction.'),
    scienceSection('Worked example: combine position with charge balance',
        '''Consider magnesium, atomic number 12, with neutral shell arrangement 2,8,2. It has 12 protons and 12 electrons. Three occupied shells place it in period 3; two outer electrons fit group 2. Losing two electrons yields Mg2+ with 10 electrons. Chlorine forms Cl− in the example. A neutral ionic compound must balance charges: one Mg2+ requires two Cl− ions because +2 + 2(−1) = 0. The formula is MgCl2.

The subscript two counts chloride ions per magnesium ion in the lattice ratio. It does not mean chlorine has two extra electrons or that magnesium has changed atomic number. Similarly, Na+ and Cl− balance in a 1:1 ratio, giving NaCl. Always distinguish ion charge, atom count and proton count: they answer separate questions even when small numbers appear in all three places.'''),
    scienceSection('Guided activity: build a miniature table',
        '''Make paper cards for lithium (3; 2,1), sodium (11; 2,8,1), magnesium (12; 2,8,2), fluorine (9; 2,7), chlorine (17; 2,8,7), neon (10; 2,8), and argon (18; 2,8,8). Place cards with equal occupied-shell counts in rows. Align equal outer-electron patterns into columns. Leave gaps rather than force these selected elements into consecutive positions; this is a partial table.

Predict which pair should show related chemistry: sodium and lithium share an outer-electron pattern despite occupying different periods. Predict which is larger: sodium has an additional occupied shell. Then compare sodium with chlorine in the same period: chlorine generally has the smaller radius and greater first ionization energy. Write a reason using shells, shielding and attraction. The activity is a model of relationships, not permission to handle reactive elements.'''),
    scienceSection('Common mistakes',
        'Atomic number counts protons, not rounded atomic mass. A period is a row, and a group is a column. Equal periods do not imply equal valence counts. Forming an ion does not change element identity. Helium has a filled two-electron shell. Periodic trends are general and must be qualified; they do not erase configuration-dependent exceptions.'),
    scienceSection('Quick check',
        'A neutral atom has atomic number 17 and shell arrangement 2,8,7. Identify its period, valence count and electron count after forming its common −1 ion. Would its radius generally exceed that of sodium?'),
    scienceSection('Check your thinking',
        'It is chlorine in period 3 with seven valence electrons. Its −1 ion has 18 electrons and still 17 protons. Neutral chlorine generally has a smaller radius than neutral sodium because attraction strengthens across this period without adding a new principal shell.',
        reveal: true),
    scienceSection('Recap',
        'Start with proton count to identify an element. Use period and valence arrangement to compare specified main-group atoms. Explain general trends through attraction, shell number and shielding. For ionic formulas, conserve element identity and balance total positive and negative charge.'),
  ],
  keyConcept:
      'Periodic position organizes atomic number and recurring electron arrangements. These patterns support qualified predictions of size, ionization energy and common ion behavior in specified elements.',
  questions: [
    [
      'What determines the ordering of the modern periodic table?',
      'Increasing atomic number',
      'Increasing neutron count in every isotope',
      'Increasing density without exception',
      'Alphabetical element names',
      'The modern table orders elements by proton count, called atomic number.',
      'Table order'
    ],
    [
      'What is a period?',
      'A horizontal row',
      'A vertical column',
      'The number of neutrons alone',
      'The charge on every ion',
      'Periods are horizontal rows; groups are vertical columns.',
      'Period'
    ],
    [
      'What is a group?',
      'A vertical column',
      'A horizontal row',
      'A single isotope of every element',
      'The mass number of a neutral atom',
      'Groups organize elements vertically, often with related valence arrangements.',
      'Group'
    ],
    [
      'Neutral sodium has atomic number 11. How many electrons does it have?',
      '11',
      '10',
      '12',
      '23',
      'A neutral atom has equal proton and electron counts.',
      'Neutral charge'
    ],
    [
      'For sodium 2,8,1, how many valence electrons are in the simplified model?',
      '1',
      '2',
      '8',
      '11',
      'The final shell has one electron, so sodium has one valence electron here.',
      'Valence'
    ],
    [
      'Which electron arrangement belongs to neutral chlorine in this lesson?',
      '2,8,7',
      '2,8,1',
      '2,8,2',
      '2,8,8',
      'Chlorine has 17 electrons, arranged as 2,8,7 in the introductory model.',
      'Chlorine'
    ],
    [
      'Which number remains unchanged when magnesium forms Mg2+?',
      'Its proton count',
      'Its electron count',
      'Its net charge',
      'Its number of electrons lost',
      'Ion formation changes electrons while the nucleus retains its proton count.',
      'Ion identity'
    ],
    [
      'Why are sodium, magnesium and chlorine all in period 3?',
      'Their neutral ground-state atoms have three occupied shells',
      'They all have three valence electrons',
      'They all form ions with charge +3',
      'Their atomic numbers are all multiples of three',
      'Their shell arrangements each occupy three shells in the model.',
      'Shared period'
    ],
    [
      'Which pair has related outer-electron arrangements?',
      'Lithium and sodium',
      'Sodium and chlorine',
      'Magnesium and chlorine',
      'Lithium and neon',
      'Lithium and sodium are group 1 examples with one outer electron.',
      'Family patterns'
    ],
    [
      'How many electrons are in Mg2+ when magnesium has 12 protons?',
      '10',
      '12',
      '14',
      '2',
      'A +2 ion has two fewer electrons than protons: 12 − 2 = 10.',
      'Magnesium ion'
    ],
    [
      'Why is sodium generally larger than lithium?',
      'It has an additional occupied shell and more shielding',
      'It has fewer protons than lithium',
      'It has no inner electrons',
      'Its positive ion must have 11 valence electrons',
      'Down this group, added shells and shielding increase atomic size.',
      'Down-group radius'
    ],
    [
      'Across a main-group period, what generally happens to neutral atomic radius?',
      'It decreases as attraction on outer electrons strengthens',
      'It increases because a new shell is added at every step',
      'It stays identical for all elements',
      'It equals the atomic number in centimeters',
      'Across a period, stronger effective attraction generally contracts the electron cloud.',
      'Across-period radius'
    ],
    [
      'What does first ionization energy measure?',
      'Energy required to remove an electron from a neutral gaseous atom',
      'Energy required to add a proton to a nucleus',
      'The number of occupied electron shells',
      'The physical width of a periodic-table cell',
      'First ionization energy concerns removing the first electron from a neutral gaseous atom.',
      'Ionization energy'
    ],
    [
      'Why must the usual filled-shell pattern include a helium exception?',
      'Its filled first shell has two electrons',
      'It has eight protons and no electrons',
      'It belongs to group 1 with sodium',
      'It has no occupied shell in its neutral state',
      'Helium is group 18, but its complete first shell contains two electrons.',
      'Helium'
    ],
    [
      'An atom has 17 protons and 18 electrons. Which description fits?',
      'Cl−, still chlorine',
      'Ar, because it gained an electron',
      'Cl+, because electrons are positive',
      'Mg2+, because its outer shell is full',
      'The proton count identifies chlorine; one extra electron gives charge −1.',
      'Identity and charge'
    ],
    [
      'Which formula balances Mg2+ and Cl−?',
      'MgCl2',
      'MgCl',
      'Mg2Cl',
      'Mg2Cl3',
      'One +2 charge requires two −1 charges, giving the ratio MgCl2.',
      'Charge balance'
    ],
    [
      'A student says every step right must raise ionization energy. What correction is needed?',
      'The general trend has configuration-related exceptions',
      'Ionization energy is simply the atomic radius',
      'No relationship with electron attraction exists',
      'Every element in a row has identical ionization energy',
      'Ionization energy generally rises across a period but neighboring exceptions occur.',
      'Trend limits'
    ],
    [
      'For neutral sodium and chlorine, which comparison fits the taught trends?',
      'Chlorine is smaller and harder to ionize first',
      'Chlorine is larger and easier to ionize first',
      'Both have identical radii and ionization energies',
      'Sodium has seven valence electrons and chlorine has one',
      'Across this period, stronger attraction gives chlorine smaller radius and higher first ionization energy.',
      'Combined trends'
    ],
    [
      'An element card shows atomic number 12 and decimal atomic mass. Which value identifies the element?',
      '12, the proton count',
      'The decimal mass rounded to a whole number',
      'The sum of the two printed values',
      'The number of digits after the decimal point',
      'Atomic number fixes identity; tabulated atomic mass describes isotope-weighted mass.',
      'Reading cards'
    ],
    [
      'A neutral main-group atom has arrangement 2,8,2. Which prediction is supported?',
      'It is in period 3 and commonly forms a +2 ion in this example',
      'It is in period 2 and must form a −3 ion',
      'It has only two electrons in total',
      'It must change proton count when it bonds',
      'Three occupied shells give period 3; magnesium commonly loses its two outer electrons.',
      'Position prediction'
    ],
    [
      'A sodium ion has 11 protons and 10 electrons. Which statement explains its identity and charge?',
      'It remains sodium and has charge +1',
      'It becomes neon and has charge zero',
      'It remains sodium and has charge −1',
      'It becomes magnesium and has charge +2',
      'Eleven protons retain sodium identity; 11 − 10 gives net charge +1.',
      'Mastery ion'
    ],
    [
      'Which explanation correctly compares lithium and sodium first ionization energies?',
      'Sodium is easier to ionize because its outer electron is farther out and more shielded',
      'Sodium is harder to ionize because every added proton overrides shielding',
      'Lithium is easier because it has an extra occupied shell',
      'They must be equal because they share a group',
      'Down group 1, added distance and shielding reduce the energy to remove the outer electron.',
      'Mastery trend'
    ],
    [
      'An ionic solid contains Mg2+ and Cl− only. Why are two chloride ions needed per magnesium ion?',
      'Their combined −2 charge balances magnesium’s +2 charge',
      'Each chloride ion has two positive charges',
      'Magnesium must gain two extra protons',
      'The period number requires two chlorine atoms in every compound',
      'Electrical neutrality requires +2 + (−1) + (−1) = 0.',
      'Mastery formula'
    ],
  ],
);

final _acidsBases = scienceTopic(
  grade: 'g10',
  order: 3,
  title: 'Acids & Bases',
  subtitle: 'Reason with ions, logarithmic pH and reacting amounts',
  minutes: '25–30 minutes',
  prerequisiteTopicId: 'science.g10.periodic-table',
  objectives: [
    'Distinguish acidic, neutral and basic aqueous solutions using hydronium and hydroxide.',
    'Interpret tenfold pH steps and calculate simple concentration ratios.',
    'Distinguish acid strength from solution concentration.',
    'Predict neutralization and excess reactant for stated strong acid/base examples.'
  ],
  introduction:
      'Two clear solutions can look identical yet differ by a hundredfold in hydronium concentration. A label saying weak acid also does not tell you how much acid is present. To compare solutions meaningfully, we must separate particle behavior, amount per volume and the pH scale. These distinctions also prevent misleading conclusions about neutralization and handling.',
  sections: [
    scienceSection('Acids and bases in water',
        '''In an introductory aqueous model, an acid increases hydronium ion concentration when dissolved in water. A hydrogen ion associates with water to form H3O+, hydronium; equations often use H+ as shorthand. A base can increase hydroxide ion concentration or accept protons from water or another acid. Dissolved sodium hydroxide supplies Na+ and OH− ions. Ammonia illustrates a base that reacts with water to produce some OH− even though its formula contains no OH group.

Water itself contains both hydronium and hydroxide. An acidic solution has more hydronium than hydroxide; a basic solution has more hydroxide than hydronium. Neutral means these concentrations are equal, not that both ions are absent. Acid and base descriptions therefore concern relative ion amounts in solution, not a liquid's color, thickness or whether it seems familiar.'''),
    scienceSection('The pH scale compresses large ratios',
        '''pH is a logarithmic measure related to hydronium activity. For the dilute aqueous examples here, we approximate it using concentration: pH = −log10[H3O+], with concentration expressed in mol/L. You do not need a logarithm calculator for powers of ten: 10⁻³ mol/L corresponds approximately to pH 3, and 10⁻⁵ mol/L to pH 5. Lower pH means higher hydronium concentration, not lower.

At 25 °C, neutral dilute water has pH about 7. Values below 7 are acidic and values above 7 are basic under those conditions. Neutral pH changes with temperature, so always preserve the stated temperature assumption. The familiar 0–14 display is a useful classroom range, not an absolute mathematical boundary for every possible solution. Our calculations stay within ordinary dilute examples where the approximation is appropriate.'''),
    scienceVisual('sci-g10-3-ph',
        'A lower pH corresponds to more hydronium per equal volume.'),
    scienceSection('Worked example: compare pH 3 and pH 5',
        '''Start with the pH difference: 5 − 3 = 2. Each unit corresponds to a factor of ten in hydronium concentration, so two units correspond to 10 × 10 = 100. The pH 3 solution has 100 times the hydronium concentration of the pH 5 solution. You can verify the direction using 10⁻³/10⁻⁵ = 10² = 100. It is not merely twice as acidic in the concentration sense.

Likewise, pH 4 has ten times the hydronium concentration of pH 5, and pH 6 has one tenth that of pH 5. Equal volumes are helpful when drawing particle comparisons, but volume is not part of pH itself. A larger beaker of the same well-mixed solution has the same pH; it contains more total dissolved material because there is more solution, not because its concentration increased.'''),
    scienceSection('Strength and concentration are separate properties',
        '''Acid strength describes the extent of ionization in water. A strong acid such as hydrochloric acid ionizes essentially completely in the simple dilute model. A weak acid such as acetic acid ionizes only partly at equilibrium: both intact acid molecules and ions remain. Weak does not mean that no hydronium forms, and strong does not describe how much liquid is in the bottle.

Concentration describes dissolved amount per solution volume. A strong acid can be dilute, and a weak acid can be concentrated. If equal concentrations of a strong monoprotic acid and a weak monoprotic acid are compared under the same dilute conditions, the strong acid generally produces more hydronium and a lower pH. Without concentrations, however, the words strong and weak alone do not determine which sample has lower pH. A safety judgment likewise cannot be reduced to the strength label; identity, concentration, quantity and exposure all matter.'''),
    scienceVisual('sci-g10-3-strength',
        'Ask separately how much acid is present and what fraction ionizes.'),
    scienceSection('Dilution changes concentration',
        '''Adding water to a solution increases its volume without adding more of the original dissolved acid. In a simple strong-acid example where its hydronium greatly exceeds that supplied by water, a tenfold dilution reduces hydronium concentration tenfold and raises pH by about one unit. For example, increasing solution volume from 10 mL to 100 mL changes an ideal pH 3 strong-acid solution to approximately pH 4.

The volume becomes ten times its original value; it is not enough merely to add ten milliliters. This shortcut must not be extended indefinitely near neutral conditions, where water's contribution matters, or applied unchanged to a weak acid whose ionization fraction shifts during dilution. Dilution does not change a strong acid into a weak acid: its chemical strength and its amount per volume remain distinct ideas.'''),
    scienceSection('Neutralization consumes reacting amounts',
        '''For the strong acid and hydroxide-base examples here, the net ionic reaction is H3O+ + OH− → 2H2O, often shortened to H+ + OH− → H2O. Sodium and chloride ions remain in solution when hydrochloric acid reacts with sodium hydroxide; they are spectator ions in this net reaction. The full process produces water and dissolved salt, but salt does not necessarily mean a visible solid appears.

One reacting hydronium ion consumes one hydroxide ion. Therefore compare amounts, not just volumes. Equal volumes neutralize exactly only when the relevant reacting-ion concentrations and stoichiometry match. At equivalence for a strong monoprotic acid and strong hydroxide base, the resulting solution is approximately neutral at 25 °C. Other combinations can form ions that react with water, so the phrase acid plus base does not guarantee pH 7 in every case.'''),
    scienceVisual('sci-g10-3-neutralization',
        'Count what reacts, then identify what remains in excess.'),
    scienceSection('Guided example: use a particle ledger',
        '''Imagine a scaled model with 6 equal amount-units of hydronium and 4 equal amount-units of hydroxide. Pair one unit of each until one supply runs out. Four pairs react, leaving 2 hydronium units in excess and no added hydroxide units unreacted. The resulting solution is acidic; it is not neutral simply because both reactants were present. Reverse the amounts and hydroxide remains in excess, giving a basic solution.

Use paper tokens to repeat the ledger with 5 and 5 units, then 3 and 7 units. The first reaches equal reacting amounts; the second leaves 4 hydroxide units. These counts are proportional amount units, not a claim that macroscopic beakers contain only a few ions. The activity teaches stoichiometric bookkeeping without handling chemicals. Exact final pH would also require concentrations, final volume and the chemical model; leftover count alone does not provide it.'''),
    scienceSection('Measurement and safe observation',
        '''An indicator changes color over a particular pH interval, so a color comparison gives an estimate rather than an exact universal measurement. A properly calibrated pH meter can provide a numerical reading, but its precision and operating conditions still matter. For an offline investigation, analyze supplied pH cards rather than taste, touch or mix unknown substances. Never identify acids by tasting them or combine household cleaners. Real practical work requires the teacher's approved materials, eye protection and handling procedure; neutralization can release heat, and a mixture is not automatically safe because its pH approaches neutral.'''),
    scienceSection('Common mistakes',
        'A pH difference is multiplicative in hydronium concentration. Neutral water still contains ions. Weak and dilute are not synonyms. More volume of the same solution does not change pH. Equal volumes need not contain equal reacting amounts. A neutralization mixture can remain acidic or basic, and the word neutral does not certify harmlessness.'),
    scienceSection('Quick check',
        'Compare hydronium concentrations at pH 2 and pH 4. If a strong acid supplies 8 amount-units and a hydroxide base supplies 5, what remains in excess? Can a weak acid be concentrated?'),
    scienceSection('Check your thinking',
        'At pH 2 the hydronium concentration is 100 times that at pH 4. Five acid/base pairs react, leaving 3 acid amount-units in excess. A weak acid can be concentrated because strength describes ionization while concentration describes amount per volume.',
        reveal: true),
    scienceSection('Recap',
        'Identify hydronium and hydroxide, interpret pH logarithmically, and keep strength separate from concentration. For neutralization, compare reacting amounts and check what remains. Use stated assumptions and approved measurements rather than appearance or tasting.'),
  ],
  keyConcept:
      'pH tracks hydronium on a logarithmic scale. Acid strength concerns ionization, concentration concerns amount per volume, and neutralization depends on reacting amounts rather than labels or equal volumes alone.',
  questions: [
    [
      'Which ion is represented by H3O+?',
      'Hydronium',
      'Hydroxide',
      'Chloride',
      'Sodium',
      'Hydronium is the water-associated hydrogen ion, written H3O+.',
      'Hydronium'
    ],
    [
      'An acidic aqueous solution contains which relationship?',
      'More hydronium than hydroxide',
      'More hydroxide than hydronium',
      'No ions of any kind',
      'Equal hydronium and hydroxide at every pH',
      'Acidity means hydronium exceeds hydroxide in the aqueous solution.',
      'Acidity'
    ],
    [
      'At 25 °C, which pH describes a basic dilute solution?',
      '9',
      '7',
      '5',
      '3',
      'Above pH 7 is basic for these dilute aqueous examples at 25 °C.',
      'Basic pH'
    ],
    [
      'What does neutral mean for hydronium and hydroxide concentrations?',
      'They are equal',
      'Both must be zero',
      'Hydronium is always higher',
      'Hydroxide is always higher',
      'Neutrality means equal concentrations, not the absence of these ions.',
      'Neutrality'
    ],
    [
      'What does acid strength describe in this lesson?',
      'Extent of ionization in water',
      'Volume of liquid in a container',
      'Mass of the glass bottle',
      'Whether a label uses bright colors',
      'Strong and weak refer to ionization behavior, not amount or container size.',
      'Strength'
    ],
    [
      'What does solution concentration describe?',
      'Dissolved amount per solution volume',
      'The number of beakers on a table',
      'Whether the acid ionizes completely',
      'The color of every dissolved substance',
      'Concentration relates dissolved amount to the volume containing it.',
      'Concentration'
    ],
    [
      'Which is an appropriate way to investigate unknown-looking solutions here?',
      'Analyze supplied pH data without tasting or mixing',
      'Taste each liquid to identify acidity',
      'Mix household cleaners to see if they neutralize',
      'Touch each sample until one stings',
      'Use supplied data and approved procedures; tasting and uncontrolled mixing are unsafe.',
      'Safe observation'
    ],
    [
      'How does hydronium concentration at pH 4 compare with pH 5?',
      'It is 10 times as large',
      'It is twice as large',
      'It is one tenth as large',
      'It is unchanged',
      'A one-unit decrease in pH means a tenfold hydronium increase.',
      'One pH step'
    ],
    [
      'How does pH 3 compare with pH 5 in hydronium concentration?',
      'pH 3 has 100 times as much per volume',
      'pH 3 has twice as much per volume',
      'pH 5 has 100 times as much per volume',
      'The concentrations are equal',
      'Two pH units correspond to 10 × 10 = 100, with lower pH higher in hydronium.',
      'Two pH steps'
    ],
    [
      'A dilute solution has hydronium concentration 10⁻⁴ mol/L. What is its approximate pH?',
      '4',
      '−4',
      '10',
      '14',
      'For a power of ten, pH = −log10(10⁻⁴) = 4.',
      'Concentration to pH'
    ],
    [
      'Which description is chemically possible?',
      'A dilute strong acid',
      'A weak acid that forms no ions by definition',
      'A neutral solution without any hydronium',
      'A base identified only by its bottle shape',
      'A strong acid can be present at low concentration while still ionizing extensively.',
      'Independent properties'
    ],
    [
      'Equal concentrations of dilute strong and weak monoprotic acids are compared. What is generally expected?',
      'The strong acid produces more hydronium',
      'The weak acid must ionize completely',
      'Their hydronium concentrations must be identical',
      'The strong acid contains no dissolved acid',
      'At equal concentration the strong acid ionizes more extensively.',
      'Controlled comparison'
    ],
    [
      'Which net ionic reaction represents the taught neutralization?',
      'H3O+ + OH− → 2H2O',
      'Na+ + Cl− → H3O+',
      'H3O+ → Na+ + Cl−',
      'OH− + OH− → NaCl',
      'Hydronium and hydroxide react in a one-to-one ratio to form water.',
      'Neutralization'
    ],
    [
      'Why are sodium and chloride called spectator ions in this example?',
      'They remain in solution without taking part in the net acid-base reaction',
      'They disappear from the solution permanently',
      'They both become neutral water molecules',
      'They force every mixture to precipitate solid salt',
      'The net ionic reaction involves hydronium and hydroxide; sodium and chloride remain.',
      'Spectator ions'
    ],
    [
      'A pH 3 strong acid is diluted from 10 mL to 100 mL under the stated dilute model. Approximate final pH?',
      '4',
      '2',
      '3',
      '13',
      'Tenfold dilution reduces hydronium tenfold and raises pH by about one.',
      'Dilution'
    ],
    [
      'Six acid amount-units react with four hydroxide amount-units. What remains in excess?',
      'Two acid units',
      'Two hydroxide units',
      'Ten acid units',
      'No excess because both were present',
      'Four one-to-one pairs react, leaving 6 − 4 = 2 acid units.',
      'Excess acid'
    ],
    [
      'Why do equal acid and base volumes not always neutralize exactly?',
      'Their reacting-ion concentrations or stoichiometry may differ',
      'Equal volumes always contain equal ion amounts',
      'Volume alone fixes every final pH at 7',
      'Hydronium and hydroxide never react in water',
      'Equal volume is insufficient without matching reacting amounts.',
      'Equal-volume limit'
    ],
    [
      'A larger beaker is filled with the same well-mixed solution. What happens to pH?',
      'It stays the same because concentration stays the same',
      'It doubles with beaker volume',
      'It becomes neutral whenever volume increases',
      'It falls by one for every extra milliliter',
      'More solution changes total amount, not concentration or pH of that solution.',
      'Volume versus pH'
    ],
    [
      'Only strong and weak acid labels are given. Can the lower-pH sample be identified?',
      'No; concentrations and conditions are also needed',
      'Yes; strong always means lower pH regardless of concentration',
      'Yes; weak always means pH 7',
      'Yes; the larger bottle always has lower pH',
      'Strength alone does not determine sample pH without concentration information.',
      'Insufficient information'
    ],
    [
      'An indicator changes color over a pH interval. What conclusion is appropriate?',
      'Its color gives an approximate pH range',
      'Its color gives unlimited exact decimal precision',
      'It proves the solution can be tasted safely',
      'It measures total solution volume directly',
      'Indicators respond over intervals, so their colors provide estimates or ranges.',
      'Measurement limits'
    ],
    [
      'Solution A is pH 6 and B is pH 3. How do their hydronium concentrations compare?',
      'B has 1000 times the concentration of A',
      'A has 1000 times the concentration of B',
      'B has 3 times the concentration of A',
      'Both have equal concentrations because both are acidic',
      'Three pH units give a factor of 10³ = 1000; the lower pH has more hydronium.',
      'Mastery pH ratio'
    ],
    [
      'Three acid amount-units and seven hydroxide amount-units react in the strong acid/base model. What follows?',
      'Four hydroxide units remain in excess, so the solution is basic',
      'Four acid units remain in excess, so the solution is acidic',
      'All ten units remain unreacted',
      'The mixture must have pH 7 because an acid was added',
      'Three pairs react, leaving 7 − 3 = 4 hydroxide units in excess.',
      'Mastery neutralization'
    ],
    [
      'A student calls a concentrated weak acid harmless because weak means dilute. Which correction is best?',
      'Weak describes partial ionization; concentration and hazards require separate information',
      'Weak acids never produce hydronium',
      'Concentrated solutions always have neutral pH',
      'All strong acids are concentrated by definition',
      'Strength and concentration describe different properties, and weak does not establish safe handling.',
      'Mastery distinction'
    ],
  ],
);

final _electricityMagnetism = scienceTopic(
  grade: 'g10',
  order: 4,
  title: 'Electricity & Magnetism',
  subtitle: 'Connect circuits, energy transfer and changing magnetic fields',
  minutes: '25–30 minutes',
  prerequisiteTopicId: 'science.g10.acids-bases',
  objectives: [
    'Calculate current, resistance and power for ideal ohmic circuits.',
    'Apply current and voltage rules to simple series and parallel arrangements.',
    'Relate current direction and magnitude to a coil’s magnetic field.',
    'Explain electromagnetic induction as a response to changing magnetic flux.'
  ],
  introduction:
      'A resistor warms when connected to a battery, while a generator can light a lamp when its shaft turns. These are connected energy transformations. Electric current produces magnetic effects, and changing magnetic conditions can produce a voltage. We will first make circuit calculations precise, then explain how current, magnetic fields and motion fit together.',
  sections: [
    scienceSection('Current, voltage and resistance measure different things',
        '''Electric current is the rate of charge flow, measured in amperes (A). One ampere corresponds to one coulomb of charge passing a point each second. Potential difference, or voltage, measures energy transferred per unit charge, in volts (V). One volt is one joule per coulomb. Resistance describes how much voltage is needed to drive a given current through a component, measured in ohms (Ω).

In a steady closed circuit, charge circulates rather than being used up by a resistor. The supply transfers energy to charges, and components transfer electrical energy to other forms, such as thermal energy. Conventional current direction follows positive charge motion; in a metal wire, electrons drift in the opposite direction. You can apply circuit rules consistently using conventional current without claiming that electrons move in that same direction.'''),
    scienceSection('Ohm’s law is a model with conditions',
        '''For an ohmic resistor held at constant temperature, potential difference is proportional to current: V = IR. Rearranging gives I = V/R and R = V/I. State which quantity is held fixed before predicting a change. At fixed resistance, doubling voltage doubles current. At fixed voltage, doubling resistance halves current.

Not every component keeps a constant resistance under every condition. A lamp filament changes temperature as it heats, so blindly extending a constant-resistance calculation can fail. Our numerical problems use ideal supplies, negligible wire resistance, and stated fixed ohmic resistors. An open switch breaks the conducting path and stops steady current in that path. A voltage can still exist across an open part of a circuit; voltage and current are not the same quantity.'''),
    scienceVisual('sci-g10-4-circuit',
        'Identify the closed path, then calculate current before power.'),
    scienceSection('Worked example: a resistor transfers energy',
        '''An ideal 12 V supply is connected across a 6 Ω resistor. First write I = V/R. Substitute units: I = 12 V / 6 Ω = 2 A. Then calculate electric power using P = VI: P = 12 V × 2 A = 24 W. A watt is a joule per second, so this resistor transfers 24 joules of electrical energy to thermal energy each second.

For steady power, transferred energy is E = Pt. Over 30 s, E = 24 × 30 = 720 J. Power and energy differ: power gives the transfer rate, while energy accumulates over time. If the resistance doubles to 12 Ω at the same 12 V, current falls to 1 A and power falls to 12 W. A larger resistance does not automatically mean greater heating power; the voltage or current held fixed determines the comparison.'''),
    scienceSection('Series circuits share one current',
        '''Components connected in series lie on one unbranched path. In steady operation, the same current passes each component. Charge does not pile up indefinitely between resistors, and the first resistor does not consume part of the current before it reaches the second. Voltage drops across the resistors add to the supply voltage, while series resistances add: Rtotal = R1 + R2.

For 2 Ω and 4 Ω resistors in series across 12 V, total resistance is 6 Ω and current is 2 A everywhere in the path. The voltage drops are 2 × 2 = 4 V and 2 × 4 = 8 V. Their sum is 12 V. The larger series resistor has the larger voltage drop because both carry the same current. Opening either part of this single path stops steady current through both.'''),
    scienceVisual('sci-g10-4-branches',
        'Follow connection points rather than judging circuits by drawing shape.'),
    scienceSection('Parallel circuits share a voltage',
        '''Parallel branches connect between the same two circuit points. Each branch therefore has the same potential difference, while branch currents can differ. At a junction, incoming current equals total outgoing current in steady operation. This is charge conservation, not a rule that every branch must carry an equal share.

Connect 6 Ω and 12 Ω resistors in parallel across an ideal 12 V supply. Their currents are 12/6 = 2 A and 12/12 = 1 A. Total supply current is 3 A. The equivalent resistance is V/Itotal = 12/3 = 4 Ω, lower than either branch resistance because parallel paths make more total current possible at the same voltage. If the 12 Ω branch opens while the ideal supply remains at 12 V, the intact 6 Ω branch still carries 2 A, and total current falls to 2 A.'''),
    scienceSection('A current produces a magnetic field',
        '''A magnetic field describes magnetic influence in space. Around a straight current-carrying wire, the field follows circular directions. A coil combines the magnetic effects of its turns and produces a field with north-like and south-like ends. Reversing conventional current reverses the field direction. For the same coil geometry and material conditions, increasing current generally strengthens its field. Adding turns can also strengthen a coil's field under appropriate comparisons.

An electromagnet uses current to produce a controllable magnetic effect, often strengthened by an iron core. Its behavior depends on the core and circuit; real materials can saturate and may retain some magnetism after current stops. A motor uses magnetic forces on current-carrying parts to produce motion. It transfers electrical energy into mechanical energy, with additional transfers such as heating; it does not create energy.'''),
    scienceVisual('sci-g10-4-fields',
        'Separate a field produced by current from voltage induced by a changing field relationship.'),
    scienceSection('Induction requires change through the loop',
        '''Electromagnetic induction produces a voltage when magnetic flux through a loop changes. Flux depends on field strength, loop area and orientation, so moving a magnet relative to a coil, rotating a loop, or changing a nearby current can change it. If the receiving circuit is closed, the induced voltage can drive current. A magnet simply sitting beside a stationary coil with unchanging flux does not sustain an induced current.

Moving the same magnet faster through the same coil generally increases the magnitude of induced voltage because the flux changes faster. Reversing the motion reverses the induced polarity under otherwise matching conditions. The induced effect opposes the change producing it, consistent with energy conservation. A generator uses mechanical work to maintain motion and transfer energy into electrical form. A magnet supplies the field arrangement; it is not an unlimited fuel source.'''),
    scienceSection('Guided activity: diagnose two explanations',
        '''Use paper circuit diagrams only. Draw a 12 V source with 6 Ω and 12 Ω parallel branches, and label their shared endpoints. Calculate each current separately, then add them at the source. Compare your result with a claim that each resistor receives half the voltage. The shared endpoints show why the claim fails: both branches span the entire 12 V.

Next sketch a coil and three magnet positions: approaching, held still, and retreating. Mark flux changing, unchanging and changing respectively. Predict induction during approach and retreat, with opposite polarity, but none sustained during the still interval. The sketch tests causal reasoning without mains electricity, loose batteries or heated wires. Numerical coil voltages would require more data; a qualitative diagram cannot justify invented measurements.'''),
    scienceSection('Common mistakes',
        'Current is not used up as energy is transferred. Voltage can exist without steady current. Ohm’s law calculations require the specified component conditions. Series components share current; parallel branches share voltage. Power is a rate, not accumulated energy. Magnetic induction requires changing flux, and generators require an energy input.'),
    scienceSection('Quick check',
        'A fixed 4 Ω resistor is connected across 8 V. Find current and power. What happens to a coil’s field direction if its current reverses? Would an unmoving magnet with constant flux sustain induced current in a stationary coil?'),
    scienceSection('Check your thinking',
        'Current is 8/4 = 2 A and power is 8 × 2 = 16 W. Reversing coil current reverses its field direction. An unmoving magnet with unchanging flux does not sustain induced voltage or current; a change in flux is required.',
        reveal: true),
    scienceSection('Recap',
        'Choose circuit equations after identifying paths and fixed conditions. Track energy through voltage, current, power and time. Current produces magnetic fields, while changing magnetic flux can induce voltage. Motors and generators connect these effects through energy transfers.'),
  ],
  keyConcept:
      'For ideal ohmic circuits, V = IR and P = VI connect charge flow with energy transfer. Current produces magnetic fields, and changing magnetic flux induces voltage while conserving energy.',
  questions: [
    [
      'What does electric current measure?',
      'Rate of charge flow',
      'Energy transferred per unit charge',
      'Total mass of a resistor',
      'The number of magnetic poles only',
      'Current measures charge passing a point per unit time.',
      'Current'
    ],
    [
      'What does voltage measure?',
      'Energy transferred per unit charge',
      'Charge flow per second',
      'Resistance multiplied by time only',
      'Total length of all wires',
      'Potential difference measures energy per charge, in joules per coulomb.',
      'Voltage'
    ],
    [
      'Which equation applies to the stated fixed ohmic resistor?',
      'V = IR',
      'V = I/R',
      'R = VI',
      'I = VR',
      'Ohm’s law relates voltage, current and resistance through V = IR.',
      'Ohms law'
    ],
    [
      'Which unit measures electric power?',
      'Watt',
      'Coulomb',
      'Ohm',
      'Ampere',
      'A watt is a joule per second, measuring energy transfer rate.',
      'Power unit'
    ],
    [
      'What is shared by ideal series components in steady operation?',
      'The same current',
      'The same resistance regardless of component',
      'The same voltage drop in every case',
      'Separate independent conducting paths',
      'Series components lie on one path, so steady current is the same through each.',
      'Series current'
    ],
    [
      'What is shared by branches connected between the same two points?',
      'The same voltage',
      'The same current regardless of resistance',
      'The same number of resistors',
      'The same thermal energy transfer in every case',
      'Parallel branches span the same endpoints and therefore share potential difference.',
      'Parallel voltage'
    ],
    [
      'What can produce a magnetic field around a wire?',
      'Electric current in the wire',
      'Resistance with no current under all conditions',
      'An open diagram with no physical source',
      'The printed color of the wire label',
      'Moving charge in a current produces a magnetic field.',
      'Current field'
    ],
    [
      'What current passes through 6 Ω across 12 V?',
      '2 A',
      '72 A',
      '0.5 A',
      '18 A',
      'Use I = V/R = 12/6 = 2 A.',
      'Current calculation'
    ],
    [
      'A component has 12 V across it and 2 A through it. What is its power?',
      '24 W',
      '6 W',
      '14 W',
      '0.17 W',
      'P = VI = 12 × 2 = 24 watts.',
      'Power calculation'
    ],
    [
      'What is the total resistance of 2 Ω and 4 Ω in series?',
      '6 Ω',
      '2 Ω',
      '8 Ω',
      '0.5 Ω',
      'Series resistances add: 2 + 4 = 6 ohms.',
      'Series resistance'
    ],
    [
      'For a fixed resistance, what happens when voltage doubles?',
      'Current doubles',
      'Current halves',
      'Current remains zero in every circuit',
      'Resistance must also double by definition',
      'I = V/R, so doubling V at fixed R doubles I.',
      'Fixed resistance'
    ],
    [
      'What happens to a coil’s field direction when current reverses?',
      'It reverses',
      'It remains unchanged in direction',
      'It becomes gravitational attraction',
      'It must disappear permanently',
      'Magnetic field direction depends on current direction and reverses with it.',
      'Field direction'
    ],
    [
      'Which condition can induce voltage in a coil?',
      'Changing magnetic flux through it',
      'An unchanging flux through a stationary coil',
      'A magnet existing anywhere without any change',
      'Removing all motion and all field changes permanently',
      'Electromagnetic induction requires a change in magnetic flux through the loop.',
      'Induction'
    ],
    [
      'What energy transfer describes a generator?',
      'Mechanical energy into electrical energy',
      'Electrical energy created without an input',
      'Thermal energy permanently destroyed',
      'Magnetic poles consumed as an unlimited fuel',
      'A generator requires mechanical work to produce electrical energy.',
      'Generator'
    ],
    [
      'A resistor transfers energy at 24 W for 30 s. How much energy is transferred?',
      '720 J',
      '0.8 J',
      '54 J',
      '24 J',
      'E = Pt = 24 × 30 = 720 joules.',
      'Energy calculation'
    ],
    [
      'A 12 V source drives 2 Ω and 4 Ω in series. What is the drop across 4 Ω?',
      '8 V',
      '4 V',
      '12 V',
      '2 V',
      'Total current is 12/(2+4) = 2 A; the 4-ohm drop is 2 × 4 = 8 V.',
      'Series voltage'
    ],
    [
      'Across 12 V, parallel 6 Ω and 12 Ω branches draw what total current?',
      '3 A',
      '1 A',
      '2 A',
      '18 A',
      'Branch currents are 2 A and 1 A, which add to 3 A at the supply.',
      'Parallel sum'
    ],
    [
      'The 12 Ω branch opens in that ideal parallel circuit. What current remains in the 6 Ω branch?',
      '2 A',
      '0 A',
      '3 A',
      '1 A',
      'The intact branch still has 12 V across 6 ohms, so it continues at 2 A.',
      'Open branch'
    ],
    [
      'Why does constant resistance need a stated temperature condition?',
      'Some components change resistance as they heat',
      'Current always consumes resistor mass',
      'Ohms and amperes are identical units',
      'Voltage has no relationship to charge energy',
      'Heating can change resistance, so a fixed-resistance model has conditions.',
      'Model limits'
    ],
    [
      'The same magnet moves faster through the same coil. What is generally predicted?',
      'Larger induced voltage magnitude because flux changes faster',
      'No induction because speed prevents flux change',
      'A guaranteed fixed 12 V independent of speed',
      'Electrical energy without mechanical input',
      'Faster change of magnetic flux generally increases induced voltage magnitude.',
      'Rate of flux change'
    ],
    [
      'An ideal 9 V supply drives a fixed 3 Ω resistor. Which pair is correct?',
      '3 A and 27 W',
      '27 A and 3 W',
      '3 A and 12 W',
      '0.33 A and 27 W',
      'I = 9/3 = 3 A and P = 9 × 3 = 27 W.',
      'Mastery circuit'
    ],
    [
      'A student says the first series resistor uses up current. Which correction is right?',
      'Current stays the same while electrical energy is transferred',
      'Only the second resistor receives any voltage',
      'Charge disappears whenever resistance is present',
      'The first resistor always doubles the charge flow',
      'Steady series current is conserved; components transfer energy rather than consume charge.',
      'Mastery conservation'
    ],
    [
      'A magnet is moved toward a closed coil, held still, then moved away. Which pattern is expected?',
      'Induction during motion, none sustained while still, reversed polarity for reversed motion',
      'Constant identical induction through all three stages',
      'Induction only during the still interval',
      'No induction during any flux change',
      'Changing flux induces voltage; the still interval has no sustained change, and reversing motion reverses polarity.',
      'Mastery induction'
    ],
  ],
);
