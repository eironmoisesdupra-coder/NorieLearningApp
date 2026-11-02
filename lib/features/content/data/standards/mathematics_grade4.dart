import '../authored/core_math_unit.dart';
import '../authored/grade4_mathematics_core.dart';
import 'mathematics_authoring.dart';

final depedMath4 = <CoreMathUnit>[
  mathUnit(
      title: 'Whole Numbers to One Million',
      aims: [
        'Read and compare six-digit numbers.',
        'Round to the nearest hundred thousand.',
        'Add and subtract large numbers with regrouping.'
      ],
      idea:
          'Each place is ten times the place to its right. In 642,305 the six means 600,000. Compare from the left until digits differ. To round to the nearest hundred thousand, inspect the ten-thousands digit. Five or more rounds up. To add or subtract, align the places and exchange groups of ten when needed. Rounding first gives a useful check on the size of an answer.',
      model: {
        '642,305': '600,000 + 40,000 + 2,000 + 300 + 5',
        'Round': '642,305 → 600,000',
        'Estimate': '386,000 + 218,000 ≈ 400,000 + 200,000',
        'Exact': '386,000 + 218,000 = 604,000'
      },
      worked:
          'Find 502,010 - 187,625. Exchange across the zero places to subtract ones, tens, hundreds, and thousands. The result is 314,385. Check by addition: 314,385 + 187,625 = 502,010. Rounded values give about 500,000 - 200,000 = 300,000, so the exact answer is reasonable.',
      tryIt:
          'Round 750,100 to the nearest hundred thousand. Add 245,670 + 132,250.',
      check:
          'The ten-thousands digit is five, so round up to 800,000. The sum is 377,920 after exchanging twelve tens for one hundred and two tens.',
      avoid:
          'Round using the digit immediately to the right of the target place. Keep zeros as place holders.',
      remember:
          'Use place value for comparing, rounding, and regrouping. Check exact calculations against estimates.',
      bank: '''
Value of 8 in 381,406?|80000|8000;800;8|Eight is in the ten-thousands place.
Which equals 700,052?|700000 + 50 + 2|700000 + 500 + 2;70000 + 50 + 2;700000 + 5 + 2|Only the hundred-thousands, tens, and ones are nonzero.
Which is larger: 456,789 or 456,798?|456798|456789;They are equal;Both exceed a million|The first differing place is the tens.
Round 349,999 to the nearest hundred thousand.|300000|400000;350000;340000|The ten-thousands digit four rounds down.
Round 650,000 to the nearest hundred thousand.|700000|600000;650000;1000000|Five in the next place rounds up.
What is 125,300 + 243,200?|368500|358500;378500;368050|Add matching places.
What is 600,000 - 250,000?|350000|450000;850000;250000|Subtract 250 thousands from 600 thousands.
Estimate 392,000 + 207,000 by rounding each to hundred thousands.|600000|500000;700000;599000|Round to 400,000 and 200,000.
What is 498,765 + 123,456?|622221|612221;622121;632221|Regroup each place from right to left.
What is 700,002 - 356,789?|343213|353213;443213;343223|Exchanges across zeros preserve the starting value.
Which checks 820,000 - 315,200 = 504,800?|504800 + 315200 = 820000|820000 + 315200 = 504800;504800 - 315200 = 820000;315200 + 820000 = 504800|The difference plus the removed amount must rebuild the whole.
'''),
  mathUnit(
      title: 'Triangles Quadrilaterals and Boundary Length',
      aims: [
        'Classify triangles and quadrilaterals.',
        'Measure an angle with a protractor.',
        'Find perimeters including joined shapes.'
      ],
      idea:
          'An equilateral triangle has three equal sides; an isosceles triangle has at least two. A right triangle has a 90-degree angle. A quadrilateral has four sides. A parallelogram has two pairs of parallel opposite sides. A rectangle has four right angles and a square also has four equal sides. Put a protractor centre on the corner, align zero with one ray, and read the scale beginning at that zero. Perimeter is the length around the outside.',
      model: {
        'Acute angle': 'Less than 90°',
        'Obtuse angle': 'Greater than 90° but less than 180°',
        'Joined rectangles': 'Perimeter = P1 + P2 - 2 × shared edge',
        'Square family': 'A square is also a rectangle and a parallelogram'
      },
      worked:
          'A 6 cm by 4 cm rectangle joins a 3 cm by 4 cm rectangle along their 4 cm sides. Their perimeters are 20 and 14 cm. The shared edge is inside, counted twice. Subtract 8: 20 + 14 - 8 = 26 cm. Check the outside is a 9 cm by 4 cm rectangle.',
      tryIt:
          'Find the perimeter of a quadrilateral with sides 4, 6, 5, and 7 cm. Is a 110° angle acute or obtuse?',
      check:
          'Add all outside sides: 4 + 6 + 5 + 7 = 22 cm. An angle of 110° is obtuse.',
      avoid:
          'Do not count an internal shared edge as boundary. A protractor has two scales: begin at the aligned zero.',
      remember:
          'Classify using sides and angles. Perimeter adds only the outside lengths.',
      bank: '''
A triangle has three equal sides. Name it.|Equilateral|Scalene;Right only;Quadrilateral|Equilateral means all three sides equal.
A 90° angle is what kind?|Right|Acute;Obtuse;Straight|A right angle measures ninety degrees.
A 35° angle is what kind?|Acute|Right;Obtuse;Straight|It is smaller than ninety degrees.
A 125° angle is what kind?|Obtuse|Acute;Right;Full|It lies between ninety and one hundred eighty degrees.
How many sides has a quadrilateral?|4|3;5;6|The name describes a four-sided polygon.
Which statement about a square is true?|It is also a rectangle|It has three sides;It has no right angles;Its opposite sides are not parallel|A square meets every rectangle condition.
Perimeter of sides 3, 5, 4, 6 cm?|18 cm|12 cm;24 cm;30 cm|Add the four boundary lengths.
Where should a protractor centre go?|At the angle vertex|At the ray end;Anywhere on the page;Outside both rays|The centre must sit where the two rays meet.
A 7 cm by 3 cm rectangle has perimeter what?|20 cm|21 cm;10 cm;14 cm|Add 7 + 3 + 7 + 3.
Two squares of side 4 cm share one full side. Outside perimeter?|24 cm|32 cm;16 cm;28 cm|The total 32 loses two copies of the shared 4 cm edge.
An isosceles triangle has sides 5, 5, 6 cm. Perimeter?|16 cm|11 cm;25 cm;30 cm|Add the three lengths, including both equal sides.
'''),
  grade4MathUnits[0],
  mathUnit(
      title: 'Converting Measures and Reading Time Intervals',
      aims: [
        'Convert length, mass, and capacity units.',
        'Convert clock units using sixty.',
        'Solve elapsed-time and measurement problems.'
      ],
      idea:
          'Use a conversion fact to keep the amount unchanged. One kilometre is 1000 metres; one metre is 100 centimetres. One kilogram is 1000 grams, one gram is 1000 milligrams, and one litre is 1000 millilitres. Smaller units require a larger count. Clock time uses sixty seconds per minute and sixty minutes per hour. Days have 24 hours and weeks have seven days. Months have different lengths; use an actual calendar rather than assuming four weeks per month.',
      model: {
        'Length': '250 cm ÷ 100 = 2.5 m',
        'Mass': '3 g × 1000 = 3000 mg',
        'Capacity': '1500 mL = 1 L 500 mL',
        'Time': '1 h 20 min = 60 + 20 = 80 min'
      },
      worked:
          'A bus leaves at 10:35 and arrives at 12:10. Count twenty-five minutes to 11:00, sixty to 12:00, and ten to 12:10. Total 95 minutes. Divide into sixty plus thirty-five: one hour thirty-five minutes.',
      tryIt: 'Convert 4 kg 250 g to grams. How long is 8:50 to 9:25?',
      check:
          'Four kilograms are 4000 g, so the total is 4250 g. Ten minutes reach 9:00 and twenty-five more reach 9:25: thirty-five minutes.',
      avoid:
          'Multiplying when converting to larger units makes the count too big. Months are not all thirty days.',
      remember:
          'Write the conversion fact, keep the same amount, and use clock jumps for time intervals.',
      bank: '''
How many metres are in 6 km?|6000|600;60;6|Multiply six by one thousand.
How many centimetres are in 9 m?|900|90;9000;9|Each metre contains one hundred centimetres.
How many grams are in 2 kg 300 g?|2300|2030;230;2003|Two thousand plus three hundred equals 2300.
How many milligrams are in 5 g?|5000|500;50;5|A gram contains one thousand milligrams.
How many litres equal 3000 mL?|3|30;300;3000|Divide by one thousand.
How many minutes equal 3 hours?|180|300;120;90|Three times sixty is 180.
How many hours equal 2 days?|48|24;12;20|Two times twenty-four equals forty-eight.
How many days equal 3 weeks?|21|30;14;24|Each week contains seven days.
Elapsed time from 1:45 to 3:20?|95 minutes|75 minutes;135 minutes;85 minutes|Fifteen plus sixty plus twenty equals ninety-five.
A 2 m ribbon loses 35 cm. Length left?|165 cm|235 cm;135 cm;65 cm|Change two metres to 200 cm before subtracting.
Which gives exact days in a particular month?|Check that month's calendar|Always use 28;Always use 30;Always use four weeks|Month lengths vary.
'''),
  mathUnit(
      title: 'Adding and Subtracting Fraction Amounts',
      aims: [
        'Change improper fractions and mixed numbers.',
        'Use common-sized parts to add or subtract.',
        'Regroup a whole when subtracting mixed numbers.'
      ],
      idea:
          'The denominator names a part size. Add or subtract counts of the same size without changing that size. For different denominators, first rename using equal fractions. Three quarters and one half become three quarters and two quarters. An improper fraction has at least one whole: 7/4 = 1 3/4. When subtracting 2 1/4 - 3/4, exchange one whole for four quarters.',
      model: {
        'Same parts': '2/7 + 3/7 = 5/7',
        'Rename': '1/2 = 2/4',
        'Add': '3/4 + 1/2 = 5/4 = 1 1/4',
        'Exchange': '2 1/4 = 1 5/4'
      },
      worked:
          'Find 3 1/3 - 1 5/6. First rename one third as two sixths: 3 2/6. Exchange one whole: 2 8/6. Subtract 1 5/6 to get 1 3/6. Simplify to 1 1/2. Check 1 1/2 + 1 5/6 = 3 1/3.',
      tryIt: 'Find 2/5 + 1/10. Then find 1 - 3/8.',
      check:
          'Two fifths are four tenths, so the sum is 5/10 = 1/2. One whole is eight eighths; subtract three to leave 5/8.',
      avoid:
          'Do not add denominators. Use the same whole and same-sized parts before combining.',
      remember:
          'Rename equal amounts, combine part counts, then simplify and check.',
      bank: '''
What is 2/9 + 4/9?|6/9|6/18;2/9;8/9|Six ninth-size parts result.
What is 7/8 - 3/8?|1/2|4/0;10/8;3/8|Four eighths simplify to one half.
What is 1/2 + 1/4?|3/4|2/6;1/6;1/8|Rename half as two quarters.
What is 5/6 - 1/3?|1/2|4/3;2/3;1/3|Five sixths minus two sixths equals three sixths.
Write 9/4 as a mixed number.|2 1/4|1 1/4;2 3/4;4 1/2|Eight quarters make two wholes with one quarter left.
Write 2 2/3 as an improper fraction.|8/3|4/3;6/3;7/3|Two wholes are six thirds, plus two thirds.
What is 1 - 2/5?|3/5|2/5;1/5;3/4|Five fifths minus two fifths leaves three.
What is 1 1/4 + 2 2/4?|3 3/4|3 3/8;2 3/4;4 1/4|Add wholes and equal fourth parts.
What is 2 1/5 - 4/5?|1 2/5|2 3/5;1 3/5;1 1/5|Exchange one whole to get 1 6/5 before subtracting.
What is 2/3 + 3/4?|1 5/12|5/7;5/12;1 1/12|Eight twelfths plus nine twelfths gives seventeen twelfths.
A jug holds 1 1/2 L. Use 3/4 L. Amount left?|3/4 L|1/4 L;2 1/4 L;1 L|One and a half is six quarters; subtract three quarters.
'''),
  grade4MathUnits[1],
  grade4MathUnits[2],
  grade4MathUnits[4],
  mathUnit(
      title: 'Line Graphs Rules and Number Sentences',
      aims: [
        'Read a time table and a single line graph.',
        'Find increases and decreases from data.',
        'Describe a number rule and balance number sentences.'
      ],
      idea:
          'A line graph shows how an amount changes over ordered times. Label the horizontal axis with time and the vertical axis with the measured amount and unit. Plot each table pair before joining neighbouring points. Read the scale, not just how steep the picture looks. A number pattern follows a rule. In a number sentence, both sides of the equals sign must have the same value.',
      model: {
        'Table': 'Day 1: 12 cm; day 2: 15 cm; day 3: 14 cm; day 4: 18 cm',
        'Horizontal axis': 'Days 1 to 4, equally spaced',
        'Vertical axis': 'Plant height in centimetres',
        'Rule': '4, 9, 14, 19: add 5'
      },
      worked:
          'The plant grows from 12 cm on day 1 to 18 cm on day 4. Subtract 18 - 12 = 6 cm overall. From day 2 to day 3 it drops by 1 cm. For 4 + __ = 6 + 3, first find the right side is nine, so the blank is five.',
      tryIt:
          'Use the table in the model. What is the largest day-to-day rise? Complete 7 × 4 = 4 × __.',
      check:
          'Day 3 to day 4 rises from fourteen to eighteen, or four centimetres. The blank is seven because multiplication can swap factors.',
      avoid:
          'A higher point means a larger value, not always a larger increase. An equals sign is not a command to write the next calculation.',
      remember:
          'Read axes and scales, compare values by subtraction, and keep both sides of an equation equal.',
      bank: '''
The horizontal axis is days. What belongs on the vertical height axis?|Centimetres|Learner names;Days again;Fruit names|The measured quantity is height.
Day 1 is 12 cm and day 2 is 15 cm. Increase?|3 cm|27 cm;2 cm;15 cm|Subtract twelve from fifteen.
Day 2 is 15 cm and day 3 is 14 cm. Change?|Decrease of 1 cm|Increase of 1 cm;Decrease of 29 cm;No change|Fourteen is one less than fifteen.
Which day in the model has the greatest height?|Day 4|Day 1;Day 2;Day 3|Eighteen is the largest listed height.
What follows 3, 7, 11, 15?|19|18;20;21|Add four at every step.
What is missing in 8 + __ = 13?|5|4;6;21|Eight needs five to make thirteen.
Complete 9 + 4 = 4 + __.|9|4;5;13|Swapping addends keeps the same total.
Complete 3 × 6 = 2 × __.|9|8;6;18|Both sides must equal eighteen.
Height rises from 17 cm to 25 cm. How much growth?|8 cm|42 cm;7 cm;9 cm|Twenty-five minus seventeen equals eight.
The rule is subtract 6. What follows 31, 25, 19?|13|12;14;15|Nineteen minus six is thirteen.
Why read a graph's scale before comparing points?|Each step may stand for several units|Each step always means one;Axes have no units;Lines determine exact future values|The marked scale determines each point's value.
'''),
  grade4MathUnits[3],
];
