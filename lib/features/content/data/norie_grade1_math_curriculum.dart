import '../domain/norie_content_models.dart';
import 'authored_topic_builder.dart';

// Adapted instructional prose and practice from the reviewed historical branch
// origin/feature/grade1-math-lessons (9e38d55); no branch merge or XP-policy change.

abstract final class NorieGrade1MathCurriculum {
  static NorieTopicContent _ready(NorieTopicContent source) {
    final extra = _extensions[source.order]!;
    final practice = source.quiz.questions;
    return authoredTopic(
      subject: source.subject,
      accent: source.accent,
      visualType: 'authored-path',
      grade: 'g1',
      order: source.order,
      title: source.title,
      subtitle: source.subtitle,
      minutes: '20–30 minutes',
      objectives: source.lesson.sections.first.points,
      introduction: source.lesson.introduction,
      sections: [
        for (final section in source.lesson.sections.skip(1))
          NorieLessonSection(
              title: section.title,
              symbol: section.symbol,
              accent: section.accent,
              points: const [],
              body: section.points.join('\n\n'),
              visualType: section.visualType == 'g1-counting-number-line' &&
                      source.order == 3
                  ? 'g1-addition-number-line'
                  : section.visualType == 'g1-counting-number-line' &&
                          source.order == 4
                      ? 'g1-subtraction-number-line'
                      : section.visualType,
              visualCaption: section.visualCaption),
        NorieLessonSection(
            title: 'Guided example',
            symbol: '',
            accent: 'cyan',
            points: const [],
            body: extra[0]),
        NorieLessonSection(
            title: 'Guided solution',
            symbol: '',
            accent: 'cyan',
            points: const [],
            body: extra[1],
            reveal: true),
        NorieLessonSection(
            title: 'Lesson recap',
            symbol: '',
            accent: 'cyan',
            points: const [],
            body: source.lesson.keyConceptBody),
      ],
      keyConcept: source.lesson.keyConceptBody,
      questions: [
        for (final q in practice)
          [
            q.prompt,
            q.options[q.correctIndex],
            ...q.options
                .asMap()
                .entries
                .where((entry) => entry.key != q.correctIndex)
                .map((entry) => entry.value),
            q.explanation,
            _concepts[source.order]!
          ],
        ..._mastery[source.order]!.map((row) => row.split('|')),
      ],
      prerequisiteTopicId: source.prerequisiteTopicId,
    );
  }

  static const _concepts = {
    1: 'Counting and number order',
    2: 'Tens and ones',
    3: 'Joining groups',
    4: 'Taking away and checking',
    5: 'Shape properties and repeating units'
  };
  static const _extensions = <int, List<String>>{
    1: [
      'Count the sequence 47, 48, __, 50. Find the missing number, then say what comes just before it. Explain how each number changes.',
      'The missing number is 49 and its previous number is 48. Forward counting adds one each time.'
    ],
    2: [
      'Build 62 using tens and ones. Then compare it with 26. Which place should you examine first?',
      '62 has six tens and two ones. 26 has two tens and six ones. Compare tens first: six tens is more than two, so 62 is greater.'
    ],
    3: [
      'Eight birds are on a branch and three more land. Show how counting on finds the total without recounting the first eight.',
      'Begin at eight and count three new birds: nine, ten, eleven. The total is eleven, so 8 + 3 = 11.'
    ],
    4: [
      'Sixteen counters are shown and five are removed. Count backward to find what remains, then check with addition.',
      'Five backward counts are fifteen, fourteen, thirteen, twelve, eleven. Eleven remain, and 11 + 5 = 16 checks the answer.'
    ],
    5: [
      'Continue triangle, triangle, circle, triangle, triangle, circle. Name the repeating unit and next two shapes. If a triangle turns, do its sides change?',
      'The unit is triangle, triangle, circle. The next two shapes are triangle and triangle. Turning a triangle keeps its three sides.'
    ],
  };
  static const _mastery = <int, List<String>>{
    1: [
      'Which number comes between 68 and 70?|69|67|71|60|Counting forward adds one, so sixty-nine lies between sixty-eight and seventy.|Number order',
      'A group has seven buttons and another has ten. Which has fewer?|The seven-button group|The ten-button group|Both have the same|The larger buttons always|Seven is a smaller count than ten, regardless of button size.|Quantity comparison',
      'Continue backward: 34, 33, 32, __.|31|35|30|23|Each backward count is one less, so thirty-one comes next.|Number order',
    ],
    2: [
      'What number has six tens and two ones?|62|26|602|8|Six tens is sixty, and two ones add two to make sixty-two.|Tens and ones',
      'In 73, what is the value of the tens digit?|70|7|3|73|The seven is in the tens place and represents seven tens, or seventy.|Tens and ones',
      'Compare 54 and 59 using place value. Which is greater?|59|54|They are equal|Neither is two-digit|Their tens match, but nine ones is greater than four ones.|Place value comparison',
    ],
    3: [
      'There are eight birds and three more land. Total birds are what?|11|5|10|12|Counting on three from eight gives nine, ten, eleven.|Joining groups',
      'Find the missing part: 6 + __ = 13.|7|6|13|19|Seven additional objects join six to make thirteen.|Missing addend',
      'Which equation joins five shells and eight shells correctly?|5 + 8 = 13|5 − 8 = 13|5 + 8 = 12|5 + 8 = 3|Adding the two group counts gives thirteen shells.|Joining groups',
    ],
    4: [
      'Sixteen counters lose five. How many remain?|11|21|10|12|Counting backward five from sixteen reaches eleven.|Taking away',
      'Which addition checks 19 − 7 = 12?|12 + 7 = 19|19 + 7 = 12|12 + 19 = 7|7 + 7 = 19|Adding the removed seven to the remaining twelve rebuilds the original nineteen.|Inverse check',
      'A box held eighteen pencils; six were given away. How many remain?|12|24|6|13|Taking six from eighteen leaves twelve pencils.|Taking away',
    ],
    5: [
      'Continue triangle, triangle, circle, triangle, triangle, circle. Next shape?|Triangle|Circle|Square|Rectangle|The repeating unit begins again with its first triangle.|Repeating unit',
      'A triangle is turned upside down. How many straight sides remain?|3|4|2|0|Turning changes orientation but not its three straight sides.|Shape properties',
      'Which property distinguishes a square from a circle?|Four straight sides and four corners|Blue color|Large size|Being turned sideways|A square has four straight sides and corners; a circle has neither.|Shape properties',
    ],
  };
  static final topics = List<NorieTopicContent>.unmodifiable([
    _ready(_counting),
    _ready(_placeValue),
    _ready(_addition),
    _ready(_subtraction),
    _ready(_shapesPatterns)
  ]);

