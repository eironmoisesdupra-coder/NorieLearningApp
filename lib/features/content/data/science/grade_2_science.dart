import '../../domain/norie_content_models.dart';
import 'science_lesson_builder.dart';
import 'science_figure.dart';

final List<NorieTopicContent> grade2ScienceTopics = [
  _lifeCycles,
  _habitats,
  _statesOfMatter,
  _lightAndSound,
  _earthAndSky,
];

const Map<String, ScienceFigure> grade2ScienceFigures = {
  'sci-g2-1-life-cycle': ScienceFigure(
    picture: 'butterfly',
    title: 'Butterfly life cycle',
    kind: 'cycle',
    labels: ['Egg', 'Caterpillar', 'Pupa', 'Adult butterfly'],
    details: [
      'An adult lays eggs.',
      'The young animal eats and grows.',
      'The body changes inside.',
      'An adult can lay eggs for a new generation.'
    ],
    note:
        'The arrows connect generations. The same adult does not turn back into an egg.',
  ),
  'sci-g2-1-bean-cycle': ScienceFigure(
    picture: 'bean',
    title: 'A bean plant makes new seeds',
    kind: 'cycle',
    labels: ['Seed', 'Seedling', 'Adult plant', 'New seeds'],
    details: [
      'A root begins to grow.',
      'A shoot grows upward.',
      'Flowers can develop into pods.',
      'Seeds inside pods can start new plants.'
    ],
    note:
        'Seeds need water, air and suitable warmth to begin growing. Growing seedlings also need light.',
  ),
  'sci-g2-2-habitat-needs': ScienceFigure(
    picture: 'habitat',
    title: 'A bird needs more than a nest',
    kind: 'comparison',
    labels: ['Food', 'Water', 'Shelter', 'Space'],
    details: [
      'Suitable seeds or insects provide food.',
      'A clean water source provides drinking water.',
      'Leaves and branches offer cover.',
      'Room is needed to move and find resources.'
    ],
    note:
        'A nest is one part of a habitat. A habitat must meet the animal’s needs.',
  ),
  'sci-g2-2-habitat-places': ScienceFigure(
    title: 'Different places offer different conditions',
    kind: 'comparison',
    labels: ['Garden', 'Freshwater pond', 'Desert'],
    details: [
      'Plants can supply food and cover for birds and insects.',
      'Water supports freshwater fish; pond edges can shelter other animals.',
      'Little rain means plants and animals must cope with scarce water.'
    ],
    note:
        'A habitat suits particular living things. One place does not suit every kind.',
  ),
  'sci-g2-3-particles': ScienceFigure(
    title: 'Three states of matter',
    kind: 'particles',
    labels: ['Solid', 'Liquid', 'Gas'],
    details: [
      'Keeps its own shape unless a force changes it.',
      'Flows and takes the shape of the part of the container it occupies.',
      'Spreads to fill available space in a closed container.'
    ],
    note:
        'Dots model tiny particles. They are not actual-size pictures. Solid particles also move, vibrating in place.',
  ),
  'sci-g2-3-melting-freezing': ScienceFigure(
    title: 'Water can change state',
    kind: 'cycle',
    labels: ['Ice: solid water', 'Liquid water'],
    details: [
      'Enough warming melts ice into liquid water.',
      'Enough cooling freezes liquid water into ice.'
    ],
    note: 'Melting and freezing change the state. The material is still water.',
  ),
  'sci-g2-3-water-air': ScienceFigure(
    title: 'Liquid water and water vapor',
    kind: 'process',
    labels: ['Liquid water', 'Water vapor', 'Liquid drops'],
    details: [
      'Evaporation can happen at the surface.',
      'Water in its gas state is invisible.',
      'Enough cooling can cause condensation.'
    ],
    note:
        'Visible mist contains tiny liquid drops; water vapor is invisible gas.',
  ),
  'sci-g2-4-seeing': ScienceFigure(
    title: 'How a lit book is seen',
    kind: 'process',
    labels: ['Lamp', 'Book', 'Eyes'],
    details: [
      'The lit lamp makes light.',
      'Some light reflects from the book.',
      'Light entering the eyes makes the book visible.'
    ],
    note:
        'The book reflects light. It does not make its own light like the lit lamp.',
  ),
  'sci-g2-4-shadow': ScienceFigure(
    picture: 'shadow',
    title: 'A card blocks light',
    kind: 'process',
    labels: ['Torch', 'Opaque card', 'Wall shadow'],
    details: [
      'A torch sends light toward the wall.',
      'The card blocks some of that light.',
      'The blocked region receives less light.'
    ],
    note:
        'Keep torch and wall fixed. Moving the card closer to the torch can make its shadow larger.',
  ),
  'sci-g2-4-sound': ScienceFigure(
    title: 'From a ringing bell to an ear',
    kind: 'process',
    labels: ['Vibrating bell', 'Air', 'Ear'],
    details: [
      'The bell moves back and forth.',
      'The vibration passes through the air.',
      'Sound reaches the listener’s ear.'
    ],
    note:
        'Faster vibration gives higher pitch. Louder and higher are different descriptions.',
  ),
  'sci-g2-5-day-night': ScienceFigure(
    picture: 'daynight',
    title: 'Sunlight reaches one side at a time',
    kind: 'comparison',
    labels: ['Facing the Sun', 'Facing away from the Sun'],
    details: [
      'This part of Earth receives sunlight: daytime.',
      'This part does not receive direct sunlight: nighttime.'
    ],
    note:
        'Earth rotates. A place turns into and out of sunlight. Clouds can make daytime darker without causing night.',
  ),
  'sci-g2-5-sky-objects': ScienceFigure(
    title: 'Sun, Moon and other stars',
    kind: 'comparison',
    labels: ['Sun', 'Moon', 'Other stars'],
    details: [
      'A nearby star that makes its own light.',
      'An object that reflects sunlight; sometimes visible by day.',
      'Distant stars that make their own light; easier to see in a dark sky.'
    ],
    note:
        'Clouds are in Earth’s air. The Sun, Moon and other stars are beyond that air in space.',
  ),
  'sci-g2-5-daily-pattern': ScienceFigure(
    title: 'A repeating local pattern',
    kind: 'cycle',
    labels: ['Morning', 'Daytime', 'Evening', 'Nighttime'],
    details: [
      'Your place turns into sunlight.',
      'Your place receives sunlight.',
      'Your place turns out of sunlight.',
      'Your place faces away from the Sun.'
    ],
    note:
        'In our usual local pattern, a full turn takes about 24 hours. This diagram does not show the Sun going around Earth.',
  ),
};

