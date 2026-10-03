import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

final List<NorieTopicContent> grade3ScienceTopics = [
  _plantParts,
  _animalAdaptations,
  _matterAndChanges,
  _forceAndMotion,
  _weatherPatterns,
];

const Map<String, ScienceFigure> grade3ScienceFigures = {
  'sci-g3-1-anatomy': ScienceFigure(
    picture: 'plant-parts',
    title: 'Parts of a flowering plant',
    kind: 'comparison',
    labels: ['Roots', 'Stem', 'Leaves', 'Flower', 'Fruit and seeds'],
    details: [
      'Anchor the plant and absorb water and minerals.',
      'Supports the plant and carries water and food.',
      'Use light, water and carbon dioxide to make food.',
      'Helps a flowering plant produce seeds.',
      'A fruit protects seeds; seeds contain young plants.'
    ],
    note: 'This model shows a flowering bean plant, not every kind of plant.',
  ),
  'sci-g3-1-water-route': ScienceFigure(
    title: 'Follow water through a plant',
    kind: 'process',
    labels: ['Water in soil', 'Roots', 'Stem', 'Leaves'],
    details: [
      'Water is available around the roots.',
      'Roots absorb some of that water.',
      'Tubes carry water upward.',
      'Water helps leaves make food.'
    ],
    note:
        'The arrows follow water. Food is made in green leaves and carried to other parts.',
  ),
  'sci-g3-1-seeds': ScienceFigure(
    title: 'A flower can lead to new plants',
    kind: 'process',
    labels: ['Flower', 'Pollen moved', 'Fruit with seeds', 'New seedling'],
    details: [
      'A bean plant makes flowers.',
      'Pollination moves pollen to the part that receives it.',
      'A flower can develop into a bean pod with seeds.',
      'A seed can grow when conditions are suitable.'
    ],
    note:
        'Not every flower makes a fruit. Seeds need water, air and suitable warmth to begin growing.',
  ),
  'sci-g3-2-body-jobs': ScienceFigure(
    title: 'A body structure meets a need',
    kind: 'comparison',
    labels: [
      'Duck: webbed feet',
      'Owl: hooked beak and talons',
      'Tortoise: shell'
    ],
    details: [
      'Skin between toes makes a broad surface for pushing water.',
      'Sharp claws grip prey; the beak helps tear food.',
      'A hard covering helps protect the body from attackers.'
    ],
    note:
        'Explain a structure by connecting it to a job in the animal’s habitat.',
  ),
  'sci-g3-2-camouflage': ScienceFigure(
    title: 'Camouflage depends on the background',
    kind: 'comparison',
    labels: [
      'White hare on snow',
      'White hare on dark ground',
      'Brown hare on brown ground'
    ],
    details: [
      'The similar colors make the hare harder to notice.',
      'The different colors make the hare easier to notice.',
      'The similar colors can hide the hare from predators.'
    ],
    note:
        'Many snowshoe hares in snowy regions grow different seasonal coats; some populations stay brown. Camouflage does not make them invisible.',
  ),
  'sci-g3-2-generations': ScienceFigure(
    title: 'Inherited helpful traits across generations',
    kind: 'process',
    labels: [
      'Traits vary',
      'Some traits help',
      'Survivors reproduce',
      'Young inherit traits'
    ],
    details: [
      'Animals of a kind can differ in inherited traits.',
      'A trait can improve survival in a particular habitat.',
      'Surviving animals may have more young.',
      'Helpful inherited traits can become more common over many generations.'
    ],
    note:
        'This is a simplified explanation over generations, not one animal wishing for a new body part.',
  ),
  'sci-g3-3-states': ScienceFigure(
    title: 'Matter keeps its identity during a state change',
    kind: 'particles',
    labels: ['Solid', 'Liquid', 'Gas'],
    details: [
      'Ice: water particles stay close and vibrate in place.',
      'Liquid water: particles stay close but move past one another.',
      'Water vapor: particles are much farther apart and move freely.'
    ],
    note:
        'Dots model particles, not actual size. Changing their arrangement does not turn water into a new substance.',
  ),
  'sci-g3-3-before-after': ScienceFigure(
    title: 'Compare material before and after',
    kind: 'comparison',
    labels: ['Paper → torn paper', 'Ice → liquid water', 'Iron → rusted iron'],
    details: [
      'Size and shape change; the pieces remain paper: physical change.',
      'State changes; the substance remains water: physical change.',
      'Some iron reacts with oxygen and forms rust: chemical change.'
    ],
    note:
        'Ask whether a new substance formed. Being easy to reverse is not the definition.',
  ),
  'sci-g3-3-dissolving': ScienceFigure(
    title: 'Salt is still present after dissolving',
    kind: 'process',
    labels: [
      'Salt and water',
      'Salt dissolved',
      'Water evaporates',
      'Salt remains'
    ],
    details: [
      'Solid salt is added to water.',
      'Salt spreads through the water and is no longer easy to see.',
      'Water leaves as invisible water vapor.',
      'Salt can be seen again after enough water leaves.'
    ],
    note:
        'This is a physical change. Use room-temperature evaporation, never a child-operated heater.',
  ),
  'sci-g3-4-forces': ScienceFigure(
    picture: 'forces',
    title: 'Compare forces on the same block',
    kind: 'comparison',
    labels: ['Balanced horizontal forces', 'Unbalanced horizontal forces'],
    details: [
      'Equal left and right forces cancel. Horizontal motion does not change.',
      'A stronger right force than left force changes motion toward the right.'
    ],
    note:
        'Arrow direction shows force direction; length compares strength. These are force arrows, not travel paths. Vertical forces are balanced and omitted.',
  ),
  'sci-g3-4-distance': ScienceFigure(
    title: 'Distance covered in the same two seconds',
    kind: 'bars',
    labels: ['Car A', 'Car B'],
    details: [
      'Travels 20 cm in 2 seconds.',
      'Travels 40 cm in 2 seconds: faster over this interval.'
    ],
    values: [20, 40],
    unit: 'cm',
    note:
        'Both cars are observed for the same time. The bars measure distance, not force.',
  ),
  'sci-g3-4-contact': ScienceFigure(
    title: 'Forces around a toy car',
    kind: 'comparison',
    labels: ['Hand push', 'Friction', 'Gravity', 'Surface support'],
    details: [
      'Contact with a hand can start or change movement.',
      'Contact between surfaces resists sliding or rolling.',
      'Earth pulls the car downward without touching it.',
      'A table can push upward on the resting car.'
    ],
    note:
        'Forces can act even when an object is at rest. Downward gravity and upward support can balance.',
  ),
  'sci-g3-5-instruments': ScienceFigure(
    title: 'Match a measurement to its instrument',
    kind: 'comparison',
    labels: ['Thermometer', 'Rain gauge', 'Wind vane', 'Anemometer'],
    details: [
      'Measures temperature, recorded here in degrees Celsius (°C).',
      'Measures collected rainfall depth, recorded in millimeters (mm).',
      'Shows the direction the wind comes from.',
      'Measures how fast the wind blows.'
    ],
    note:
        'Cloud cover can be described by observation. Instruments measure different weather properties.',
  ),
  'sci-g3-5-rainfall': ScienceFigure(
    title: 'Example rainfall log for four days',
    kind: 'bars',
    labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday'],
    details: [
      '2 mm: some rain was collected.',
      '6 mm: more rain than Monday.',
      '0 mm: no rain collected during this interval.',
      '8 mm: the greatest rainfall in this log.'
    ],
    values: [2, 6, 0, 8],
    unit: 'mm',
    note:
        'Each value covers one equal 24-hour interval in the same place. These example data do not predict Friday’s rainfall.',
  ),
  'sci-g3-5-water-cycle': ScienceFigure(
    title: 'One possible route through the water cycle',
    kind: 'cycle',
    labels: [
      'Evaporation',
      'Condensation',
      'Precipitation',
      'Collection and runoff'
    ],
    details: [
      'Liquid surface water becomes invisible vapor.',
      'Cooling vapor can become liquid droplets.',
      'Rain or other water falls from clouds.',
      'Water collects in lakes or oceans, or flows over land.'
    ],
    note:
        'Water has many routes: some soaks into soil. A water-cycle model is not a weather forecast or a fixed daily schedule.',
  ),
};