  static final _counting = NorieTopicContent(
    id: 'mathematics.g1.counting-to-100',
    subject: 'Mathematics',
    category: 'Grade 1',
    gradeLevel: 'g1',
    title: 'Counting to 100',
    subtitle: 'Count, read, order, and compare numbers from 0 to 100',
    order: 1,
    accent: 'cyan',
    visualType: 'authored-path',
    lesson: const NorieLessonContent(
      heading: 'Counting tells us how many',
      introduction:
          'Counting is more than saying number names in order. We count to find how many objects are in a group, to tell which number comes before or after another number, and to describe where a number belongs on a number line. In this lesson, you will build a strong counting pattern from 0 all the way to 100.',
      sections: [
        NorieLessonSection(
            title: 'Learning objectives',
            symbol: '',
            accent: 'cyan',
            points: [
              'Count objects carefully using one number for each object.',
              'Count forward and backward within 100.',
              'Tell the number before and after a given number.',
              'Compare two small quantities using more, fewer, or the same.',
            ]),
        NorieLessonSection(
          title: '1. Count one object at a time',
          symbol: '1',
          accent: 'cyan',
          visualType: 'g1-counting-counters',
          visualCaption: 'Eight counters counted one by one',
          points: [
            'Touch, point to, or move each object once as you count. Say one number for each object: “one, two, three…” This is called one-to-one counting.',
            'The last number you say tells how many objects are in the whole group. If you count 1, 2, 3, 4, 5, then there are 5 objects.',
            'Objects do not have to be in a straight row. You can still count them correctly as long as you keep track of which objects have already been counted.',
          ],
        ),
        NorieLessonSection(
          title: '2. Notice the pattern in the number names',
          symbol: '10',
          accent: 'violet',
          visualType: 'g1-counting-number-line',
          visualCaption: 'Numbers increase by one as you move right',
          points: [
            'When we count forward, each next number is exactly one more: 17, 18, 19, 20, 21. When we count backward, each next number is one less.',
            'After 29 comes 30. After 39 comes 40. The same pattern continues through 49, 59, 69, 79, 89, and 99.',
            'The decade numbers—10, 20, 30, 40, 50, 60, 70, 80, 90, and 100—help us organize the long counting sequence.',
          ],
        ),
        NorieLessonSection(
          title: '3. Worked example: count a group',
          symbol: '→',
          accent: 'orange',
          visualType: 'g1-counting-counters',
          visualCaption: 'Step-by-step counting model',
          points: [
            'Step 1: Start with an object you can recognize easily, such as the top-left counter.',
            'Step 2: Point to each new object once while saying the next number name.',
            'Step 3: Stop when every object has been counted. If the last number said is 8, the group has 8 objects.',
            'Step 4: Check by counting again in a different direction. The total should stay the same.',
          ],
        ),
        NorieLessonSection(
          title: '4. Before, after, and between',
          symbol: '↔',
          accent: 'green',
          visualType: 'g1-counting-number-line',
          visualCaption: 'Use a number line to find neighbors',
          points: [
            'On a number line, numbers grow larger as you move to the right. The number just before 42 is 41, and the number just after 42 is 43.',
            'A number can also be between two neighbors. For example, 56 is between 55 and 57.',
            'To compare quantities, count both groups. The group with the greater counting number has more objects.',
          ],
        ),
        NorieLessonSection(
          title: '5. Common counting mistakes',
          symbol: '!',
          accent: 'magenta',
          points: [
            'Do not count one object twice. Moving counted objects to one side can help.',
            'Do not skip an object just because it is far from the others. Scan the whole group before you finish.',
            'Do not guess the total from the size of the objects. Five large blocks are still fewer than eight tiny buttons.',
          ],
        ),
      ],
      keyConceptTitle: 'The last counting number tells the total',
      keyConceptBody:
          'Count each object exactly once. When you have counted every object, the final number you say is the number of objects in the group.',
      completionXp: 50,
    ),
    quiz: NorieQuizContent(
      questions: _countingQuestions(),
    ),
    challenge: NorieChallengeContent(
      title: 'Counting Mastery',
      description: 'Use number order and quantity clues without hints.',
      rounds: _countingQuestions().skip(17).take(3).toList(),
    ),
  );

