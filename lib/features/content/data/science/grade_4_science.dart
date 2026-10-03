import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

final List<NorieTopicContent> grade4ScienceTopics = [
  _ecosystems,
  _humanBodySystems,
  _energy,
  _rocksAndMinerals,
  _earthMoonSun,
];

const Map<String, ScienceFigure> grade4ScienceFigures = {
  'sci-g4-1-interactions': ScienceFigure(
    title: 'A pond is more than a place to live',
    kind: 'comparison',
    labels: ['Living ↔ nonliving', 'Living ↔ living', 'Living ↔ living'],
    details: [
      'Pond plants use sunlight and water to grow.',
      'A snail eats a pond plant for food.',
      'A heron eats a fish; the fish population can change.'
    ],
    note:
        'An interaction is a connection that affects organisms. The pond also includes air, soil and temperature.',
  ),
  'sci-g4-1-chain': ScienceFigure(
    title: 'One food chain in a grassy ecosystem',
    kind: 'process',
    labels: ['Grass', 'Grasshopper', 'Frog', 'Snake'],
    details: [
      'A producer uses sunlight to make food.',
      'A consumer eats grass.',
      'A consumer eats the grasshopper.',
      'A consumer eats the frog.'
    ],
    note:
        'Each arrow means energy in food passes to the eater. It points from food to consumer, not toward what an animal hunts.',
  ),
  'sci-g4-1-recycling': ScienceFigure(
    title: 'Materials can return to an ecosystem',
    kind: 'cycle',
    labels: [
      'Plant grows',
      'Leaf falls',
      'Decomposers act',
      'Materials return'
    ],
    details: [
      'A plant takes in water and mineral nutrients.',
      'A dead leaf becomes available to decomposers.',
      'Fungi and bacteria break down dead material.',
      'Mineral nutrients become available in soil for plants.'
    ],
    note:
        'This cycle follows materials. Energy enters mainly as sunlight and is transferred; it is not recycled in this same loop.',
  ),
  'sci-g4-2-body': ScienceFigure(
    picture: 'g4-body',
    title: 'Organs in a cooperating body',
    kind: 'comparison',
    labels: [
      'Brain and nerves',
      'Lungs',
      'Heart and vessels',
      'Stomach and intestines'
    ],
    details: [
      'Receive information and coordinate responses.',
      'Exchange oxygen and carbon dioxide with blood.',
      'Pump and carry blood around the body.',
      'Break down food and absorb nutrients.'
    ],
    note:
        'Simplified front view: organs overlap in real bodies. The heart is between the lungs and slightly toward the person’s left, which is the picture’s right.',
  ),
  'sci-g4-2-food': ScienceFigure(
    title: 'Follow food, then absorbed nutrients',
    kind: 'process',
    labels: ['Mouth', 'Food tube', 'Stomach', 'Small intestine'],
    details: [
      'Teeth break food into pieces; saliva starts digestion.',
      'The esophagus moves swallowed food toward the stomach.',
      'The stomach mixes food with digestive juices.',
      'Most nutrients pass through the wall into the blood.'
    ],
    note:
        'Food does not travel into the heart. Blood transports absorbed nutrients after digestion. The large intestine absorbs water from remaining material.',
  ),
  'sci-g4-2-moving': ScienceFigure(
    title: 'Several systems help you take a step',
    kind: 'comparison',
    labels: [
      'Nervous system',
      'Muscles and skeleton',
      'Respiratory system',
      'Circulatory system'
    ],
    details: [
      'Signals coordinate the movement.',
      'Muscles pull on bones at joints.',
      'Lungs provide oxygen to blood.',
      'Blood delivers oxygen and nutrients to working muscles.'
    ],
    note:
        'These jobs cooperate. Muscles use energy from food; oxygen helps the body release that energy.',
  ),
  'sci-g4-3-torch': ScienceFigure(
    title: 'Energy changes in a battery torch',
    kind: 'process',
    labels: ['Battery', 'Closed circuit', 'Lamp', 'Surroundings'],
    details: [
      'Stored chemical energy is available.',
      'Energy is transferred electrically.',
      'The lamp gives light and becomes warmer.',
      'Light and heating transfer energy away.'
    ],
    note:
        'A torch changes and transfers energy. It does not create energy when switched on.',
  ),
  'sci-g4-3-transfer': ScienceFigure(
    title: 'Different ways energy reaches another object',
    kind: 'comparison',
    labels: ['Light from the Sun', 'Warm cup to hand', 'Moving ball to pin'],
    details: [
      'Sunlight transfers energy to a surface it reaches.',
      'Contact can transfer energy from warmer to cooler material.',
      'A collision can transfer energy and make the pin move.'
    ],
    note:
        'A transfer moves energy between objects; a change of form can happen at the same time.',
  ),
  'sci-g4-3-ramps': ScienceFigure(
    title: 'One example ball-and-ramp investigation',
    kind: 'bars',
    labels: ['Low start', 'High start'],
    details: ['A pin moves 4 cm.', 'The same pin moves 9 cm.'],
    values: [4, 9],
    unit: 'cm',
    note:
        'Same ball, ramp, pin and release method. These example distances are evidence for this trial, not a rule that doubling height doubles distance.',
  ),
  'sci-g4-4-minerals': ScienceFigure(
    picture: 'g4-rock',
    title: 'Mineral grains can make one rock',
    kind: 'comparison',
    labels: ['Quartz grain', 'Feldspar grain', 'Mica grain', 'Granite rock'],
    details: [
      'One mineral component.',
      'A different mineral component.',
      'Another mineral component.',
      'An example mixture of these mineral grains.'
    ],
    note:
        'The drawing uses enlarged colored patterns to distinguish grains; actual colors and grain sizes vary. Not every rock contains the same minerals.',
  ),
  'sci-g4-4-formation': ScienceFigure(
    title: 'Formation identifies three rock groups',
    kind: 'comparison',
    labels: ['Igneous', 'Sedimentary', 'Metamorphic'],
    details: [
      'Melted rock cools and becomes solid.',
      'Sediments can be compacted and cemented together.',
      'Existing rock changes under heat and pressure without melting.'
    ],
    note:
        'These are common formation routes. Rocks can follow different paths through the rock cycle; not a fixed sequence.',
  ),
  'sci-g4-4-sediments': ScienceFigure(
    title: 'From exposed rock to sedimentary rock',
    kind: 'process',
    labels: [
      'Weathering',
      'Erosion',
      'Deposition',
      'Compaction and cementation'
    ],
    details: [
      'Rock breaks down into smaller pieces.',
      'Water or wind carries pieces elsewhere.',
      'Pieces settle and collect in layers.',
      'Burial presses grains together; natural cement joins them.'
    ],
    note:
        'This is one route, often over very long times. Breaking, transporting and settling are different processes.',
  ),
  'sci-g4-5-daynight': ScienceFigure(
    picture: 'daynight',
    title: 'Rotation brings places into daylight',
    kind: 'comparison',
    labels: ['Facing the Sun', 'Facing away', 'Earth rotates'],
    details: [
      'A place receives direct sunlight: daytime.',
      'A place does not receive direct sunlight: nighttime.',
      'A place moves between the lit and unlit sides.'
    ],
    note:
        'One rotation takes about 24 hours. Sizes and distances in this model are not to scale.',
  ),
  'sci-g4-5-moon': ScienceFigure(
    picture: 'g4-moon',
    title: 'Moon phases: a changing view of the lit half',
    kind: 'comparison',
    labels: ['New Moon', 'Quarter Moon', 'Full Moon'],
    details: [
      'The sunlit half faces mainly away from Earth.',
      'We see half of the Moon’s visible disk lit.',
      'The sunlit half faces mainly toward Earth.'
    ],
    note:
        'Sunlight comes from the left. The top row is a space view; the bottom disks show views from Earth. Distances, sizes and orbit shape are simplified; these positions do not imply an eclipse every month.',
  ),
  'sci-g4-5-motions': ScienceFigure(
    title: 'Match the motion to the repeating pattern',
    kind: 'comparison',
    labels: ['Earth rotates', 'Earth orbits the Sun', 'Moon orbits Earth'],
    details: [
      'About 24 hours: day and night repeat.',
      'About 365 days: one year.',
      'Changing views of its lit half repeat in about a month.'
    ],
    note:
        'Rotate means spin; orbit means travel around another object. The phase cycle is about 29½ days.',
  ),
};

