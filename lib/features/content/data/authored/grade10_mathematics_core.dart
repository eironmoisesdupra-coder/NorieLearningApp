import 'core_math_unit.dart';

const grade10MathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "Quadratic Equations",
    objectives: [
      "Solve using factors or the quadratic formula.",
      "Interpret the discriminant.",
      "Retain all real solutions."
    ],
    focus: "A quadratic equation may have two, one, or no real roots.",
    explanation:
        "For ax² + bx + c = 0 with a ≠ 0, the formula is x = (−b ± √(b² − 4ac))/(2a). The discriminant D = b² − 4ac determines real-root count: positive gives two, zero one repeated root, negative no real roots. Factoring x² − 5x + 6 gives (x − 2)(x − 3), hence roots two and three. The zero-product rule requires a product equal to zero.",
    model: {
      "x² − 5x + 6 = 0": "Roots two and three; D = 1.",
      "x² − 6x + 9 = 0": "Repeated root three; D = 0.",
      "x² + 4x + 5 = 0": "D = −4, so no real roots."
    },
    worked:
        "Solve x² − x − 6 = 0 by formula. Step 1: a = 1, b = −1, c = −6. Step 2: D = 1 + 24 = 25. Step 3: x = (1 ± 5)/2. Step 4: obtain three and negative two; both satisfy the equation.",
    guided: "Solve 2x² − 8 = 0 and classify the real roots of x² + 2x + 1 = 0.",
    solution:
        "The first reduces to x² = 4, so x = 2 or −2. The second is (x + 1)² = 0 with one repeated root −1.",
    mistakes:
        "The ± sign gives two candidates unless they coincide. Divide the entire numerator by 2a. Negative discriminant means no real roots, not no complex roots.",
    recap:
        "Choose a valid solving method and use the discriminant to classify real solutions.",
    questions: [
      "Roots of x² − 5x + 6 = 0?|2 and 3|−2 and −3;1 and 6;0 and 5|The factors x minus two and x minus three vanish.",
      "Discriminant of x² − 5x + 6?|1|25;24;49|Twenty-five minus twenty-four equals one.",
      "Positive discriminant gives how many distinct real roots?|2|1;0;Infinitely many|The square-root term is nonzero and real.",
      "Zero discriminant gives what?|One repeated real root|Two distinct roots;No real root;Every number|The plus and minus results coincide.",
      "Discriminant of x² + 4x + 5?|−4|4;36;16|Sixteen minus twenty equals negative four.",
      "Roots of x² − x − 6 = 0?|3 and −2|−3 and 2;1 and 6;−1 and −6|The formula gives one plus or minus five, divided by two.",
      "Why set the equation equal to zero before factoring to solve?|The zero-product property requires zero|Every expression is zero;It removes all roots;Only positive factors work|A nonzero product need not have a zero factor.",
      "Formula denominator for coefficient a is what?|2a|a;2;4ac|Both numerator branches divide by twice the leading coefficient.",
      "Roots of 2x² − 8 = 0?|2 and −2|4 and −4;2 only;−2 only|Both positive and negative two square to four.",
      "Root of x² + 2x + 1 = 0?|−1 repeated|1 repeated;−2;No real root|The expression is the square of x plus one.",
      "Roots of x² − 9 = 0?|3 and −3|9 and −9;3 only;−3 only|Both signs solve x squared equals nine."
    ],
  ),
  CoreMathUnit(
    title: "Functions & Graphs",
    objectives: [
      "Identify real-valued domain restrictions.",
      "Read intercepts and transformations.",
      "Distinguish a vertical asymptote from a permitted input."
    ],
    focus: "Function rules and graph features must agree on allowed inputs.",
    explanation:
        "For f(x) = 1/(x − 2), x = 2 is excluded because division by zero is undefined; x = 2 is a vertical asymptote. For √(x + 3) over real numbers, require x + 3 ≥ 0, giving x ≥ −3. The graph y = (x − 2)² + 3 shifts y = x² two units right and three up. For y = −2x + 6, the y-intercept is six and the x-intercept is three. Intercepts are found by setting the other coordinate to zero.",
    model: {
      "1/(x − 2)": "Domain excludes two; vertical asymptote x = 2.",
      "√(x + 3)": "Real domain x ≥ −3.",
      "(x − 2)² + 3": "Vertex (2, 3)."
    },
    worked:
        "Find intercepts of y = 3x − 9. Step 1: set x = 0 to get y = −9. Step 2: y-intercept is (0, −9). Step 3: set y = 0 and solve 3x = 9. Step 4: x-intercept is (3, 0).",
    guided: "State the domain of 1/(x + 4) and the vertex of (x + 1)² − 5.",
    solution:
        "The rational rule excludes x = −4. The quadratic vertex is (−1, −5).",
    mistakes:
        "A graph does not fill excluded inputs automatically. Horizontal shifts use the value that makes the grouped expression zero, so x + 1 shifts left.",
    recap:
        "Check algebraic restrictions and connect shifts, intercepts, and asymptotes to the rule.",
    questions: [
      "Which input is excluded from 1/(x − 2)?|2|−2;0;1|At two the denominator is zero.",
      "Real domain of √(x + 3)?|x ≥ −3|x ≥ 3;All real x;x < −3|The quantity under a real square root must be nonnegative.",
      "Vertex of (x − 2)² + 3?|(2, 3)|(−2, 3);(2, −3);(3, 2)|The square is zero at x two.",
      "Y-intercept of y = −2x + 6?|6|−2;3;−3|At x zero the output is six.",
      "X-intercept of y = −2x + 6?|3|6;−3;2|Set output zero and solve.",
      "Vertical asymptote of 1/(x − 2)?|x = 2|y = 2;x = −2;y = −2|The denominator vanishes at x two.",
      "Vertex of (x + 1)² − 5?|(−1, −5)|(1, −5);(−1, 5);(5, 1)|The group vanishes at x negative one.",
      "Why is x = 2 not a value of 1/(x − 2)?|Division by zero is undefined|The output is automatically zero;The output is automatically two;All positive inputs are forbidden|A vertical asymptote does not assign a finite value.",
      "Excluded input of 1/(x + 4)?|−4|4;0;−1|Negative four makes the denominator zero.",
      "X-intercept of y = 3x − 9?|3|−9;9;−3|Set y zero and divide nine by three.",
      "Real domain of √(x − 5)?|x ≥ 5|x ≥ −5;All real x;x < 5|The radicand must be nonnegative."
    ],
  ),
  CoreMathUnit(
    title: "Trigonometry Basics",
    objectives: [
      "Identify sides relative to an acute angle.",
      "Use sine, cosine, and tangent ratios.",
      "Apply a ratio to find a side."
    ],
    focus:
        "Right-triangle trigonometry compares sides relative to a chosen angle.",
    explanation:
        "For acute angle θ in a right triangle, sin θ = opposite/hypotenuse, cos θ = adjacent/hypotenuse, and tan θ = opposite/adjacent. The adjacent leg is not the hypotenuse. With opposite three, adjacent four, and hypotenuse five, the ratios are 3/5, 4/5, and 3/4. Changing the chosen acute angle swaps the opposite and adjacent legs. This lesson gives angles in degrees; calculator mode must match.",
    model: {
      "Opposite 3, adjacent 4, hypotenuse 5":
          "sin θ = 3/5; cos θ = 4/5; tan θ = 3/4",
      "sin 30° = 1/2": "Opposite is half the hypotenuse.",
      "tan 45° = 1": "The two legs are equal."
    },
    worked:
        "Find opposite side when θ = 30° and hypotenuse ten. Step 1: choose sine. Step 2: 1/2 = opposite/10. Step 3: multiply by ten to get five. Step 4: check the opposite is smaller than the hypotenuse.",
    guided:
        "For opposite six and adjacent eight, find tangent. With angle thirty degrees and hypotenuse fourteen, find the opposite side.",
    solution:
        "Tangent is 6/8 = 3/4. The second opposite side is seven because sine thirty degrees equals one half.",
    mistakes:
        "Choose the angle before naming opposite and adjacent. Do not use a slanted leg as hypotenuse unless it is opposite the right angle. Degrees and radians are different input units.",
    recap:
        "Identify sides relative to the chosen angle, select the matching ratio, and check units and size.",
    questions: [
      "For opposite 3 and hypotenuse 5, sine is what?|3/5|5/3;4/5;3/4|Sine divides opposite by hypotenuse.",
      "For adjacent 4 and hypotenuse 5, cosine is what?|4/5|5/4;3/5;4/3|Cosine divides adjacent leg by hypotenuse.",
      "For opposite 3 and adjacent 4, tangent is what?|3/4|4/3;3/5;4/5|Tangent compares the two legs.",
      "Which side is always hypotenuse?|Opposite the right angle|Opposite any selected angle;The horizontal side;The shortest leg|The hypotenuse is the right-triangle longest side.",
      "Sin 30° equals what?|1/2|1;0;√3/2|The opposite leg is half the hypotenuse.",
      "Tan 45° equals what?|1|0;1/2;√3|The two legs are equal.",
      "Angle 30°, hypotenuse ten. Opposite length?|5|10;20;√3|Multiply the sine ratio one half by ten.",
      "Why set calculator mode to degrees for a 30° input?|Angle units must match|Degrees and radians are identical;It changes triangle size;It removes the hypotenuse|A different unit gives a different interpreted angle.",
      "Opposite six, adjacent eight. Tangent?|3/4|4/3;3/5;4/5|Six eighths simplifies to three fourths.",
      "Angle 30°, hypotenuse fourteen. Opposite length?|7|14;28;6|One half of fourteen is seven.",
      "Can sine of an acute right-triangle angle exceed one?|No|Yes, always;Only if legs are long;Only in degrees|Opposite leg is shorter than hypotenuse."
    ],
  ),
  CoreMathUnit(
    title: "Circles",
    objectives: [
      "Distinguish radius and diameter.",
      "Calculate circumference and area.",
      "Relate central and inscribed angles on one arc."
    ],
    focus:
        "Circle length, area, and angles describe different geometric quantities.",
    explanation:
        "A radius joins center to circumference; a diameter passes through the center and is twice the radius. Circumference is 2πr and area is πr². With radius three, circumference is 6π and area 9π. A central angle has its vertex at the center. An inscribed angle with the same intercepted arc has half the central angle measure. The stated same-arc condition matters.",
    model: {
      "Radius 3, diameter 6": "Circumference 6π; area 9π.",
      "Central angle 100°": "Same-arc inscribed angle 50°.",
      "Diameter endpoints":
          "An inscribed angle intercepting the semicircle is 90°."
    },
    worked:
        "Use diameter ten. Step 1: radius is five. Step 2: circumference is 2π × 5 = 10π. Step 3: area is π × 25 = 25π. Step 4: attach length units to circumference and square units to area.",
    guided:
        "For radius four, find circumference and area. Find a same-arc inscribed angle for central angle eighty degrees.",
    solution:
        "Circumference is 8π units, area 16π square units, and the inscribed angle is forty degrees.",
    mistakes:
        "Do not use diameter as radius in πr². Circumference is not area. Angle halving applies only when both angles intercept the same arc.",
    recap:
        "Choose radius, apply the proper formula and units, and track the intercepted arc.",
    questions: [
      "Radius three gives diameter what?|6|3;9;1.5|A diameter contains two radii.",
      "Radius three gives circumference what?|6π|3π;9π;12π|Use twice pi times radius.",
      "Radius three gives area what?|9π|6π;3π;18π|Square the radius in the area formula.",
      "Diameter ten gives radius what?|5|10;20;2|Radius is half the diameter.",
      "Diameter ten gives area what?|25π|100π;10π;50π|Use radius five, then square it.",
      "Central angle 100°, same arc inscribed angle what?|50°|100°;200°;25°|The inscribed angle is half the central measure.",
      "Which unit fits circle area?|Square units|Length units only;Degrees;Seconds|Area measures a two-dimensional region.",
      "Inscribed angle intercepting a diameter measures what?|90°|180°;45°;360°|Its central angle is 180 degrees.",
      "Radius four gives circumference what?|8π|16π;4π;32π|Multiply radius by two pi.",
      "Radius four gives area what?|16π|8π;4π;32π|Four squared times pi is sixteen pi.",
      "Central angle eighty, same arc inscribed angle what?|40°|80°;160°;20°|Halve the central angle measure."
    ],
  ),
  CoreMathUnit(
    title: "Probability & Combinatorics",
    objectives: [
      "Distinguish ordered selections from unordered ones.",
      "Calculate small permutations and combinations.",
      "State probability assumptions."
    ],
    focus: "Counting rules must match whether order and repetition matter.",
    explanation:
        "Choosing two different letters in order from A, B, C gives 3 × 2 = 6 codes. Selecting two letters without order gives three pairs: AB, AC, BC. Each unordered pair was counted twice in the ordered list, so divide by 2!. In general nPr = n!/(n − r)! and nCr = n!/[r!(n − r)!]. For equally likely outcomes, probability is favorable divided by total. Sampling without replacement changes later available choices.",
    model: {
      "Ordered two from three": "AB, AC, BA, BC, CA, CB: six",
      "Unordered two from three": "AB, AC, BC: three",
      "Two fair coin tosses": "HH, HT, TH, TT: four equally likely outcomes"
    },
    worked:
        "Choose two representatives from five people without order. Step 1: ordered choices total 5 × 4 = 20. Step 2: each pair appears twice. Step 3: divide by two to get ten pairs. Step 4: check by systematic listing rather than treating order as a new team.",
    guided:
        "Count three-letter codes without repetition from four letters. For two independent fair coin tosses, find probability of exactly one head.",
    solution:
        "The code count is 4 × 3 × 2 = 24. Exactly one head occurs in HT or TH, so probability is 2/4 = 1/2.",
    mistakes:
        "Do not use permutations for an unordered committee. Independent fair tosses justify equally likely paths; arbitrary outcomes need not share probability.",
    recap:
        "Specify order, repetition, and likelihood before choosing a count or probability formula.",
    questions: [
      "Ordered two different letters from three gives how many?|6|3;9;2|Three first choices and two second choices.",
      "Unordered pairs from three distinct letters gives how many?|3|6;9;2|Each ordered pair has its reversed duplicate.",
      "Unordered pairs of people from five gives how many?|10|20;5;25|Divide five times four by two.",
      "Three-letter codes without repetition from four letters gives what count?|24|64;12;4|Choices decrease four, three, then two.",
      "Two independent fair coin tosses give how many paths?|4|2;3;8|Each of two stages has two possibilities.",
      "Exactly one head in two independent fair coin tosses has probability what?|1/2|1/4;3/4;1|HT and TH are two of four paths.",
      "Which selection makes order matter?|A first-place and second-place award|An unordered two-person committee;A set of two books;Two names listed alphabetically as a group|Swapping award recipients changes the outcome.",
      "Without replacement, why does a later choice count fall?|A selected item is no longer available|Every probability becomes zero;Order stops mattering;The original set grows|The chosen item is removed.",
      "Choose two people from six without order. Count?|15|30;12;36|Six times five divided by two is fifteen.",
      "Two letters with repetition from three letters gives how many?|9|6;3;12|Both stages retain three choices.",
      "Can favorable-count divided by total-count be used directly for biased unequal outcomes?|No|Yes;Only if the total is even;Only if outcomes have names|Count ratios assume equal likelihood."
    ],
  ),
];
