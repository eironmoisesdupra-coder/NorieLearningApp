import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

final List<NorieTopicContent> grade5ScienceTopics = [
  _cellsIntroduction,
  _foodWebs,
  _propertiesOfMatter,
  _simpleMachines,
  _waterCycle,
];

const Map<String, ScienceFigure> grade5ScienceFigures = {
  'sci-g5-5-paths': ScienceFigure(
    picture: 'g5-water-paths',
    title: 'Water can take several routes through a landscape',
    kind: 'comparison',
    labels: [
      'Surface to air',
      'Air to surface',
      'Along the surface',
      'Into and through the ground'
    ],
    details: [
      'Evaporation and plant transpiration supply water vapor.',
      'Condensation forms droplets; precipitation returns water to the surface.',
      'Runoff can enter streams and larger water stores.',
      'Infiltration supplies water to soil and can replenish groundwater.'
    ],
    note:
        'Branches show possible routes, not a fixed schedule. Some water stays stored, some enters plants, and some follows another route.',
  ),
  'sci-g5-5-states': ScienceFigure(
    title: 'Name a change using its starting and ending states',
    kind: 'comparison',
    labels: ['Evaporation', 'Condensation', 'Freezing and melting'],
    details: [
      'Liquid water becomes invisible water vapor, a gas.',
      'Water vapor becomes liquid droplets; clouds contain droplets and/or ice crystals.',
      'Freezing changes liquid to solid ice; melting returns solid ice to liquid water.'
    ],
    note:
        'Rainfall moves water from atmosphere to surface; it is not the name for liquid water changing into gas.',
  ),
  'sci-g5-5-runoff': ScienceFigure(
    title: 'Example runoff collected after adding 100 mL of water',
    kind: 'bars',
    labels: ['Soil tray', 'Paved-model tray'],
    details: ['25 mL collected as runoff.', '80 mL collected as runoff.'],
    values: [25, 80],
    unit: 'mL runoff',
    note:
        'Equal area, slope, added water and collection time. Water not collected could infiltrate or remain on a tray; this test alone does not show all of it became groundwater.',
  ),
  'sci-g5-4-lever': ScienceFigure(
    picture: 'g5-lever',
    title: 'A lever trades effort force for travel',
    kind: 'comparison',
    labels: ['Load', 'Fulcrum', 'Effort', 'Unequal arms'],
    details: [
      'The object being lifted lies on the short arm.',
      'The beam turns around this supporting pivot.',
      'A downward push on the long arm lifts the load.',
      'The effort end travels farther than the load end in this arrangement.'
    ],
    note:
        'The fulcrum lies between load and effort in this example. Other levers have different arrangements; a longer effort arm can reduce effort force.',
  ),
  'sci-g5-4-types': ScienceFigure(
    title: 'Six simple-machine forms',
    kind: 'comparison',
    labels: [
      'Lever and pulley',
      'Inclined plane and wedge',
      'Wheel and axle; screw'
    ],
    details: [
      'A lever pivots; a pulley guides a rope around a wheel.',
      'A ramp offers a sloping route; a moving wedge separates or lifts material.',
      'Linked rotating wheel and axle sizes can trade force and travel; a screw uses a spiral inclined plane.'
    ],
    note:
        'Machines can change force, distance or direction. An ordinary hand-operated tool does not need a motor to be a machine.',
  ),
  'sci-g5-4-ramp': ScienceFigure(
    title: 'Example force readings for two ramps to the same height',
    kind: 'bars',
    labels: ['Short ramp', 'Long ramp'],
    details: [
      '12 N in this example comparison.',
      '6 N in this example comparison.'
    ],
    values: [12, 6],
    unit: 'N',
    note:
        'Same load, height, surface and steady-motion method. The longer route used less force in these example readings; it did not remove the need to transfer energy.',
  ),
  'sci-g5-3-properties': ScienceFigure(
    title: 'Choose a property for the question',
    kind: 'comparison',
    labels: ['Mass', 'Volume', 'Solubility', 'Magnetic response'],
    details: [
      'Measure the amount of matter with a balance, in grams.',
      'Measure occupied space; liquid volume may be measured in milliliters.',
      'Test whether a known substance dissolves in a chosen liquid under stated conditions.',
      'Observe attraction to a magnet; steel may respond while aluminum does not.'
    ],
    note:
        'Properties are evidence. Neither matching color nor one magnetic result uniquely identifies every material.',
  ),
  'sci-g5-3-density': ScienceFigure(
    title: 'Compare equal volumes of example liquids',
    kind: 'bars',
    labels: ['Liquid A: 20 mL', 'Liquid B: 20 mL'],
    details: [
      'Mass 40 g; density 40 ÷ 20 = 2 g/mL.',
      'Mass 20 g; density 20 ÷ 20 = 1 g/mL.'
    ],
    values: [40, 20],
    unit: 'g',
    note:
        'The bars show mass, not density directly. Equal volumes let us infer that A has twice the mass per milliliter in these example measurements.',
  ),
  'sci-g5-3-separate': ScienceFigure(
    title: 'Properties guide separation of salt, sand and water',
    kind: 'process',
    labels: ['Stir known materials', 'Filter', 'Allow water to evaporate'],
    details: [
      'Salt dissolves; sand remains as visible grains.',
      'A suitable filter retains sand but lets salt solution pass.',
      'Water leaves as vapor; salt can remain in the container.'
    ],
    note:
        'Teacher demonstration or diagram only. No tasting, heating or unknown mixtures. Dissolved salt is too small for this ordinary filter to retain.',
  ),
  'sci-g5-2-web': ScienceFigure(
    picture: 'g5-food-web',
    title: 'Several connected feeding routes in a meadow',
    kind: 'comparison',
    labels: [
      'Grass → rabbit',
      'Grass → grasshopper',
      'Grasshopper → frog',
      'Rabbit → hawk and frog → hawk'
    ],
    details: [
      'The rabbit receives energy in eaten grass.',
      'The grasshopper also receives energy in eaten grass.',
      'The frog receives energy in eaten grasshoppers.',
      'The hawk has two prey routes in this simplified web.'
    ],
    note:
        'Food arrows point toward the eater. These selected links do not show every possible food or organism in a real meadow.',
  ),
  'sci-g5-2-materials': ScienceFigure(
    title: 'Materials return; energy does not loop back',
    kind: 'comparison',
    labels: [
      'Dead organisms and waste',
      'Decomposer activity',
      'Mineral nutrients',
      'Energy transfer'
    ],
    details: [
      'Material from producers and consumers becomes available.',
      'Many fungi and bacteria break down that material.',
      'Some materials return to soil and can be taken up by plants.',
      'Energy passes through organisms and spreads to surroundings as heat.'
    ],
    note:
        'The plant → eater arrows follow food energy. The return of mineral nutrients is a different connection, not recycled sunlight.',
  ),
  'sci-g5-2-counts': ScienceFigure(
    title: 'Example rabbit counts in the same survey area',
    kind: 'bars',
    labels: ['Before dry period', 'After dry period'],
    details: [
      '12 rabbits observed using a set method.',
      '7 rabbits observed using the same method.'
    ],
    values: [12, 7],
    unit: 'rabbits observed',
    note:
        'Counts show a decline in observations, not its cause. Grass amount, movement and detection also need investigation.',
  ),
  'sci-g5-1-structures': ScienceFigure(
    picture: 'g5-cells',
    title: 'Animal cell and photosynthetic plant cell',
    kind: 'comparison',
    labels: [
      'Cell membrane',
      'Cytoplasm and nucleus',
      'Cell wall',
      'Chloroplasts and large vacuole'
    ],
    details: [
      'Both cells have a boundary that controls movement of substances.',
      'Both contain cytoplasm and a nucleus with genetic instructions.',
      'The plant cell has a supporting wall outside its membrane.',
      'The leaf-cell model has chloroplasts and a large fluid-filled central vacuole.'
    ],
    note:
        'Simplified enlarged models, not actual colors or scale. Many root cells have no chloroplasts. Both plant and animal cells also have mitochondria.',
  ),
  'sci-g5-1-organization': ScienceFigure(
    title: 'From small units to a whole person',
    kind: 'process',
    labels: ['Muscle cell', 'Muscle tissue', 'Heart', 'Circulatory system'],
    details: [
      'One living unit can contract.',
      'Related cells work together in tissue.',
      'An organ contains several tissue types.',
      'The heart and blood vessels cooperate in a system.'
    ],
    note:
        'Cells, tissues, organs and systems describe levels of organization, not stages that one cell turns into during a day.',
  ),
  'sci-g5-1-evidence': ScienceFigure(
    title: 'Observation, model and inference',
    kind: 'comparison',
    labels: ['Microscope image', 'Labeled diagram', 'Reasoned inference'],
    details: [
      'Shows structures visible in this prepared sample.',
      'Selects and enlarges features to explain their jobs.',
      'Uses evidence and taught structure to explain what the cell may do.'
    ],
    note:
        'An unseen structure is not necessarily absent. Visibility depends on preparation, magnification and the instrument.',
  ),
};

