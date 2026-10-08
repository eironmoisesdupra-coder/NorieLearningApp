import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

final List<NorieTopicContent> grade6ScienceTopics = [
  _organismsClassification,
  _mixturesSolutions,
  _electricity,
  _plateTectonics,
  _solarSystem,
];

const Map<String, ScienceFigure> grade6ScienceFigures = {
  'sci-g6-5-orbits': ScienceFigure(
    picture: 'g6-solar',
    title: 'Eight planets orbit one star',
    kind: 'comparison',
    labels: ['Inner planets', 'Main asteroid belt', 'Outer planets'],
    details: [
      'Mercury, Venus, Earth and Mars are rocky planets, in increasing average distance from the Sun.',
      'Many small rocky objects orbit between Mars and Jupiter; the dwarf planet Ceres also lies in this region.',
      'Jupiter and Saturn are gas giants; Uranus and Neptune are ice giants, farther outward in that order.',
    ],
    note:
        'Orbit order only. Sizes, distances, shapes and positions are simplified, not to scale or a view of a particular date. Asteroids also occur outside the main belt.',
  ),
  'sci-g6-5-distances': ScienceFigure(
    title: 'Approximate average distances from the Sun',
    kind: 'bars',
    labels: ['Earth', 'Mars', 'Jupiter', 'Neptune'],
    details: ['1.0 AU.', '1.5 AU.', '5.2 AU.', '30.1 AU.'],
    values: [1.0, 1.5, 5.2, 30.1],
    unit: 'AU from Sun',
    note:
        '1 AU is about 150 million km, close to Earth’s average Sun distance. These are Sun distances, not current distances from Earth; planetary separation varies as planets move.',
  ),
  'sci-g6-5-categories': ScienceFigure(
    title: 'Different kinds of Solar System objects',
    kind: 'comparison',
    labels: [
      'Sun: star',
      'Earth: planet',
      'Pluto: dwarf planet',
      'Moon: natural satellite'
    ],
    details: [
      'Produces energy by nuclear fusion and emits its own light.',
      'Orbits the Sun, is nearly round, and gravitationally dominates its orbital neighborhood.',
      'Orbits the Sun and is nearly round, but has not cleared its orbital neighborhood; is not a satellite.',
      'Orbits Earth while the Earth–Moon system also travels around the Sun.',
    ],
    note:
        'Cleared does not mean an orbit contains absolutely no other objects. Being nearly round alone does not establish that a body is a planet.',
  ),
  'sci-g6-4-boundaries': ScienceFigure(
    picture: 'g6-plates',
    title: 'Relative motion defines three boundary types',
    kind: 'comparison',
    labels: ['Divergent: apart', 'Convergent: together', 'Transform: past'],
    details: [
      'At an ocean ridge, new crust forms as molten rock rises and cools in the spreading region.',
      'This oceanic–continental example shows one plate descending beneath another; continental collision has a different form.',
      'In the plan view, plates move in opposite directions along a shared boundary; this motion does not directly create new crust.',
    ],
    note:
        'Simplified models, not scale. Cross-sections are used for the first two; transform is viewed from above. The mantle is mostly solid rock that deforms slowly, not an ocean of liquid magma.',
  ),
  'sci-g6-4-layers': ScienceFigure(
    title: 'A tectonic plate is more than a continent',
    kind: 'comparison',
    labels: [
      'Crust',
      'Rigid uppermost mantle',
      'Lithosphere',
      'Deforming mantle beneath'
    ],
    details: [
      'The thin outer rocky layer may be oceanic or continental.',
      'A rigid mantle portion lies directly below the crust.',
      'Crust plus rigid uppermost mantle make the moving plate layer.',
      'Mostly solid material can deform over long geological time, allowing motion of the plates above.',
    ],
    note:
        'A plate can include both land and seafloor. Local melt exists, but the mantle as a whole is not liquid.',
  ),
  'sci-g6-4-ages': ScienceFigure(
    title: 'Example rock ages on opposite sides of a ridge',
    kind: 'bars',
    labels: ['West far', 'West near', 'East near', 'East far'],
    details: [
      '8 million years.',
      '2 million years.',
      '2 million years.',
      '8 million years.'
    ],
    values: [8, 2, 2, 8],
    unit: 'million years',
    note:
        'Near sites are equally close to the ridge; far sites are equally farther away. Youngest crust occurs at the ridge itself. This idealized pattern supports spreading, not an earthquake date.',
  ),
  'sci-g6-3-loop': ScienceFigure(
    picture: 'g6-circuit',
    title: 'A lamp needs a complete conducting loop through its source',
    kind: 'comparison',
    labels: ['Closed switch', 'Open switch', 'Cell and lamp'],
    details: [
      'A continuous path connects both cell terminals through the lamp; current can flow.',
      'A gap breaks the only path; sustained current stops throughout this simple loop.',
      'The cell supplies energy; the lamp transfers energy to light and heating without using up charge.',
    ],
    note:
        'Schematic model, not a wiring instruction. Only a teacher-approved low-voltage AA-cell kit may be demonstrated. Never use wall outlets or connect cell terminals directly.',
  ),
  'sci-g6-3-paths': ScienceFigure(
    picture: 'g6-branches',
    title: 'One shared path versus two separate lamp branches',
    kind: 'comparison',
    labels: ['Series', 'Parallel'],
    details: [
      'Two lamps lie along one path. An open break anywhere in it interrupts both lamps.',
      'Each lamp lies on a separate path between the same two junctions. Opening one lamp branch leaves the other complete.',
    ],
    note:
        'Ideal diagrams with a working source and intact common wires. Breaking a common wire can stop both parallel branches. Brightness depends on source and component ratings.',
  ),
  'sci-g6-3-current': ScienceFigure(
    title: 'Example steady currents at a parallel junction',
    kind: 'bars',
    labels: ['Before junction', 'Branch A', 'Branch B', 'After rejoining'],
    details: ['0.30 A total.', '0.10 A in A.', '0.20 A in B.', '0.30 A total.'],
    values: [0.30, 0.10, 0.20, 0.30],
    unit: 'A',
    note:
        '0.10 + 0.20 = 0.30 A. Charge is conserved; different branch currents do not mean charge disappears in a lamp. These are supplied readings, not instructions to connect a meter.',
  ),
  'sci-g6-2-uniform': ScienceFigure(
    title: 'Uniform dissolved material versus a settling solid',
    kind: 'comparison',
    labels: ['Salt solution', 'Sand in water', 'Oil and water'],
    details: [
      'Dissolved salt is distributed throughout the water; an ordinary filter does not retain it.',
      'Visible grains may settle and can be retained by a suitable filter.',
      'Two liquid layers form after the mixture is left undisturbed.',
    ],
    note:
        'Uniform appearance does not establish purity or drinking safety. These are known-material models, not instructions to test unknown samples.',
  ),
  'sci-g6-2-amounts': ScienceFigure(
    title: 'Solute mass in equal final solution volumes',
    kind: 'bars',
    labels: ['Solution A: 100 mL', 'Solution B: 100 mL'],
    details: ['4 g dissolved sugar.', '8 g dissolved sugar.'],
    values: [4, 8],
    unit: 'g sugar',
    note:
        'B has twice the sugar per 100 mL of solution. Final solution volume is measured; it is not assumed equal to starting water volume.',
  ),
  'sci-g6-2-separation': ScienceFigure(
    title: 'Separate a known salt–sand–water mixture by its properties',
    kind: 'process',
    labels: ['Stir', 'Filter', 'Choose a recovery method'],
    details: [
      'Salt dissolves in water; sand does not under these conditions.',
      'Sand stays as residue; salt solution passes as filtrate.',
      'Evaporation can leave salt; distillation also collects water after its vapor condenses.',
    ],
    note:
        'Teacher diagram or prepared demonstration only. Learners do not heat mixtures. Distillation changes water liquid → vapor → liquid without carrying dissolved salt into the collected vapor.',
  ),
  'sci-g6-1-groups': ScienceFigure(
    title: 'Several traits together give stronger classification evidence',
    kind: 'comparison',
    labels: ['Plants', 'Animals', 'Fungi', 'Bacteria and Archaea'],
    details: [
      'Multicellular organisms; many cells make food by photosynthesis; cell walls are present.',
      'Multicellular organisms that eat other organisms or their products; cells lack cell walls.',
      'Absorb nutrients from their surroundings; cell walls are present; yeasts are single-celled fungi.',
      'Two distinct domains of organisms whose cells lack a nucleus; appearance alone cannot reliably distinguish them.',
    ],
    note:
        'This introductory comparison is not a complete list of living groups. Eukarya also includes diverse organisms often studied as protists.',
  ),
  'sci-g6-1-key': ScienceFigure(
    picture: 'g6-key',
    title: 'A two-choice key for four example animals',
    kind: 'comparison',
    labels: ['1: Backbone?', '2: Feathers?', '3: Six jointed legs?'],
    details: [
      'Yes: go to 2. No: go to 3.',
      'Yes: pigeon. No: frog. This step is reached only after choosing backbone present.',
      'Yes: ant. No: earthworm. This step is reached only after choosing backbone absent.',
    ],
    note:
        'Use only for this set: pigeon, frog, ant and earthworm. An unfamiliar animal may need a different key. Count legs from a clear photograph rather than handling animals.',
  ),
  'sci-g6-1-hierarchy': ScienceFigure(
    title: 'Nested groups: the domestic cat',
    kind: 'process',
    labels: [
      'Domain: Eukarya',
      'Kingdom: Animalia',
      'Family: Felidae',
      'Genus and species: Felis catus'
    ],
    details: [
      'A broad group containing organisms whose cells have nuclei.',
      'Within Eukarya: animals, including many very different body forms.',
      'Within the animal grouping: the cat family, including lions and domestic cats.',
      'A much narrower name identifying the domestic-cat species.',
    ],
    note:
        'Selected levels only: phylum, class and order occur between kingdom and family. The scientific name uses genus first and species second.',
  ),
};