final _plantParts = scienceTopic(
  grade: 'g3',
  order: 1,
  title: 'Plant Parts',
  prerequisiteTopicId: null,
  subtitle: 'Connect each part of a flowering plant to the job it does.',
  minutes: '25–30 minutes',
  objectives: [
    'Identify roots, stems, leaves, flowers, fruits and seeds.',
    'Explain how roots, stems and leaves work together.',
    'Trace how a flower can lead to a fruit containing seeds.',
    'Use a plant part’s job as evidence when identifying it.',
  ],
  introduction:
      'A bean plant stands upright even though nobody holds it. Water starts in the soil, but its leaves are above the ground. How does the water reach them? Look closely at the plant as a team of connected parts, each doing a different job.',
  sections: [
    scienceSection('Roots: hold and absorb',
        'Most roots grow in soil. They anchor the plant, holding it in place when wind blows. Roots also absorb water and minerals from around them. Absorb means take in. Minerals are materials that plants need in small amounts to grow. They are different from the food a plant makes.\n\nMany roots have small branches, spreading through the soil. Some roots store food made by the plant. A carrot is a storage root. Roots are not just strings that hang below a stem: they help supply the rest of the living plant.'),
    scienceSection('Stems: support and transport',
        'A stem supports leaves, flowers and fruits. Holding leaves up helps them reach light. Inside a stem are tiny tubes that transport materials. Transport means carry from one place to another. Water absorbed by roots travels through the stem to leaves. Food made in leaves can travel to other parts.\n\nA soft bean stem and a woody tree trunk look different, but both are stems. A trunk supports branches and carries materials. A stem is not always a straight green stick, and its job is more than holding the plant up.'),
    scienceVisual('sci-g3-1-anatomy',
        'Match the numbered parts to their jobs. The soil line separates the usual underground roots from the shoot.'),
    scienceSection('Leaves: make the plant’s food',
        'Green leaves use light energy, water and a gas in the air called carbon dioxide to make food. This process is called photosynthesis. The food helps the plant grow and provides energy for living. Leaves also release oxygen into the air during photosynthesis. Light supplies energy; it is not a material the plant eats.\n\nRoots supply water, and the stem carries it to leaves. Leaves then supply food to the plant. Soil does not contain ready-made meals for roots to eat. Water and minerals from soil help the plant, but leaves make its food. A seedling needs suitable light once its leaves are growing.'),
    scienceVisual('sci-g3-1-water-route',
        'Read the arrows as a route: soil water → roots → stem → leaves.'),
    scienceSection('Flowers, fruits and seeds',
        'Flowers help flowering plants reproduce, or make new plants. Pollination is the movement of pollen to the flower part that receives it. Bees can carry pollen between flowers; wind moves pollen in some plants. After pollination and further development, some flowers form fruits with seeds.\n\nA bean pod is a fruit, even though it is not sweet. A tomato is also a fruit because it develops from a flower and contains seeds. Fruits protect seeds and can help them spread. A seed contains a tiny young plant and stored food. With water, air and suitable warmth, it can begin growing into a seedling. Not all plants make flowers, and not every flower produces a fruit.'),
    scienceVisual('sci-g3-1-seeds',
        'A bean flower can develop into a pod. Each seed can begin another plant.'),
    scienceSection('Worked example: explain a wilted plant',
        'A bean plant has dry soil and drooping leaves. Which connection should we check first? Step 1: leaves need water. Step 2: the stem carries water from roots. Step 3: roots absorb water from soil. Dry soil may not supply enough water, so check the soil and ask an adult about suitable watering.\n\nDrooping alone does not prove the cause. A scientist uses observations and checks, rather than assuming every wilted plant has the same problem.'),
    scienceSection('Guided example: identify the pod',
        'A green bean pod grew where a flower had been. Opened by an adult, it contains seeds. Is the pod a root, stem, leaf or fruit? Use both its origin and its contents as evidence.'),
    scienceSection('Reveal: use two clues',
        'It is a fruit. It developed from a flower and contains seeds. Its green color does not make it a leaf, and its long shape does not make it a stem.',
        reveal: true),
    scienceSection('Observe a plant safely',
        'With an adult, observe a potted plant without pulling it out. Draw its visible stem and leaves. Look for flowers or fruits if present. Label roots as hidden below the soil. Compare with a carrot and a bean pod supplied by an adult. Do not taste unknown plants or remove wild flowers. Wash hands after touching soil.'),
    scienceSection('Common mistakes',
        'A tree trunk is a stem. A fruit need not be sweet. Green color alone cannot identify a leaf: use position and job too. Roots absorb water and minerals; they do not eat soil. The parts depend on one another, so a healthy plant needs more than leaves alone.'),
    scienceSection('Quick check',
        'Which part absorbs water? Which process makes food in green leaves? Why can a bean pod be called a fruit?'),
    scienceSection('Check your thinking',
        'Roots absorb water. Photosynthesis makes food using light, water and carbon dioxide. A bean pod develops from a flower and contains seeds.',
        reveal: true),
    scienceSection('Recap',
        'Roots anchor and absorb. Stems support and transport. Leaves make food. Flowers help produce seeds, fruits protect seeds, and seeds can begin new plants. Identify each part by its job and its connection to the rest of the plant.'),
  ],
  keyConcept:
      'A flowering plant’s parts work together to obtain water, make food, grow and produce new plants.',
  questions: [
    [
      'Which plant part usually absorbs water from soil?',
      'Roots',
      'Leaves',
      'Flowers',
      'Fruits',
      'Roots absorb water and minerals from around them.',
      'Root function'
    ],
    [
      'Which part supports leaves and carries materials through tubes?',
      'Stem',
      'Seed',
      'Flower',
      'Fruit',
      'A stem supports the plant and transports water and food.',
      'Stem function'
    ],
    [
      'Where do green bean plants make most of their food?',
      'In their leaves',
      'In the soil around them',
      'In their roots alone',
      'In their fruits alone',
      'Green leaves make food through photosynthesis.',
      'Leaf function'
    ],
    [
      'Which name describes food-making using light, water and carbon dioxide?',
      'Photosynthesis',
      'Pollination',
      'Absorption',
      'Reproduction',
      'Photosynthesis is the process that makes food in green leaves.',
      'Photosynthesis'
    ],
    [
      'Which part helps a flowering plant produce seeds?',
      'Flower',
      'Root',
      'Stem',
      'Leaf',
      'Flowers are reproductive parts of flowering plants.',
      'Flower function'
    ],
    [
      'What is inside a seed?',
      'A tiny young plant and stored food',
      'Only water and minerals from soil',
      'Only an empty protective coat',
      'A fully grown plant with fruits',
      'Seeds contain young plants and food that supports early growth.',
      'Seed structure'
    ],
    [
      'Which plant part is a carrot?',
      'A storage root',
      'A woody stem',
      'A seed-filled fruit',
      'A food-making leaf',
      'A carrot is a root that stores food.',
      'Storage roots'
    ],
    [
      'Which route carries water to a leaf?',
      'Soil → roots → stem → leaves',
      'Soil → leaves → stem → roots',
      'Roots → leaves → soil → stem',
      'Leaves → roots → stem → soil',
      'Roots absorb soil water and the stem carries it toward leaves.',
      'Water transport'
    ],
    [
      'Why is a tree trunk a stem?',
      'It supports branches and transports materials',
      'It absorbs all water directly from air',
      'It is a fruit that contains tree seeds',
      'It makes every seed without flowers',
      'A trunk has stem jobs even though it is woody and thick.',
      'Identifying stems'
    ],
    [
      'Which gas do leaves use when making food?',
      'Carbon dioxide',
      'Oxygen',
      'Water vapor only',
      'No gas from air',
      'Leaves use carbon dioxide, water and light energy in photosynthesis.',
      'Photosynthesis materials'
    ],
    [
      'What does sunlight supply for photosynthesis?',
      'Energy',
      'Minerals',
      'Stored food',
      'Seeds',
      'Light supplies energy that leaves use to make food.',
      'Light energy'
    ],
    [
      'What is pollination?',
      'Moving pollen to the flower part that receives it',
      'Moving soil water through a stem',
      'Making food in a green leaf',
      'Growing a root out of a seed',
      'Pollination moves pollen and helps flowering plants reproduce.',
      'Pollination'
    ],
    [
      'Why is a bean pod classified as a fruit?',
      'It develops from a flower and contains seeds',
      'It is green and grows above soil',
      'It carries water up a plant stem',
      'It absorbs minerals from the soil',
      'The pod’s origin and seeds are the clues that identify a fruit.',
      'Fruit classification'
    ],
    [
      'Which pair contains materials that roots absorb?',
      'Water and minerals',
      'Light and ready-made food',
      'Flowers and seeds',
      'Pollen and fruits',
      'Roots take in water and minerals; green leaves make food.',
      'Plant nutrition'
    ],
    [
      'A learner says plants eat soil. Which explanation corrects this?',
      'Roots take in water and minerals; leaves make food',
      'Roots take in soil as ready-made food',
      'Leaves take ready-made food directly from soil',
      'Flowers make all food without light',
      'Plants use soil resources, but photosynthesis makes their food.',
      'Plant nutrition reasoning'
    ],
    [
      'A plant has dry soil and drooping leaves. Which idea best guides a first check?',
      'Roots may not have enough water available',
      'Extra light can replace any missing water',
      'Dry soil provides ready-made food for roots',
      'Leaves can make food without any water',
      'Trace the water route and check available soil water; drooping alone does not prove a cause.',
      'Evidence about plant needs'
    ],
    [
      'A green structure contains seeds and grew from a flower. What is it?',
      'Fruit',
      'Leaf',
      'Root',
      'Stem',
      'Seeds and development from a flower identify a fruit despite its color.',
      'Evidence for a fruit'
    ],
    [
      'A bean seedling has water and air but stays in darkness. What resource is missing for food-making?',
      'Light energy',
      'Ready-made food from soil',
      'More oxygen instead of carbon dioxide',
      'Minerals instead of any light',
      'Growing green leaves need suitable light for photosynthesis.',
      'Applying plant needs'
    ],
    [
      'Which observation shows transport rather than support?',
      'Water moving through a stem toward leaves',
      'A trunk holding branches upright',
      'A root keeping a plant anchored',
      'A fruit protecting its seeds',
      'Transport means carrying materials between parts.',
      'Transport evidence'
    ],
    [
      'Why can damage to roots affect leaves above the soil?',
      'Roots supply water that stems carry to leaves',
      'Roots supply ready-made meals taken from soil',
      'Leaves receive water without any help from stems',
      'Leaf needs do not depend on roots',
      'The connected parts depend on water absorbed by roots.',
      'Connected plant parts'
    ],
    [
      'A tomato grew from a flower and holds seeds. Which explanation identifies it?',
      'It is a fruit, even if used in a savory meal',
      'It is a leaf because its plant is green',
      'It is a root because its plant grows in soil',
      'It is a stem because it grew above soil',
      'A tomato meets the taught flower-and-seed evidence for a fruit.',
      'Mastery: plant classification'
    ],
    [
      'Which account correctly connects roots, stems and leaves?',
      'Roots absorb water, stems carry it, and leaves use it to make food',
      'Roots absorb ready-made food, stems carry it, and leaves only store it',
      'Roots absorb water, but stems only support and never carry materials',
      'Roots anchor, but leaves obtain all water without roots or stems',
      'The parts cooperate to supply water and make food.',
      'Mastery: connected functions'
    ],
    [
      'A learner labels every flower as a future fruit. Which correction is accurate?',
      'Some flowers develop into fruits, but not every flower does',
      'Each flower guarantees a fruit without further development',
      'Only flowers on sweet-fruited plants can make seeds',
      'Fruits appear before the flowers they develop from',
      'Flowers help reproduction, but fruit development is not guaranteed for each flower.',
      'Mastery: reproduction'
    ],
  ],
);