final _lifeCycles = scienceTopic(
  grade: 'g2',
  order: 1,
  title: 'Life Cycles',
  prerequisiteTopicId: null,
  subtitle: 'Follow a butterfly and a bean plant as new living things grow.',
  minutes: '20–25 minutes',
  objectives: [
    'Put the four butterfly stages in order.',
    'Describe how a bean seed becomes a plant that makes new seeds.',
    'Compare a young animal with an adult.',
    'Explain why a life-cycle arrow can lead to a new generation.',
  ],
  introduction:
      '🐛 A caterpillar on a leaf looks very different from a butterfly. Yet they can be two stages of the same kind of animal. A tiny bean seed also looks different from a leafy plant. Let us follow these changes over time.',
  sections: [
    scienceSection('Growing and changing 🌱',
        'A life cycle describes the stages in the life of a living thing. A stage is one part of that sequence. Young living things grow and develop. An adult is a fully grown stage. Adults of a kind can produce new young living things. Those young begin the next generation.\n\nNot every living thing has the same stages. A kitten resembles an adult cat, but it is smaller. A caterpillar does not look like an adult butterfly. Both are young animals. Growing means more than simply getting taller. Body parts and abilities can change too.'),
    scienceSection('Four butterfly stages 🦋',
        'An adult butterfly lays eggs. A caterpillar hatches from an egg. Caterpillar is the name of the young, feeding stage. It eats suitable leaves and grows. Next comes the pupa stage. A butterfly pupa is also called a chrysalis. The animal may look still, but its body is changing inside.\n\nAn adult butterfly comes out of the pupa. Its wings let it fly after they are ready. The adult stage can produce the next generation of eggs. The egg, caterpillar, pupa and adult are stages of a butterfly, not four different kinds of animal.'),
    scienceVisual('sci-g2-1-life-cycle',
        'Follow the arrows: egg → caterpillar → pupa → adult. New eggs begin a new generation.'),
    scienceSection('From bean to bean 🌿',
        'A bean seed holds a tiny young plant and stored food. With water, air and suitable warmth, the seed can begin growing. A root grows downward. A shoot grows upward. A small young plant is called a seedling. Its leaves use light as the plant grows.\n\nAn adult bean plant can make flowers. Some flowers develop into pods containing new seeds. Those seeds can grow into new bean plants. A seed does not turn into an animal. It grows into the same kind of plant that made it.'),
    scienceVisual('sci-g2-1-bean-cycle',
        'Roots and shoots grow before a bean plant makes flowers and new seeds.'),
    scienceSection('Worked example: read the arrow 🔎',
        'A picture shows a caterpillar, then an arrow, then a pupa. What does the arrow mean? First name the starting stage: caterpillar. Next name the stage it grows into: pupa. The arrow shows the order of change. It does not mean that the caterpillar eats the pupa.\n\nNow follow the arrow from adult butterfly to egg. This arrow connects an adult to the eggs it can produce. The adult does not shrink into an egg. A new individual begins its life.'),
    scienceSection('Guided example: a missing stage 🤔',
        'Read this sequence: seed → ____ → adult bean plant → new seeds. Which stage belongs in the gap? Think about a small plant with a root, a shoot and its first leaves.'),
    scienceSection('Reveal: the young plant',
        'The missing stage is seedling. A seedling comes after the seed begins growing and before the adult plant. The new seeds at the end belong to the next generation.',
        reveal: true),
    scienceSection('Observe safely 📒',
        'With an adult, place a bean seed on a damp paper towel in a clear cup. Keep it damp, not flooded. Observe for several days. Draw the first root and then the shoot if they appear. Compare each drawing with the day before. Place a growing seedling where it gets suitable light. Do not taste the seed or touch mold. Leave wild caterpillars and eggs where they are.'),
    scienceSection('Common mistakes ⚠️',
        'A pupa is not an empty shell with nothing happening. The animal develops inside. A life-cycle circle does not mean one animal lives forever. It connects parents and new young. Plants and animals both have life cycles, but their stage names differ. There is no butterfly stage in a bean plant life cycle.'),
    scienceSection('Quick check 🧠',
        'Which butterfly stage comes just after the egg? Why does an adult bean plant connect to new seeds in a life-cycle diagram?'),
    scienceSection('Check your thinking',
        'A caterpillar hatches from the egg. An adult bean plant can produce seeds. Each new seed can begin a new plant, so the cycle continues through another generation.',
        reveal: true),
    scienceSection('Recap 🌟',
        'Butterflies develop through egg, caterpillar, pupa and adult stages. Beans develop from seeds into seedlings and adult plants that can make new seeds. Life-cycle diagrams show an order of stages and how one generation leads to the next.'),
  ],
  keyConcept:
      'Living things grow through stages. Adults can produce new young, beginning another generation.',
  questions: [
    [
      'What does a life cycle describe?',
      'Stages in the life of a living thing',
      'Only the places an animal visits',
      'Only the color of a plant',
      'The meals eaten in one day',
      'A life cycle follows growth and development through stages.',
      'Life-cycle meaning'
    ],
    [
      'What hatches from a butterfly egg?',
      'A caterpillar',
      'An adult butterfly',
      'A pupa',
      'A seedling',
      'The caterpillar is the young stage that hatches from the egg.',
      'Butterfly stages'
    ],
    [
      'Which butterfly stage comes after the caterpillar?',
      'Pupa',
      'Egg',
      'Adult butterfly',
      'Caterpillar',
      'The growing caterpillar develops into a pupa.',
      'Butterfly stages'
    ],
    [
      'What is a butterfly pupa also called?',
      'A chrysalis',
      'A caterpillar',
      'An egg',
      'An adult butterfly',
      'Chrysalis is another name for a butterfly pupa.',
      'Butterfly vocabulary'
    ],
    [
      'What do we call a small young bean plant?',
      'A seedling',
      'A pupa',
      'An egg',
      'A caterpillar',
      'A seedling is the young plant stage after a seed begins growing.',
      'Plant stages'
    ],
    [
      'Which part of a bean seedling grows downward?',
      'Root',
      'Shoot',
      'Stem',
      'Leaf',
      'The root grows downward; the shoot grows upward.',
      'Plant growth'
    ],
    [
      'Where can new bean seeds form?',
      'Inside pods',
      'Inside the plant’s roots',
      'Inside the plant’s leaves',
      'Inside the plant’s stem',
      'Bean flowers can develop into pods that contain seeds.',
      'Plant reproduction'
    ],
    [
      'Which sequence has the butterfly stages in the right order?',
      'Egg → caterpillar → pupa → adult',
      'Egg → pupa → caterpillar → adult',
      'Adult → caterpillar → egg → pupa',
      'Caterpillar → adult → pupa → egg',
      'The caterpillar hatches, grows into a pupa, and develops into an adult.',
      'Stage order'
    ],
    [
      'What happens inside the butterfly pupa?',
      'The animal develops and changes',
      'The caterpillar keeps eating leaves',
      'The animal becomes its own egg again',
      'The adult has already flown away',
      'The still-looking pupa contains an animal whose body is developing.',
      'Pupa development'
    ],
    [
      'Why is a kitten a young animal?',
      'It can grow into an adult cat',
      'It has already finished growing as an adult',
      'It is the egg stage of a cat',
      'It is the pupa stage of a cat',
      'A kitten resembles a cat and grows into the adult cat stage.',
      'Comparing life cycles'
    ],
    [
      'What does a seed need to begin growing?',
      'Water, air and suitable warmth',
      'Only light with no water',
      'Only warmth with no water',
      'Only water with no air',
      'Water, air and suitable warmth help a bean seed begin growing.',
      'Seed needs'
    ],
    [
      'Which pair names young stages of living things?',
      'Caterpillar and seedling',
      'Adult butterfly and adult cat',
      'Adult bean plant and adult butterfly',
      'Adult cat and adult bean plant',
      'A caterpillar is a young butterfly stage, and a seedling is a young plant.',
      'Young and adult'
    ],
    [
      'What do the arrows between life stages show?',
      'The order of growth and change',
      'The size of every living thing',
      'The color of each animal',
      'The food each stage eats',
      'Arrows connect stages in a sequence; they do not measure size or show meals.',
      'Reading a cycle'
    ],
    [
      'What helps a growing seedling after its leaves appear?',
      'Suitable light',
      'Keeping it in darkness',
      'Keeping its roots without water',
      'Removing its first leaves',
      'Growing leaves use light; a seedling needs suitable light to continue growing.',
      'Seedling needs'
    ],
    [
      'A life-cycle arrow leads from an adult butterfly to an egg. What does it mean?',
      'An adult can produce eggs for new young',
      'The adult turns back into its own egg',
      'The adult eats every egg',
      'Every egg is already an adult',
      'The arrow connects generations, not an adult changing back into an egg.',
      'New generations'
    ],
    [
      'A bean drawing has a root and its first small leaves. Which label fits?',
      'Seedling',
      'Unchanged dry seed',
      'Adult plant with pods',
      'Flower before any root grows',
      'Roots and the first leaves identify the young growing plant.',
      'Identifying a stage'
    ],
    [
      'A butterfly chart shows egg → ____ → pupa → adult. What fills the gap?',
      'Caterpillar',
      'Adult laying new eggs',
      'Egg before hatching',
      'A seedling growing its first leaves',
      'The caterpillar is the stage between egg and pupa.',
      'Completing a sequence'
    ],
    [
      'A learner says the still pupa is doing nothing. Which correction fits?',
      'Its body is developing inside',
      'It is already finished growing as an adult',
      'It is changing back to its own egg',
      'It needs no more change before flying',
      'A still-looking pupa remains a living, developing butterfly stage.',
      'Explaining development'
    ],
    [
      'Two bean drawings are made three days apart. The second has a longer root. What do they show?',
      'The young plant has grown',
      'The plant is already making new seeds',
      'The dry seed has stayed unchanged',
      'The root has changed into a shoot',
      'Comparing drawings over time gives evidence of plant growth.',
      'Observing growth'
    ],
    [
      'A bean plant makes seeds that grow into new plants. Which statement is correct?',
      'The new plants are bean plants',
      'The old plant turns back into one seed',
      'The seeds are already adult plants',
      'The young plants skip the seedling stage',
      'New bean seeds grow into the same kind of plant that produced them.',
      'Continuing a cycle'
    ],
    [
      'Which completed bean cycle shows a new generation?',
      'Seed → seedling → adult plant → new seeds',
      'Seed → adult plant → seedling → new seeds',
      'Seedling → new seeds → seed → adult plant',
      'Adult plant → its own seed → same adult again',
      'Beans grow into seedlings and adults that can produce new bean seeds.',
      'Mastery: plant cycle'
    ],
    [
      'A caterpillar and an adult butterfly look different. What links them?',
      'They are stages of the same kind of animal',
      'They must be different kinds of animal',
      'The caterpillar is an adult that lost its wings',
      'The adult becomes its own caterpillar again',
      'A young butterfly can look very different from its adult stage.',
      'Mastery: stage comparison'
    ],
    [
      'Why does a life-cycle diagram loop back to the beginning?',
      'New young can start the next generation',
      'Every adult becomes its own young self',
      'No living thing can die',
      'Every stage happens at the same time in one animal',
      'The loop connects generations; it does not mean an individual lives forever.',
      'Mastery: cycle meaning'
    ],
  ],
);

