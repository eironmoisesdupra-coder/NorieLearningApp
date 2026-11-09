import '../authored/core_math_unit.dart';
import '../authored/grade6_mathematics_core.dart';
import 'mathematics_authoring.dart';

final depedMath6 = <CoreMathUnit>[
  mathUnit(
      title: 'Fraction and Decimal Problem Solving',
      aims: [
        'Multiply and divide fractions using equal amounts.',
        'Compute decimal products and quotients.',
        'Choose operations from a measurement story.'
      ],
      idea:
          'Multiplying a fraction by a fraction can find part of a part: half of three quarters is three eighths. Dividing by a fraction asks how many groups of that size fit. Two divided by one quarter is eight quarter-size groups. Multiplying by the reciprocal gives the same count. Decimal multiplication uses place value: 1.2 × 0.3 = 0.36. For decimal division, multiply both numbers by the same power of ten so the divisor becomes whole.',
      model: {
        'Part of a part': '1/2 × 3/4 = 3/8',
        'Group count': '2 ÷ 1/4 = 8',
        'Scale both': '4.8 ÷ 0.6 = 48 ÷ 6 = 8',
        'Decimal product': '12 tenths × 3 tenths = 36 hundredths'
      },
      worked:
          'A 2 1/4 m ribbon is cut into 3/8 m pieces. Change 2 1/4 to 9/4. Compute 9/4 ÷ 3/8 = 9/4 × 8/3 = 6. Check six pieces of 3/8 m total 18/8 m = 2 1/4 m.',
      tryIt: 'Find 3/5 × 5/6. Then find 7.2 ÷ 0.9.',
      check:
          'Cancel the common five to get 3/6 = 1/2. Scale both decimals by ten: 72 ÷ 9 = 8.',
      avoid:
          'Dividing by a number smaller than one can make an answer larger. Do not shift only one decimal in division.',
      remember:
          'Keep amounts equal when renaming, select the operation from the story, and check by multiplication.',
      bank: '''
What is 2/3 × 3/4?|1/2|2/7;5/7;3/2|Six twelfths reduce to one half.
What is 3/5 ÷ 1/5?|3|3/25;1/3;5|Three fifth-size groups fit in three fifths.
What is 2 ÷ 2/3?|3|4/3;1/3;2/3|Two times three halves equals three.
What is 1 1/2 + 2 3/4?|4 1/4|3 1/4;4 3/4;3 3/4|One half is two quarters; the fraction total is five quarters.
What is 1.4 × 0.2?|0.28|2.8;28;0.028|Fourteen tenths times two tenths gives twenty-eight hundredths.
What is 6.3 ÷ 0.7?|9|0.9;90;4.41|Scale both by ten to divide 63 by 7.
What is 4.05 + 0.8?|4.85|4.13;4.75;4.058|Align decimal places and add 4.05 + 0.80.
What is 5 - 2.75?|2.25|3.25;2.75;7.75|Exchange through 5.00 before subtracting.
How many 3/4 L servings fit in 6 L?|8|4;6;9|Six times four thirds is eight.
A cloth costs ₱12.50 per metre. Cost for 2.4 m?|₱30|₱25;₱35;₱300|Multiply 12.5 by 2.4 to obtain thirty.
What is 3 1/3 - 1 5/6?|1 1/2|2 1/2;1 1/6;2 1/6|Rename as 3 2/6, exchange one whole, then subtract.
'''),
  grade6MathUnits[0],
  grade6MathUnits[1],
  grade6MathUnits[2],
  grade6MathUnits[3],
  mathUnit(
      title: 'Solids Nets and Surface Area',
      aims: [
        'Describe prisms, pyramids, cylinders, cones, and spheres.',
        'Match faces to a solid net.',
        'Calculate surface area from exposed faces.'
      ],
      idea:
          'A prism has two matching parallel bases. A pyramid has one base and triangular faces meeting at a point. A cylinder has two circular bases and a curved surface; a cone has one circular base and a curved surface. A sphere has only a curved surface. A net unfolds a solid surface. For a closed rectangular prism, two faces have area lw, two lh, and two wh. Its surface area is 2(lw + lh + wh).',
      model: {
        'Box dimensions': 'l = 5 cm, w = 3 cm, h = 2 cm',
        'Base pair': '2 × 5 × 3 = 30 cm²',
        'Side pairs': '2 × 5 × 2 + 2 × 3 × 2 = 32 cm²',
        'Total surface': '30 + 32 = 62 cm²'
      },
      worked:
          'Find the surface area of a closed cube of side 4 cm. Each face is a square with area sixteen square centimetres. There are six faces. Multiply 6 × 16 = 96 cm². Check all six faces are counted once.',
      tryIt:
          'Find the surface area of a closed 6 cm by 4 cm by 3 cm box. Which solid has one circular base and one pointed top?',
      check:
          'The face pairs give 2(24 + 18 + 12) = 108 cm². A cone has one circular base and a pointed top.',
      avoid:
          'Surface area uses square units; volume uses cubic units. An open box does not include a missing lid.',
      remember:
          'Unfold and label the faces before adding their areas. Count only surfaces that actually exist.',
      bank: '''
Which solid has six equal square faces?|Cube|Cone;Sphere;Cylinder|A cube has six congruent square faces.
Which solid has one base and triangular faces meeting at a point?|Pyramid|Prism;Sphere;Cylinder|Its side faces meet at the apex.
Which solid has two circular bases?|Cylinder|Cone;Sphere;Cube|The two circles are parallel and equal.
Which solid has no flat faces?|Sphere|Cube;Cylinder;Pyramid|A sphere has only a curved surface.
Area of one cube face when the side is 3 cm?|9 cm²|6 cm²;3 cm²;27 cm²|Square the side length.
Surface area of a closed cube of side 3 cm?|54 cm²|27 cm²;18 cm²;9 cm²|Six faces each have area nine.
Which unit fits surface area?|cm²|cm³;cm;kg|Surface area covers faces with squares.
What does a net show?|Unfolded surface faces|Only the inside volume;Only one edge;Only a point|Its connected faces can fold into a solid.
Surface area of a closed 4 by 3 by 2 cm prism?|52 cm²|24 cm²;26 cm²;48 cm²|Use 2(12 + 8 + 6).
A cube of side 5 cm has no top. Area of its five faces?|125 cm²|150 cm²;25 cm²;100 cm²|Five faces each cover twenty-five square centimetres.
A square pyramid has base side 6 cm and slant height 4 cm. Surface area?|84 cm²|60 cm²;96 cm²;144 cm²|Base area is 36 and four triangles each have area 12.
'''),
  mathUnit(
      title: 'Volume and Household Meter Readings',
      aims: [
        'Find volumes of cylinders, pyramids, cones, and spheres.',
        'Keep radius and height labels clear.',
        'Subtract meter readings to find consumption.'
      ],
      idea:
          'Volume counts cubic units inside a solid. A prism or cylinder has volume base area × perpendicular height. A pyramid or cone has one third the volume of a prism or cylinder with the same base area and height. A sphere has V = 4πr³/3. Water and electricity meters record running totals. Consumption over a period is the later reading minus the earlier reading; multiply usage by a stated unit price to estimate a simple bill.',
      model: {
        'Cylinder': 'V = πr²h',
        'Cone or pyramid': 'V = base area × h ÷ 3',
        'Sphere': 'V = 4πr³ ÷ 3',
        'Water meter': 'Later 246 m³ - earlier 231 m³ = 15 m³ used'
      },
      worked:
          'A cone has radius 3 cm and height 10 cm. Its matching cylinder holds π × 9 × 10 = 90π cm³. Take one third: 30π cm³, or 94.2 cm³ using π = 3.14. For readings 1250 and 1318 kWh, usage is 68 kWh.',
      tryIt:
          'A pyramid has base area 48 cm² and height 9 cm. Find volume. Water readings rise from 508 to 526 m³. Find usage.',
      check: '48 × 9 ÷ 3 = 144 cm³. Water usage is 526 - 508 = 18 m³.',
      avoid:
          'Use perpendicular height, not a sloping side. Meter readings are cumulative; the later reading is not itself the period usage.',
      remember:
          'Identify the solid, label dimensions, calculate in cubic units, and subtract cumulative meter readings.',
      bank: '''
Volume of a prism with base area 20 cm² and height 4 cm?|80 cm³|24 cm³;40 cm³;5 cm³|Multiply base area by height.
Volume of a pyramid with base area 30 cm² and height 6 cm?|60 cm³|180 cm³;36 cm³;90 cm³|Take one third of thirty times six.
Using π = 3.14, cylinder radius 2 cm and height 5 cm has volume what?|62.8 cm³|31.4 cm³;20 cm³;125.6 cm³|Use 3.14 × 4 × 5.
A cone has the same base and height as a 90 cm³ cylinder. Cone volume?|30 cm³|90 cm³;270 cm³;60 cm³|A cone occupies one third of the matching cylinder.
Which formula gives sphere volume?|4πr³/3|πr²;2πr;πr²h|A sphere uses the cube of its radius.
Water readings are 120 and 138 m³. Consumption?|18 m³|258 m³;138 m³;12 m³|Subtract the previous total from the new total.
Electric readings are 2080 and 2145 kWh. Consumption?|65 kWh|4225 kWh;55 kWh;2145 kWh|The difference measures usage during the period.
At ₱10 per kWh, 25 kWh costs what before other fees?|₱250|₱25;₱35;₱2500|Multiply twenty-five units by ten pesos each.
Using π = 22/7, cylinder radius 7 cm and height 3 cm volume?|462 cm³|154 cm³;132 cm³;147 cm³|Multiply 22/7 by 49 and by 3.
A sphere has radius 3 cm. Exact volume?|36π cm³|12π cm³;9π cm³;108π cm³|Use 4/3 × π × 27.
Readings rise from 742 to 761 m³. At ₱20 per m³, simple usage cost?|₱380|₱400;₱19;₱1503|Nineteen cubic metres at twenty pesos each cost 380.
'''),
  grade6MathUnits[4],
  mathUnit(
      title: 'Pie Graphs and Equally Likely Outcomes',
      aims: [
        'Relate circle sectors to fractions of a total.',
        'Count favourable and total outcomes.',
        'Distinguish theoretical chance from observed frequency.'
      ],
      idea:
          'A pie graph divides a full 360-degree circle into shares of a total. A quarter share uses ninety degrees. Label every category and state the total. For equally likely outcomes, theoretical probability is favourable outcomes divided by all outcomes. For a fair die, three of six faces are even, giving one half. Experimental probability instead uses actual recorded trials, which may differ from theory.',
      model: {
        'Class total': '40 learners',
        'Walkers': '20/40 = 50% = 180°',
        'Riders': '10/40 = 25% = 90°',
        'Other': '10/40 = 25% = 90°'
      },
      worked:
          'A bag contains 4 red and 6 blue equal counters. The total is ten. The chance of red is 4/10 = 2/5 = 40%. A pie sector for red is 40/100 × 360 = 144 degrees. Check the blue sector is 216 degrees and they total 360.',
      tryIt:
          'What is the chance of rolling a number greater than four on a fair six-face die? What angle represents 25% of a pie graph?',
      check:
          'The favourable faces are five and six: 2/6 = 1/3. A quarter of 360 degrees is ninety degrees.',
      avoid:
          'Count all outcomes in the denominator, not only the unfavourable ones. A whole pie represents one total, not several unrelated totals.',
      remember:
          'Fractions, percents, and sector angles describe the same shares. Probability counts favourable out of all equally likely outcomes.',
      bank: '''
How many degrees make a whole pie graph?|360|100;180;90|A full turn measures 360 degrees.
What angle represents half the data?|180°|90°;45°;360°|Half of 360 is 180.
What percent is one quarter of a pie?|25%|20%;40%;75%|One quarter is twenty-five out of a hundred.
Chance of heads on a fair coin?|1/2|1;0;1/3|One of two equally likely faces is heads.
Chance of an even number on a fair die labelled 1 to 6?|1/2|1/6;2/3;1|Faces two, four, and six are three of six.
A bag has 3 green and 7 red equal counters. Chance of green?|3/10|3/7;7/10;1/3|Three favourable counters out of ten total.
Chance of rolling 8 on a normal six-face die?|0|1;1/6;1/8|No face shows eight.
Chance of rolling less than 7 on a normal six-face die?|1|0;1/7;5/6|All six faces are favourable.
A category is 30% of 60 learners. How many learners?|18|20;30;12|Multiply sixty by three tenths.
What angle represents 20% of a pie graph?|72°|20°;36°;90°|One fifth of 360 is seventy-two.
In 50 trials, red occurs 22 times. Observed probability?|11/25|22/28;1/22;1/2|Use event count over all trials: 22/50.
'''),
];