final _organismsClassification = scienceTopic(
  grade: 'g6',
  order: 1,
  title: 'Organisms & Classification',
  subtitle:
      'Use cell and body evidence to group living things and follow a key',
  minutes: 'About 40–45 minutes',
  objectives: [
    'Classify familiar organisms using several observable or supplied traits.',
    'Compare plants, animals, fungi and the three-domain introductory model.',
    'Follow and evaluate a two-choice identification key for a stated set.',
    'Explain how nested groups and two-part scientific names improve communication.',
  ],
  introduction:
      'A mushroom grows beside a young plant, while an ant walks past both. They share a damp place, but should they share the same biological group? A useful classification depends on evidence about organisms, not just where we find them.',
  prerequisiteTopicId: null,
  sections: [
    scienceSection('Grouping with a purpose',
        '''An organism is an individual living thing. Classification is the organization of organisms into groups using shared features and evidence of relationships. Sorting school objects by color is useful for finding crayons. Biological classification has a different purpose: it helps scientists compare living things, identify them and communicate what they have learned.

A habitat is a place where an organism lives. A pond may contain fish, plants, fungi and microscopic organisms. Sharing that habitat does not make them one biological group. Size and color can be clues, but either may change with age or conditions. Stronger classification combines traits, such as cell structure, how nutrients are obtained and body structures, rather than relying on one convenient resemblance.'''),
    scienceSection('Cells divide the broad groups',
        '''In the introductory three-domain model, living organisms belong to Bacteria, Archaea or Eukarya. A domain is a very broad classification level. Bacteria and Archaea are distinct groups of organisms whose cells have no nucleus. Their genetic material is present, but it is not enclosed in a nucleus. Scientists distinguish these groups with evidence including molecules and genetic information; two similar-looking cells cannot be confidently assigned just from shape.

Eukarya contains organisms whose cells have nuclei, including animals, plants and fungi. It also includes diverse organisms often studied as protists. Some eukaryotes consist of one cell; others contain many cooperating cells. Therefore, being microscopic or single-celled does not by itself mean an organism is a bacterium. Some archaea live in extreme environments, but many live in ordinary soil, oceans and other habitats.'''),
    scienceSection('Plants, animals and fungi',
        '''Plants are multicellular organisms with cell walls. Many plant cells use light to make food through photosynthesis. Animals are multicellular organisms whose cells lack cell walls; they obtain food by eating other organisms or their products. Movement is not a reliable single test. An adult sponge stays attached in one place but is an animal, while a plant can change the position of its leaves.

Fungi have cell walls and absorb nutrients from their surroundings. They do not make food by photosynthesis. Mushrooms and many molds are multicellular fungi, but yeasts are single-celled fungi. A mushroom is therefore not a plant simply because it grows from soil and remains in place. These descriptions give useful broad evidence; a complete classification requires more than a photograph of one visible part.'''),
    scienceVisual('sci-g6-1-groups',
        'Compare cell structure and food acquisition, rather than just appearance.'),
    scienceSection('Backbones and body traits',
        '''Within animals, vertebrates have a backbone; invertebrates lack one. Fish, amphibians, reptiles, birds and mammals are vertebrate groups. Feathers identify birds among these groups. Mammals have hair at some stage of life and feed young with milk. These traits are more helpful than simply asking whether an animal flies: bats are mammals and many insects fly.

An insect is an invertebrate with six jointed legs and three main body regions in its adult form. A spider has eight legs and is not an insect. An earthworm has no jointed legs. Count and examine structures from clear pictures or supplied observations. A hidden leg in a photograph is missing evidence, not proof that the animal has fewer legs.'''),
    scienceSection('Nested groups and names',
        '''Classification groups fit inside broader groups. Common ranks run from domain to kingdom, phylum, class, order, family, genus and species. The broadest groups contain many kinds of organisms; a species is much more specific. A domestic cat and a lion share the cat family but do not belong to the same species. Sharing a broad group does not mean two organisms are identical.

A scientific species name has two parts: the genus first, then a specific epithet; together they name the species. The domestic cat is Felis catus. Genus begins with a capital letter; the second part begins with a lowercase letter. In printed scientific writing the two words are italicized. Common names can differ between languages or refer to different organisms, so a shared scientific name reduces confusion. Classification can be revised when new evidence changes our understanding of relationships.'''),
    scienceVisual('sci-g6-1-hierarchy',
        'Read the groups as nested levels, with several middle ranks omitted.'),
    scienceSection('Worked example: follow a key',
        '''A dichotomous key offers two alternatives at each step. Our key identifies only pigeon, frog, ant and earthworm. Step 1 asks whether a backbone is present. Yes leads to step 2; no leads to step 3. Step 2 asks whether feathers are present: yes gives pigeon and no gives frog. Step 3 asks whether six jointed legs are present: yes gives ant and no gives earthworm.

To identify the ant, start at step 1 rather than guessing from its name. It has no backbone, so follow step 3. Its six jointed legs match the yes choice, giving ant. The answer depends on the stated collection. A snail would also lack a backbone and six legs, but this key cannot legitimately identify it as an earthworm because snail is outside the set.'''),
    scienceVisual('sci-g6-1-key',
        'Every route starts at step 1 and uses evidence appropriate to the specified animals.'),
    scienceSection('Guided example: improve a weak group',
        'A learner places a bat, pigeon and butterfly in one group called birds because all can fly. Use one distinguishing trait for each organism. Then explain whether a flight-based group can still be useful for a different purpose.'),
    scienceSection('Reveal: purpose changes the group',
        '''The pigeon has feathers and belongs to birds. The bat has hair and is a mammal. The adult butterfly has six jointed legs and is an insect. Flight groups them by one activity, which could be useful when studying movement. It does not establish that all three are birds or that they are equally closely related. The conclusion must match the evidence and the purpose.''',
        reveal: true),
    scienceSection('Safe observation and uncertain evidence',
        '''Choose teacher-provided pictures of four familiar animals. Record observable features in a table before writing a key. Use two alternatives that do not overlap, such as feathers present or feathers absent, and check that every pictured animal reaches its own endpoint. Ask a partner to follow the key without knowing your intended answers. Do not capture wild animals, touch unknown fungi or culture microbes.

If a photograph hides a needed structure, write uncertain and request a clearer view. A responsible conclusion states what the evidence supports and what remains unknown. DNA comparisons can reveal relationships that appearance alone misses, so an identification key is a practical tool for a set rather than a complete history of life.'''),
    scienceSection('Common mistakes',
        'Growing in soil does not make a fungus a plant. Single-celled does not mean bacterial, and archaea are not restricted to extreme places. Flying does not make an animal a bird. A key cannot identify every organism if it was designed for only four. Groups within groups are nested, not separate boxes with no shared members.'),
    scienceSection('Quick check',
        'A single-celled yeast has a nucleus and absorbs nutrients. Which domain and familiar group fit? An unfamiliar snail reaches the earthworm endpoint of our four-animal key. Should that endpoint be accepted?'),
    scienceSection('Check your thinking',
        'Yeast belongs to Eukarya and is a fungus. The snail is outside the stated set, so the endpoint is not a valid identification. Use an appropriate key and further evidence.',
        reveal: true),
    scienceSection('Recap',
        'Group organisms using several meaningful traits. Distinguish broad cell evidence, narrower body traits and a precise species name. Follow identification keys step by step within their stated scope, and revise conclusions when better evidence becomes available.'),
  ],
  keyConcept:
      'Biological classification combines evidence into nested groups; identification keys use selected traits to identify organisms within a stated set.',
  questions: [
    [
      'A pond contains fish and algae. Why is the pond alone insufficient to place them in one biological group?',
      'Habitat does not establish shared cell and body traits',
      'Habitat establishes that both are vertebrates',
      'Habitat establishes that both obtain food by eating',
      'Habitat identifies their exact species',
      'Different biological groups can share a habitat; compare traits and relationships.',
      'Classification evidence'
    ],
    [
      'A supplied cell description says its genetic material is enclosed in a nucleus. Which domain fits?',
      'Eukarya',
      'Bacteria',
      'Archaea',
      'Either Bacteria or Archaea only',
      'A nucleus supports Eukarya in the introductory model.',
      'Domains'
    ],
    [
      'Which observation distinguishes a bird from a flying mammal?',
      'Feathers',
      'Ability to travel through air',
      'Presence of a backbone',
      'Need for food',
      'Feathers identify birds; both birds and mammals are vertebrates and use food.',
      'Animal traits'
    ],
    [
      'A mushroom absorbs nutrients and has cell walls but does not photosynthesize. Which group fits?',
      'Fungi',
      'Plants',
      'Animals',
      'Bacteria',
      'Fungi absorb nutrients and have cell walls; mushrooms are multicellular fungi.',
      'Fungi'
    ],
    [
      'A frog is a vertebrate. Which supplied trait directly supports that grouping?',
      'A backbone',
      'A damp habitat',
      'A green body color',
      'A diet of insects',
      'Vertebrate classification depends on a backbone, not color, location or diet.',
      'Vertebrates'
    ],
    [
      'An adult ant has six jointed legs. Which familiar animal group does that support?',
      'Insects',
      'Spiders',
      'Mammals',
      'Earthworms',
      'Adult insects have six jointed legs; spiders have eight.',
      'Insect traits'
    ],
    [
      'Which option gives the complete correctly ordered domestic-cat species name?',
      'Felis catus',
      'catus Felis',
      'Felis',
      'catus',
      'The complete species name needs both parts: genus Felis first, then the specific epithet catus.',
      'Scientific names'
    ],
    [
      'A yeast cell has a nucleus. Which claim correctly combines its size and group?',
      'A single-celled organism can belong to Eukarya',
      'All single-celled organisms belong to Bacteria',
      'All fungi must contain many cells',
      'A nucleus identifies it as an animal',
      'Yeasts are single-celled fungi within Eukarya; a nucleus alone does not identify animals.',
      'Cell diversity'
    ],
    [
      'Two microorganisms look alike and lack nuclei. What can be concluded from those observations alone?',
      'They cannot reliably be distinguished as Bacteria or Archaea',
      'They must both belong to Bacteria',
      'They must both belong to Archaea',
      'They must both belong to Eukarya',
      'Bacteria and Archaea both lack nuclei; molecular evidence helps distinguish them.',
      'Evidence limits'
    ],
    [
      'A key for pigeon, frog, ant and earthworm first separates animals with a backbone, then separates those with feathers. An organism has a backbone and feathers. Which endpoint follows?',
      'Pigeon',
      'Frog',
      'Ant',
      'Earthworm',
      'Backbone present leads to step 2; feathers present leads to pigeon.',
      'Using a key'
    ],
    [
      'Key for pigeon, frog, ant and earthworm: 1: backbone present? Yes → 2; no → 3. 2: feathers present? Yes → pigeon; no → frog. 3: six jointed legs present? Yes → ant; no → earthworm. An organism has no backbone and six jointed legs. Which route is correct?',
      'Step 1 no, then step 3 yes: ant',
      'Step 1 yes, then step 2 yes: pigeon',
      'Step 1 yes, then step 2 no: frog',
      'Step 1 no, then step 3 no: earthworm',
      'Follow no at the backbone question and yes at the six-leg question.',
      'Using a key'
    ],
    [
      'A lion and domestic cat share Felidae but have different species names. What does this show?',
      'One family can contain multiple species',
      'One species must contain multiple families',
      'A family and species are the same rank',
      'Sharing a family means identical organisms',
      'Family is broader than species; shared family membership does not make organisms identical.',
      'Nested groups'
    ],
    [
      'Which evidence is strongest for distinguishing a plant from a mushroom in this lesson?',
      'How it obtains food, together with cell evidence',
      'Both remain in one place',
      'Both occur in soil',
      'Both can be similar in height',
      'Food acquisition distinguishes photosynthetic plants from nutrient-absorbing fungi better than place or size.',
      'Comparing groups'
    ],
    [
      'Which statement about Archaea avoids an inaccurate restriction?',
      'Some occupy extreme environments and many occupy ordinary habitats',
      'They live only in very hot springs',
      'They live only in salty water',
      'They live only inside animals',
      'Archaea have diverse habitats, including ordinary soil and oceans.',
      'Archaea'
    ],
    [
      'An identification key is designed only for pigeon, frog, ant and earthworm. A learner follows its choices and identifies a snail as an earthworm. What is the best correction?',
      'The snail is outside the stated set, so use an appropriate key',
      'Remove the backbone question to guarantee accuracy',
      'Treat every legless invertebrate as an earthworm',
      'Accept the answer because both share a habitat',
      'A key endpoint is valid only within the collection for which the key was designed.',
      'Key limits'
    ],
    [
      'A photo shows only five visible legs of a partly hidden ant. What should a learner do?',
      'Seek a clear view before deciding its total leg count',
      'Classify it as a new five-legged group immediately',
      'Count the hidden side as having no legs',
      'Use body color to replace all structural evidence',
      'A hidden part creates uncertainty; it is not evidence of absence.',
      'Observation limits'
    ],
    [
      'Which pair of alternatives would make a clearer first step in a picture key?',
      'Feathers present / feathers absent',
      'Small / fairly small',
      'Lives nearby / lives outdoors',
      'Can move / moves sometimes',
      'Present and absent are nonoverlapping alternatives for a clear visible feature.',
      'Designing a key'
    ],
    [
      'A sponge stays attached to a rock. Why should it not be classified as a plant solely for that reason?',
      'Movement alone does not reliably distinguish animals and plants',
      'All animals must move from place to place as adults',
      'Attachment proves photosynthesis takes place',
      'A rock habitat proves plant cell walls are present',
      'Some animals remain attached; use cell and food evidence together.',
      'Multiple traits'
    ],
    [
      'Two communities use different common names for one organism. What helps compare their records?',
      'Use the same correctly identified scientific species name',
      'Group records only by the length of each common name',
      'Replace all names with the organism color',
      'Assume different common names always mean different species',
      'A shared two-part scientific name reduces confusion across languages.',
      'Scientific communication'
    ],
    [
      'New DNA evidence conflicts with an older grouping based on appearance. What scientific response fits?',
      'Review and revise the classification if the new evidence supports it',
      'Keep the old grouping because appearance is the only evidence',
      'Discard the DNA evidence without examining it',
      'Assign a different domain solely from habitat',
      'Classification can change when stronger relationship evidence is evaluated.',
      'Revising models'
    ],
    [
      'A pictured animal has hair, feeds young with milk and can fly. Which conclusion uses the relevant evidence?',
      'It is a mammal; flying does not make it a bird',
      'It is a bird because every flying vertebrate is a bird',
      'It is an insect because all flying animals have six legs',
      'It is a reptile because hair is a reptile trait',
      'Hair and milk support mammals; flight is shared by several groups.',
      'Mastery: traits'
    ],
    [
      'An unknown cell lacks a nucleus. A student calls it Archaea because it was found in soil. Which improvement is needed?',
      'Gather molecular evidence to distinguish Archaea from Bacteria',
      'Treat soil as proof of Archaea',
      'Treat lack of nucleus as proof of Eukarya',
      'Use cell size alone to identify its species',
      'Both domains can occur in soil and lack nuclei, so those facts do not distinguish them.',
      'Mastery: evidence'
    ],
    [
      'A key for pigeon, frog, ant and earthworm is tested on all four and gives distinct endpoints. What has this test established?',
      'It distinguishes this supplied set using the selected traits',
      'It identifies every animal on Earth',
      'It proves all four belong to the same family',
      'It replaces all evidence of evolutionary relationships',
      'Testing confirms usefulness for the stated set, not unlimited scope or full biological relationships.',
      'Mastery: key scope'
    ],
  ],
);