final _cellsIntroduction = scienceTopic(
  grade: 'g5',
  order: 1,
  title: 'Cells Introduction',
  subtitle: 'Connect tiny living structures with the jobs of an organism',
  minutes: 'About 35–40 minutes',
  objectives: [
    'Identify the membrane, cytoplasm and nucleus in a simplified cell model.',
    'Compare a typical animal cell with a photosynthetic plant cell using structural evidence.',
    'Connect cells, tissues, organs and organ systems in one example.',
    'Distinguish a microscope observation from a diagram or an unsupported inference.',
  ],
  introduction:
      'A leaf and your arm look very different. Under a microscope, both contain small living units called cells. How can tiny units with shared parts help make such different organisms?',
  prerequisiteTopicId: null,
  sections: [
    scienceSection('Small units, real life',
        '''A cell is the smallest unit that carries out the basic activities of life. Cells use materials, release usable energy from food, and maintain their internal conditions. New cells come from existing cells. Most cells are too small to examine clearly with only your eyes, so microscopes help scientists study them.

Some organisms consist of one cell. A single-celled organism must perform its life activities within that one cell. Plants and animals are multicellular: their bodies contain many cells. A large organism is not usually one enormous cell. It has many small units that cooperate. Cell shape and size vary, so a single picture cannot represent every cell.'''),
    scienceSection('A boundary and a working interior',
        '''The cell membrane is a thin boundary around a cell. It controls which substances enter and leave. Water, nutrients and waste must move between cells and their surroundings. A membrane is not a sealed plastic bag: it allows selected movement while helping maintain suitable conditions inside.

Cytoplasm is the material inside the membrane, outside the nucleus in the cells studied here. It includes fluid and structures where many cell activities occur. The nucleus contains most of the cell's genetic instructions, which help direct its activities. A nucleus is a structure inside the cell, not the whole cell itself. These instructions are not thoughts, and cells do not make conscious choices.'''),
    scienceSection('Special structures support special jobs',
        '''Mitochondria help release usable energy from food. Both typical plant cells and typical animal cells have them. Plants make sugars through photosynthesis, but their cells still need to release usable energy from those sugars. A cell that does demanding work may contain many mitochondria.

Plant cells also have a cell wall outside the membrane. This firmer layer supports and protects the cell. A large central vacuole in many mature plant cells stores fluid and helps keep the cell firm when it contains enough water. Chloroplasts in photosynthetic cells capture light energy for making food. Many leaf cells have chloroplasts; many root cells underground do not. Being a plant cell does not mean every cell has every structure shown in a leaf-cell diagram.'''),
    scienceVisual('sci-g5-1-structures',
        'Compare shared structures first, then structures of the photosynthetic plant-cell model.'),
    scienceSection('From cells to cooperating systems',
        '''In a multicellular organism, cells can become specialized for different jobs. Muscle cells can contract. Nerve cells carry signals. In plants, root hair cells help take in water and minerals from soil; their extended shape gives more contact with their surroundings.

Related cells working together form a tissue. Several tissue types cooperate in an organ. The heart is an organ containing muscle tissue and other tissues. Organs working together form an organ system. The heart and blood vessels cooperate in the circulatory system. These are levels of organization. A muscle cell does not simply grow into a whole heart. Different cells and tissues contribute to building and maintaining the organ.'''),
    scienceVisual('sci-g5-1-organization',
        'Explain what is added at each level: cooperating cells, several tissue types, then cooperating organs.'),
    scienceSection('Worked example: an unknown cell drawing',
        '''A prepared drawing shows a cell membrane, nucleus, firm outer wall and large central vacuole. No chloroplasts are shown. Step 1: identify the shared parts. The membrane and nucleus fit both typical animal and plant cells. Step 2: look for distinguishing evidence. The wall and large central vacuole support identifying a plant cell in this comparison. Step 3: check a possible exception. A root cell may have no chloroplasts. Step 4: state a careful conclusion: this model fits a plant cell, but the drawing alone does not identify its exact plant or location.

Using only color would be weaker reasoning. Diagram colors are chosen to separate structures; a green outline alone is not evidence of chloroplasts.'''),
    scienceSection('Guided example: a working muscle',
        '''A muscle-cell model contains many mitochondria and a nucleus but no cell wall. Explain why the mitochondria are useful during movement. Does the absence of a wall fit the animal-cell model? Use a structure and its job in each explanation.'''),
    scienceSection('Reveal: connect structures to movement',
        '''Muscle cells use energy when they contract. Mitochondria help release usable energy from food, so many mitochondria fit a cell with high energy needs. No cell wall fits the typical animal-cell model. The nucleus alone does not distinguish animal from plant cells because typical cells of both groups have nuclei.''',
        reveal: true),
    scienceSection('Read evidence carefully',
        '''A microscope image records what can be seen in a particular sample with particular equipment. A diagram is a model: it may enlarge tiny parts, remove overlapping structures and add colors. Use its key before identifying parts. Not every structure in a diagram can be seen clearly through a classroom light microscope.

An observation describes visible evidence, such as repeated outlines in a prepared image. An inference explains evidence using prior knowledge, such as suggesting those outlines are cell walls. If a nucleus is not visible, it may be difficult to see or outside the slice shown. Do not immediately claim that the cell has no nucleus.'''),
    scienceVisual('sci-g5-1-evidence',
        'Ask what is directly visible and what depends on a model or further evidence.'),
    scienceSection('Safe model investigation',
        '''Use a teacher-provided microscope photograph or a prepared slide with adult guidance. Do not collect body fluids or cut living tissue. Draw five adjacent cells from the image. Label only the parts you can identify confidently, and mark uncertain parts with a question. Compare your drawing with a labeled model. Record one useful simplification and one limitation of that model. Handle glass slides only as instructed; a photograph gives a safe alternative.'''),
    scienceSection('Common mistakes',
        '''A cell wall and membrane are different structures; a plant cell has both. Plants have mitochondria as well as photosynthetic cells with chloroplasts. Not all plant cells contain chloroplasts. A nucleus holds instructions rather than doing every job by itself. A missing label or invisible part is not proof that the structure is absent. Large bodies contain cooperating cells, not just larger versions of a single cell.'''),
    scienceSection('Quick check',
        'Which boundary controls entry and exit? Which evidence helps distinguish the plant-cell model? Why might an image fail to show a nucleus?'),
    scienceSection('Check your thinking',
        'The cell membrane controls movement. A cell wall and large central vacuole support the plant-cell comparison. A nucleus may not be clear because of sample preparation, the slice shown or the limits of the microscope.',
        reveal: true),
    scienceSection('Recap',
        'Cells are living units with cooperating structures. Link each labeled part to its function, compare evidence rather than diagram colors, and connect specialized cells to tissues, organs and systems. Use models to explain, while remembering their limits.'),
  ],
  keyConcept:
      'Cells carry out life activities; their structures support particular jobs, and specialized cells cooperate to form tissues, organs and systems.',
  questions: [
    [
      'What is a cell?',
      'The smallest unit carrying out basic life activities',
      'A group of organs working together',
      'A tissue made of several organs',
      'Only the part containing genetic instructions',
      'A cell is a living unit, whereas tissues and organs contain cooperating cells.',
      'Living units'
    ],
    [
      'Which cell structure controls substances entering and leaving?',
      'Cell membrane',
      'Nucleus',
      'Mitochondrion',
      'Central vacuole',
      'The membrane controls movement across the cell boundary.',
      'Membrane'
    ],
    [
      'Where are most genetic instructions located in the typical cells studied here?',
      'Nucleus',
      'Cell wall',
      'Central vacuole',
      'Cell membrane',
      'The nucleus contains most genetic instructions in these plant and animal cells.',
      'Nucleus'
    ],
    [
      'Which description fits cytoplasm?',
      'Interior material containing fluid and many cell structures',
      'The firm layer outside a plant membrane',
      'The structure holding most genetic instructions',
      'Only the empty space between neighboring cells',
      'Cytoplasm includes the interior material outside the nucleus in these cells.',
      'Cytoplasm'
    ],
    [
      'Which structures help release usable energy from food?',
      'Mitochondria',
      'Cell walls',
      'Central vacuoles',
      'Cell membranes only',
      'Mitochondria support energy release in typical plant and animal cells.',
      'Mitochondria'
    ],
    [
      'Which structure captures light energy in a photosynthetic leaf cell?',
      'Chloroplast',
      'Nucleus',
      'Cell wall',
      'Central vacuole',
      'Chloroplasts capture light for photosynthesis.',
      'Chloroplasts'
    ],
    [
      'What do related cells working together form?',
      'A tissue',
      'An organ containing several tissue types',
      'A single enlarged cell',
      'An organ system directly',
      'A tissue consists of related cooperating cells; an organ contains multiple tissue types.',
      'Organization'
    ],
    [
      'Which pair is shared by typical animal and plant cells?',
      'Cell membrane and nucleus',
      'Cell wall and chloroplasts',
      'Chloroplasts and large central vacuole',
      'Cell wall and large central vacuole',
      'Typical cells of both groups have membranes and nuclei.',
      'Comparing cells'
    ],
    [
      'What supports a plant cell outside its membrane?',
      'Cell wall',
      'Cytoplasm',
      'Nucleus',
      'Mitochondrion',
      'The wall is an additional outer support, not a replacement for the membrane.',
      'Cell wall'
    ],
    [
      'Which statement about many underground root cells is correct?',
      'They lack chloroplasts but are still plant cells',
      'They become animal cells without chloroplasts',
      'They need no membrane because they have walls',
      'They contain chloroplasts simply because all plants are green',
      'Many root cells are not photosynthetic and lack chloroplasts.',
      'Plant cell variation'
    ],
    [
      'Why do plant cells need mitochondria even if the plant makes sugars?',
      'They need to release usable energy from food',
      'They need a firm outer layer around the membrane',
      'They need to capture light directly to make sugars',
      'They need a large storage space for water',
      'Making sugars and releasing usable energy from food are different cell activities.',
      'Energy in plant cells'
    ],
    [
      'Which sequence follows levels from smaller units to larger cooperation?',
      'Cell, tissue, organ, organ system',
      'Organ, cell, organ system, tissue',
      'Tissue, organ system, cell, organ',
      'Cell, organ system, tissue, organ',
      'Related cells form tissues; tissues cooperate in organs; organs cooperate in systems.',
      'Organization'
    ],
    [
      'How can a large central vacuole help a mature plant cell?',
      'Its fluid helps keep the cell firm',
      'It stores most of the genetic instructions',
      'It controls passage through the outer membrane',
      'It captures the light used in photosynthesis',
      'A water-filled central vacuole helps support firmness in many mature plant cells.',
      'Vacuole'
    ],
    [
      'What is a useful difference between a diagram and a microscope image?',
      'A diagram can simplify and color selected structures',
      'A diagram always shows actual structure colors',
      'An image must show every structure in a cell',
      'An image has no limits from equipment',
      'A diagram is an explanatory model; microscope visibility depends on equipment and preparation.',
      'Model limitations'
    ],
    [
      'A drawing shows a wall and large vacuole but no chloroplasts. Which conclusion is supported?',
      'It fits a plant-cell model, possibly a nonphotosynthetic cell',
      'It must be an animal cell because chloroplasts are absent',
      'It cannot be living because no chloroplasts are drawn',
      'It is certainly from one particular leaf species',
      'Plant cells may lack chloroplasts; the wall and vacuole are useful evidence in this comparison.',
      'Structural evidence'
    ],
    [
      'A muscle cell contains many mitochondria. Which explanation connects structure to function?',
      'Contraction requires usable energy released from food',
      'Mitochondria store the instructions for every movement',
      'Mitochondria make a rigid wall for contracting cells',
      'Contraction uses sunlight captured by mitochondria',
      'Working muscles require usable energy, and mitochondria help release it from food.',
      'Structure and function'
    ],
    [
      'A nucleus is unclear in a microscope image. What should a learner conclude?',
      'More evidence is needed before claiming it is absent',
      'The cell definitely has no nucleus',
      'The sample definitely contains only animal cells',
      'The image identifies its exact tissue without further evidence',
      'An unseen structure may be unclear because of preparation or instrument limits.',
      'Evidence limits'
    ],
    [
      'Why does a root hair cell have an extended shape?',
      'It gives more contact for taking in water and minerals',
      'It mainly provides a light-capturing surface for photosynthesis',
      'It mainly supplies rigid support for the whole stem',
      'It mainly stores the genetic instructions used by all root cells',
      'Specialized cell shapes can support a particular job.',
      'Specialized cells'
    ],
    [
      'A learner says the heart is just one huge muscle cell. What corrects this?',
      'The heart is an organ containing multiple tissues and many cells',
      'The heart is one tissue type and nothing else',
      'The heart is the complete circulatory system by itself',
      'Each heart muscle cell is already a complete organ',
      'A heart contains cooperating tissues, and those tissues contain cells.',
      'Levels in the body'
    ],
    [
      'Which classroom record is a direct observation rather than an explanation?',
      'Five neighboring outlines are visible in the image',
      'The outlines must be cell walls of plant cells',
      'The cells are specialized for taking up water',
      'The sample must come from a particular plant species',
      'Reporting visible outlines is an observation; identifying unseen features requires inference.',
      'Observation and inference'
    ],
    [
      'Two models both have nuclei and membranes; only one has a wall. Which comparison is justified?',
      'The walled model fits a plant cell better in this comparison',
      'The model without a wall must lack cytoplasm',
      'The nucleus proves both are photosynthetic leaf cells',
      'The wall means its membrane is absent',
      'The shared structures do not distinguish these groups; the wall is useful distinguishing evidence.',
      'Mastery comparison'
    ],
    [
      'A plant wilts after losing water. Which taught structure helps explain reduced cell firmness?',
      'A central vacuole with less water',
      'A nucleus containing fewer instructions',
      'A chloroplast receiving less light',
      'A cell wall controlling water entry by itself',
      'Water in central vacuoles supports firmness; water loss can reduce that support.',
      'Mastery function'
    ],
    [
      'A colored model clearly shows mitochondria that are unclear in a classroom image. Which statement is strongest?',
      'The model explains structures beyond what this image clearly shows',
      'The image proves mitochondria occur only in models',
      'The model proves every cell has the same number of mitochondria',
      'The colors prove mitochondria look identical in living cells',
      'Models select and simplify structures; visibility and actual appearances vary.',
      'Mastery evidence'
    ],
  ],
);