final _ecosystems = scienceTopic(
  grade: 'g4',
  order: 1,
  title: 'Ecosystems',
  prerequisiteTopicId: null,
  subtitle: 'Explain connections between organisms and their surroundings.',
  minutes: '30–35 minutes',
  objectives: [
    'Identify living and nonliving parts of an ecosystem.',
    'Trace energy in a simple food chain.',
    'Explain how decomposers return materials to the environment.',
    'Predict a possible effect of a change using evidence.'
  ],
  introduction:
      'At the edge of a pond, a snail eats a leaf while a heron watches for fish. The water level has dropped after several dry days. Are these separate events, or can one change affect another? An ecosystem is a network of living things and nonliving surroundings that interact. You will follow some of those connections.',
  sections: [
    scienceSection('From a habitat to an ecosystem',
        'A habitat is the place where an organism lives. An ecosystem includes organisms, nonliving parts and their interactions. A pond ecosystem includes plants, snails, fish and tiny living things. It also includes water, sunlight, air, soil and temperature. A tree, a garden or a large forest can be studied as an ecosystem.\n\nLiving organisms need resources from their surroundings. A pond plant needs water and light. A fish needs suitable water and oxygen dissolved in it. Nonliving does not mean unimportant. If a pond becomes too dry, the conditions for its organisms change. To explain an ecosystem, describe a connection, not just a list of things.'),
    scienceVisual('sci-g4-1-interactions',
        'Name what each organism receives or changes in the connection.'),
    scienceSection('Producers and consumers',
        'A producer makes its own food. Green plants use light energy to make food from water and carbon dioxide. Grass and pond plants are producers. They do not eat soil; mineral nutrients in soil support growth but are different from the food they make.\n\nA consumer obtains food by eating organisms or their products. A grasshopper eating grass is a consumer. A frog eating that grasshopper is also a consumer. Herbivores mainly eat plants, carnivores mainly eat animals, and omnivores eat both. These words describe what an animal eats, not whether it is large or small. A tiny insect can eat another animal.'),
    scienceSection('Read a food chain as energy transfer',
        'A food chain shows one feeding route. In grass → grasshopper → frog → snake, the grasshopper eats grass, the frog eats the grasshopper, and the snake eats the frog. The arrows point from the food to the eater. They show the direction that energy stored in food passes.\n\nSunlight supplies energy that the grass uses to make food. Some of this stored energy can reach the animals through feeding. Organisms use energy for living and transfer some to their surroundings as heat. Energy does not travel endlessly around the same circle. Real ecosystems have many feeding routes, but one chain helps us study one connection clearly.'),
    scienceVisual('sci-g4-1-chain',
        'Start at grass and explain each arrow in a complete sentence.'),
    scienceSection('Decomposers return materials',
        'Dead leaves do not stay unchanged forever. Decomposers, including many fungi and bacteria, break down dead organisms and waste. Materials from that breakdown can return to soil and water. Plants can take in mineral nutrients again. Decomposers are living things doing a job, not simply piles of dead leaves.\n\nRecycling materials differs from transferring energy. A mineral nutrient may return to soil and later enter another plant. Energy originally supplied by sunlight passes through organisms and eventually spreads to the surroundings. The Sun keeps supplying new energy. A useful model must say whether its arrows follow materials or energy.'),
    scienceVisual('sci-g4-1-recycling',
        'This loop follows materials returned by decomposition, rather than a loop of reused sunlight.'),
    scienceSection('Worked example: less grass after a dry period',
        'Suppose a dry period reduces grass growth. Step 1: name the changed resource: water. Step 2: connect it to a producer: less water can limit grass growth. Step 3: follow the chain: grasshoppers may have less food. Step 4: frogs may then have fewer grasshoppers to eat.\n\nThis is a possible effect, not a certain count of animals. Grasshoppers might move, and frogs might eat other prey. A prediction should explain its connection and admit what is not yet known. Counting organisms before and after the change would provide evidence.'),
    scienceSection('Guided example: fallen leaves',
        'A gardener removes every fallen leaf from a small garden. What material-returning process has less dead leaf material available? Explain the role of the living things involved.'),
    scienceSection('Reveal: connect leaves and decomposers',
        'Decomposition has less dead leaf material available. Fungi and bacteria break down leaves and return materials that can become available to plants. This does not prove the garden will immediately lose every nutrient: other sources and conditions also matter.',
        reveal: true),
    scienceSection('Observe connections safely',
        'With an adult, observe a garden from a path. Record one producer, one animal if visible, and two nonliving parts. Draw a line between a plant and sunlight, then explain what the line means. Note chewed leaves as evidence of feeding without guessing which animal made them. Do not handle unknown fungi, disturb nests or enter ponds. Leave organisms in place and wash hands after outdoor work.'),
    scienceSection('Common mistakes',
        'An ecosystem includes nonliving parts. A food-chain arrow points toward the organism receiving food energy, not toward its food. Decomposers do not make materials disappear; they change and return them. Removing one resource can affect more than one organism, but a short chain cannot predict every result in a complex ecosystem.'),
    scienceSection('Quick check',
        'What distinguishes an ecosystem from a habitat description? Which organism receives energy in grass → grasshopper? Are mineral nutrients and energy recycled in the same way?'),
    scienceSection('Check your thinking',
        'An ecosystem description includes interactions among organisms and nonliving surroundings. The grasshopper receives food energy. Mineral nutrients can return through decomposition; energy transfers and spreads to the surroundings, so new energy is needed.',
        reveal: true),
    scienceSection('Recap',
        'Describe an ecosystem through connections. Producers make food, consumers obtain it by eating, and decomposers break down dead material. Follow food-chain arrows toward the eater. Use these connections to make careful predictions about changes, then collect evidence to test them.'),
  ],
  keyConcept:
      'An ecosystem’s organisms interact with each other and nonliving surroundings; food transfers energy while decomposition returns materials.',
  questions: [
    [
      'Which description includes an ecosystem interaction?',
      'A snail eating a pond plant',
      'A list of fish living in the pond',
      'The water depth without any connection',
      'A map showing only the pond boundary',
      'Eating connects two living parts of the pond ecosystem.',
      'Ecosystem interactions'
    ],
    [
      'Which is a nonliving part of a garden ecosystem?',
      'Sunlight',
      'Grass',
      'Ant',
      'Fungus',
      'Sunlight is nonliving but provides energy used by producers.',
      'Nonliving factors'
    ],
    [
      'Which organism is a producer in a grassy field?',
      'Grass',
      'Grasshopper',
      'Frog',
      'Snake',
      'Green grass makes food using sunlight, water and carbon dioxide.',
      'Producers'
    ],
    [
      'What makes a frog a consumer?',
      'It obtains food by eating organisms',
      'It lives near producers in a pond',
      'It absorbs water from its surroundings',
      'It needs sunlight to warm its body',
      'Consumers obtain food by eating rather than making it by photosynthesis.',
      'Consumers'
    ],
    [
      'An animal mainly eats plants. Which word fits its diet?',
      'Herbivore',
      'Carnivore',
      'Omnivore',
      'Producer',
      'Herbivores mainly eat plants; they are still consumers.',
      'Feeding roles'
    ],
    [
      'Which pair includes common decomposers?',
      'Fungi and bacteria',
      'Grass and pond plants',
      'Frogs and snakes',
      'Sunlight and water',
      'Many fungi and bacteria break down dead organisms and waste.',
      'Decomposers'
    ],
    [
      'In a food chain, what does an arrow point toward?',
      'The eater receiving food energy',
      'The food the animal is hunting',
      'The producer that supplies all the food',
      'The organism with the most stored energy',
      'Arrows show energy passing from food to the consumer.',
      'Food-chain arrows'
    ],
    [
      'In grass → grasshopper → frog, which eats the grasshopper?',
      'Frog',
      'Grass',
      'Grasshopper',
      'No organism shown',
      'The arrow from grasshopper to frog represents feeding and energy transfer.',
      'Reading food chains'
    ],
    [
      'Where does grass obtain the energy used to make food?',
      'Sunlight',
      'Mineral nutrients from the soil',
      'Water absorbed by the roots',
      'Carbon dioxide taken from the air',
      'Sunlight provides energy; water and carbon dioxide provide food-making materials.',
      'Energy source'
    ],
    [
      'Which statement about soil minerals is correct?',
      'They support growth but are not the plant’s made food',
      'They are the plant’s ready-made food',
      'They are its main food-making energy source',
      'They replace the carbon dioxide used in leaves',
      'Plants use mineral nutrients but make their food using photosynthesis.',
      'Plant resources'
    ],
    [
      'What can decomposers do to a dead leaf?',
      'Return materials to the surroundings',
      'Return all its energy unchanged to plants',
      'Make its mineral nutrients cease to exist',
      'Make new food directly from sunlight',
      'Breaking down dead material returns materials that may become available to plants.',
      'Material recycling'
    ],
    [
      'Which animal diet is omnivorous?',
      'Eating both fruits and insects',
      'Eating grass leaves and tree leaves',
      'Eating insects and small frogs',
      'Making food from water and carbon dioxide',
      'Omnivores eat plant and animal foods.',
      'Feeding roles'
    ],
    [
      'Why is pond water important to fish?',
      'It provides a suitable environment with dissolved oxygen',
      'It supplies all the fish’s food without feeding',
      'It supplies oxygen only above its surface',
      'It lets fish make food from sunlight',
      'Fish depend on suitable water and oxygen dissolved in it.',
      'Nonliving factors'
    ],
    [
      'Which statement compares materials and energy correctly?',
      'Materials can recycle; energy spreads to surroundings',
      'Energy and minerals both repeat one endless loop',
      'Materials disappear; energy returns unchanged to grass',
      'Neither materials nor energy can move between organisms',
      'Decomposition returns materials; energy transfers and eventually spreads as heat.',
      'Matter and energy'
    ],
    [
      'A pond plant gets less sunlight. What is a reasonable first prediction?',
      'It may make less food',
      'It may make more food because it is cooler',
      'It may make the same food regardless of light',
      'It may obtain all its food directly from soil',
      'Less light can limit the food-making process of a producer.',
      'Predicting change'
    ],
    [
      'Drought reduces grass. Which first effect does grass \u2192 grasshopper \u2192 frog predict?',
      'Grasshoppers have less food',
      'Grasshoppers have more grass available',
      'Frogs gain more grasshoppers immediately',
      'The grass supply cannot affect the food chain',
      'Grasshoppers depend on grass for food in the example chain.',
      'Predicting change'
    ],
    [
      'Why can a short food chain not predict exact frog numbers after drought?',
      'Other foods and movements may affect the result',
      'Food chains have no feeding meaning',
      'Water never affects living organisms',
      'Consumers always stay in the same place',
      'The simple chain leaves out other connections and possible movements.',
      'Limits of models'
    ],
    [
      'Chewed leaves are found, but no animal is seen. Which conclusion is best supported?',
      'Some feeding probably occurred',
      'A particular snail certainly made the holes',
      'The leaves prove the plant makes no food',
      'The feeding proves every insect count increased',
      'Chewed leaves support feeding, but do not identify an unseen eater.',
      'Observation evidence'
    ],
    [
      'What would help test a prediction that fewer grasshoppers follow less grass?',
      'Compare grass and grasshopper observations over time',
      'Count grasshoppers once without checking grass',
      'Measure only soil color before the dry period',
      'Use the food chain without collecting observations',
      'Repeated relevant observations can test the predicted connection.',
      'Testing predictions'
    ],
    [
      'A pupil draws dead leaf → bacteria → soil nutrients → plant. What do the arrows follow?',
      'Returning materials',
      'The same sunlight repeatedly returning unchanged',
      'Food energy passing only between animal consumers',
      'Mineral nutrients leaving the ecosystem permanently',
      'The route represents decomposition and reuse of mineral nutrients.',
      'Material recycling'
    ],
    [
      'A garden has plants, beetles, fungi, soil and rain. Which account explains it as an ecosystem?',
      'Rain supplies plants; beetles feed; fungi break down remains',
      'Only organisms matter; rain and soil have no role',
      'Every garden organism makes food from sunlight',
      'Decomposition prevents materials returning to soil',
      'An ecosystem explanation connects living and nonliving parts and their jobs.',
      'Ecosystem interactions'
    ],
    [
      'A snake eats a frog. Which arrow correctly represents this transfer?',
      'Frog → snake',
      'Snake → frog',
      'Grass → snake as a direct meal',
      'Frog → grass as a direct meal',
      'Food energy passes from the frog to the snake that eats it.',
      'Food-chain arrows'
    ],
    [
      'Fallen leaves decay and minerals later enter roots. What conclusion follows?',
      'Decomposers help return materials plants can use',
      'Decomposers return all original energy unchanged',
      'Roots receive ready-made leaf food from minerals',
      'Only consumers can use any returned minerals',
      'Decomposition connects dead material with mineral nutrients available to plants.',
      'Material recycling'
    ],
  ],
);

