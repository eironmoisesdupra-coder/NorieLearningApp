import '../authored/core_math_unit.dart';
import '../authored/grade5_mathematics_core.dart';
import 'mathematics_authoring.dart';

final depedMath5 = <CoreMathUnit>[
  mathUnit(
      title: 'Large Numbers and Divisibility',
      aims: [
        'Read numbers through ten million.',
        'Test divisibility using number properties.',
        'Use common factors and multiples in problems.'
      ],
      idea:
          'In 7,406,025, the seven means seven million. Compare large numbers at their first different place. A number is divisible by another if division leaves no remainder. An even last digit tests divisibility by two; a last digit zero or five tests five. A digit sum divisible by three tests three. Factor pairs multiply to a number. The greatest common factor makes the largest equal groups; the least common multiple finds the first shared repeating total.',
      model: {
        '7,406,025': '7,000,000 + 400,000 + 6,000 + 20 + 5',
        '246 ÷ 3': '2 + 4 + 6 = 12, divisible by 3',
        'GCF of 18 and 24': 'Shared factors 1, 2, 3, 6; greatest 6',
        'LCM of 6 and 8': 'First common positive multiple 24'
      },
      worked:
          'Pack 18 red and 24 blue beads into the greatest number of identical packs without leftovers. List common factors of 18 and 24: 1, 2, 3, 6. Choose six packs. Each has three red and four blue beads. Check six threes are eighteen and six fours are twenty-four.',
      tryIt:
          'Is 435 divisible by three and five? Find the first shared positive multiple of four and ten.',
      check:
          'Its digit sum is twelve, so it is divisible by three. It ends in five, so it is divisible by five. The first shared multiple is twenty.',
      avoid:
          'Divisible does not mean merely smaller. Factors divide a number; multiples are repeated copies of it.',
      remember:
          'Use place value, divisibility tests, and exact factor or multiple lists to support a decision.',
      bank: '''
Value of 6 in 6,254,013?|6000000|600000;60000;6000|Six is in the millions place.
Which number is divisible by 2?|438|435;437;439|Its last digit eight is even.
Which number is divisible by 5?|725|722;723;724|The final digit is five.
Is 312 divisible by 3?|Yes, digit sum is 6|No, it ends in 2;No, it has three digits;Yes, all numbers are|Three plus one plus two is divisible by three.
Which is a factor of 36?|9|5;7;10|Nine times four equals thirty-six.
Greatest common factor of 12 and 20?|4|2;6;12|Four is their largest shared factor.
Least common positive multiple of 3 and 4?|12|7;9;24|Twelve is the first positive multiple shared by both.
Which number is prime?|17|15;21;27|Only one and seventeen divide it exactly.
How many identical packs can use all 16 red and 24 blue beads at most?|8|4;12;16|The greatest common factor is eight.
Two bells ring every 6 and 10 minutes. After ringing together, when next together?|30 minutes|16 minutes;20 minutes;60 minutes|Thirty is the least common positive multiple.
Round 8,650,000 to the nearest million.|9000000|8000000;8600000;8650000|The hundred-thousands digit six rounds up.
'''),
  grade5MathUnits[4],
  grade5MathUnits[0],
  grade5MathUnits[1],
  mathUnit(
      title: 'Ratios Proportions and Percent Models',
      aims: [
        'Compare quantities using ordered ratios.',
        'Find an equivalent ratio and a missing proportion.',
        'Connect percent with fractions and decimals.'
      ],
      idea:
          'A ratio keeps an order: two red beads for three blue is red to blue 2:3. It is not two out of three beads overall; there are five beads. Multiply both terms by the same number to scale a ratio. A proportion states two ratios are equal. Percent means out of one hundred. Thus 25% is 25/100 = 1/4 = 0.25.',
      model: {
        'Mixture': '2 red : 3 blue; total 5 parts',
        'Double batch': '4 red : 6 blue',
        'Proportion': '2/3 = 8/12',
        'Percent grid': '25 shaded squares out of 100 = 25%'
      },
      worked:
          'A recipe uses 3 cups of rice for 6 people. To serve 10 people, first find 3 ÷ 6 = 1/2 cup per person. Multiply by ten to get five cups. Check 3/6 and 5/10 both equal one half. For 20% of 150, take 20/100 × 150 = 30.',
      tryIt:
          'For a 1:4 syrup-to-water ratio, how much water goes with 3 cups syrup? Write 3/4 as a percent.',
      check:
          'Multiply both parts by three: 3:12, so twelve cups water. Three quarters is 75/100, or 75%.',
      avoid:
          'Do not reverse ratio order. The whole for percent must be identified before calculating a part.',
      remember:
          'Scale both ratio terms equally. Percent is a fraction with denominator one hundred.',
      bank: '''
There are 3 red and 5 blue beads. Red-to-blue ratio?|3:5|5:3;3:8;5:8|Keep the named order.
In that group, red-to-total ratio is what?|3:8|3:5;5:3;8:3|The total is three plus five.
Which ratio equals 2:7?|6:21|4:7;2:14;7:2|Both terms were multiplied by three.
Complete 3/4 = __/20.|15|12;16;17|Multiply numerator and denominator by five.
What fraction is 50% in simplest form?|1/2|1/5;5/1;1/50|Fifty out of one hundred reduces to half.
Write 0.3 as a percent.|30%|3%;0.3%;300%|Three tenths equals thirty hundredths.
What is 10% of 80?|8|10;70;800|One tenth of eighty is eight.
What is 25% of 60?|15|25;30;20|One quarter of sixty is fifteen.
A ratio of flour to sugar is 4:1. For 12 cups flour, sugar needed?|3 cups|4 cups;8 cups;48 cups|The flour part is tripled, so triple the sugar.
What is 60% of 150?|90|60;75;100|Multiply 0.6 by 150.
In 40 equal squares, 10 are shaded. Percent shaded?|25%|10%;40%;75%|Ten out of forty is one quarter.
'''),
  mathUnit(
      title: 'Polygons Circles and Solid Models',
      aims: [
        'Classify polygons by sides.',
        'Relate radius, diameter, and circumference.',
        'Identify faces and nets of simple solids.'
      ],
      idea:
          'A polygon is closed and made of straight sides. A regular polygon has all sides equal and all angles equal. Five sides make a pentagon and six make a hexagon. A circle has no straight sides. A radius joins its centre to its edge. A diameter crosses the centre and equals two radii. Circumference is the distance around: C = πd. A net folds from a flat arrangement into the faces of a solid.',
      model: {
        'Regular hexagon': '6 equal sides and 6 equal angles',
        'Circle radius': 'Centre to edge: r',
        'Circle diameter': 'Edge through centre to edge: d = 2r',
        'Cube net': '6 square faces joined so they can fold without overlap'
      },
      worked:
          'A circular hoop has radius 7 cm. Double it to get diameter 14 cm. Use π = 22/7: C = 22/7 × 14 = 44 cm. Check this is a length around the hoop, not an area.',
      tryIt:
          'Name a polygon with eight sides. Find the diameter of a circle with radius 5 cm. How many square faces does a cube have?',
      check:
          'An eight-sided polygon is an octagon. Double five to get diameter ten centimetres. A cube has six square faces.',
      avoid:
          'Equal sides alone do not guarantee a regular polygon. Radius is half the diameter. A circle is not a polygon.',
      remember:
          'Classify polygons using sides and angles. Label the circle centre, radius, and diameter before calculating.',
      bank: '''
A polygon with five sides is what?|Pentagon|Hexagon;Octagon;Triangle|Penta names five sides.
A polygon with six sides is what?|Hexagon|Pentagon;Octagon;Quadrilateral|Hexa names six sides.
What makes a polygon regular?|Equal sides and equal angles|Only equal sides;Only one right angle;Any closed curve|Both conditions are required.
Which is not a polygon?|Circle|Triangle;Square;Pentagon|Its boundary is curved.
A circle has radius 4 cm. Diameter?|8 cm|2 cm;4 cm;16 cm|Double the radius.
A circle has diameter 18 cm. Radius?|9 cm|18 cm;36 cm;6 cm|Take half the diameter.
Using π = 3.14, circumference for diameter 10 cm?|31.4 cm|314 cm;15.7 cm;10 cm|Multiply pi by diameter.
How many square faces has a cube?|6|4;8;12|A cube has six equal square faces.
A cube net is made of what flat shapes?|Squares|Circles;Only triangles;Only semicircles|Each cube face is a square.
Using π = 22/7, circumference for radius 14 cm?|88 cm|44 cm;28 cm;616 cm|Use 2 × 22/7 × 14.
A regular pentagon has side 6 cm. Perimeter?|30 cm|11 cm;24 cm;36 cm|Five equal sides total five times six.
'''),
  mathUnit(
      title: 'Circle Area and Temperature',
      aims: [
        'Distinguish area from circumference.',
        'Calculate circle area using radius.',
        'Read and compare Celsius temperatures.'
      ],
      idea:
          'Area measures flat space in square units. Cut a circle into many thin sectors and arrange them alternately: the shape approaches a rectangle with height r and base πr. So A = πr². Use radius, not diameter. A thermometer scale measures temperature in degrees Celsius. Read the value at the liquid level and the value of each marked step. A temperature rise is ending minus starting temperature.',
      model: {
        'Circle area': 'A = π × r × r',
        'Radius 3 cm': 'A = 9π cm²',
        'Thermometer steps': '20, 22, 24, 26: each step is 2°C',
        'Temperature rise': '29°C - 24°C = 5°C'
      },
      worked:
          'A round mat has diameter 10 m. First halve the diameter: r = 5 m. Square it: 25 m². Multiply by 3.14: area = 78.5 m². Check the unit is square metres. If temperature rises from 23°C to 31°C, the rise is 8°C.',
      tryIt:
          'Using π = 3.14, find the area of a circle with radius 2 cm. A thermometer drops from 30°C to 26°C. Find the fall.',
      check:
          'A = 3.14 × 2 × 2 = 12.56 cm². The temperature falls by four degrees Celsius.',
      avoid:
          'Do not use πd for area or write a length unit for a surface. A warmer temperature does not mean more degrees between every tick.',
      remember:
          'Area uses πr² and square units. Read thermometer tick values before comparing temperatures.',
      bank: '''
Which formula gives circle area?|πr²|2πr;πd;r + d|The surface has area pi times radius squared.
What radius belongs to diameter 12 cm?|6 cm|12 cm;24 cm;3 cm|Radius is half the diameter.
Using π = 3.14, area for radius 1 cm?|3.14 cm²|6.28 cm²;1 cm²;31.4 cm²|Square one and multiply by pi.
Using π = 3.14, area for radius 3 cm?|28.26 cm²|18.84 cm²;9.42 cm²;9 cm²|Three squared is nine, then multiply by 3.14.
Which unit fits the area of a circular garden?|Square metres|Metres;Litres;Degrees Celsius|Area measures two-dimensional coverage.
Temperature rises from 21°C to 28°C. Rise?|7°C|49°C;6°C;8°C|Subtract the starting value from the ending value.
Temperature falls from 32°C to 27°C. Fall?|5°C|59°C;4°C;6°C|Thirty-two minus twenty-seven is five.
Ticks read 10, 15, 20. Each step means what?|5°C|1°C;2°C;10°C|Neighbouring values differ by five.
Using π = 22/7, area for radius 7 m?|154 m²|44 m²;49 m²;308 m²|Multiply 49 by 22/7.
A circle's diameter doubles. How does its area change?|Becomes four times as large|Doubles;Halves;Stays equal|The radius doubles and its square multiplies by four.
A temperature of 25°C rises by 6°C. New reading?|31°C|19°C;30°C;150°C|Add the rise to the initial reading.
'''),
  grade5MathUnits[2],
  mathUnit(
      title: 'Line Graphs and Experimental Probability',
      aims: [
        'Read two data series on one time graph.',
        'Compare changes using a legend.',
        'Estimate chance from recorded experiments.'
      ],
      idea:
          'A double-line graph uses one time axis and two labelled lines. A legend tells which line belongs to each group. Compare values at the same time and use the vertical scale. In an experiment, relative frequency is the number of times an event occurs divided by the total trials. It describes the observed results. More trials can improve an estimate, but they do not guarantee a particular next result.',
      model: {
        'Monday': 'Class A: 8 books; class B: 6 books',
        'Tuesday': 'Class A: 10 books; class B: 9 books',
        'Legend': 'Solid line = A; dotted line = B',
        'Experiment': '12 heads in 20 tosses: 12/20 = 0.6'
      },
      worked:
          'On Tuesday, A reads ten books and B reads nine. Their difference is one book. A increased by two since Monday; B increased by three. In forty spinner trials, green occurs eighteen times. The experimental chance is 18/40 = 9/20 = 45%.',
      tryIt:
          'Which class had the larger Monday-to-Tuesday increase? A die shows six in 8 of 48 rolls. Find its observed fraction.',
      check:
          'Class B increased by three rather than two. The observed fraction for six is 8/48 = 1/6.',
      avoid:
          'Do not compare points from different days by accident. Experimental frequency need not equal the theoretical chance exactly.',
      remember:
          'Read the legend and axes. Use event count divided by trials for an experimental estimate.',
      bank: '''
What identifies the two lines in a double-line graph?|Legend|Title alone;Page number;Date alone|The legend maps line styles to groups.
In the model, how many books does A read Tuesday?|10|8;9;6|Read A at Tuesday.
In the model, how many more books does A read than B Monday?|2|1;3;14|Eight minus six equals two.
How much does B increase from Monday to Tuesday?|3 books|2 books;1 book;15 books|Nine minus six equals three.
An event occurs 6 times in 20 trials. Relative frequency?|3/10|6/14;1/6;20/6|Divide six by twenty and simplify.
Heads occurs 15 times in 30 tosses. Observed percent?|50%|15%;30%;100%|Fifteen is half of thirty.
Does 5 heads in a row force tails next?|No|Yes;Only with 10 trials;Only on a small coin|Past independent tosses do not force the next outcome.
What should a graph's vertical axis include?|Quantity and units|Only a colour;Only a date;Only the word graph|Units explain the measured values.
Red occurs 18 times in 60 trials. Observed probability?|3/10|1/18;18/42;3/5|Eighteen divided by sixty reduces to three tenths.
A line rises from 14 to 23 books. Increase?|9 books|37 books;8 books;10 books|Subtract fourteen from twenty-three.
Why might experimental and theoretical probabilities differ?|Trials vary by chance|One must be a counting error;Theory always equals every trial;Graphs change the bag|Finite trial results can vary without changing theoretical chance.
'''),
];