final _foodWebs = scienceTopic(
  grade: 'g5',
  order: 2,
  title: 'Food Webs',
  subtitle:
      'Trace energy routes and reason about changes in connected populations',
  minutes: 'About 35–40 minutes',
  objectives: [
    'Trace at least two food chains within a branched food web.',
    'Explain the roles of producers, consumers and decomposers.',
    'Distinguish energy transfer from the recycling of materials.',
    'Predict a possible population change and identify evidence needed to test it.',
  ],
  introduction:
      'A hawk can eat a rabbit or a frog. Both feeding routes connect back to plants. What might happen to the hawk if one prey population declines? A food web helps us reason about several connections at once.',
  prerequisiteTopicId: 'science.g5.cells-introduction',
  sections: [
    scienceSection('A chain is one route through a web',
        '''A food chain follows one sequence of feeding relationships. A food web connects several chains that share organisms. In a meadow model, grass is eaten by rabbits and grasshoppers. Frogs eat grasshoppers. Hawks eat rabbits and frogs. The hawk therefore connects two routes: grass → rabbit → hawk and grass → grasshopper → frog → hawk.

Every food arrow points from the food to the eater receiving energy. Grass → rabbit means the rabbit eats grass; it does not mean grass eats rabbits. Start at the tail of each arrow and finish at its point. Arrows represent particular feeding links, not general friendship, shelter or the direction an animal runs.'''),
    scienceVisual('sci-g5-2-web',
        'Trace the shorter rabbit route and the longer grasshopper-and-frog route to the same hawk.'),
    scienceSection('Different roles in the same system',
        '''Green plants are producers because they make food using light energy, water and carbon dioxide. The sugars they make contain stored chemical energy. Consumers obtain food by eating other organisms. A rabbit eating grass is a herbivore. A hawk eating animals is a carnivore. An animal eating both plant and animal foods is an omnivore. Its role depends on its actual feeding, not only its size.

Decomposers, including many fungi and bacteria, obtain food from dead material and waste. They act on material from producers and consumers throughout the web. They are not just the final animal in one chain. Animals that eat dead material can help break it into pieces, while fungi and bacteria perform important further breakdown.'''),
    scienceSection('Energy moves; materials can cycle',
        '''Sunlight supplies the original energy for this meadow model. Producers store some of that energy in food. Eating transfers some food energy to a consumer. Organisms use energy in life activities, and energy spreads to the surroundings as heat. Only some of the energy in one organism becomes available to the next eater. Longer feeding routes therefore involve further transfers and energy spreading.

Materials take a different route. Decomposition can return mineral nutrients to soil. Plants may take up those nutrients again. Nutrients are materials, not an energy source replacing sunlight. A drawing with nutrients returning to plants must not be read as energy returning to the Sun or endlessly recycling through organisms.'''),
    scienceVisual('sci-g5-2-materials',
        'Separate the return of materials from the transfer and spreading of energy.'),
    scienceSection('Competition and alternative foods',
        '''When two populations use the same limited resource, they may compete. In our simplified web, rabbits and grasshoppers both use grass. Competition becomes more likely if available grass is scarce. The hawk has two shown foods, so a decline in rabbits does not automatically mean it has no food. Frogs provide another route, although their amount and availability matter.

A food web represents selected relationships, not the complete ecosystem. Weather, water, disease, shelter and movement also affect populations. A population is a group of the same kind of organism living in an area. A feeding link helps explain a possible change, but it cannot by itself give an exact future population count.'''),
    scienceSection('Worked example: reduced grass growth',
        '''A dry period reduces grass growth. Step 1: locate the changed resource at the producer level. Step 2: follow direct links. Rabbits and grasshoppers may have less food, so their populations could decline or move elsewhere. Step 3: follow indirect links. Fewer grasshoppers may leave frogs with less prey. Step 4: examine alternatives. Hawks may have fewer rabbits and frogs, but other foods not shown could matter.

State the prediction with a reason: hawk numbers might decline if reduced prey limits their food. Avoid claiming that every hawk will disappear. To test the explanation, compare grass growth, prey counts and hawk observations across time using consistent methods. Check rainfall and whether animals moved into nearby areas.'''),
    scienceSection('Guided example: fewer hawks',
        '''Suppose hawk numbers decline while grass and water remain similar. Use the web to predict one possible direct change in rabbits, then one possible effect on grass. Explain why the prediction is conditional rather than certain.'''),
    scienceSection('Reveal: work backward along a link',
        '''With fewer hawks eating rabbits, rabbits might increase if other conditions allow. More rabbits could eat more grass, reducing the grass available. This is conditional: disease, other predators, food amount and movement can change the result. Follow each link separately instead of assuming every population changes in the same direction.''',
        reveal: true),
    scienceSection('Survey data and its limits',
        '''The bar chart shows twelve rabbits observed before a dry period and seven afterward in the same area. Subtracting gives five fewer observed rabbits. This is evidence of fewer observations, but it does not prove all five died or that drought was the only cause.

For a fair comparison, use the same area, observation duration and time of day when possible. Repeat surveys because a rabbit hidden in vegetation may be missed. Record grass availability and other conditions alongside counts. These extra records help compare explanations: reduced food, movement away, or changes in how easily rabbits were seen.'''),
    scienceVisual('sci-g5-2-counts',
        'Read the count difference, then ask what additional evidence would help explain it.'),
    scienceSection('Safe field connection',
        '''Observe a garden or meadow from a safe path with an adult. List plants, visible animals and signs such as chewed leaves. Draw only links supported by observation or reliable information about feeding. A bird standing beside a flower does not prove it ate the flower. Do not feed wildlife, touch fungi, disturb nests or collect unknown organisms. You can also build the supplied meadow web on paper and remove one organism card to explore possible effects.'''),
    scienceSection('Common mistakes',
        '''Food arrows point toward the eater, rather than toward what a hunter seeks. Producers make food; soil nutrients do not count as their food energy source. Decomposers work on material from many levels. Energy spreads and needs a continuing supply; mineral nutrients can cycle. A branched web allows alternatives, but alternatives do not guarantee a population will be unaffected by a change.'''),
    scienceSection('Quick check',
        'Name two routes from grass to hawk. Which populations share grass? Can a change in observed rabbit counts alone identify its cause?'),
    scienceSection('Check your thinking',
        'The routes go through rabbit, or through grasshopper and frog. Rabbits and grasshoppers share grass. Counts alone do not identify the cause; feeding, movement, weather and survey evidence help evaluate explanations.',
        reveal: true),
    scienceSection('Recap',
        'A web connects feeding routes. Trace arrows toward consumers, consider shared resources and alternative foods, and distinguish energy flow from material cycling. Make reasoned predictions and test them with repeated, comparable observations.'),
  ],
  keyConcept:
      'Food webs connect energy transfers among organisms; a change can affect several populations, while evidence and alternative routes limit predictions.',
  questions: [
    [
      'What does a food web show?',
      'Several connected feeding chains',
      'Only a single feeding sequence',
      'Only the habitats of animals',
      'Only the number of each organism',
      'A web connects chains that share organisms.',
      'Food webs'
    ],
    [
      'In grass → rabbit, which organism receives food energy?',
      'Rabbit',
      'Grass',
      'Both receive it from the other equally',
      'Neither because arrows show shelter',
      'The arrow points toward the eater, the rabbit.',
      'Arrow direction'
    ],
    [
      'Which organism is a producer in the meadow model?',
      'Grass',
      'Rabbit',
      'Frog',
      'Hawk',
      'Grass makes food using light energy.',
      'Producers'
    ],
    [
      'A hawk eating frogs is acting as which kind of consumer?',
      'Carnivore',
      'Herbivore',
      'Producer',
      'Decomposer',
      'Carnivores eat other animals.',
      'Consumer roles'
    ],
    [
      'Which pair contains common decomposers?',
      'Fungi and bacteria',
      'Grass and leaf cells',
      'Rabbits and grasshoppers',
      'Hawks and frogs',
      'Many fungi and bacteria break down dead material and waste.',
      'Decomposers'
    ],
    [
      'What supplies the original energy for the meadow model?',
      'Sunlight',
      'Soil minerals',
      'Water in roots',
      'Dead leaves alone',
      'Producers use sunlight; minerals and water are materials.',
      'Energy source'
    ],
    [
      'What is a population?',
      'The same kind of organism living in an area',
      'Every living and nonliving part in an area',
      'A sequence of different feeding organisms',
      'All different kinds of animals living in the area together',
      'A population groups organisms of the same kind in an area.',
      'Populations'
    ],
    [
      'Which is a complete route shown from grass to hawk?',
      'Grass → grasshopper → frog → hawk',
      'Grass → frog → grasshopper → hawk',
      'Hawk → rabbit → grass',
      'Rabbit → grasshopper → frog',
      'Each arrow follows a feeding link from food to eater in the taught model.',
      'Tracing routes'
    ],
    [
      'Which organisms share grass as a food resource in this model?',
      'Rabbits and grasshoppers',
      'Frogs and hawks',
      'Hawks and rabbits',
      'Frogs and grasshoppers',
      'Both rabbits and grasshoppers eat grass and may compete if it is limited.',
      'Shared resources'
    ],
    [
      'Why might a hawk still obtain food after rabbits decline?',
      'Frogs provide another shown prey route',
      'Grass is a direct hawk food in this model',
      'The rabbit count cannot affect its predators',
      'The grasshopper-to-frog arrow supplies food directly to hawks',
      'A branched web can show alternative prey, although availability still matters.',
      'Alternative foods'
    ],
    [
      'Which statement separates energy from materials correctly?',
      'Mineral nutrients can return to soil while energy spreads as heat',
      'Energy returns to plants as soil minerals',
      'Both sunlight and minerals cycle identically through the web',
      'Heat from hawks replaces the sunlight needed by grass',
      'Material recycling and energy transfer are different processes.',
      'Energy and matter'
    ],
    [
      'Where can decomposers obtain dead material in a web?',
      'From producers and consumers at many levels',
      'Only from the final predator',
      'Only from living green leaves',
      'Only from soil minerals without dead material',
      'Dead organisms and waste come from many parts of the web.',
      'Decomposer links'
    ],
    [
      'What is likely to make competition for grass stronger?',
      'Less grass available to its consumers',
      'More grass while consumer needs stay similar',
      'Removing one of its consumers with all else similar',
      'A larger grass supply per consumer',
      'Competition concerns shared limited resources.',
      'Competition'
    ],
    [
      'What does 12 rabbits observed before and 7 afterward show?',
      'Five fewer rabbits were observed afterward',
      'Exactly five rabbits certainly died',
      'Drought was proved to be the only cause',
      'Seven rabbits were added to the first count',
      '12 minus 7 is 5; the count difference does not establish deaths or a unique cause.',
      'Reading counts'
    ],
    [
      'Less grass leaves grasshoppers with less food. Which possible indirect effect follows?',
      'Frogs may have fewer grasshoppers to eat',
      'Frogs receive more energy directly from grass',
      'Hawks become unaffected by any prey changes',
      'Frogs gain more grasshopper prey because less grass is available',
      'The next feeding link connects grasshoppers to frogs.',
      'Indirect effects'
    ],
    [
      'Fewer hawks eat rabbits, with other conditions similar. What might happen first?',
      'Rabbit numbers might increase',
      'Rabbit numbers might decline because fewer are hunted',
      'Grass might increase because rabbits face less hunting',
      'Frogs might decline because the web shows them eating hawks',
      'Reduced predation can allow prey to increase; other factors still matter.',
      'Predator changes'
    ],
    [
      'Why is a future exact hawk count unsupported by this web alone?',
      'Weather, movement and prey amounts are not fully described',
      'Feeding arrows give exact future population sizes',
      'Two prey routes guarantee unchanged hawk numbers',
      'The longest chain alone determines every population count',
      'A relationship model lacks the full data needed for exact population prediction.',
      'Prediction limits'
    ],
    [
      'Which observation most directly supports a proposed grasshopper → frog link?',
      'A frog is observed eating a grasshopper',
      'A frog and grasshopper are near the same plant',
      'Both populations are seen increasing in one survey',
      'Frogs are counted in the same month as grasshoppers',
      'Actual feeding supports the link more directly than shared location or survey timing.',
      'Feeding evidence'
    ],
    [
      'Which survey change makes before-and-after rabbit counts harder to compare?',
      'Searching a larger area only in the second survey',
      'Using the same time of day',
      'Keeping observation duration similar',
      'Repeating the same route',
      'Changing area changes the opportunity to see rabbits.',
      'Comparable observations'
    ],
    [
      'A hawk switches to frogs when rabbits decline. Which result is possible?',
      'Frogs experience increased feeding pressure from hawks',
      'Frogs experience less feeding pressure because rabbits declined',
      'Hawks stop depending on animal food while switching prey',
      'The change directly proves grasshopper numbers decreased first',
      'Alternative feeding can change pressure on another prey population.',
      'Connected changes'
    ],
    [
      'Grasshoppers decline but rabbits remain plentiful. Which conclusion best uses this web?',
      'One hawk food route is reduced while another remains available',
      'Every hawk must starve because a single chain changed',
      'The frog route remains unchanged regardless of its prey',
      'The rabbit route must decline by the same amount',
      'The web has two routes; effects depend on food availability along each.',
      'Mastery branching'
    ],
    [
      'After lower rabbit counts, which additional evidence best tests a reduced-food explanation?',
      'Repeated grass measurements and comparable rabbit surveys',
      'Only hawk counts without measuring available grass',
      'Only frog counts without measuring rabbit food',
      'A larger-area rabbit survey without measuring grass',
      'Food measurements and comparable counts test the proposed connection.',
      'Mastery investigation'
    ],
    [
      'A diagram returns mineral nutrients to grass. What label prevents an energy misconception?',
      'Materials recycled; new light energy still enters',
      'Sunlight recycled from consumers to producers',
      'All heat becomes food in the soil',
      'Decomposition supplies the light used by grass',
      'Nutrient return is a material cycle, not a cycle of sunlight energy.',
      'Mastery energy'
    ],
  ],
);