final _humanBodySystems = scienceTopic(
  grade: 'g4',
  order: 2,
  title: 'Human Body Systems',
  prerequisiteTopicId: 'science.g4.ecosystems',
  subtitle: 'Connect organs to their jobs and explain how systems cooperate.',
  minutes: '30–35 minutes',
  objectives: [
    'Match major organs to digestive, respiratory, circulatory and nervous systems.',
    'Trace food and oxygen along their different routes.',
    'Explain how muscles, bones and nerves help movement.',
    'Describe cooperation among systems during activity.'
  ],
  introduction:
      'You take a bite of breakfast, breathe, and stand up. You do not need to tell your stomach, lungs or heart every step. Your body contains connected teams of parts called systems. Their different jobs cooperate so that you can move, sense your surroundings and stay alive.',
  sections: [
    scienceSection('Organs and systems',
        'An organ is a body part with a particular job, such as the heart, brain or stomach. A body system is a group of parts that work together. One system cannot supply everything the body needs by itself. The lungs bring oxygen into contact with blood, but blood must carry it elsewhere.\n\nThe picture is a simplified front view. Your lungs sit in the chest. The heart sits between them, slightly toward your left. Your stomach and intestines are mainly below the chest. The brain is protected inside the skull. Organs are not loose objects in separate boxes; real systems connect and overlap throughout the body.'),
    scienceVisual('sci-g4-2-body',
        'Locate the organs before matching each to its function. The person’s left appears on your right.'),
    scienceSection('Digestion: food becomes useful nutrients',
        'The digestive system breaks food into smaller pieces and smaller substances the body can use. These useful substances are nutrients. Teeth chew food in the mouth, and saliva begins digestion. Swallowed food moves along the esophagus, a food tube, into the stomach. The stomach mixes food with digestive juices.\n\nFood then enters the small intestine, where digestion continues and most nutrients pass through its wall into blood. Absorb means take in through a surface. The large intestine absorbs water from remaining material; waste later leaves the body. Digestion is more than storing food in a stomach. It prepares nutrients for delivery to other parts.'),
    scienceVisual('sci-g4-2-food',
        'Follow the route of swallowed food. Absorbed nutrients take a different route through blood.'),
    scienceSection('Breathing and circulation connect',
        'The respiratory system moves air into and out of the lungs. Air enters through the nose or mouth and travels down the windpipe. In the lungs, oxygen moves into blood and carbon dioxide moves from blood into the air that will be breathed out. Carbon dioxide is a waste gas produced as the body uses food for energy.\n\nThe circulatory system includes the heart, blood and blood vessels. The heart pumps blood through vessels around the body. Blood carries oxygen from the lungs and absorbed nutrients from digestion to body parts. It carries carbon dioxide back toward the lungs. The heart is a pump; it does not chew food or take air directly from the nose.'),
    scienceSection('Support, movement and coordination',
        'The skeleton supports the body and helps protect organs. The skull protects the brain, and the rib cage helps protect the heart and lungs. A joint is a place where bones meet; many joints allow movement. Muscles pull on bones to move them. A muscle does not push a bone back in the opposite direction: cooperating muscles provide pulls for different movements.\n\nThe nervous system includes the brain, spinal cord and nerves. It receives information from senses and coordinates responses. Seeing a ball helps your brain coordinate a catch. Signals travel along nerves to muscles. Your nervous system also helps control many actions that happen without a conscious decision, including the pattern of breathing.'),
    scienceVisual('sci-g4-2-moving',
        'Taking a step needs coordination, support and supplies, rather than one system alone.'),
    scienceSection('Worked example: walking across a room',
        'Step 1: your senses and nervous system help you choose a clear path. Step 2: nerves coordinate muscles that pull on leg bones at joints. Step 3: working muscles need energy from food and oxygen. The digestive system has supplied nutrients; lungs supply oxygen to blood. Step 4: the heart pumps that blood toward the muscles.\n\nDuring more active movement, breathing and heartbeat often become faster to help meet increased needs. This is evidence that systems cooperate. The legs make the visible movement, but the movement depends on parts elsewhere in the body. Being still does not stop these systems: they continue supporting living processes.'),
    scienceSection('Guided example: separate two routes',
        'A learner says, “My lunch goes through my windpipe into my lungs, and the lungs send it to my legs.” Trace the normal route of swallowed food, then explain how nutrients can reach the legs.'),
    scienceSection('Reveal: digestion then delivery',
        'Swallowed food normally travels through the esophagus, stomach and intestines. Nutrients are absorbed mainly in the small intestine into blood. The circulatory system carries them to the legs. Air travels through the windpipe to the lungs; food and air have different normal routes.',
        reveal: true),
    scienceSection('Observe gentle movement',
        'Sit comfortably and notice ordinary breathing. If comfortable and an adult agrees, walk slowly across the room and back. Notice whether breathing changes, then rest. Compare observations without competing over speed or breath-holding. A person can also observe another willing adult or describe a familiar walk. Stop if uncomfortable. This observation explores cooperation, not a diagnosis or a fitness score.'),
    scienceSection('Common mistakes',
        'The stomach is not where all nutrient absorption happens; most occurs in the small intestine. The lungs exchange gases, while the heart pumps blood. Bones do not move themselves: muscles pull them. Breathing and heartbeat continue during rest. Different body systems do different jobs, but their connections make the jobs useful to the whole body.'),
    scienceSection('Quick check',
        'Where do most digested nutrients enter blood? Which organ pumps blood? How do nerves, muscles and bones work together when you lift a hand?'),
    scienceSection('Check your thinking',
        'Most nutrients enter blood through the small intestine. The heart pumps blood. Nervous signals coordinate muscles that pull on bones at joints to lift the hand.',
        reveal: true),
    scienceSection('Recap',
        'Digestion supplies nutrients. Respiration exchanges gases. Circulation transports materials. The skeleton supports and protects; muscles provide pulls for movement. The nervous system receives information and coordinates responses. Explain a body action by connecting several jobs instead of naming just one organ.'),
  ],
  keyConcept:
      'Body systems specialize in different jobs and cooperate to deliver materials, coordinate responses and produce movement.',
  questions: [
    [
      'Which organ pumps blood?',
      'Heart',
      'Stomach',
      'Lung',
      'Brain',
      'The heart is the pump of the circulatory system.',
      'Circulation'
    ],
    [
      'Which system breaks food down into useful nutrients?',
      'Digestive',
      'Respiratory',
      'Skeletal',
      'Nervous',
      'The digestive system prepares nutrients from food for absorption.',
      'Digestion'
    ],
    [
      'Which organs exchange gases between air and blood?',
      'Lungs',
      'Kidneys',
      'Stomach',
      'Bones',
      'Oxygen enters blood and carbon dioxide leaves blood in the lungs.',
      'Respiration'
    ],
    [
      'Where are most digested nutrients absorbed?',
      'Small intestine',
      'Esophagus',
      'Mouth',
      'Large intestine',
      'Most nutrients pass through the small intestine wall into blood.',
      'Absorption'
    ],
    [
      'Which structures carry blood around the body?',
      'Blood vessels',
      'Nerves',
      'Esophagus',
      'Windpipe',
      'Blood vessels form routes through which the heart pumps blood.',
      'Circulation'
    ],
    [
      'Which part helps protect the brain?',
      'Skull',
      'Rib cage',
      'Stomach',
      'Windpipe',
      'The skull is a bony protective covering around the brain.',
      'Skeleton'
    ],
    [
      'Which system includes the brain, spinal cord and nerves?',
      'Nervous',
      'Digestive',
      'Circulatory',
      'Respiratory',
      'These parts receive information and coordinate responses.',
      'Coordination'
    ],
    [
      'Which is the normal route of swallowed food?',
      'Mouth → esophagus → stomach',
      'Mouth → windpipe → lungs',
      'Mouth → heart → stomach',
      'Mouth → nerves → bones',
      'The esophagus carries swallowed food toward the stomach.',
      'Food route'
    ],
    [
      'What moves from air into blood at the lungs?',
      'Oxygen',
      'Carbon dioxide',
      'All the air together',
      'Nutrients from food',
      'Lungs exchange gases, including oxygen entering the blood.',
      'Gas exchange'
    ],
    [
      'What happens to carbon dioxide carried to the lungs?',
      'It enters air that is breathed out',
      'It stays in the lungs rather than being exhaled',
      'It returns unchanged to muscles as their oxygen',
      'It leaves mainly in swallowed food waste',
      'Carbon dioxide moves from blood into lung air and can be exhaled.',
      'Gas exchange'
    ],
    [
      'How do muscles move bones?',
      'They pull on them',
      'They push on them without pulling',
      'Bones pull muscles rather than the reverse',
      'Nerves pull bones without using muscles',
      'Muscles provide pulls that move bones at joints.',
      'Movement'
    ],
    [
      'What is a joint?',
      'A place where bones meet',
      'A connection between a nerve and the brain',
      'A blood vessel branching toward a muscle',
      'A passage from the mouth to the stomach',
      'Many joints allow bones to move relative to each other.',
      'Joints'
    ],
    [
      'Which pair best describes lung and heart cooperation?',
      'Lungs exchange gases; heart pumps blood',
      'Lungs pump blood; heart exchanges gases',
      'Lungs digest food; heart absorbs nutrients',
      'Lungs carry blood; heart takes in outside air',
      'Gas exchange becomes useful throughout the body because blood transports the gases.',
      'System cooperation'
    ],
    [
      'What is an important job of the large intestine?',
      'Absorbing water from remaining material',
      'Absorbing most digested nutrients from food',
      'Mixing newly swallowed food with saliva',
      'Pumping blood to the small intestine',
      'The large intestine absorbs water after food has passed through the small intestine.',
      'Digestion'
    ],
    [
      'Why do moving leg muscles need the circulatory system?',
      'Blood delivers oxygen and nutrients',
      'Blood carries air without exchanging gases',
      'Blood transports whole swallowed food pieces',
      'Blood provides the pulls instead of muscles',
      'Circulation brings materials needed by working muscles.',
      'System cooperation'
    ],
    [
      'A learner sees a ball and catches it. Which connection explains coordination?',
      'Brain and nerves send signals to muscles',
      'Muscles coordinate the catch without nerve signals',
      'Bones receive sight information instead of the brain',
      'The heart chooses the direction of the hand',
      'The nervous system uses sensory information to coordinate muscle movement.',
      'Coordination'
    ],
    [
      'A picture places the heart slightly on its right in a front view. Why can this be correct?',
      'The person’s left appears on the viewer’s right',
      'The heart is normally mainly on the person’s right',
      'The picture is viewed from the person’s back',
      'The heart is normally below both intestines',
      'A front-facing person’s left side is opposite the viewer’s left.',
      'Body location'
    ],
    [
      'Which claim corrects “the stomach absorbs all nutrients”?',
      'Most nutrients enter blood at the small intestine',
      'Most nutrients enter blood in the esophagus',
      'Most nutrients enter blood through the lungs',
      'Most nutrients enter blood in the large intestine',
      'Digestion involves several organs; most nutrient absorption happens in the small intestine.',
      'Absorption'
    ],
    [
      'Why can breathing become faster during active movement?',
      'Working body parts need more oxygen supply',
      'Breathing sends more air directly into leg bones',
      'The lungs begin digesting nutrients during exercise',
      'Breathing replaces the need for circulating blood',
      'Breathing and circulation can increase to help meet the needs of activity.',
      'Activity response'
    ],
    [
      'A person is resting. Which statement is correct?',
      'Breathing and circulation continue',
      'Breathing continues but blood stops circulating',
      'Blood circulates but all nerve signals stop',
      'Digestion waits until the person moves again',
      'Rest does not stop the living processes that systems support.',
      'Continuous functions'
    ],
    [
      'After digestion, how can nutrients from breakfast reach an arm?',
      'Absorption into blood, followed by circulation',
      'Whole food pieces travel in blood to the arm',
      'Nutrients travel along nerves to arm muscles',
      'The stomach sends nutrients straight to the arm',
      'Nutrients enter blood mainly at the small intestine; blood carries them onward.',
      'System cooperation'
    ],
    [
      'Which account explains raising a foot?',
      'Nerves coordinate muscles pulling bones at joints',
      'Muscles push bones while nerves provide no signals',
      'Bones move themselves after receiving oxygen',
      'Nerves pull the foot without muscles acting',
      'Movement combines nervous coordination with muscular pulls and skeletal structures.',
      'Movement'
    ],
    [
      'Which comparison separates respiration from circulation?',
      'Lungs exchange gases; vessels carry blood',
      'Lungs pump blood; vessels exchange gases with air',
      'Lungs absorb nutrients; vessels digest food',
      'Lungs carry air directly to every muscle; blood stays in the chest',
      'Respiration and circulation have different jobs that cooperate in material delivery.',
      'System cooperation'
    ],
  ],
);

