import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

final List<NorieTopicContent> grade8ScienceTopics = [
  _geneticsBasics,
  _chemicalReactions,
  _workEnergy,
  _waves,
  _weatherClimate,
];

const Map<String, ScienceFigure> grade8ScienceFigures = {
  'sci-g8-5-radiation': ScienceFigure(
    picture: 'g8-greenhouse',
    title: 'Follow incoming sunlight and outgoing infrared energy',
    kind: 'comparison',
    labels: [
      'Solar energy enters',
      'The surface emits infrared',
      'The atmosphere exchanges energy'
    ],
    details: [
      'Some incoming shortwave sunlight is reflected; some is absorbed by the surface and atmosphere.',
      'The warmed surface emits longwave infrared radiation. Some can escape directly to space.',
      'Greenhouse gases absorb some infrared energy and the atmosphere emits infrared upward and downward.',
    ],
    note:
        'This qualitative model distinguishes reflection from absorption and emission. Arrows do not give measured fractions. Energy continues leaving Earth; it is not trapped forever.',
  ),
  'sci-g8-5-baseline': ScienceFigure(
    title: 'A hypothetical station compares matching annual quantities',
    kind: 'bars',
    labels: ['30-year reference annual mean', 'One recent annual mean'],
    values: [25.0, 26.2],
    unit: '°C',
    details: [
      '25.0 °C is the provided long-term annual reference at this station.',
      '26.2 °C is one year at the same station: an annual temperature anomaly of +1.2 °C.',
    ],
    note:
        'Invented teaching data, not a measured place or current global estimate. One station-year does not establish a global trend. Celsius ratios do not describe ratios of thermal energy.',
  ),
  'sci-g8-5-responses': ScienceFigure(
    title: 'Match a climate response to its purpose',
    kind: 'comparison',
    labels: ['Adaptation', 'Mitigation', 'Both can be planned together'],
    details: [
      'A flood-drainage upgrade reduces harm from water reaching a settlement.',
      'Replacing fossil-fuel electricity with a lower-emission source reduces greenhouse gas emissions.',
      'A community can prepare for impacts while also reducing the causes of future warming.',
    ],
    note:
        'Some projects have both purposes. Judge the stated mechanism and context; adaptation does not mean eliminating all risk.',
  ),
  'sci-g8-4-profile': ScienceFigure(
    picture: 'g8-wave',
    title: 'Read space and time information separately',
    kind: 'comparison',
    labels: ['Amplitude: 0.5 m', 'Wavelength: 2 m', 'Supplied frequency: 3 Hz'],
    details: [
      'The maximum displacement from equilibrium to a crest is 0.5 m. The full crest-to-trough height is 1 m.',
      'Adjacent crests are 2 m apart along the direction the wave travels.',
      'Frequency comes from separate timing information. With 3 Hz and 2 m, wave speed is 6 m/s.',
    ],
    note:
        'This profile shows positions at one instant. It is not the path followed by a single rope particle, and the drawing alone cannot supply frequency.',
  ),
  'sci-g8-4-types': ScienceFigure(
    title: 'Local oscillation and wave travel are different directions',
    kind: 'comparison',
    labels: [
      'Transverse rope model',
      'Longitudinal sound in air',
      'Electromagnetic light'
    ],
    details: [
      'Rope portions oscillate perpendicular to the direction of wave travel.',
      'Air particles oscillate parallel to travel, making compressions and rarefactions.',
      'Light can travel through a vacuum. Mechanical sound cannot.',
    ],
    note:
        'Ideal models distinguish local motion from energy transfer. Surface water waves have more complicated particle motion than a purely transverse rope model.',
  ),
  'sci-g8-4-boundary': ScienceFigure(
    title: 'A boundary can divide incoming wave energy',
    kind: 'comparison',
    labels: ['Reflection', 'Transmission', 'Absorption'],
    details: [
      'Some disturbance returns from the boundary into the original medium.',
      'Some travels onward. A different medium can change speed and wavelength.',
      'Some wave energy becomes other energy, often thermal energy in the material.',
    ],
    note:
        'Several processes can occur together. For a stationary boundary and a steady source, transmitted frequency stays tied to the source. These panels do not specify energy percentages.',
  ),
  'sci-g8-3-lift': ScienceFigure(
    picture: 'g8-work',
    title: 'A steady lift transfers energy without increasing speed',
    kind: 'comparison',
    labels: ['Applied work', 'Gravitational energy', 'Net work'],
    details: [
      'A constant 10 N upward force over 1 m upward does +10 J on the 1 kg load.',
      'With model g = 10 N/kg, the Earth–load system gains 10 J of gravitational potential energy.',
      'Weight does −10 J; the two works sum to zero, matching unchanged kinetic energy during the steady segment.',
    ],
    note:
        'Ideal constant-velocity segment with no other resisting force. Equal force arrows do not mean neither force transfers energy. This is a diagram, not an instruction to lift a heavy load.',
  ),
  'sci-g8-3-kinetic': ScienceFigure(
    title: 'Doubling speed quadruples kinetic energy at fixed mass',
    kind: 'bars',
    labels: ['1 kg at 2 m/s', '1 kg at 4 m/s'],
    details: ['½ × 1 × 2² = 2 J.', '½ × 1 × 4² = 8 J.'],
    values: [2, 8],
    unit: 'J',
    note:
        'Values are kinetic energy, not speed. The speed is squared before multiplying by half the mass.',
  ),
  'sci-g8-3-power': ScienceFigure(
    title: 'Same transferred energy, different transfer rates',
    kind: 'comparison',
    labels: ['60 J in 6 s', '60 J in 3 s'],
    details: [
      'Average power = 60 ÷ 6 = 10 W.',
      'Average power = 60 ÷ 3 = 20 W.'
    ],
    note:
        'A watt is a joule per second. Faster energy transfer means greater power, while the total energy can remain equal.',
  ),
  'sci-g8-2-atoms': ScienceFigure(
    picture: 'g8-reaction',
    title: '2H₂ + O₂ → 2H₂O conserves each type of atom',
    kind: 'comparison',
    labels: ['Reactants', 'Products', 'Count check'],
    details: [
      'Two hydrogen molecules and one oxygen molecule contain four H atoms and two O atoms.',
      'Two water molecules contain four H atoms and two O atoms in different groupings.',
      'The number of molecules changes from three to two; each element’s atom count stays the same.',
    ],
    note:
        'Paper/diagram model only. Never mix or ignite hydrogen and oxygen. Colors and bond sticks are explanatory symbols, not scale or an exact reaction mechanism.',
  ),
  'sci-g8-2-evidence': ScienceFigure(
    title: 'Evidence requires an explanation, not a checklist shortcut',
    kind: 'comparison',
    labels: [
      'Bubbles',
      'Color or temperature change',
      'New solid in a solution'
    ],
    details: [
      'May indicate a new gas, but boiling or release of dissolved gas can also produce bubbles.',
      'May support reaction, but dye mixing or heat transferred from a warmer sample can change these observations physically.',
      'A precipitate can support new-substance formation; distinguish it from an already present solid settling.',
    ],
    note:
        'Combine observations with controlled comparisons and product properties. No single sign proves every chemical reaction.',
  ),
  'sci-g8-2-mass': ScienceFigure(
    title: 'Account for the same closed reaction system',
    kind: 'bars',
    labels: ['Before reaction', 'After reaction'],
    details: [
      '35 g container + 25 g reactant contents = 60 g.',
      '35 g container + 25 g total product contents = 60 g.'
    ],
    values: [60, 60],
    unit: 'g',
    note:
        'Supplied idealized ordinary-reaction data: no matter enters or leaves. If gas leaves an open vessel, include that transferred matter when checking conservation.',
  ),
  'sci-g8-1-cross': ScienceFigure(
    picture: 'g8-inheritance',
    title: 'Aa × Aa: four equally likely allele combinations',
    kind: 'comparison',
    labels: ['AA: one box', 'Aa: two boxes', 'aa: one box'],
    details: [
      'Homozygous dominant: 1/4 or 25%; purple in the stated model.',
      'Heterozygous: 2/4 or 50%; purple in the stated model.',
      'Homozygous recessive: 1/4 or 25%; white in the stated model.',
    ],
    note:
        'Simplified single-gene complete-dominance model. Boxes are probabilities, not four guaranteed offspring or four stages of development. Each offspring is an independent outcome under the same assumptions.',
  ),
  'sci-g8-1-levels': ScienceFigure(
    title: 'Connect genetic material with a trait without confusing levels',
    kind: 'comparison',
    labels: ['Chromosome', 'Gene and allele', 'Genotype', 'Phenotype'],
    details: [
      'A DNA-containing structure carrying many genes.',
      'A gene is a DNA sequence with a biological role; an allele is a version at a particular location.',
      'The allele combination for the gene being considered, such as heterozygous Aa.',
      'The observable characteristic, such as purple flowers in this model; many traits also depend on environment.',
    ],
    note:
        'Letters are symbols for allele versions, not actual DNA shapes. A chromosome is not a single allele or one visible trait.',
  ),
  'sci-g8-1-probability': ScienceFigure(
    title: 'Two different crosses predict different white-flower chances',
    kind: 'bars',
    labels: ['Aa × Aa', 'Aa × aa'],
    details: ['25% white, genotype aa.', '50% white, genotype aa.'],
    values: [25, 50],
    unit: '% probability',
    note:
        'These are model probabilities per offspring, not measured percentages required in every small sample. A different parental genotype changes the prediction.',
  ),
};