final _mixturesSolutions = scienceTopic(
  grade: 'g6',
  order: 2,
  title: 'Mixtures & Solutions',
  subtitle:
      'Explain dissolving, compare concentration and choose separation methods',
  minutes: 'About 40–45 minutes',
  objectives: [
    'Distinguish uniform solutions from mixtures with visible particles or layers.',
    'Identify solute and solvent and explain why dissolved material remains present.',
    'Compare concentration and distinguish dissolving rate from solubility.',
    'Use material properties to justify a separation sequence and a fair comparison.',
  ],
  introduction:
      'Two clear cups may look alike even when one contains dissolved sugar and the other contains only water. If the sugar is no longer visible, where did it go? Looking beyond appearance helps us explain mixtures and choose useful measurements.',
  prerequisiteTopicId: 'science.g6.organisms-classification',
  sections: [
    scienceSection('Mixture does not mean new substance',
        '''A mixture contains two or more substances together. Mixing does not require them to become one new substance. Sand and water, air, and salt solution are mixtures. Their components retain properties that may help separate them. A pure substance has a fixed chemical composition; a solution can contain different amounts of dissolved material and is not pure merely because it looks uniform.

A heterogeneous mixture has a composition that varies from place to place. Sand in water has solid grains and liquid regions. Oil and water can form separate layers. A homogeneous mixture is uniform throughout at the scale of its small components. A solution is a homogeneous mixture. Dissolved salt is distributed through water, so properly mixed equal-size samples have the same concentration.'''),
    scienceSection('Solute, solvent and the particle idea',
        '''The solute is the substance dissolved in a solution. The solvent is the substance doing the dissolving, often the component present in the larger amount. In a sugar solution, sugar is the solute and water is the solvent. Water is a useful solvent for many substances, but not for everything: sand does not dissolve appreciably, and oil does not form a uniform solution with water in this example.

During dissolving, solute particles spread among solvent particles. The dissolved material has not vanished or necessarily changed into a liquid. Salt in water separates into tiny charged particles; sugar spreads as molecules. We do not see those individual particles with our eyes. An ordinary classroom filter has openings that allow dissolved material and water through, even though it can retain visible sand grains.'''),
    scienceVisual('sci-g6-2-uniform',
        'Uniformity, visible particles and layers are different kinds of evidence.'),
    scienceSection('Concentration compares amount with volume',
        '''Concentration describes how much solute is present in a stated amount of solution. A comparison must include the amount of solvent or solution, not only the solute. We will use grams of solute per 100 milliliters of final solution. If A contains 4 g of sugar in 100 mL of solution and B contains 8 g in 100 mL, B has twice A's concentration.

If 8 g is instead dissolved to make 200 mL of solution, each 100 mL contains 4 g. This matches A, despite having more sugar in the whole container. Adding water to a solution without adding solute dilutes it: the same solute is spread through more solution. Starting water volume and final solution volume need not be identical, so always read which quantity the data states.'''),
    scienceVisual('sci-g6-2-amounts',
        'Equal final volumes make the solute-mass comparison meaningful.'),
    scienceSection('Worked example: compare two recipes',
        '''Solution P contains 6 g of sugar in 150 mL of final solution. Solution Q contains 4 g in 100 mL. Step 1: choose a common volume, 100 mL. Step 2: for P, divide 6 by 150 to get 0.04 g per mL. Multiply by 100: 4 g per 100 mL. Step 3: Q already has 4 g per 100 mL. Step 4: conclude that their concentrations are equal, assuming complete dissolving and uniform mixing.

P contains more total sugar and more solution. Neither fact alone proves greater concentration. Units explain the comparison: grams measure solute mass, while milliliters measure solution volume. A statement such as 6 is more concentrated than 4 omits essential information.'''),
    scienceSection('Rate is different from the dissolving limit',
        '''Dissolving rate describes how quickly a solute dissolves. Stirring brings fresh solvent into contact with the solute. Smaller pieces expose more surface area. These changes often make a known solid dissolve sooner; they do not by themselves increase the maximum amount that can dissolve in a fixed solvent amount at a fixed temperature.

Solubility describes that maximum under stated conditions. A saturated solution has reached its dissolving limit for that solute at those conditions. Excess solid can remain undissolved. Suppose an example substance has a measured limit of 12 g in 100 mL of water at room temperature. Adding 16 g leaves 4 g undissolved after sufficient mixing. Temperature can affect solubility; many solids become more soluble in warmer water, but this is not a rule for every substance. Heating often reduces the solubility of gases in water.'''),
    scienceSection('Guided example: check the conditions',
        'The example dissolving limit is 12 g per 100 mL of water at room temperature. A learner adds 20 g to 200 mL of water at that same temperature. What limit does the model predict for this water amount? Should excess solid remain after enough mixing? Would stirring twice as fast justify doubling the limit?'),
    scienceSection('Reveal: amount and rate answer different questions',
        'Twice as much water gives an example limit of 24 g at the same temperature. The added 20 g is below this limit, so it can all dissolve in this model. Faster stirring can shorten the time, but it does not justify changing the 24 g limit. These numbers describe the stated example substance, not every solute.',
        reveal: true),
    scienceSection('Choose separation from properties',
        '''A suitable filter separates an undissolved solid from liquid. The retained material is the residue; the liquid passing through is the filtrate. Filtering a known sand–salt–water mixture retains sand but leaves salt dissolved in the filtrate. Repeating ordinary filtration does not remove that salt.

Evaporation can remove water and leave dissolved salt behind. To recover water as well, distillation evaporates water and then cools its vapor so it condenses into a collection container. These methods use differences in behavior, not disappearance of matter. This is an explanation using a diagram or a teacher-prepared demonstration, not a learner heating activity. Separation alone also does not certify that an unknown sample is safe to drink.'''),
    scienceVisual('sci-g6-2-separation',
        'The filtrate still contains dissolved salt; the final method depends on which component is wanted.'),
    scienceSection('Safe fair comparison',
        '''With teacher guidance, compare small equal masses of known sugar in equal amounts of room-temperature water in two clear, unbreakable cups. Stir one at an agreed steady pace and leave the other still. Keep sugar grain size, water temperature, container and observation method the same. Record the time until visible grains disappear, without tasting. Change only stirring to investigate rate.

A faster disappearance supports a rate difference under these conditions. It does not measure the maximum solubility, because you have not repeatedly tested increasing amounts until excess remains. Never use unknown substances or mix household cleaners. A provided observation table can replace the activity.'''),
    scienceSection('Common mistakes',
        'Clear does not mean pure or safe. Dissolved sugar remains present. Ordinary filtering does not remove dissolved salt. More total solute does not always mean greater concentration. Stirring rate and maximum solubility are different quantities. A temperature claim must specify the substance and conditions rather than saying all solutes behave alike.'),
    scienceSection('Quick check',
        'A solution has 10 g of dissolved sugar in 200 mL of final solution. How many grams per 100 mL is that? Which method retains sand? Which extra step collects water from the salt solution?'),
    scienceSection('Check your thinking',
        'The concentration is 5 g per 100 mL. A suitable filter retains sand. Distillation collects water by evaporation followed by condensation; ordinary filtration leaves dissolved salt in the liquid.',
        reveal: true),
    scienceSection('Recap',
        'Describe the components and their distribution, compare amounts with units, and separate mixtures using their properties. Keep the speed of dissolving distinct from its limit. Evidence from a fair rate test cannot answer every question about a solution.'),
  ],
  keyConcept:
      'A solution is a uniform mixture of solute and solvent. Concentration, dissolving rate and solubility describe different properties and require different evidence.',
  questions: [
    [
      'In a known sugar–water solution, which substance is the solute?',
      'Sugar',
      'Water',
      'The whole solution',
      'Neither substance',
      'Sugar is dissolved; water is the solvent and the combination is the solution.',
      'Solute and solvent'
    ],
    [
      'A cup contains visible sand grains and water regions. Which description fits?',
      'A heterogeneous mixture',
      'A homogeneous salt solution',
      'A pure liquid substance',
      'A single dissolved solute',
      'The composition varies between solid grains and liquid regions.',
      'Mixture types'
    ],
    [
      'Which description fits properly mixed dissolved salt in water?',
      'A homogeneous mixture',
      'A pure substance because it is clear',
      'A heterogeneous mixture with settled salt grains',
      'A substance with no solute present',
      'A salt solution is uniform but contains salt and water, so it is a mixture.',
      'Solutions'
    ],
    [
      'Sugar grains disappear during dissolving. What happens to the sugar?',
      'Its particles spread among water particles',
      'Its matter is removed from the container',
      'It all changes into water particles',
      'It becomes visible filter residue',
      'Dissolving distributes sugar particles; it does not make matter vanish.',
      'Particle model'
    ],
    [
      'What does solubility describe for a stated solvent amount and temperature?',
      'The maximum solute amount that can dissolve',
      'The time until the first grain disappears',
      'The stirring speed used in a test',
      'The volume of the empty container',
      'Solubility is a limit under stated conditions; rate concerns time.',
      'Solubility'
    ],
    [
      'Which change investigates dissolving rate while keeping water temperature unchanged?',
      'Stir one cup and leave an otherwise matching cup still',
      'Compare different solutes in different water volumes',
      'Compare hot water with cold water while changing grain size',
      'Measure only the empty cup mass',
      'Changing stirring alone gives a clearer rate comparison.',
      'Fair rate test'
    ],
    [
      'In filtration of sand and salt solution, what is the sand caught by the filter called?',
      'Residue',
      'Filtrate',
      'Solvent',
      'Dissolved solute',
      'Residue is retained; filtrate is the liquid passing through.',
      'Filtration'
    ],
    [
      'A has 4 g sugar in 100 mL final solution; B has 8 g in 100 mL. How do concentrations compare?',
      'B is twice as concentrated as A',
      'A is twice as concentrated as B',
      'They are equal because volumes match',
      'They cannot be compared despite the supplied units',
      'At equal final volumes, twice the solute mass means twice the concentration.',
      'Concentration'
    ],
    [
      'C contains 8 g sugar in 200 mL final solution. What is its concentration per 100 mL?',
      '4 g per 100 mL',
      '8 g per 100 mL',
      '16 g per 100 mL',
      '2 g per 100 mL',
      'Half of 200 mL is 100 mL, containing half of 8 g: 4 g.',
      'Concentration calculation'
    ],
    [
      'Why does ordinary filtration fail to remove dissolved salt from water?',
      'Dissolved particles pass through the filter with water',
      'Salt solution cannot flow through any filter',
      'Filtering changes salt into sand',
      'Water particles are retained while only salt passes',
      'The ordinary filter openings retain sand but not dissolved salt particles.',
      'Dissolved particles'
    ],
    [
      'A solution is diluted with water and no solute is lost. What changes?',
      'Solute per unit solution volume decreases',
      'Total solute mass increases',
      'The solute becomes filter residue automatically',
      'Every dissolved particle is destroyed',
      'The same solute spreads through a larger amount of solution.',
      'Dilution'
    ],
    [
      'What is the key difference between evaporation and distillation here?',
      'Distillation also condenses and collects the water vapor',
      'Distillation uses an ordinary filter to capture salt particles',
      'Evaporation collects liquid water without condensation',
      'Evaporation removes sand while leaving all water',
      'Both can vaporize water; distillation collects condensed water.',
      'Separation methods'
    ],
    [
      'A solute has a dissolving limit of 12 g per 100 mL water. Adding 16 g to 100 mL water at that temperature leaves how much undissolved after equilibration?',
      '4 g',
      '12 g',
      '16 g',
      '28 g',
      'The dissolved amount can reach 12 g; 16 − 12 = 4 g remains.',
      'Saturation calculation'
    ],
    [
      'Which claim correctly describes temperature and solubility?',
      'Temperature effects depend on the solute; warming often reduces gas solubility',
      'Warming increases the solubility of every substance',
      'Warming can change rate but never any solubility',
      'Cooling always dissolves more of every solid',
      'Many solids and gases respond differently; avoid universal claims.',
      'Temperature effects'
    ],
    [
      'A test uses 6 g in 150 mL final solution and 4 g in 100 mL. Which conclusion follows?',
      'Their concentrations are equal',
      'The 6 g solution is always more concentrated',
      'The 4 g solution is always more concentrated',
      'Neither solution contains a solute',
      '6 ÷ 150 × 100 = 4 g per 100 mL, matching the second solution.',
      'Comparing recipes'
    ],
    [
      'Small sugar grains dissolve sooner than large grains in matched cups. What does this result establish?',
      'A rate difference under the tested conditions',
      'A higher maximum solubility for the small grains',
      'A conversion of small sugar grains into water',
      'A lower total sugar mass after dissolving',
      'Disappearance time measures rate; it does not establish a new solubility limit.',
      'Rate evidence'
    ],
    [
      'A learner wants sand retained, then water collected from a salt–sand–water mixture. Which sequence fits?',
      'Filter first, then distill the filtrate',
      'Distill first, then collect sand from the water vapor',
      'Filter twice and collect salt-free filtrate',
      'Stir longer and collect sand dissolved in water',
      'Filtering retains sand; distillation separates and collects water from the salt solution.',
      'Separation sequence'
    ],
    [
      'Why should a fair stirring comparison use the same sugar grain size?',
      'Grain size can also affect dissolving time',
      'Grain size determines whether water is a solvent',
      'Different grains make the cup stop being a mixture',
      'Equal grains prevent any dissolving',
      'Keeping grain size equal helps isolate stirring as the changed variable.',
      'Controlled variables'
    ],
    [
      'The example limit is 12 g per 100 mL water. Can 20 g dissolve in 200 mL at the same temperature?',
      'Yes; the model limit is 24 g for that water amount',
      'No; the limit remains 12 g regardless of water amount',
      'No; 20 g must remain entirely undissolved',
      'Yes; stirring has removed the limit entirely',
      'Doubling the water doubles the example capacity: 24 g, greater than 20 g.',
      'Scaling solubility'
    ],
    [
      'An unknown liquid is clear after filtering. What conclusion is justified?',
      'Some visible particles may be removed, but purity and safety are not established',
      'It is safe to drink because filters remove every solute',
      'It must contain only pure water',
      'It has no dissolved substances because it is clear',
      'Clear filtrate can still contain dissolved or harmful substances; do not taste unknown samples.',
      'Evidence and safety'
    ],
    [
      'A contains 10 g solute in 200 mL solution; B contains 10 g in 100 mL. Which explanation is correct?',
      'B has twice the solute per 100 mL despite equal total solute masses',
      'They have equal concentration because total solute masses match',
      'A is twice as concentrated because its volume is larger',
      'Neither concentration can be calculated from mass and volume',
      'A has 5 g per 100 mL and B has 10 g per 100 mL.',
      'Mastery: concentration'
    ],
    [
      'A saturated example solution has excess solid. Faster stirring makes no extra solid dissolve at fixed temperature. Which interpretation fits?',
      'The solution has reached its limit under these conditions',
      'The solution contains no dissolved material',
      'Stirring must always double the dissolving limit',
      'The remaining solid proves all water has evaporated',
      'Saturation limits the amount dissolved; rate changes do not by themselves raise that limit.',
      'Mastery: rate and limit'
    ],
    [
      'A diagram shows water leaving salt solution as vapor and then forming collected droplets. Which process and limitation fit?',
      'Distillation; collected-water safety is not certified for an unknown mixture',
      'Filtration; every dissolved contaminant is guaranteed removed',
      'Settling; salt and water both become sediment',
      'Dilution; water is created from salt particles',
      'Vaporization followed by condensation is distillation, but a diagram of separation does not prove drinking safety.',
      'Mastery: separation'
    ],
  ],
);