final _habitats = scienceTopic(
  grade: 'g2',
  order: 2,
  title: 'Habitats',
  subtitle: 'Find the food, water, shelter and space that living things need.',
  minutes: '20–25 minutes',
  prerequisiteTopicId: 'science.g2.life-cycles',
  objectives: [
    'Describe a habitat as a place that meets a living thing’s needs.',
    'Identify food, water, shelter and space in a bird’s habitat.',
    'Compare conditions in a garden, pond and desert.',
    'Predict how a change can remove a resource from a habitat.',
  ],
  introduction:
      '🐦 A bird rests in a tree near your window. The tree offers cover, but where does the bird drink? Where does it find food? A habitat is more than a sleeping place. We will look for the resources around it.',
  sections: [
    scienceSection('A place to live 🌳',
        'A habitat is the place where a living thing lives and finds what it needs. A resource is something it uses, such as food or water. Animals need suitable food, water, shelter and enough space. Shelter offers cover from weather or danger. Space gives room to move and find resources.\n\nA nest is a shelter used by some birds. It is not the whole habitat. A bird also uses places around its nest. It may find insects in a bush and water nearby. Its habitat includes the area it uses to meet these needs.'),
    scienceVisual('sci-g2-2-habitat-needs',
        'Look around the nest: food, water, shelter and space all matter.'),
    scienceSection('Many habitats nearby 🐟',
        'A garden can be a habitat. Flowering plants may supply food for butterflies. Leaves, shrubs and trees offer cover for many small animals. A freshwater pond is another habitat. Freshwater fish live in its water. The pond edge may support birds and other animals too.\n\nDifferent living things can share one area. They may use different parts of it. A fish lives in the water. A bird may feed near the edge and rest in a tree. Plants are also living things in a habitat. They need suitable light, water, air and space to grow.'),
    scienceSection('Different conditions 🌵',
        'Conditions are what a place is like. A pond is wet. A desert gets little rain, so water can be hard to find. Deserts are not all hot all the time. Some are cold. Animals and plants in a desert must be able to live with little available water.\n\nOcean water is salty. Freshwater in a pond is much less salty. A freshwater pond fish cannot simply be moved into ocean water and expected to live. The kind of water matters. A place that suits one living thing may not suit another.'),
    scienceVisual('sci-g2-2-habitat-places',
        'Compare resources and conditions. A wet pond and a dry desert meet different living things’ needs.'),
    scienceSection('Worked example: check every need 🔎',
        'A small bird has a tree for cover, suitable seeds for food, clean drinking water and room to fly between them. Is this area more useful than a box with only a perch? First check food and water. The tree area has both. Next check shelter and space. Branches offer cover, and the area has room to move. The box has a resting place but does not supply the other listed needs. A shelter by itself is not enough.'),
    scienceSection('Guided example: what changed? 🤔',
        'A garden has insects, bushes and a small clean drinking-water dish. The dish becomes empty during a dry week. The insects and bushes remain. Which listed resource has been lost? What could a responsible adult do?'),
    scienceSection('Reveal: track the resource',
        'The bird has lost that water source. Its food and shelter are still present. An adult could provide fresh, clean water in a suitable clean dish. The dish needs regular cleaning. Do not handle wildlife or move animals yourself.',
        reveal: true),
    scienceSection('Observe a habitat safely 📒',
        'From a safe path, window or school garden, choose one animal you can see. Make four drawing boxes: food, water, shelter and space. Draw only resources you can observe. If you cannot find a water source, mark it unknown. Not seeing water does not prove there is none. Watch without touching nests, feeding unknown food, entering water or moving animals. Ask an adult to help identify unfamiliar animals.'),
    scienceSection('Changes and care 🍃',
        'Cutting away every bush can remove cover. Litter in a pond can harm its habitat. A drying pond has less water for animals that live there. Some animals may move if another suitable place is available, but moving is not always possible. People can protect habitats by keeping litter out and caring for local plants. A beautiful-looking place still needs the right resources for the living things there.'),
    scienceSection('Common mistakes ⚠️',
        'A habitat is not only a house, burrow or nest. Those can be shelters inside a habitat. Water alone is not enough for every animal. Food, cover and space matter too. Do not put a wild animal in a new place because it looks comfortable to you. Its needs may be different from yours.'),
    scienceSection('Quick check 🧠',
        'A pond supplies water, but its sheltered edge is removed. Which need might be harder to meet for a bird resting there? Why is an ocean not the same habitat as a freshwater pond?'),
    scienceSection('Check your thinking',
        'The bird may lose shelter or cover. Ocean water is salty, while pond freshwater is much less salty. Different water conditions suit different living things.',
        reveal: true),
    scienceSection('Recap 🌟',
        'A habitat supplies resources under suitable conditions. Check food, water, shelter and space for an animal. Compare what each place offers. Observe carefully, mark what is unknown, and protect the living things already there.'),
  ],
  keyConcept:
      'A habitat is a place with suitable conditions and resources for the living things that use it.',
  questions: [
    [
      'What is a habitat?',
      'A place where a living thing meets its needs',
      'Only an animal’s sleeping spot',
      'Only the food an animal eats',
      'Only the name of an animal',
      'A habitat is the place used to live and find needed resources.',
      'Habitat meaning'
    ],
    [
      'Which resource gives an animal cover from weather?',
      'Shelter',
      'Food',
      'Drinking water',
      'Room to move',
      'Shelter offers protection or cover from weather and danger.',
      'Shelter'
    ],
    [
      'Which need is met by suitable seeds eaten by a bird?',
      'Food',
      'Shelter',
      'Space',
      'Drinking water',
      'Seeds can be food for a bird that eats them.',
      'Food resources'
    ],
    [
      'Which habitat feature supplies space for a bird?',
      'Room to move between feeding and resting places',
      'A dish of drinking water',
      'A supply of suitable seeds',
      'A leafy hiding place',
      'Space gives an animal room to move and reach resources.',
      'Space'
    ],
    [
      'Which place can be a habitat for a freshwater fish?',
      'A freshwater pond',
      'Salty ocean water',
      'A dry garden',
      'A dry desert dune',
      'A freshwater pond has the kind of water the fish lives in.',
      'Pond habitat'
    ],
    [
      'What is an important desert condition?',
      'Little rain',
      'Hot weather all year in every desert',
      'Salty ocean water everywhere',
      'Rain falls constantly',
      'Deserts get little rain, so available water can be scarce.',
      'Desert conditions'
    ],
    [
      'Which water is salty?',
      'Ocean water',
      'Freshwater in a pond',
      'Fresh drinking water',
      'Freshwater in a stream',
      'Ocean water is salty; freshwater is much less salty.',
      'Water conditions'
    ],
    [
      'Why is a nest not a bird’s whole habitat?',
      'The bird also needs resources around the nest',
      'The nest supplies food and water by itself',
      'A bird uses only the nest and nowhere else',
      'A bird needs shelter but no food or water',
      'A nest provides shelter, while the surrounding area can supply other needs.',
      'Shelter and habitat'
    ],
    [
      'How can a fish and a bird use the same pond area differently?',
      'The fish uses water and the bird can use the edge',
      'Both must spend all their time underwater',
      'Both must use only the dry land',
      'Both must use exactly the same shelter',
      'Different animals can share an area while using different parts.',
      'Shared habitats'
    ],
    [
      'Which resources help plants grow in a habitat?',
      'Suitable light, water, air and space',
      'Only light, with no water',
      'Only water, with no air',
      'Only space, with no light',
      'Plants need suitable light, water, air and room to grow.',
      'Plant needs'
    ],
    [
      'What does the word conditions mean here?',
      'What a place is like',
      'Only the names of its animals',
      'Only a bird’s meal',
      'Only the size of a nest',
      'Wetness and saltiness are examples of conditions in a place.',
      'Habitat vocabulary'
    ],
    [
      'A bird hides among a bush’s leaves. Which need is being met?',
      'Shelter',
      'Drinking water',
      'Food from seeds',
      'Space for a long flight',
      'Leaves and branches can provide cover or shelter.',
      'Garden resources'
    ],
    [
      'Which statement about deserts matches this lesson?',
      'Some deserts are cold',
      'Every desert is hot all the time',
      'No desert gets any rain at any time',
      'Every desert has plentiful freshwater ponds',
      'Little rain defines deserts; they are not all hot all the time.',
      'Desert comparison'
    ],
    [
      'Why should a freshwater fish not be placed in ocean water?',
      'The water conditions are different',
      'Any kind of water meets exactly the same needs',
      'Ocean water is the same as pond freshwater',
      'Only the amount of swimming space matters',
      'Ocean saltiness differs from freshwater conditions needed by the pond fish.',
      'Matching conditions'
    ],
    [
      'A water dish dries up, but bushes and insects remain. What resource was lost?',
      'Drinking water from the dish',
      'All food in the garden',
      'All shelter in the garden',
      'All space in the garden',
      'The change described removes that water source, not the remaining insects or bushes.',
      'Habitat changes'
    ],
    [
      'All bushes at a pond edge are removed, but food and drinking water remain. What might a resting bird lose?',
      'Shelter',
      'The remaining drinking water',
      'The remaining food',
      'All room to move',
      'Removing bushes can remove cover used by birds.',
      'Predicting effects'
    ],
    [
      'A box has a perch but no food or water. Which conclusion fits?',
      'A resting place alone does not meet all needs',
      'The perch replaces food and water',
      'The box meets every animal’s needs',
      'Animals need only a place to sit',
      'Shelter alone does not provide the other resources animals need.',
      'Checking resources'
    ],
    [
      'You do not see drinking water during one short bird observation. What should you record?',
      'The water source is unknown',
      'The bird never needs water',
      'There is no water anywhere nearby',
      'The bird’s shelter replaces its water need',
      'One short observation cannot show every resource used by the bird.',
      'Observation evidence'
    ],
    [
      'A pond becomes much smaller during dry weather. Which change matters to a fish?',
      'Less water is available as habitat',
      'More swimming space is available',
      'The amount of water habitat has stayed the same',
      'The exposed dry land provides the same water habitat',
      'A shrinking pond reduces the water area used by the fish.',
      'Habitat reasoning'
    ],
    [
      'Which action helps protect a pond habitat?',
      'Keep litter out of the pond',
      'Move pond fish into the ocean',
      'Remove every plant at the edge',
      'Put unknown food in the water',
      'Keeping litter out helps care for the habitat and its living things.',
      'Habitat care'
    ],
    [
      'A bird has seeds, water and room to move, but no cover. Which listed need is missing?',
      'Shelter',
      'Food',
      'Water',
      'Space',
      'Food, water and space are present; cover is the missing shelter resource.',
      'Mastery: resource check'
    ],
    [
      'Why can a garden and a pond support different living things?',
      'They offer different resources and conditions',
      'Every living thing has identical needs',
      'The appearance of a place is all that matters',
      'Shelter alone suits every kind of animal',
      'Different resources and conditions fit different living things.',
      'Mastery: habitat comparison'
    ],
    [
      'A learner finds a nest and says the bird needs nothing beyond it. Which explanation corrects this?',
      'The bird also needs food, water and space nearby',
      'Every nest creates all the bird’s food',
      'Shelter makes drinking water unnecessary',
      'Birds never leave their nests',
      'A nest is shelter within a wider habitat that supplies the bird’s other needs.',
      'Mastery: complete habitat'
    ],
  ],
);