final _geneticsBasics = scienceTopic(
  grade: 'g8',
  order: 1,
  title: 'Genetics Basics',
  subtitle:
      'Use allele models to predict inheritance without turning chance into certainty',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Distinguish DNA, chromosomes, genes, alleles, genotype and phenotype.',
    'Explain allele separation into gametes in a simplified diploid inheritance model.',
    'Construct a one-gene Punnett square and calculate genotype and phenotype probabilities.',
    'Distinguish expected proportions from guaranteed outcomes and identify limits of simple trait models.',
  ],
  introduction:
      'Two purple-flowered plants can produce a white-flowered offspring. The white trait has not appeared from nowhere, and purple has not blended into a paler shade. An allele model lets us explain the result and predict its probability while keeping the limits of that prediction clear.',
  prerequisiteTopicId: null,
  sections: [
    scienceSection('From DNA to inherited variation',
        '''DNA is the material carrying genetic information. Chromosomes are structures containing long DNA molecules and associated material. A chromosome carries many genes. A gene is a DNA sequence with a biological role; many genes help provide instructions for making proteins that influence cell activities and traits. A gene is not a whole chromosome or a visible flower.

An allele is a version of genetic sequence at a particular location. Organisms can differ in the alleles they possess. For the selected gene in our diploid plant model, a body cell has two copies, one inherited from each parent. This is a bounded model, not a claim that bacteria or every type of cell have two copies of every gene. Changes in DNA, called mutations, can introduce new variation; they do not arise because an organism decides it needs a trait.'''),
    scienceSection('Genotype and phenotype',
        '''Genotype describes the allele combination being considered. Phenotype is the observable characteristic that develops. Our simplified pea-flower model uses two alleles: A associated with purple flowers and a associated with white flowers. With complete dominance, AA and Aa plants have purple flowers; aa plants have white flowers. A is called dominant relative to a in this model.

Dominant does not mean stronger, better, more common or destined to spread. It describes the phenotype of a heterozygote under stated conditions. Aa is heterozygous because its two alleles differ. AA and aa are homozygous because their two alleles match. A recessive allele in Aa is still present and can be passed on. Its effect on this flower phenotype is masked rather than its DNA being erased.'''),
    scienceVisual('sci-g8-1-levels',
        'Keep the physical DNA structures, symbolic allele combination and observed trait distinct.'),
    scienceSection('One allele from each gamete',
        '''Gametes are reproductive cells that contribute genetic material to an offspring. In our one-gene model, each gamete receives one allele from the parent's pair. The two alleles separate during gamete formation. An Aa parent produces A-bearing or a-bearing gametes with equal probability in this model. An AA parent contributes A, while an aa parent contributes a.

Fertilization combines a gamete from each parent, restoring a pair in the new individual. Aa is therefore not a single gamete containing both alternatives. The symbols identify inherited versions rather than physically changing during fertilization. We assume normal segregation, equally likely gamete contributions and no differences in offspring survival affecting the predicted counts.'''),
    scienceSection('Worked example: two heterozygous parents',
        '''Consider Aa × Aa. Step 1: write the first parent's possible gametes, A and a, above two columns. Step 2: write the second parent's A and a beside two rows. Step 3: combine one allele from the column and one from the row. The boxes give AA, Aa, Aa and aa. Writing aA instead of Aa does not create a different biological genotype; the same two alleles are present.

Step 4: count genotype probabilities among four equally likely boxes. AA occurs once, giving 1/4 = 25%. Aa occurs twice, giving 2/4 = 50%. aa occurs once, giving 25%. Step 5: connect to the dominance rule. Three boxes produce purple flowers and one produces white, giving 75% purple and 25% white per offspring.'''),
    scienceVisual('sci-g8-1-cross',
        'Read row and column headings as gametes, then combine their alleles in each box.'),
    scienceSection('Probability is not a four-offspring schedule',
        '''A probability gives the chance of an outcome under the model. It does not assign the first offspring to the first box and the fourth to the last. Four offspring from Aa × Aa need not include exactly one white plant. All four could be purple, or more than one could be white, without contradicting the per-offspring prediction.

Each offspring is independent under the same assumptions: one white offspring does not use up the white box. The next offspring still has a 25% white probability. In a large set, observed proportions often approach the model probabilities more closely, but no finite sample must match exactly. For 12 offspring, 12 × 0.25 = 3 is the expected white count, not a guarantee. An expectation summarizes many possible repetitions of the cross.'''),
    scienceSection('Guided example: a different parent pair',
        'Build Aa × aa. What gametes can each parent contribute? List the resulting genotype combinations, combine equivalent boxes, and calculate the white-flower probability. For 20 offspring, what white count is expected? Would exactly that count be required?'),
    scienceSection('Reveal: change the cross, change the prediction',
        'The Aa parent contributes A or a; the aa parent contributes a in either row. The boxes are Aa, aa, Aa and aa. Half are heterozygous purple and half are homozygous recessive white: 50% each. The expected white count is 20 × 0.50 = 10, but a sample of 20 is not required to contain exactly ten white plants.',
        reveal: true),
    scienceVisual('sci-g8-1-probability',
        'The parental genotypes matter; the same trait name does not imply the same inheritance probability.'),
    scienceSection('An observed dominant trait leaves uncertainty',
        '''A white-flowered plant must be aa within this complete-dominance model. A purple-flowered plant can be AA or Aa, so its color alone does not identify its genotype. If a purple parent produces a white offspring when crossed with aa, it must have contributed a to that offspring, supporting Aa under our assumptions.

If only purple offspring are observed in a small sample, do not conclude with certainty that the parent is AA. An Aa × aa cross could happen to produce a small all-purple sample. More offspring provide additional evidence, and direct genetic evidence could answer different questions. State both what the observations support and what they leave uncertain.'''),
    scienceSection('Real traits need more than one simple square',
        '''Many characteristics depend on multiple genes and environmental conditions. Plant height can respond to inherited differences, light, water and nutrition. Human height is not adequately described by one dominant and one recessive allele. Some inheritance patterns involve incomplete dominance, where the heterozygote has an intermediate phenotype, or codominance, where both allele effects are expressed. Those require different phenotype rules.

The same Punnett reasoning about allele combinations can be useful, but the AA/Aa-purple rule cannot be imposed on every trait. Genetics describes variation, not a ranking of organisms' worth. Our activity uses an invented bounded model or documented plant data, rather than labeling classmates by oversimplified human trait charts.'''),
    scienceSection('Safe inheritance model activity',
        '''Make two pairs of paper allele cards, one A and one a for each parent. Shuffle each pair separately, take one card from each, record the genotype and replace both cards before the next trial. Repeat 20 times. Replacement preserves the same per-offspring probabilities; failing to replace changes the experiment.

Record the observed numbers of AA, Aa and aa and compare with 25%, 50% and 25% predictions. Treat a mismatch as sampling variation to investigate, not a reason to alter the record. No breeding, biological sampling or disclosure of family health information is required. A provided sequence of card outcomes is an offline alternative.'''),
    scienceSection('Common mistakes',
        'A dominant allele is not automatically common or better. Aa retains the recessive allele. Gametes carry one allele for this selected gene, not both. Punnett boxes give possibilities and probabilities, not a birth order. A phenotype can leave genotype uncertain, and real traits may need multiple genes or environmental evidence.'),
    scienceSection('Quick check',
        'For Aa × Aa, what is the heterozygous probability? After one white offspring, does the next white probability change? Can purple appearance alone distinguish AA from Aa?'),
    scienceSection('Check your thinking',
        'Two of four boxes give Aa, so 50%. The next offspring remains 25% likely to be white under independent identical conditions. Purple can be AA or Aa, so color alone cannot distinguish them.',
        reveal: true),
    scienceSection('Recap',
        'Trace alleles from parental pairs to gametes and then offspring pairs. Combine genotype probabilities with the stated phenotype rule, distinguish expectation from certainty, and use evidence cautiously when a simple model does not capture a real trait.'),
  ],
  keyConcept:
      'Allele combinations and a stated inheritance rule predict probabilities. The same probability applies independently to each offspring, while phenotype, sampling and model limits constrain conclusions.',
  questions: [
    [
      'Which relationship correctly connects a chromosome with genes?',
      'One chromosome can carry many genes',
      'Every chromosome is exactly one visible trait',
      'A gene contains all of an organism’s chromosomes',
      'An allele is an entire set of chromosomes',
      'Chromosomes contain long DNA molecules carrying many genes.',
      'Genetic organization'
    ],
    [
      'In the flower model, what is an allele?',
      'A version of the selected genetic sequence',
      'The observed flower color itself',
      'The entire chromosome carrying all traits',
      'A reproductive cell containing every parental allele pair',
      'Alleles are versions at a genetic location; phenotype and chromosome are different levels.',
      'Alleles'
    ],
    [
      'Which description fits heterozygous Aa in the stated model?',
      'Two different alleles for the selected gene',
      'Two matching dominant alleles',
      'Two matching recessive alleles',
      'Only one allele in a gamete',
      'Aa contains differing versions; AA and aa are homozygous.',
      'Heterozygosity'
    ],
    [
      'Which genotype category produces white flowers under the stated complete-dominance rule?',
      'Homozygous recessive (aa)',
      'Homozygous dominant (AA)',
      'Heterozygous (Aa)',
      'Any genotype containing dominant A',
      'White flowers occur when both alleles are a in this model.',
      'Phenotype rule'
    ],
    [
      'What does dominant mean for A relative to a here?',
      'Aa expresses the A-associated flower phenotype',
      'A must be the more common allele in every population',
      'A is biologically better for every environment',
      'A removes the a allele from the DNA',
      'Dominance concerns the heterozygote phenotype, not frequency, worth or deletion.',
      'Dominance'
    ],
    [
      'What does one gamete contribute for this selected gene?',
      'One allele from the parental pair',
      'Both alleles from the parental pair',
      'Two complete offspring genotypes',
      'The observed flower color without genetic material',
      'Gamete formation separates the pair; fertilization combines one allele from each parent.',
      'Gametes'
    ],
    [
      'Which example distinguishes genotype from phenotype?',
      'Heterozygous Aa is genotype; purple flowers are phenotype',
      'Purple flowers are genotype; Aa is phenotype',
      'The chromosome is phenotype; flower color is an allele',
      'A gamete is phenotype; every flower is a chromosome',
      'Genotype is an allele combination; phenotype is the observable characteristic.',
      'Genotype and phenotype'
    ],
    [
      'An Aa parent produces gametes under the model. Which possibilities apply?',
      'Dominant-A-bearing or recessive-a-bearing gametes, each 50%',
      'Only dominant-A-bearing gametes',
      'Only recessive-a-bearing gametes',
      'Every gamete carries both alleles together',
      'The pair separates and each allele has equal chance in this simplified cross.',
      'Segregation'
    ],
    [
      'How many boxes in Aa × Aa produce a heterozygous combination?',
      'Two of four',
      'One of four',
      'Three of four',
      'Four of four',
      'A from one parent with a from the other can arise in two boxes.',
      'Punnett combinations'
    ],
    [
      'What is the white-flower probability from Aa × Aa?',
      '25%',
      '50%',
      '75%',
      '100%',
      'Only one of four equally likely combinations is aa.',
      'Recessive probability'
    ],
    [
      'What is the purple-flower probability from Aa × Aa?',
      '75%',
      '25%',
      '50%',
      '0%',
      'AA and both Aa boxes are purple, giving three of four.',
      'Dominant phenotype probability'
    ],
    [
      'Which genotype categories can share purple phenotype in this model?',
      'Homozygous dominant and heterozygous',
      'Only homozygous dominant',
      'Only homozygous recessive',
      'Heterozygous and homozygous recessive',
      'AA and Aa are purple under complete dominance.',
      'Phenotype ambiguity'
    ],
    [
      'In Aa × aa, what is the white-flower probability?',
      '50%',
      '25%',
      '12.5%',
      '0%',
      'The heterozygous parent contributes a half the time; the aa parent always contributes a.',
      'Different cross'
    ],
    [
      'For 12 offspring from Aa × Aa, what white count is expected?',
      '3, without guaranteeing exactly that number',
      '3, guaranteed in every set of twelve',
      '9, because white has 75% probability',
      '12, because every recessive allele is visible',
      '12 × 0.25 = 3 is an expectation across repeated samples, not a required count.',
      'Expected count'
    ],
    [
      'An Aa × Aa cross has already produced a white offspring. What is the next white probability under unchanged assumptions?',
      '25%, because the next outcome is independent',
      '0%, because the white box has been used',
      '50%, because the previous offspring was white',
      '100%, because white must now continue',
      'One offspring does not remove possibilities from the next independent cross.',
      'Independent offspring'
    ],
    [
      'A purple parent crossed with aa produces a white offspring. Which parental category is supported within the model?',
      'Heterozygous (Aa)',
      'Homozygous dominant (AA)',
      'Homozygous recessive (aa)',
      'A one-allele gamete rather than a plant',
      'The purple parent must carry and contribute a, while its purple phenotype requires A.',
      'Inferring a genotype'
    ],
    [
      'A small sample from a purple × aa cross is all purple. What should a learner conclude?',
      'AA is possible, but Aa is not excluded by this small sample',
      'AA is proven with complete certainty',
      'Aa is impossible because chance never produces all-purple samples',
      'The offspring must have changed the parent’s genotype',
      'An Aa × aa cross can by chance produce a small all-purple sample.',
      'Sample limits'
    ],
    [
      'Why replace both allele cards after each simulated offspring?',
      'To preserve the same possibilities and probabilities for the next trial',
      'To force exactly one white in every four trials',
      'To remove recessive alleles after a purple result',
      'To turn every gamete into a two-allele body cell',
      'Replacement models independent offspring under unchanged parental genotypes.',
      'Model activity'
    ],
    [
      'Which explanation of plant height respects the limits of a one-gene flower model?',
      'Height may involve multiple genes and environmental conditions',
      'Every plant height must follow the same complete-dominance flower rule',
      'Water and light cannot influence any inherited organism',
      'A dominant letter always means the taller plant',
      'Many traits combine several genetic and environmental influences.',
      'Model scope'
    ],
    [
      'A mutation introduces a genetic difference. Which statement avoids a false purpose-based explanation?',
      'DNA changes can create variation without an organism choosing a needed trait',
      'An organism deliberately edits each allele to match its needs',
      'Every mutation must be beneficial in every environment',
      'Mutation always removes all recessive alleles',
      'Mutation changes DNA; it is not a conscious response guaranteeing a useful trait.',
      'Variation'
    ],
    [
      'For 20 offspring from Aa × aa, which expectation and limitation follow?',
      '10 white expected; observed count may differ',
      '10 white guaranteed in every sample',
      '5 white expected because this cross is 25% white',
      '15 white expected because white is dominant here',
      '20 × 0.50 = 10, with sampling variation around that expectation.',
      'Mastery: expected proportions'
    ],
    [
      'Two purple-flowered plants produce white offspring in this model. Which parental combination fits?',
      'Both are heterozygous, each retaining a recessive allele',
      'Both are homozygous dominant and contribute only A',
      'Both are homozygous recessive but express purple',
      'One lacks any allele for flower color',
      'A white aa offspring needs a from each parent; purple parents must therefore be Aa.',
      'Mastery: hidden alleles'
    ],
    [
      'A learner applies the Aa × Aa purple/white rule to all human height differences. What is the scientific correction?',
      'Use a model accounting for multiple genes and environmental influences',
      'Assign one dominant letter to every taller person',
      'Treat a Punnett square as proof that environment never matters',
      'Assume dominance identifies which person is healthier',
      'The stated single-gene plant model cannot describe complex human height variation.',
      'Mastery: model limits'
    ],
  ],
);