final _electricity = scienceTopic(
  grade: 'g6',
  order: 3,
  title: 'Electricity',
  subtitle:
      'Trace complete circuits and distinguish charge flow from energy transfer',
  minutes: 'About 40–45 minutes',
  objectives: [
    'Trace closed and open paths through a source, lamp and switch.',
    'Distinguish current, voltage and energy transfer using units and examples.',
    'Compare simple series and parallel circuits and predict the effect of a break.',
    'Use supplied readings and controlled changes to explain circuit evidence safely.',
  ],
  introduction:
      'A flashlight may contain a good cell and an undamaged lamp but remain dark when its switch is open. Why are the parts alone insufficient? Electricity works through a connected system, and a single gap can change the whole system.',
  prerequisiteTopicId: 'science.g6.mixtures-solutions',
  sections: [
    scienceSection('Charge is present; the source supplies energy',
        '''Electric charge is a property of particles. In metal wires, moving electrons carry charge. Electric current is the rate at which charge passes a point. Its unit is the ampere, written A. A larger current means more charge passes that point each second; it does not mean each electron becomes larger.

A cell uses stored chemical energy to drive charge through a suitable connected circuit. A battery contains one or more cells. The metal wires already contain charges before the switch closes. The source does not need to fill an empty wire with new electrons. A lamp transfers electrical energy to light and heating. Charge continues through the circuit rather than being consumed by the lamp.'''),
    scienceSection('A loop through both terminals',
        '''A simple circuit contains a source, conducting wires and a component such as a lamp. To keep current flowing, the conducting route must be complete through both terminals of the source and the lamp. A connection to only one cell terminal is not enough. A closed circuit has this complete route; an open circuit has a break.

A switch controls the connection. Closing it joins contacts; opening it separates them. In one simple loop, an open switch stops sustained current throughout the path, not just beyond the switch. A lamp also has two connections, allowing current through its working part. A circuit drawing is a model: follow the actual lines and junctions rather than assuming that nearby symbols are connected.'''),
    scienceVisual('sci-g6-3-loop',
        'Trace the complete route in the closed model and locate the gap in the open model.'),
    scienceSection('Conductors, insulators and resistance',
        '''A conductor allows charge to move relatively easily. Metals such as copper are useful wire conductors. An insulator strongly resists charge movement under ordinary conditions; plastic covering helps keep conducting wires separated and reduces accidental contact. A wire can therefore contain a metal conducting core and an insulating outer layer. The outside is not intended to carry current.

Resistance describes how strongly a component opposes current. A lamp has resistance and transfers energy as charges pass through it. A short circuit is an unintended low-resistance route that bypasses the intended component. It can produce a large current, overheating wires or the source. Never connect cell terminals directly with a wire. Household mains electricity is far more hazardous than a classroom cell kit and is never part of a learner experiment.'''),
    scienceSection('Voltage is not another name for current',
        '''Voltage, or potential difference, describes the energy transferred per unit charge between points. It is measured in volts, V. A cell marked 1.5 V has a voltage rating, not a current rating of 1.5 A. The current depends on the connected circuit as well as the source. This lesson uses supplied readings rather than calculations with resistance.

Energy transfer and charge flow answer different questions. A lamp may receive energy while the same amount of charge per second enters and leaves it in a steady circuit. The battery gradually loses stored chemical energy; this is not evidence that charges disappear at the lamp. Changing a source or adding components may change readings, so compare circuits only under clearly stated conditions.'''),
    scienceSection('One path or separate branches',
        '''In a series circuit, components lie along one conducting path. Current passes through each in turn. In a steady simple series loop, current has the same value at each point because charge does not accumulate in one component. If either lamp connection opens, the single route is broken and both lamps go out.

In a parallel circuit, branches provide separate routes between the same two junctions. Each branch in this model contains one lamp. If one lamp branch opens, the other can remain a complete loop through the source. However, a break in a common wire or loss of the source affects both. Parallel does not mean immune to every fault. The current entering a junction equals the sum leaving through the branches in a steady circuit.'''),
    scienceVisual('sci-g6-3-paths',
        'Follow lines between junctions to count paths; component position on the page does not define the arrangement.'),
    scienceSection('Worked example: account for current',
        '''A supplied parallel-circuit table shows 0.30 A entering a junction. Branch A carries 0.10 A and branch B carries 0.20 A. Step 1: identify the point where the current splits. Step 2: add the outgoing branch readings: 0.10 + 0.20 = 0.30 A. Step 3: compare with the incoming reading. They match. Step 4: after branches rejoin, the example total is again 0.30 A.

The lamps may transfer different amounts of energy, but charge is not used up. Do not subtract a lamp's heating from a current reading. If supplied readings fail to add up, check the stated measurement conditions, units and possible recording error rather than deciding that charge vanished.'''),
    scienceVisual('sci-g6-3-current',
        'Read the bars in amperes and add branch currents, not the before-and-after totals.'),
    scienceSection('Guided example: locate the effect of a break',
        'Two diagrams have identical working sources and lamps. Diagram S has lamps in series. Diagram P has one lamp on each parallel branch. A switch opens only the connection beside lamp A in each diagram. Predict what happens to lamp B, and trace the route supporting each prediction.'),
    scienceSection('Reveal: follow the remaining route',
        'In S, the only path is broken, so lamp B also stops. In P, lamp B retains its own complete route through the source, so it can stay on. This answer assumes the source and common wires remain intact. Opening a common wire in P would break both routes.',
        reveal: true),
    scienceSection('Safe observation and troubleshooting',
        '''Observe a teacher-approved demonstration using a low-voltage AA-cell holder, matching lamp, insulated leads and switch, or use prepared diagrams instead. The teacher checks component ratings and connections. Do not use wall outlets, household wiring, damaged cells or improvised short circuits. Keep hands and the area dry; learners do not test unknown liquids as conductors.

Record whether the lamp is lit before and after the teacher changes only the switch position. If a closed model stays dark, examine one possibility at a time: a loose connection, a depleted cell or a damaged lamp. A dark lamp alone does not identify which cause occurred. A fair troubleshooting test replaces or checks one part while keeping the rest unchanged.'''),
    scienceSection('Common mistakes',
        'A lamp needs a complete loop, not just contact with one cell terminal. The source transfers energy; the lamp does not use up charges. Volts and amperes measure different quantities. Parallel branches can survive one branch break but not necessarily a break in their shared supply. A conductor is not safe to touch merely because it conducts well.'),
    scienceSection('Quick check',
        'A cell is labeled 1.5 V. Does that number state the current? A single-loop switch opens: where does sustained current stop? Two branches carry 0.15 A and 0.25 A. What is the supplied total?'),
    scienceSection('Check your thinking',
        '1.5 V states voltage, not current. Sustained current stops throughout the open simple loop. The example parallel total is 0.15 + 0.25 = 0.40 A.',
        reveal: true),
    scienceSection('Recap',
        'Trace loops before predicting lamp behavior. Separate the flow of charge from the transfer of energy, use the correct units, and account for current at junctions. Diagnose a dark circuit with controlled evidence while keeping all practical work within teacher-approved low-voltage equipment.'),
  ],
  keyConcept:
      'A complete conducting loop allows a source to transfer energy through a circuit. Charge is conserved, while series and parallel connections provide different paths.',
  questions: [
    [
      'A lamp has one lead connected to a cell but no return connection. What is missing?',
      'A complete conducting loop through both terminals',
      'An extra insulator across the lamp',
      'A second label showing cell voltage',
      'A branch that bypasses the lamp directly',
      'Sustained current requires a complete route through both source terminals and the lamp.',
      'Closed loops'
    ],
    [
      'In a simple loop, opening the switch does what?',
      'Breaks the conducting path',
      'Increases the chemical energy stored in the cell',
      'Makes the lamp a source',
      'Joins the separated switch contacts',
      'An open switch separates contacts, breaking the route.',
      'Switches'
    ],
    [
      'Which part of an ordinary insulated wire is intended to conduct current?',
      'Its copper core',
      'Its plastic covering',
      'The surrounding dry air',
      'The gap between disconnected ends',
      'Copper is a conductor; plastic separates and covers conducting parts.',
      'Conductors and insulators'
    ],
    [
      'A supplied reading of 0.20 A measures which quantity?',
      'Electric current',
      'Voltage',
      'Stored chemical energy',
      'Resistance',
      'Amperes measure the rate of charge flow. Voltage is measured in volts.',
      'Current units'
    ],
    [
      'A cell label reads 1.5 V. What does V stand for?',
      'Volts, the voltage unit',
      'Amperes, the current unit',
      'Volts, the rate-of-charge-flow unit',
      'Amperes, the energy-per-charge unit',
      'The cell label gives voltage in volts, not current in amperes.',
      'Voltage units'
    ],
    [
      'What is the main energy source in the AA-cell circuit discussed here?',
      'Stored chemical energy in the cell',
      'Mechanical energy from moving the switch',
      'Thermal energy absorbed from the room',
      'Light energy absorbed by the wires',
      'The cell converts stored chemical energy to electrical energy transferred in the circuit.',
      'Energy source'
    ],
    [
      'Which arrangement has both lamps along one conducting path?',
      'Series',
      'Parallel with one lamp per branch',
      'Two unconnected lamps',
      'An open circuit with no source',
      'Series components share one path through the source.',
      'Series circuits'
    ],
    [
      'A steady series circuit has 0.12 A before its lamp. What current leaves the lamp in this model?',
      '0.12 A',
      '0.06 A because half the charge is used',
      '0 A because all charge is used',
      '0.24 A because the lamp creates charge',
      'Charge is conserved, so steady current is the same along the simple series path.',
      'Charge conservation'
    ],
    [
      'What does a lit lamp transfer electrical energy into in this lesson?',
      'Light and heating',
      'Only light with no heating',
      'Only heating with no light',
      'Chemical energy stored back in the cell',
      'The lamp transfers energy to light and heating without consuming charge.',
      'Energy transfer'
    ],
    [
      'Two lamps are in series and one connection opens. What happens?',
      'Both stop because the only route is broken',
      'Only the nearer lamp stops while the route stays complete',
      'Both become brighter because resistance vanishes',
      'The cell voltage label alone keeps both lit',
      'An open break anywhere in the one path interrupts the series circuit.',
      'Series breaks'
    ],
    [
      'In an ideal parallel model, only lamp A branch opens. What can lamp B do if the common wires remain intact?',
      'Remain lit on its complete branch',
      'Stop because every branch must open together',
      'Receive no voltage because A is absent',
      'Become a short circuit merely by remaining connected',
      'The other branch still forms a loop through the source.',
      'Parallel branches'
    ],
    [
      'Which fault can interrupt both lamps in the parallel model?',
      'An open break in their common supply wire',
      'A break only in lamp A branch',
      'A break only in lamp B branch',
      'Different current readings in intact branches',
      'Both branch loops depend on the common supply path.',
      'Common connections'
    ],
    [
      'Branch currents are 0.10 A and 0.20 A. What total enters their junction in the steady model?',
      '0.30 A',
      '0.10 A',
      '0.20 A',
      '0.02 A',
      'The total is the sum: 0.10 + 0.20 = 0.30 A.',
      'Junction calculation'
    ],
    [
      'Why is a direct wire between cell terminals unsafe?',
      'It creates a low-resistance short circuit that may overheat',
      'It safely removes all electrical energy instantly',
      'It guarantees the current becomes zero',
      'It makes the plastic covering conduct instead of metal',
      'Bypassing the intended load can cause excessive current and heating.',
      'Short circuits'
    ],
    [
      'A learner says a battery goes flat because a lamp eats its electrons. Which correction fits?',
      'The battery loses stored chemical energy; charges continue through the circuit',
      'Current steadily decreases after each lamp because charge is used',
      'The battery supplies stored current but no energy',
      'Only the wires supply energy once the switch closes',
      'The source supplies energy; charge is not consumed at the lamp.',
      'Energy versus charge'
    ],
    [
      'A closed low-voltage circuit stays dark. Which conclusion follows from that observation alone?',
      'A fault exists, but the faulty part is not yet identified',
      'The lamp must be the only faulty part',
      'The cell must be the only faulty part',
      'All connected wires must be insulators',
      'A dark lamp may result from several causes; check them one at a time.',
      'Troubleshooting evidence'
    ],
    [
      'Which change best tests whether a loose connection caused the dark lamp?',
      'Correct that connection while keeping the other parts unchanged',
      'Replace the cell, lamp and every wire together',
      'Change the lamp and switch while removing the cell',
      'Add a direct bypass across the cell terminals',
      'Changing one suspected factor gives evidence about its role without creating a short circuit.',
      'Controlled checks'
    ],
    [
      'In a steady model, total current is 0.40 A and one branch carries 0.15 A. What does the other branch carry?',
      '0.25 A',
      '0.55 A',
      '0.40 A',
      '0.15 A',
      'Subtract the known branch from the total: 0.40 − 0.15 = 0.25 A.',
      'Junction reasoning'
    ],
    [
      'A diagram places two lamps side by side but links them along one route. How should the circuit be classified?',
      'Series, because path connections determine arrangement',
      'Parallel, because symbols are side by side',
      'Open, because the lamps are not drawn touching',
      'Shorted, because two lamp symbols are present',
      'Trace conducting routes; visual placement does not determine series or parallel.',
      'Reading schematics'
    ],
    [
      'Which observation would support that a switch controls continuity in the teacher demonstration?',
      'The lamp lights when the same circuit closes and goes out when it opens',
      'The lamp changes color after every cell is removed',
      'Different lamps are compared with different sources each time',
      'Only the printed voltage label is read without observing the lamp',
      'Changing only switch position links the lit state to the open or closed route.',
      'Circuit observation'
    ],
    [
      'Two parallel branches carry 0.18 A and 0.22 A. What should be explained at the return wire?',
      '0.40 A rejoins; lamps transferred energy without consuming charge',
      '0.04 A rejoins because only the current difference survives',
      '0 A rejoins because both lamps use all charge',
      '0.18 A rejoins because the larger branch loses its current',
      'The currents add to 0.40 A before splitting and after rejoining in this steady model.',
      'Mastery: conserved current'
    ],
    [
      'A parallel circuit loses both lamps when its common wire opens. Does that contradict independent branches?',
      'No; each branch still needs the common route through the source',
      'Yes; parallel lamps operate without a source',
      'Yes; a common wire can affect only the nearest lamp',
      'No; both lamps must have consumed all charge simultaneously',
      'Branch independence applies to a break within one branch, not a shared connection.',
      'Mastery: paths'
    ],
    [
      'A 1.5 V cell lights a lamp but no current reading is provided. Which claim is justified?',
      'Voltage is given; current cannot be read directly from that label',
      'Current must be exactly 1.5 A',
      'The lamp creates a second 1.5 V chemical source',
      'Current must be zero because voltage and current differ',
      'Voltage and current are distinct; a voltage label alone does not give circuit current.',
      'Mastery: quantities'
    ],
  ],
);