final _energy = scienceTopic(
  grade: 'g4',
  order: 3,
  title: 'Energy',
  prerequisiteTopicId: 'science.g4.human-body-systems',
  subtitle: 'Follow energy as it changes form and moves between objects.',
  minutes: '30–35 minutes',
  objectives: [
    'Recognize energy in motion, light, sound, heating and stored forms.',
    'Trace energy changes in a familiar device.',
    'Explain a transfer between objects.',
    'Use fair comparisons as evidence about energy.'
  ],
  introduction:
      'A battery torch gives light, a rolling ball knocks over a pin, and sunshine warms a bench. Each event involves energy. Energy helps cause changes. Instead of just saying that something “has energy,” you will identify where energy starts, how it moves, and what changes you can observe.',
  sections: [
    scienceSection('Recognize forms and stores',
        'A moving object has motion energy. Light and sound can carry energy from a source to another place. A warmer object has more thermal energy than a cooler version of the same object under otherwise similar conditions. Heating transfers energy from warmer to cooler objects. Temperature and energy are related, but they are not the same measurement.\n\nEnergy can also be stored. Food and batteries contain stored chemical energy. A ball held higher above the floor has more stored energy because of its position than the same ball held lower. That stored energy can change into motion energy as the ball falls. An object need not be moving right now to have stored energy.'),
    scienceSection('A torch changes energy',
        'A battery torch begins with stored chemical energy in its battery. When its switch closes a complete circuit, energy is transferred electrically to the lamp. The lamp gives light and also becomes warmer. Follow the whole story: chemical energy in the battery → electrical transfer → light and heating.\n\nThe switch does not create energy. It controls whether the circuit is complete. A used battery has less energy available to transfer than a fresh one. A lamp also does not turn every bit of energy into useful light. Some energy warms the lamp and its surroundings. These effects help explain why a device may warm while doing its main job.'),
    scienceVisual('sci-g4-3-torch',
        'The stages trace energy, rather than claiming that battery material travels into the light.'),
    scienceSection('Transfers connect objects',
        'An energy transfer moves energy from one object or place to another. Sunlight reaching a bench can transfer energy to it and warm it. A hand touching a warm cup can receive energy from the cup by heating. A moving ball hitting a pin can transfer energy and make the pin move.\n\nA change of form and a transfer are connected ideas, but they ask different questions. “Where did the energy go?” asks about transfer. “What kind of energy is involved now?” asks about a change of form. A vibrating speaker transfers energy as sound to its surroundings. Sound is not a substance poured out of a speaker; it involves vibrations spreading through material.'),
    scienceVisual('sci-g4-3-transfer',
        'For each case, name the source, receiver and visible or felt change.'),
    scienceSection('Energy is conserved',
        'Energy is not created from nothing or destroyed during these changes. It is transferred or changes form. A rolling ball eventually stops because energy is transferred to the surroundings, including heating from friction and sometimes sound. The motion energy decreases, but the energy has not simply vanished.\n\nWe sometimes say energy is “used up” in everyday speech. More precisely, energy has moved or changed into forms that are less useful for our purpose. Turning off an unused lamp reduces the transfer of energy from its supply. Energy conservation in science means accounting for energy; saving electricity is a practical action that reduces how much is supplied.'),
    scienceSection('Worked example: compare two ramp starts',
        'A pupil releases the same ball from two heights on one ramp. The ball hits the same light pin. From the lower start the pin moves 4 cm; from the higher start it moves 9 cm. Step 1: the higher ball begins with more stored position energy. Step 2: rolling changes some of it to motion energy. Step 3: the collision transfers some energy to the pin. Step 4: the larger pin movement supports the prediction that the higher start can produce a greater effect.\n\nKeep the ball, ramp, pin and release method the same, without an extra push. Repeat trials because collisions vary. These numbers describe one example, not a promise that every pin will move these distances.'),
    scienceVisual('sci-g4-3-ramps',
        'Both bars measure the pin’s distance from the same zero baseline. The starting heights are categories, not measured by these bars.'),
    scienceSection('Guided example: a stopped toy car',
        'A toy car rolls along a floor, makes a little sound and stops. A learner says its energy has been destroyed. What happened to its motion energy? Use both contact with the floor and sound in your explanation.'),
    scienceSection('Reveal: follow energy outward',
        'The car transfers energy to its surroundings. Friction contributes to heating, and sound carries some energy away. Less remains as the car’s motion energy. Stopping is a change in where energy is and its form, rather than energy disappearing.',
        reveal: true),
    scienceSection('Try a low ramp safely',
        'With an adult, make a short low ramp from a book and sturdy card on the floor. Roll a large toy ball toward a lightweight paper cup. Keep the same ball and cup position for each trial; mark the cup’s movement. Compare two low starting positions and repeat. Keep fingers away from the rolling path and clear the floor of people and pets. Do not use stairs, heavy objects, hot appliances or electrical wiring.'),
    scienceSection('Common mistakes',
        'A still battery can store energy. A lamp supplies heating as well as light. A moving object that stops has transferred energy rather than destroyed it. A longer bar here means farther pin movement, not a direct measurement of energy. A fair test changes the chosen starting height while keeping other important conditions alike.'),
    scienceSection('Quick check',
        'What energy store begins the torch story? How can a moving ball transfer energy to a pin? Why does a stopped ball not show that energy was destroyed?'),
    scienceSection('Check your thinking',
        'The battery stores chemical energy. A collision can transfer energy and move the pin. Energy from a slowing ball transfers to the surroundings, including heating and sound.',
        reveal: true),
    scienceSection('Recap',
        'Recognize energy in stores and observable changes. Trace a source, transfer and receiver. Devices can change energy into several forms at once. Energy is conserved even when it spreads into the surroundings. Use fair comparisons and repeated observations to test predictions about an effect.'),
  ],
  keyConcept:
      'Energy is transferred and changes form; it is not created or destroyed when an object lights, warms, moves or stops.',
  questions: [
    [
      'Which energy does a rolling ball have because it moves?',
      'Motion energy',
      'Stored chemical energy',
      'Stored position energy only',
      'Light energy',
      'Movement is evidence of motion energy.',
      'Energy forms'
    ],
    [
      'Which object stores chemical energy for a torch?',
      'Battery',
      'Switch',
      'Lens',
      'Wire covering',
      'The battery supplies stored chemical energy.',
      'Chemical energy'
    ],
    [
      'Which pair describes two outputs of a working lamp?',
      'Light and heating',
      'Light only, with no heating',
      'Heating only, with no light',
      'Light and stored chemical energy returned to the battery',
      'A lamp gives light and also warms itself and its surroundings.',
      'Device outputs'
    ],
    [
      'Compared with the same ball lower down, a ball held higher has more of which store?',
      'Stored position energy',
      'Stored chemical energy',
      'Sound energy',
      'Light energy',
      'A greater height above the floor increases the ball’s stored position energy.',
      'Position energy'
    ],
    [
      'What does an energy transfer do?',
      'Moves energy between objects or places',
      'Creates energy from nothing',
      'Makes energy cease to exist',
      'Always keeps energy in one object',
      'Transfer describes where energy goes.',
      'Energy transfer'
    ],
    [
      'Energy transferred by heating normally goes in which direction?',
      'From warmer to cooler',
      'From cooler to warmer by itself',
      'Only between equally warm objects',
      'Only from moving to resting objects',
      'Heating transfers energy from a warmer object to a cooler one.',
      'Heating'
    ],
    [
      'Which statement expresses energy conservation?',
      'Energy transfers or changes form without being destroyed',
      'Energy always stays as motion',
      'Energy is made whenever a switch closes',
      'Energy disappears whenever a ball stops',
      'Conservation means accounting for energy across changes and transfers.',
      'Conservation'
    ],
    [
      'Which sequence accounts for both a battery torch\u2019s light and warming?',
      'Chemical store → electrical transfer → light and heating',
      'Electrical store → chemical transfer → light only',
      'Chemical store → electrical transfer → light only',
      'Light store → electrical transfer → chemical heating',
      'Energy begins in the battery and reaches the lamp electrically.',
      'Torch pathway'
    ],
    [
      'What does closing a torch switch normally control?',
      'Whether the circuit is complete',
      'Whether the lamp produces chemical energy',
      'Whether the battery stores more energy while glowing',
      'Whether all supplied energy becomes light',
      'The switch completes a route for electrical energy transfer.',
      'Torch circuit'
    ],
    [
      'A ball strikes a pin and the pin moves. What has occurred?',
      'Energy transferred from ball to pin',
      'The ball’s energy remained entirely in the ball',
      'The pin’s new motion needs no energy transfer',
      'The ball’s motion energy was entirely destroyed',
      'The collision can transfer energy to the pin’s movement.',
      'Collision transfer'
    ],
    [
      'A sunny bench gets warmer. Which is the source of transferred energy?',
      'Sunlight reaching the bench',
      'The bench’s shadow supplying heating',
      'The bench reflecting all arriving light unchanged',
      'The air supplying all warming regardless of sunlight',
      'Light from the Sun transfers energy when it reaches the bench.',
      'Light transfer'
    ],
    [
      'What question focuses on a transfer?',
      'Where did the energy go?',
      'What form does the energy have now?',
      'How much energy remains stored in this object?',
      'Is the object moving or standing still?',
      'A transfer explains energy moving to another object or place.',
      'Energy reasoning'
    ],
    [
      'Why can a lamp become warm while shining?',
      'Some supplied energy produces heating',
      'All energy became light, so none caused heating',
      'The warmth means energy was created by the lamp',
      'Only the battery can warm; the lamp cannot',
      'A device can have more than one energy output.',
      'Device outputs'
    ],
    [
      'Which describes sound carrying energy?',
      'Vibrations spread through material',
      'Light reflected from a vibrating surface',
      'Stored chemical energy remaining in a speaker',
      'A moving object’s height increasing',
      'Sound involves spreading vibrations and can carry energy away.',
      'Sound transfer'
    ],
    [
      'Which change can explain a rolling car slowing on a floor?',
      'Friction transfers energy to surroundings',
      'Its energy vanishes as soon as it stops',
      'Friction creates new energy in the wheels',
      'Its motion energy stays the same while slowing',
      'Contact effects transfer energy, reducing the energy of motion.',
      'Slowing objects'
    ],
    [
      'In the ramp test, which should stay the same while start height changes?',
      'Ball, ramp and pin',
      'The ball only, while ramp and pin change',
      'The pin only, while ball and ramp change',
      'The ramp only, while ball and pin change',
      'Keeping the apparatus and release method alike supports a fair comparison.',
      'Fair comparison'
    ],
    [
      'Why should the ramp ball be released without an extra push?',
      'A push adds another changing influence',
      'A push makes the effect depend only on height',
      'A push keeps all starting energy the same',
      'A push removes variation in every collision',
      'An extra push would make it harder to isolate the effect of starting height.',
      'Fair comparison'
    ],
    [
      'The bars show 4 cm and 9 cm. What do they measure directly?',
      'Pin movement distance',
      'Energy stored in the ball',
      'Temperature of the ramp',
      'Battery energy supplied',
      'The unit cm measures distance, so these bars are evidence of movement.',
      'Reading evidence'
    ],
    [
      'Why repeat the ball-and-pin trials?',
      'Collisions and measured distances can vary',
      'One trial gives a certain result for every release',
      'Repeating changes the starting-height question',
      'Repeated trials remove the need to measure distance',
      'Repeated observations help judge whether a result is consistent.',
      'Repeated evidence'
    ],
    [
      'Which explains why turning off an unused lamp saves supplied energy?',
      'It reduces transfer from the supply',
      'It destroys energy that was already supplied',
      'It returns all past heating to the battery',
      'It changes every surrounding energy form into light',
      'Switching off reduces how much energy the device receives from its supply.',
      'Saving energy'
    ],
    [
      'A torch glows and warms. Which conclusion accounts for both effects?',
      'Supplied energy has more than one output',
      'The warmth proves new energy was created',
      'All supplied energy became useful light',
      'Energy conservation stopped when the lamp warmed',
      'The battery’s energy can produce light and heating at the same time.',
      'Conservation'
    ],
    [
      'A higher ramp start moved a pin farther once. What should the investigator do next?',
      'Repeat with the same equipment and release method',
      'Declare all higher starts always double distance',
      'Replace the ball and ramp before comparing',
      'Record the result as a direct energy measurement',
      'Repeated fair trials check the pattern without claiming a universal numerical rule.',
      'Interpreting evidence'
    ],
    [
      'A rolling ball stops with a faint sound. Which account is best?',
      'Energy spread into sound and heating of surroundings',
      'Its energy was destroyed when motion ended',
      'All energy remained as unchanged ball motion',
      'Sound proves the ball created energy from nothing',
      'A decrease in motion energy is balanced by energy transfers and changes elsewhere.',
      'Conservation'
    ],
  ],
);

