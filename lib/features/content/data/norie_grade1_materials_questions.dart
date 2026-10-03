import '../domain/norie_content_models.dart';

/// Independent recognition, comparison, and purpose questions from Lesson 5.
const _materialsBank = <List<String>>[
  [
    'What material is a wooden chair made from?',
    'Wood',
    'Glass',
    'Paper',
    'Rubber',
    'A wooden chair is made from wood, which comes from trees.',
    'Wood'
  ],
  [
    'What material is a metal spoon made from?',
    'Metal',
    'Fabric',
    'Paper',
    'Wood',
    'A metal spoon is made from metal. Many metals are hard and strong.',
    'Metal'
  ],
  [
    'Which material is often used to make bottles and buckets?',
    'Plastic',
    'Soft fabric',
    'Paper towel',
    'Foam',
    'Plastic can be shaped into bottles and buckets.',
    'Plastic'
  ],
  [
    'What material is a clear glass window made from?',
    'Glass',
    'Wood',
    'Rubber',
    'Fabric',
    'The window is made from glass. Clear glass lets us see through it.',
    'Glass'
  ],
  [
    'What material is a notebook page made from?',
    'Paper',
    'Metal',
    'Rubber',
    'Glass',
    'Notebook pages are paper, which is useful for writing and drawing.',
    'Paper'
  ],
  [
    'A cotton shirt is made from which kind of material?',
    'Fabric',
    'Glass',
    'Metal',
    'Wood',
    'Cotton can be made into fabric for shirts.',
    'Fabric'
  ],
  [
    'Which material is often used for bicycle tires and erasers?',
    'Rubber',
    'Paper',
    'Glass',
    'Wood',
    'Rubber is used for tires and erasers. It can be flexible and grippy.',
    'Rubber'
  ],
  [
    'Which property is useful for a comfortable blanket?',
    'Soft',
    'Transparent',
    'Hard',
    'Sharp',
    'A soft blanket feels soft. Different fabrics can have different properties.',
    'Hard and soft'
  ],
  [
    'An unfinished piece of wood feels uneven. Which property describes its surface?',
    'Rough',
    'Transparent',
    'Smooth',
    'Stretchy',
    'Rough describes an uneven surface. Some other wood feels smooth.',
    'Texture'
  ],
  [
    'A rubber band bends easily without breaking. Which property does this show?',
    'Flexible',
    'Stiff',
    'Transparent',
    'Sharp',
    'A flexible material can bend without breaking easily.',
    'Flexible and stiff'
  ],
  [
    'A paper towel takes in water. Which word describes this?',
    'Absorbent',
    'Waterproof',
    'Transparent',
    'Stiff',
    'Absorb means to take in liquid. Paper towels can absorb water.',
    'Waterproof and absorbent'
  ],
  [
    'You can see clearly through a clear glass window. Which property does it have?',
    'Transparent',
    'Opaque',
    'Rough',
    'Soft',
    'Transparent materials let light pass through so we can see through them.',
    'Transparent and opaque'
  ],
  [
    'A wooden door blocks your view of the next room. Which word fits?',
    'Opaque',
    'Transparent',
    'Stretchy',
    'Absorbent',
    'Opaque materials block our view. Wood is usually opaque.',
    'Transparent and opaque'
  ],
  [
    'Which properties are useful for a bicycle tire that bends and grips the road?',
    'Flexible and grippy',
    'Transparent and thin',
    'Soft and absorbent',
    'Sharp and breakable',
    'Rubber can bend and provide grip, making it useful for bicycle tires.',
    'Matching properties to a job'
  ],
  [
    'You need a window that lets you see outside. Which material fits the job?',
    'Clear glass',
    'Wood',
    'Hard metal',
    'Soft blanket fabric',
    'Clear glass is transparent, so it lets us see outside and lets light through.',
    'Choosing materials for a purpose'
  ],
  [
    'You want a raincoat that bends as you move and keeps rain away. Which material fits?',
    'Flexible waterproof fabric',
    'Absorbent paper',
    'Hard wood',
    'Breakable glass',
    'Flexible waterproof fabric bends and resists water, matching what a raincoat must do.',
    'Choosing materials for a purpose'
  ],
  [
    'Why is ordinary paper a poor choice for an umbrella cover in the rain?',
    'It can absorb water and become weak',
    'It always keeps water out',
    'It is as waterproof as rubber',
    'It stays strong when very wet',
    'Paper can take in water and become wet and weak. A waterproof cover fits this job better.',
    'Reasoning about water'
  ],
  [
    'A bicycle has a metal frame, rubber tires, and a cushioned seat. What does this show?',
    'One object can use several materials',
    'Every part must be metal',
    'All materials have the same properties',
    'Only rubber can make a bicycle',
    'Different bicycle parts use materials with properties suited to their jobs.',
    'Many materials in one object'
  ],
  [
    'You fold a sheet of paper to make an artwork. What material is the folded sheet?',
    'Still paper',
    'A new material because its shape changed',
    'Always waterproof now',
    'Too stiff to fold again',
    'Changing a material\'s shape does not always create a new material. Folded paper is still paper.',
    'Changing materials'
  ],
  [
    'You need a container for your pencils. What is a safe way to reuse an object?',
    'Use a clean safe box again',
    'Use a broken glass jar',
    'Touch sharp metal scraps',
    'Taste unknown materials first',
    'A clean safe box can hold pencils again. Reuse means using an object again, and safety matters.',
    'Safe reuse'
  ],
  // Independently authored mastery situations; never copies of quiz prompts.
  [
    'Two toys are plastic. One is hard and one bends. What can you conclude?',
    'Different plastics can have different properties',
    'Every plastic must bend',
    'Every plastic must be hard',
    'A bending toy cannot be plastic',
    'Plastic can be made in different forms. Some plastic is hard and some is flexible.',
    'Comparing material properties'
  ],
  [
    'Your class has used paper and plastic containers. How should you decide what to recycle?',
    'Follow local recycling instructions and adult guidance',
    'Put every material into the same bin',
    'Assume all plastics can be recycled anywhere',
    'Pick up broken glass to add to the bin',
    'Some materials may be recyclable, but rules differ by place. Follow local instructions and an adult\'s guidance.',
    'Recycling safely'
  ],
  [
    'You are making a blanket to feel soft and bend around you. Which choice and reason fit?',
    'Soft flexible fabric, because it fits the job',
    'Clear glass, because all objects need light',
    'Hard metal, because soft materials are useless',
    'Rough wood, because every material fits every job',
    'Soft flexible fabric fits the purpose of a comfortable blanket. The best material depends on the job.',
    'Explaining a material choice'
  ],
];

List<NorieQuestionContent> materialsQuestions({required bool mastery}) {
  final start = mastery ? 20 : 0;
  return List.generate(mastery ? 3 : 20, (i) {
    final row = _materialsBank[start + i];
    final position = (start + i) % 4;
    final options = row.sublist(1, 5);
    final concept = row[6].toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
    return NorieQuestionContent(
      id: 'science-g1-5-${mastery ? 'mastery' : 'q'}${i + 1}',
      prompt: row[0],
      options: [...options.skip(4 - position), ...options.take(4 - position)],
      correctIndex: position,
      explanation: row[5],
      difficulty: mastery || i >= 14
          ? 'advanced'
          : i >= 7
              ? 'intermediate'
              : 'foundation',
      conceptId: 'science.g1.5.$concept',
      conceptLabel: row[6],
    );
  });
}
