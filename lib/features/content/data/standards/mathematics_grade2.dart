import '../authored/core_math_unit.dart';
import '../authored/grade2_mathematics_core.dart';
import 'mathematics_authoring.dart';

final depedMath2 = <CoreMathUnit>[
  grade2MathUnits[0],
  grade2MathUnits[1],
  grade2MathUnits[2],
  grade2MathUnits[3],
  mathUnit(
      title: 'Sharing Equally and Unit Fractions',
      aims: [
        'Share objects into equal groups.',
        'Check division with multiplication.',
        'Name one equal part of a whole.'
      ],
      idea:
          'Division shares a total fairly. Twelve seeds shared among three pots give four seeds to each pot. Write 12 ÷ 3 = 4. Check by making three groups of four. A unit fraction names one equal part: 1/3 is one of three equal parts. The bottom number tells how many equal parts make the whole. More equal parts make each part smaller when the whole stays the same.',
      model: {
        '12 seeds': '[4] [4] [4]',
        'Division': '12 ÷ 3 = 4 in each group',
        'Check': '3 × 4 = 12',
        'One third': '[chosen][ ][ ]: one of three equal parts'
      },
      worked:
          'Share 20 beads among five children. Give each child one bead at a time. After four rounds all twenty beads are used. Each child has four. Check 5 × 4 = 20. If a strip is cut into five equal parts, one part is 1/5 of the strip.',
      tryIt:
          'Share 18 shells among 3 cups. Then name one equal part of a whole cut into eight parts.',
      check:
          'Each cup gets six shells since 3 × 6 = 18. One of eight equal parts is 1/8.',
      avoid:
          'Equal sharing requires the same number in each group. A fraction needs equal-sized parts, not just any pieces.',
      remember:
          'Total ÷ groups gives the number in each group. One equal part is a unit fraction.',
      bank: '''
What is 12 ÷ 2?|6|5;10;24|Two groups of six rebuild twelve.
What is 15 ÷ 5?|3|2;5;10|Five threes make fifteen.
Twenty-four stones in groups of four make how many groups?|6|4;8;20|Six groups of four use all twenty-four.
Which checks 16 ÷ 4 = 4?|4 × 4 = 16|16 + 4 = 4;4 - 4 = 16;16 × 4 = 4|Multiply the group count by its size.
One of three equal parts is what fraction?|1/3|3/1;1/2;3/3|Three equal parts make the whole and one is chosen.
In 1/6, what does 6 tell us?|Six equal parts make the whole|Six parts are chosen;The whole has one part;Each part is six wholes|The denominator counts equal parts in one whole.
Of the same cake, which piece is larger?|1/2|1/4;1/6;1/8|Dividing into fewer equal parts gives a larger piece.
Is one of four unequal pieces necessarily 1/4?|No, parts must be equal|Yes, any four pieces work;Yes, if it is smallest;Yes, if it is largest|Quarters require four equal shares.
Thirty seeds shared equally among five pots give how many per pot?|6|5;25;35|Five times six equals thirty.
What is 40 ÷ 10?|4|5;10;30|Four groups of ten make forty.
One strip is cut into ten equal pieces. One piece is what fraction?|1/10|10/1;1/5;10/10|One out of ten equal parts is one tenth.
'''),
  mathUnit(
      title: 'Lines Shapes and Growing Patterns',
      aims: [
        'Tell straight lines from curved lines.',
        'Sort flat shapes by sides and corners.',
        'Extend number patterns using a rule.'
      ],
      idea:
          'A straight line does not bend. A curved line bends. A square has four equal sides and four square corners. A rectangle has four square corners. A triangle has three sides. A circle has a curved edge and no corners. Shapes can be joined to make a bigger shape. A growing pattern follows a change, such as adding three each time: 3, 6, 9, 12.',
      model: {
        'Triangle': '3 straight sides; 3 corners',
        'Circle': 'Curved edge; no corners',
        'Growing rule': '4 → 8 → 12 → 16: add 4',
        'Joined parts': 'Two matching small squares make one rectangle'
      },
      worked:
          'Extend 5, 10, 15. First compare neighbours: each grows by five. Add five to fifteen to get twenty. Check the same rule works for every step. Draw a triangle and trace its three straight sides.',
      tryIt: 'What follows 18, 16, 14? How many corners does a rectangle have?',
      check:
          'The numbers decrease by two, so twelve comes next. A rectangle has four corners.',
      avoid:
          'A tilted square is still a square. Do not change a pattern rule halfway through.',
      remember:
          'Look at sides, corners, and curves. Find a rule that fits every shown pattern step.',
      bank: '''
Which line bends?|Curved line|Straight line;Square side;Ruler edge|A curve changes direction along its length.
How many corners has a triangle?|3|2;4;0|Its three sides meet at three corners.
Which shape has no corners?|Circle|Triangle;Square;Rectangle|The circle has a continuous curved edge.
How many square corners has a rectangle?|4|3;2;1|Each of its four corners is a right angle.
What follows 6, 9, 12?|15|13;14;18|Add three each time.
What follows 20, 18, 16?|14|12;15;18|Subtract two each time.
What follows 10, 20, 30?|40|31;35;50|The rule adds ten.
Two equal squares joined side by side make which outline?|Rectangle|Circle;Triangle;Pentagon|The outside has four square corners and opposite sides equal.
A square is turned on a corner. Its name is now what?|Square|Triangle;Circle;Not a shape|Turning preserves its sides and corners.
Fill the gap: 7, 14, __, 28.|21|20;22;24|Add seven at each step.
Which rule fits 25, 20, 15, 10?|Subtract 5|Add 5;Subtract 10;Add 10|Each neighbour is five smaller.
'''),
  grade2MathUnits[4],
  mathUnit(
      title: 'Standard Measures and Tile Area',
      aims: [
        'Choose centimetres, metres, grams, kilograms, and litres.',
        'Measure from zero on a ruler.',
        'Count square tiles covering a surface.'
      ],
      idea:
          'A centimetre is a short length. A metre is 100 centimetres. Start at the zero mark of a ruler, not its edge. We use grams for light objects and kilograms for heavier ones. A litre measures how much a container holds. Area tells how much flat space is covered. Cover it with equal square tiles without gaps or overlaps, then count the tiles.',
      model: {
        'Length': '0 to 8 cm on a ruler means 8 cm',
        'Mass': '1 kg = 1000 g',
        'Capacity': '1 litre holds 1000 millilitres',
        'Area': '2 rows × 3 square tiles = 6 square units'
      },
      worked:
          'A mat is covered by three rows of four equal square tiles. Count four, eight, twelve. Its area is twelve square tiles. Check no tiles overlap and no spaces are left. A metre-long strip equals one hundred centimetres.',
      tryIt:
          'A card covers 2 rows of 5 square tiles. What is its area? Which is better for the length of a pencil: centimetres or kilometres?',
      check:
          'Two rows of five cover ten square tiles. Centimetres fit a short pencil; kilometres are for much longer distances.',
      avoid:
          'Area counts covering tiles, not just the tiles along the edge. Kilograms measure mass, not length.',
      remember:
          'Choose a unit that matches the object. Area is the count of equal square units covering a surface.',
      bank: '''
Which unit fits the length of a pencil?|Centimetres|Kilograms;Litres;Hours|A pencil has a short length.
Which unit fits the mass of a sack of rice?|Kilograms|Metres;Litres;Minutes|A sack is weighed using mass units.
Which unit fits water held by a jug?|Litres|Grams;Centimetres;Days|Capacity tells how much liquid fits.
How many centimetres equal one metre?|100|10;1000;60|A metre is one hundred centimetres.
A line starts at 0 and ends at 7 cm. Length?|7 cm|6 cm;8 cm;0 cm|Subtract zero from seven.
Two rows of four square tiles cover what area?|8 square units|6 square units;4 square units;2 square units|Count four tiles in each of two rows.
Which tiling measures area fairly?|Equal tiles with no gaps or overlaps|Overlapping tiles;Different-sized tiles;Only corner tiles|Each equal tile covers one square unit.
Which is heavier: 2 kg or 1 kg?|2 kg|1 kg;Equal;Cannot compare|Two kilograms exceed one kilogram.
A strip is 9 cm long. Cut off 3 cm. Length left?|6 cm|12 cm;3 cm;9 cm|Nine minus three equals six.
Three rows of five tiles cover what area?|15 square units|8 square units;10 square units;20 square units|Five plus five plus five equals fifteen.
Two one-litre bottles hold how much altogether?|2 litres|1 litre;3 litres;20 litres|Add one litre and one litre.
'''),
  mathUnit(
      title: 'Tables Picture Charts and Chance',
      aims: [
        'Collect and count responses in a table.',
        'Read a picture key.',
        'Describe certain, possible, and impossible events.'
      ],
      idea:
          'Record each answer once in a table. A picture key tells how much each symbol stands for. If one star means two votes, three stars mean six votes. A chart makes groups easy to compare. An event is certain if it must happen, impossible if it cannot happen, and possible if it may or may not happen. These words describe a situation, not a wish.',
      model: {
        'Key': 'Each star = 2 votes',
        'Bus row': '* * * = 6 votes',
        'Walk row': '* * = 4 votes',
        'Bag': 'Only red counters: red is certain; blue is impossible'
      },
      worked:
          'A chart shows four stars for bananas and two stars for mangoes. Each star means two votes. Multiply 4 × 2 = 8 and 2 × 2 = 4. Bananas have four more votes. Check the total is twelve votes, not six.',
      tryIt:
          'A bag has red and blue counters only. Can a green counter be drawn? A row has five symbols worth two each. How many votes?',
      check:
          'Green is impossible because no green counter is in the bag. Five pairs make ten votes.',
      avoid:
          'Always read the key. Possible does not mean guaranteed, and impossible does not mean merely unlikely.',
      remember:
          'Use the key to count data. Use the contents of the situation to judge chance.',
      bank: '''
Each star means 2 votes. Three stars mean how many?|6|3;5;9|Three groups of two total six.
Each picture means 5 books. Two pictures mean how many?|10|2;5;7|Two fives make ten.
A table lists 4 cats and 7 dogs. Total pets?|11|3;10;12|Four plus seven equals eleven.
Which is more: 8 votes or 6 votes?|8 votes|6 votes;Equal;Neither|Eight is two more than six.
A bag contains only blue beads. Drawing blue is what?|Certain|Impossible;Possible but not certain;Unrelated|Every bead available is blue.
A bag contains only red beads. Drawing yellow is what?|Impossible|Certain;Guaranteed;Already happened|No yellow bead can be drawn.
A bag has red and blue beads. Drawing red is what?|Possible but not certain|Impossible;Certain;Never possible|There are red beads but a blue bead could be drawn.
How should a class survey count each learner?|Once|Twice;Only if tall;Not at all|One response per learner keeps the count accurate.
Four symbols worth 3 each represent how many?|12|7;4;9|Four groups of three total twelve.
A chart shows 10 walkers and 6 riders. Difference?|4|16;6;10|Subtract six from ten.
A box has 3 circles and 2 squares, no triangles. Which event is impossible?|Drawing a triangle|Drawing a circle;Drawing a square;Drawing a shape|The box contains no triangle.
'''),
];