  static final _placeValue = NorieTopicContent(
    id: 'mathematics.g1.place-value',
    subject: 'Mathematics',
    category: 'Grade 1',
    gradeLevel: 'g1',
    title: 'Place Value',
    subtitle: 'Build two-digit numbers using tens and ones',
    order: 2,
    accent: 'cyan',
    visualType: 'authored-path',
    prerequisiteTopicId: 'mathematics.g1.counting-to-100',
    lesson: const NorieLessonContent(
      heading: 'A digit has value because of its place',
      introduction:
          'Two-digit numbers are easier to understand when we group objects into tens and ones. Ten single objects can be bundled together to make one ten. The position of a digit tells whether it counts tens or ones.',
      sections: [
        NorieLessonSection(
            title: 'Learning objectives',
            symbol: '',
            accent: 'cyan',
            points: [
              'Explain that 10 ones make 1 ten.',
              'Identify the tens digit and ones digit in a two-digit number.',
              'Build and break apart numbers from 10 to 99.',
              'Compare two-digit numbers by looking at tens first.',
            ]),
        NorieLessonSection(
          title: '1. Make groups of ten',
          symbol: '10',
          accent: 'cyan',
          visualType: 'g1-place-value-blocks',
          visualCaption: 'Three tens and four ones make 34',
          points: [
            'Instead of counting 34 separate objects one by one, we can group them. Every group of 10 objects is called one ten.',
            'Thirty-four means 3 tens and 4 ones. The 3 is in the tens place, so it represents 30. The 4 is in the ones place, so it represents 4.',
            'We can write the same idea as 34 = 30 + 4.',
          ],
        ),
        NorieLessonSection(
          title: '2. Read the tens and ones places',
          symbol: 'TO',
          accent: 'violet',
          visualType: 'g1-place-value-blocks',
          visualCaption: 'Tens are on the left; ones are on the right',
          points: [
            'In a two-digit number, the left digit is the tens digit and the right digit is the ones digit.',
            'For 57, the digit 5 means 5 tens, or 50. The digit 7 means 7 ones.',
            'For 80, the digit 8 means 8 tens. The 0 tells us there are no extra ones.',
          ],
        ),
        NorieLessonSection(
          title: '3. Worked example: build 46',
          symbol: '→',
          accent: 'orange',
          points: [
            'Step 1: Look at the tens digit. The 4 tells us to make 4 groups of ten.',
            'Step 2: Look at the ones digit. The 6 tells us to add 6 single objects.',
            'Step 3: Combine the values: 40 + 6 = 46.',
            'Step 4: Check by counting by tens first—10, 20, 30, 40—then count on six more: 41, 42, 43, 44, 45, 46.',
          ],
        ),
        NorieLessonSection(
          title: '4. Compare two-digit numbers',
          symbol: '>',
          accent: 'green',
          points: [
            'Compare the tens digits first. A number with more tens is greater. For example, 63 is greater than 48 because 6 tens is more than 4 tens.',
            'If the tens digits are the same, compare the ones. For example, 52 is greater than 49 already because 5 tens is more than 4 tens. But for 52 and 57, both have 5 tens, so compare 2 ones and 7 ones.',
            'Equal numbers have the same number of tens and the same number of ones.',
          ],
        ),
        NorieLessonSection(
          title: '5. Common place-value mistakes',
          symbol: '!',
          accent: 'magenta',
          points: [
            'Do not read 42 as 4 + 2. The 4 is worth 40 because it is in the tens place.',
            'A zero can be important. In 60, the zero means there are no ones, not that the whole number is zero.',
            'When comparing, start with tens. Looking only at the last digit can give the wrong answer.',
          ],
        ),
      ],
      keyConceptTitle: '10 ones = 1 ten',
      keyConceptBody:
          'For a two-digit number, the left digit counts tens and the right digit counts ones. Example: 72 = 7 tens + 2 ones = 70 + 2.',
      completionXp: 50,
    ),
    quiz: NorieQuizContent(
      questions: _placeValueQuestions(),
    ),
    challenge: NorieChallengeContent(
      title: 'Tens and Ones Challenge',
      description: 'Build and compare two-digit numbers quickly.',
      rounds: _placeValueQuestions().skip(17).take(3).toList(),
    ),
  );

  static final _addition = NorieTopicContent(
    id: 'mathematics.g1.addition-basics',
    subject: 'Mathematics',
    category: 'Grade 1',
    gradeLevel: 'g1',
    title: 'Addition Basics',
    subtitle: 'Join groups and find totals within 20',
    order: 3,
    accent: 'cyan',
    visualType: 'authored-path',
    prerequisiteTopicId: 'mathematics.g1.place-value',
    lesson: const NorieLessonContent(
      heading: 'Addition joins amounts together',
      introduction:
          'Addition helps us find a total when two or more groups are combined. We can model addition with real objects, drawings, number lines, fingers, or equations. The plus sign (+) means join or add, and the equal sign (=) tells us that both sides have the same value.',
      sections: [
        NorieLessonSection(
            title: 'Learning objectives',
            symbol: '',
            accent: 'cyan',
            points: [
              'Explain addition as joining groups or counting on.',
              'Read and write simple addition equations.',
              'Find sums within 20 using objects, drawings, or a number line.',
              'Choose an efficient strategy such as counting on from the larger number.',
            ]),
        NorieLessonSection(
          title: '1. Join two groups',
          symbol: '+',
          accent: 'cyan',
          visualType: 'g1-addition-groups',
          visualCaption: '3 joined with 2 makes 5',
          points: [
            'Suppose you have 3 red counters and someone gives you 2 more. Put the groups together and count all the counters: 1, 2, 3, 4, 5.',
            'We write this as 3 + 2 = 5. The numbers being added are called addends, and the answer is called the sum.',
            'Addition does not change just because the objects are different. 3 apples + 2 apples and 3 blocks + 2 blocks both have a total of 5 objects.',
          ],
        ),
        NorieLessonSection(
          title: '2. Count on instead of starting over',
          symbol: '→',
          accent: 'violet',
          visualType: 'g1-counting-number-line',
          visualCaption: 'Start at 6 and jump forward 3 spaces',
          points: [
            'For 6 + 3, you do not have to count 1 through 6 again. Start at 6 and count on three more numbers: 7, 8, 9.',
            'Counting on is especially helpful when one addend is small.',
            'You can start with the larger addend to make the counting shorter. For 2 + 8, start at 8 and count 9, 10.',
          ],
        ),
        NorieLessonSection(
          title: '3. Worked example: 7 + 5',
          symbol: '1-2-3',
          accent: 'orange',
          points: [
            'Step 1: Start with 7 because it is already one of the groups.',
            'Step 2: Count on 5 more: 8, 9, 10, 11, 12.',
            'Step 3: The last number is 12, so 7 + 5 = 12.',
            'Step 4: Check by drawing 7 dots and 5 more dots, then count all 12 dots.',
          ],
        ),
        NorieLessonSection(
          title: '4. Addition facts are related',
          symbol: '↔',
          accent: 'green',
          points: [
            'Changing the order does not change the sum: 4 + 3 = 7 and 3 + 4 = 7.',
            'Adding zero keeps a number the same: 9 + 0 = 9.',
            'Doubles are useful facts to remember: 4 + 4 = 8, 5 + 5 = 10, and so on.',
          ],
        ),
        NorieLessonSection(
          title: '5. Common addition mistakes',
          symbol: '!',
          accent: 'magenta',
          points: [
            'When counting on, do not count the starting number as one of the jumps. For 5 + 2, say 6, 7—not 5, 6.',
            'The equal sign does not mean “the answer comes next.” It means the amount on the left is the same as the amount on the right.',
            'Check that you added every object once and did not accidentally count an object twice.',
          ],
        ),
      ],
      keyConceptTitle: 'Addition finds the total after joining',
      keyConceptBody:
          'You can model a + b by starting with one amount and counting forward by the other amount. The number you reach is the sum.',
      completionXp: 50,
    ),
    quiz: NorieQuizContent(
      questions: _additionQuestions(),
    ),
    challenge: NorieChallengeContent(
      title: 'Addition Sprint',
      description: 'Solve three sums using efficient counting strategies.',
      rounds: _additionQuestions().skip(17).take(3).toList(),
    ),
  );