final _plateTectonics = scienceTopic(
  grade: 'g6',
  order: 4,
  title: 'Plate Tectonics',
  subtitle:
      'Connect slowly moving rigid plates with ridges, trenches and earthquakes',
  minutes: 'About 40–45 minutes',
  objectives: [
    'Describe the lithosphere and distinguish a tectonic plate from a continent.',
    'Use motion arrows to identify divergent, convergent and transform boundaries.',
    'Connect boundary processes with landforms while recognizing important exceptions.',
    'Interpret simple rock-age patterns and calculate distance from a stated plate-motion rate.',
  ],
  introduction:
      'A mountain ridge under the ocean and a deep trench may seem unrelated. On a plate map, both can mark places where huge pieces of Earth’s outer layer interact. How can movement too slow to see during a lesson build such large features?',
  prerequisiteTopicId: 'science.g6.electricity',
  sections: [
    scienceSection('Rigid pieces of an active planet',
        '''Earth's crust is its thin outer rocky layer. Beneath it lies the mantle, and deeper inside lies the core. The lithosphere includes the crust and the rigid uppermost mantle. It is divided into tectonic plates that move relative to one another. A plate is not just a continent: it may include continental land and ocean floor together.

The mantle beneath the rigid plates is mostly solid rock. Over very long times it can slowly deform and flow. Plates are not floating on a worldwide liquid-magma ocean. Small regions of rock can melt under particular conditions, but that does not make the whole mantle liquid. A plate drawing simplifies shapes and thicknesses to show relationships; it is not a measured slice through the planet.'''),
    scienceVisual('sci-g6-4-layers',
        'The lithosphere combines two rigid layers; a plate can carry land and ocean floor.'),
    scienceSection('Small annual motion adds up',
        '''Plates commonly move only a few centimeters per year. Their rates and directions differ. Modern satellite measurements can track changes in positions, while rocks provide evidence about movement across longer times. Motion is relative: two plates can move toward one another, apart, or along their shared edge.

Several processes contribute to plate motion. Dense, descending parts of oceanic plates can pull the rest of a plate; gravity and movement within Earth's interior also contribute. The detailed balance varies. At this level, the important point is that plates move as parts of a connected system over long periods. A sudden earthquake is not the same as the slow average motion recorded over years.'''),
    scienceSection('Divergent: plates separate',
        '''At a divergent boundary, neighboring plates move apart. At a mid-ocean ridge, hot rock beneath the separating plates rises; some melts, and molten material can reach the surface and cool to form new oceanic crust. The newly formed crust moves away from the ridge as more crust forms. This process is seafloor spreading.

Ridge rocks are generally youngest near the spreading center and older farther away. A matching age pattern on opposite sides supports the spreading explanation. A continent can also begin to split at a rift, so divergent boundaries are not restricted to deep oceans. Earthquakes and volcanic activity can occur at spreading regions, but the exact features depend on the setting.'''),
    scienceSection('Convergent: plates approach',
        '''At a convergent boundary, plates move toward one another. Where oceanic lithosphere descends beneath another plate, the process is subduction. A deep trench can form where the descending plate bends downward. Earthquakes occur along the interacting plates, and volcanoes can form on the overriding plate. Melting involves particular conditions above the descending slab; the entire mantle does not turn to liquid.

When two continental regions collide, their material resists sinking as readily as dense oceanic lithosphere. Crust can shorten, fold and thicken, building mountains. A convergent boundary therefore does not always mean an ocean trench plus volcanoes. To interpret a diagram, ask both how plates move and what kind of plate material is interacting.'''),
    scienceSection('Transform: plates pass one another',
        '''At a transform boundary, plates slide past each other along their shared edge. The relative movement is mainly sideways. This boundary motion does not directly create new crust as a ridge does or consume it through subduction. The plates can catch along a fault, a fracture where rock moves. Strain builds until slipping releases energy as earthquake waves.

Transform boundaries commonly have earthquakes, but transform motion does not normally produce the volcanism characteristic of spreading or subduction. Earthquakes occur at all three boundary types, so an earthquake alone does not identify one type. Some earthquakes and volcanoes also occur inside plates. A hotspot can produce volcanoes away from a plate boundary; a plate map shows a useful pattern rather than every possible event.'''),
    scienceVisual('sci-g6-4-boundaries',
        'Use arrows relative to the boundary and remember the different viewing directions.'),
    scienceSection('Worked example: read a ridge record',
        '''A provided rock-age table has four sites. Two sites equally near opposite sides of a ridge contain 2-million-year-old rocks. Two sites equally farther away contain 8-million-year-old rocks. Step 1: compare near with far: the farther rocks are older. Step 2: compare opposite sides at matching distances: their example ages match. Step 3: connect the pattern to new crust forming near the center and moving outward.

This evidence supports spreading, but a table alone does not specify every movement mechanism or predict an earthquake. Similar fossil and rock patterns on now-separated continents provide another kind of evidence for past connections. Several independent observations strengthen an explanation more than a coastline resemblance alone.'''),
    scienceVisual('sci-g6-4-ages',
        'The bars show age, not height or plate speed. The spatial relation is stated in each site label.'),
    scienceSection('Guided example: calculate motion',
        'A supplied model plate moves 3 cm per year at a constant rate. How far does it move in 10 years? In 100 years? Give the second result in meters. Does this average rate tell you how far one earthquake will suddenly move a fault?'),
    scienceSection('Reveal: keep rate and event separate',
        'Multiply rate by time: 3 cm/year × 10 years = 30 cm. Over 100 years the distance is 300 cm, equal to 3 m because 100 cm = 1 m. A constant average-rate model does not state the slip in one earthquake; gradual motion and sudden fault movement are different descriptions.',
        reveal: true),
    scienceSection('Safe map investigation',
        '''Use a teacher-provided map of plate boundaries and recorded earthquake locations. Mark where dots cluster near boundaries, then check for dots inside plates. Describe the pattern without claiming every earthquake lies on an edge. If volcanoes are also shown, compare their pattern with ridges and subduction zones rather than assuming they follow every boundary equally.

For a table-top model, move two paper cards apart, together and past one another. Draw arrows for each relative motion. Cards help show direction but cannot reproduce rock strength, depth, heat or the timescale of mantle deformation. Do not visit unstable slopes, faults, trenches or active volcanic areas for an activity. Use local official emergency instructions and school drills for real hazards.'''),
    scienceSection('Common mistakes',
        'A continent and plate are not equivalent. The lithosphere includes rigid uppermost mantle as well as crust. Mostly solid mantle can deform slowly without being a liquid ocean. Not every convergent boundary has the same features, and not every plate boundary produces volcanoes. A boundary map or average motion rate does not give the timing of a particular earthquake.'),
    scienceSection('Quick check',
        'Arrows point away from a ridge: which boundary type is shown? A plate descends beneath another: what is the process? Does an earthquake dot by itself distinguish transform from convergent?'),
    scienceSection('Check your thinking',
        'The ridge is divergent. The descending plate undergoes subduction. An earthquake dot alone cannot identify the boundary type because several types can produce earthquakes; combine location, motion and other evidence.',
        reveal: true),
    scienceSection('Recap',
        'Start with rigid lithospheric plates over slowly deforming, mostly solid mantle. Use relative motion to name boundaries, connect processes to landforms, and test explanations with several kinds of evidence. Keep small average rates distinct from sudden hazard events.'),
  ],
  keyConcept:
      'Tectonic plates are rigid pieces of lithosphere whose relative motion forms different boundaries. Long-term motion explains many large landforms and hazard patterns, with exceptions.',
  questions: [
    [
      'Which layers together make the lithosphere in this lesson?',
      'Crust and rigid uppermost mantle',
      'Crust and the entire liquid outer core',
      'Only ocean water and seafloor sediment',
      'The whole mantle and whole core',
      'Lithosphere includes crust and the rigid uppermost mantle, not the entire interior.',
      'Lithosphere'
    ],
    [
      'Which description of the mantle beneath plates is accurate?',
      'Mostly solid rock that can deform over long times',
      'A worldwide ocean of fully liquid magma',
      'A rigid layer that cannot change shape on any timescale',
      'An empty gap between crust and core',
      'Long-term deformation is possible in mostly solid mantle; it is not all liquid.',
      'Mantle behavior'
    ],
    [
      'A plate contains both land and seafloor. What does that demonstrate?',
      'A tectonic plate is not the same as a continent',
      'Every plate consists only of continental crust',
      'Every continent must be a separate whole plate',
      'Ocean floor lies outside all tectonic plates',
      'Plates may include oceanic and continental regions together.',
      'Plates and continents'
    ],
    [
      'Boundary arrows point away from one another. Which type is shown?',
      'Divergent',
      'Convergent',
      'Transform',
      'Continental collision',
      'Divergent means plates move apart relative to their boundary.',
      'Boundary motion'
    ],
    [
      'One oceanic plate descends beneath another plate. What is this process called?',
      'Subduction',
      'Seafloor spreading',
      'Sideways transform slip',
      'Surface weathering',
      'Subduction carries one plate downward at a convergent boundary.',
      'Subduction'
    ],
    [
      'Boundary arrows show sideways movement along the shared edge. Which type fits?',
      'Transform',
      'Divergent',
      'Convergent subduction',
      'Continental collision',
      'Transform plates pass one another along their shared boundary.',
      'Transform motion'
    ],
    [
      'Where is new oceanic crust generally formed during seafloor spreading?',
      'Near the mid-ocean ridge',
      'Only at the deepest part of the core',
      'Only at every transform fault',
      'At the bottom of every river valley',
      'Molten rock can cool to form new oceanic crust at spreading ridges.',
      'New crust'
    ],
    [
      'Which rock-age pattern supports spreading away from a ridge?',
      'Younger near the ridge and older farther away on both sides',
      'Older near the ridge and younger farther away on both sides',
      'Age determined only by whether rock is above sea level',
      'No relationship between rock age and distance in any ridge model',
      'New crust forms near the spreading center and moves outward as it ages.',
      'Rock-age evidence'
    ],
    [
      'Which landform can mark where an oceanic plate bends downward into subduction?',
      'A deep trench',
      'Only a flat spreading center',
      'A transform edge that creates new crust',
      'A river delta formed by sediment alone',
      'A trench can form where the descending oceanic plate bends down.',
      'Subduction landforms'
    ],
    [
      'Two continental regions collide. Which outcome fits the lesson?',
      'Crust can fold and thicken into mountains',
      'Every collision must form an ocean trench with volcanoes',
      'New oceanic crust must form between separating plates',
      'Both regions must slide only sideways without shortening',
      'Continental collision can build mountains without the same features as oceanic subduction.',
      'Continental collision'
    ],
    [
      'Why are earthquakes alone insufficient to identify a boundary type?',
      'All three main types can produce earthquakes',
      'Earthquakes occur only at transform boundaries',
      'Earthquakes occur only at divergent boundaries',
      'Earthquakes occur only at convergent boundaries',
      'Use motion and setting as well as earthquake evidence.',
      'Multiple evidence'
    ],
    [
      'What commonly happens when caught rock along a fault suddenly slips?',
      'Stored strain energy is released as earthquake waves',
      'The whole mantle becomes liquid immediately',
      'The plate stops moving permanently',
      'A new continent must form at once',
      'Sudden slipping releases energy; it differs from the slow average motion of plates.',
      'Earthquake mechanism'
    ],
    [
      'A model plate moves 3 cm each year. What distance corresponds to 10 years at that rate?',
      '30 cm',
      '3 cm',
      '13 cm',
      '300 cm',
      'Rate × time = 3 × 10 = 30 cm.',
      'Rate calculation'
    ],
    [
      'Which statement about volcano locations fits the lesson?',
      'Many occur near boundaries, but hotspots can occur within plates',
      'Every volcano must lie on a transform boundary',
      'Every plate boundary must have volcanoes',
      'No volcano can occur away from a boundary',
      'Patterns are useful but have exceptions, including within-plate hotspots.',
      'Volcanic patterns'
    ],
    [
      'A rock-age chart shows 2 million years near a ridge and 8 million years far away. What do its bars measure?',
      'Rock age, not plate height or movement speed',
      'Plate height in millions of meters',
      'Movement speed in millions of centimeters per year',
      'The date of the next earthquake',
      'Read the stated unit: million years measures age.',
      'Graph interpretation'
    ],
    [
      'A map shows a volcano inside a plate. Which explanation should be considered?',
      'A hotspot, rather than assuming the boundary map is wrong',
      'A transform boundary must run through every volcano',
      'The mantle everywhere must be fully molten',
      'Volcanoes cannot exist inside plates, so erase the observation',
      'Within-plate volcanism can occur at hotspots; maps need not place every volcano on a boundary.',
      'Exceptions'
    ],
    [
      'Which extra evidence strengthens a past-connection explanation beyond similar coastlines?',
      'Matching rock and fossil patterns across separated continents',
      'Only the present country names',
      'Only current rainfall on each continent',
      'Only the color used for continents on the map',
      'Independent geological and fossil evidence can support past connections.',
      'Past connections'
    ],
    [
      'At 3 cm/year for 100 years, what is the model distance in meters?',
      '3 m',
      '30 m',
      '0.3 m',
      '300 m',
      '3 × 100 = 300 cm, and 300 ÷ 100 = 3 m.',
      'Unit conversion'
    ],
    [
      'What is a limitation of sliding paper cards to model plate motion?',
      'They show directions but do not reproduce rock properties or mantle timescales',
      'They cannot show any relative direction',
      'They prove the mantle is a liquid ocean',
      'They measure actual plate speeds without field data',
      'A useful motion model does not reproduce every physical process.',
      'Model limits'
    ],
    [
      'A map has many earthquake dots near edges and some inside plates. Which description respects all the data?',
      'Earthquakes cluster near boundaries but are not restricted to them',
      'Every earthquake lies exactly on a plate edge',
      'No earthquake is related to plate boundaries',
      'Interior dots prove that plates cannot move',
      'Describe both the main pattern and the exceptions.',
      'Map evidence'
    ],
    [
      'A diagram shows plates moving together, one descending, and a trench. Which conclusion is supported?',
      'Convergent subduction is shown, with oceanic lithosphere descending',
      'Divergence is shown because every trench forms new crust',
      'Transform motion is shown because every earthquake is transform',
      'Continental collision must be shown because all convergent plates stay horizontal',
      'Use motion, downward slab and trench together to identify the subduction model.',
      'Mastery: boundary evidence'
    ],
    [
      'A constant-rate model gives 3 cm/year. What does it establish about one future earthquake?',
      'It does not specify that earthquake’s timing or slip distance',
      'The earthquake must move exactly 3 cm',
      'The earthquake must happen once every year',
      'The earthquake cannot occur because plate motion is slow',
      'Average plate motion and a particular sudden fault event are different quantities.',
      'Mastery: rate limits'
    ],
    [
      'Two near-ridge sites have ages of 2 million years and two farther sites have ages of 8 million years. Which inference fits?',
      'The pattern supports crust forming near the ridge and moving outward',
      'The pattern proves every nearby boundary is transform',
      'The pattern shows older crust forming at the ridge today',
      'The pattern identifies the exact date of the next eruption',
      'The paired outward increase in age supports spreading, with no event prediction implied.',
      'Mastery: ridge record'
    ],
  ],
);