final _statesOfMatter = scienceTopic(
  grade: 'g2',
  order: 3,
  title: 'States of Matter',
  subtitle:
      'Compare solids, liquids and gases, then follow water as it changes.',
  minutes: '20–25 minutes',
  prerequisiteTopicId: 'science.g2.habitats',
  objectives: [
    'Classify familiar examples as solid, liquid or gas using their behavior.',
    'Compare what happens when water and a solid block change containers.',
    'Describe melting, freezing, evaporation and condensation using water.',
    'Explain why air is matter even when it cannot be seen.',
  ],
  introduction:
      '🧊 An ice cube and the water beside it are the same material in different states. The air above them is matter too. We can use shape, flow and changes to tell solids, liquids and gases apart.',
  sections: [
    scienceSection('Matter takes up space 🧱',
        'Matter is the stuff that makes up objects and materials. It takes up space. A block takes up space on a table. Water takes up space in a cup. Air takes up space inside a bag even though we usually cannot see it.\n\nSolid, liquid and gas are three states of matter. State describes how the material behaves. A solid block keeps its own shape when you move it from a cup to a plate. A force can change a solid’s shape. Soft clay is still solid. Being hard is not the rule for being a solid.'),
    scienceSection('Flow and spread 💧',
        'A liquid flows. Water poured from a cup into a bowl takes the shape of the part of the bowl it occupies. It does not spread through every bit of empty space above it. If no water spills, the same amount of water is still there. A wider bowl may make it look shallower.\n\nA gas spreads to fill available space in a closed container. Air is a mixture of gases. A closed bag holding air is not empty. You can gently press it and feel the trapped air push back. Do not put bags near anyone’s face.'),
    scienceVisual('sci-g2-3-particles',
        'Compare behavior, not color. Dots are a model of particles too small to see in this activity.'),
    scienceSection('A tiny-particle picture 🔎',
        'Matter is made of tiny particles. In a solid, the particles stay close and move around their places. In a liquid, close particles can move past one another. Gas particles are much farther apart and move through the available space. The dots in our picture help explain behavior. They are not real photographs. You do not need to count or memorize the dots.'),
    scienceSection('Ice and liquid water 🔄',
        'Melting is a change from solid to liquid. With enough warming, an ice cube melts into liquid water. Freezing is a change from liquid to solid. With enough cooling, liquid water becomes ice. Ice is solid water, not a different material.\n\nThese changes can be reversed. An adult can put water in a freezer, and later the ice can melt again. Cutting a solid into pieces is different from melting. The smaller pieces are still solids. A small ice piece is still ice until it melts.'),
    scienceVisual('sci-g2-3-melting-freezing',
        'Warming enough can melt ice. Cooling enough can freeze water.'),
    scienceSection('Water can enter the air ☁️',
        'Evaporation happens when liquid water changes into gas at its surface. A small puddle can dry without boiling. The water has entered the air as invisible water vapor. Water vapor is water in its gas state.\n\nCondensation is the change from gas to liquid. Enough cooling can turn water vapor into little drops. Drops on the outside of a cold cup can come from water vapor in the air. Visible mist is made of tiny drops of liquid water. It is different from invisible water vapor.'),
    scienceVisual('sci-g2-3-water-air',
        'Evaporation changes liquid to gas. Condensation changes gas to liquid.'),
    scienceSection('Worked example: a tall cup and wide bowl 🥣',
        'A learner pours all the water from a tall cup into a wide bowl without spilling. First notice its shape: it changes to fit the bowl. Next notice the amount: no water was added or lost. The water is shallower because it spreads across a wider base. It remains a liquid. Changing containers is not freezing or evaporation.'),
    scienceSection('Guided example: can it pour? 🤔',
        'Dry rice pours from a cup. Does pouring prove that each grain is liquid? Think about one grain. Does it keep its own shape when moved?'),
    scienceSection('Reveal: look at one grain',
        'Each grain is a small solid. Many loose solids can slide past one another and pour together. The ability to pour a pile is not enough to prove its pieces are liquid.',
        reveal: true),
    scienceSection('Observe safely 📒',
        'Ask an adult to place an ice cube on a small plate. Draw it, wait indoors, and draw it again as it melts. Use no stove or hot water. Notice solid ice becoming liquid water. Wipe up spills. For another observation, watch an adult gently press a closed bag of room air. Do not taste materials or put the bag near your face.'),
    scienceSection('Common mistakes ⚠️',
        'Air is not “nothing.” It occupies space. A soft solid is still solid. Loose grains can pour while each grain keeps its shape. Water vapor is invisible; visible mist contains liquid drops. A change of container changes a liquid’s shape, not automatically its amount or state.'),
    scienceSection('Quick check 🧠',
        'A puddle dries without boiling. What change can explain this? Ice becomes liquid on a plate. What is that change called?'),
    scienceSection('Check your thinking',
        'The puddle’s water evaporates into the air. Ice becoming liquid is melting. Both changes keep water as the material while changing its state.',
        reveal: true),
    scienceSection('Recap 🌟',
        'Solids keep their own shape, liquids flow to fit the space they occupy, and gases spread through available space. Water can melt, freeze, evaporate or condense. Use observations to explain the change.'),
  ],
  keyConcept:
      'A material can have different states. Shape and flow help distinguish states; heating or cooling enough can change water’s state.',
  questions: [
    [
      'Which example is solid water?',
      'An ice cube',
      'Water in a drinking cup',
      'Invisible water vapor',
      'Water in a puddle',
      'Ice is water in its solid state.',
      'Solid water'
    ],
    [
      'Which example is a liquid?',
      'Water poured into a bowl',
      'A wooden block',
      'An ice cube',
      'Air inside a bag',
      'Liquid water flows and takes the shape of the part of its container it occupies.',
      'Liquid behavior'
    ],
    [
      'Which example is a gas?',
      'Air inside a closed bag',
      'An ice cube on a plate',
      'Liquid water in a bowl',
      'Visible mist made of drops',
      'Air is a mixture of gases and occupies the bag’s space.',
      'Gas behavior'
    ],
    [
      'What is melting?',
      'A solid changing into liquid',
      'A liquid changing into solid',
      'A gas changing into liquid',
      'A solid being cut into pieces',
      'Melting changes a solid, such as ice, into liquid.',
      'Melting'
    ],
    [
      'What is freezing?',
      'A liquid changing into solid',
      'A solid changing into liquid',
      'A liquid changing into gas',
      'A gas changing into liquid',
      'Freezing changes liquid water into solid ice.',
      'Freezing'
    ],
    [
      'What is water vapor?',
      'Water in its gas state',
      'A small solid piece of ice',
      'A large liquid water drop',
      'Visible mist made of liquid drops',
      'Water vapor is invisible water in the gas state.',
      'Water vapor'
    ],
    [
      'What does matter do?',
      'Takes up space',
      'Exists only if we can see it',
      'Must always be hard',
      'Must always be liquid',
      'Matter takes up space, including gases that we cannot usually see.',
      'Matter meaning'
    ],
    [
      'A block is moved from a cup to a plate without squeezing it. What happens?',
      'It keeps its own shape',
      'It spreads through all the space like gas',
      'It takes the exact shape of the plate like liquid',
      'It must melt because it moved',
      'A solid keeps its own shape unless a force or another change affects it.',
      'Solid behavior'
    ],
    [
      'Water is poured into a new bowl. What can change even with no spill?',
      'Its shape',
      'Its material changes into a different substance',
      'Its state must become solid',
      'Its state must become gas',
      'Liquid water changes shape to fit the space it occupies in the bowl.',
      'Changing containers'
    ],
    [
      'Why can soft clay still be a solid?',
      'Hardness alone does not decide the state',
      'Every soft material must be a liquid',
      'Every solid must be hard like a block',
      'Changing shape under a force proves it is gas',
      'A solid may be soft and change shape under a force.',
      'Soft solids'
    ],
    [
      'What does a gas do in a closed container?',
      'Spreads through available space',
      'Keeps its own shape like a block',
      'Forms a liquid layer only at the bottom',
      'Keeps the shape of a pile of grains',
      'Gas particles move through the available space in a closed container.',
      'Gas spreading'
    ],
    [
      'What is evaporation?',
      'Liquid water changing into gas at its surface',
      'Liquid water changing into ice',
      'Ice changing into liquid water',
      'Water vapor changing into drops',
      'Evaporation changes liquid water at the surface into water vapor.',
      'Evaporation'
    ],
    [
      'What is condensation?',
      'Gas changing into liquid',
      'Liquid changing into solid',
      'Solid changing into liquid',
      'A grain being broken in half',
      'Water vapor can condense into liquid drops when cooled enough.',
      'Condensation'
    ],
    [
      'What do the dots in the particle diagram represent?',
      'Tiny particles of matter',
      'Actual-size water drops',
      'Only empty spaces inside a solid',
      'Visible pieces large enough to count in water',
      'The dots are a model of particles too small to see in these observations.',
      'Particle models'
    ],
    [
      'All the water is moved from a tall cup to a wide bowl with no spills. Why is it shallower?',
      'The same water spreads across a wider base',
      'Less depth always means less water remains',
      'The bowl has changed it to a solid',
      'Changing containers must remove some water',
      'The shape changes, while the same amount remains if none is lost.',
      'Container reasoning'
    ],
    [
      'A closed bag holds air. Why is it not empty?',
      'The air occupies space inside',
      'Only visible materials count as matter',
      'Air takes up no room',
      'A bag counts as filled only if it contains liquid',
      'Invisible air is matter occupying space in the bag.',
      'Evidence of gas'
    ],
    [
      'A puddle dries on a mild day without boiling. Where can its water go?',
      'Into the air as water vapor',
      'It must have frozen into ice',
      'It must still be liquid in exactly the same place',
      'It must stop being matter when it becomes invisible',
      'Water can evaporate at the surface without boiling.',
      'Explaining drying'
    ],
    [
      'An adult cools liquid water enough in a freezer. What forms?',
      'Solid ice',
      'More liquid by melting',
      'Water vapor by evaporation',
      'Liquid drops by condensation of the same liquid',
      'Enough cooling freezes liquid water into ice.',
      'Predicting freezing'
    ],
    [
      'Dry rice pours from a cup. What helps show its grains are solids?',
      'Each grain keeps its own shape',
      'Pouring always proves a material is liquid',
      'Each grain takes the cup’s shape like water',
      'Each grain spreads through all available space like gas',
      'Loose solids can pour together while each grain retains its shape.',
      'Classifying grains'
    ],
    [
      'Tiny drops appear outside a cold cup. Which change can explain them?',
      'Water vapor in air condenses',
      'The drops evaporate from gas into liquid',
      'The air melts from solid into liquid',
      'The drops freeze from gas into liquid',
      'Cooling can make water vapor from the air condense into liquid drops.',
      'Explaining condensation'
    ],
    [
      'A child cuts one ice cube into smaller pieces. Which statement fits before any melting?',
      'The pieces are still solid water',
      'Smaller pieces must be gas',
      'Cutting always changes solid into liquid',
      'The pieces have changed into a different material',
      'Making smaller pieces does not by itself change the solid state.',
      'Mastery: size and state'
    ],
    [
      'Ice melts, and an adult later freezes the water again. What stayed the same?',
      'The material is water',
      'The shape must stay identical',
      'The state never changed',
      'The particles disappeared during melting',
      'Melting and freezing change water’s state while it remains water.',
      'Mastery: reversible changes'
    ],
    [
      'Which statement correctly compares visible mist and water vapor?',
      'Mist has liquid drops; water vapor is invisible gas',
      'Mist and water vapor are both gas',
      'Water vapor is visible; mist is invisible',
      'Both are solid water because they are in air',
      'Tiny liquid drops make mist visible, while water vapor itself is invisible.',
      'Mastery: gas and drops'
    ],
  ],
);