  static final _subtraction = NorieTopicContent(
    id: 'mathematics.g1.subtraction-basics',
    subject: 'Mathematics',
    category: 'Grade 1',
    gradeLevel: 'g1',
    title: 'Subtraction Basics',
    subtitle: 'Take away, compare, and find what remains',
    order: 4,
    accent: 'cyan',
    visualType: 'authored-path',
    prerequisiteTopicId: 'mathematics.g1.addition-basics',
    lesson: const NorieLessonContent(
      heading: 'Subtraction finds what is left or the difference',
      introduction:
          'Subtraction can describe taking objects away, finding how many remain, or comparing two amounts. The minus sign (−) tells us to subtract. You can use counters, drawings, or a number line to make the change visible.',
      sections: [
        NorieLessonSection(
            title: 'Learning objectives',
            symbol: '',
            accent: 'cyan',
            points: [
              'Model subtraction by taking objects away.',
              'Read and solve subtraction equations within 20.',
              'Count backward to find a difference.',
              'Connect addition and subtraction as related operations.',
            ]),
        NorieLessonSection(
          title: '1. Start with the whole, then take away',
          symbol: '−',
          accent: 'cyan',
          visualType: 'g1-subtraction-take-away',
          visualCaption: 'Seven counters with two crossed out leaves five',
          points: [
            'For 7 − 2, begin with 7 objects. Remove or cross out 2 objects. Count what remains: 5.',
            'We write 7 − 2 = 5. The first number tells the starting amount, the second tells how many are removed, and the answer tells what remains.',
            'Subtraction makes sense only when you know what the numbers represent. A drawing can help you see the story.',
          ],
        ),
        NorieLessonSection(
          title: '2. Count backward on a number line',
          symbol: '←',
          accent: 'violet',
          visualType: 'g1-counting-number-line',
          visualCaption: 'Start at a number and jump left to subtract',
          points: [
            'To solve 9 − 3, start at 9 and move backward three steps: 8, 7, 6. The answer is 6.',
            'Moving left on a number line makes the number smaller. Each single jump left subtracts 1.',
            'Counting back is useful when the amount being subtracted is small.',
          ],
        ),
        NorieLessonSection(
          title: '3. Worked example: 13 − 5',
          symbol: '1-2-3',
          accent: 'orange',
          points: [
            'Step 1: Start at 13.',
            'Step 2: Count backward five numbers: 12, 11, 10, 9, 8.',
            'Step 3: Stop after exactly five backward moves. The answer is 8.',
            'Step 4: Check with addition. Since 8 + 5 = 13, we know 13 − 5 = 8.',
          ],
        ),
        NorieLessonSection(
          title: '4. Addition can check subtraction',
          symbol: '+/−',
          accent: 'green',
          points: [
            'Addition and subtraction are related. The facts 6 + 4 = 10, 4 + 6 = 10, 10 − 6 = 4, and 10 − 4 = 6 belong to the same fact family.',
            'If you solve 12 − 7 = 5, add 5 + 7. If the result is 12, your subtraction is correct.',
            'Subtracting zero changes nothing: 8 − 0 = 8. Subtracting a number from itself gives zero: 8 − 8 = 0.',
          ],
        ),
        NorieLessonSection(
          title: '5. Common subtraction mistakes',
          symbol: '!',
          accent: 'magenta',
          points: [
            'Do not count the starting number as the first backward jump. For 8 − 2, move to 7 and then 6.',
            'Pay attention to which number comes first. 9 − 4 is not the same as 4 − 9 in Grade 1 whole-number subtraction.',
            'If you use a drawing, cross out exactly the number being taken away, then count only the objects that are still visible.',
          ],
        ),
      ],
      keyConceptTitle: 'Subtract by removing or counting backward',
      keyConceptBody:
          'Start with the whole amount, take away the stated amount, and count what remains. You can check the answer by adding the parts back together.',
      completionXp: 50,
    ),
    quiz: NorieQuizContent(
      questions: _subtractionQuestions(),
    ),
    challenge: NorieChallengeContent(
      title: 'Subtraction Sprint',
      description: 'Find what remains and check with addition.',
      rounds: _subtractionQuestions().skip(17).take(3).toList(),
    ),
  );