final _propertiesOfMatter = scienceTopic(
  grade: 'g5',
  order: 3,
  title: 'Properties of Matter',
  subtitle:
      'Use measurements and fair comparisons to describe and choose materials',
  minutes: 'About 35–40 minutes',
  objectives: [
    'Distinguish mass, volume and density using appropriate units.',
    'Calculate density from simple mass and volume measurements.',
    'Use more than one physical property to support a material comparison.',
    'Explain how dissolving, filtering and evaporation help separate a familiar mixture.',
  ],
  introduction:
      'A large foam block can have less mass than a small stone. Size alone does not tell us how much matter an object contains. Which measurements help us compare materials fairly?',
  prerequisiteTopicId: 'science.g5.food-webs',
  sections: [
    scienceSection('Matter and physical properties',
        '''Matter has mass and occupies space. Air is matter even though we often cannot see it. Solids, liquids and gases are states of matter, but state alone cannot identify a material: both water and cooking oil are liquids at ordinary room temperature.

A physical property can be observed or measured without changing a substance into a different substance. Color, texture, hardness, flexibility, solubility and magnetic response are examples. Different materials can share a property. Both salt and sugar may appear white, so color alone is weak identification evidence. Combine properties and state the conditions of a test. Never taste an unknown material to identify it.'''),
    scienceSection('Mass is different from volume',
        '''Mass describes how much matter an object or sample contains. A balance measures mass, commonly in grams, written g. Volume describes the space occupied. Liquid volume can be measured with a measuring cylinder in milliliters, written mL. Read the liquid level at eye height using the instrument's instructions; a tilted view can give a misleading reading.

Two samples can have the same volume but different masses. They can also have the same mass but different volumes. Mass is not the same as weight: weight is the pull of gravity on matter. In this lesson we compare balance measurements of mass, rather than calling every measurement in grams a force.'''),
    scienceVisual('sci-g5-3-properties',
        'Match each question about a material to the property that could provide useful evidence.'),
    scienceSection('Density compares mass per volume',
        '''Density tells us the mass for each unit of volume. Calculate density by dividing mass by volume: density = mass ÷ volume. With mass in grams and volume in milliliters, the answer is in grams per milliliter, g/mL. For solid volumes measured in cubic centimeters, the unit can be g/cm³. One milliliter occupies one cubic centimeter.

For the same material under the same conditions, a larger sample usually has more mass and more volume, rather than greater density. A sample twice as large has about twice the mass and volume, so their ratio stays the same. Compare measured mass per volume, not merely which object looks bigger or feels heavier.'''),
    scienceVisual('sci-g5-3-density',
        'Use equal volumes to compare masses, then calculate each density with units.'),
    scienceSection('Worked example: two equal-volume samples',
        '''Two example liquids each occupy 20 mL. Liquid A has mass 40 g; liquid B has mass 20 g. Step 1: write the formula, density = mass ÷ volume. Step 2: substitute A's measurements: 40 g ÷ 20 mL = 2 g/mL. Step 3: calculate B: 20 g ÷ 20 mL = 1 g/mL. Step 4: compare the same units. A has twice as much mass in each milliliter.

This does not identify the liquids by itself. Several materials can have similar measured densities, and temperature or measurement error can affect results. A useful conclusion describes the evidence without claiming more than the test supports.'''),
    scienceSection('Guided example: larger sample, same ratio',
        '''A sample has mass 30 g and volume 10 mL. A second sample of the same material under the same conditions has mass 60 g and volume 20 mL. Calculate both densities. Does having twice the mass mean the second sample is twice as dense?'''),
    scienceSection('Reveal: divide before comparing',
        '''30 ÷ 10 = 3 g/mL, and 60 ÷ 20 = 3 g/mL. Both densities are the same. The second sample contains more matter but also occupies proportionally more space. Comparing mass alone would confuse sample amount with density.''',
        reveal: true),
    scienceSection('Solubility, dissolving and fair tests',
        '''Solubility describes how much of a substance can dissolve in a liquid under stated conditions. When some salt dissolves in water, it becomes distributed through the liquid even though separate grains are no longer visible. The salt has not vanished. Dissolving is different from melting: melting changes a solid to liquid through a state change.

A fair comparison of how samples dissolve keeps water amount, temperature, stirring and sample amount controlled. Time taken to dissolve describes a rate. It is not automatically a measure of the maximum amount that can dissolve. A faster result might reflect smaller grains or more stirring, rather than higher solubility.'''),
    scienceSection('Use differences to separate a mixture',
        '''Consider a known mixture of salt, sand and water. Stirring dissolves the salt, while the sand remains as grains. Filtering can trap sand in a suitable filter. Dissolved salt passes through with water, so ordinary filtering does not produce salt-free water.

If the filtered solution is left safely to evaporate, water can leave as vapor and salt can remain. This separation uses two differences: sand does not dissolve readily in water, and dissolved salt does not evaporate along with the water in this simple situation. A material's properties can therefore guide a method, rather than just providing words to memorize.'''),
    scienceVisual('sci-g5-3-separate',
        'Explain why filtering removes sand but leaves dissolved salt in the liquid.'),
    scienceSection('Safe material investigation',
        '''With an adult, compare a paper strip, a blunt steel paper clip and a piece of aluminum foil. Record color, flexibility and response to a covered magnet. Keep magnets away from electronics and never put objects in your mouth. All three can be bent in this form, but only the steel clip is expected to be attracted strongly. This shows why all metals should not be called magnetic. Do not test hardness by scratching skin or damaging belongings.'''),
    scienceSection('Common mistakes',
        '''Larger volume does not necessarily mean greater mass. Greater mass alone does not prove greater density. Dissolved material can remain present without visible grains. Melting and dissolving are different processes. An ordinary filter removes suitable solid particles, not dissolved salt. A single matching property does not prove two samples are the same substance.'''),
    scienceSection('Quick check',
        'What unit fits liquid volume? What is the density of 24 g in 8 mL? Would an ordinary filter remove dissolved salt?'),
    scienceSection('Check your thinking',
        'Liquid volume may be measured in mL. Density is 24 ÷ 8 = 3 g/mL. An ordinary filter lets dissolved salt pass with the water.',
        reveal: true),
    scienceSection('Recap',
        'Choose properties suited to the question, measure with units and control comparison conditions. Density combines mass and volume. Solubility and particle size help explain separation methods and their limits.'),
  ],
  keyConcept:
      'Physical properties provide evidence about matter; density is mass per volume, and differences in properties help us compare, choose and separate materials.',
  questions: [
    [
      'Which statement describes matter?',
      'It has mass and occupies space',
      'It must be visible and solid',
      'It occupies space but never has mass',
      'It must dissolve in water',
      'Matter includes gases as well as liquids and solids.',
      'Matter'
    ],
    [
      'Which instrument measures mass in this lesson?',
      'Balance',
      'Measuring cylinder',
      'Thermometer',
      'Ruler alone',
      'A balance measures mass; the other tools measure other quantities.',
      'Mass'
    ],
    [
      'Which unit is appropriate for liquid volume?',
      'mL',
      'g',
      'g/mL',
      'Minutes',
      'Milliliters measure volume, while grams measure mass.',
      'Volume'
    ],
    [
      'Which expression calculates density?',
      'Mass ÷ volume',
      'Volume ÷ mass',
      'Mass + volume',
      'Mass × volume',
      'Density is the amount of mass per unit volume.',
      'Density formula'
    ],
    [
      'Which test provides evidence about magnetic response?',
      'Observing whether a magnet attracts the sample',
      'Measuring how much liquid the sample displaces',
      'Bending the sample to compare its flexibility',
      'Using a balance to measure sample mass',
      'Attraction to a magnet tests magnetic response; the other tests examine different properties.',
      'Physical properties'
    ],
    [
      'What happens to salt that dissolves in water?',
      'It becomes distributed through the liquid',
      'It is removed from the mixture immediately',
      'It changes to liquid salt by melting',
      'It all remains as large visible grains',
      'Dissolved salt remains present without separate visible grains.',
      'Dissolving'
    ],
    [
      'What can an ordinary suitable filter remove from salt-and-sand water?',
      'Sand grains',
      'All dissolved salt',
      'The water but none of the sand',
      'Both sand and dissolved salt equally',
      'Sand is retained while the salt solution passes through.',
      'Filtering'
    ],
    [
      'Two samples each occupy 20 mL. One has twice the mass. What follows?',
      'It has twice the density',
      'It has half the density',
      'Their densities must be equal',
      'Density cannot be compared even with both measurements',
      'With equal volume, twice the mass means twice the mass per volume.',
      'Equal-volume comparison'
    ],
    [
      'What is the density of a 40 g sample occupying 20 mL?',
      '2 g/mL',
      '0.5 g/mL',
      '20 g/mL',
      '60 g/mL',
      '40 divided by 20 is 2, with units g/mL.',
      'Density calculation'
    ],
    [
      'Why does doubling both mass and volume leave density unchanged?',
      'The ratio of mass to volume remains the same',
      'Density depends only on the larger mass',
      'Density depends only on the larger volume',
      'Doubling both measurements doubles their ratio',
      'Doubling numerator and denominator leaves their ratio unchanged.',
      'Sample amount'
    ],
    [
      'Which distinction between mass and weight is correct?',
      'Mass is amount of matter; weight is gravitational pull',
      'Mass is occupied space; weight is amount of matter',
      'Mass is gravitational pull; weight is amount of matter',
      'Both words name the same quantity measured in grams',
      'Mass and gravitational force are different quantities.',
      'Mass and weight'
    ],
    [
      'Which observation challenges the idea that all metals are magnetic?',
      'Steel is attracted but aluminum foil is not',
      'Two steel clips are both attracted',
      'The clip can be bent',
      'Foil and a clip both look shiny',
      'Different metals can respond differently to a magnet.',
      'Magnetic materials'
    ],
    [
      'Salt and sugar look white. What does this alone show?',
      'They share a color, but need more evidence for identification',
      'They must be the same substance',
      'They have identical densities',
      'They dissolve in identical amounts under all conditions',
      'Different substances can share one property.',
      'Multiple properties'
    ],
    [
      'Salt dissolves faster after extra stirring. What does this establish most directly?',
      'The dissolving rate changed in that test',
      'Its maximum solubility definitely doubled',
      'The salt melted rather than dissolved',
      'The test proves a greater maximum amount can dissolve',
      'Speed of dissolving and maximum solubility are different measurements.',
      'Rate and solubility'
    ],
    [
      'A 60 g sample occupies 20 mL. What is its density?',
      '3 g/mL',
      '0.33 g/mL',
      '40 g/mL',
      '80 g/mL',
      '60 ÷ 20 gives 3 grams per milliliter.',
      'Applying density'
    ],
    [
      'Samples are 30 g in 10 mL and 60 g in 20 mL. Which comparison is correct?',
      'Both are 3 g/mL',
      'The second is twice as dense',
      'The first is twice as dense',
      'Both are 30 g/mL',
      'Each mass divided by its volume gives 3 g/mL.',
      'Ratio reasoning'
    ],
    [
      'Which change would weaken a comparison of two dissolving rates?',
      'Stirring only one sample while changing the substance',
      'Using equal water volumes',
      'Keeping temperature similar',
      'Using equal sample masses',
      'Changing stirring as well as substance introduces another explanation for a rate difference.',
      'Fair tests'
    ],
    [
      'After sand is filtered out, why might salt remain in the collected liquid?',
      'Dissolved salt passes through the ordinary filter with water',
      'Only the heaviest substances are retained by every filter',
      'Salt melts during ordinary room-temperature filtering',
      'Salt is collected only above the filter while the water passes',
      'Filtering removes suitable particles rather than dissolved salt.',
      'Separation limits'
    ],
    [
      'Which method can leave salt behind from known salt solution without heating?',
      'Allowing the water to evaporate safely',
      'Filtering the same solution once more',
      'Adding more water until the salt vanishes',
      'Letting the dissolved salt settle as if it were sand',
      'Water can leave as vapor while salt remains; an ordinary filter does not trap it.',
      'Evaporation separation'
    ],
    [
      'A foam block is larger than a stone but has less mass. What does this support?',
      'Volume alone does not determine mass',
      'Every larger object contains more matter',
      'The foam has no matter because it is light',
      'The stone must occupy more volume than the foam',
      'Different materials can have different masses at different volumes.',
      'Comparing amount'
    ],
    [
      'An example liquid has 24 g mass in 8 mL. A second is 18 g in 6 mL. Which conclusion follows?',
      'Both have density 3 g/mL',
      'The first has higher density because it has more mass',
      'The second has higher density because it has less volume',
      'The first has density 16 g/mL and the second 12 g/mL',
      '24 ÷ 8 and 18 ÷ 6 both equal 3.',
      'Mastery density'
    ],
    [
      'A clear liquid passes through a filter from salt-and-sand water. Which conclusion is justified?',
      'Sand was removed, but dissolved salt may remain',
      'Clear appearance proves all substances except water were removed',
      'The filter removed salt because its grains were no longer visible',
      'The liquid must have become a new substance',
      'Clear appearance does not establish purity; dissolved salt can pass through.',
      'Mastery separation'
    ],
    [
      'Two unknown samples match in color and magnetic response. What is the strongest next conclusion?',
      'They share those properties; further safe tests are needed to identify them',
      'The two tests prove every property is identical',
      'They must have the same mass regardless of sample size',
      'They must dissolve at the same rate under different stirring conditions',
      'Matching some properties supports comparison but does not uniquely identify substances.',
      'Mastery evidence'
    ],
  ],
);