final _chemicalReactions = scienceTopic(
  grade: 'g8',
  order: 2,
  title: 'Chemical Reactions',
  subtitle:
      'Identify new substances and balance atom accounts without changing formulas',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Distinguish physical changes from reactions that form new substances.',
    'Evaluate reaction evidence while considering alternative physical explanations.',
    'Read formulas and balance simple equations by changing coefficients.',
    'Use atom and mass conservation to account for closed and open reaction systems.',
  ],
  introduction:
      'An ice cube melts and a piece of metal corrodes. Both look different afterward, but the changes are not the same kind. Chemistry asks whether new substances formed, then accounts for the atoms that make them rather than assuming matter appeared or vanished.',
  prerequisiteTopicId: 'science.g8.genetics-basics',
  sections: [
    scienceSection('A new substance is the central idea',
        '''A physical change alters state, shape or distribution without changing the chemical identity of the substance. Melting ice produces liquid water, still made of water molecules. Dissolving known sugar spreads sugar molecules among water molecules. Those familiar changes do not by themselves make a different substance.

A chemical reaction forms substances with different chemical identities. The starting substances are reactants; the substances formed are products. In a molecular reaction, atoms may become connected in new arrangements as bonds break and form. The atoms themselves do not become different elements in an ordinary chemical reaction. Corrosion can form a metal compound with oxygen; the new compound has properties different from the original metal. A change being difficult to reverse is not the definition of a reaction.'''),
    scienceSection('Signs are evidence, not automatic proof',
        '''Gas production, a persistent color change, a temperature change or formation of a new solid can support a reaction explanation. However, bubbles can occur when water boils or dissolved gas escapes. Mixing colored dyes can change appearance without forming a new chemical substance. A warmer material can raise a mixture's temperature by heat transfer alone.

A precipitate is a solid that forms from a solution during a process such as a reaction. It differs from sand already present that merely settles. To infer reaction, combine observations with what the materials were, controlled comparisons and evidence about the product's properties. Some reactions have little visible change. Therefore neither one dramatic sign nor lack of a dramatic sign settles every case.'''),
    scienceVisual('sci-g8-2-evidence',
        'For each sign, identify a possible alternative and what further evidence would distinguish it.'),
    scienceSection('Read formulas as atom counts',
        '''Chemical symbols identify elements: H is hydrogen, O is oxygen and C is carbon. A subscript gives the number of those atoms in one molecule or formula unit. H₂ has two hydrogen atoms per molecule. O₂ has two oxygen atoms per molecule. H₂O contains two hydrogen atoms and one oxygen atom; the absent subscript after O means one.

A coefficient before a formula multiplies the whole formula. In 2H₂O, two water molecules contain 2 × 2 = 4 H atoms and 2 × 1 = 2 O atoms. Changing H₂O to H₂O₂ would describe hydrogen peroxide, a different substance, not twice as much water. Counting coefficients and subscripts separately prevents changing a substance accidentally while trying to balance an equation.'''),
    scienceSection('A chemical equation records the transformation',
        '''An equation places reactants before an arrow and products after it. A plus sign separates different participating substances or quantities. The arrow means produces or yields; it is not a statement that reactants and products have identical properties. A balanced equation has the same number of atoms of each element on both sides.

Balancing changes coefficients, not the chemical formulas supplied. The coefficients express ratios of reacting particles; they do not say that 2 g of one substance reacts with 1 g of another. Different particles have different masses, so particle-number ratios and mass ratios are distinct. This lesson counts particles and atoms without requiring mole calculations.'''),
    scienceSection('Worked example: balance formation of water',
        '''Start with H₂ + O₂ → H₂O. Step 1: count atoms. The left has two H and two O; the right has two H and one O. Step 2: make two water molecules by writing 2H₂O, giving four H and two O on the right. Step 3: supply four H atoms on the left with 2H₂. The equation becomes 2H₂ + O₂ → 2H₂O.

Step 4: recount both elements. Hydrogen is four on each side; oxygen is two on each side. The number of molecules is not conserved here: three reactant molecules become two product molecules. What is conserved is the number of each type of atom and the ordinary reaction system's material mass. This is a diagram exercise only; mixing and igniting hydrogen with oxygen is dangerous and is not an activity.'''),
    scienceVisual('sci-g8-2-atoms',
        'Count atoms by element, not just the total circles or the number of molecules.'),
    scienceSection('Guided example: carbon, hydrogen and oxygen',
        'Consider CH₄ + O₂ → CO₂ + H₂O, a supplied equation for complete reaction of methane with oxygen. CH₄ contains one C and four H atoms. Choose a water coefficient to match hydrogen, then choose an oxygen coefficient to match all product oxygen atoms. Keep each formula unchanged. What final counts should appear on both sides?'),
    scienceSection('Reveal: balance one element, then recheck all',
        'Use 2H₂O to supply four product H atoms. Products now contain two O in CO₂ plus two O in two water molecules: four O total. Use 2O₂ on the left. CH₄ + 2O₂ → CO₂ + 2H₂O has one C, four H and four O on each side. It is a symbolic exercise, not an instruction to burn methane.',
        reveal: true),
    scienceSection('Mass conservation needs a boundary',
        '''Atoms are rearranged in ordinary reactions rather than created or destroyed. If no matter crosses the study boundary, the total measured material mass remains the same to ordinary classroom measurement precision. In the supplied model, 10 g of one reactant and 15 g of another make 25 g of total product contents after complete reaction. Including a 35 g container gives 60 g both before and after.

An open container can lose gas products or gain a reactant from the air. A lower reading does not prove matter was destroyed. A metal can gain mass when oxygen from air joins it in a product. If a model metal starts at 10 g and incorporates 3 g oxygen, the product mass is 13 g, assuming no other transfers. The oxygen must be included in the material account.'''),
    scienceVisual('sci-g8-2-mass',
        'The same boundary and all contents must be included in both readings.'),
    scienceSection('Energy transfers during reaction',
        '''Breaking chemical bonds requires energy; forming bonds releases energy. The overall reaction can transfer energy to its surroundings when formation releases more than breaking requires. Such a reaction is exothermic. If the reaction takes in energy overall, it is endothermic. A temperature change can give evidence of a transfer, but the experimental comparison must rule out ordinary warming or cooling from other sources.

Energy is transferred, not created from nothing. An exothermic reaction may still need an initial energy input to begin. The detailed bond energies and reaction mechanisms require later study. The simple particle model records conservation and final groupings rather than showing every collision or how quickly the reaction occurs.'''),
    scienceSection('Safe atom-account activity',
        '''Use paper circles labeled H, O and C. Build the supplied reactant groupings, then rearrange the same circles into products. Record a before-and-after count for each element. Do not add a missing atom card to repair the product picture; first correct the coefficients or the arrangement. Keep colors and labels consistent so one element is not silently changed into another.

For evidence practice, compare teacher-provided descriptions of boiling, dye mixing, corrosion and a newly formed precipitate. Explain what supports each interpretation and what remains uncertain. Learners do not combine household cleaners, heat mixtures, ignite gases, taste samples or produce pressurized gas in a sealed container.'''),
    scienceSection('Common mistakes',
        'Visible change alone does not establish reaction. A precipitate forms rather than merely being an old solid settling. Coefficients count whole formulas; subscripts identify the substance. Molecule counts can change while atom counts stay balanced. Open-vessel mass changes require tracking gas transfers, and bond breaking requires rather than releases energy.'),
    scienceSection('Quick check',
        'How many H and O atoms are represented by 3H₂O? Why can ordinary boiling produce bubbles without chemical reaction? If 3 g gas leaves the model 60 g open system, what reading remains?'),
    scienceSection('Check your thinking',
        'Three water molecules represent six H and three O atoms. Boiling changes water state rather than its chemical identity. The open system reads 57 g after 3 g leaves; including the escaped gas restores the 60 g material account.',
        reveal: true),
    scienceSection('Recap',
        'Identify new substances with evidence and alternatives, then count atoms using unchanged formulas and appropriate coefficients. Account for all material across a chosen boundary, and keep reaction energy transfers distinct from creation or destruction of matter.'),
  ],
  keyConcept:
      'Chemical reactions rearrange atoms into new substances. Balanced equations conserve each element’s atom count, and measured mass must be interpreted using the system boundary.',
  questions: [
    [
      'Ice melts into liquid water. Which description identifies the kind of change?',
      'Physical, because water retains its chemical identity',
      'Chemical, because any state change creates a new substance',
      'Chemical, because liquid particles are newly created',
      'Physical, because all particle motion stops',
      'Melting changes arrangement and state without changing water into a different substance.',
      'Physical versus chemical'
    ],
    [
      'In a reaction equation, what are the starting substances called?',
      'Reactants',
      'Products',
      'Precipitates in every case',
      'Coefficients',
      'Reactants participate before transformation; products are formed.',
      'Reaction vocabulary'
    ],
    [
      'In H₂O, what does the subscript 2 specify?',
      'Two H atoms per water molecule',
      'Two O atoms per water molecule',
      'Two separate water molecules',
      'Two grams of water',
      'The subscript follows H and counts hydrogen within one molecule.',
      'Subscripts'
    ],
    [
      'What does the coefficient in 2H₂O multiply?',
      'The entire water formula',
      'Only the oxygen count, leaving hydrogen unchanged',
      'Only the hydrogen count, leaving oxygen unchanged',
      'Only the number of elements, not molecule quantity',
      'Two whole water molecules contain four H and two O atoms.',
      'Coefficients'
    ],
    [
      'What is a precipitate in the context taught here?',
      'A solid newly formed from a solution',
      'Any old sand grain settling in water',
      'Only water vapor leaving a solution',
      'Every unchanged soluble substance',
      'Precipitate formation differs from an already present solid merely settling.',
      'Precipitates'
    ],
    [
      'What must match on both sides of a balanced chemical equation?',
      'The count of each element’s atoms',
      'Only the total number of molecules',
      'Only the visible color of substances',
      'The physical state of every substance',
      'An ordinary chemical reaction rearranges atoms while conserving each element.',
      'Atom conservation'
    ],
    [
      'What happens energetically when a chemical bond is broken?',
      'Energy is required',
      'Energy is always released by breaking alone',
      'No energy transfer can occur during breaking',
      'Energy is required only when new bonds form',
      'Breaking bonds requires input; forming bonds releases energy.',
      'Bond energy'
    ],
    [
      'Which count is represented by 2H₂O?',
      'Four H atoms and two O atoms',
      'Two H atoms and two O atoms',
      'Four H atoms and four O atoms',
      'Two H atoms and one O atom',
      'Multiply each formula count by two: H 2 × 2, O 2 × 1.',
      'Formula counting'
    ],
    [
      'Why is changing H₂O to H₂O₂ an invalid way to balance water formation?',
      'It changes the product into a different substance',
      'It only doubles the number of water molecules',
      'It preserves the same formula and changes only quantity',
      'It removes the need to count hydrogen',
      'Hydrogen peroxide is not water; balance with coefficients rather than altered subscripts.',
      'Formula identity'
    ],
    [
      'Which equation balances the supplied water-formation reaction?',
      '2H₂ + O₂ → 2H₂O',
      'H₂ + O₂ → H₂O',
      '2H₂ + 2O₂ → 2H₂O',
      'H₂ + O₂ → 2H₂O',
      'The correct equation has four H and two O atoms on each side.',
      'Balancing water'
    ],
    [
      'Bubbles appear when water boils. Why are bubbles alone insufficient evidence of reaction?',
      'A physical state change can produce them',
      'Every bubble must contain a new chemical product',
      'Boiling must split water into hydrogen and oxygen',
      'A gas cannot be the same substance as its liquid form',
      'Water can become vapor without a new chemical identity.',
      'Evidence alternatives'
    ],
    [
      'Which result gives stronger evidence of reaction than a color change alone?',
      'A product with different chemical properties after alternative mixing explanations are checked',
      'The mixture merely becomes a different shade after dye addition',
      'A warm sample transfers heat to a cooler sample',
      'An existing solid settles without changing',
      'New substance properties and controls help distinguish reaction from physical alternatives.',
      'Product evidence'
    ],
    [
      'A closed model combines 10 g and 15 g reactants. What total product-content mass follows after complete reaction?',
      '25 g',
      '5 g',
      '15 g',
      '150 g',
      'The material account adds both reactant masses: 10 + 15 = 25 g.',
      'Mass conservation'
    ],
    [
      'What does the 2:1:2 coefficient ratio in water formation describe?',
      'A particle-number ratio, not a 2 g:1 g:2 g mass ratio',
      'Equal masses for every kind of molecule',
      'A required ratio of container volumes in every setting',
      'A change in the chemical symbols themselves',
      'Different molecules have different masses; coefficients count quantities of whole particles.',
      'Coefficient meaning'
    ],
    [
      'Which coefficients complete CH₄ + __O₂ → CO₂ + __H₂O?',
      '2 for O₂ and 2 for H₂O',
      '1 for O₂ and 2 for H₂O',
      '2 for O₂ and 1 for H₂O',
      '4 for O₂ and 1 for H₂O',
      'Four H require two water molecules; products then contain four O, supplied by two O₂.',
      'Balancing methane'
    ],
    [
      'How many H and O atoms are represented by 3H₂O?',
      'Six H and three O',
      'Three H and six O',
      'Two H and three O',
      'Six H and six O',
      'Three formulas multiply two H and one O each.',
      'Multiple molecules'
    ],
    [
      'A model metal starts at 10 g and incorporates 3 g oxygen from air. What product mass follows with no other transfers?',
      '13 g',
      '7 g',
      '10 g',
      '30 g',
      'The incoming oxygen adds to the metal: 10 + 3 = 13 g.',
      'Incoming matter'
    ],
    [
      'An open reaction system falls from 60 g to 57 g because gas leaves. Which account is correct?',
      '57 g remains and 3 g moved into the surroundings',
      '57 g remains and no matter moved outside',
      '60 g remains and an additional 3 g moved outside',
      '63 g remains and 3 g moved outside',
      'A 3 g transfer across the open boundary explains the lower reading.',
      'Outgoing matter'
    ],
    [
      'Which interpretation fits an exothermic reaction?',
      'More energy is released in bond formation than required overall for bond breaking',
      'Every broken bond releases energy without input',
      'No reaction can transfer energy to its surroundings',
      'Atom counts increase because energy is released',
      'The net energy transfer is outward, even though breaking bonds requires energy.',
      'Exothermic transfer'
    ],
    [
      'A product model has too few oxygen atoms. What should be done first?',
      'Recount both sides and correct quantities or arrangements without changing elements',
      'Relabel a hydrogen atom as oxygen to make it balance',
      'Delete extra reactant atoms without reporting a transfer',
      'Change the known water formula arbitrarily',
      'A valid ordinary-reaction model conserves each element’s atom count.',
      'Model checking'
    ],
    [
      'In balanced water formation, three reactant molecules become two product molecules. Which statement resolves the apparent change?',
      'Molecule number can change while four H and two O atoms remain',
      'The missing molecule proves matter destruction',
      'Every equation must conserve molecule count as well as atom count',
      'Oxygen atoms must have become hydrogen atoms',
      'New groupings change molecule numbers without changing the inventory of elements.',
      'Mastery: atoms and molecules'
    ],
    [
      'A mixture warms after two samples combine. What would strengthen a chemical explanation?',
      'Control initial temperatures and test evidence for new product substances',
      'Treat warming alone as proof regardless of starting temperatures',
      'Ignore ordinary heat transfer between the samples',
      'Assume every warm mixture must have created atoms',
      'Heat can transfer physically, so controls and product evidence are needed.',
      'Mastery: evidence'
    ],
    [
      'The model container is 35 g and reactant contents total 25 g. After a closed reaction, what should the total reading be?',
      '60 g, including all product contents',
      '25 g, counting only product contents',
      '35 g, counting only the container',
      '10 g, subtracting contents from container mass',
      'The same boundary contains 35 + 25 = 60 g before and after the ordinary closed reaction.',
      'Mastery: complete mass account'
    ],
  ],
);