final _solarSystem = scienceTopic(
  grade: 'g6',
  order: 5,
  title: 'Solar System',
  subtitle:
      'Compare orbiting objects, motion and the scale of planetary distances',
  minutes: 'About 40–45 minutes',
  objectives: [
    'Distinguish the Sun, planets, dwarf planets and natural satellites using stated criteria.',
    'Locate the inner planets, main asteroid belt and outer planets in orbital order.',
    'Compare rotation with revolution and explain gravity’s role in an orbit.',
    'Interpret average Sun distances in AU and evaluate the limits of a scale model.',
  ],
  introduction:
      'A page can fit the Sun and every planet into a small picture, but space between them is enormous. Which parts of that picture help explain our Solar System, and which parts could give a false impression if we treated them as measurements?',
  prerequisiteTopicId: 'science.g6.plate-tectonics',
  sections: [
    scienceSection('One star and its orbiting system',
        '''The Solar System contains the Sun and objects held in its gravitational system, including planets, dwarf planets, moons, asteroids and comets. The Sun is a star. Deep inside it, nuclear fusion releases energy that eventually reaches space as radiation, including light. The Sun is not a planet, and a planet does not become a star just because it looks bright in our sky.

Planets are visible mainly because they reflect sunlight. Their surfaces or atmospheres can also give off energy as infrared radiation, but they do not produce sunlight through fusion like the Sun. A natural satellite, or moon, orbits a larger body such as a planet or dwarf planet. Earth's Moon travels around Earth while both also move around the Sun.'''),
    scienceSection('What makes a planet in our Solar System?',
        '''The current introductory definition for a Solar System planet has three criteria. It orbits the Sun, its own gravity makes it nearly round, and it has cleared the neighborhood around its orbit. The last phrase means that the body gravitationally dominates its orbital region. It does not require absolutely empty space: planets can still share their regions with small bodies.

A dwarf planet also orbits the Sun and is nearly round, but has not cleared its orbital neighborhood. It is not a natural satellite. Pluto and Ceres are dwarf planets. Pluto did not change physically when its classification changed; scientists adopted criteria that place it in a different category. Being small alone or being round alone is insufficient to distinguish all these categories. These definitions concern our Solar System; the Sun itself is outside the planet category.'''),
    scienceVisual('sci-g6-5-categories',
        'Use orbit, shape and orbital-region evidence together; do not classify from apparent brightness.'),
    scienceSection('Eight planets in orbital order',
        '''Starting with the smallest average distance from the Sun, the planets are Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus and Neptune. Mercury, Venus, Earth and Mars are the inner rocky planets. They have solid rocky surfaces. Jupiter and Saturn are gas giants, made mainly of hydrogen and helium. Uranus and Neptune are ice giants, with a larger proportion of other substances in their interiors. These outer planets do not have a solid surface like Earth's ground.

The main asteroid belt lies between the orbits of Mars and Jupiter. Asteroids are generally small rocky bodies orbiting the Sun, and they also occur outside that belt. Ceres is a dwarf planet within the main belt. Comets contain ice and dust; when near the Sun, escaping material can form a surrounding cloud and tails. A comet is not a planet with a tail.'''),
    scienceVisual('sci-g6-5-orbits',
        'Follow numbered orbits outward. The drawn bodies are model markers, not a photograph of current positions.'),
    scienceSection('Gravity, rotation and revolution',
        '''Gravity attracts objects with mass. The Sun's gravity continually changes the direction of a moving planet, helping keep it in orbit. An orbit is not a solid track or a string holding the planet. The planet's motion and gravitational attraction together explain the curved path; it is not simply resting still above the Sun.

Rotation is spinning about an axis. Revolution is traveling around another body. Earth's rotation gives the daily alternation of day and night; one revolution around the Sun defines a year. These are different motions and can happen together. Planets have different rotation times and orbital periods. A planet farther from the Sun generally takes longer to complete an orbit than an inner planet. Drawn circles or ellipses simplify actual paths and do not imply equally spaced orbits.'''),
    scienceSection('Distances require a scale',
        '''An astronomical unit, AU, is about 150 million kilometers, close to Earth's average distance from the Sun. We use rounded values here: Earth 1.0 AU, Mars 1.5 AU, Jupiter 5.2 AU and Neptune 30.1 AU. These describe average distances from the Sun, not distances between a planet and Earth on a particular day.

The planets move, so their separation changes. Subtracting two average Sun distances does not generally give their present separation. For example, Earth and Mars may be on different sides of the Sun. A chart of average Sun distances answers which orbit is farther out, but a current separation question needs current positions. Read both the units and the reference point before drawing a conclusion.'''),
    scienceVisual('sci-g6-5-distances',
        'The bars compare average Sun distance on a common zero baseline; they do not show planet diameters.'),
    scienceSection('Worked example: a distance model',
        '''Choose a model scale of 1 AU represented by 10 cm. Step 1: put a Sun marker at 0 cm. Step 2: multiply each average Sun distance by 10 cm per AU. Earth is at 10 cm, Mars at 15 cm, Jupiter at 52 cm and Neptune at 301 cm. Step 3: convert the last measurement: 301 cm equals 3.01 m. This model needs more than three meters of clear space.

Step 4: identify its limitation. The marker sizes are not on the same scale as the distances. A large paper Earth placed at 10 cm is useful for labeling but makes the planet look far too large. Model positions along a straight line compare radial distances; they do not show every planet actually aligned at once.'''),
    scienceSection('Guided example: change the scale',
        'Use the same rounded distances with 1 AU represented by 5 cm. Where should Earth and Jupiter be placed from the Sun marker? Does halving the scale change the real average distance to Jupiter or only the model distance?'),
    scienceSection('Reveal: a model changes, space does not',
        'Earth is at 1.0 × 5 = 5 cm. Jupiter is at 5.2 × 5 = 26 cm. The real average distance remains about 5.2 AU; changing the model scale only changes its representation. Use one scale consistently when comparing all markers.',
        reveal: true),
    scienceSection('Safe model investigation',
        '''Create a table of the four supplied AU values and calculate model distances before placing paper markers. With teacher guidance, use a clear indoor surface, measuring tape and removable paper labels. Keep walkways open and avoid trailing string across a route. If space is limited, draw a number line on paper using a smaller consistent scale. Do not claim realistic planet diameters unless you have calculated a separate size model.

Sky observation is optional and requires an adult-approved location. Never look directly at the Sun or point binoculars or a telescope at it. Photographs and local diagrams are enough for this lesson; no telescope, internet connection or outdoor trip is needed to learn the core ideas.'''),
    scienceSection('Common mistakes',
        'The Sun is a star, and Pluto is a dwarf planet. A nearly round shape alone does not make a planet; moons can be round too. Rotation and revolution are different motions. Average Sun distance is not present Earth–planet distance. Orbit diagrams often exaggerate body sizes and compress gaps, so a neat picture is not automatically a scale model.'),
    scienceSection('Quick check',
        'Which motion defines Earth’s year? Which rocky planet comes just before the main asteroid belt? At 10 cm per AU, where does Jupiter go? Can a round object orbiting Earth satisfy the dwarf-planet definition?'),
    scienceSection('Check your thinking',
        'Earth’s revolution defines the year. Mars precedes the main belt. Jupiter goes at 52 cm. A satellite orbiting Earth is not a dwarf planet under the stated criteria, even if nearly round.',
        reveal: true),
    scienceSection('Recap',
        'Distinguish object categories, trace orbital order, and connect gravity with moving bodies. Read distance units and reference points carefully. Models make enormous distances manageable, but their scales and limitations must be stated explicitly.'),
  ],
  keyConcept:
      'The Solar System is a gravitational system centered on one star. Object categories, orbital motions and distance scales describe different features and must not be confused.',
  questions: [
    [
      'The Sun produces its own light through energy released by fusion. Which category fits it?',
      'Star',
      'Rocky planet',
      'Dwarf planet',
      'Natural satellite',
      'The Sun is a star; planets primarily reflect sunlight in visible observations.',
      'Sun as star'
    ],
    [
      'Which order correctly lists the inner rocky planets outward from the Sun?',
      'Mercury, Venus, Earth, Mars',
      'Venus, Mercury, Mars, Earth',
      'Earth, Mars, Venus, Mercury',
      'Mercury, Earth, Venus, Mars',
      'The orbital order starts Mercury, Venus, Earth, Mars.',
      'Planet order'
    ],
    [
      'Which pair consists of the gas giants in this lesson?',
      'Jupiter and Saturn',
      'Uranus and Neptune',
      'Earth and Mars',
      'Mercury and Venus',
      'Jupiter and Saturn are gas giants; Uranus and Neptune are ice giants.',
      'Planet groups'
    ],
    [
      'The main asteroid belt is between which planetary orbits?',
      'Mars and Jupiter',
      'Earth and Mars',
      'Jupiter and Saturn',
      'Uranus and Neptune',
      'The main belt lies between Mars and Jupiter; not all asteroids occur in it.',
      'Asteroid belt'
    ],
    [
      'Earth spins about its axis. Which motion is this?',
      'Rotation',
      'Revolution around the Sun',
      'Satellite motion around Earth',
      'Clearing an orbital neighborhood',
      'Rotation is spinning; revolution is travel around another body.',
      'Rotation'
    ],
    [
      'Which motion defines one Earth year?',
      'One revolution around the Sun',
      'One rotation about Earth’s axis',
      'One Moon rotation only',
      'One comet passage near Earth',
      'Earth completes a revolution around the Sun in a year.',
      'Revolution'
    ],
    [
      'Which supplied object is a dwarf planet?',
      'Pluto',
      'Neptune',
      'Earth’s Moon',
      'The Sun',
      'Pluto is nearly round and orbits the Sun but has not cleared its orbital neighborhood.',
      'Dwarf planets'
    ],
    [
      'What does 1 AU approximately represent in this lesson?',
      '150 million km, close to Earth’s average Sun distance',
      '150 km, the distance across a small city',
      'Earth’s diameter rather than a Sun distance',
      'The Moon’s average distance from Earth',
      'AU is useful for Solar System distances and is about 150 million km.',
      'Astronomical units'
    ],
    [
      'Which evidence is needed beyond nearly round shape to identify a Solar System planet?',
      'Sun orbit and cleared orbital neighborhood',
      'Earth orbit and a visible tail',
      'Any orbit and an icy surface',
      'A bright appearance and a ring system',
      'The definition combines Sun orbit, near-round shape and orbital dominance.',
      'Planet criteria'
    ],
    [
      'Why does cleared orbital neighborhood not require an absolutely empty orbit?',
      'It refers to gravitational dominance rather than absence of every small object',
      'It means the planet has no gravity',
      'It means every object in the region is a moon',
      'It means the planet must be the smallest body in its region',
      'Planets can dominate their regions while small bodies still occur there.',
      'Orbital dominance'
    ],
    [
      'A natural object is nearly round and orbits Earth. Which classification fits its stated orbit?',
      'Natural satellite',
      'Solar System planet solely because it is round',
      'Dwarf planet solely because it is small',
      'Star solely because it is visible',
      'A moon is a satellite; round shape does not override its orbit category.',
      'Satellites'
    ],
    [
      'Which comparison of Uranus and Neptune with Jupiter and Saturn is taught?',
      'The first pair are ice giants and the second pair are gas giants',
      'The first pair are rocky planets and the second are dwarf planets',
      'All four are inner rocky planets',
      'All four are natural satellites of the Sun',
      'The outer planets have distinct gas-giant and ice-giant groupings.',
      'Outer planets'
    ],
    [
      'At 10 cm per AU, where is Mars using its rounded 1.5 AU Sun distance?',
      '15 cm from the Sun marker',
      '1.5 cm from the Sun marker',
      '150 cm from the Sun marker',
      '6.7 cm from the Sun marker',
      'Multiply 1.5 AU by 10 cm per AU to get 15 cm.',
      'Scale calculation'
    ],
    [
      'What role does gravity play in a planet’s orbit?',
      'It continually changes the direction of the moving planet',
      'It creates a solid track in space',
      'It keeps the planet motionless above the Sun',
      'It makes all planets have equal orbital periods',
      'Gravity and existing motion together explain a curved orbit.',
      'Orbital motion'
    ],
    [
      'Jupiter is at an average 5.2 AU from the Sun. What is its position at 5 cm per AU?',
      '26 cm from the Sun marker',
      '52 cm from the Sun marker',
      '1.04 cm from the Sun marker',
      '10.2 cm from the Sun marker',
      '5.2 × 5 = 26 cm; changing scale changes the model, not the real orbit.',
      'Changing scale'
    ],
    [
      'A chart gives Earth 1.0 AU and Mars 1.5 AU from the Sun. Why is 0.5 AU not generally their current separation?',
      'Their positions around the Sun vary and they may be on different sides',
      'An AU changes length for each planet',
      'Mars always stays directly beyond Earth on one line',
      'Earth’s average Sun distance measures its diameter',
      'Average radial distances alone do not specify current planet-to-planet separation.',
      'Reference points'
    ],
    [
      'A large paper Earth is placed correctly at 10 cm in the distance model. What limitation remains?',
      'Its diameter is not necessarily on the distance scale',
      'Its orbital order must be wrong because it is paper',
      'The real Earth has moved to 10 cm from the Sun',
      'The model has measured the current Earth–Mars separation',
      'Marker positions can use a distance scale while marker sizes are exaggerated.',
      'Model size limits'
    ],
    [
      'At 10 cm per AU, Neptune at 30.1 AU belongs at what distance in meters?',
      '3.01 m',
      '30.1 m',
      '0.301 m',
      '301 m',
      '30.1 × 10 = 301 cm; divide by 100 to obtain 3.01 m.',
      'Unit conversion'
    ],
    [
      'Why does changing Pluto’s classification not imply that Pluto physically changed?',
      'Classification criteria changed how scientists group the same body',
      'Pluto stopped orbiting the Sun when renamed',
      'Pluto instantly lost its nearly round shape',
      'Every dwarf planet became a moon at that moment',
      'A category reflects criteria and evidence; renaming did not transform the object.',
      'Classification and objects'
    ],
    [
      'A drawn orbit chart spaces all planets equally. What should a learner check before measuring gaps?',
      'Whether the chart explicitly uses a distance scale',
      'Whether every marker has the same color',
      'Whether the title uses the word space',
      'Whether the chart contains eight planet names only',
      'An orbit-order diagram may compress distances; a scale must be stated before measuring.',
      'Reading models'
    ],
    [
      'A body orbits the Sun, is nearly round, has not cleared its orbital neighborhood and is not a satellite. Which category follows?',
      'Dwarf planet',
      'Planet under all three criteria',
      'Natural satellite',
      'Star',
      'All supplied criteria match a dwarf planet and distinguish it from a planet or moon.',
      'Mastery: categories'
    ],
    [
      'A model places Earth at 5 cm and Jupiter at 26 cm from its Sun marker. Which consistent scale fits the supplied data?',
      '5 cm per AU',
      '10 cm per AU',
      '1 cm per AU',
      '26 cm per AU',
      'Earth is 1 AU and Jupiter 5.2 AU; both positions equal distance multiplied by 5 cm per AU.',
      'Mastery: model scale'
    ],
    [
      'An observer sees a bright object but has no orbit or light-production evidence. Which conclusion is justified?',
      'Brightness alone cannot establish whether it is a star or planet',
      'Every bright object must be a planet',
      'Every bright object must produce light through fusion',
      'A bright object must be a dwarf planet',
      'Category depends on physical and orbital evidence, not apparent brightness alone.',
      'Mastery: evidence'
    ],
  ],
);