  static final _shapesPatterns = NorieTopicContent(
    id: 'mathematics.g1.shapes-patterns',
    subject: 'Mathematics',
    category: 'Grade 1',
    gradeLevel: 'g1',
    title: 'Shapes & Patterns',
    subtitle: 'Describe shapes and continue repeating patterns',
    order: 5,
    accent: 'cyan',
    visualType: 'authored-path',
    prerequisiteTopicId: 'mathematics.g1.subtraction-basics',
    lesson: const NorieLessonContent(
      heading: 'Shapes have properties and patterns repeat by a rule',
      introduction:
          'Geometry begins by noticing what makes shapes alike or different. Patterns begin by noticing what repeats. In this lesson, you will describe common two-dimensional shapes and use repeating rules to predict what comes next.',
      sections: [
        NorieLessonSection(
            title: 'Learning objectives',
            symbol: '',
            accent: 'cyan',
            points: [
              'Name circles, triangles, squares, and rectangles.',
              'Describe shapes using sides and corners.',
              'Sort shapes by their properties instead of only by color or size.',
              'Identify and continue simple repeating patterns such as AB and AAB.',
            ]),
        NorieLessonSection(
          title: '1. Look at sides and corners',
          symbol: '△',
          accent: 'cyan',
          visualType: 'g1-shapes-basic',
          visualCaption: 'Common Grade 1 shapes',
          points: [
            'A circle is round. It has no straight sides and no corners.',
            'A triangle has 3 straight sides and 3 corners.',
            'A square has 4 equal straight sides and 4 square corners, like the corners of a sheet of paper. A rectangle has 4 straight sides and 4 square corners; its side lengths do not all have to be equal. A square is a special rectangle.',
          ],
        ),
        NorieLessonSection(
          title: '2. A shape stays the same when it turns',
          symbol: '↻',
          accent: 'violet',
          points: [
            'Turning a triangle upside down does not stop it from being a triangle. It still has 3 straight sides and 3 corners.',
            'A square can look like a diamond when it is turned, but its properties are still the same.',
            'Use properties—not the direction, color, or size—to decide what shape you see.',
          ],
        ),
        NorieLessonSection(
          title: '3. Worked example: classify a shape',
          symbol: '1-2-3',
          accent: 'orange',
          points: [
            'Step 1: Count the straight sides.',
            'Step 2: Count the corners.',
            'Step 3: Compare those properties with the shape rules. A shape with 3 straight sides and 3 corners is a triangle.',
            'Step 4: Turn the page or imagine the shape rotated. Its name should stay the same.',
          ],
        ),
        NorieLessonSection(
          title: '4. Find the repeating unit in a pattern',
          symbol: 'AB',
          accent: 'green',
          visualType: 'g1-shapes-pattern',
          visualCaption: 'Circle, square, circle, square...',
          points: [
            'A repeating pattern has a small part that repeats again and again. In circle, square, circle, square, the repeating unit is “circle, square.”',
            'An AB pattern uses two items in turn: A, B, A, B. An AAB pattern repeats two of one item followed by another: A, A, B, A, A, B.',
            'To find what comes next, say the repeating unit aloud and continue it in the same order.',
          ],
        ),
        NorieLessonSection(
          title: '5. Common shape and pattern mistakes',
          symbol: '!',
          accent: 'magenta',
          points: [
            'Do not name a shape only by how it is facing. Count its sides and corners.',
            'Do not assume every four-sided shape is a square. A rectangle can have two long sides and two short sides.',
            'When continuing a pattern, identify the full repeating unit first. Guessing from only the last item can lead to the wrong answer.',
          ],
        ),
      ],
      keyConceptTitle: 'Properties name shapes; rules continue patterns',
      keyConceptBody:
          'Count sides and corners to identify a shape. For a repeating pattern, find the smallest group that repeats, then continue that group in order.',
      completionXp: 50,
    ),
    quiz: NorieQuizContent(
      questions: _shapePatternQuestions(),
    ),
    challenge: NorieChallengeContent(
      title: 'Shape & Pattern Challenge',
      description: 'Use properties and repeating rules to solve each clue.',
      rounds: _shapePatternQuestions().skip(17).take(3).toList(),
    ),
  );

  static List<NorieQuestionContent> _countingQuestions() => [
        _q('count-q1', 'What number comes after 18?', ['17', '18', '19', '20'],
            '19', 'Counting forward one from 18 gives 19.'),
        _q('count-q2', 'What number comes before 40?', ['39', '40', '41', '30'],
            '39', 'Counting backward one from 40 gives 39.'),
        _q(
            'count-q3',
            'Which number is between 26 and 28?',
            ['25', '27', '29', '30'],
            '27',
            'The counting order is 26, 27, 28.'),
        _q(
            'count-q4',
            'Which number is greatest?',
            ['12', '21', '18', '9'],
            '21',
            '21 is farther along in the counting sequence than the other choices.'),
        _q('count-q5', 'Which number is smallest?', ['33', '30', '39', '36'],
            '30', '30 comes before 33, 36, and 39.'),
        _q('count-q6', 'Count on: 47, 48, 49, ___', ['40', '50', '59', '60'],
            '50', 'The next number after 49 is 50.'),
        _q('count-q7', 'Count backward: 15, 14, 13, ___',
            ['12', '16', '11', '10'], '12', 'One less than 13 is 12.'),
        _q(
            'count-q8',
            'Which list is in counting order?',
            ['8, 9, 10, 11', '8, 10, 9, 11', '11, 10, 8, 9', '9, 8, 11, 10'],
            '8, 9, 10, 11',
            'Counting order increases by one each time.'),
        _q('count-q9', 'What number comes after 69?', ['68', '70', '79', '60'],
            '70', '69 followed by one more is 70.'),
        _q('count-q10', 'What number comes before 100?',
            ['90', '98', '99', '101'], '99', '99 is one less than 100.'),
        _q('count-q11', 'Which number has one more than 54?',
            ['53', '54', '55', '64'], '55', 'One more than 54 is 55.'),
        _q('count-q12', 'Which number has one less than 73?',
            ['72', '74', '63', '70'], '72', 'One less than 73 is 72.'),
        _q(
            'count-q13',
            'Which group has more objects: 6 counters or 9 counters?',
            ['6 counters', '9 counters', 'They are equal', 'Cannot tell'],
            '9 counters',
            '9 is greater than 6, so 9 counters is more.'),
        _q(
            'count-q14',
            'Which pair shows the same quantity?',
            ['5 and 5', '4 and 6', '7 and 8', '9 and 3'],
            '5 and 5',
            'Equal quantities have the same counting number.'),
        _q('count-q15', 'Finish the sequence: 96, 97, 98, ___, 100',
            ['90', '95', '99', '101'], '99', '99 comes between 98 and 100.'),
        _q('count-q16', 'Which number is closer to 20 on a number line?',
            ['19', '14', '8', '2'], '19', '19 is only one step away from 20.'),
        _q(
            'count-q17',
            'If you count 11 objects and then add one more object, how many are there?',
            ['10', '11', '12', '21'],
            '12',
            'Adding one more moves from 11 to 12.'),
        _q(
            'count-q18',
            'Which number comes directly after 89?',
            ['88', '90', '99', '80'],
            '90',
            'The counting sequence changes from the 80s to 90 at this point.'),
        _q('count-q19', 'Count backward from 32 by one. Where do you land?',
            ['31', '33', '22', '30'], '31', 'One less than 32 is 31.'),
        _q(
            'count-q20',
            'Which statement is true?',
            [
              '45 is after 44',
              '45 is before 44',
              '45 is the same as 54',
              '45 comes after 50'
            ],
            '45 is after 44',
            'The counting order contains 44, then 45.'),
      ];