final _animalAdaptations = scienceTopic(
  grade: 'g3',
  order: 2,
  title: 'Animal Adaptations',
  prerequisiteTopicId: 'science.g3.plant-parts',
  subtitle:
      'Use evidence to explain how traits help animals in their habitats.',
  minutes: '25–30 minutes',
  objectives: [
    'Connect an animal’s body structures to survival jobs.',
    'Distinguish a structural adaptation from a behavioral adaptation.',
    'Explain why camouflage works better on some backgrounds.',
    'Describe adaptation as inherited change across many generations.',
  ],
  introduction:
      'A duck paddles across a pond while a tortoise walks along the bank. The duck’s feet spread wide in the water; the tortoise carries a hard shell. What can their bodies tell us about the problems each animal faces? We will connect a trait, a job and a habitat.',
  sections: [
    scienceSection('Traits that help survival',
        'A trait is a feature of a living thing, such as foot shape or coat color. An adaptation is an inherited trait that helps a kind of animal survive and reproduce in its environment. Inherited means passed from parents to young. Reproduce means produce young. An adaptation may help an animal get food, move, avoid attackers or cope with conditions.\n\nA habitat supplies food, water, shelter and space. A useful trait fits conditions there. It is not a promise that an animal will always survive. Animals still need resources, and a helpful trait in one habitat may be less helpful in another.'),
    scienceSection('Structures: what a body has',
        'A structural adaptation is a helpful body part or physical feature. A duck has webbed feet, with skin between its toes. When it pushes its feet through water, the broad surface helps paddle its body forward. The webbing is part of its body, not something it grows by practicing swimming.\n\nAn owl has sharp talons, or claws, to grip prey. Its hooked beak helps tear food. A tortoise has a hard shell that helps protect its body from attackers. Connect each structure to a particular job. A shell provides protection; it does not do the duck’s paddling job.'),
    scienceVisual('sci-g3-2-body-jobs',
        'Read each structure beside the survival problem it helps solve.'),
    scienceSection('Camouflage: blend with surroundings',
        'Camouflage is a color or pattern that makes an animal harder to notice against its surroundings. A predator is an animal that hunts other animals for food. Prey are the animals hunted. Camouflage can help prey hide, and can also help predators approach prey without being noticed.\n\nMany snowshoe hares in snowy regions grow a white winter coat and a brown summer coat. Some populations stay brown. In our snowy-region example, white blends with snow; brown blends with brown ground. The seasonal ability is inherited. The hare does not choose a new inherited trait by wanting a different color. A white coat is less helpful on dark ground. Camouflage makes detection harder, not impossible.'),
    scienceVisual('sci-g3-2-camouflage',
        'Compare the same coat color against two backgrounds before judging whether it hides the hare.'),
    scienceSection('Behaviors: what an animal does',
        'A behavioral adaptation is an inherited pattern of action that helps survival. Some birds migrate, moving seasonally between regions. Migration can help them reach places where food is available. A body structure is something the animal has; a behavior is something it does.\n\nNot every helpful action is an inherited adaptation. A pet learning to sit for a treat learns during its own life. An animal can also move into shade on a hot day without its body evolving a new part. Learning and short-term responses matter, but they differ from inherited traits that become common across generations.'),
    scienceSection('Across many generations',
        'Animals of a kind can have different inherited traits. In certain conditions, a trait may help some survive and have young. Their young may inherit that trait. Over many generations, a helpful inherited trait can become more common.\n\nThis process does not happen because an individual wishes hard enough. A duck does not suddenly develop webbing because it falls into a pond. A helpful trait is already present before it can help survival. Changes to a habitat can also make a once-helpful trait less useful. An adaptation is a fit to conditions, not a perfect solution to every problem.'),
    scienceVisual('sci-g3-2-generations',
        'The arrows connect inherited variation, survival and new generations.'),
    scienceSection('Worked example: explain the duck’s feet',
        'Question: how do webbed feet help a duck in a pond? Step 1: identify the structure—skin stretches between toes. Step 2: identify the task—moving through water. Step 3: connect them—a broad foot pushes against water and helps the duck paddle. This explanation gives a mechanism, rather than saying only that the feet are useful.'),
    scienceSection('Guided example: a changing background',
        'Imagine a white-coated hare on snow, then the same hare on dark ground after snow melts. On which background is it harder for a predator to notice? Explain using the colors, without claiming the hare becomes invisible.'),
    scienceSection('Reveal: compare the contrast',
        'It is harder to notice on snow because white fur blends with the white background. On dark ground the white fur stands out. The background affects how well camouflage works.',
        reveal: true),
    scienceSection('Model camouflage safely',
        'Place equal numbers of light and dark paper squares on a light sheet. Ask a partner to point out the squares they notice first. Repeat on a dark sheet. Keep square sizes and viewing time the same. This models color contrast, not real animal survival. Observe wildlife from a distance; do not handle, chase or feed animals.'),
    scienceSection('Common mistakes',
        'An animal does not gain an inherited adaptation simply by needing it. Body structures and actions are different categories. Camouflage depends on surroundings. A trained pet’s new skill is learned, rather than an inherited body change.'),
    scienceSection('Quick check',
        'Is a tortoise shell a structure or a behavior? Is seasonal bird migration a structure or a behavior? Can one coat color hide an animal equally well everywhere?'),
    scienceSection('Check your thinking',
        'The shell is a structure; migration is a behavior. A coat blends with some backgrounds better than others.',
        reveal: true),
    scienceSection('Recap',
        'Explain an adaptation by linking an inherited trait to a survival job in a habitat. Structures include webbed feet, talons and shells; behaviors include seasonal migration. Helpful inherited traits can become more common over many generations.'),
  ],
  keyConcept:
      'Adaptations are inherited traits that help survival and reproduction in particular environments; they do not arise from an individual’s wishes.',
  questions: [
    [
      'What is an inherited trait?',
      'A feature passed from parents to young',
      'A skill learned only through practice',
      'A place visited once by an animal',
      'A choice made only on one hot day',
      'Inherited traits pass between generations, unlike a newly learned skill.',
      'Inheritance'
    ],
    [
      'Which is a structural adaptation of a duck?',
      'Webbed feet',
      'Seasonal migration',
      'Learning a new trick',
      'Moving into shade',
      'Webbed feet are a physical body structure.',
      'Structural adaptations'
    ],
    [
      'How do webbed feet help a duck?',
      'They provide a broad surface to push water',
      'They reduce the area of foot pushing against water',
      'They grip prey with sharp curved claws',
      'They replace the need to push against water',
      'Skin between the toes helps the duck paddle through water.',
      'Duck structure and function'
    ],
    [
      'Which owl structure grips prey?',
      'Talons',
      'Hooked beak',
      'Coat color',
      'Webbed toes',
      'An owl’s talons are sharp claws that grip prey.',
      'Owl structures'
    ],
    [
      'What job does a tortoise shell help do?',
      'Protect the body',
      'Paddle through pond water',
      'Tear food with a hooked edge',
      'Blend white fur with snow',
      'A hard shell helps protect a tortoise from attackers.',
      'Protection'
    ],
    [
      'What does camouflage help an animal do?',
      'Become harder to notice against surroundings',
      'Become invisible against every background',
      'Grow a new body part after one wish',
      'Replace every need for food and water',
      'Camouflage reduces how easily an animal is noticed on a suitable background.',
      'Camouflage'
    ],
    [
      'Which term names an animal that hunts other animals for food?',
      'Predator',
      'Prey',
      'Habitat',
      'Trait',
      'Predators hunt; prey are the animals hunted.',
      'Predator and prey'
    ],
    [
      'Which pair gives a structure and its correct job?',
      'Owl talons: grip prey',
      'Tortoise shell: paddle water',
      'Duck webbing: tear food',
      'White hare coat: grip prey',
      'Talons are claws that help an owl grip its food.',
      'Matching structure to function'
    ],
    [
      'Which is a behavioral adaptation taught in this lesson?',
      'Seasonal bird migration',
      'A tortoise’s shell',
      'An owl’s talons',
      'A duck’s webbed feet',
      'Migration is an inherited pattern of action; the other choices are structures.',
      'Behavioral adaptations'
    ],
    [
      'Why do some birds migrate?',
      'To reach regions where food is available',
      'To stay where food is scarce throughout the year',
      'To keep the same location despite changing food supplies',
      'To avoid needing food during the journey',
      'Seasonal movement can help birds reach available food.',
      'Migration function'
    ],
    [
      'Where does a white coat hide a hare better?',
      'Against white snow',
      'Against dark bare ground',
      'Against a black sheet',
      'Against every background equally',
      'Matching colors reduce contrast between the hare and snow.',
      'Camouflage background'
    ],
    [
      'In our snowy-region hare example, how do summer and winter coats differ?',
      'Summer is brown; winter is white',
      'Summer is white; winter is brown',
      'Both coats stay white',
      'Both coats stay brown',
      'The example hare has brown summer and white winter coats; not every population changes this way.',
      'Seasonal camouflage'
    ],
    [
      'How is a pet learning to sit different from inherited webbed feet?',
      'Sitting is learned during its life; webbing is inherited',
      'Sitting changes its inherited feet immediately',
      'Webbing is learned by sitting repeatedly',
      'Both arise only from an animal’s wishes',
      'Learning during one life differs from a physical trait passed to young.',
      'Learned and inherited'
    ],
    [
      'What must an animal still obtain even with helpful adaptations?',
      'Food, water, shelter and space',
      'Food only, because adaptations replace water needs',
      'Shelter only, because adaptations replace food needs',
      'Space only, because adaptations guarantee food and water',
      'Adaptations help with survival but do not replace habitat resources.',
      'Habitat needs'
    ],
    [
      'A white hare stands out on dark ground. What does this show?',
      'Camouflage depends on the background',
      'White fur hides animals on every surface',
      'Coat color is unrelated to being noticed',
      'Being inherited guarantees the coat hides it everywhere',
      'A helpful color on snow may contrast strongly with dark ground.',
      'Applying camouflage'
    ],
    [
      'A learner says a duck grows webbing because it wants to swim. Which correction fits?',
      'Webbing is inherited, not created by a wish',
      'Webbing is learned after one swim',
      'Webbing is created only by repeated swimming practice',
      'Webbing is a temporary choice rather than a body structure',
      'An individual’s desire does not create an inherited body structure.',
      'Adaptation misconception'
    ],
    [
      'Why should a camouflage model use equal-sized paper squares?',
      'To compare color without changing size too',
      'To guarantee both colors are equally noticeable',
      'To show size never affects what people notice',
      'To make the background color irrelevant',
      'Keeping size the same makes the color contrast comparison more useful.',
      'Fair camouflage model'
    ],
    [
      'Which explanation includes both a structure and how it works?',
      'Webbing broadens a duck’s feet so they push more water',
      'A duck has feet, so its habitat is always safe',
      'A duck wants to paddle, so new webbing appears',
      'Every duck foot works equally well in every task',
      'This links a physical feature to its paddling mechanism.',
      'Explaining a mechanism'
    ],
    [
      'A trait helps animals survive and their young inherit it. What can happen over many generations?',
      'The trait can become more common',
      'The trait must become less common because it helps survival',
      'Every animal must acquire the trait during its own lifetime',
      'The trait must help in every possible habitat',
      'Inherited helpful traits can spread across generations through survival and reproduction.',
      'Change across generations'
    ],
    [
      'An animal moves into shade for an afternoon. Which conclusion is supported?',
      'It changed its action; this alone does not show a new inherited trait',
      'It gained a new inherited trait just by changing places',
      'Its young must inherit everything it did that afternoon',
      'Any helpful action proves change across generations',
      'A temporary response is different from inherited change across generations.',
      'Temporary responses'
    ],
    [
      'A seasonal migrant has webbed feet. How should its two traits be classified?',
      'Migration: behavioral; webbing: structural',
      'Migration: structural; webbing: behavioral',
      'Both are structures because both help survival',
      'Both are learned tricks because both involve movement',
      'Migration is an action pattern, while webbing is a body feature.',
      'Mastery: classification'
    ],
    [
      'Why could a helpful camouflage trait become less useful after a habitat changes?',
      'Its color may no longer blend with the new background',
      'An inherited color always blends equally well everywhere',
      'Background color has no effect on being noticed',
      'The animal can choose any inherited color immediately',
      'The value of camouflage depends on the surrounding conditions.',
      'Mastery: habitat change'
    ],
    [
      'Which explanation describes adaptation across generations?',
      'Helpful inherited traits can pass to young and become more common',
      'An animal wishes for a trait and grows it before sunset',
      'Practice always turns a learned skill into an inherited body part',
      'Animals with helpful traits no longer need to reproduce',
      'Adaptation involves inheritance, survival and reproduction over generations.',
      'Mastery: inherited adaptation'
    ],
  ],
);