final _lightAndSound = scienceTopic(
  grade: 'g2',
  order: 4,
  title: 'Light & Sound',
  subtitle: 'Trace light to your eyes and sound from a vibrating object.',
  minutes: '20–25 minutes',
  prerequisiteTopicId: 'science.g2.states-of-matter',
  objectives: [
    'Distinguish a light source from an object that reflects light.',
    'Explain how an opaque object makes a shadow.',
    'Connect sound with back-and-forth vibration.',
    'Compare loudness and pitch using familiar sounds.',
  ],
  introduction:
      '🔦 A torch lights a dark wall. Your hand makes a shadow in front of it. Nearby, a bell rings. What travels to your eyes? What makes the sound? Follow the path from a source to a listener or viewer.',
  sections: [
    scienceSection('Light lets us see 💡',
        'A light source makes its own light. The Sun, a lit lamp and a switched-on torch are sources. A book, a wall and the Moon do not make their own light. They can reflect light. Reflect means send some incoming light back or in another direction.\n\nTo see a book, light must reach it and some of that light must reach our eyes. In complete darkness, no light from the book reaches our eyes. A book’s color does not make it shine by itself. Never look directly at the Sun or shine a torch into someone’s eyes.'),
    scienceVisual('sci-g2-4-seeing',
        'Light starts at the lamp, reflects from the book, and reaches the eyes.'),
    scienceSection('Through or blocked? 🖐️',
        'Light travels in straight lines through air in this activity. Clear material lets much of the light pass through. An opaque material blocks light from passing through it. A piece of thick card is opaque. A shadow forms where an object blocks light from a source. It is a region receiving less light, not a black object coming out of your hand.\n\nTo notice a shadow in this activity, use a source, a blocking object and a surface. Move the card and its shadow changes position. With a torch and wall held fixed, moving the card closer to the torch can make the shadow larger.'),
    scienceVisual('sci-g2-4-shadow',
        'The card blocks part of the torch’s light. The wall behind that part has a shadow.'),
    scienceSection('Sound starts with vibration 🔔',
        'Vibration means quick back-and-forth movement. A ringing bell vibrates. A plucked instrument string vibrates. These movements make sound. You may not always see the movement because it is small and fast.\n\nSound can travel through air from the bell to your ears. The air passes the vibration along. The whole bell does not fly to your ear. When the sounding part stops vibrating, it stops making that sound. Covering your ears may make a sound seem quieter, but it does not necessarily stop the source vibrating.'),
    scienceVisual('sci-g2-4-sound',
        'A vibrating source sends sound through air to a listener.'),
    scienceSection('Loud or soft; high or low 🎵',
        'Loudness describes how loud or soft a sound is. A gentle tap can make a soft sound. A stronger tap on the same object can make a louder sound. Keep taps gentle enough to be safe. Loud sounds can hurt hearing.\n\nPitch describes how high or low a sound is. A whistle often has a high pitch. A deep drum sound has a low pitch. Faster vibration makes a higher pitch; slower vibration makes a lower pitch. A high sound can be quiet. A low sound can be loud. High and loud are different ideas.'),
    scienceSection('Worked example: a quiet whistle 🔎',
        'Imagine a soft, squeaky whistle sound and a loud, deep drum sound. First compare loudness. The drum is louder in this example. Next compare pitch. The whistle is higher in pitch. We need both words because one describes strength and the other describes high or low tone. A quiet high sound is still high. A loud low sound is still low.'),
    scienceSection('Guided example: shadow size 🤔',
        'An adult keeps a torch and a wall in the same places. A thick card makes a shadow. The card moves closer to the torch. Predict what can happen to the shadow’s size. Which object is blocking the light?'),
    scienceSection('Reveal: follow the blocked light',
        'The card blocks light. Moving it closer to the torch can make a larger shadow on the fixed wall. The shadow is the area where less light arrives. The card has not grown larger.',
        reveal: true),
    scienceSection('Observe safely 📒',
        'With an adult, use a battery torch, thick card and a wall. Keep the torch aimed at the wall, away from faces. Compare a card shadow with what happens when light passes through clear plastic. Do not use a hot lamp or electrical equipment you must open.\n\nFor sound, gently hum and notice the vibration with a light touch at your throat if comfortable. Compare two quiet taps on a sturdy tabletop. Avoid loud bangs and do not put objects inside ears.'),
    scienceSection('Common mistakes ⚠️',
        'A bright-looking wall is reflecting light; it is not automatically a light source. A shadow is caused by blocked light, not by the object making darkness. Sound can come from movement too small to see. Louder does not mean higher in pitch. Turning up a recording’s volume can make it louder while the notes keep their pitches.'),
    scienceSection('Quick check 🧠',
        'A lit lamp shines on a book. Which object makes its own light? A bell is ringing. What movement at the bell makes that sound?'),
    scienceSection('Check your thinking',
        'The lit lamp is the source. The book reflects some light to your eyes. The bell’s back-and-forth vibration makes its sound.',
        reveal: true),
    scienceSection('Recap 🌟',
        'Light sources make light. Many objects are seen by reflected light. Opaque objects can form shadows by blocking light. Sound comes from vibration. Use loud or soft for loudness and high or low for pitch.'),
  ],
  keyConcept:
      'Light reaches our eyes from a source or by reflection. Sound begins with vibration. A shadow is blocked light; pitch and loudness describe different features of sound.',
  questions: [
    [
      'Which object makes its own light?',
      'A switched-on torch',
      'A closed book',
      'A plain wall',
      'The Moon',
      'A switched-on torch is a light source; the others reflect incoming light.',
      'Light sources'
    ],
    [
      'What does a book do with some light falling on it?',
      'Reflects it',
      'Makes its own light like a lit lamp',
      'Lets all light through like clear plastic',
      'Sends light out from your eyes',
      'A book reflects some incoming light, and some can reach the eyes.',
      'Reflection'
    ],
    [
      'What causes a hand’s shadow on a wall?',
      'The hand blocks some light',
      'The hand makes darkness of its own',
      'The wall stops the torch making light',
      'The hand lets all the light pass through',
      'A shadow is a region receiving less light because an object blocks it.',
      'Shadows'
    ],
    [
      'Which material blocks light from passing through it?',
      'Thick opaque card',
      'Clear plastic sheet',
      'Clear air',
      'A clear window',
      'Opaque card blocks light; clear materials let much of it pass through.',
      'Opaque materials'
    ],
    [
      'What does vibration mean?',
      'Quick back-and-forth movement',
      'Moving once in one direction',
      'Staying perfectly still',
      'Only moving from one container to another',
      'Vibration is back-and-forth movement that can make sound.',
      'Vibration'
    ],
    [
      'Which movement makes a bell’s sound?',
      'The bell vibrating',
      'The bell reflecting sunlight',
      'The bell casting a shadow',
      'The bell keeping perfectly still',
      'A ringing bell vibrates and sends sound through its surroundings.',
      'Sound sources'
    ],
    [
      'Which words describe loudness?',
      'Loud and soft',
      'High and low',
      'Clear and opaque',
      'Light and shadow',
      'Loudness describes loud or soft sound; pitch describes high or low sound.',
      'Loudness'
    ],
    [
      'Which words describe pitch?',
      'High and low',
      'Loud and soft',
      'Opaque and clear',
      'Bright and dark',
      'Pitch is the highness or lowness of a sound.',
      'Pitch'
    ],
    [
      'How can a ringing bell’s sound reach your ear nearby?',
      'Its vibration travels through air',
      'Sound stays only inside the bell',
      'Only reflected light carries the sound',
      'The bell must touch your ear',
      'Sound can travel through air from a vibrating source to the listener.',
      'Sound travel'
    ],
    [
      'Why is a book hard to see in complete darkness?',
      'No light from the book reaches the eyes',
      'Eyes send enough light to see every book',
      'The book makes light but it stays inside',
      'Sound must reach the book before it can be seen',
      'Seeing the book needs light to reach it and then reach the eyes.',
      'Seeing objects'
    ],
    [
      'What kind of light does the Moon send toward us?',
      'Reflected light',
      'Light it makes like a lit lamp',
      'Light made by our eyes',
      'Light made by its shadow',
      'The Moon does not make its own light; it reflects sunlight.',
      'Reflected moonlight'
    ],
    [
      'Which change makes a higher pitch?',
      'Faster vibration',
      'Slower vibration',
      'Only greater loudness with the same vibration speed',
      'Only softer loudness with the same vibration speed',
      'Faster vibration gives higher pitch; slower vibration gives lower pitch.',
      'Pitch and vibration'
    ],
    [
      'What happens when a bell’s sounding part stops vibrating?',
      'It stops making that sound',
      'It keeps making the same sound while still',
      'It makes a louder sound because it is still',
      'It makes a higher pitch because it is still',
      'Sound production depends on the sounding part vibrating.',
      'Stopping sound'
    ],
    [
      'Which statement about a shadow is correct?',
      'It is an area receiving less light',
      'It is a solid copy of an object',
      'It is darkness made by the object',
      'It is an area receiving more light from the source',
      'The shadow marks where some light is blocked from reaching the surface.',
      'Shadow meaning'
    ],
    [
      'A quiet whistle has a high tone. Which description fits?',
      'Soft and high-pitched',
      'Loud and low-pitched',
      'Soft and low-pitched',
      'Loud and high-pitched',
      'Quiet describes soft loudness; the high tone describes pitch.',
      'Comparing sounds'
    ],
    [
      'A sound is loud but low-pitched. Which statement fits?',
      'Its loudness is loud and its pitch is low',
      'Its pitch must be high because it is loud',
      'Its loudness must be soft because its pitch is low',
      'Its pitch and loudness must be the same feature',
      'Low describes pitch, while loud describes loudness.',
      'Pitch reasoning'
    ],
    [
      'With torch and wall fixed, a card moves closer to the torch. What can happen?',
      'The shadow becomes larger',
      'The shadow must stay the card’s exact size',
      'The shadow disappears because the card is opaque',
      'The shadow can grow only if the card itself grows',
      'A closer blocking card can create a larger shadow on the fixed wall.',
      'Predicting shadows'
    ],
    [
      'A lamp lights a book that you see. Which path explains seeing it?',
      'Lamp → book → eyes',
      'Eyes → book → lamp',
      'Book makes light → eyes → lamp',
      'Lamp → eyes, with no light reaching the book',
      'Light reaches the book, reflects, and enters the eyes.',
      'Light paths'
    ],
    [
      'A plucked string makes sound, but its movement is hard to see. What can explain this?',
      'Its vibration is small and fast',
      'A string can make sound while perfectly still',
      'Sound always needs a large visible movement',
      'The string makes sound only by reflecting light',
      'Sounding parts can vibrate too quickly and slightly for movement to be easy to see.',
      'Interpreting sound'
    ],
    [
      'A recording is played louder with the same notes. What changed?',
      'Loudness only',
      'Pitch only',
      'Both loudness and pitch must rise',
      'Pitch must become lower',
      'Changing volume changes loudness without necessarily changing pitch.',
      'Separating sound features'
    ],
    [
      'A torch shines through clear plastic but a card makes a shadow. What explains the difference?',
      'Plastic lets much light through; the card blocks it',
      'The card makes its own light; plastic makes darkness',
      'Both materials block all light equally',
      'Only sound can pass through plastic',
      'Different materials transmit or block light differently.',
      'Mastery: materials and light'
    ],
    [
      'Which explanation correctly links a ringing bell and a listener?',
      'Vibrating bell → air → ear',
      'Still bell → air → ear',
      'Ear → air → bell makes sound',
      'Bell → reflected light → ear',
      'The vibrating bell sends sound through air to the ear.',
      'Mastery: sound pathway'
    ],
    [
      'Two sounds are equally quiet, but one is a squeak and one is a deep tone. What differs?',
      'Pitch only',
      'Loudness only',
      'Both pitch and loudness must differ',
      'Neither pitch nor loudness differs',
      'Both are quiet, so the contrast between high squeak and deep tone is pitch.',
      'Mastery: sound comparison'
    ],
  ],
);