final _rocksAndMinerals = scienceTopic(
  grade: 'g4',
  order: 4,
  title: 'Rocks & Minerals',
  prerequisiteTopicId: 'science.g4.energy',
  subtitle:
      'Use composition, properties and formation to explain Earth materials.',
  minutes: '30–35 minutes',
  objectives: [
    'Distinguish a mineral from a rock using examples.',
    'Compare properties without relying on color alone.',
    'Explain common formation routes for three rock groups.',
    'Separate weathering, erosion and deposition in a sequence.'
  ],
  introduction:
      'Look closely at granite: different grains may sit together in one solid piece. Now imagine a smooth pebble of one color. Are a rock and a mineral the same thing? Scientists study what Earth materials contain, their observable properties, and how they formed. These clues tell more than appearance alone.',
  sections: [
    scienceSection('Minerals are ingredients of many rocks',
        'A mineral is a naturally occurring, usually inorganic solid with an orderly inner structure and a particular chemical composition. Inorganic means not made from living material in the usual mineral definition. At this level, think of a mineral as a distinct natural material rather than any object dug from the ground. Quartz, feldspar and mica are examples. Different minerals have different properties.\n\nA rock is a solid natural Earth material that can contain a mixture of minerals. Granite commonly contains quartz, feldspar and mica as visible grains. The whole granite piece is a rock; a quartz grain is a mineral component. Some rocks contain mainly one mineral, so count of visible colors alone cannot settle the distinction. A rock is not automatically one mineral just because it looks uniform.'),
    scienceVisual('sci-g4-4-minerals',
        'The enlarged pattern shows different mineral grains joined in a single rock.'),
    scienceSection('Properties give several clues',
        'Color is easy to observe but can be misleading: different minerals can share a color, and one mineral can occur in different colors. Luster describes how a surface reflects light, such as glassy or dull. Hardness means resistance to scratching, rather than how heavy a sample feels. A softer material can be scratched by a harder one.\n\nTexture describes features such as visible grain size, roughness or layers in a rock. These observations help compare samples, but one clue rarely proves a name. A shiny sample is not automatically valuable metal, and a smooth river pebble is not automatically soft. Its surface may have been worn smooth while the material remained hard.'),
    scienceSection('Three rock groups by formation',
        'Igneous rock forms when melted rock cools and becomes solid. Melted rock underground is called magma; at the surface it is called lava. Granite is an igneous example that formed from magma underground.\n\nMany sedimentary rocks form from sediments: small pieces of rock or other material. Layers accumulate, burial compacts them, and natural minerals can cement grains together. Sandstone is an example made from sand-sized grains. Metamorphic rock forms when existing rock changes under heat and pressure without melting. Marble can form from limestone this way. If rock melts and later cools, the resulting rock is igneous, not metamorphic merely because heat was involved.'),
    scienceVisual('sci-g4-4-formation',
        'Ask what happened to the material, rather than assigning a group by color.'),
    scienceSection('Pieces have a route too',
        'Weathering breaks down exposed rock where it is. Cracks and repeated action of water can help make smaller pieces. Erosion transports pieces, for example when running water carries sand downstream. Deposition happens when carried material settles in a new place. These words describe different jobs: break down, move, and settle.\n\nSediment layers may later be buried, pressed and cemented into rock. Not every loose pile has already become sedimentary rock. The rock cycle is a model of possible changes among rock materials. A rock can follow several paths and need not visit the three groups in a fixed order. Many rock changes take very long times compared with a school observation.'),
    scienceVisual('sci-g4-4-sediments',
        'Separate making pieces, transporting them, settling them and joining them into rock.'),
    scienceSection('Worked example: sand becomes sandstone',
        'A stream carries sand into a quiet area where the grains settle. Step 1: carrying is erosion; settling is deposition. Step 2: more layers bury the sand and press grains together: compaction. Step 3: minerals can join the grains like natural cement: cementation. Step 4: the resulting sandstone belongs to the sedimentary group because of this formation route.\n\nThe presence of grains helps, but the story of formation is the strongest explanation here. Do not call the loose sand igneous because its original grains may have come from older igneous rocks. The new rock is classified by how those grains became joined.'),
    scienceSection('Guided example: heat without melting',
        'Existing limestone is changed by heat and pressure underground, but it does not melt. It becomes marble. Which rock group fits? Identify the part of the evidence that separates it from igneous formation.'),
    scienceSection('Reveal: the solid rock changed',
        'Marble is metamorphic. Heat and pressure changed an existing rock without melting it. Igneous formation requires melted rock to cool and become solid. Heat alone does not identify the group.',
        reveal: true),
    scienceSection('Observe samples safely',
        'Ask an adult for clean, known samples or clear photographs. Compare color, luster, visible grains and layers. Record what you can see separately from a guessed name. Use a hand lens if available. Do not strike rocks, make dust, use acids, scratch household surfaces or taste samples. Unknown materials should stay untouched. Wash hands after handling approved samples. A photograph cannot reveal hardness reliably, so mark that property “not tested.”'),
    scienceSection('Common mistakes',
        'A rock and a mineral are related, but are not interchangeable names. Hardness concerns scratching, not weight. Color alone is unreliable for identification. Weathering happens before movement in our example, while erosion transports material. Metamorphic rock does not form by melting; melting followed by cooling is an igneous route.'),
    scienceSection('Quick check',
        'In granite, is a quartz grain a rock mixture or a mineral component? What property describes resistance to scratching? How does deposition differ from erosion?'),
    scienceSection('Check your thinking',
        'The quartz grain is a mineral component. Hardness describes resistance to scratching. Erosion carries material; deposition is its settling and collection.',
        reveal: true),
    scienceSection('Recap',
        'Combine composition, properties and formation evidence. Minerals are distinct natural solids; rocks may mix their grains. Igneous formation involves cooling melt, sedimentary formation can join sediments, and metamorphic formation changes solid rock with heat and pressure. Weathering, erosion and deposition explain different stages in the movement of pieces.'),
  ],
  keyConcept:
      'Minerals are distinct natural materials, rocks can contain mineral mixtures, and a rock’s formation route determines its group.',
  questions: [
    [
      'Which is a mineral commonly found in granite?',
      'Quartz',
      'Sandstone',
      'Marble',
      'Granite',
      'Quartz is a mineral; granite, sandstone and marble are rocks.',
      'Minerals and rocks'
    ],
    [
      'Which statement describes granite?',
      'A rock containing mineral grains',
      'Always one pure mineral',
      'A loose pile of sand only',
      'A liquid mineral mixture',
      'Granite commonly contains quartz, feldspar and mica grains.',
      'Rock composition'
    ],
    [
      'What does hardness describe?',
      'Resistance to scratching',
      'Amount of light reflected',
      'Weight of a whole sample',
      'Number of visible colors',
      'Hardness is a material’s resistance to being scratched.',
      'Hardness'
    ],
    [
      'What does luster describe?',
      'How a surface reflects light',
      'How heavy a rock feels',
      'How far sediment travels',
      'How many layers are buried',
      'Glassy and dull are descriptions of luster.',
      'Luster'
    ],
    [
      'Which rock group forms when melted rock cools?',
      'Igneous',
      'Sedimentary',
      'Metamorphic',
      'Loose sediment',
      'Solidifying melted rock forms igneous rock.',
      'Igneous formation'
    ],
    [
      'Which rock group can form by compacting and cementing sediments?',
      'Sedimentary',
      'Igneous',
      'Metamorphic',
      'Magma',
      'Sediment grains can become joined into sedimentary rock.',
      'Sedimentary formation'
    ],
    [
      'What is deposition?',
      'Carried material settles and collects',
      'Rock breaks down in place',
      'Pieces are transported downstream',
      'Melted rock cools underground',
      'Deposition is settling, distinct from breaking down or transporting.',
      'Deposition'
    ],
    [
      'Which evidence describes metamorphic formation?',
      'Solid rock changes under heat and pressure',
      'Lava cools at the surface',
      'Loose sand is transported by a stream',
      'Rain carries grains to a beach',
      'Metamorphic change occurs without melting the existing rock.',
      'Metamorphic formation'
    ],
    [
      'Why is color alone a weak mineral identification clue?',
      'Different minerals can share colors',
      'Minerals never have visible colors',
      'A sample’s color measures its hardness',
      'Only rocks can reflect colored light',
      'Color varies within some minerals and overlaps between different ones.',
      'Identification evidence'
    ],
    [
      'What is magma?',
      'Melted rock underground',
      'Melted rock at the surface',
      'Loose sediment in a stream',
      'Solid rock changed without melting',
      'The term magma names melted rock below the surface; lava is at the surface.',
      'Magma and lava'
    ],
    [
      'Which event is weathering?',
      'An exposed rock breaks into pieces',
      'A stream carries sand downstream',
      'Sand settles at a river mouth',
      'Buried grains become cemented',
      'Weathering breaks down rock where it is.',
      'Weathering'
    ],
    [
      'Which event is erosion?',
      'Water carries rock pieces elsewhere',
      'A rock cracks without pieces moving',
      'Carried grains settle in quiet water',
      'Magma becomes a solid rock',
      'Erosion transports material from one place to another.',
      'Erosion'
    ],
    [
      'A rock feels smooth. What can be concluded about hardness?',
      'Smoothness alone does not establish hardness',
      'It must be the softest mineral',
      'It must be harder than every rough rock',
      'Its hardness equals its weight',
      'Surface texture and resistance to scratching are different properties.',
      'Comparing properties'
    ],
    [
      'Which statement fits the rock cycle?',
      'Rocks can follow several change routes',
      'Every rock follows one fixed three-step order',
      'All rocks change group every day',
      'Only igneous rocks can break into pieces',
      'The cycle models possible routes rather than a compulsory sequence.',
      'Rock cycle'
    ],
    [
      'A stream slows and sand settles. Which stage is observed?',
      'Deposition',
      'Weathering',
      'Erosion only',
      'Melting',
      'Settling of previously transported grains is deposition.',
      'Interpreting stages'
    ],
    [
      'An old rock melts, then cools solid. Which group describes the new rock?',
      'Igneous',
      'Metamorphic',
      'Sedimentary',
      'Loose sediment',
      'Cooling a melt is igneous formation regardless of the earlier rock type.',
      'Formation evidence'
    ],
    [
      'Sand is loose on a beach. What is still needed in the taught sandstone route?',
      'Compaction and cementation',
      'Only changing its visible color',
      'Only carrying it farther downstream',
      'Only cooling liquid lava beside it',
      'Loose sediment must become joined to form this sedimentary rock.',
      'Sedimentary formation'
    ],
    [
      'A shiny grain is seen in a sample. Which report is supported?',
      'It has a shiny luster',
      'It is certainly a valuable metal',
      'It must be the hardest grain',
      'It formed by melting at the surface',
      'Shininess describes luster but does not prove value, hardness or formation.',
      'Observation evidence'
    ],
    [
      'Which property should be marked not tested when using only a photograph?',
      'Hardness',
      'Visible color',
      'Visible layers',
      'Visible grain pattern',
      'A photograph cannot directly show resistance to scratching.',
      'Evidence limits'
    ],
    [
      'A sandstone grain originally came from granite. Why is the sandstone sedimentary?',
      'The grains later became compacted and cemented',
      'Every grain lost all mineral properties',
      'All rocks with quartz are sedimentary',
      'The rock group follows only the oldest source',
      'The new rock’s formation route determines its group.',
      'Formation evidence'
    ],
    [
      'One sample contains quartz, feldspar and mica joined as grains. Which description fits?',
      'A rock with several mineral components',
      'One mineral identified by its three colors',
      'Magma because it contains several materials',
      'Sediment because every grain is still loose',
      'Several joined mineral grains can form a rock such as granite.',
      'Rock composition'
    ],
    [
      'Limestone changes into marble under heat and pressure without melting. Why is it metamorphic?',
      'An existing solid rock changed',
      'A melt cooled into new crystals',
      'Loose sand settled and became cemented',
      'Surface water transported all its pieces',
      'The absence of melting separates this metamorphic route from igneous formation.',
      'Metamorphic formation'
    ],
    [
      'A cliff breaks, fragments travel in water, then settle. Which sequence fits?',
      'Weathering → erosion → deposition',
      'Deposition → weathering → erosion',
      'Erosion → deposition → melting',
      'Melting → compaction → weathering',
      'The stages are breakdown in place, transport, then settling.',
      'Interpreting stages'
    ],
  ],
);