final _matterAndChanges = scienceTopic(
  grade: 'g3',
  order: 3,
  title: 'Matter & Changes',
  prerequisiteTopicId: 'science.g3.animal-adaptations',
  subtitle: 'Compare what changes with what stays the same in a material.',
  minutes: '25–30 minutes',
  objectives: [
    'Describe physical changes to shape, size and state.',
    'Distinguish physical changes from changes that form new substances.',
    'Explain why salt is still present after dissolving in water.',
    'Use before-and-after evidence rather than one clue to classify a change.',
  ],
  introduction:
      'An ice cube melts in a cup. A piece of paper tears into smaller pieces. An old iron gate develops rust. All three look different afterward. Do they all change in the same way? We need to ask about the material, not just its appearance.',
  sections: [
    scienceSection('Matter and its properties',
        'Matter has mass and takes up space. Mass describes how much matter an object contains; we can compare it using a balance. A property is a feature we can observe or measure, such as shape, state or mass. A substance is a kind of material, such as water, iron or salt.\n\nA change can affect a property without making a new substance. Tearing a sheet changes its size and shape. Both large and small pieces are still paper. We can describe a change more carefully by comparing what was present before with what is present after.'),
    scienceSection('Physical changes',
        'A physical change alters size, shape or state without forming a new substance. Folding paper, crushing a piece of chalk and melting ice are examples. Chalk powder is still chalk. Ice and liquid water are the same substance in different states. Enough warming causes melting; enough cooling causes freezing.\n\nEvaporation changes liquid water into invisible water vapor. Condensation changes water vapor into liquid drops. Both are physical changes. Water particles rearrange as the state changes, but remain water particles. Solid particles vibrate in place, liquid particles move past one another, and gas particles spread much farther apart.'),
    scienceVisual('sci-g3-3-states',
        'Compare the particle arrangements. The dots represent the same substance in three states.'),
    scienceSection('Dissolving does not mean disappearing',
        'When salt dissolves in water, it spreads through the water in pieces too small to see. The water may look clear, but salt is still present. Dissolving ordinary table salt in water is a physical change: the salt does not become water or vanish.\n\nIf the water evaporates, salt can remain in the dish. The water leaves as vapor while the salt stays behind. We do not need to taste the mixture to check for salt. This is different from simply mixing large visible pieces: sand stirred into water can remain visible and settle. Both examples make mixtures without needing to form new substances.'),
    scienceVisual('sci-g3-3-dissolving',
        'Follow what happens to each material. Water can leave the dish; the dissolved salt remains.'),
    scienceSection('Chemical changes',
        'A chemical change forms one or more new substances. When iron rusts, some iron reacts with oxygen from the air. Water helps rusting occur. Rust is a different substance from the iron it forms from. A rusty gate contains both remaining iron and rust.\n\nBaking cake batter is another chemical-change example: heating causes ingredients to form new substances with new properties. Changes in color, smell or gas production can be clues. A clue alone is not proof. Boiling water makes gas bubbles, but the gas is still water vapor. Adding color to paper changes its appearance without proving that the paper itself formed a new substance.'),
    scienceVisual('sci-g3-3-before-after',
        'The useful question is whether the material stayed the same substance or formed a new one.'),
    scienceSection('Worked example: use the right question',
        'A learner calls torn paper a chemical change because it is hard to turn the pieces back into the original sheet. Step 1: identify the starting material—paper. Step 2: inspect the pieces—they are still paper. Step 3: classify the change—physical, because no new substance formed.\n\nSome physical changes are hard to reverse. Melting ice can be reversed by freezing, but rebuilding a torn sheet is difficult. Ease of reversing is a helpful observation, not the definition of a physical or chemical change.'),
    scienceSection('Guided example: a closed bag of ice',
        'A sealed bag contains 20 grams of ice. All the ice melts, and no water enters or leaves. Predict the mass of the water in the bag. Has the change made a new substance?'),
    scienceSection('Reveal: the water stayed inside',
        'The water still has a mass of 20 grams. It changed state but none left or entered. It remains water, so melting is a physical change. If water escaped from an open dish, the dish’s contents could have less mass.',
        reveal: true),
    scienceSection('Observe a change safely',
        'With an adult, stir a small spoon of salt into water in a shallow dish. Record what is visible before and after. Leave the labeled dish where it cannot spill and observe over several days as water evaporates. Do not taste it, heat it or mix household cleaners. Observe rust on an existing gate from a safe distance without touching sharp metal.'),
    scienceSection('Common mistakes',
        'Clear salt water is not necessarily pure water. A state change does not create a new substance. Bubbles or color changes alone do not prove a chemical change. A physical change need not be easy to undo.'),
    scienceSection('Quick check',
        'Classify crushed chalk and rusting iron. Explain why dissolved salt is still in the dish before the water evaporates.'),
    scienceSection('Check your thinking',
        'Crushed chalk is a physical change because it remains chalk. Rusting is chemical because new rust forms. Dissolved salt spreads through the water and remains present even when it is too small to see.',
        reveal: true),
    scienceSection('Recap',
        'Physical changes alter properties while keeping the substances. Chemical changes form new substances. Compare materials before and after, and use several observations. Do not decide only from appearance or how easy the change is to reverse.'),
  ],
  keyConcept:
      'A physical change keeps the substances; a chemical change forms new substances. Evidence about the material matters more than appearance alone.',
  questions: [
    [
      'Which description defines matter?',
      'It has mass and takes up space',
      'It must always be visible',
      'It must always be a solid',
      'It must always be alive',
      'Matter has mass and occupies space, including invisible gases.',
      'Matter'
    ],
    [
      'Which is a physical change?',
      'Folding paper',
      'Iron forming rust',
      'Baking cake batter',
      'Iron reacting with oxygen',
      'Folding changes shape but the material remains paper.',
      'Physical changes'
    ],
    [
      'What happens during a chemical change?',
      'New substances form',
      'Only size can change',
      'The original substance always stays unchanged',
      'Matter must disappear completely',
      'The formation of new substances defines a chemical change.',
      'Chemical changes'
    ],
    [
      'An ice cube warms enough to become liquid water. Which change occurred?',
      'Melting',
      'Freezing',
      'Evaporation',
      'Condensation',
      'Enough warming can melt solid ice into liquid water.',
      'State changes'
    ],
    [
      'Which change turns liquid water into water vapor?',
      'Evaporation',
      'Condensation',
      'Freezing',
      'Rusting',
      'Evaporation is a liquid-to-gas state change.',
      'Evaporation'
    ],
    [
      'What happens to salt when it dissolves in water?',
      'It spreads through the water and remains present',
      'It becomes the water itself',
      'It leaves the dish immediately as vapor',
      'It disappears from matter completely',
      'Dissolved salt is present even when individual pieces cannot be seen.',
      'Dissolving'
    ],
    [
      'Which substance forms when iron rusts?',
      'Rust',
      'Liquid water',
      'Table salt',
      'Chalk',
      'Some iron forms a new substance called rust.',
      'Rusting'
    ],
    [
      'Why is melting ice a physical change?',
      'The material is still water',
      'It makes a new substance called liquid',
      'It destroys all the water particles',
      'It must change the water into salt',
      'Ice and liquid water are different states of the same substance.',
      'Classifying state changes'
    ],
    [
      'Which description fits solid particles in the model?',
      'They stay close and vibrate in place',
      'They do not move at all',
      'They spread much farther apart than gas particles',
      'They change into new substances whenever they move',
      'Solid particles vibrate; they are not completely still.',
      'Particle model'
    ],
    [
      'What can remain after water evaporates from salt water?',
      'Salt',
      'Only liquid water',
      'Only salt vapor that leaves with water',
      'Nothing, because both materials vanish',
      'The water can leave as vapor while salt remains in the dish.',
      'Salt recovery'
    ],
    [
      'Why is crushing chalk a physical change?',
      'Smaller pieces remain chalk',
      'Powder is always a new substance',
      'Only liquids can remain the same substance after a shape change',
      'Only chemical changes can change size',
      'Crushing changes size without changing chalk into a new substance.',
      'Size changes'
    ],
    [
      'What helps iron rust?',
      'Oxygen from air and water',
      'Only reshaping the iron',
      'Only folding the iron',
      'Removing both air and water',
      'Iron reacts with oxygen, and water helps rusting occur.',
      'Rusting conditions'
    ],
    [
      'Which observation distinguishes sand mixed into water from dissolved salt?',
      'Sand can remain visible and settle',
      'Sand always spreads until it cannot be seen',
      'Salt always stays as large visible grains',
      'Sand mixing must form a new substance',
      'Sand can remain visible, while dissolved salt spreads in pieces too small to see.',
      'Mixtures'
    ],
    [
      'Which question best classifies a change as physical or chemical?',
      'Did a new substance form?',
      'Did the object become smaller?',
      'Was it hard to undo?',
      'Did its appearance change at all?',
      'New substance formation is the deciding distinction.',
      'Classification evidence'
    ],
    [
      'Torn paper is hard to restore. Which classification is still correct?',
      'Physical, because the pieces remain paper',
      'Chemical, because every hard-to-undo change is chemical',
      'Chemical, because smaller matter is a new substance',
      'Chemical, because every shape change forms a new substance',
      'Difficulty reversing does not define chemical change.',
      'Reversibility misconception'
    ],
    [
      'Gas bubbles appear in boiling water. Why is that not enough evidence of chemical change?',
      'The bubbles contain water vapor, the same substance',
      'Every gas bubble must be a new substance',
      'Water particles stop being matter during boiling',
      'A state change always makes a new substance',
      'Boiling changes the state of water rather than forming a new substance.',
      'Clues and evidence'
    ],
    [
      'A sealed bag holds 20 grams of ice. It melts with nothing entering or leaving. What is the water’s mass?',
      '20 grams',
      '10 grams',
      '40 grams',
      '0 grams',
      'The material stays in the closed bag; its mass is unchanged.',
      'Closed-system mass'
    ],
    [
      'A dish of salt water looks clear. Which conclusion is supported?',
      'Salt may still be dissolved in it',
      'All the salt must have vanished',
      'It must contain only pure water',
      'Dissolving must have formed a new substance',
      'A clear appearance cannot show that dissolved salt is absent.',
      'Appearance and materials'
    ],
    [
      'Which comparison uses before-and-after evidence for a chemical change?',
      'Iron before; new rust present after',
      'Large chalk before; small chalk after',
      'Flat paper before; folded paper after',
      'Ice before; liquid water after',
      'New rust is a different substance, unlike the other changes.',
      'Chemical evidence'
    ],
    [
      'An open water dish has less liquid after several days. Which explanation fits evaporation?',
      'Some water moved into the air as vapor',
      'All water stayed liquid in the dish but became massless',
      'Some water changed into a new substance because it became gas',
      'Water vapor is no longer matter because it is invisible',
      'Evaporated water leaves the open dish as vapor.',
      'Matter in open systems'
    ],
    [
      'A learner claims every color change is chemical. Which example shows why this is unreliable?',
      'Adding color to paper changes appearance without proving the paper formed a new substance',
      'Iron forming new rust is a chemical change',
      'Cake batter forming new substances during baking is chemical',
      'A new substance can have different properties',
      'Appearance is a clue, but it cannot decide substance identity by itself.',
      'Mastery: evidence limits'
    ],
    [
      'A sealed container of liquid water freezes. What happens to substance and mass if nothing enters or leaves?',
      'It stays water and keeps the same mass',
      'It stays water but loses mass because it is colder',
      'It becomes a new substance called ice but keeps the same mass',
      'It stays water but gains mass because it is solid',
      'Freezing is a physical change within a closed container.',
      'Mastery: state and mass'
    ],
    [
      'After salt water dries, salt is visible in the dish. Which explanation fits?',
      'Water evaporated while salt remained',
      'Dissolved salt left with the water vapor',
      'Evaporation created salt from the water',
      'Salt could not have been present while invisible',
      'The result shows salt was still present when dissolved.',
      'Mastery: dissolving explanation'
    ],
  ],
);