final _weatherClimate = scienceTopic(
  grade: 'g8',
  order: 5,
  title: 'Weather & Climate',
  subtitle:
      'Read atmospheric records, explain energy flows and compare climate responses',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Distinguish weather observations from long-term climate patterns and variability.',
    'Calculate means and anomalies using matching quantities and stated baselines.',
    'Explain the greenhouse effect and several influences on regional and global climate.',
    'Compare adaptation with mitigation using the purpose and mechanism of an action.',
  ],
  prerequisiteTopicId: 'science.g8.waves',
  introduction:
      '''A town can have a cool afternoon during an unusually warm year. A rainy day can interrupt a season that usually has little rainfall. These are not contradictions: the time interval and comparison matter. To make a useful claim, read the observations, identify the reference and ask whether you are describing today's atmosphere or a pattern across many years.''',
  sections: [
    scienceSection('Weather is an observation; climate is a pattern',
        '''Weather describes atmospheric conditions at a particular place and time, including temperature, precipitation, wind, humidity and air pressure. A forecast concerns upcoming conditions and includes uncertainty. Climate describes long-term patterns and variability of these conditions. It includes averages, seasonal cycles and the frequency or likelihood of extremes, not only a single average temperature.

Climate normals commonly use a 30-year reference period. This provides a useful baseline; it does not mean weather must equal the normal each day or climate cannot change. Actual normals require quality control and statistical handling of missing records and changes in stations. Our small classroom datasets practice reasoning, not the full professional calculation. Five days of temperatures remain a weather record even after you calculate their average.'''),
    scienceSection('A mean describes only the data included',
        '''Consider invented daily mean temperatures of 24, 26, 25, 27 and 28 °C at one station. Step 1: identify the quantity: each entry is already a daily mean, not a daily maximum. Step 2: add the five values: 24 + 26 + 25 + 27 + 28 = 130 °C. Step 3: divide by five equally weighted days: 130 ÷ 5 = 26 °C. The record ranges from 24 to 28 °C; its range is 4 °C.

The five-day mean does not tell you the annual climate. Nor does it reveal rainfall or how many extremely hot days occur over decades. Two places could have the same annual mean but different seasonal swings. Explain the time interval, quantity and spread rather than treating one average as a complete description.'''),
    scienceSection('Worked example: compare with a baseline',
        '''An anomaly is a difference from a stated reference. An invented station has a provided 30-year reference annual mean temperature of 25.0 °C. Its mean for one recent year is 26.2 °C. Step 1: check that both numbers concern annual mean temperature at the same station. Step 2: subtract reference from observation: 26.2 − 25.0 = +1.2 °C. Step 3: interpret the positive sign: that year was 1.2 °C warmer than the reference.

An anomaly is not an absolute temperature and is not automatically a long-term trend. A trend concerns the direction of change across a series of observations over time. One station-year cannot establish a global trend. Scientists compare long records from many locations and other evidence, check measurement changes and use methods appropriate to the coverage.'''),
    scienceVisual('sci-g8-5-baseline',
        'A provided annual reference and one station-year give an anomaly, not a global conclusion.'),
    scienceSection('Guided example: rainfall needs a matching comparison',
        '''The same hypothetical station has a reference annual precipitation total of 1,000 mm. A particular year records 900 mm. Calculate the difference and state whether it is wetter or drier than that annual reference. Then consider whether a daily maximum temperature should be compared directly with a reference annual mean temperature. Pause and check both the variable and the time interval.'''),
    scienceSection('Reveal: sign, units and matching quantities',
        '''The rainfall anomaly is 900 − 1,000 = −100 mm: the year received 100 mm less precipitation than its reference. It is a difference in annual totals, not an average daily rainfall. Daily maximum temperature and annual mean temperature summarize different things. A fair anomaly calculation needs a reference for the same quantity, place and time interval. A warm day compared with an annual mean may mainly reflect the season.''',
        reveal: true),
    scienceSection('Regional climate has several influences',
        '''Latitude affects the angle and seasonal pattern of sunlight reaching a location. Higher elevations are generally cooler than nearby lowlands, though particular weather conditions can produce exceptions. Large bodies of water warm and cool more slowly than land, often moderating nearby temperature changes. Winds and ocean currents redistribute energy and moisture; they help make two places at similar latitude differ.

Mountains can force moist air upward. As rising air cools, water vapor can condense and precipitation can fall on the windward side. The leeward side can be drier: a rain shadow. These are interacting influences, not guarantees that every coastal town, mountain or latitude has identical weather. Regional climate includes where a place sits within circulating air and ocean systems.'''),
    scienceSection('The natural greenhouse effect is an energy process',
        '''The Sun supplies energy mostly as relatively shortwave radiation, including visible light. Some incoming energy is reflected by clouds and surfaces; some is absorbed. A warmed surface emits longer-wave infrared radiation. Greenhouse gases, including water vapor, carbon dioxide and methane, absorb some of this outgoing infrared energy. The atmosphere emits infrared upward and downward, exchanging energy with the surface and space.

This natural greenhouse effect helps keep Earth's surface warmer than it would otherwise be. It is not greenhouse gases acting as a shiny mirror, nor all energy being held forever. Some surface infrared escapes directly; the atmosphere also emits energy to space. Increasing greenhouse gases changes the balance of outgoing and incoming energy. The system warms until its outgoing energy can again balance incoming energy under the new conditions.'''),
    scienceVisual('sci-g8-5-radiation',
        'Absorption and emission of infrared are different from sunlight reflection.'),
    scienceSection('Drivers, variation and evidence',
        '''Climate has natural influences, including changes in solar energy and volcanic eruptions. Large eruptions can add particles to the atmosphere that reflect sunlight and produce temporary cooling. Ocean–atmosphere variations can also redistribute energy and affect weather across regions without accounting for the whole long-term global warming trend.

Human activities increase greenhouse gases, notably through burning fossil fuels and changes in land use. Scientific evidence shows that human influence is the main cause of recent global warming; solar changes do not explain the observed recent trend. This conclusion rests on extensive evidence, not our invented five-day record. Ozone depletion is a different atmospheric issue from the greenhouse mechanism. A cool week cannot cancel a long-term global warming pattern, just as a hot afternoon alone cannot measure it.'''),
    scienceSection('Two response purposes',
        '''Adaptation adjusts to actual or expected climate and its effects to reduce harm. Improving drainage for heavier rainfall, planning heat-safe school schedules and providing accessible cooling spaces are examples when designed for those risks. Adaptation reduces vulnerability; it does not guarantee no harm.

Mitigation reduces greenhouse gas emissions or increases their removal from the atmosphere. Replacing fossil-fuel electricity with a lower-emission source or using less energy for the same service can contribute to mitigation. Assess the whole stated context rather than assuming every device or project has identical benefits. Some projects can serve both purposes. Communities need to consider local needs, costs and access while preparing for impacts and reducing future warming.'''),
    scienceVisual('sci-g8-5-responses',
        'Classify a response by what it changes: impacts, emissions or both.'),
    scienceSection('Safe data activity, quick check and recap',
        '''Use the supplied paper records or an existing teacher-provided dataset. Label place, units, variable and interval. Calculate a mean, show its range and identify what additional records a climate claim would need. If making observations, remain in a safe shaded location with supervision; do not go into storms, floodwater or dangerous heat to collect data.

Check these statements: our five daily means average 26 °C; an annual 26.2 °C observation compared with the matching 25.0 °C reference has a positive anomaly; drainage designed for flood risk is adaptation. Explain why an afternoon, annual anomaly and climate trend answer different questions.'''),
    scienceSection('Reveal: careful claims',
        '''The five-day mean describes those days. The annual anomaly is +1.2 °C relative to its stated annual reference. Drainage reduces impacts and is adaptation. Climate requires long-term patterns, variation and properly checked records. Follow incoming and outgoing energy to explain the greenhouse effect, and follow an action's purpose to distinguish adapting to impacts from mitigating emissions.''',
        reveal: true),
  ],
  keyConcept:
      'Match atmospheric claims to their place, time interval and baseline; climate patterns and greenhouse energy flows guide adaptation and mitigation.',
  questions: [
    [
      'A station reports this afternoon’s temperature, wind and rainfall. What does that report describe?',
      'Weather at that place and time',
      'A complete 30-year climate normal',
      'The global warming trend by itself',
      'Only the station’s greenhouse gas emissions',
      'These are atmospheric conditions for a particular place and short interval, so they describe weather.',
      'Foundation: weather'
    ],
    [
      'Which description would give the fullest climate picture of a town?',
      'Long-term seasonal patterns, averages and variability of atmospheric conditions',
      'The temperature at noon on its hottest recorded day alone',
      'Only a five-day mean from one school week',
      'Only tomorrow’s forecast without historical observations',
      'Climate includes long-term patterns and variation, including seasons and extremes rather than one short observation.',
      'Foundation: climate'
    ],
    [
      'Why does the lesson use a 30-year climate reference rather than treating one week as a normal?',
      'A long reference period represents long-term conditions more usefully',
      'Thirty years guarantees no weather variation within the period',
      'Weather measurements become exact only after thirty years',
      'A climate reference forbids future climate change',
      'The long period supplies a baseline; variability, measurement issues and climate change still exist.',
      'Foundation: reference period'
    ],
    [
      'In the greenhouse diagram, which radiation is emitted by the warmed surface?',
      'Longwave infrared radiation',
      'Only the unchanged incoming visible sunlight',
      'Only reflected shortwave radiation with no emission',
      'Only ultraviolet radiation regardless of surface temperature',
      'Absorbed energy warms the surface, which emits longer-wave infrared radiation.',
      'Foundation: surface emission'
    ],
    [
      'Which atmospheric interaction is central to the greenhouse mechanism taught here?',
      'Absorbing infrared energy and emitting infrared upward and downward',
      'Reflecting every incoming ray of visible light back to space',
      'Stopping all outgoing energy permanently',
      'Absorbing only shortwave sunlight while never emitting infrared',
      'Greenhouse gases absorb some outgoing infrared; atmospheric emission exchanges energy in both directions.',
      'Foundation: greenhouse mechanism'
    ],
    [
      'A school improves drainage to reduce harm from expected heavier rainfall. What is its stated climate purpose?',
      'Adaptation to an impact',
      'Mitigation by directly reducing fossil-fuel emissions',
      'Measurement of a temperature anomaly',
      'Calculation of a climate normal',
      'The drainage change reduces exposure to rainfall impacts, which is adaptation in this context.',
      'Foundation: adaptation'
    ],
    [
      'A town replaces fossil-fuel electricity with a lower-emission supply. What climate purpose does that change serve?',
      'Mitigation through reduced greenhouse gas emissions',
      'Adaptation solely through flood drainage',
      'Observation of daily air pressure',
      'Elimination of all natural climate variation',
      'Reducing greenhouse gas emissions addresses a cause of future warming and is mitigation.',
      'Foundation: mitigation'
    ],
    [
      'Find the mean of five daily means: 24, 26, 25, 27 and 28 °C.',
      '26 °C',
      '25 °C',
      '27 °C',
      '130 °C',
      'The five daily means total 130; dividing by five equally weighted days gives 26 °C.',
      'Intermediate: mean'
    ],
    [
      'What is the temperature range of that 24, 26, 25, 27 and 28 °C record?',
      '4 °C',
      '26 °C',
      '2 °C',
      '52 °C',
      'Range subtracts the smallest value from the largest: 28 − 24 = 4 °C.',
      'Intermediate: spread'
    ],
    [
      'An annual station mean is 26.2 °C and its matching reference is 25.0 °C. What is the anomaly?',
      '+1.2 °C',
      '−1.2 °C',
      '+25.0 °C',
      '+51.2 °C',
      'Subtract the reference from the observation: 26.2 − 25.0 = +1.2 °C, warmer than that baseline.',
      'Intermediate: anomaly'
    ],
    [
      'Which comparison best supports a meaningful daily temperature anomaly?',
      'A daily mean and a long-term reference for the same station and calendar interval',
      'A daily maximum and an annual mean from another region',
      'A noon temperature and an annual rainfall total',
      'A winter minimum and an unrelated summer maximum',
      'Anomalies require matching variables, location and intervals; otherwise differences can reflect mismatched summaries.',
      'Intermediate: matching reference'
    ],
    [
      'Why can two towns at similar latitude have different regional climates?',
      'Elevation, nearby water and circulation can differ',
      'Latitude alone determines every atmospheric condition',
      'Ocean currents cannot redistribute energy',
      'Large bodies of water always warm and cool as quickly as land',
      'Several interacting influences shape climate; latitude is one influence rather than a complete prediction.',
      'Intermediate: regional influences'
    ],
    [
      'Which side of a mountain can receive more precipitation when moist air rises and cools?',
      'The windward side facing the arriving moist air',
      'The leeward side solely because descending air must get wetter',
      'Both sides must always have identical precipitation',
      'Neither side because rising air cannot cool',
      'Rising moist air can cool and condense on the windward side, contributing to a drier leeward rain shadow.',
      'Intermediate: rain shadow'
    ],
    [
      'What does a positive annual temperature anomaly say by itself?',
      'That year is warmer than the stated matching reference',
      'Every day of that year exceeded every reference-day temperature',
      'The entire world warmed by exactly that station’s difference',
      'All future years must have the same temperature',
      'An anomaly is a difference for its stated quantity and baseline; it does not describe every day or every location.',
      'Intermediate: anomaly limits'
    ],
    [
      'Annual precipitation is 900 mm against a matching 1,000 mm reference. Interpret the difference.',
      '−100 mm: 100 mm less than the reference total',
      '+100 mm: 100 mm more than the reference total',
      '−900 mm: no precipitation occurred that year',
      '+1,900 mm: the two totals must be added',
      'Subtract reference from observation: 900 − 1,000 = −100 mm, indicating less annual precipitation.',
      'Application: precipitation anomaly'
    ],
    [
      'A student calls a five-day mean a complete description of annual climate. Which revision follows the evidence?',
      'It describes those five days; long-term records are needed for climate patterns',
      'It proves all seasons share the same temperatures',
      'It becomes an annual climate normal because division was used',
      'It proves precipitation and extremes match the temperature mean',
      'Calculating an average does not extend the time interval or reveal unmeasured climate variables.',
      'Application: bounded claim'
    ],
    [
      'A town has a cold week during a long-term warming trend. Which interpretation is sound?',
      'Short-term variability can occur within a long-term warming pattern',
      'That week cancels the trend in every region',
      'A warming climate requires every day to be warmer than the previous day',
      'Cold weather means greenhouse gases cannot absorb infrared',
      'Weather fluctuates; a long-term trend concerns many observations over time rather than uninterrupted daily increases.',
      'Application: variability'
    ],
    [
      'Which correction improves a diagram showing greenhouse gases as mirrors that hold all energy forever?',
      'Show infrared absorption and emission, including routes to space',
      'Remove all outgoing infrared arrows from the model',
      'Show only ozone loss as the source of the greenhouse effect',
      'Label every reflected sunlight ray as newly emitted infrared',
      'Absorption and emission differ from reflection; Earth continues emitting energy to space.',
      'Application: energy model'
    ],
    [
      'Which statement about recent global warming matches the scientific evidence discussed?',
      'Human influence is the main cause; solar changes alone do not explain the observed trend',
      'One hot afternoon is the entire evidence for the global trend',
      'Solar changes alone explain the observed recent warming',
      'Natural influences must be absent whenever human influences operate',
      'Extensive evidence identifies the main recent driver while allowing natural variation and other influences.',
      'Application: climate drivers'
    ],
    [
      'A community combines flood preparation with lower-emission electricity. How should the purposes be described?',
      'Adaptation and mitigation can be pursued together',
      'Both are only adaptation because they occur in one community',
      'Both are only mitigation because climate is mentioned',
      'The two purposes cannot occur in the same plan',
      'Flood preparation addresses impacts; lower-emission energy addresses emissions, so the plan includes both.',
      'Application: response comparison'
    ],
    [
      'An invented annual mean is 24.3 °C against a matching 25.0 °C reference. What anomaly and interpretation follow?',
      '−0.7 °C, cooler than that annual reference',
      '+0.7 °C, warmer than that annual reference',
      '−24.3 °C, the absolute annual temperature',
      '+49.3 °C, the sum of reference and observation',
      'Observation minus reference is 24.3 − 25.0 = −0.7 °C; the negative sign indicates cooler than the baseline.',
      'Mastery: new anomaly'
    ],
    [
      'What would strengthen a claim about a regional temperature trend beyond one unusual station-year?',
      'Long, quality-checked records from multiple relevant locations',
      'Only the single hottest afternoon at that station',
      'Only a daily maximum compared with an unrelated annual mean',
      'Removing every year that disagrees with the preferred claim',
      'A regional trend needs appropriate long-term coverage and data checks, rather than selective or mismatched observations.',
      'Mastery: evidence'
    ],
    [
      'Why can adding greenhouse gases warm the climate while Earth still loses energy to space?',
      'They change outgoing energy flows, and warming increases emission toward a new balance',
      'They create energy without any solar input',
      'They stop all infrared escape permanently',
      'They work only by changing the color of incoming sunlight',
      'Changing absorption and atmospheric emission alters the energy balance; a warmer system emits more energy rather than holding it forever.',
      'Mastery: greenhouse balance'
    ],
  ],
);