  static List<NorieQuestionContent> _placeValueQuestions() => [
        _q('pv-q1', 'How many tens are in 34?', ['3', '4', '7', '30'], '3',
            '34 has 3 tens and 4 ones.'),
        _q('pv-q2', 'How many ones are in 34?', ['3', '4', '30', '40'], '4',
            'The ones digit in 34 is 4.'),
        _q('pv-q3', 'Which number is 5 tens and 2 ones?',
            ['25', '52', '50', '7'], '52', '5 tens is 50 and 2 ones makes 52.'),
        _q(
            'pv-q4',
            'What is 67 as tens and ones?',
            ['6 tens and 7 ones', '7 tens and 6 ones', '67 tens', '6 ones'],
            '6 tens and 7 ones',
            'The 6 is in the tens place and 7 is in the ones place.'),
        _q(
            'pv-q5',
            'Which expanded form equals 42?',
            ['40 + 2', '4 + 2', '20 + 4', '40 + 20'],
            '40 + 2',
            '42 is 4 tens and 2 ones.'),
        _q('pv-q6', 'What number is 8 tens and 0 ones?',
            ['8', '80', '18', '88'], '80', '8 tens equals 80.'),
        _q('pv-q7', 'In 91, what is the value of the 9?',
            ['9', '90', '1', '91'], '90', 'The 9 is in the tens place.'),
        _q('pv-q8', 'In 58, what is the value of the 8?',
            ['80', '8', '50', '58'], '8', 'The 8 is in the ones place.'),
        _q(
            'pv-q9',
            'Which is greater?',
            ['46', '64', 'They are equal', 'Cannot tell'],
            '64',
            '64 has 6 tens while 46 has 4 tens.'),
        _q(
            'pv-q10',
            'Which is smaller?',
            ['72', '27', 'They are equal', 'Both are 70'],
            '27',
            '27 has only 2 tens, while 72 has 7 tens.'),
        _q('pv-q11', 'Which number has 3 tens and 9 ones?',
            ['93', '39', '30', '12'], '39', '30 + 9 = 39.'),
        _q('pv-q12', '70 + 5 equals...', ['57', '75', '705', '12'], '75',
            '7 tens plus 5 ones makes 75.'),
        _q(
            'pv-q13',
            'Which number has the same tens digit as 43?',
            ['47', '34', '53', '24'],
            '47',
            'Both 43 and 47 have 4 in the tens place.'),
        _q(
            'pv-q14',
            'What does the zero mean in 60?',
            ['No tens', 'No ones', 'The number is zero', 'Six ones'],
            'No ones',
            '60 has 6 tens and 0 ones.'),
        _q(
            'pv-q15',
            'Which comparison is true?',
            ['52 > 49', '52 < 49', '52 = 49', '5 > 49'],
            '52 > 49',
            '5 tens is greater than 4 tens.'),
        _q('pv-q16', 'Which number is made from 20 + 8?',
            ['28', '82', '208', '10'], '28', '2 tens and 8 ones make 28.'),
        _q(
            'pv-q17',
            'How many ones must be grouped to make one ten?',
            ['1', '5', '10', '100'],
            '10',
            'Ten individual ones can be regrouped as one ten.'),
        _q('pv-q18', 'Which number has 9 tens and 6 ones?',
            ['69', '96', '90', '15'], '96', '90 + 6 = 96.'),
        _q(
            'pv-q19',
            'Compare 75 and 71. Why is 75 greater?',
            [
              'It has more tens',
              'It has more ones',
              'It has fewer ones',
              'They are equal'
            ],
            'It has more ones',
            'Both have 7 tens, so compare the ones: 5 is greater than 1.'),
        _q(
            'pv-q20',
            'Which expanded form equals 99?',
            ['90 + 9', '9 + 9', '90 + 90', '9 + 0'],
            '90 + 9',
            '99 is 9 tens and 9 ones.'),
      ];