final _forceAndMotion = scienceTopic(
  grade: 'g3',
  order: 4,
  title: 'Force & Motion',
  prerequisiteTopicId: 'science.g3.matter-changes',
  subtitle: 'Explain changes in movement using pushes, pulls and force arrows.',
  minutes: '25–30 minutes',
  objectives: [
    'Describe motion using position, direction and distance over a given time.',
    'Identify pushes, pulls, friction and gravity in everyday examples.',
    'Compare balanced and unbalanced forces on one object.',
    'Use a fair comparison to investigate a toy car’s motion.',
  ],
  introduction:
      'Give a toy car a gentle push. It moves, slows and stops. Nobody pulls it backward with a string. What changed its movement? To explain this, we need to look for forces acting on the car, including ones we cannot see directly.',
  sections: [
    scienceSection('Describe the motion first',
        'Motion is a change in position compared with a reference point. A reference point is something used for comparison, such as a mark on a table. A car moving away from the mark changes position. Direction tells where it moves: left, right, forward or backward.\n\nSpeed describes how fast an object moves. For a simple comparison, observe two cars for the same time. If Car A covers 20 centimeters in two seconds and Car B covers 40 centimeters in two seconds, Car B is faster over that time. You cannot compare speed from distance alone if the travel times are different.'),
    scienceVisual('sci-g3-4-distance',
        'The common zero baseline makes distances comparable. Both observations last two seconds.'),
    scienceSection('Pushes and pulls change motion',
        'A force is a push or pull. A hand pushes a toy car forward; a string can pull it toward you. Forces have direction and strength. A force can start motion, speed an object up, slow it down, stop it or turn it. Turning is a change in motion even if the speed stays the same.\n\nWe draw a force as an arrow on the object it acts on. The arrow points in the force’s direction. Within the same diagram, a longer arrow represents a stronger force. It does not automatically show where the object has already traveled. We must compare all the forces on that object.'),
    scienceSection('Forces with and without contact',
        'A hand push needs contact. Friction is also a contact force: it resists movement between touching surfaces. Friction helps a rolling toy car slow after the hand stops pushing. A rougher surface can cause more resistance than a smoother one, but compare the same car and similar starting motion to investigate fairly.\n\nGravity is the pull between masses. Near Earth, Earth’s gravity pulls objects downward, toward Earth. It acts without a hand or string touching the object. When a toy rests on a table, gravity still pulls down. The table pushes upward and supports the toy. A resting object can have forces acting on it.'),
    scienceVisual('sci-g3-4-contact',
        'Identify which forces need touching surfaces. Gravity acts without direct contact.'),
    scienceSection('Balanced and unbalanced forces',
        'Balanced forces cancel each other’s effects on the same object. Equal pushes in opposite directions are balanced. A block initially at rest stays at rest when all its forces balance. An object already moving keeps the same speed and direction if all forces balance. Balanced does not always mean stopped.\n\nUnbalanced forces do not cancel. They change an object’s motion. If a rightward force is stronger than an opposing leftward force, the motion changes toward the right. A resting block can start moving right. If the block was moving left, that same rightward imbalance can first slow it. Force direction and present travel direction need not be the same.'),
    scienceVisual('sci-g3-4-forces',
        'Compare arrow lengths on each block. Consider the starting motion before predicting what happens.'),
    scienceSection('Worked example: why the car slows',
        'A toy car rolls right after a hand releases it. Step 1: name its starting motion—rolling right. Step 2: the hand is no longer pushing. Step 3: resistance, including friction, acts against its motion. The forces are unbalanced backward, so it slows.\n\nThe car does not need a continuous hand push to remain moving for a while. It slows because resisting forces act. If all forces balanced, its speed and direction would remain unchanged.'),
    scienceSection('Guided example: compare the arrows',
        'A block is initially still. A long force arrow points right and a shorter one points left. Vertical forces are balanced. Are the horizontal forces balanced? Which way will the block begin to move?'),
    scienceSection('Reveal: the stronger direction',
        'The horizontal forces are unbalanced because the opposite arrows have different lengths. The stronger rightward force makes the resting block begin moving right.',
        reveal: true),
    scienceSection('Investigate safely',
        'On a clear floor, mark a starting line and gently roll a toy car on a smooth surface. Repeat on a towel. Keep the car, starting position and starting motion as similar as possible. Measure distance from the line to its stopping point. Repeat each trial; hand pushes can vary. Compare the results rather than deciding from one roll. Keep cars away from stairs and people; do not test by pushing classmates.'),
    scienceSection('Common mistakes',
        'A stopped object may still have balanced forces. A moving object may also have balanced forces. An arrow for a force is not a record of travel. Turning counts as changing motion. A car that traveled farther was faster only if the compared time was the same.'),
    scienceSection('Quick check',
        'Why can a table-supported toy stay still while gravity acts? If two cars travel for two seconds, which is faster: one covering 20 cm or one covering 40 cm?'),
    scienceSection('Check your thinking',
        'Upward support can balance downward gravity. The car covering 40 cm is faster over the same two seconds.',
        reveal: true),
    scienceSection('Recap',
        'Describe motion before explaining it. Forces are pushes or pulls with strength and direction. Balanced forces leave motion unchanged; unbalanced forces change speed or direction. Friction resists movement, and gravity pulls objects toward Earth.'),
  ],
  keyConcept:
      'Unbalanced forces change motion. Balanced forces keep an object at rest or moving at the same speed in the same direction.',
  questions: [
    [
      'What is a force?',
      'A push or pull',
      'A distance traveled',
      'A time interval',
      'A reference mark',
      'A force is a push or pull with strength and direction.',
      'Force meaning'
    ],
    [
      'What does motion describe?',
      'A change in position relative to a reference point',
      'Only a change in an object’s color',
      'Only a change in a material’s state',
      'Only the mass measured on a balance',
      'Motion is described by comparing position with a reference point.',
      'Motion'
    ],
    [
      'Which force pulls a toy downward near Earth?',
      'Gravity',
      'Upward table support',
      'A forward hand push',
      'A sideways string pull',
      'Earth’s gravity pulls objects toward Earth.',
      'Gravity'
    ],
    [
      'What does friction usually do to a rolling toy after a push ends?',
      'Resist its motion',
      'Push it in its travel direction',
      'Keep its speed unchanged on every surface',
      'Act only when someone touches the toy by hand',
      'Friction between touching surfaces helps resist movement.',
      'Friction'
    ],
    [
      'What does a force arrow’s direction show?',
      'The direction of the force',
      'The direction the object must already be moving',
      'The direction of the object’s past travel',
      'Only the direction of gravity in every diagram',
      'A force arrow points in the direction of the push or pull.',
      'Force arrows'
    ],
    [
      'What does a longer arrow mean within the same force diagram?',
      'A stronger force',
      'A longer travel time',
      'A larger distance already traveled',
      'A slower clock reading',
      'Arrow length compares force strength, not journey length.',
      'Force strength'
    ],
    [
      'Which action changes motion even if speed stays the same?',
      'Turning',
      'Keeping the same direction',
      'Continuing at the same speed in a straight line',
      'Staying still at a reference point',
      'Changing direction is a change in motion.',
      'Direction changes'
    ],
    [
      'A resting block has equal forces left and right, with all other forces balanced. What happens?',
      'It stays at rest',
      'It starts right because any push must move it',
      'It starts left because two forces always cause motion',
      'It turns because equal forces cannot cancel',
      'Balanced forces do not change the block’s initial state of rest.',
      'Balanced forces at rest'
    ],
    [
      'A car is already moving and all forces balance. What happens to its motion?',
      'Its speed and direction stay the same',
      'It must immediately stop',
      'It must speed up',
      'It must turn around',
      'Balanced forces leave existing motion unchanged.',
      'Balanced forces in motion'
    ],
    [
      'What balances downward gravity on a toy resting on a table?',
      'Upward force from the table',
      'Another downward pull',
      'No force at all',
      'The toy has no downward force while still',
      'The table pushes up while gravity pulls down.',
      'Support and gravity'
    ],
    [
      'Car A travels 20 cm and Car B travels 40 cm in the same two seconds. Which is faster?',
      'Car B',
      'Car A',
      'Both have the same speed',
      'Neither is moving',
      'Car B covers more distance in the same time.',
      'Comparing speed'
    ],
    [
      'Which force acts without direct contact from a hand or string?',
      'Earth’s gravity',
      'A hand pushing the car',
      'Friction with a towel',
      'A table supporting the car',
      'Gravity acts at a distance; the other examples involve contact.',
      'Contact and noncontact'
    ],
    [
      'Which observation shows an unbalanced force effect?',
      'A rolling car slows down',
      'A car stays at the same speed and direction',
      'A supported toy stays at rest',
      'A block stays still under balanced pushes',
      'A change in speed shows a change in motion caused by unbalanced forces.',
      'Unbalanced force evidence'
    ],
    [
      'Why compare the same toy car on a floor and towel?',
      'To change the surface while keeping the car the same',
      'To guarantee each hand push is identical',
      'To prove both surfaces have no friction',
      'To compare two different car masses at once',
      'Keeping the car the same makes surface effects easier to investigate.',
      'Fair comparisons'
    ],
    [
      'A resting block has a longer right arrow than left arrow. Other forces balance. What happens?',
      'It begins moving right',
      'It begins moving left',
      'It stays still because opposite arrows always cancel',
      'It must move upward',
      'The horizontal imbalance points right and changes the resting block’s motion.',
      'Applying force arrows'
    ],
    [
      'A block moves left, but the unbalanced force points right. What can happen first?',
      'It slows its leftward motion',
      'It must speed up leftward',
      'Its motion cannot change',
      'It must instantly travel right at full speed',
      'A force opposite the present movement can slow the object.',
      'Force and travel direction'
    ],
    [
      'Why repeat toy-car trials instead of relying on one roll?',
      'Starting pushes can vary between trials',
      'One roll always represents every possible result',
      'Every hand push is already identical without checking',
      'Repeats guarantee the same stopping distance each time',
      'Several trials help account for variation in hand pushes.',
      'Repeated observations'
    ],
    [
      'A learner says a still toy has no forces. Which evidence corrects this?',
      'Gravity pulls down and the table pushes up',
      'A still toy cannot have gravity acting on it',
      'Support acts only after a toy starts falling',
      'Only moving objects can have opposing forces',
      'A still object can have forces that balance.',
      'Forces at rest misconception'
    ],
    [
      'Two cars travel different distances, but their travel times differ. What else is needed to compare speed?',
      'Compare the distances over the same time',
      'Assume both cars traveled for the same time without checking',
      'Ignore travel time and compare only total distance',
      'Assume the longer distance is always faster',
      'Distance alone is not enough when the times are different.',
      'Interpreting speed evidence'
    ],
    [
      'A car rolls after the pushing hand lets go. Why can it later stop?',
      'Resisting forces can slow it',
      'It stops because movement always needs a touching hand',
      'Friction stops acting once the hand releases it',
      'Any balanced force must stop a moving object',
      'Resistance acts after release and changes the motion.',
      'Explaining slowing'
    ],
    [
      'A car turns a corner at unchanged speed. What can you infer about forces?',
      'They are unbalanced because direction changes',
      'They must balance because speed is unchanged',
      'No force can affect a turning car',
      'The car must be at rest during the turn',
      'Changing direction requires unbalanced forces even at steady speed.',
      'Mastery: changing direction'
    ],
    [
      'Which statement correctly compares balanced and unbalanced forces?',
      'Balanced forces leave motion unchanged; unbalanced forces change it',
      'Balanced forces always stop motion; unbalanced forces always speed it up',
      'Balanced forces act only at rest; unbalanced forces act only during movement',
      'Balanced forces always speed objects up; unbalanced forces always stop them',
      'Motion includes both speed and direction, which only unbalanced forces change.',
      'Mastery: force comparison'
    ],
    [
      'A still block has a long force arrow right and a shorter one left. Other forces balance. What does this show?',
      'Stronger force right, so the block’s motion will change rightward',
      'The block has already traveled farther right than left',
      'The left force must be stronger because its arrow is shorter',
      'The block must stay still because it started still',
      'Force arrows compare pushes on the block; they do not show its past travel.',
      'Mastery: diagram interpretation'
    ],
  ],
);