final _waves = scienceTopic(
  grade: 'g8',
  order: 4,
  title: 'Waves',
  subtitle:
      'Connect oscillations, spatial patterns and timed cycles with energy transfer',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Distinguish wave travel from local oscillation in transverse and longitudinal models.',
    'Read amplitude and wavelength from a spatial profile without inventing timing information.',
    'Calculate frequency, period and wave speed with appropriate units.',
    'Explain how a medium and a boundary affect transmission, reflection and absorption.',
  ],
  prerequisiteTopicId: 'science.g8.work-energy',
  introduction:
      '''A pulse travels along a rope while a colored mark on the rope moves up and down near its starting position. The disturbance reaches the far end, but the mark does not ride the pulse there. Following the mark and following the disturbance answer different questions. This difference helps explain sound, light and the repeating patterns called waves.''',
  sections: [
    scienceSection('A disturbance carries energy',
        '''A wave is a disturbance that transfers energy through space or through a material. A material through which a mechanical wave travels is its medium. Rope, water and air can serve as media. Neighboring portions interact, passing the disturbance onward. Each portion can move locally while energy travels much farther. Equilibrium is the position or condition about which that local motion occurs.

A single traveling bump is a pulse. A source that repeatedly oscillates can produce a periodic wave: a repeating disturbance. An oscillation is one back-and-forth cycle. Our ideal rope model separates local oscillation from the travel of the pattern. Real waves can also move material in some circumstances, so this model does not mean every wave in nature transports absolutely no matter. Ask which system and which kind of motion the diagram represents.'''),
    scienceSection('Two directions, two mechanical models',
        '''In a transverse wave, local oscillation is perpendicular to the direction of wave travel. A rope disturbance traveling horizontally can have rope portions moving vertically. In a longitudinal wave, local oscillation is parallel to travel. For sound traveling through air, particles move back and forth along the sound's direction. They produce compressions, where particles are closer together and pressure is higher, and rarefactions, where particles are farther apart and pressure is lower.

Air particles do not generally travel all the way from a speaker to an ear with each sound. The disturbance propagates through neighboring particles. Surface water waves have more complicated motion, often involving both horizontal and vertical movement. Calling every water particle's path purely transverse would overlook that difference.'''),
    scienceVisual('sci-g8-4-types',
        'Compare the local motion with the direction of energy transfer.'),
    scienceSection('Sound and light need different models',
        '''Sound needs a material medium and can travel through gases, liquids and solids. Its speed depends on the material and conditions such as temperature. Sound cannot cross an ideal vacuum containing no particles to pass the mechanical disturbance along. Light is an electromagnetic wave and can travel through a vacuum. It does not require air particles to carry it.

A drawn sine-shaped curve is a representation, not necessarily a photograph of material bent into that shape. A graph might show rope displacement, sound pressure or an electromagnetic field. Read the axis labels before deciding what the curve means. A curved sound graph does not make air sound transverse; the graph could be showing pressure changes at successive positions.'''),
    scienceSection('Read a snapshot: amplitude and wavelength',
        '''Amplitude is the maximum displacement from equilibrium in our rope model. The illustrated wave has amplitude 0.5 m: equilibrium to crest. Its trough is 0.5 m below equilibrium, so crest-to-trough height is 1 m. That full height is twice the amplitude. Otherwise comparable waves with larger amplitude generally transfer more energy, but amplitude is not a count of cycles.

Wavelength, written λ, is the distance between neighboring points at the same stage of the repeating pattern, such as one crest and the next crest. It is measured along travel, in meters. Here neighboring crests are 2 m apart. Amplitude and wavelength describe different dimensions. A spatial profile gives positions at one instant; it cannot reveal cycles per second unless timing or other suitable information is supplied.'''),
    scienceVisual('sci-g8-4-profile',
        'Frequency is supplied separately from this spatial snapshot.'),
    scienceSection('Watch a fixed point: frequency and period',
        '''Frequency f counts complete cycles passing a fixed point each second. Its unit is hertz, Hz, meaning cycles per second. If five complete cycles pass in two seconds, f = 5 ÷ 2 = 2.5 Hz. Count complete repetitions, not every upward and downward extreme as separate cycles.

Period T is the time for one complete cycle. Because frequency counts cycles per second and period gives seconds per cycle, T = 1/f. At 4 Hz, T = 1 ÷ 4 = 0.25 s. Faster repetition means a shorter period. For sound, frequency is closely connected to pitch: higher frequency means higher pitch. Increasing amplitude at unchanged frequency mainly changes sound intensity, not pitch.'''),
    scienceSection('Worked example: connect space with time',
        '''The source produces 3 cycles each second, so f = 3 Hz. A separately measured wavelength is 2 m. In one period the pattern advances one wavelength. Wave speed is therefore v = fλ. Step 1: identify frequency, 3 cycles/s. Step 2: identify wavelength, 2 m/cycle. Step 3: multiply: v = 3 × 2 = 6 m/s. The cycles cancel in the units, leaving distance per second.

Step 4: calculate period, T = 1/3 s, approximately 0.33 s. The wave advances 2 m in about one third of a second. Its 0.5 m amplitude is useful information, but it is not a factor in this speed calculation. In the simple fixed-medium model, speed is determined by the medium rather than automatically increasing whenever the source repeats faster.'''),
    scienceSection('Guided example: change the source',
        '''A wave travels at 12 m/s while the source frequency is 4 Hz. Find wavelength and period, then predict wavelength if frequency rises to 8 Hz while speed stays 12 m/s. Begin with v = fλ. To isolate wavelength, divide speed by frequency. To find period, use the reciprocal of frequency. State the fixed-speed assumption before predicting the change.'''),
    scienceSection('Reveal: the changed source',
        '''Wavelength is 12 ÷ 4 = 3 m. Period is 1 ÷ 4 = 0.25 s. At 8 Hz and unchanged speed, wavelength becomes 12 ÷ 8 = 1.5 m. Twice as many cycles fit into each second, so their spatial spacing halves. Frequency and wavelength change together; speed stays fixed in this stated model.''',
        reveal: true),
    scienceSection('At a boundary, follow the energy',
        '''Reflection returns some disturbance into the original medium. Transmission carries some onward across a boundary. Absorption converts some wave energy into other energy, often thermal energy in the material. All three can occur together. A window can reflect some light, transmit some and absorb some; energy accounting includes every route.

For a stationary boundary and a steady source, transmitted frequency remains tied to the source. A new medium can change wave speed and therefore wavelength. If speed decreases while frequency stays unchanged, wavelength becomes shorter. Absorption does not make energy disappear, and reflection does not create extra energy. A diagram without numerical energy labels cannot tell you the percentages taking each route.'''),
    scienceVisual('sci-g8-4-boundary',
        'A boundary can divide incoming energy among several routes.'),
    scienceSection('Safe observation and common mistakes',
        '''Use a paper wave profile first. Draw equilibrium, two crests and a trough. Mark amplitude vertically and wavelength horizontally using separate arrows. Supply a frequency from a written timing record; do not guess it from the drawing. Explain what each axis represents.

For a teacher-supervised soft-rope demonstration, keep movements small, the rope away from faces and necks, and the floor clear. Mark one portion and compare its local motion with pulse travel. There is no need for loud headphones, lasers or unfamiliar electrical equipment. Common mistakes are using full crest-to-trough height as amplitude, confusing wavelength with period, and treating a profile as one particle's travel path. Check units: meters, seconds and hertz describe different quantities.'''),
    scienceSection('Quick check and recap',
        '''A source has frequency 4 Hz. What is its period? Another wave has frequency 3 Hz and wavelength 2 m. What is its speed? A profile's amplitude is 0.5 m. How tall is crest to trough? Explain which answers require timing information and which can be read spatially.'''),
    scienceSection('Reveal: measurements and recap',
        '''The period is 0.25 s; the second wave's speed is 6 m/s; crest-to-trough height is 1 m. Frequency supplies timing, while amplitude and wavelength describe a spatial profile. Wave travel transfers energy; local oscillation, medium requirements and boundary behavior must be explained using the correct wave model. Two graphs could show the same amplitude and wavelength yet represent waves repeating at different rates in different media. Always connect a claim to its spatial measurement, timing record and stated assumptions.''',
        reveal: true),
  ],
  keyConcept:
      'Separate local oscillation from wave travel, and separate spatial measurements from timing: v = fλ and T = 1/f connect them.',
  questions: [
    [
      'A rope pulse moves right while a marked portion oscillates vertically. Which model fits?',
      'A transverse mechanical wave',
      'A longitudinal sound wave in air',
      'An undisturbed rope at equilibrium',
      'A stream carrying every rope portion to the right',
      'The marked portion oscillates perpendicular to pulse travel, which defines the transverse model.',
      'Foundation: wave type'
    ],
    [
      'In the air-sound model, how do local particle oscillations compare with sound travel?',
      'They run parallel to the direction of travel',
      'They run perpendicular to the direction of travel',
      'Each particle travels the entire source-to-ear distance',
      'Particles remain motionless while pressure changes',
      'Longitudinal oscillations produce successive compressions and rarefactions along travel.',
      'Foundation: longitudinal motion'
    ],
    [
      'A rope mark reaches its greatest distance from equilibrium. Which quantity measures that distance?',
      'Amplitude',
      'Wavelength',
      'Period',
      'Frequency',
      'Amplitude measures maximum displacement from equilibrium, rather than spacing or timing.',
      'Foundation: amplitude'
    ],
    [
      'Which measurement gives wavelength on a repeating spatial rope profile?',
      'Distance from one crest to the next crest',
      'Distance from equilibrium vertically to a crest',
      'Time for the source to complete one cycle',
      'Number of cycles passing each second',
      'Neighboring crests share the same stage of the repeating pattern and are one wavelength apart.',
      'Foundation: wavelength'
    ],
    [
      'A source is labeled 3 Hz. What does this timing information mean?',
      'Three complete cycles occur at a fixed point each second',
      'Neighboring crests must be three meters apart',
      'Every complete cycle takes three seconds',
      'The wave must travel at three meters per second',
      'Hertz counts complete cycles per second; speed and spacing need additional information.',
      'Foundation: frequency'
    ],
    [
      'Which observation directly measures a wave period?',
      'Timing one complete cycle at a fixed point',
      'Measuring the distance between neighboring crests',
      'Measuring the greatest displacement from equilibrium',
      'Counting reflected energy per meter of material',
      'Period is the time for one complete repetition and is measured in seconds.',
      'Foundation: period'
    ],
    [
      'Which disturbance can cross an ideal vacuum without a material medium?',
      'Light from a star',
      'Sound from an air speaker',
      'A pulse along a rope',
      'A ripple on a water surface',
      'Light is electromagnetic; the other examples require material for mechanical propagation.',
      'Foundation: medium'
    ],
    [
      'A rope profile has amplitude 0.5 m. What is its full crest-to-trough height?',
      '1 m',
      '0.5 m',
      '0.25 m',
      '2 m',
      'The crest is 0.5 m above equilibrium and the trough 0.5 m below, giving 1 m altogether.',
      'Intermediate: profile measurement'
    ],
    [
      'Five complete cycles pass a sensor in 2 s. What frequency does the record show?',
      '2.5 Hz',
      '10 Hz',
      '0.4 Hz',
      '5 Hz',
      'Divide the five cycles by two seconds: 2.5 complete cycles per second.',
      'Intermediate: frequency calculation'
    ],
    [
      'A vibrating source completes 4 cycles each second. Find its period.',
      '0.25 s',
      '4 s',
      '2 s',
      '0.5 s',
      'Period is the reciprocal of 4 Hz: one cycle takes 1/4 second, or 0.25 s.',
      'Intermediate: reciprocal period'
    ],
    [
      'A wave has frequency 3 Hz and wavelength 2 m. Calculate its propagation speed.',
      '6 m/s',
      '1.5 m/s',
      'About 0.67 m/s',
      '5 m/s',
      'Multiply cycles per second by meters per cycle: 3 × 2 = 6 m/s.',
      'Intermediate: wave speed'
    ],
    [
      'What can an accurately scaled spatial snapshot supply without timing data?',
      'Amplitude and wavelength',
      'Frequency without any other information',
      'The exact time each particle takes to cross the medium',
      'The percentage of energy reflected at every boundary',
      'A spatial profile measures displacement and spacing; cycles per second require timing or other suitable data.',
      'Intermediate: spatial evidence'
    ],
    [
      'A sound source is adjusted to a higher pitch. Which change matches that observation?',
      'Its oscillation frequency increases',
      'Only amplitude increases at unchanged frequency',
      'Its oscillation frequency decreases',
      'Only crest height changes while timing stays fixed',
      'Higher sound pitch is linked to higher frequency; amplitude chiefly affects intensity.',
      'Intermediate: pitch'
    ],
    [
      'A steady wave crosses a stationary boundary into another medium. Which quantity remains tied to its source?',
      'Frequency',
      'Speed in every possible medium',
      'Wavelength in every possible medium',
      'The absorbed fraction at every boundary',
      'The stationary boundary does not change the source repetition rate, though speed and wavelength can change.',
      'Intermediate: boundary timing'
    ],
    [
      'A wave travels at 12 m/s with frequency 4 Hz. What wavelength follows?',
      '3 m',
      '48 m',
      'About 0.33 m',
      '8 m',
      'Rearrange v = fλ: wavelength is 12 m/s divided by 4 cycles/s, giving 3 m.',
      'Application: wavelength calculation'
    ],
    [
      'In that 12 m/s medium, frequency changes from 4 Hz to 8 Hz. What happens to wavelength?',
      'It halves from 3 m to 1.5 m',
      'It doubles from 3 m to 6 m',
      'It remains 3 m while speed stays fixed',
      'It becomes 8 m because frequency is 8 Hz',
      'At the stated fixed speed, λ = v/f; doubling frequency halves spatial spacing.',
      'Application: fixed-speed prediction'
    ],
    [
      'A material absorbs part of an incoming wave. Where can that absorbed energy go?',
      'Into other energy stores, often thermal energy',
      'It disappears from the total energy account',
      'It must all return as reflected wave energy',
      'It must increase frequency without another change',
      'Absorption transfers energy into the material; conservation still includes that transfer.',
      'Application: absorption'
    ],
    [
      'A book draws a sinusoidal sound graph. What should you check before interpreting its shape?',
      'Whether its vertical axis represents pressure or displacement',
      'Whether every air particle follows the drawn curve across the page',
      'Whether the curved line proves the air sound is transverse',
      'Whether the graph is a photograph of air bent like rope',
      'A graph represents labeled quantities; a pressure profile is not a particle trajectory.',
      'Application: representations'
    ],
    [
      'Why should a student avoid assigning one universal propagation speed to every sound wave?',
      'Medium properties and conditions such as temperature affect speed',
      'Frequency alone fixes the same speed in all materials',
      'Every sound travels at the speed of light',
      'Longitudinal waves cannot travel through solids',
      'Sound travels through different materials at speeds determined by those materials and conditions.',
      'Application: medium comparison'
    ],
    [
      'Can one boundary reflect, transmit and absorb portions of the same incoming wave energy?',
      'Yes; incoming energy can divide among these routes',
      'No; only one route can occur at a boundary',
      'No; transmitted energy must always equal the entire input',
      'Yes; the boundary creates extra energy for each route',
      'Multiple processes can occur together; their energy shares belong in one conserved account.',
      'Application: energy routes'
    ],
    [
      'A 3 Hz wave enters a medium where its speed is 3 m/s without changing frequency. Find its new wavelength.',
      '1 m',
      '3 m',
      '9 m',
      'About 0.33 m',
      'Wavelength equals speed divided by frequency: 3 m/s ÷ 3 Hz = 1 m.',
      'Mastery: changed medium'
    ],
    [
      'A class labels a 1 m crest-to-trough height as amplitude. Which correction is justified?',
      'Amplitude is 0.5 m, measured from equilibrium to an extreme',
      'Amplitude is 2 m because both sides must be doubled',
      'Amplitude is 1 Hz because height counts cycles',
      'Amplitude cannot be read from any spatial profile',
      'The full height includes both the upward and downward maximum displacement, twice amplitude.',
      'Mastery: measurement correction'
    ],
    [
      'A marked rope portion returns near equilibrium after a pulse reaches the far end. What traveled along the rope?',
      'The disturbance and energy',
      'The marked portion through the entire rope length',
      'All rope material from one end to the other',
      'Only a force pattern with no energy transfer',
      'Neighboring portions pass a disturbance and energy onward while the mark oscillates locally.',
      'Mastery: transfer model'
    ],
  ],
);