  static List<NorieQuestionContent> _additionQuestions() => [
        _q('add-q1', '2 + 3 = ?', ['4', '5', '6', '1'], '5',
            'Join 2 objects and 3 objects to get 5.'),
        _q('add-q2', '4 + 1 = ?', ['3', '4', '5', '6'], '5',
            'One more than 4 is 5.'),
        _q('add-q3', '6 + 2 = ?', ['7', '8', '9', '4'], '8',
            'Count on from 6: 7, 8.'),
        _q('add-q4', '5 + 5 = ?', ['5', '10', '15', '0'], '10',
            'This double fact is 5 + 5 = 10.'),
        _q('add-q5', '9 + 0 = ?', ['0', '8', '9', '10'], '9',
            'Adding zero does not change a number.'),
        _q('add-q6', '7 + 3 = ?', ['9', '10', '11', '4'], '10',
            'Count on three from 7: 8, 9, 10.'),
        _q('add-q7', '8 + 4 = ?', ['10', '11', '12', '13'], '12',
            'Count on four from 8: 9, 10, 11, 12.'),
        _q(
            'add-q8',
            '3 + 7 has the same sum as...',
            ['7 + 3', '7 − 3', '3 − 7', '7 + 7'],
            '7 + 3',
            'Changing the order of addends keeps the same sum.'),
        _q('add-q9', '10 + 2 = ?', ['8', '10', '12', '20'], '12',
            'Two more than 10 is 12.'),
        _q('add-q10', '6 + 6 = ?', ['10', '11', '12', '13'], '12',
            'The double of 6 is 12.'),
        _q('add-q11', 'There are 4 birds. 3 more land. How many birds now?',
            ['1', '7', '8', '12'], '7', 'The groups join: 4 + 3 = 7.'),
        _q(
            'add-q12',
            'Which equation makes 9?',
            ['5 + 4 = 9', '5 + 5 = 9', '9 + 1 = 9', '7 + 3 = 9'],
            '5 + 4 = 9',
            '5 and 4 combine to make 9.'),
        _q(
            'add-q13',
            'Start at 11 and count on 3. Where do you land?',
            ['12', '13', '14', '15'],
            '14',
            '12, 13, 14 are three counts after 11.'),
        _q('add-q14', '1 + 8 = ?', ['7', '8', '9', '10'], '9',
            'One more than 8 is 9.'),
        _q(
            'add-q15',
            'Which is a double fact?',
            ['4 + 4', '4 + 3', '5 + 4', '6 + 2'],
            '4 + 4',
            'A double fact adds the same number to itself.'),
        _q('add-q16', '13 + 2 = ?', ['14', '15', '16', '11'], '15',
            'Count on two from 13: 14, 15.'),
        _q('add-q17', 'Which symbol means add or join?', ['−', '+', '=', '<'],
            '+', 'The plus sign means addition.'),
        _q('add-q18', '7 + 5 = ?', ['11', '12', '13', '14'], '12',
            'Count on five from 7 to reach 12.'),
        _q('add-q19', '9 + 8 = ?', ['16', '17', '18', '19'], '17',
            '9 + 8 makes 17.'),
        _q(
            'add-q20',
            'Which equation is true?',
            ['6 + 4 = 10', '6 + 4 = 9', '6 + 4 = 11', '6 + 4 = 8'],
            '6 + 4 = 10',
            'Six joined with four makes ten.'),
      ];

  static List<NorieQuestionContent> _subtractionQuestions() => [
        _q('sub-q1', '5 − 2 = ?', ['2', '3', '4', '7'], '3',
            'Take 2 away from 5 and 3 remain.'),
        _q('sub-q2', '8 − 1 = ?', ['6', '7', '8', '9'], '7',
            'One less than 8 is 7.'),
        _q('sub-q3', '10 − 4 = ?', ['4', '5', '6', '14'], '6',
            'Remove 4 from 10 and 6 remain.'),
        _q('sub-q4', '7 − 0 = ?', ['0', '6', '7', '8'], '7',
            'Taking away zero changes nothing.'),
        _q('sub-q5', '9 − 9 = ?', ['0', '1', '9', '18'], '0',
            'Taking all 9 away leaves zero.'),
        _q('sub-q6', '12 − 2 = ?', ['9', '10', '11', '14'], '10',
            'Count back two from 12: 11, 10.'),
        _q('sub-q7', '13 − 5 = ?', ['7', '8', '9', '18'], '8',
            'Count back five from 13 to reach 8.'),
        _q(
            'sub-q8',
            'Which addition fact checks 10 − 6 = 4?',
            ['4 + 6 = 10', '10 + 6 = 4', '6 − 4 = 10', '4 + 10 = 6'],
            '4 + 6 = 10',
            'Difference + amount removed should rebuild the starting number.'),
        _q('sub-q9', 'There are 6 apples. 2 are eaten. How many remain?',
            ['3', '4', '6', '8'], '4', '6 − 2 = 4.'),
        _q('sub-q10', '15 − 3 = ?', ['11', '12', '13', '18'], '12',
            'Count back three: 14, 13, 12.'),
        _q('sub-q11', 'Which symbol means subtract or take away?',
            ['+', '−', '=', '>'], '−', 'The minus sign tells us to subtract.'),
        _q('sub-q12', '11 − 1 = ?', ['9', '10', '11', '12'], '10',
            'One less than 11 is 10.'),
        _q('sub-q13', '18 − 8 = ?', ['9', '10', '11', '26'], '10',
            '18 minus 8 leaves 10.'),
        _q('sub-q14', 'What is the missing number? 9 − 4 = ___',
            ['4', '5', '6', '13'], '5', 'Removing four from nine leaves five.'),
        _q(
            'sub-q15',
            'Which equation belongs to the fact family for 3 + 5 = 8?',
            ['8 − 5 = 3', '8 + 5 = 3', '5 − 8 = 3', '3 − 5 = 8'],
            '8 − 5 = 3',
            'The same three numbers can make related addition and subtraction facts.'),
        _q('sub-q16', '14 − 6 = ?', ['7', '8', '9', '20'], '8',
            'Counting back six from 14 lands on 8.'),
        _q('sub-q17', 'If 5 blocks are removed from 12 blocks, how many stay?',
            ['5', '6', '7', '17'], '7', '12 − 5 = 7.'),
        _q('sub-q18', '17 − 9 = ?', ['7', '8', '9', '26'], '8',
            '17 minus 9 equals 8.'),
        _q(
            'sub-q19',
            'Which equation is true?',
            ['16 − 7 = 9', '16 − 7 = 8', '16 − 7 = 10', '16 − 7 = 7'],
            '16 − 7 = 9',
            'Nine and seven make sixteen, so sixteen minus seven is nine.'),
        _q(
            'sub-q20',
            'A box had 20 crayons. 6 were taken out. How many remain in the box?',
            ['12', '13', '14', '26'],
            '14',
            '20 − 6 = 14.'),
      ];