final _weatherPatterns = scienceTopic(
  grade: 'g3',
  order: 5,
  title: 'Weather Patterns',
  prerequisiteTopicId: 'science.g3.force-motion',
  subtitle:
      'Measure daily weather and explain how water moves through the environment.',
  minutes: '25–30 minutes',
  objectives: [
    'Match temperature, rainfall and wind measurements to instruments.',
    'Read a weather log using units and equal observation intervals.',
    'Describe evaporation, condensation, precipitation and runoff.',
    'Distinguish a weather observation from a water-cycle process and a forecast.',
  ],
  introduction:
      'Yesterday your playground was dry; today puddles cover it. By tomorrow some puddles may be smaller. We can investigate two questions: what was the weather each day, and where did the water go? A daily record and a water-cycle model help in different ways.',
  sections: [
    scienceSection('Describe and measure the weather',
        'Weather is the condition of the air at a place and time. Temperature, wind, cloud cover and rainfall help describe it. Temperature tells how hot or cold the air is. A thermometer measures it. We will use degrees Celsius, written °C. A reading of 30 °C is warmer than 24 °C.\n\nCloud cover describes how much sky is covered by clouds. We can record clear, partly cloudy or overcast. Overcast means clouds cover most or all of the sky. Clouds do not guarantee rain: a cloudy day can stay dry. A report should include the place and time, because weather can differ between places and change during the day.'),
    scienceSection('Tools for rain and wind',
        'A rain gauge collects rain and measures its depth, often in millimeters, written mm. More millimeters means more rainfall during the measured interval. A reading of 0 mm means no rain was collected in that interval, not that the place can never have rain.\n\nWind is moving air. A wind vane shows the direction wind comes from. A north wind comes from the north, even though it blows toward the south. An anemometer measures wind speed, or how fast air moves. Direction and speed are different properties. A rain gauge cannot tell wind speed, and a wind vane cannot measure rainfall.'),
    scienceVisual('sci-g3-5-instruments',
        'Choose a tool that measures the property you need. Keep its units in your record.'),
    scienceSection('Use a record to find patterns',
        'A weather log is a dated record of observations and measurements. To compare daily temperatures, use the same suitable place and time each day. A thermometer in direct sunlight can heat more than the surrounding air, so an adult should choose a sheltered, shaded measuring position. For rainfall comparisons, use the same gauge and equal intervals.\n\nA pattern is a repeated or regular relationship in observations. Many places often warm during daylight and cool later, but clouds and changing air can alter that pattern. Several observations help us test a pattern. One rainy afternoon does not prove that every afternoon will be rainy. A forecast predicts future weather using many measurements; a short log alone cannot guarantee the next day.'),
    scienceVisual('sci-g3-5-rainfall',
        'This example log measures rainfall, not cloud cover or temperature. Read the day and the unit together.'),
    scienceSection('Water changes state and moves',
        'The water cycle describes water moving among air, land and bodies of water. Evaporation changes liquid water to invisible water vapor. Energy from sunlight can help surface water evaporate; evaporation can occur without boiling. A puddle can shrink as water enters the air.\n\nCondensation changes water vapor into liquid droplets when conditions allow, often as air cools. Clouds contain tiny liquid droplets, ice crystals or both; they are not just invisible vapor. Precipitation is water falling from clouds, such as rain or snow. Tiny droplets may grow large enough to fall as rain. Water collecting on the ground can flow over land as runoff into rivers, lakes or oceans. Some soaks into soil.'),
    scienceVisual('sci-g3-5-water-cycle',
        'Follow one possible path. Water does not always take every step in this order or complete a round in one day.'),
    scienceSection('Worked example: read the rainfall bars',
        'The example log shows Monday 2 mm, Tuesday 6 mm, Wednesday 0 mm and Thursday 8 mm. Which day had the most measured rain? Step 1: compare the values in the same unit. Step 2: 8 is the largest value. Step 3: match it to Thursday.\n\nHow much rain was collected across the four intervals? Add 2 + 6 + 0 + 8 = 16 mm. This total describes these observations. It does not tell us the temperature or guarantee how much rain will fall on Friday.'),
    scienceSection('Guided example: explain a puddle',
        'A puddle becomes smaller on a dry day. A learner says its water must have vanished. What process can move liquid water into the air? Could water also move into the ground?'),
    scienceSection('Reveal: follow the water',
        'Evaporation can turn liquid water into invisible vapor in the air. Some water may also soak into soil. A smaller puddle shows that water left the puddle; it does not show that water stopped existing.',
        reveal: true),
    scienceSection('Make a safe weather log',
        'With an adult, record cloud cover and an available thermometer reading at the same time for several days. Write the place, time, unit and observation. Use an adult-installed rain gauge if available; compare equal intervals. Observe from shelter during bad weather. Stay indoors when thunder is heard. Never enter floodwater or climb to install instruments.'),
    scienceSection('Common mistakes',
        'Weather measurements describe conditions; water-cycle terms describe processes. A cloud is not invisible water vapor. Wind direction names where wind comes from. A cycle is not a promise of rain every day, and a forecast is a prediction that can change with new information.'),
    scienceSection('Quick check',
        'Which tool measures rainfall? Does 0 mm on Wednesday predict no rain on Thursday? Which process forms liquid droplets from vapor?'),
    scienceSection('Check your thinking',
        'A rain gauge measures rainfall. Wednesday’s 0 mm does not predict Thursday; the example Thursday has 8 mm. Condensation forms liquid droplets from water vapor.',
        reveal: true),
    scienceSection('Recap',
        'Weather logs use observations, instruments, units and comparable intervals. The water cycle explains movement and state changes. Use records to investigate patterns, while keeping observations, process explanations and future predictions distinct.'),
  ],
  keyConcept:
      'Weather records describe conditions at a place and time. Water-cycle processes explain how water moves; neither a cycle diagram nor a short log guarantees tomorrow’s weather.',
  questions: [
    [
      'Which instrument measures air temperature?',
      'Thermometer',
      'Rain gauge',
      'Wind vane',
      'Anemometer',
      'A thermometer measures temperature, recorded here in degrees Celsius.',
      'Weather instruments'
    ],
    [
      'Which unit is used for rainfall depth in this lesson?',
      'Millimeters (mm)',
      'Degrees Celsius (°C)',
      'Seconds',
      'Grams',
      'A rain gauge reading is a depth of rainfall, here measured in mm.',
      'Rainfall units'
    ],
    [
      'What is wind?',
      'Moving air',
      'Liquid drops falling from clouds',
      'Water flowing across land',
      'Heat stored in a thermometer',
      'Wind is air in motion.',
      'Wind'
    ],
    [
      'What does a wind vane show?',
      'The direction wind comes from',
      'The amount of rain collected',
      'The temperature of air',
      'The speed of water runoff',
      'A wind vane reports wind direction, not its speed.',
      'Wind direction'
    ],
    [
      'What process changes liquid water into water vapor?',
      'Evaporation',
      'Condensation',
      'Precipitation',
      'Runoff',
      'Evaporation is the liquid-to-gas change.',
      'Evaporation'
    ],
    [
      'What process changes water vapor into liquid droplets?',
      'Condensation',
      'Evaporation',
      'Precipitation',
      'Runoff',
      'Condensation changes gas water into liquid drops.',
      'Condensation'
    ],
    [
      'What is precipitation?',
      'Water falling from clouds',
      'Water soaking into soil',
      'Water flowing over land',
      'Liquid water becoming vapor',
      'Rain and snow are examples of precipitation.',
      'Precipitation'
    ],
    [
      'Which reading is warmer?',
      '30 °C',
      '24 °C',
      'Both readings are equally warm',
      'Neither reading describes temperature',
      '30 is greater than 24 on the same Celsius scale.',
      'Temperature comparisons'
    ],
    [
      'What does 0 mm in a daily rain-gauge log mean?',
      'No rain was collected during that interval',
      'The place can never receive rain',
      'The air temperature was 0 °C',
      'The wind did not move all day',
      'A zero describes measured rainfall for that interval only.',
      'Interpreting measurements'
    ],
    [
      'Which tool measures wind speed?',
      'Anemometer',
      'Wind vane',
      'Rain gauge',
      'Thermometer',
      'Wind speed is measured with an anemometer.',
      'Wind speed'
    ],
    [
      'A wind vane reports a north wind. From which direction does the wind arrive?',
      'North',
      'South',
      'East',
      'West',
      'Wind is named for the direction it comes from.',
      'Naming wind direction'
    ],
    [
      'What do clouds contain?',
      'Tiny liquid droplets, ice crystals or both',
      'Only invisible water vapor',
      'Only large drops that have already reached the ground',
      'Only dry air with no water',
      'Clouds are made visible by droplets or ice, unlike invisible water vapor.',
      'Clouds'
    ],
    [
      'What is runoff?',
      'Water flowing over land',
      'Liquid water changing into vapor',
      'Vapor changing into droplets',
      'A thermometer measuring hot air',
      'Runoff carries water over the ground toward other places.',
      'Runoff'
    ],
    [
      'Why use equal time intervals when comparing rain-gauge readings?',
      'To compare rainfall over the same amount of time',
      'To make every reading the same number',
      'To guarantee the next day will be rainy',
      'To measure temperature instead of rain',
      'A longer collection interval could collect more simply because it lasted longer.',
      'Comparable intervals'
    ],
    [
      'Monday has 2 mm, Tuesday 6 mm, Wednesday 0 mm and Thursday 8 mm. Which day had the most rainfall?',
      'Thursday',
      'Tuesday',
      'Monday',
      'Wednesday',
      'Thursday’s 8 mm is the largest recorded value.',
      'Reading rainfall data'
    ],
    [
      'What is the total of 2 mm, 6 mm, 0 mm and 8 mm rainfall?',
      '16 mm',
      '8 mm',
      '14 mm',
      '18 mm',
      'Add the readings: 2 + 6 + 0 + 8 = 16 mm.',
      'Summing rainfall'
    ],
    [
      'Why place an air thermometer in a suitable shaded position?',
      'Direct sunlight can heat the instrument above the surrounding air',
      'Shade prevents all daily changes in air temperature',
      'A shaded thermometer cannot measure warm air',
      'Direct sun always gives the most accurate air temperature',
      'A suitable shaded position helps measure air temperature rather than extra heating of the instrument.',
      'Measurement conditions'
    ],
    [
      'A cloudy day has no collected rain. Which explanation is accurate?',
      'Cloud cover does not guarantee rainfall',
      'Every cloud must release rain immediately',
      'A rain gauge measures cloud cover instead of rain',
      'No rain proves there were no clouds',
      'Clouds and rainfall are related, but a cloudy day can remain dry.',
      'Clouds and rain'
    ],
    [
      'A puddle shrinks without boiling. Which explanation is possible?',
      'Liquid water evaporates into invisible vapor',
      'Evaporation requires boiling, so none can occur',
      'Every drop must become a visible cloud at once',
      'Water cannot leave a puddle on a dry day',
      'Evaporation can occur from a liquid surface without boiling.',
      'Explaining puddle changes'
    ],
    [
      'Four days of rainfall rise and fall. What can the log alone establish?',
      'How much rain was recorded on those days',
      'Exactly how much rain will fall on every future day',
      'That every cloudy day must have equal rain',
      'That the water cycle stops on dry days',
      'A short record describes observations, but does not guarantee a future pattern.',
      'Evidence limits'
    ],
    [
      'Which statement compares a weather log and a water-cycle diagram accurately?',
      'A log records conditions; a cycle diagram explains water processes',
      'A log guarantees future rainfall; a cycle lists measured rain amounts',
      'Both guarantee that every afternoon must be rainy',
      'Both record exact weather measurements for the same day',
      'The two tools answer different questions about conditions and water movement.',
      'Mastery: measurements and processes'
    ],
    [
      'An observer records a west wind and 6 mm of rain. What do these mean?',
      'Wind comes from west; 6 mm rainfall was collected',
      'Wind comes from east; air temperature is 6 °C',
      'Wind comes from west; wind speed is 6 mm',
      'Wind comes from east; rainfall is 6 °C',
      'Keep wind direction and rainfall depth distinct, with the correct meaning and units.',
      'Mastery: interpreting a report'
    ],
    [
      'A learner says the water-cycle circle means rain must fall every day. Which correction fits?',
      'Water takes many paths and does not complete the diagram on a fixed daily schedule',
      'Every water particle completes every step once each afternoon',
      'A dry day means water has ceased to exist',
      'Condensation and precipitation always happen at the same instant',
      'A cycle model explains possible movement, not a guaranteed daily forecast.',
      'Mastery: cycle model limits'
    ],
  ],
);