final _workEnergy = scienceTopic(
  grade: 'g8',
  order: 3,
  title: 'Work & Energy',
  subtitle:
      'Calculate transfers and distinguish force, energy, motion and power',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Calculate work by a constant force parallel to a straight displacement.',
    'Calculate simple kinetic and gravitational potential energy using supplied quantities.',
    'Distinguish work by one force from net work and kinetic-energy change.',
    'Compare energy transfer rates and account for energy spreading as thermal energy.',
  ],
  introduction:
      'Holding a heavy bag still can feel tiring even though the bag does not move. Lifting it slowly can increase stored gravitational energy without increasing its speed. The everyday word work is broad; the physics meaning describes a particular transfer of energy.',
  prerequisiteTopicId: 'science.g8.chemical-reactions',
  sections: [
    scienceSection('Work is a force-related energy transfer',
        '''A force does work on an object when it transfers energy through displacement. For a constant force in the same direction as a straight displacement, W = F × d. W is work, F is force in newtons and d is distance in meters along that displacement. A 20 N force through 3 m in its direction does 20 × 3 = 60 J of work.

Work and energy are measured in joules, J. One joule equals one newton-meter, N·m. Force alone is not work: both force and the relevant displacement matter. If a wall does not move when pushed, the push does no mechanical work on the wall in this model, even though the person's muscles use energy. Do not confuse internal biological energy use with work on the chosen object.'''),
    scienceSection('Direction determines the transfer',
        '''The W = Fd form above applies to co-directed force and displacement. An opposing force does negative work, transferring energy away from the object's mechanical motion. A force perpendicular to displacement does zero work in the simple model. If you carry a bag horizontally at constant height, its upward supporting force does no work through the horizontal displacement.

This does not mean carrying uses no body energy. It means the particular upward force is perpendicular to the bag's displacement. Changes in height, speed or swinging require a more detailed account. Before calculating, select the object, identify the force and state its direction relative to the movement. This lesson avoids angled-force trigonometry; it uses parallel, opposite or perpendicular cases.'''),
    scienceSection('Kinetic energy depends on mass and speed',
        '''Kinetic energy is energy associated with motion. For these ordinary-speed models, KE = ½mv², where m is mass in kilograms and v is speed in meters per second. Square the speed, then multiply by mass and by one-half. A 1 kg cart at 2 m/s has KE = ½ × 1 × 4 = 2 J.

At 4 m/s the same cart has KE = ½ × 1 × 16 = 8 J. Doubling speed therefore quadruples kinetic energy at fixed mass. Doubling mass at fixed speed doubles it. Speed is not itself energy, and kilograms measure mass rather than force. These relationships help explain why faster-moving objects can transfer much more energy during a stop.'''),
    scienceVisual('sci-g8-3-kinetic',
        'Use the squared speed and read the vertical values as joules.'),
    scienceSection('Potential energy depends on a configuration',
        '''Potential energy is stored energy associated with the configuration of a system. Near Earth's surface, changing an object's height changes gravitational potential energy of the Earth–object system. For a height increase h, the gain is mgh. We use a rounded model g = 10 N/kg; an object of mass 1 kg therefore has a weight of 10 N.

Raising 1 kg by 1 m gives a gain of 1 × 10 × 1 = 10 J. The chosen starting height is a reference; a quoted gravitational potential energy needs a reference level. Raising the same load through the same vertical height gives the same gravitational gain even if the route differs. Friction along a route can still change the total input required.'''),
    scienceSection('Worked example: steady lifting and net work',
        '''A 1 kg load moves upward steadily through 1 m. Assume g = 10 N/kg, no other resistance and constant velocity during this segment. Step 1: weight is 10 N downward. To keep velocity constant, an equal 10 N lifting force acts upward. Step 2: lifting work is +10 × 1 = +10 J. Step 3: gravity acts against upward displacement, doing −10 J.

Step 4: net work is the sum of work by all forces: +10 + (−10) = 0 J. Net work equals change in kinetic energy, so unchanged speed fits zero net work. Step 5: gravitational potential energy rises by 10 J. Work by the lifting force is not the same as net work. Selecting the load's motion or the Earth–load energy system answers different but consistent questions.'''),
    scienceVisual('sci-g8-3-lift',
        'Follow both the force balance and the energy account; equal forces can each do nonzero work.'),
    scienceSection('Power is a rate, not another energy store',
        '''Power describes how quickly energy is transferred. Average power = transferred energy ÷ elapsed time. Its unit is the watt, W, equal to J/s. Moving 60 J in 6 s gives 10 W; moving the same 60 J in 3 s gives 20 W. Greater power need not mean greater total energy for the whole task.

The letter W is used as a work symbol in equations and as the watt unit after a power number; context distinguishes them. A reading of 20 W states a rate, while 20 J states an energy amount. Keep units in every calculation. When the transfer comes from work, divide that work by the time to obtain average power.'''),
    scienceVisual('sci-g8-3-power',
        'Compare total joules separately from joules transferred per second.'),
    scienceSection('Guided example: a larger low-speed lift',
        'A model raises a 2 kg load by 1.5 m steadily, using g = 10 N/kg and no other resistance. Calculate its weight, lifting work and gravitational energy gain. If the lift lasts 3 s, calculate average lifting power. Does steady speed mean its gravitational energy stays unchanged?'),
    scienceSection('Reveal: calculate each quantity with its units',
        'Weight is 2 × 10 = 20 N. Lifting work is 20 × 1.5 = 30 J, matching the mgh gain of 2 × 10 × 1.5 = 30 J. Average lifting power is 30 ÷ 3 = 10 W. Steady speed keeps kinetic energy unchanged, not gravitational potential energy.',
        reveal: true),
    scienceSection('Conservation includes thermal energy',
        '''Energy can transfer between stores and to surroundings without being created or destroyed. In an ideal falling model, gravitational potential energy decreases while kinetic energy increases. Real interactions such as air resistance and friction transfer some energy into heating the object and surroundings. Mechanical energy, the sum of kinetic and potential energy, need not remain constant when these transfers occur.

Calling energy lost usually means it is no longer available in the chosen useful mechanical store. It has not ceased to exist. A stopping cart can warm its wheels and track slightly. That dispersed thermal energy is harder to use again for the original motion. A complete account needs the system boundary and relevant surroundings, not only the most visible moving part.'''),
    scienceSection('Safe model and observation',
        '''Use a teacher-provided picture or a small classroom object raised a short distance over a low clear surface. Do not lift heavy loads, stand on furniture, drop objects or test moving vehicles. Record supplied mass, height and model g before calculating. Mark the reference height and distinguish vertical height from distance along a sloping route.

Compare two numerical cart models at the same mass but different speeds. Calculate KE and check the expected square relationship. Explain why the bar heights are energy values rather than drawing force arrows with those numbers. The provided datasets allow the activity without physical lifting or powered equipment.'''),
    scienceSection('Common mistakes',
        'Force is measured in N; work and energy in J; power in W. Work requires the relevant displacement and direction. Square speed in kinetic energy. Mass and weight are different. Zero net work can coexist with work by individual forces. Friction transfers energy into thermal stores rather than destroying it.'),
    scienceSection('Quick check',
        'What work does a co-directed 20 N force do over 3 m? How does doubling speed change KE at fixed mass? Can a steady lift increase gravitational energy while leaving KE unchanged?'),
    scienceSection('Check your thinking',
        'The work is 60 J. Doubling speed quadruples KE. A steady lift can increase gravitational energy through lifting work while gravity does equal negative work, leaving zero net work and unchanged KE.',
        reveal: true),
    scienceSection('Recap',
        'Choose the force, displacement and system, then calculate quantities with units. Separate kinetic motion energy, gravitational configuration energy and power. Balance all energy transfers, including those into less useful thermal stores, before deciding what has changed.'),
  ],
  keyConcept:
      'Work transfers energy through force and displacement; net work changes kinetic energy. Potential energy, thermal transfers and power complete different parts of the energy account.',
  questions: [
    [
      'A constant 20 N force moves an object 3 m in its own direction. Which expression gives its work?',
      '20 N × 3 m',
      '20 N ÷ 3 m',
      '3 m ÷ 20 N',
      '20 N + 3 m',
      'For co-directed constant force and displacement, work equals force times distance.',
      'Work calculation rule'
    ],
    [
      'Which unit is used for work and energy?',
      'Joule, J',
      'Newton, N',
      'Watt, W',
      'Meter per second, m/s',
      'Joules measure energy amounts and work; the other units describe force, power and speed.',
      'Energy units'
    ],
    [
      'A person pushes an unmoving wall. What mechanical work is done on the wall in this model?',
      'Zero, because the wall has no displacement',
      'Positive work simply because a force exists',
      'Work equal to the force in newtons without distance',
      'Negative work because the person feels tired',
      'Work on the selected wall requires displacement; muscles can still use energy internally.',
      'Displacement requirement'
    ],
    [
      'Which energy is associated with an object’s motion?',
      'Kinetic energy',
      'Gravitational potential energy alone',
      'Average power',
      'Supporting force',
      'Kinetic energy depends on mass and speed.',
      'Kinetic energy'
    ],
    [
      'Which formula calculates the stated kinetic-energy model?',
      'KE = ½mv²',
      'KE = mv',
      'KE = mgh',
      'KE = F ÷ d',
      'Kinetic energy uses half the mass times squared speed.',
      'Kinetic formula'
    ],
    [
      'A model uses g = 10 N/kg. What is the weight of a 1 kg load?',
      '10 N',
      '1 N',
      '10 J',
      '1 kg of force',
      'Weight is mass times g: 1 kg × 10 N/kg = 10 N.',
      'Mass and weight'
    ],
    [
      'What does power describe?',
      'Energy transferred per unit time',
      'Only the total energy stored',
      'Force multiplied by mass',
      'Distance traveled per unit time',
      'Power is a transfer rate, measured in watts or joules per second.',
      'Power'
    ],
    [
      'What work results from 20 N over 3 m in the same direction?',
      '60 J',
      '6.67 J',
      '23 J',
      '0.15 J',
      'Multiply force by its co-directed displacement: 20 × 3 = 60 J.',
      'Work arithmetic'
    ],
    [
      'A 1 kg cart moves at 2 m/s. What is its kinetic energy?',
      '2 J',
      '1 J',
      '4 J',
      '8 J',
      '½ × 1 × 2² = ½ × 4 = 2 J.',
      'Kinetic arithmetic'
    ],
    [
      'If that cart’s speed doubles to 4 m/s, what happens to its KE?',
      'It quadruples to 8 J',
      'It doubles to 4 J',
      'It stays at 2 J',
      'It halves to 1 J',
      'The speed is squared, so a factor of two in speed gives a factor of four in KE.',
      'Speed-squared relationship'
    ],
    [
      'A 1 kg load rises 1 m with model g = 10 N/kg. What gravitational energy gain follows?',
      '10 J',
      '1 J',
      '0.1 J',
      '100 J',
      'mgh = 1 × 10 × 1 = 10 J.',
      'Gravitational energy'
    ],
    [
      'During a steady upward lift, what sign does the downward weight’s work have?',
      'Negative, because it opposes the displacement',
      'Positive, because every force does positive work',
      'Zero solely because the load is moving steadily',
      'No sign because force and energy are identical',
      'An opposing force does negative work, even when total net work is zero.',
      'Work direction'
    ],
    [
      'Why can the steady 1 kg lift have zero net work but +10 J lifting work?',
      'Gravity does −10 J, canceling lifting work in the net sum',
      'The lifting force does no work despite upward displacement',
      'Zero net work proves gravitational energy cannot change',
      'Net work must always equal the lifting force’s work alone',
      'Work by one force differs from the sum over all forces.',
      'Net versus individual work'
    ],
    [
      'What power transfers 60 J in 3 s?',
      '20 W',
      '180 W',
      '0.05 W',
      '63 W',
      'Average power = energy ÷ time = 60 ÷ 3 = 20 J/s.',
      'Power arithmetic'
    ],
    [
      'A steady lift raises 2 kg by 1.5 m with g = 10 N/kg. What lifting work follows without other resistance?',
      '30 J',
      '20 J',
      '15 J',
      '3 J',
      'Weight is 20 N and work is 20 × 1.5 = 30 J.',
      'Lifting calculation'
    ],
    [
      'That lift transfers 30 J in 3 s. What average lifting power follows?',
      '10 W',
      '90 W',
      '0.1 W',
      '30 W',
      'Average lifting power divides the 30 J transfer by 3 s: 10 J/s, or 10 W.',
      'Lifting power'
    ],
    [
      'An upward support force acts while a bag moves purely horizontally at constant height. What work does that force do in the ideal model?',
      'Zero, because force is perpendicular to displacement',
      'Positive work equal to upward force times horizontal distance',
      'Negative work because the bag has weight',
      'Work equal to bag mass with no distance factor',
      'Only the force component along displacement contributes; the upward force is perpendicular here.',
      'Perpendicular work'
    ],
    [
      'A cart stops through friction. Which energy account is appropriate?',
      'Some motion energy transfers to thermal energy of cart and surroundings',
      'Kinetic energy is destroyed and has no later location',
      'Friction creates all the original energy from nothing',
      'All energy remains in the cart’s translational motion after it stops',
      'Friction spreads energy into heating; include surroundings in the account.',
      'Thermal transfer'
    ],
    [
      'Two lifts raise the same mass through the same vertical height but use different routes. What gravitational comparison follows?',
      'The gravitational energy gain is equal for the same reference and g',
      'The longer route always has greater gravitational energy gain',
      'Only horizontal route distance determines mgh',
      'The steeper route removes the need for energy transfer',
      'Gravitational change depends on vertical height; other route losses can still differ.',
      'Height and route'
    ],
    [
      'Two devices transfer 60 J, one in 6 s and one in 3 s. Which comparison is correct?',
      'The second has twice the average power but equal transferred energy',
      'The second transfers twice the total energy by definition',
      'Both have equal power because total energy matches',
      'The first has twice the power because it runs longer',
      'Rates are 10 W and 20 W, while each transfers 60 J.',
      'Amount versus rate'
    ],
    [
      'A 1 kg object moves at 4 m/s. If its mass doubles at the same speed, what KE follows?',
      '16 J',
      '8 J',
      '32 J',
      '4 J',
      'KE = ½ × 2 × 4² = 16 J; at fixed speed doubling mass doubles KE.',
      'Mastery: mass and motion'
    ],
    [
      'A steady lift increases height but not speed. Which pair of changes fits the ideal model?',
      'Gravitational energy increases; kinetic energy remains unchanged',
      'Both gravitational and kinetic energy must increase equally',
      'Neither energy can change because forces balance',
      'Kinetic energy increases while gravitational energy vanishes',
      'Constant speed fixes KE, while increased height raises gravitational potential energy.',
      'Mastery: stores'
    ],
    [
      'Why can mechanical energy decrease in a real falling-object system without violating conservation?',
      'Energy can transfer to thermal stores and surroundings through resistance',
      'Energy conservation applies only while speed is zero',
      'Mechanical energy and total energy must always be identical quantities',
      'Gravitational energy must be created at every instant',
      'The broader energy account includes non-mechanical transfers such as heating.',
      'Mastery: conservation'
    ],
  ],
);
