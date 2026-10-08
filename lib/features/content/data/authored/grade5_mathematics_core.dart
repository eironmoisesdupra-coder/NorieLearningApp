import 'core_math_unit.dart';

const grade5MathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "Fraction Operations",
    objectives: [
      "Add and subtract using common-sized parts.",
      "Multiply a fraction by a whole number.",
      "Interpret division by a unit fraction."
    ],
    focus: "Fraction operations must keep the whole and part sizes clear.",
    explanation:
        "Add 3/4 and 1/6 by changing both to twelfths: 9/12 + 2/12 = 11/12. Add numerators only after part sizes match. Subtraction uses the same principle. Multiplying 2/3 by three joins three copies, making six thirds or two wholes. Dividing three by 1/2 asks how many halves fit into three wholes: six. Dividing 3/4 among three equal shares instead gives 1/4 per share.",
    model: {
      "3/4 + 1/6": "9/12 + 2/12 = 11/12",
      "3 × 2/3": "6/3 = 2",
      "3 ÷ 1/2": "Six half-sized groups fit."
    },
    worked:
        "Find 5/6 − 1/4. Step 1: choose twelfths. Step 2: rewrite as 10/12 − 3/12. Step 3: subtract to get 7/12. Step 4: check 7/12 + 3/12 = 10/12.",
    guided:
        "Find 2/5 + 1/10 and explain how many quarters fit into two wholes.",
    solution:
        "Four tenths plus one tenth gives 5/10 = 1/2. Eight quarter-sized groups fit into two wholes.",
    mistakes:
        "Do not add denominators. A quotient asks either group count or share size; identify which. A unit-fraction divisor can produce a larger numerical answer.",
    recap:
        "Match part sizes before adding or subtracting and interpret multiplication or division in context.",
    questions: [
      "3/4 + 1/6 equals what?|11/12|4/10;1/2;5/12|Use nine twelfths plus two twelfths.",
      "5/6 − 1/4 equals what?|7/12|4/2;1/2;9/12|Ten twelfths minus three twelfths leaves seven.",
      "3 × 2/3 equals what?|2|2/9;3;5/3|Three copies give six thirds.",
      "3 ÷ 1/2 equals what?|6|3/2;2;4|Six halves fill three wholes.",
      "3/4 shared into three equal portions gives what per portion?|1/4|9/4;1;3/7|Divide the three quarter-parts among three shares.",
      "Why use a common denominator for addition?|It makes the parts the same size|It makes all numerators one;It changes the whole;It removes the sum|Numerators can be combined when their units match.",
      "1/3 + 1/3 equals what?|2/3|2/6;1/6;1|Two equal thirds make two thirds.",
      "How many quarters fit into one whole?|4|2;1/4;3|Four quarter-sized parts fill one whole.",
      "2/5 + 1/10 equals what?|1/2|3/15;3/10;4/5|Four tenths plus one tenth is five tenths.",
      "2 ÷ 1/4 equals what?|8|1/2;6;4|Each whole contains four quarters.",
      "7/8 − 1/4 equals what?|5/8|6/4;3/8;1/2|Rewrite one fourth as two eighths before subtracting."
    ],
  ),
  CoreMathUnit(
    title: "Decimal Operations",
    objectives: [
      "Align decimals for sums and differences.",
      "Track place value in products.",
      "Scale both terms of a division equally."
    ],
    focus:
        "Decimal operations follow place value rather than digit appearance.",
    explanation:
        "For addition and subtraction, align decimal points so like places combine. Multiplication can be understood with fractional units: 1.2 × 0.3 = (12/10)(3/10) = 36/100 = 0.36. Estimate first to check size. For division, 2.4 ÷ 0.6 = 24 ÷ 6 because multiplying both dividend and divisor by ten preserves the quotient. Scaling only one changes the result.",
    model: {
      "3.75 + 0.8": "3.75 + 0.80 = 4.55",
      "1.2 × 0.3": "36 hundredths = 0.36",
      "2.4 ÷ 0.6": "24 ÷ 6 = 4"
    },
    worked:
        "Compute 5.20 − 1.85. Step 1: align hundredths. Step 2: regroup one tenth to subtract five hundredths. Step 3: regroup a whole to subtract eight tenths. Step 4: report 3.35 and check 3.35 + 1.85 = 5.20.",
    guided: "Find 0.4 × 0.7 and 4.2 ÷ 0.7. Explain the unit scaling.",
    solution:
        "Four tenths times seven tenths is twenty-eight hundredths, 0.28. Scale the division by ten to obtain 42 ÷ 7 = 6.",
    mistakes:
        "Do not align only the last digits for addition. A product of two positive decimals below one is smaller than either. Scale both division quantities equally.",
    recap:
        "Estimation and fractional place value explain decimal operations and catch misplaced decimal points.",
    questions: [
      "3.75 + 0.8 equals what?|4.55|3.83;4.35;11.75|Write eight tenths as eighty hundredths.",
      "1.2 × 0.3 equals what?|0.36|3.6;0.036;1.5|Twelve tenths times three tenths gives thirty-six hundredths.",
      "2.4 ÷ 0.6 equals what?|4|0.4;40;3|Scale both quantities by ten to divide twenty-four by six.",
      "5.20 − 1.85 equals what?|3.35|4.65;3.45;7.05|Regroup while keeping hundredths aligned.",
      "0.5 × 0.5 equals what?|0.25|1;0.5;2.5|Half of one half is one quarter.",
      "Which preserves 4.2 ÷ 0.7?|42 ÷ 7|42 ÷ 0.7;4.2 ÷ 7;4.9 ÷ 7|Multiply both terms by ten.",
      "What aligns in decimal subtraction?|Matching places and decimal points|Only last digits;Only highest digits;Any digits|Tenths and hundredths must subtract like-sized parts.",
      "6.3 + 0.07 equals what?|6.37|6.10;6.307;7.0|Seven hundredths adds to six and three tenths.",
      "0.4 × 0.7 equals what?|0.28|2.8;0.028;1.1|Four tenths of seven tenths is twenty-eight hundredths.",
      "4.2 ÷ 0.7 equals what?|6|0.6;60;3.5|Forty-two divided by seven gives six.",
      "Two lengths of 1.25 m total what?|2.5 m|1.5 m;2.25 m;0.625 m|Join two equal one-and-a-quarter-meter lengths."
    ],
  ),
  CoreMathUnit(
    title: "Volume",
    objectives: [
      "Count unit cubes.",
      "Find rectangular-prism volume.",
      "Distinguish cubic units from area units."
    ],
    focus: "Volume measures the three-dimensional space an object occupies.",
    explanation:
        "A rectangular box four centimeters long, three wide, and two high contains two layers of twelve one-centimeter cubes. Its volume is 4 × 3 × 2 = 24 cm³. Length times width finds one layer area; height counts layers. Cubic centimeters measure three dimensions, unlike square centimeters. Changing one dimension changes volume proportionally when the others stay fixed. The outside surface area answers a different question.",
    model: {
      "One layer: 4 × 3": "Twelve unit cubes in each layer.",
      "Two layers": "12 + 12 = 24 cm³",
      "Doubling height only":
          "Doubles volume, not necessarily every surface area."
    },
    worked:
        "Find a five-by-two-by-three box volume. Step 1: choose one unit cube. Step 2: one layer has 5 × 2 = 10 cubes. Step 3: three layers contain thirty. Step 4: write 30 cubic units.",
    guided:
        "A box measures six by four by two centimeters. Find volume and predict volume if only height doubles.",
    solution:
        "The volume is 6 × 4 × 2 = 48 cm³. Doubling height doubles it to 96 cm³.",
    mistakes:
        "Do not add dimensions for volume or stop after finding one layer area. Use consistent length units before multiplying.",
    recap:
        "Rectangular-prism volume is length times width times height, counted in cubic units.",
    questions: [
      "A 4 cm by 3 cm by 2 cm box has volume what?|24 cm³|9 cm³;12 cm³;18 cm³|Two layers of twelve unit cubes total twenty-four.",
      "One 4 by 3 layer contains how many unit cubes?|12|7;24;3|Multiply the two layer dimensions.",
      "Which unit measures volume?|Cubic centimeters|Square centimeters;Centimeters only;Degrees|Volume counts three-dimensional unit cubes.",
      "A five-by-two-by-three box has volume what?|30 cubic units|10 cubic units;25 cubic units;15 cubic units|Ten cubes per layer times three layers.",
      "Doubling only height with base fixed does what?|Doubles volume|Quadruples volume;Leaves volume unchanged;Halves volume|The number of equal layers doubles.",
      "A cube of side three has volume what?|27 cubic units|9 cubic units;18 cubic units;3 cubic units|Multiply three by three by three.",
      "Does length times width alone give box volume?|No, it gives base area|Yes, always;Only if color matches;It gives perimeter|A third dimension is needed for volume.",
      "Why convert centimeters and meters before multiplying?|Dimensions must use matching units|Units do not matter;Every meter equals one centimeter;Conversion removes height|A consistent unit produces a meaningful cubic unit.",
      "A six-by-four-by-two box has volume what?|48 cubic units|12 cubic units;24 cubic units;96 cubic units|Multiply all three dimensions.",
      "A 6-by-4-by-2 box height doubles to four. New volume?|96 cubic units|48 cubic units;192 cubic units;24 cubic units|The original forty-eight doubles.",
      "A box volume is twenty-four with base area six. Height?|4 units|18 units;30 units;6 units|Divide volume by base area."
    ],
  ),
  CoreMathUnit(
    title: "Coordinate Plane",
    objectives: [
      "Read ordered pairs.",
      "Plot points in the first quadrant.",
      "Find horizontal and vertical distances."
    ],
    focus:
        "An ordered pair gives a position using two perpendicular number lines.",
    explanation:
        "The origin is (0, 0). In (3, 5), move three units along the horizontal x-axis, then five upward parallel to the y-axis. Order matters: (5, 3) is a different point. This lesson uses nonnegative first-quadrant positions. Points on the x-axis have y = 0; points on the y-axis have x = 0. For points sharing y, horizontal distance is the difference between x-values; for points sharing x, use y-values.",
    model: {
      "(3, 5)": "Three right, then five up from the origin.",
      "(5, 3)": "Five right, then three up: a different position.",
      "(2, 4) to (7, 4)": "Horizontal distance five units."
    },
    worked:
        "Locate (6, 2). Step 1: start at the origin. Step 2: move six right. Step 3: move two up. Step 4: check the x-coordinate is six and y-coordinate two.",
    guided:
        "Find the distance from (3, 1) to (3, 7). Explain which coordinate stays fixed.",
    solution:
        "The x-coordinate remains three, so movement is vertical. Distance is 7 − 1 = 6 units.",
    mistakes:
        "Do not reverse coordinate order or start at an arbitrary point. Distance is a nonnegative amount, not a signed coordinate.",
    recap:
        "Read x first and y second; use shared-coordinate differences for axis-aligned distances.",
    questions: [
      "In (3, 5), the x-coordinate is what?|3|5;8;0|The first number gives horizontal position.",
      "Where is the origin?|(0, 0)|(1, 1);(0, 1);(1, 0)|Both coordinate axes start together at zero.",
      "Which point lies on the x-axis?|(4, 0)|(0, 4);(4, 4);(1, 4)|An x-axis point has zero y-coordinate.",
      "Which lies on the y-axis?|(0, 6)|(6, 0);(6, 6);(1, 6)|A y-axis point has zero x-coordinate.",
      "Are (3, 5) and (5, 3) the same point?|No|Yes, order never matters;Only if both are positive;Only on any graph|Swapping coordinates changes the position.",
      "Distance from (2, 4) to (7, 4)?|5 units|9 units;3 units;4 units|They share y, so subtract x-values.",
      "From the origin, six right and two up gives what?|(6, 2)|(2, 6);(8, 0);(0, 8)|Record horizontal movement first.",
      "What stays fixed in a vertical move?|The x-coordinate|The y-coordinate always;Both coordinates;Neither coordinate|Vertical movement changes only y.",
      "Distance from (3, 1) to (3, 7)?|6 units|8 units;4 units;3 units|They share x, so subtract y-values.",
      "Which point is four right and eight up?|(4, 8)|(8, 4);(12, 0);(0, 12)|The ordered pair is horizontal then vertical.",
      "Distance from (1, 2) to (6, 2)?|5 units|7 units;4 units;6 units|The shared y makes this a horizontal distance."
    ],
  ),
  CoreMathUnit(
    title: "Numerical Expressions",
    objectives: [
      "Use grouping symbols.",
      "Apply operation order.",
      "Translate a verbal calculation into an expression."
    ],
    focus: "An expression records a calculation; an equation asserts equality.",
    explanation:
        "In 3 + 4 × 2, multiplication happens before addition, giving 3 + 8 = 11. Parentheses change the intended grouping: (3 + 4) × 2 = 14. After grouping, handle multiplication and division left to right, then addition and subtraction left to right. Equal-priority operations do not mean multiplication always precedes division. An expression has no equality claim by itself.",
    model: {
      "3 + 4 × 2": "3 + 8 = 11",
      "(3 + 4) × 2": "7 × 2 = 14",
      "12 ÷ 3 × 2": "4 × 2 = 8"
    },
    worked:
        "Evaluate 20 − (3 + 2) × 2. Step 1: add inside parentheses to get five. Step 2: multiply five by two. Step 3: subtract ten from twenty. Step 4: the value is ten.",
    guided:
        "Translate twice the sum of five and three, then evaluate. Explain why 2 × 5 + 3 differs.",
    solution:
        "Twice the sum is 2 × (5 + 3) = 16. Without parentheses, 2 × 5 + 3 = 13.",
    mistakes:
        "Do not read every expression only left to right regardless of priority. Parentheses are mathematical instructions, not decoration.",
    recap:
        "Grouping and operation priority determine the value; write an expression that matches the intended calculation.",
    questions: [
      "3 + 4 × 2 equals what?|11|14;10;9|Multiply four by two before adding three.",
      "(3 + 4) × 2 equals what?|14|11;9;10|Add the grouped sum first.",
      "12 ÷ 3 × 2 equals what?|8|2;12;18|Division and multiplication proceed left to right.",
      "20 − (3 + 2) × 2 equals what?|10|30;15;34|Group five, multiply to ten, then subtract.",
      "Which means twice the sum of five and three?|2 × (5 + 3)|2 × 5 + 3;5 + 3 + 2;5 × 3 × 2|The entire sum is multiplied by two.",
      "Which is an expression rather than an equation?|7 + 2|7 + 2 = 9;7 = 7;9 = 7 + 2|An expression does not assert equality.",
      "18 − 6 − 3 equals what?|9|15;3;27|Equal-priority subtraction is evaluated left to right.",
      "Which step comes first in 8 × (2 + 1)?|Add two and one|Multiply eight and two;Add eight and one;Subtract one|Grouping symbols select the inner calculation first.",
      "2 × (5 + 3) equals what?|16|13;20;10|The grouped sum eight is doubled.",
      "24 ÷ 4 + 2 equals what?|8|4;12;6|Divide first, then add two.",
      "Which represents subtract four from the product of three and six?|3 × 6 − 4|3 × (6 − 4);4 − 3 × 6;3 + 6 − 4|First form the product, then subtract four."
    ],
  ),
];