final _earthMoonSun = scienceTopic(
  grade: 'g4',
  order: 5,
  title: 'Earth, Moon & Sun',
  prerequisiteTopicId: 'science.g4.rocks-minerals',
  subtitle: 'Explain daily and monthly patterns using motions and sunlight.',
  minutes: '30–35 minutes',
  objectives: [
    'Distinguish rotation from orbit using Earth and the Moon.',
    'Explain day and night with Earth’s rotation.',
    'Explain Moon phases as views of its sunlit half.',
    'Use a model carefully and identify its limits.'
  ],
  introduction:
      'The Sun seems to cross the sky during a day. The Moon can look like a narrow crescent on one date and a bright disk on another. These repeating patterns have different causes. A model of Earth, the Moon and the Sun helps you connect what you see from the ground with motions in space.',
  sections: [
    scienceSection('Three objects, different light roles',
        'The Sun is a star that produces its own light. Earth is a planet that travels around the Sun. The Moon is Earth’s natural satellite: it travels around Earth. Earth and the Moon do not produce sunlight. We see the bright Moon mainly because its surface reflects light from the Sun.\n\nAn orbit is the path an object follows around another object. Rotation means spinning around an imaginary line called an axis. These motions are different. Earth rotates while also orbiting the Sun. A spinning top can rotate in one place; a child walking around a table can model travel around another object. Neither everyday model copies all of space.'),
    scienceSection('Earth’s rotation explains day and night',
        'At one time, the side of Earth facing the Sun receives direct sunlight. Places there have daytime. The side facing away does not receive direct sunlight and has nighttime. As Earth rotates, a place moves into the lit side and later out of it. One rotation takes about 24 hours.\n\nFrom the ground, the Sun appears to move across the sky, but the daily pattern is explained by Earth’s rotation. The Sun does not switch off at night. Another part of Earth can have daytime while your location has nighttime. Clouds can block some sunlight on a day, but they are not the cause of the repeating day-and-night cycle.'),
    scienceVisual('sci-g4-5-daynight',
        'Use a fixed Sun and rotating Earth to explain why the same place changes between day and night.'),
    scienceSection('An orbit gives a different timescale',
        'Earth travels around the Sun in about 365 days: one year. This trip is much longer than one daily rotation. When describing a pattern, match it to the correct motion. One spin relates to a day; one trip around the Sun relates to a year. Earth does not need to complete its yearly orbit before another night begins.\n\nThe Moon also moves, orbiting Earth. As it travels, the relationship among Sun, Earth and Moon changes. That changes how much of the Moon’s sunlit half we can see from Earth. The repeating phase cycle takes about 29½ days, roughly a month. This is not the same timescale as Earth’s day or year.'),
    scienceVisual('sci-g4-5-motions',
        'Compare the motions and their approximate times without treating the drawing as a distance scale.'),
    scienceSection('Phases are views of the lit half',
        'Sunlight normally illuminates half of the Moon, just as a lamp lights one side of a ball. At new Moon, the lit half faces mainly away from Earth, so we see little or none of it. At full Moon, the lit half faces mainly toward Earth, so the visible disk looks fully lit. At a quarter Moon, half of the disk we see appears lit. The whole Moon has not become a different shape.\n\nBetween these examples, crescent phases show less than half of the visible disk lit, and gibbous phases show more than half. Ordinary phases are not caused by Earth’s shadow. Earth’s shadow can fall on the Moon during a lunar eclipse, a special alignment. The Moon’s orbit is tilted, so the simple positions in a flat picture do not mean an eclipse happens every month.'),
    scienceVisual('sci-g4-5-moon',
        'Keep the space view separate from what an observer on Earth sees. The Moon remains a sphere in every phase.'),
    scienceSection('Worked example: explain a half-lit Moon',
        'A learner sees a quarter Moon and says half of the Moon has disappeared. Step 1: distinguish the object from its visible lighting: the Moon remains a complete sphere. Step 2: sunlight illuminates half of that sphere. Step 3: at this position, Earth’s observer sees only part of the lit half, making half of the visible disk look bright. Step 4: changing position along the orbit changes the view over several days.\n\nThe word quarter refers to the phase’s place in the repeating cycle, not to a quarter of the visible disk being bright. Half of the disk is lit in a quarter phase.'),
    scienceSection('Guided example: different clocks',
        'A friend says Earth must orbit the Sun once to make one day, and the Moon makes its own light at full Moon. Correct both statements by naming a motion and a light source.'),
    scienceSection('Reveal: match motion and source',
        'Earth’s rotation makes the repeating daily pattern; its orbit around the Sun takes about a year. The full Moon reflects sunlight. It looks fully lit because its sunlit half faces mainly toward Earth, not because it starts making light.',
        reveal: true),
    scienceSection('Observe the Moon safely',
        'With an adult, record the Moon’s visible shape on several dates from a safe place. Write the date and time and draw the bright part. If clouds hide it, record “not visible” rather than inventing a shape. The Moon can sometimes be visible in daytime too. Never look directly at the Sun or point binoculars or a telescope near it. For a model, use an ordinary cool torch and a ball indoors with adult help.'),
    scienceSection('Common mistakes',
        'Rotation and orbit are different motions. Night does not mean the Sun stopped shining. Moon phases describe the visible sunlit portion, not pieces of the Moon missing. A quarter Moon shows half its disk lit. Earth’s shadow causes a lunar eclipse in a special alignment, not the ordinary monthly phase cycle.'),
    scienceSection('Quick check',
        'Which motion explains night at your location? What lights the Moon? Does a crescent mean the Moon’s actual shape has changed?'),
    scienceSection('Check your thinking',
        'Earth’s rotation moves your location away from direct sunlight. The Sun lights the Moon, which reflects its light. A crescent is a changing view of the sunlit half; the Moon remains spherical.',
        reveal: true),
    scienceSection('Recap',
        'Explain sky patterns with the right motion and viewpoint. Earth rotates in about a day and orbits the Sun in about a year. The Moon orbits Earth, producing a roughly monthly cycle of views of its lit half. Models help reveal these relationships but simplify sizes, distances and three-dimensional alignment.'),
  ],
  keyConcept:
      'Earth’s rotation explains day and night; Moon phases come from changing views of its sunlit half as it orbits Earth.',
  questions: [
    [
      'Which object produces the sunlight in this lesson?',
      'Sun',
      'Moon',
      'Earth',
      'Both Earth and Moon',
      'The Sun is a star that produces light; the Moon reflects sunlight.',
      'Light source'
    ],
    [
      'What does rotation mean?',
      'Spinning around an axis',
      'Traveling around another object',
      'Moving along a path without spinning',
      'Completing a monthly phase cycle',
      'Rotation is spinning, distinct from orbiting.',
      'Rotation'
    ],
    [
      'What does orbiting mean?',
      'Traveling around another object',
      'Spinning only in one place',
      'Producing its own light',
      'Turning all reflected light off',
      'An orbit is a path around another object.',
      'Orbit'
    ],
    [
      'About how long does one Earth rotation take?',
      '24 hours',
      '29½ days',
      '365 days',
      '12 years',
      'Earth’s daily rotation takes approximately 24 hours.',
      'Daily pattern'
    ],
    [
      'Which motion takes Earth about one year?',
      'Orbiting the Sun',
      'One rotation',
      'Orbiting the Moon',
      'One Moon phase cycle',
      'Earth’s trip around the Sun takes about 365 days.',
      'Yearly pattern'
    ],
    [
      'Why does the Moon appear bright?',
      'It reflects sunlight',
      'It produces light like a star',
      'It receives its main light from Earth’s shadow',
      'It produces light only during full Moon',
      'The bright Moon is seen mainly by reflected sunlight.',
      'Moon light'
    ],
    [
      'At a quarter Moon, how much of its visible disk looks lit?',
      'Half',
      'One quarter',
      'All',
      'None',
      'A quarter phase shows half of the visible disk illuminated.',
      'Moon phases'
    ],
    [
      'What causes ordinary day and night at a place?',
      'Earth’s rotation moves it into and out of sunlight',
      'The Sun switches on and off every day',
      'The Moon blocks the Sun every night',
      'Earth completes its entire orbit each day',
      'Rotation changes whether a location faces direct sunlight.',
      'Daily pattern'
    ],
    [
      'Your location has night. What can be true elsewhere on Earth?',
      'Another location has daytime',
      'Every location must have nighttime',
      'Every location must face away from the Sun',
      'The Sun stops shining until your morning',
      'At one time, the side facing the Sun is lit while the other side is not.',
      'Day and night'
    ],
    [
      'Which description fits full Moon?',
      'The sunlit half faces mainly toward Earth',
      'The sunlit half faces mainly away from Earth',
      'Only half the visible disk is illuminated',
      'Earth’s shadow makes the entire visible disk bright',
      'At full Moon, the observer sees the illuminated half facing Earth.',
      'Moon phases'
    ],
    [
      'Which description fits new Moon?',
      'The sunlit half faces mainly away from Earth',
      'The Moon receives no sunlight on either half',
      'The entire lit half faces Earth',
      'Earth’s shadow causes every new Moon',
      'The Moon is still lit on one half, but little of that half is visible from Earth.',
      'Moon phases'
    ],
    [
      'What normally illuminates half the Moon?',
      'Sunlight',
      'Earth’s own starlight',
      'Light produced by the Moon',
      'Clouds reflecting all the needed light',
      'The Sun lights half the sphere; position changes our view of it.',
      'Moon illumination'
    ],
    [
      'What causes the ordinary monthly phase changes?',
      'Changing views of the lit half during the Moon’s orbit',
      'Earth’s shadow regularly covering the Moon',
      'The Sun illuminating more than half the sphere',
      'The Moon making different amounts of its own light',
      'The Moon’s position changes which portion of its sunlit half we see.',
      'Phase cause'
    ],
    [
      'Which event can involve Earth’s shadow falling on the Moon?',
      'Lunar eclipse',
      'Every quarter Moon',
      'Every crescent Moon',
      'Every sunrise',
      'A lunar eclipse is a special shadow alignment, distinct from ordinary phases.',
      'Eclipse distinction'
    ],
    [
      'A crescent shows a narrow bright part. What remains true about the Moon?',
      'It remains a complete sphere',
      'The whole sphere has become a thin curved shape',
      'Only the crescent part receives any sunlight',
      'Earth’s shadow must be covering the rest',
      'The apparent crescent is a lighting view, not a change of the whole object’s shape.',
      'Shape and view'
    ],
    [
      'A pupil needs a model of day and night. What should move relative to a fixed lamp?',
      'A globe rotates in place',
      'A globe circles the lamp without rotating',
      'The lamp switches off to produce every night',
      'A Moon ball covers the lamp for every night',
      'A fixed light and rotating globe model places entering and leaving sunlight.',
      'Using models'
    ],
    [
      'The Moon is hidden by clouds during an observation. What should the pupil record?',
      'Not visible, with date and time',
      'New Moon because the Moon was not seen',
      'The same phase as the last clear observation',
      'Full Moon because the clouds appeared bright',
      'Visibility conditions do not establish a phase; record the observation honestly.',
      'Observation evidence'
    ],
    [
      'Why does a flat orbit picture not prove an eclipse happens every month?',
      'The real Moon orbit is tilted',
      'Earth casts a shadow only once each year',
      'The Moon stops orbiting during most new Moons',
      'The Moon produces light that prevents eclipses',
      'Three-dimensional tilt allows most monthly positions to avoid exact shadow alignment.',
      'Model limits'
    ],
    [
      'Which timescale best fits a complete repeating Moon phase cycle?',
      'About a month',
      'About one hour',
      'About one day',
      'About one year',
      'The repeating phase cycle is approximately 29½ days.',
      'Monthly pattern'
    ],
    [
      'What can be concluded from seeing the Moon in daylight?',
      'It can be visible during some daytime periods',
      'It must produce light to be seen in daylight',
      'It can only be a full Moon if seen in daylight',
      'The daily rotation must have stopped temporarily',
      'The Moon is not visible only at night; sunlight can reflect from it during daylight too.',
      'Sky observations'
    ],
    [
      'A class calls a quarter Moon “one quarter of the visible disk lit.” Which correction fits?',
      'Half the disk is lit; quarter names its place in the cycle',
      'One quarter of the whole Moon is present',
      'Half the disk is lit by Earth’s shadow',
      'The whole visible disk is always fully lit',
      'Quarter is a phase name, while the observed disk is half illuminated.',
      'Moon phases'
    ],
    [
      'Which explanation separates a day from a year?',
      'A day relates to rotation; a year to orbit around the Sun',
      'Both require one orbit around the Moon',
      'A day requires an eclipse; a year requires new Moon',
      'A day and year both take one rotation of Earth',
      'Earth’s spin and its orbit have different timescales and patterns.',
      'Matching motions'
    ],
    [
      'A learner says Earth’s shadow makes every crescent. What evidence-based explanation should replace it?',
      'The crescent is our view of part of the Moon’s sunlit half',
      'Every crescent is a long-lasting lunar eclipse',
      'The Sun illuminates only a crescent of the sphere',
      'The Moon makes light only on a crescent-shaped part',
      'Ordinary phases result from position and viewpoint, not Earth’s shadow.',
      'Phase cause'
    ],
  ],
);
