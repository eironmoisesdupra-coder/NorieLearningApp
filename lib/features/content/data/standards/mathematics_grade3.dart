import '../authored/core_math_unit.dart';
import '../authored/grade3_mathematics_core.dart';
import 'mathematics_authoring.dart';

final depedMath3 = <CoreMathUnit>[
  mathUnit(
      title: 'Numbers Money and Operations to 10000',
      aims: [
        'Read thousands, hundreds, tens, and ones.',
        'Round and compare four-digit numbers.',
        'Add and subtract whole numbers and peso amounts.'
      ],
      idea:
          'In 4,276 the four means four thousand. Compare numbers from the largest place first. To round to the nearest hundred, look at the tens: five or more rounds up. Adding joins equal places. Subtracting may exchange one hundred for ten tens. For money in whole pesos, use the same place-value rules and write the peso sign.',
      model: {
        '4,276': '4,000 + 200 + 70 + 6',
        'Nearest hundred': '4,276 → 4,300',
        'Sum': '2,346 + 1,527 = 3,873',
        'Change': '₱500 - ₱275 = ₱225'
      },
      worked:
          'Find 3,402 - 1,785. Exchange through the zero: the top becomes 2 thousands, 13 hundreds, 9 tens, 12 ones. Subtract each place to get 1,617. Check 1,617 + 1,785 = 3,402.',
      tryIt:
          'Round 6,348 to the nearest hundred. A ₱350 bag is paid for with ₱500. Find the change.',
      check:
          'The tens digit is four, so 6,348 rounds to 6,300. Change is ₱500 - ₱350 = ₱150.',
      avoid:
          'A zero still holds a place. Rounding gives an estimate, not the exact value. Ordinal words such as twentieth tell position.',
      remember:
          'Read each place, align equal places, and use addition to check subtraction.',
      bank: '''
What is the value of 7 in 7,305?|7000|700;70;7|Seven is in the thousands place.
Which equals 5,082?|5000 + 80 + 2|500 + 80 + 2;5000 + 800 + 2;5000 + 8 + 2|The hundreds digit is zero.
Which number is greater?|6341|6314;6143;6134|Compare thousands, then hundreds, then tens.
Round 2,763 to the nearest hundred.|2800|2700;2760;3000|The tens digit six rounds the hundreds up.
What is 1,245 + 2,314?|3559|3459;3569;1069|Add each matching place without exchange.
What is 4,000 - 1,250?|2750|3250;2850;5250|Subtracting 1000 then 250 leaves 2750.
What is ₱245 + ₱125?|₱370|₱360;₱120;₱380|Five plus five ones exchange for a ten.
Pay ₱1000 for ₱675. Change?|₱325|₱425;₱1675;₱375|The price plus 325 rebuilds 1000.
What is 2,786 + 1,459?|4245|4145;4235;4345|Regroup ones, tens, and hundreds as needed.
What is 6,003 - 2,578?|3425|3525;3435;4525|Exchange across the zeros before subtracting.
Which ordinal names position 100?|Hundredth|Hundred;Tenth;Thousandth|The ending marks a place in an ordered list.
'''),
  grade3MathUnits[0],
  grade3MathUnits[1],
  grade3MathUnits[2],
  mathUnit(
      title: 'Lines Symmetry and Number Patterns',
      aims: [
        'Recognize parallel, intersecting, and perpendicular lines.',
        'Find a line of symmetry.',
        'Extend a pattern and complete an equation.'
      ],
      idea:
          'Parallel straight lines stay the same distance apart and do not meet. Intersecting lines meet. Perpendicular lines meet at a square corner. A line of symmetry splits a shape into two matching mirror halves. Patterns may grow or shrink by a steady amount. An equals sign tells us both sides have the same value.',
      model: {
        'Parallel': 'Rail tracks on a straight section do not meet.',
        'Perpendicular':
            'An upright line meets a horizontal line at 90 degrees.',
        'Square symmetry': 'Fold through the middle: matching halves overlap.',
        'Equation': '3 × 4 = 6 + 6 = 12'
      },
      worked:
          'Complete 4 × __ = 28. First ask which group size gives twenty-eight in four groups. Seven works because 7 + 7 + 7 + 7 = 28. Check 4 × 7 = 28. For 6, 12, 18, add six to get twenty-four.',
      tryIt:
          'A rectangle has a fold joining midpoints of opposite long sides. Is it a symmetry line? What follows 35, 30, 25?',
      check:
          'Yes, the two halves match. The pattern subtracts five each time, so twenty comes next.',
      avoid:
          'Lines that cross are not always perpendicular. A fold is a symmetry line only if both halves match exactly.',
      remember:
          'Use square corners to test perpendicular lines, matching halves for symmetry, and one consistent rule for a pattern.',
      bank: '''
Which lines never meet on a flat plane?|Parallel lines|Perpendicular lines;All intersecting lines;Crossed lines|Parallel lines remain a constant distance apart.
Lines meeting at a square corner are what?|Perpendicular|Parallel;Curved;Unconnected|The angle is a right angle.
How many straight symmetry lines has a non-square rectangle?|2|1;3;4|Horizontal and vertical midpoint folds match, but diagonals do not.
How many symmetry lines has a square?|4|1;2;3|Two midpoint folds and two diagonal folds match.
What follows 8, 16, 24?|32|30;28;40|Add eight each time.
What follows 50, 45, 40?|35|30;39;45|Subtract five each time.
What completes 6 × __ = 42?|7|6;8;9|Six sevens equal forty-two.
What completes 36 ÷ __ = 4?|9|8;6;12|Four groups of nine make thirty-six.
Which completes 9 + 7 = __ + 6?|10|9;11;16|Both sides must equal sixteen.
Two lines cross at 60 degrees. Are they perpendicular?|No|Yes;Only if long;Only if tilted|Perpendicular lines meet at ninety degrees.
Fill 4, 9, 14, __, 24.|19|18;20;21|The change is plus five at every step.
'''),
  grade3MathUnits[3],
  mathUnit(
      title: 'Changing Units and Elapsed Time',
      aims: [
        'Convert common length, mass, and capacity units.',
        'Convert hours, minutes, and seconds.',
        'Find elapsed time and solve measurement stories.'
      ],
      idea:
          'One metre is 100 centimetres. One kilometre is 1000 metres. One kilogram is 1000 grams, and one litre is 1000 millilitres. To change to smaller units, multiply by how many small units fit in one large unit. One hour is 60 minutes and one minute is 60 seconds. Count forward through the clock to find how long something lasts.',
      model: {
        'Length': '3 m = 300 cm',
        'Mass': '2 kg = 2000 g',
        'Capacity': '2 L = 2000 mL',
        'Clock jump': '2:40 → 3:00 = 20 min; → 3:15 = 15 min'
      },
      worked:
          'A trip begins at 8:45 and ends at 10:10. From 8:45 to 9:00 is fifteen minutes. From 9:00 to 10:00 is sixty minutes. Add ten more minutes to reach 10:10. Total: 85 minutes, or one hour twenty-five minutes.',
      tryIt:
          'How many centimetres are in 4 m? A game runs from 1:20 to 2:05. How long is it?',
      check:
          'Four groups of 100 make 400 cm. From 1:20 to 2:00 is forty minutes, then five more: forty-five minutes.',
      avoid:
          'Clock units use sixty, not one hundred. Smaller unit names produce larger counts for the same amount.',
      remember:
          'Use the correct conversion fact. Count forward in easy jumps to measure elapsed time.',
      bank: '''
How many centimetres are in 5 m?|500|50;5000;5|Multiply five by one hundred.
How many metres are in 2 km?|2000|200;20;2|Each kilometre contains one thousand metres.
How many grams are in 3 kg?|3000|300;30;3|Three groups of one thousand make three thousand.
How many millilitres equal 1 L?|1000|100;10;60|A litre has one thousand millilitres.
How many minutes equal 2 hours?|120|100;200;60|Two times sixty is one hundred twenty.
How many seconds equal 3 minutes?|180|30;300;120|Three times sixty is one hundred eighty.
Elapsed time from 4:10 to 4:50?|40 minutes|30 minutes;50 minutes;60 minutes|Subtract ten from fifty within the same hour.
Elapsed time from 9:30 to 10:15?|45 minutes|85 minutes;30 minutes;75 minutes|Thirty minutes to ten plus fifteen more.
Which is longer: 150 cm or 1 m?|150 cm|1 m;Equal;Cannot compare|One metre is 100 cm, which is less than 150.
A 2 L jug pours out 500 mL. How much remains?|1500 mL|2500 mL;500 mL;1000 mL|Change two litres to 2000 mL, then subtract 500.
A film runs from 2:45 to 4:00. Duration?|1 hour 15 minutes|1 hour 45 minutes;2 hours;45 minutes|Fifteen minutes reach three, then sixty reach four.
'''),
  grade3MathUnits[4],
  mathUnit(
      title: 'Experiments and Likelihood',
      aims: [
        'List possible outcomes of a simple experiment.',
        'Use likely, unlikely, certain, and impossible.',
        'Compare recorded outcomes without promising the next result.'
      ],
      idea:
          'An experiment is an action with an uncertain result, such as drawing a counter without looking. The possible outcomes depend on what is in the bag. With nine red counters and one blue counter, red is more likely but blue is still possible. Record each result in a tally. Past results describe what happened; they do not force the next result.',
      model: {
        'Bag': '9 red + 1 blue = 10 counters',
        'More likely': 'Red: nine available choices',
        'Less likely': 'Blue: one available choice',
        'Impossible': 'Green: no green counters'
      },
      worked:
          'A spinner has four equal parts: three yellow and one green. Count the yellow parts, then green. Yellow is more likely because it has more equal parts. Green can still happen. Blue is impossible because no part is blue.',
      tryIt:
          'A bag has only five white counters. Describe drawing white and drawing black. If a coin lands heads three times, must the next toss be tails?',
      check:
          'White is certain and black impossible. Tails is not forced next; either coin side can still land up.',
      avoid:
          'More likely is not certain. Compare equal-sized spinner parts, not colours alone.',
      remember:
          'List what can happen, compare available outcomes, and record actual results honestly.',
      bank: '''
A bag contains only red counters. Drawing red is what?|Certain|Impossible;Unlikely;Less likely than blue|Every available counter is red.
A bag contains no green counters. Drawing green is what?|Impossible|Certain;Likely;Guaranteed|There is no green counter to select.
A fair coin can land on which faces?|Heads or tails|Only heads;Only tails;Red or blue|These are the two coin faces.
A bag has 8 red and 2 blue counters. Which is more likely?|Red|Blue;Equal;Green|More counters are red.
A bag has 1 red and 9 blue counters. Drawing red is what?|Unlikely but possible|Impossible;Certain;More likely than blue|A red counter exists but is rare in the bag.
A spinner has 2 red and 2 blue equal parts. The colours are what?|Equally likely|Red certain;Blue impossible;Red more likely|Both colours occupy the same number of equal parts.
What should be recorded after each draw?|The actual colour drawn|The wished-for colour;Only red results;A guessed future result|Data must describe what happened.
Three heads in a row force the next fair toss to be tails. True?|No|Yes;Only in the morning;Only with a large coin|Previous tosses do not force the next face.
Ten trials give 6 red and 4 blue results. Which occurred more?|Red|Blue;Equal;Neither|Six recorded red results exceed four blue results.
A six-face die has faces 1 to 6. Which result is impossible?|7|1;3;6|Seven is not printed on any face.
A spinner has 5 equal yellow parts and 1 green. Which statement is right?|Green may happen|Yellow must happen;Green cannot happen;Both colours are certain|One green part makes green possible, although less likely.
'''),
];