final _earthAndSky = scienceTopic(
  grade: 'g2',
  order: 5,
  title: 'Earth & Sky',
  subtitle: 'Explain day and night and compare the Sun, Moon and stars.',
  minutes: '20–25 minutes',
  prerequisiteTopicId: 'science.g2.light-sound',
  objectives: [
    'Describe Earth as a planet with land, water and surrounding air.',
    'Use Earth’s rotation to explain day and night.',
    'Distinguish the Sun and stars from the Moon by how they shine.',
    'Use observations to describe a repeating local sky pattern.',
  ],
  introduction:
      '🌎 In the morning, daylight returns. At night, a dark sky may show stars. The Moon can sometimes appear in daylight too. What changes as a day passes? Our planet is turning while we observe the sky.',
  sections: [
    scienceSection('Our home planet 🌍',
        'Earth is the planet where we live. A planet is a large body in space that travels around a star. Earth travels around the Sun. Earth is shaped roughly like a ball. A globe is a model of this shape. A flat map can show places, but Earth itself is not a flat sheet.\n\nEarth has land and water at its surface. Air surrounds it. People, plants and other animals live on Earth. We look through the surrounding air when we look at the sky. Clouds are in this air. The Sun, Moon and distant stars are much farther away, in space.'),
    scienceSection('Turn toward the light ☀️',
        'Earth rotates. Rotate means turn around, like a spinning ball. A full turn takes about 24 hours. Sunlight reaches the side facing the Sun. A place on that side has daytime. The side turned away does not receive direct sunlight and has nighttime.\n\nAs Earth turns, our place moves into and out of sunlight. This makes the familiar day-and-night pattern. The Moon does not switch daylight off. Different places can have daytime and nighttime at the same moment because they face different directions.'),
    scienceVisual('sci-g2-5-day-night',
        'Compare two places: the side facing the Sun has daytime; the side facing away has nighttime.'),
    scienceSection('A daily pattern 🔄',
        'In our usual local pattern, morning leads to daytime, then evening and nighttime. Morning comes again. A pattern repeats. We can record this sequence on several days and look for the repetition.\n\nThe Sun seems to change position in the sky during the day because Earth turns. The daily pattern is not caused by the Sun circling Earth once a day. Clouds may hide the Sun or make daytime seem dark. It is still daytime when our place faces the Sun, even if the sky is cloudy.'),
    scienceVisual('sci-g2-5-daily-pattern',
        'This is a sequence at our location. The repeating pattern comes from Earth’s rotation.'),
    scienceSection('What shines in the sky? 🌙',
        'The Sun is a star. It makes its own light. Other stars also make light. They look like small points because they are very far away. The Sun is much nearer to Earth than those other stars.\n\nThe Moon does not make its own light like a star. We see sunlight reflected from it. The Moon can be visible at night and sometimes in daytime. Stars are still there during the day, but the bright sky makes most of them hard to see. Clouds can hide sky objects too. Not seeing an object does not mean it has disappeared.'),
    scienceVisual('sci-g2-5-sky-objects',
        'The Sun and other stars make light. The Moon reflects sunlight.'),
    scienceSection('Worked example: a turning globe 🔎',
        'An adult shines a battery torch on a globe in a dim room. The torch models the Sun. A small sticker marks our place. First turn the sticker toward the torch. It is lit, modeling daytime. Next turn the globe so the sticker faces away. It is dark, modeling nighttime.\n\nThe torch stays in one place while the globe turns. This helps show why Earth’s turning can change day to night at one location. Models leave out details: a torch and globe are not the real sizes or distances of the Sun and Earth.'),
    scienceSection('Guided example: a cloudy afternoon 🤔',
        'It is afternoon. Thick clouds hide the Sun, and the sky looks gray. Has night begun just because the Sun is hidden? Think about whether our place has turned away from the Sun.'),
    scienceSection('Reveal: cloud cover is different',
        'It can still be daytime. Clouds can block our view of the Sun without changing which side of Earth faces it. Nighttime comes when our location turns away from direct sunlight.',
        reveal: true),
    scienceSection('Keep a safe sky record 📒',
        'With an adult, record morning, afternoon and evening sky conditions for two days from a safe spot. Write the time. Draw clouds and note whether daylight is present. If you see the Moon, note it too. Never look directly at the Sun. Do not use binoculars or a telescope to look toward it.\n\nYou can observe a tree’s shadow on the ground instead of looking at the Sun. Its position can change as the Sun’s apparent position changes. Do not go outside alone at night. Record only what you observe; clouds may prevent some observations.'),
    scienceSection('Common mistakes ⚠️',
        'The Moon does not cause ordinary night. Earth’s turning does. The Moon is not visible only at night. A bright Moon is reflecting light, not making its own. Other stars do not vanish at sunrise. A dark cloud and the night side of Earth are different reasons for less light.'),
    scienceSection('Quick check 🧠',
        'A sticker on the globe faces the torch. Does it model daytime or nighttime? If the real Moon is visible in a blue daytime sky, does that observation fit this lesson?'),
    scienceSection('Check your thinking',
        'The lit sticker models daytime. A daytime Moon fits the lesson because the Moon is sometimes visible during the day. It reflects sunlight whether seen by day or by night.',
        reveal: true),
    scienceSection('Recap 🌟',
        'Earth is a roughly ball-shaped planet with land, water and surrounding air. Its rotation takes about 24 hours and makes the familiar day-and-night pattern. The Sun and other stars make light. The Moon reflects sunlight and can sometimes be seen in daytime.'),
  ],
  keyConcept:
      'Earth’s rotation turns places into and out of sunlight. The Sun is a light-making star; the Moon reflects sunlight.',
  questions: [
    [
      'What kind of space object is Earth?',
      'A planet',
      'A star',
      'A moon',
      'A cloud',
      'Earth is a planet that travels around the Sun.',
      'Earth as a planet'
    ],
    [
      'Which model best shows Earth’s overall shape?',
      'A ball-shaped globe',
      'A flat sheet',
      'A long straight rod',
      'A thin ring',
      'Earth is roughly ball-shaped, and a globe models this shape.',
      'Earth models'
    ],
    [
      'What surrounds Earth and contains clouds?',
      'Air',
      'Only land',
      'Only ocean water',
      'Only solid rock',
      'Air surrounds Earth, and clouds form in this air.',
      'Earth and air'
    ],
    [
      'What is the Sun?',
      'A star that makes light',
      'A planet that only reflects light',
      'A moon that only reflects light',
      'A cloud inside Earth’s air',
      'The Sun is a star and makes its own light.',
      'Sun'
    ],
    [
      'Why can we see the Moon?',
      'It reflects sunlight',
      'It makes light exactly like a star',
      'It is a bright cloud in our air',
      'Our eyes send light all the way to it',
      'The Moon reflects the Sun’s light toward us.',
      'Moonlight'
    ],
    [
      'What does rotate mean?',
      'Turn around',
      'Only move straight ahead',
      'Only change color',
      'Only become warmer',
      'Earth rotates by turning around, like a spinning ball.',
      'Rotation vocabulary'
    ],
    [
      'When can the Moon sometimes be visible?',
      'During daytime as well as nighttime',
      'Only during nighttime',
      'Only during daytime',
      'Only at the moment evening begins',
      'The Moon can sometimes be seen in the daytime sky too.',
      'Daytime Moon'
    ],
    [
      'About how long does Earth take to make a full turn?',
      '24 hours',
      '1 hour',
      '7 days',
      '1 year',
      'Earth completes one full rotation in about 24 hours.',
      'Rotation time'
    ],
    [
      'Which part of Earth has daytime?',
      'The part facing the Sun',
      'The part facing away from the Sun',
      'Only the part facing the Moon',
      'Every part at the same moment',
      'The Sun-facing side receives direct sunlight.',
      'Daytime'
    ],
    [
      'What causes ordinary day and night at our location?',
      'Earth rotating',
      'The Moon blocking the Sun every night',
      'Stars turning their lights off',
      'Clouds covering the whole planet each evening',
      'Earth’s rotation moves our location into and out of sunlight.',
      'Day and night'
    ],
    [
      'Why are most other stars difficult to see during the day?',
      'The daytime sky is too bright',
      'They disappear from space every morning',
      'They stop making their own light at sunrise',
      'They are visible only when Earth stops turning',
      'The bright daytime sky makes most distant stars hard to see.',
      'Seeing stars'
    ],
    [
      'Which sequence matches the usual repeating local pattern?',
      'Morning → daytime → evening → nighttime',
      'Morning → nighttime → daytime → evening',
      'Evening → morning → nighttime → daytime',
      'Nighttime → evening → daytime → morning',
      'Our usual local pattern passes from morning to day, evening and night.',
      'Daily pattern'
    ],
    [
      'Why does the Sun seem to change position during a day?',
      'Earth turns',
      'The Sun circles Earth once each day',
      'Only clouds move; Earth never turns',
      'The Sun must turn its light on and off',
      'Earth’s rotation makes the Sun seem to move across the sky.',
      'Apparent sky motion'
    ],
    [
      'How do the Sun and other stars differ from the Moon?',
      'They make their own light',
      'They only reflect light like the Moon',
      'They are all clouds in our air',
      'They can exist only at nighttime',
      'Stars make light, while the Moon reflects sunlight.',
      'Comparing sky objects'
    ],
    [
      'On a globe model, a sticker faces away from a fixed torch. What does that model?',
      'Nighttime at that place',
      'Daytime at that place',
      'A cloud hiding a still-lit place',
      'All places on Earth having nighttime together',
      'The sticker on the unlit side models a place turned away from the Sun.',
      'Model reasoning'
    ],
    [
      'A thick cloud hides the Sun in the afternoon. Which explanation fits?',
      'It can still be daytime',
      'Every hidden Sun means nighttime',
      'Earth must have stopped turning',
      'All stars have disappeared',
      'Cloud cover can hide the Sun without turning the location away from it.',
      'Weather and daytime'
    ],
    [
      'A tree’s shadow changes position during a sunny day. What can explain this?',
      'The Sun’s apparent position changes as Earth turns',
      'The tree must grow longer to move its shadow',
      'The Moon always replaces the Sun during daytime',
      'The Sun has stopped making light',
      'Earth’s turning changes the Sun’s apparent position and the tree’s shadow.',
      'Observing shadows'
    ],
    [
      'A child sees the Moon before sunset. Which conclusion fits?',
      'The Moon can be visible during daytime',
      'Night has begun everywhere on Earth',
      'Every visible Moon means it is nighttime',
      'Daytime observations cannot include the Moon',
      'Seeing a daytime Moon agrees with the Moon sometimes being visible by day.',
      'Interpreting a Moon observation'
    ],
    [
      'Two places on opposite sides of Earth face toward and away from the Sun. What can happen?',
      'One has daytime while the other has nighttime',
      'Both must have daytime at that moment',
      'Both must have nighttime at that moment',
      'Neither can have day or night until the Moon rises',
      'Different sides face different directions, so day and night can occur at once in different places.',
      'Comparing places'
    ],
    [
      'A torch lights a turning globe. What does the torch represent?',
      'The Sun',
      'The Moon',
      'Earth’s surrounding air',
      'The night side of Earth',
      'The torch supplies light in the model, representing the Sun.',
      'Model parts'
    ],
    [
      'A learner says the Moon makes every night happen. What corrects that idea?',
      'Our place turns away from sunlight as Earth rotates',
      'The Moon blocks the Sun every night',
      'Clouds cover our place every evening',
      'The Sun stops making light every night',
      'Ordinary nighttime at our location is due to Earth’s rotation.',
      'Mastery: cause of night'
    ],
    [
      'How do moonlight and sunlight differ?',
      'The Sun makes light; the Moon reflects the Sun’s light',
      'The Moon makes light; the Sun only reflects it',
      'Both make their own light like stars',
      'Both only reflect light from other stars',
      'The Sun produces light, while moonlight is reflected sunlight.',
      'Mastery: light in the sky'
    ],
    [
      'After two cloudy afternoons, a child has no star observations for those times. What is supported?',
      'Clouds and bright sky can prevent seeing stars',
      'There were no stars anywhere in space',
      'Stars stop making light every afternoon',
      'Stars exist only when people can see them',
      'Not seeing stars in a cloudy bright sky does not mean they have disappeared.',
      'Mastery: observation limits'
    ],
  ],
);
