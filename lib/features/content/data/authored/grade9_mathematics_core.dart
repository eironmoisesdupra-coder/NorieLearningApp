import 'core_math_unit.dart';

const grade9MathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "Polynomials",
    objectives: [
      "Combine polynomial terms.",
      "Expand products by distribution.",
      "Identify degree from nonzero terms."
    ],
    focus:
        "Polynomials combine coefficient-weighted whole-number powers of variables.",
    explanation:
        "In 3x² − 2x + 5, the degree is two because the largest exponent is two. Like powers combine: 3x² + 4x² = 7x², while x² and x stay distinct. Multiply binomials by distributing each term to each term. For (2x + 3)(x − 4), the four products give 2x² − 8x + 3x − 12 = 2x² − 5x − 12. Addition does not multiply exponents.",
    model: {
      "(2x + 3)(x − 4)": "2x² − 5x − 12",
      "(x + 2)²": "x² + 4x + 4",
      "Degree of 3x² − 2x + 5": "Two"
    },
    worked:
        "Expand (x + 5)(x − 2). Step 1: x times both terms gives x² − 2x. Step 2: five times both gives 5x − 10. Step 3: combine to x² + 3x − 10. Step 4: at x = 2, both product and expanded form equal zero.",
    guided: "Subtract (2x² − x + 4) from (5x² + 3x − 1).",
    solution:
        "Distribute the minus sign: 5x² + 3x − 1 − 2x² + x − 4 = 3x² + 4x − 5.",
    mistakes:
        "The square of a sum includes cross terms. Subtracting a polynomial changes the sign of every term in the subtracted group.",
    recap:
        "Combine equal powers and distribute systematically, then verify with substitution.",
    questions: [
      "Degree of 3x² − 2x + 5?|2|3;5;1|The highest nonzero variable power is two.",
      "3x² + 4x² simplifies to what?|7x²|12x⁴;7x⁴;7x|Add coefficients of matching powers.",
      "(x + 2)² expands to what?|x² + 4x + 4|x² + 4;x² + 2x + 4;x² + 2|Both cross terms contribute two x.",
      "(2x + 3)(x − 4) equals what?|2x² − 5x − 12|2x² + 5x − 12;2x² − 8x + 3;2x² − 12|Four distributed products combine to negative five x.",
      "Which terms are like?|2x³ and −5x³|2x³ and 5x²;2x and 5y;2x² and 5|Variable powers must match.",
      "(x + 5)(x − 2) expands to what?|x² + 3x − 10|x² + 7x − 10;x² − 3x − 10;x² − 10|The middle terms are negative two x plus five x.",
      "What does subtracting a grouped polynomial require?|Reverse every grouped term sign|Reverse the first sign only;Delete constants;Square each term|A factor of negative one distributes throughout.",
      "At x = 2, x² + 3x − 10 equals what?|0|4;6;10|Four plus six minus ten equals zero.",
      "(5x² + 3x − 1) − (2x² − x + 4) equals what?|3x² + 4x − 5|3x² + 2x + 3;7x² + 2x + 3;3x² − 4x − 5|Subtract every term then combine matching powers.",
      "(x − 3)(x + 3) equals what?|x² − 9|x² + 9;x² − 6x + 9;x² + 6x + 9|Opposite middle products cancel.",
      "Degree of 4x³ + x² − 7?|3|4;2;7|The largest exponent is three."
    ],
  ),
  CoreMathUnit(
    title: "Quadratic Foundations",
    objectives: [
      "Connect a quadratic rule with a parabola.",
      "Find a vertex by completing a square.",
      "Identify zeros separately from the vertex."
    ],
    focus: "A quadratic has a squared variable term and a parabolic graph.",
    explanation:
        "The rule f(x) = x² − 4x + 3 rewrites as (x − 2)² − 1. Its vertex is (2, −1), the lowest point because the squared term is nonnegative. Its symmetry line is x = 2. Factoring as (x − 1)(x − 3) shows zeros at one and three. Zeros are x-values where output is zero, not the same as the vertex. A negative leading coefficient opens the parabola downward.",
    model: {
      "x² − 4x + 3": "(x − 2)² − 1",
      "Vertex": "(2, −1); symmetry x = 2",
      "Zeros": "x = 1 and x = 3"
    },
    worked:
        "Analyze y = x² − 6x + 8. Step 1: complete the square to (x − 3)² − 1. Step 2: vertex is (3, −1). Step 3: factor as (x − 2)(x − 4). Step 4: zeros two and four lie equally far from the symmetry line.",
    guided: "Find the vertex and opening direction of y = −(x + 1)² + 4.",
    solution:
        "The vertex is (−1, 4). The negative coefficient opens downward, making the vertex a maximum.",
    mistakes:
        "In (x − h)² + k, the vertex x-value is h, not negative h. Do not confuse output at zero with a graph zero.",
    recap:
        "Equivalent quadratic forms reveal vertex, symmetry, opening direction, and zeros.",
    questions: [
      "Vertex of y = (x − 2)² − 1?|(2, −1)|(−2, −1);(2, 1);(−1, 2)|The squared term is smallest at x two.",
      "Symmetry line of y = (x − 2)² − 1?|x = 2|y = 2;x = −2;y = −1|Points at equal distances from x two have equal outputs.",
      "Zeros of x² − 4x + 3?|1 and 3|2 and −1;−1 and −3;0 and 3|Factors x minus one and x minus three vanish.",
      "A positive squared-term coefficient opens a parabola which way?|Upward|Downward;Only left;Only right|The square grows positively away from the vertex.",
      "Does a zero necessarily equal the vertex x-value?|No|Yes;Only for all quadratics;Only if coefficients are integers|Zeros describe zero output, while the vertex is a turning point.",
      "x² − 6x + 8 completes to what?|(x − 3)² − 1|(x − 3)² + 1;(x + 3)² − 1;(x − 6)² + 8|Add and subtract nine to complete the square.",
      "Zeros of x² − 6x + 8?|2 and 4|3 and −1;−2 and −4;1 and 8|The factorization is x minus two times x minus four.",
      "For f(x) = x² − 4x + 3, f(0) is what?|3|0;1;−1|Substitution zero leaves the constant three.",
      "Vertex of y = −(x + 1)² + 4?|(−1, 4)|(1, 4);(−1, −4);(4, −1)|The square is zero at x negative one.",
      "Vertex of y = −(x + 1)² + 4 is which extremum?|Maximum|Minimum;Always zero;No turning point|Other values subtract a nonnegative square from four.",
      "For y = (x − 5)² + 2, minimum output is what?|2|5;−2;0|The squared term cannot be negative."
    ],
  ),
  CoreMathUnit(
    title: "Coordinate Geometry",
    objectives: [
      "Calculate midpoint and distance.",
      "Connect coordinate differences with a right triangle.",
      "Write a simple line equation."
    ],
    focus:
        "Coordinates allow geometric lengths and locations to be calculated.",
    explanation:
        "The midpoint averages matching coordinates: between (2, 3) and (8, 11), it is (5, 7). Distance uses the Pythagorean theorem on coordinate differences: √[(8 − 2)² + (11 − 3)²] = √100 = 10. Slope compares y-change with x-change. A line with slope two and y-intercept one has equation y = 2x + 1. A vertical line instead has form x = constant.",
    model: {
      "(2, 3) to (8, 11)": "Changes six and eight; distance ten.",
      "Midpoint": "((2 + 8)/2, (3 + 11)/2) = (5, 7)",
      "y = 2x + 1": "Slope two and y-intercept one."
    },
    worked:
        "Find distance between (−1, 2) and (2, 6). Step 1: x-change is three. Step 2: y-change is four. Step 3: sum squares nine and sixteen. Step 4: take √25 = 5.",
    guided:
        "Find midpoint of (−2, 4) and (6, 0). Write the vertical line through (3, 7).",
    solution:
        "Midpoint is (2, 2). The vertical line is x = 3 because every point has x-coordinate three.",
    mistakes:
        "Do not average x with y. Distance sums squared differences, not coordinates. A vertical line does not have finite slope.",
    recap:
        "Average corresponding coordinates for midpoint and use coordinate differences for distance and line direction.",
    questions: [
      "Midpoint of (2, 3) and (8, 11)?|(5, 7)|(6, 8);(10, 14);(3, 4)|Average the two x-values and two y-values.",
      "Distance between (2, 3) and (8, 11)?|10|14;2;100|Six and eight form legs with squared sum one hundred.",
      "Distance from (0, 0) to (3, 4)?|5|7;1;25|The positive root of nine plus sixteen is five.",
      "Equation of vertical line through (3, 7)?|x = 3|y = 3;y = 7x;x = 7|All points share x-coordinate three.",
      "Slope of y = 2x + 1?|2|1;3;0|The coefficient of x is the constant rate.",
      "Y-intercept of y = 2x + 1?|1|2;3;−1|At x zero the output is one.",
      "Why square coordinate differences for distance?|They form perpendicular leg squares|All coordinates must be positive;Midpoints need squares;Every line has slope one|The Pythagorean theorem combines horizontal and vertical changes.",
      "Midpoint of (−2, 4) and (6, 0)?|(2, 2)|(4, 4);(−4, 2);(2, 4)|Average negative two and six, then four and zero.",
      "Distance between (−1, 2) and (2, 6)?|5|7;1;25|The changes are three and four.",
      "Horizontal line through (2, 5) is what?|y = 5|x = 2;y = 2;x = 5|A horizontal line keeps y fixed.",
      "Slope through (1, 1) and (3, 5)?|2|4;1/2;3|Rise four divided by run two is two."
    ],
  ),
  CoreMathUnit(
    title: "Similarity & Congruence",
    objectives: [
      "Compare corresponding side ratios.",
      "Use congruence conditions carefully.",
      "Scale area differently from length."
    ],
    focus:
        "Similar shapes preserve angles and proportional lengths; congruent shapes preserve size too.",
    explanation:
        "Triangles with sides 3, 4, 5 and 6, 8, 10 are similar with scale factor two. Corresponding angles match, but the second is not congruent because its lengths doubled. Congruent triangles can be turned or reflected; location and orientation need not match. Side-side-side and side-angle-side with the included angle are congruence tests. Angle-angle-angle gives similarity but cannot fix size. A length factor k gives area factor k².",
    model: {
      "3, 4, 5 → 6, 8, 10": "All corresponding lengths double.",
      "Length factor 2": "Perimeter doubles; area multiplies by four.",
      "AAA": "Same shape possible at many sizes."
    },
    worked:
        "An enlarged triangle has sides 5, 7, 8 scaled by three. Step 1: identify common factor three. Step 2: multiply to obtain 15, 21, 24. Step 3: perimeter scales from twenty to sixty. Step 4: area scales by nine, not three.",
    guided:
        "If a figure has area twelve and is enlarged by length factor two, find new area. Can a reflected copy be congruent?",
    solution:
        "New area is forty-eight. Reflection preserves distances and angles, so a reflected copy can be congruent.",
    mistakes:
        "Match corresponding sides before forming ratios. Two sides and an unrelated angle do not establish SAS. Same angles alone do not prove same size.",
    recap:
        "Use matching lengths, angles, and justified tests; remember squared area scaling.",
    questions: [
      "Triangles 3, 4, 5 and 6, 8, 10 have scale factor what?|2|3;1/2;4|Each corresponding second side is twice the first.",
      "Are triangles with sides 3, 4, 5 and 6, 8, 10 congruent?|No|Yes, same shape proves same size;Only if turned;Only if reflected|Their corresponding lengths differ.",
      "AAA proves what for triangles?|Similarity, not necessarily congruence|Congruence always;Equal perimeter;Equal area|Angles fix shape but not scale.",
      "In SAS, which angle is required?|The included angle between known sides|Any angle;Only the largest;An exterior angle always|The known angle must join the two known sides.",
      "Length scale factor three gives area factor what?|9|3;6;1|Area multiplies by the square of the length factor.",
      "Can a reflected copy be congruent?|Yes|No;Only for circles;Only if its location stays fixed|Reflection preserves lengths and angles.",
      "Sides 5, 7, 8 enlarged by three become what?|15, 21, 24|8, 10, 11;10, 14, 16;25, 49, 64|Multiply every corresponding side by three.",
      "Perimeter twenty enlarged by factor three becomes what?|60|180;23;40|Perimeter is a length and scales by three.",
      "Area twelve enlarged by length factor two becomes what?|48|24;14;144|Area factor is four.",
      "Which condition proves triangle congruence?|Three matching corresponding side lengths|Only three matching angles;Only one matching side;Only matching area|SSS fixes the triangle size and shape.",
      "Similar triangles have corresponding angles how?|Equal|Multiplied by scale factor;Always ninety;Always sixty|Similarity preserves angle measures."
    ],
  ),
  CoreMathUnit(
    title: "Intro Statistics",
    objectives: [
      "Compare center and spread.",
      "Calculate quartiles under a stated convention.",
      "Limit conclusions from samples."
    ],
    focus: "A center alone does not describe how varied a data set is.",
    explanation:
        "The sets 2, 3, 4, 5, 6 and 0, 0, 4, 8, 8 both have mean four, but ranges four and eight. The second is more spread out by that measure. For seven ordered observations, this lesson excludes the middle observation when finding quartile medians. In 1, 2, 3, 4, 5, 6, 7, median is four, Q1 is two, Q3 is six, and interquartile range is four. Sample methods affect which population a conclusion can describe.",
    model: {
      "2, 3, 4, 5, 6": "Mean four; range four.",
      "0, 0, 4, 8, 8": "Mean four; range eight.",
      "1–7, exclude overall median": "Q1 two; Q3 six; IQR four."
    },
    worked:
        "Compare scores 4, 5, 6 and 1, 5, 9. Step 1: each mean is five. Step 2: first range is two. Step 3: second range is eight. Step 4: report equal centers but different spread.",
    guided:
        "For ordered data 2, 4, 6, 8, 10, 12, 14, find median and quartiles using the stated exclusion convention.",
    solution:
        "Median is eight. Lower-half median is four, upper-half median twelve, so interquartile range is eight.",
    mistakes:
        "Do not infer identical data from equal means. State the quartile convention. A convenience sample or a correlation alone does not establish a population-wide causal conclusion.",
    recap:
        "Report center, spread, and sampling limits together; state how summaries were calculated.",
    questions: [
      "Mean of 2, 3, 4, 5, 6?|4|3;5;20|Twenty divided by five gives four.",
      "Range of 0, 0, 4, 8, 8?|8|4;0;20|Largest eight minus smallest zero.",
      "Can equal means accompany different spread?|Yes|No;Only with negative numbers;Only with one observation|The two example sets share mean four but have different ranges.",
      "Median of 1, 2, 3, 4, 5, 6, 7?|4|3;5;7|The fourth value is central.",
      "For 1 through 7 excluding median, Q1 is what?|2|1;3;4|Median of the lower group one, two, three is two.",
      "For data 1, 2, 3, 4, 5, 6, 7 excluding overall median, Q3?|6|4;5;7|Median of five, six, seven is six.",
      "Interquartile range with Q1 two and Q3 six?|4|8;6;2|Subtract the lower quartile from the upper.",
      "Does correlation alone prove causation?|No|Yes;Only if numbers are large;Only if a graph is drawn|Other variables or coincidence can produce association.",
      "For 2, 4, 6, 8, 10, 12, 14, median?|8|6;10;14|The fourth ordered value is eight.",
      "For data 2, 4, 6, 8, 10, 12, 14 excluding overall median, IQR?|8|12;4;6|Quartiles are four and twelve.",
      "Which is more spread by range: 4, 5, 6 or 1, 5, 9?|1, 5, 9|4, 5, 6;Both have equal ranges;Neither has a range|Their ranges are eight and two."
    ],
  ),
];
