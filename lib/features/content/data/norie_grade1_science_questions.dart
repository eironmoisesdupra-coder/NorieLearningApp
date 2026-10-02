import '../domain/norie_content_models.dart';

// Each row is an independent lesson-specific question, correct answer,
// three distractors, explanation, and concept label.
final _banks = <List<List<String>>>[
  [
    [
      'Which thing is living?',
      'Dog',
      'Rock',
      'Chair',
      'Cup',
      'A dog grows, needs resources, responds, and has a life cycle.',
      'Signs of life'
    ],
    [
      'Which thing is nonliving?',
      'Pencil',
      'Child',
      'Bird',
      'Flower',
      'A pencil does not carry out life processes.',
      'Nonliving things'
    ],
    [
      'What do people, animals, and plants need?',
      'Water',
      'Toy cars',
      'Pencils',
      'Bicycles',
      'Water is a resource needed by living things.',
      'Resources'
    ],
    [
      'How do animals get energy?',
      'From food',
      'From chairs',
      'From rocks',
      'From toys',
      'Animals eat food to get energy.',
      'Energy'
    ],
    [
      'What helps plants make their food?',
      'Light',
      'A toy motor',
      'A pencil',
      'A bicycle',
      'Plants use light energy to help make sugars.',
      'Plant energy'
    ],
    [
      'What can a baby grow into?',
      'A child',
      'A rock',
      'A chair',
      'A cup',
      'People grow and develop during their lives.',
      'Growth'
    ],
    [
      'Which thing has a life cycle?',
      'Tree',
      'Table',
      'Toy car',
      'Pencil',
      'A tree is a living thing with a life cycle.',
      'Life cycles'
    ],
    [
      'A dog turns its head when it hears its name. What is it doing?',
      'Responding',
      'Rusting',
      'Melting',
      'Becoming a toy',
      'Turning toward a sound is a response to the surroundings.',
      'Responses'
    ],
    [
      'Why is a plant living even though it cannot walk?',
      'It shows several signs of life',
      'Only walking shows life',
      'All green things are alive',
      'It is made from plastic',
      'Plants grow, use resources, respond, and have life cycles.',
      'Signs of life'
    ],
    [
      'Which sequence shows plant growth?',
      'Seed, sprout, young plant, mature plant',
      'Mature plant, toy, cup, rock',
      'Chair, pencil, seed, cup',
      'Sprout, bicycle, rock, table',
      'A seed can germinate and develop into a mature plant.',
      'Plant growth'
    ],
    [
      'A balloon gets bigger when air is added. Is this biological growth?',
      'No, air is being added',
      'Yes, it is a living plant',
      'Yes, it eats food',
      'Yes, it has a life cycle',
      'Adding air is a nonliving change, not biological growth.',
      'Growth and change'
    ],
    [
      'Which object came from something once living?',
      'Wooden table',
      'Rock',
      'Water',
      'Air',
      'Wood came from a tree, but a table is nonliving now.',
      'Once living'
    ],
    [
      'Which thing was never an organism?',
      'Rock',
      'Tree',
      'Dog',
      'Flower',
      'A rock was never a living organism.',
      'Never living'
    ],
    [
      'Where can a fish get what it needs to live?',
      'In water',
      'On a chair',
      'Inside a pencil',
      'On a dry toy shelf',
      'Fish live in water, a suitable environment for them.',
      'Places to live'
    ],
    [
      'A toy robot walks. Which evidence shows it is nonliving?',
      'Its battery and motor make it move',
      'It has a life cycle',
      'It grows like a puppy',
      'It needs water to stay alive',
      'Machine movement does not prove life.',
      'Movement and life'
    ],
    [
      'A cat is sleeping without moving around. What should you conclude?',
      'It is still alive',
      'It has become a toy',
      'It is a rock',
      'Still things are always nonliving',
      'The cat is breathing and using energy while it sleeps.',
      'Still living things'
    ],
    [
      'A seed looks dry and still. What may happen under suitable conditions?',
      'It can germinate',
      'It becomes a metal cup',
      'It turns into a robot',
      'It can never change',
      'A living seed can germinate and grow into a plant.',
      'Seeds'
    ],
    [
      'A plant shoot slowly grows toward light. What does this show?',
      'Plants respond to their environment',
      'Plants must walk',
      'Light is a toy motor',
      'All moving things are living',
      'Growing toward light is a plant response.',
      'Responses'
    ],
    [
      'You see a chair made from wood. Is the chair living now?',
      'No, it does not carry out life processes',
      'Yes, because wood came from a tree',
      'Yes, because people can move it',
      'Yes, because it is large',
      'Once-living material does not make the chair alive now.',
      'Once living'
    ],
    [
      'Which evidence is strongest for deciding a puppy is living?',
      'It grows, needs resources, and responds',
      'It is brown',
      'It is small',
      'It can be carried',
      'Several signs of life together are stronger than one clue.',
      'Using evidence'
    ],
    [
      'A fan spins and a plant stays rooted. Which statement is correct?',
      'The plant is living and the fan is nonliving',
      'Only the fan is living',
      'Both are living because they change',
      'Neither is living because neither walks',
      'A plant carries out life processes; a fan spins because of machine parts.',
      'Movement and life'
    ],
    [
      'Ice melts into water. Does that prove it was living?',
      'No, melting is a nonliving change',
      'Yes, every change proves life',
      'Yes, ice has roots',
      'Yes, ice eats food',
      'Nonliving things can change without biological growth.',
      'Growth and change'
    ],
    [
      'You must sort a sunflower and a teddy bear. Which reason supports your choice?',
      'The sunflower uses resources and grows; the bear is a toy',
      'Both have bright colors, so both are living',
      'The teddy bear is soft, so it is living',
      'The flower is still, so neither is living',
      'Sort using signs of life, not color, softness, or movement alone.',
      'Using evidence'
    ],
  ],
  [
    [
      'Which is a plant?',
      'Cactus',
      'Dog',
      'Fish',
      'Butterfly',
      'A cactus is a living plant.',
      'Plant identification'
    ],
    [
      'Which is an animal?',
      'Frog',
      'Grass',
      'Fern',
      'Rose',
      'A frog is a living animal.',
      'Animal identification'
    ],
    [
      'Which plant part is usually underground?',
      'Roots',
      'Flower',
      'Leaf',
      'Top of the stem',
      'Roots are usually found under the ground.',
      'Roots'
    ],
    [
      'Which plant part helps capture light?',
      'Leaves',
      'Roots',
      'Fins',
      'Wings',
      'Leaves help capture light to make food.',
      'Leaves'
    ],
    [
      'Which part helps a fish swim and steer?',
      'Fins',
      'Roots',
      'Flowers',
      'Hands',
      'Fish use fins to move and steer through water.',
      'Animal parts'
    ],
    [
      'Which part can help a bird fly?',
      'Wings',
      'Roots',
      'Leaves',
      'Plant stem',
      'Wings help many birds move through the air.',
      'Animal parts'
    ],
    [
      'How do animals get energy?',
      'By eating food',
      'By making food from light like plants',
      'By growing roots',
      'By turning into leaves',
      'Animals get energy by eating food.',
      'Animal needs'
    ],
    [
      'What are two jobs of roots?',
      'Holding the plant and taking in water',
      'Flying and hearing',
      'Running and jumping',
      'Eating and seeing',
      'Roots hold plants in place and absorb water and minerals.',
      'Roots'
    ],
    [
      'What does a stem help do?',
      'Support the plant and move materials',
      'Help a fish swim',
      'Help a dog hear',
      'Replace all the leaves',
      'Stems support plants and help move water and other materials.',
      'Stem'
    ],
    [
      'What can flowers help plants make?',
      'Seeds',
      'Fins',
      'Beaks',
      'Legs',
      'Many flowers help plants produce seeds.',
      'Flowers'
    ],
    [
      'Which need is shared by plants and animals?',
      'Water',
      'Wings',
      'Four legs',
      'Flowers',
      'Both plants and animals need water.',
      'Shared needs'
    ],
    [
      'Which statement describes a difference?',
      'Plants use light to make food; animals eat food',
      'Plants are nonliving; animals are living',
      'All plants walk; all animals stay rooted',
      'All animals have leaves',
      'Plants and animals get energy in different ways.',
      'Comparisons'
    ],
    [
      'What is a habitat?',
      'A place where a living thing lives and gets what it needs',
      'A body part for flying',
      'A kind of toy',
      'A part of a pencil',
      'A habitat provides resources a living thing needs.',
      'Habitats'
    ],
    [
      'What can a puppy grow into?',
      'Adult dog',
      'Tree',
      'Sunflower',
      'Fish',
      'A puppy grows into an adult dog during its life cycle.',
      'Life cycles'
    ],
    [
      'You find roots, a stem, and leaves. Which group does this living thing belong to?',
      'Plants',
      'Fish',
      'Birds',
      'Dogs',
      'Roots, stems, and leaves are plant structures.',
      'Classification'
    ],
    [
      'A butterfly eats and has wings and legs. How should you classify it?',
      'Animal',
      'Plant',
      'Nonliving rock',
      'Flower',
      'A butterfly has animal body structures and takes in food.',
      'Classification'
    ],
    [
      'Which habitat is suitable for a fish?',
      'Pond',
      'Dry cupboard',
      'Pencil case',
      'Chair seat',
      'A pond is a freshwater habitat where fish can live.',
      'Habitats'
    ],
    [
      'A frog jumps away. Which body parts help it jump?',
      'Strong back legs',
      'Plant roots',
      'Flowers',
      'Fish fins',
      'Strong back legs help frogs jump.',
      'Animal parts'
    ],
    [
      'A bee visits a flower. How can this help the plant?',
      'The bee can move pollen between flowers',
      'The bee turns the plant into an animal',
      'The bee removes every root',
      'The bee makes the plant nonliving',
      'Bees visiting flowers can help move pollen.',
      'Living connections'
    ],
    [
      'A plant remains rooted. Which conclusion is correct?',
      'It is still living because it grows and uses resources',
      'It cannot be alive unless it walks',
      'It must be an animal',
      'It needs no water',
      'Plants stay rooted but carry out life processes.',
      'Plant life'
    ],
    [
      'A garden has flowers and butterflies. Why can both live there?',
      'The habitat can provide resources they need',
      'They are both nonliving',
      'All living things need the same body parts',
      'Butterflies have plant roots',
      'Habitats support living things by providing resources.',
      'Habitats'
    ],
    [
      'A young plant has roots but damaged leaves. Which job belongs mainly to its leaves?',
      'Capturing light to help make food',
      'Steering through water',
      'Hearing sounds',
      'Running quickly',
      'Leaves capture light; roots absorb water and minerals.',
      'Plant part functions'
    ],
    [
      'A caterpillar becomes a butterfly. What does this show?',
      'Animals can change during their life cycles',
      'Plants always have wings',
      'All animals have four legs',
      'The butterfly is nonliving',
      'Some animals change dramatically during their life cycles.',
      'Life cycles'
    ],
  ],
  [
    [
      'Which body part helps us see?',
      'Eyes',
      'Ears',
      'Nose',
      'Tongue',
      'Eyes collect visual information.',
      'Sight'
    ],
    [
      'Which body part helps us hear?',
      'Ears',
      'Eyes',
      'Tongue',
      'Feet',
      'Ears detect sounds.',
      'Hearing'
    ],
    [
      'Which body part mainly helps us smell?',
      'Nose',
      'Legs',
      'Hands',
      'Knees',
      'The nose helps detect odors in the air.',
      'Smell'
    ],
    [
      'Which body part helps us taste?',
      'Tongue',
      'Ear',
      'Foot',
      'Arm',
      'The tongue helps detect flavors.',
      'Taste'
    ],
    [
      'What helps us sense touch across our body?',
      'Skin',
      'Only the fingers',
      'Only the eyes',
      'Hair alone',
      'Skin covers the body and helps sense touch.',
      'Touch'
    ],
    [
      'Which parts help us walk and run?',
      'Legs and feet',
      'Nose and tongue',
      'Eyes and ears alone',
      'Teeth and hair',
      'Legs and feet support the body and help it move.',
      'Body jobs'
    ],
    [
      'Which body parts help us hold a pencil?',
      'Hands and fingers',
      'Ears',
      'Nose',
      'Knees',
      'Hands and fingers help hold objects and write.',
      'Body jobs'
    ],
    [
      'Which sense tells you the COLOR of an apple?',
      'Sight',
      'Hearing',
      'Taste',
      'Smell',
      'Sight gives information about color and shape.',
      'Sight'
    ],
    [
      'Which sense tells you that a bell is ringing?',
      'Hearing',
      'Taste',
      'Touch',
      'Smell',
      'Ears detect the sound of a bell.',
      'Hearing'
    ],
    [
      'Which sense tells you that a towel feels soft?',
      'Touch',
      'Sight alone',
      'Hearing',
      'Taste',
      'Skin detects texture such as softness.',
      'Touch'
    ],
    [
      'Which sense notices the odor of a flower?',
      'Smell',
      'Hearing',
      'Touch',
      'Taste',
      'The nose notices smells in the air.',
      'Smell'
    ],
    [
      'Which sense tells you that safe fruit tastes sweet?',
      'Taste',
      'Hearing',
      'Touch',
      'Sight',
      'Taste helps us notice flavors such as sweetness.',
      'Taste'
    ],
    [
      'What does the brain help us do with information from our senses?',
      'Understand it',
      'Turn it into a toy',
      'Stop all body movement',
      'Replace the need for ears',
      'Sense organs collect information; the brain helps us understand it.',
      'Brain and senses'
    ],
    [
      'Which part connects the head to the rest of the body?',
      'Neck',
      'Foot',
      'Finger',
      'Knee',
      'The neck connects the head and body and helps move the head.',
      'Body parts'
    ],
    [
      'You see a ball and catch it. Which explanation is correct?',
      'Eyes, brain, arms, hands, and fingers work together',
      'Only your ears catch it',
      'Only your tongue holds it',
      'Your body parts cannot work together',
      'Several parts can work together in one action.',
      'Working together'
    ],
    [
      'You hear a phone ring before finding it. Which sense detected the ring?',
      'Hearing',
      'Sight',
      'Taste',
      'Touch',
      'Hearing notices the sound even before the phone is visible.',
      'Choosing senses'
    ],
    [
      'You find an unknown liquid. What is the safe choice?',
      'Ask a trusted adult and do not taste it',
      'Taste it to identify it',
      'Assume every liquid is food',
      'Ask another child to taste it',
      'Only taste food or drinks a trusted adult says are safe.',
      'Sense safety'
    ],
    [
      'Music is painfully loud. What should you do?',
      'Move away and tell an adult',
      'Move closer to the speaker',
      'Put objects deep into your ears',
      'Ignore the pain',
      'Protect hearing by avoiding painfully loud sounds.',
      'Ear safety'
    ],
    [
      'An apple looks red, feels smooth, and smells fruity. What does this show?',
      'Several senses can give information about one object',
      'Only one sense can work at a time',
      'All this information comes from hearing',
      'Skin notices colors',
      'We often use several senses together.',
      'Multiple senses'
    ],
    [
      'Someone uses glasses or sign language. How should we treat them?',
      'With respect',
      'As unable to learn',
      'By refusing to communicate',
      'By hiding their tools',
      'People learn and communicate in many different ways.',
      'Respect'
    ],
    [
      'You want to know whether a blanket feels rough. Which source of information is most useful?',
      'Touch through your skin',
      'Taste through your tongue',
      'Hearing through your ears',
      'Smell through your nose',
      'Texture is information gathered through touch.',
      'Choosing senses'
    ],
    [
      'You see bright sunlight. Which choice protects your eyes?',
      'Avoid staring directly at the Sun',
      'Stare at the Sun to study its shape',
      'Rub your eyes with dirty hands',
      'Hold sharp objects near your eyes',
      'Very bright light can harm eyes; do not stare at the Sun.',
      'Eye safety'
    ],
    [
      'You hear a bark and recognize a dog. What happens?',
      'Ears detect sound and the brain helps recognize it',
      'The nose detects the color of the bark',
      'The tongue hears the dog',
      'Only the hands understand sound',
      'Sense organs and the brain work together.',
      'Brain and senses'
    ],
  ],
  [
    [
      'What weather has plenty of sunlight?',
      'Sunny',
      'Rainy',
      'Stormy',
      'Always snowy',
      'Sunny weather has plenty of sunlight.',
      'Sunny weather'
    ],
    [
      'What weather has many clouds covering the sky?',
      'Cloudy',
      'Always stormy',
      'Always rainy',
      'Always clear',
      'Cloudy weather can happen without rain.',
      'Cloudy weather'
    ],
    [
      'Water is falling from clouds. What weather is this?',
      'Rainy',
      'Only windy',
      'Dry and clear',
      'Always hot',
      'Rain is water falling from clouds.',
      'Rainy weather'
    ],
    [
      'What is wind?',
      'Moving air',
      'A kind of rock',
      'A plant root',
      'Still water',
      'Wind is moving air.',
      'Wind'
    ],
    [
      'Which condition may include thunder and lightning?',
      'Stormy',
      'Only a clear sky',
      'Only gentle warmth',
      'Every cloudy day',
      'Storms may bring thunder, lightning, rain, and strong wind.',
      'Storms'
    ],
    [
      'What tool measures temperature?',
      'Thermometer',
      'Raincoat',
      'Umbrella',
      'Hat',
      'A thermometer measures how warm or cold the air is.',
      'Temperature'
    ],
    [
      'Which item is useful when it rains?',
      'Umbrella',
      'Toy fan',
      'Pencil',
      'Sunflower seed',
      'An umbrella helps protect us from rain.',
      'Weather clothing'
    ],
    [
      'Leaves blow and a flag waves quickly. What does this suggest?',
      'Windy weather',
      'Air cannot move',
      'There must be snow',
      'It cannot be windy',
      'We notice wind by observing what moving air moves.',
      'Wind evidence'
    ],
    [
      'Does a cloudy day always mean rain is falling?',
      'No, clouds can appear without rain',
      'Yes, every cloud always rains',
      'Yes, clouds are umbrellas',
      'No, clouds never bring rain',
      'Some clouds bring rain, but a cloudy day does not always mean rain.',
      'Cloud clues'
    ],
    [
      'What does a rain gauge measure?',
      'How much rain falls',
      'Wind direction',
      'Plant height',
      'Sun brightness',
      'Rain gauges measure rainfall.',
      'Weather tools'
    ],
    [
      'What does a wind vane show?',
      'Where the wind is coming from',
      'How sweet food is',
      'How much rain falls',
      'Which plants are alive',
      'A wind vane shows wind direction.',
      'Weather tools'
    ],
    [
      'What does an anemometer measure?',
      'Wind speed',
      'Temperature',
      'Flower color',
      'Water taste',
      'An anemometer measures wind speed.',
      'Weather tools'
    ],
    [
      'The morning is sunny and the afternoon is rainy. What does this show?',
      'Weather can change during a day',
      'Weather always stays the same',
      'Rain only happens at night',
      'Sunlight is a season',
      'Weather can change within the same day.',
      'Changing weather'
    ],
    [
      'Which describes weather rather than a season?',
      'Today is rainy',
      'A longer part of the year',
      'A pattern lasting much longer',
      'A whole season',
      'Weather describes conditions now or over a short time.',
      'Weather and season'
    ],
    [
      'You hear thunder while playing. What is the safe choice?',
      'Go inside a safe building and follow adult instructions',
      'Continue playing in an open field',
      'Shelter under a lone tree',
      'Wait outside to watch lightning',
      'Thunderstorms can be dangerous; move to a safe indoor place.',
      'Storm safety'
    ],
    [
      'It is hot and sunny. What should you bring?',
      'A hat and drinking water',
      'Only a thick winter scarf',
      'Nothing to drink',
      'Only a rain gauge',
      'Water, shade, and sun protection help on hot sunny days.',
      'Sun safety'
    ],
    [
      'A path is wet after rain. How should you move?',
      'Walk carefully',
      'Run as fast as possible',
      'Slide across it',
      'Close your eyes while walking',
      'Rain can make paths slippery.',
      'Rain safety'
    ],
    [
      'Fast-moving floodwater is nearby. What is the safe choice?',
      'Stay away and follow adult guidance',
      'Play in it',
      'Walk into it to measure it',
      'Float toys while standing in it',
      'Never play in flooded areas or fast-moving floodwater.',
      'Flood safety'
    ],
    [
      'How can rain help plants?',
      'It provides water',
      'It gives them wings',
      'It makes all plants nonliving',
      'It replaces their roots',
      'Plants may receive needed water from rain.',
      'Living things and weather'
    ],
    [
      'The air feels cool. Which clothing may help?',
      'A jacket',
      'Only a sun hat',
      'Only a water bottle',
      'A toy car',
      'A jacket can help keep us comfortable in cool weather.',
      'Weather clothing'
    ],
    [
      'Dark clouds, falling water, umbrellas, and puddles are observed. Which conclusion fits the evidence?',
      'The weather is rainy',
      'The ground is dry',
      'It must be a clear sunny day',
      'No weather can be described',
      'Several observations together support a rainy-weather description.',
      'Weather observations'
    ],
    [
      'Strong wind moves branches and loose objects. What should you do?',
      'Stay away from loose objects and follow adult instructions',
      'Stand under a falling branch',
      'Chase loose objects into danger',
      'Assume moving air cannot be dangerous',
      'Strong wind can move dangerous objects; seek safety as directed.',
      'Wind safety'
    ],
    [
      'It was sunny earlier, but now you hear thunder. Which activity fits the new weather?',
      'Stay safely indoors',
      'Play in an open field',
      'Cycle outside through the storm',
      'Stand under a lone tree',
      'Observe changing weather and choose activities that fit it safely.',
      'Safe activities'
    ],
  ],
];

List<NorieQuestionContent> scienceQuestions(int lesson,
    {required bool mastery}) {
  final bank = _banks[lesson - 1];
  final start = mastery ? 20 : 0;
  final count = mastery ? 3 : 20;
  return List.generate(count, (i) {
    final row = bank[start + i];
    // Rotate the correct position without changing the answer or distractors.
    final position = (start + i) % 4;
    final options = row.sublist(1, 5);
    final rotated = [
      ...options.skip(4 - position),
      ...options.take(4 - position)
    ];
    final concept = row[6].toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    return NorieQuestionContent(
      id: 'science-g1-$lesson-${mastery ? 'mastery' : 'q'}${i + 1}',
      prompt: row[0],
      options: rotated,
      correctIndex: position,
      explanation: row[5],
      difficulty: mastery || i >= 14
          ? 'advanced'
          : i >= 7
              ? 'intermediate'
              : 'foundation',
      conceptId: 'science.g1.$lesson.$concept',
      conceptLabel: row[6],
    );
  });
}