final _simpleMachines = scienceTopic(
  grade: 'g5',
  order: 4,
  title: 'Simple Machines',
  subtitle:
      'Explain how tools change force, travel and direction without creating energy',
  minutes: 'About 35–40 minutes',
  objectives: [
    'Identify six simple-machine forms in familiar tools and explain their action.',
    'Locate the load, fulcrum and effort in a lever model.',
    'Explain the force-and-distance trade in a ramp or lever.',
    'Design a fair ramp comparison and interpret example force measurements.',
  ],
  introduction:
      'A ramp lets a heavy box reach a platform with a gentler push. The box follows a longer route. How does extra distance help, and why does the ramp still need someone to supply energy?',
  prerequisiteTopicId: 'science.g5.properties-of-matter',
  sections: [
    scienceSection('A machine changes how a force works',
        '''A simple machine is a basic device that changes how an applied force acts. A force is a push or pull. A machine can reduce the force needed, change its direction, or make a useful movement easier to control. It need not contain a motor: a ramp or hand lever can be a machine.

The effort is the force applied to the machine. The load is what the machine moves or acts on. These words describe roles in a particular situation. When lifting an object, gravity pulls the object downward. The machine helps apply a useful force against that pull, but it does not make the object lose its matter or remove gravity.'''),
    scienceSection('Levers: a beam and a pivot',
        '''A lever is a rigid bar that turns around a pivot called the fulcrum. In the shown model, the fulcrum is between the load and the effort. Pushing down on one side lifts the other side. When the effort acts farther from the fulcrum than the load does, a smaller effort force can act on a larger load force.

The trade is travel: the long effort end moves farther while the short load end moves a smaller distance. Moving the fulcrum closer to the load makes the load arm shorter and the effort arm longer if the endpoints stay fixed. Not every lever reduces effort force. Some arrangements help make a load move farther or faster instead.'''),
    scienceVisual('sci-g5-4-lever',
        'Follow the downward effort arrow and upward load-motion arrow on opposite sides of the fulcrum.'),
    scienceSection('Ramps, wedges and screws',
        '''An inclined plane is a sloping surface, such as a ramp. For the same height and similar surface conditions, a longer, gentler ramp generally needs less pushing force than a steep short ramp. The load travels farther. This helps explain wheelchair access ramps as well as loading ramps.

A wedge is a sloping shape pushed into or under material to separate, cut or lift it. Its movement is important: the wedge moves against the material rather than simply giving the load a long route. A screw has an inclined plane wrapped in a spiral. Turning it moves it forward gradually. Its many turns provide a longer effort path for a smaller forward movement.'''),
    scienceSection('Pulleys and linked rotation',
        '''A pulley is a grooved wheel that guides a rope. A single fixed pulley can change the direction of pulling: pull downward to lift a load upward. In an ideal single fixed pulley, the effort force is not reduced; the change in direction can still be useful. Some movable-pulley arrangements reduce effort force, with more rope needing to be pulled.

A wheel and axle uses a larger wheel connected to a smaller axle so they turn together. Turning a large doorknob helps turn its smaller axle. The outside of the wheel travels farther around a circle than the axle surface. Size differences can trade effort force for travel. A compound machine combines simple-machine forms, such as scissors combining levers and cutting wedges.'''),
    scienceVisual('sci-g5-4-types',
        'Explain the action of each form rather than identifying it only by appearance.'),
    scienceSection('Energy still has to come from somewhere',
        '''Machines do not create free energy. In an ideal machine without friction, reducing effort force means applying it through a greater distance for the same lifting task. Real machines also have friction. Some transferred energy spreads to the surroundings through heating, so real tools can require extra input beyond the ideal case.

The useful question is not simply whether a machine makes a task easier. Ask what becomes easier: the size of the push, its direction, the distance moved or control of the motion. A tool that needs less force may still involve a longer movement. This is why a gentler ramp does not promise less total energy use.'''),
    scienceSection('Worked example: comparing ramp readings',
        '''A class compares two ramps reaching the same platform. Example force readings are 12 newtons for the short ramp and 6 newtons for the long ramp. A newton, written N, is a unit of force, not a unit of mass. Step 1: check that both ramps reach the same height and move the same load. Step 2: compare readings in the same units. The long ramp's reading is 6 N lower, half the short ramp's reading. Step 3: connect force to route length. The gentler ramp offers a longer route. Step 4: limit the conclusion to these readings, because friction and setup can vary.'''),
    scienceVisual('sci-g5-4-ramp',
        'Compare the measured force on the shared zero baseline; remember the longer travel.'),
    scienceSection('Guided example: a changed fulcrum',
        '''In the shown lever, the effort and load remain at opposite ends. Move the fulcrum closer to the load. What happens to the effort arm and the load arm? Predict the effort force and explain the travel trade.'''),
    scienceSection('Reveal: compare the two arms',
        '''The effort arm becomes longer and the load arm shorter. This arrangement can reduce the needed effort force. The effort end moves farther than the load, so reduced force comes with increased effort travel rather than free energy.''',
        reveal: true),
    scienceSection('Safe investigation and fair comparison',
        '''With an adult, make a short low ramp from a firm board and books. Move a small toy block gently, keeping fingers clear. Never stand on the ramp or lift heavy loads. Compare two ramp lengths ending at the same low height, using the same block and surface. If a teacher provides a force meter, pull steadily with the same method and repeat readings. Changing load or surface at the same time would make it harder to explain the result. Without a meter, observe route length and slope without claiming a measured force difference.'''),
    scienceSection('Common mistakes',
        'A simple machine need not be electric. A fixed pulley can change direction without reducing ideal effort force. A gentler ramp exchanges force for a longer path. Levers have different arrangements, so identify the fulcrum and arms before predicting. Friction means real machines may need additional energy.'),
    scienceSection('Quick check',
        'What is a fulcrum? Which machine gives a sloping route? What changes in a single fixed pulley?'),
    scienceSection('Check your thinking',
        'The fulcrum is the pivot of a lever. An inclined plane provides a sloping route. A single fixed pulley changes pull direction without reducing ideal effort force.',
        reveal: true),
    scienceSection('Recap',
        'Name the form, locate load and effort, then explain force, travel and direction. Compare tools for the same task under similar conditions. Their usefulness comes from changing how energy is supplied and transferred.'),
  ],
  keyConcept:
      'Simple machines change force, distance or direction; reducing effort force involves a travel trade, and real machines also lose useful energy through friction.',
  questions: [
    [
      'What is the effort force applied to a load on a ramp?',
      'A push or pull',
      'The amount of matter',
      'The space a load occupies',
      'Only the distance a load moves',
      'Forces act as pushes or pulls; mass, volume and distance are different quantities.',
      'Force'
    ],
    [
      'Which word names the pivot of a lever?',
      'Fulcrum',
      'Load',
      'Effort',
      'Axle surface',
      'A lever turns around its fulcrum.',
      'Fulcrum'
    ],
    [
      'Which simple machine gives a sloping route to a higher level?',
      'Inclined plane',
      'Fixed pulley',
      'Wheel and axle',
      'Lever',
      'An inclined plane is a ramp.',
      'Inclined plane'
    ],
    [
      'What does effort mean in a machine example?',
      'The force applied to the machine',
      'Only the object being moved',
      'The mass of the fulcrum',
      'Only the height reached',
      'Effort describes the applied force rather than the load or height.',
      'Effort'
    ],
    [
      'Which form uses a grooved wheel to guide a rope?',
      'Pulley',
      'Wedge',
      'Screw',
      'Inclined plane',
      'A pulley guides a rope and can change how force is applied.',
      'Pulley'
    ],
    [
      'Which description fits a screw?',
      'An inclined plane wrapped in a spiral',
      'A straight ramp that never turns',
      'A rope guided around a wheel',
      'A bar rotating only around a central pivot',
      'A screw turns along its spiral inclined-plane form.',
      'Screw'
    ],
    [
      'Which unit measures force?',
      'N',
      'g',
      'mL',
      'g/mL',
      'Newtons measure force; grams measure mass.',
      'Force units'
    ],
    [
      'What can an ideal single fixed pulley do?',
      'Change the pull direction without reducing effort force',
      'Halve effort force in every case',
      'Lift without any applied effort',
      'Reduce both effort force and rope travel for the same lift',
      'Changing direction is useful even when the ideal effort force is unchanged.',
      'Fixed pulley'
    ],
    [
      'For similar surfaces and the same height, why use a longer ramp?',
      'It can require less force over a longer route',
      'It removes the gravitational pull on the load',
      'It gives both a shorter route and less effort force',
      'It creates energy while the load rises',
      'A gentler ramp trades effort force for distance.',
      'Ramp trade'
    ],
    [
      'In the pictured lever, why is the effort arm longer than the load arm?',
      'This arrangement can reduce the needed effort force',
      'The effort end then travels a shorter distance than the load',
      'A longer effort arm requires greater effort force for this load',
      'Both ends then move equal distances around the pivot',
      'A longer effort arm can give greater force at the short load arm.',
      'Lever arms'
    ],
    [
      'Which example uses a wedge action?',
      'A sloping doorstop pushed under a door',
      'A rope passing around a fixed wheel',
      'A doorknob turning its axle',
      'A bar balanced on a pivot',
      'A moving wedge acts under or into material.',
      'Wedge'
    ],
    [
      'Which tool combines lever and wedge actions?',
      'Scissors',
      'A plain ramp',
      'A single fixed pulley',
      'A simple doorknob alone',
      'Scissor handles and pivot act as levers, and cutting edges act as wedges.',
      'Compound machines'
    ],
    [
      'Why does turning a large doorknob help turn a smaller axle?',
      'Its outside travels farther as the connected parts turn',
      'The knob and axle surfaces travel equal distances because they are connected',
      'A larger knob requires less travel than its smaller axle',
      'The smaller axle gives the effort hand a longer path than the knob',
      'Linked sizes allow a force-and-travel trade.',
      'Wheel and axle'
    ],
    [
      'What does friction imply for a real machine?',
      'Some energy spreads as heat, requiring extra input for the task',
      'All input energy becomes useful lifting energy',
      'The load can gain energy without any input',
      'Effort distance no longer matters at all',
      'Friction transfers some energy to surroundings, reducing the useful fraction.',
      'Friction'
    ],
    [
      'A long ramp reads 6 N and a short ramp 12 N. How do the readings compare?',
      'The long ramp reading is half the short ramp reading',
      'The long ramp reading is twice the short ramp reading',
      'Both read the same force',
      'The short ramp reading is 6 g greater',
      '6 is half of 12; N is the appropriate unit for the difference in force.',
      'Interpreting force'
    ],
    [
      'Moving the fulcrum closer to the load, with endpoints fixed, does what?',
      'Lengthens the effort arm and shortens the load arm',
      'Shortens the effort arm and lengthens the load arm',
      'Lengthens both arms by the same amount',
      'Leaves both arm lengths unchanged',
      'The fulcrum divides the fixed bar into two arm lengths.',
      'Lever adjustment'
    ],
    [
      'What must stay the same for a fair ramp-length comparison?',
      'Load, final height and surface conditions',
      'Only the pulling method while load and height change',
      'Load while both height and surface change',
      'Height while load and surface both change',
      'Controlling these variables helps isolate the effect of ramp length.',
      'Fair comparison'
    ],
    [
      'A learner uses a gentler ramp and says it gives free energy. Which explanation corrects this?',
      'Less effort force is applied over a longer route',
      'Less effort force means the load has no weight',
      'The height matters only on a steep ramp',
      'Longer travel removes the need for input energy',
      'Machines trade force and distance rather than creating energy.',
      'Energy reasoning'
    ],
    [
      'A fixed pulley helps someone pull down to raise a flag. What advantage is shown?',
      'A useful change in pull direction',
      'Proof that effort force is always halved',
      'Proof that the flag becomes lighter',
      'A shorter rope movement than flag movement in the ideal setup',
      'This fixed pulley changes direction, not ideal force magnitude.',
      'Choosing a machine'
    ],
    [
      'Which classroom record supports a measured force claim most directly?',
      'Repeated steady-motion force-meter readings',
      'The ramp looking gentler without measurement',
      'Only the ramp lengths without measuring force',
      'Only the block masses without measuring force',
      'Meter readings with a consistent method provide quantitative force evidence.',
      'Measurement evidence'
    ],
    [
      'A lever reduces effort force while lifting the same load. What travel comparison fits the shown arrangement?',
      'The effort end travels farther than the load end',
      'The effort end travels less while also needing less force',
      'The load end travels farther because it lifts against gravity',
      'Both distances must be equal because the bar is rigid',
      'Different arm lengths give different travel distances around the fulcrum.',
      'Mastery lever'
    ],
    [
      'Two ramp trials change both length and surface roughness. Why is the conclusion uncertain?',
      'Either changed variable could affect the force reading',
      'Surface roughness can never affect force',
      'Ramp length cannot affect force under any conditions',
      'Changing two variables gives stronger proof of length alone',
      'Friction and ramp geometry both matter, so changing both obscures the cause.',
      'Mastery investigation'
    ],
    [
      'A machine reduces force but requires longer motion and some frictional heating. Which conclusion is correct?',
      'It changes how effort is supplied and still needs energy input',
      'It supplies more useful energy than it receives',
      'Longer effort travel guarantees less total input energy',
      'Heating proves all input energy lifted the load',
      'The travel trade and friction are consistent with energy transfer, not energy creation.',
      'Mastery energy'
    ],
  ],
);