  static List<NorieQuestionContent> _shapePatternQuestions() => [
        _q(
            'shape-q1',
            'Which shape has 3 straight sides?',
            ['Circle', 'Triangle', 'Square', 'Rectangle'],
            'Triangle',
            'A triangle has three straight sides.'),
        _q(
            'shape-q2',
            'Which shape has no straight sides?',
            ['Circle', 'Triangle', 'Square', 'Rectangle'],
            'Circle',
            'A circle is round and has no straight sides.'),
        _q('shape-q3', 'How many corners does a square have?',
            ['0', '3', '4', '5'], '4', 'A square has four corners.'),
        _q('shape-q4', 'How many sides does a rectangle have?',
            ['2', '3', '4', '6'], '4', 'A rectangle has four straight sides.'),
        _q(
            'shape-q5',
            'A square is turned like a diamond. What is it?',
            ['Still a square', 'A triangle', 'A circle', 'No longer a shape'],
            'Still a square',
            'Turning a shape does not change its properties.'),
        _q(
            'shape-q6',
            'Which property best identifies a triangle?',
            [
              '3 sides and 3 corners',
              '4 sides and 4 corners',
              'No sides',
              'One curved side'
            ],
            '3 sides and 3 corners',
            'Triangles have three straight sides and three corners.'),
        _q(
            'shape-q7',
            'Which can be true about a rectangle?',
            [
              'It has 4 corners',
              'It has no sides',
              'It always has 3 corners',
              'It must be round'
            ],
            'It has 4 corners',
            'Rectangles have four sides and four corners.'),
        _q(
            'shape-q8',
            'What comes next: circle, square, circle, square, ___?',
            ['Circle', 'Triangle', 'Square', 'Rectangle'],
            'Circle',
            'The AB unit circle-square repeats.'),
        _q(
            'shape-q9',
            'What comes next: red, red, blue, red, red, blue, ___?',
            ['Red', 'Blue', 'Green', 'Yellow'],
            'Red',
            'The repeating unit is red, red, blue.'),
        _q(
            'shape-q10',
            'What is the repeating unit in star, heart, star, heart?',
            ['star, heart', 'star only', 'heart only', 'star, star'],
            'star, heart',
            'The smallest repeated group is star then heart.'),
        _q(
            'shape-q11',
            'Which list is an AB pattern?',
            ['A, B, A, B', 'A, A, B, A', 'A, B, C, A', 'A, A, A, B'],
            'A, B, A, B',
            'AB alternates two items.'),
        _q(
            'shape-q12',
            'Which list is an AAB pattern?',
            ['A, A, B, A, A, B', 'A, B, A, B', 'A, B, B, A', 'A, A, A, A'],
            'A, A, B, A, A, B',
            'AAB repeats two A items followed by one B.'),
        _q(
            'shape-q13',
            'Which shape can have four equal sides?',
            ['Square', 'Circle', 'Triangle', 'Line'],
            'Square',
            'A square has four equal straight sides.'),
        _q(
            'shape-q14',
            'Which is NOT useful for naming a shape?',
            ['Its color', 'Its sides', 'Its corners', 'Its shape properties'],
            'Its color',
            'Shape names depend on geometric properties, not color.'),
        _q(
            'shape-q15',
            'What comes next: △, ○, △, ○, ___?',
            ['△', '○', '□', '☆'],
            '△',
            'Triangle-circle is the repeating AB unit.'),
        _q(
            'shape-q16',
            'A shape has 4 straight sides and 4 square corners, with two long sides and two short sides. It is a...',
            ['Rectangle', 'Triangle', 'Circle', 'Point'],
            'Rectangle',
            'Four square corners identify the rectangular shape; opposite sides can have different lengths.'),
        _q(
            'shape-q17',
            'If a triangle is rotated, how many sides does it still have?',
            ['2', '3', '4', '0'],
            '3',
            'Rotation does not change the number of sides.'),
        _q(
            'shape-q18',
            'Continue: square, square, circle, square, square, circle, ___',
            ['Square', 'Circle', 'Triangle', 'Rectangle'],
            'Square',
            'The repeating unit is square, square, circle.'),
        _q(
            'shape-q19',
            'Which description matches a circle?',
            [
              'Round with no corners',
              '3 sides and 3 corners',
              '4 equal sides',
              '4 corners'
            ],
            'Round with no corners',
            'A circle has no straight sides or corners.'),
        _q(
            'shape-q20',
            'Which strategy is best for continuing a pattern?',
            [
              'Find the part that repeats',
              'Look only at the last item',
              'Choose the biggest item',
              'Ignore the order'
            ],
            'Find the part that repeats',
            'The repeating unit tells you what comes next.'),
      ];

  static NorieQuestionContent _q(
    String id,
    String prompt,
    List<String> options,
    String answer,
    String explanation,
  ) {
    final correctIndex = options.indexOf(answer);
    return NorieQuestionContent(
      id: id,
      prompt: prompt,
      options: options,
      correctIndex: correctIndex,
      explanation: explanation,
      difficulty: id.endsWith('18') || id.endsWith('19') || id.endsWith('20')
          ? 'advanced'
          : id.endsWith('11') ||
                  id.endsWith('12') ||
                  id.endsWith('13') ||
                  id.endsWith('14') ||
                  id.endsWith('15') ||
                  id.endsWith('16') ||
                  id.endsWith('17')
              ? 'intermediate'
              : 'foundation',
    );
  }
}