final _waterCycle = scienceTopic(
  grade: 'g5',
  order: 5,
  title: 'Water Cycle',
  subtitle:
      'Follow branching pathways, changes of state and evidence in a landscape',
  minutes: 'About 35–40 minutes',
  objectives: [
    'Explain evaporation, condensation, precipitation and transpiration using water states.',
    'Trace different pathways through runoff, infiltration and water storage.',
    'Connect sunlight and gravity with water-cycle movement.',
    'Interpret runoff data and distinguish measured evidence from assumptions.',
  ],
  introduction:
      'After rain, a puddle shrinks while water also moves into soil and along a drain. These are different routes for water. Does every drop have to visit the same places in the same order?',
  prerequisiteTopicId: 'science.g5.simple-machines',
  sections: [
    scienceSection('Movement between stores',
        '''The water cycle describes water moving among stores on, above and below Earth's surface. Oceans, lakes, rivers, ice, soil, groundwater and the atmosphere can store water. A store is a place where water remains for some time; it need not be a permanent stop. Water can also be held within living organisms.

There is no single starting point or fixed schedule for every drop. Rain might enter a river quickly, soak into soil, or remain in a lake. Ice can store water for a long time before melting. A cycle diagram helps connect processes, but one tidy loop leaves out many real branches and different storage times.'''),
    scienceVisual('sci-g5-5-paths',
        'Trace one route through a stream and a second route through soil and plants.'),
    scienceSection('Liquid water becomes vapor',
        '''Evaporation changes liquid water into water vapor, a gas. Water vapor is invisible. Evaporation happens at a liquid's surface and does not require boiling. A cool puddle can shrink through evaporation too. Energy is needed for the change; sunlight often supplies energy by warming surfaces. Conditions such as temperature, wind and humidity affect how quickly evaporation occurs.

Plants provide another route to air. Roots take up water, water moves through the plant, and water vapor leaves mainly through openings in leaves. This process is called transpiration. It is connected to evaporation from soil and other surfaces, but its route passes through a living plant first.'''),
    scienceSection('Vapor becomes droplets, then water falls',
        '''Condensation changes water vapor into liquid water. When moist air cools sufficiently, tiny droplets can form. Clouds contain tiny water droplets and/or ice crystals, rather than being made of visible water vapor. Droplets or ice particles can grow and eventually fall as precipitation, including rain, snow or hail. Condensation and precipitation are related but are not the same process.

Droplets forming on the outside of a cold cup illustrate condensation. Water vapor already in surrounding air changes to liquid on the cool surface. The outside water need not have leaked through the cup. A dry outside surface at the start and an intact cup help test that explanation.'''),
    scienceVisual('sci-g5-5-states',
        'For each state change, say what the water was before and what it becomes afterward.'),
    scienceSection('Runoff, infiltration and groundwater',
        '''After precipitation reaches land, some water moves over the surface as runoff. Gravity helps water move downhill into streams and other stores. Some water infiltrates: it enters the ground through spaces in soil and rock. Part may remain in soil and become available to plant roots. Some can move deeper and replenish groundwater.

Groundwater occupies spaces and cracks underground, rather than always forming a large underground lake. It may move slowly and later supply streams or springs. Soil type, existing wetness and surface coverings affect how much water enters the ground. Pavement often allows less infiltration than open soil, so more water may move over its surface.'''),
    scienceSection('Energy and gravity cooperate',
        '''Sunlight supplies much of the energy driving evaporation at Earth's surface. Gravity drives falling precipitation and helps move water downhill and through the ground. Melting and freezing can connect ice stores to liquid-water routes. These processes can happen in different places at the same time; all water does not wait for one stage to finish before another begins.

Water does not disappear when it changes state. However, water available in a particular place can become scarce. A region can receive little rain while its stored water is used or transferred elsewhere. The global water cycle therefore does not guarantee enough clean fresh water at every place and time.'''),
    scienceSection('Worked example: one storm, two routes',
        '''Rain falls on a hillside. Step 1: name the process bringing it from atmosphere to land: precipitation. Step 2: follow a surface route: some rain becomes runoff, enters a stream, then reaches a lake. Step 3: follow a second route: some rain infiltrates soil, enters roots, moves through a plant and leaves by transpiration. Step 4: identify shared later possibilities: vapor can condense into droplets, but not immediately or on a guaranteed timetable.

The routes share the storm but have different steps. A drop stored underground could stay there much longer than water flowing in a stream. Predicting its exact travel time requires more information than this diagram provides.'''),
    scienceSection('Guided example: a covered surface',
        '''A school replaces some open soil with pavement. Assume the same storm and similar slope. Predict one possible change in surface runoff and one in infiltration. What observations would test the prediction?'''),
    scienceSection('Reveal: compare pathways',
        '''More water may run over the paved surface and less may infiltrate there. Compare collected runoff or infiltration observations for the same area, rainfall amount and duration. The result also depends on drains, cracks, soil conditions and slope, so pavement alone does not give an exact runoff amount.''',
        reveal: true),
    scienceSection('Read a runoff investigation',
        '''In an example comparison, equal-area trays with the same slope receive 100 mL of water each. A soil tray produces 25 mL of collected runoff, and a paved-model tray produces 80 mL. Subtracting gives 55 mL more runoff from the paved model.

The measurements support greater collected runoff in that setup. They do not prove that every uncollected milliliter entered groundwater. Some could remain on the tray or in the soil. Keep added water, area, slope and collection time alike, repeat the test and record limitations. Model trays represent selected features; they do not copy an entire landscape.'''),
    scienceVisual('sci-g5-5-runoff',
        'Use the 55 mL difference as measured evidence, then state what the missing water could do.'),
    scienceSection('Observe condensation safely',
        '''With an adult, place cool water in an intact cup on a tray. Dry the outside first and observe whether outside droplets form. Compare with a room-temperature cup in the same place. Record temperatures only if a safe thermometer is available. Use no boiling water or glass cutting. Droplets may be scarce in very dry air, so a missing result does not prove condensation is impossible. Wipe spills to keep the floor safe.'''),
    scienceSection('Common mistakes',
        'Clouds contain droplets or ice, while vapor itself is invisible. Evaporation does not require boiling. Condensation forms liquid droplets; precipitation moves water downward. Runoff and infiltration are different routes. Groundwater commonly fills spaces underground. No fixed timetable makes each drop follow every stage.'),
    scienceSection('Quick check',
        'What state change shrinks a puddle without boiling? Where do cold-cup outside droplets come from? Can uncollected tray water all be counted as groundwater?'),
    scienceSection('Check your thinking',
        'Evaporation changes liquid to vapor. Outside droplets can form from surrounding water vapor by condensation. Uncollected water might be retained or infiltrate, so the runoff measurement alone does not prove it all became groundwater.',
        reveal: true),
    scienceSection('Recap',
        'Trace water stores and name the process on each connection. Distinguish state changes from movement, include plant and underground routes, and use comparable measurements to investigate changes in a landscape.'),
  ],
  keyConcept:
      'The water cycle connects stores through branching routes and state changes; sunlight supplies energy and gravity drives much of water movement.',
  questions: [
    [
      'What happens during evaporation from a puddle\'s surface?',
      'Liquid water changing into water vapor',
      'Water vapor changing into liquid droplets',
      'Rain falling from a cloud',
      'Water entering spaces in soil',
      'Evaporation is a liquid-to-gas change, not rainfall or infiltration.',
      'Evaporation'
    ],
    [
      'What change can form droplets on the outside of an intact cold cup?',
      'Water vapor changing into liquid droplets',
      'Ice changing into liquid water',
      'Water flowing along the land surface',
      'Liquid water changing into gas',
      'Condensation forms liquid water from vapor.',
      'Condensation'
    ],
    [
      'Which is precipitation?',
      'Rain falling from clouds to the ground',
      'A puddle changing into vapor',
      'Roots taking up soil water',
      'Water moving through underground cracks',
      'Precipitation includes rain, snow and hail falling from the atmosphere.',
      'Precipitation'
    ],
    [
      'Which process sends water vapor from a plant to air?',
      'Transpiration',
      'Infiltration',
      'Runoff',
      'Freezing',
      'Transpiration follows water through plants and into the air as vapor.',
      'Transpiration'
    ],
    [
      'What does runoff describe?',
      'Water moving over the land surface',
      'Only water stored in underground cracks',
      'Only water vapor in a cloud',
      'Water entering leaf openings from air',
      'Runoff follows a surface route, often downhill.',
      'Runoff'
    ],
    [
      'What is infiltration?',
      'Water entering the ground',
      'Water falling from the atmosphere',
      'Water evaporating from a lake',
      'Water stored only as ice',
      'Infiltration takes water into soil and rock spaces.',
      'Infiltration'
    ],
    [
      'What can clouds contain?',
      'Tiny water droplets and/or ice crystals',
      'Only invisible water vapor with no droplets or ice',
      'Only large raindrops already on the ground',
      'Only liquid water in all temperatures',
      'Cloud visibility comes from droplets or ice, while water vapor is invisible.',
      'Clouds'
    ],
    [
      'Why can a puddle shrink on a cool day without boiling?',
      'Evaporation can occur at the surface without boiling',
      'Every shrinking puddle must have boiled first',
      'Condensation changes its liquid into vapor',
      'Only infiltration can reduce the size of any cool puddle',
      'Evaporation does not require the whole liquid to boil.',
      'Evaporation conditions'
    ],
    [
      'Where can outside droplets on an intact cold cup come from?',
      'Water vapor in surrounding air',
      'Only water leaking through the cup wall',
      'Evaporation of liquid directly into outside droplets',
      'Only splashes from the liquid inside the cup',
      'The cool surface can cause nearby vapor to condense.',
      'Condensation evidence'
    ],
    [
      'Which source supplies much energy for evaporation at the surface?',
      'Sunlight',
      'Gravity alone',
      'Soil minerals alone',
      'Plant root uptake alone',
      'Sunlight often warms surfaces and supplies energy for evaporation.',
      'Solar energy'
    ],
    [
      'What helps precipitation fall and runoff move downhill?',
      'Gravity',
      'Condensation alone without a downward force',
      'Sunlight directly pulling liquid downhill',
      'Evaporation directly pushing rain toward the ground',
      'Gravity pulls water downward and supports downhill movement.',
      'Gravity'
    ],
    [
      'Which description of groundwater is accurate?',
      'Water in spaces and cracks underground',
      'Only a large empty underground lake',
      'Only vapor between cloud droplets',
      'All rainwater flowing on the paved surface',
      'Groundwater commonly occupies pore spaces and cracks.',
      'Groundwater'
    ],
    [
      'Which sequence follows a plant route after rainfall?',
      'Infiltration → root uptake → transpiration',
      'Transpiration → runoff → root uptake',
      'Root uptake → precipitation → infiltration',
      'Infiltration → transpiration → root uptake',
      'Water can enter soil, be taken up by roots and leave plants as vapor.',
      'Plant pathway'
    ],
    [
      'What is wrong with claiming every drop follows a fixed daily loop?',
      'Routes and storage times vary',
      'Only oceans contain water stores',
      'Water cannot remain in soil',
      'Condensation always happens at the ground',
      'The water cycle has branches and stores of different duration.',
      'Cycle limitations'
    ],
    [
      'Runoff is 25 mL from soil and 80 mL from a paved model. What is the difference?',
      '55 mL more from the paved model',
      '105 mL more from the paved model',
      '55 mL more from the soil tray',
      '3.2 mL more from the paved model',
      '80 minus 25 equals 55 mL.',
      'Runoff data'
    ],
    [
      'Why should tray area and slope stay alike in a surface comparison?',
      'Both can affect the amount of runoff collected',
      'They ensure every drop takes the same route',
      'They remove all possible measurement error',
      'They prove all missing water became groundwater',
      'Controlling area and slope helps isolate surface differences.',
      'Fair investigation'
    ],
    [
      'What possible effect follows replacing open soil with pavement?',
      'More surface runoff and less infiltration there',
      'More infiltration simply because pavement is firm',
      'No runoff because water cannot enter pavement',
      'Every drop remains permanently above ground',
      'Less permeable covering often shifts water toward surface routes.',
      'Landscape changes'
    ],
    [
      'Why cannot all uncollected tray water be labeled groundwater?',
      'Some may stay on the tray or be held in soil',
      'Collected runoff already includes all underground water',
      'Every uncollected amount must have evaporated immediately',
      'Soil-held water must already have reached deep groundwater',
      'The measurement does not distinguish every possible location of uncollected water.',
      'Evidence limits'
    ],
    [
      'Which route can reach a lake without first passing through a plant?',
      'Rain → surface runoff → stream → lake',
      'Rain → root uptake → transpiration → lake directly',
      'Lake → cloud → soil → rain with no state change',
      'Groundwater → root uptake → leaf tissue only',
      'A surface stream route is one possible pathway independent of plant uptake.',
      'Tracing branches'
    ],
    [
      'Why can a region lack available fresh water despite the global cycle?',
      'Local rain and storage may not meet local use',
      'Cycling water guarantees the same rainfall everywhere',
      'Every store refills each day automatically',
      'All water stores contain equally clean fresh water',
      'Water availability depends on local supplies, storage, quality and transfer.',
      'Local availability'
    ],
    [
      'Both trays receive 100 mL; the soil tray yields 25 mL runoff. What is justified?',
      '75 mL was not collected as runoff, but its exact destination needs evidence',
      '75 mL certainly reached groundwater immediately',
      '25 mL was evaporated because it was collected',
      'The full 100 mL infiltrated because the tray contained soil',
      '100 minus 25 equals 75; retained and infiltrated water need further investigation.',
      'Mastery accounting'
    ],
    [
      'A cold cup forms outside droplets while a nearby room-temperature cup stays dry. Which explanation fits?',
      'The cooler surface favored condensation of air water vapor',
      'Only the cold cup must have a hidden leak',
      'The dry room-temperature cup proves the air contains no water vapor',
      'The comparison proves droplets splashed from inside the cold cup',
      'The comparison supports condensation at the cooler surface, although conditions still matter.',
      'Mastery condensation'
    ],
    [
      'A drop stays underground before later reaching a spring. What does this show about the cycle?',
      'Storage and routes can differ from a short surface loop',
      'Groundwater lies outside the water cycle',
      'Every underground route must finish in one day',
      'Only evaporation can move water into a spring',
      'Groundwater storage and later flow are included in the branching water cycle.',
      'Mastery pathways'
    ],
  ],
);
