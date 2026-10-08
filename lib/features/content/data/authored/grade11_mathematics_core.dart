import 'core_math_unit.dart';

const grade11MathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "Advanced Algebra",
    objectives: [
      "Simplify rational expressions with retained restrictions.",
      "Use logarithms as inverse exponents.",
      "Solve an exponential or rational equation."
    ],
    focus: "Algebraic transformations must preserve the permitted input set.",
    explanation:
        "The expression (x² − 9)/(x − 3) factors to (x − 3)(x + 3)/(x − 3), so it equals x + 3 only for x ≠ 3. Cancellation does not restore the excluded input. A logarithm answers an exponent question: log₂8 = 3 because 2³ = 8. For real logarithms, the base is positive and not one, and the argument is positive. Logarithm product laws require positive arguments.",
    model: {
      "(x² − 9)/(x − 3)": "x + 3 with x ≠ 3 retained.",
      "log₂8 = 3": "Two to power three is eight.",
      "1/(x − 1) = 2": "x = 3/2, with x ≠ 1."
    },
    worked:
        "Solve 2ˣ = 16. Step 1: write sixteen as 2⁴. Step 2: compare powers of the same valid base. Step 3: x = 4. Step 4: substitute to verify 2⁴ = 16.",
    guided: "Find the real domain of log₂(x − 1), and solve 1/(x − 1) = 2.",
    solution:
        "Require x − 1 > 0, so the logarithm domain is x > 1. The rational equation gives one = 2(x − 1), hence x = 3/2.",
    mistakes:
        "Do not cancel across addition without factoring. Keep original denominator restrictions. Logarithms do not accept zero or negative real arguments.",
    recap:
        "Use factoring and inverse operations while preserving every domain restriction.",
    questions: [
      "(x² − 9)/(x − 3) simplifies to what where defined?|x + 3|x − 3;x² + 3;1|Factor the difference of squares before cancellation.",
      "Which input is excluded from (x² − 9)/(x − 3)?|3|−3;0;1|The original denominator vanishes at three.",
      "log₂8 equals what?|3|4;2;8|Two cubed equals eight.",
      "2ˣ = 16 gives x what?|4|8;2;16|Sixteen is two to the fourth power.",
      "Real domain of log₂(x − 1)?|x > 1|x ≥ 1;All real x;x < 1|The logarithm argument must be positive.",
      "1/(x − 1) = 2 gives x what?|3/2|1;2;1/2|Multiply by the nonzero denominator and solve.",
      "For real logs, can the base be one?|No|Yes;Only for positive arguments;Only for integers|One to every power cannot invert distinct positive inputs.",
      "For positive x, log₂(4x) equals what?|2 + log₂x|4 + log₂x;4log₂x;log₂4 + x|The product law adds logarithms, with log₂4 equal two.",
      "Solve 3ˣ = 27.|3|9;2;27|Twenty-seven is three cubed.",
      "Excluded inputs of 1/(x² − 4)?|2 and −2|2 only;−2 only;0 only|Both values make the factored denominator zero.",
      "log₁₀100 equals what?|2|10;100;0|Ten squared equals one hundred."
    ],
  ),
  CoreMathUnit(
    title: "Sequences & Series",
    objectives: [
      "Distinguish terms from sums.",
      "Use arithmetic and geometric patterns.",
      "Apply finite or infinite geometric sums with restrictions."
    ],
    focus: "A sequence lists terms; a series adds them.",
    explanation:
        "Arithmetic terms change by a fixed difference, while geometric terms multiply by a fixed ratio. For 2, 6, 18, the ratio is three and aₙ = 2 × 3ⁿ⁻¹. Its first four terms sum to eighty. A finite geometric sum with r ≠ 1 is a₁(1 − rⁿ)/(1 − r). An infinite geometric sum is a₁/(1 − r) only when the absolute value of r is less than one; otherwise nonzero terms do not yield that convergence.",
    model: {
      "2, 6, 18, 54": "Ratio three; sum eighty.",
      "2, 5, 8, 11, 14": "Difference three; sum forty.",
      "1 + 1/2 + 1/4 + ...": "Ratio one half; infinite sum two."
    },
    worked:
        "Sum first three terms starting at five with ratio two. Step 1: list five, ten, twenty. Step 2: add to thirty-five. Step 3: formula gives 5(1 − 2³)/(1 − 2). Step 4: both methods give thirty-five.",
    guided:
        "Find the fourth term and first-four-term sum for 3, 6, 12, ... . Does the infinite series converge?",
    solution:
        "The fourth term is twenty-four; the sum is forty-five. Ratio two has absolute value above one, so the infinite series does not converge.",
    mistakes:
        "Do not confuse the final term with total sum. A finite geometric sum is valid for growing ratios, but the infinite-sum formula needs a ratio with absolute value below one.",
    recap:
        "Identify the pattern and requested quantity, then use a sum formula with its conditions.",
    questions: [
      "Common ratio of 2, 6, 18?|3|4;2;6|Each term is multiplied by three.",
      "Fourth term of 2, 6, 18, ...?|54|80;36;24|Multiply eighteen by three.",
      "Sum of 2, 6, 18, 54?|80|54;72;26|Add all four terms.",
      "Common difference of 2, 5, 8?|3|2;5;4|Each consecutive increase is three.",
      "Fifth term of 2, 5, 8, ...?|14|15;11;40|Add four differences of three to two.",
      "Sum of 2, 5, 8, 11, 14?|40|14;28;30|Five terms have average eight.",
      "Infinite sum 1 + 1/2 + 1/4 + ...?|2|1;3;No convergence|The ratio one half meets the convergence condition.",
      "When may the infinite geometric-sum formula be used?|Ratio absolute value less than one|Every ratio;Ratio greater than one;Only ratio exactly one|Terms must shrink sufficiently toward zero.",
      "Fourth term of 3, 6, 12, ...?|24|45;18;36|The common ratio is two.",
      "Sum of 3, 6, 12, 24?|45|24;48;36|Add the four terms.",
      "Does 3 + 6 + 12 + ... converge?|No|Yes, to six;Yes, to three;Yes, to forty-five|Its nonzero terms grow rather than approach zero."
    ],
  ),
  CoreMathUnit(
    title: "Trigonometric Functions",
    objectives: [
      "Convert between degrees and radians.",
      "Interpret unit-circle sine and cosine.",
      "Find amplitude and period of a sinusoid."
    ],
    focus:
        "The unit circle extends trigonometry beyond acute right-triangle angles.",
    explanation:
        "A full turn is 2π radians, so 180 degrees equals π radians. At angle θ on the unit circle, the point is (cos θ, sin θ). Thus cos π = −1 and sin(π/2) = 1. Sine and cosine repeat every 2π. In y = A sin(Bx), amplitude is the absolute value of A and period is 2π divided by the absolute value of nonzero B. Arc length s = rθ uses θ in radians.",
    model: {
      "θ = π/2": "Unit-circle point (0, 1).",
      "y = 2 sin(3x)": "Amplitude two, period 2π/3.",
      "r = 2, θ = π/2": "Arc length π."
    },
    worked:
        "Analyze y = −3 sin(2x). Step 1: amplitude is three. Step 2: negative sign reflects outputs vertically. Step 3: period is 2π/2 = π. Step 4: a half-turn input interval completes one output cycle.",
    guided:
        "Convert sixty degrees to radians and find amplitude and period of 4 cos(2x).",
    solution:
        "Sixty degrees is π/3. The cosine amplitude is four and period is π.",
    mistakes:
        "Do not use a degree value directly in s = rθ. A negative amplitude coefficient reflects the graph but amplitude itself is nonnegative.",
    recap:
        "Use unit-circle coordinates and radians, then track vertical size and horizontal repetition separately.",
    questions: [
      "180 degrees equals what in radians?|π|2π;π/2;180π|A half turn is pi radians.",
      "60 degrees equals what in radians?|π/3|π/6;3π;2π/3|Scale pi radians by sixty over 180.",
      "Sin(π/2) equals what?|1|0;−1;1/2|The unit-circle y-coordinate is one.",
      "Cos π equals what?|−1|1;0;1/2|The unit-circle x-coordinate at a half turn is negative one.",
      "Amplitude of 2 sin(3x)?|2|3;6;2π/3|Amplitude is the absolute vertical coefficient.",
      "Period of 2 sin(3x)?|2π/3|2π;3π;π/3|Divide the sine base period by three.",
      "Radius two and angle π/2 gives arc length what?|π|2π;π/2;1|Multiply radius by angle in radians.",
      "Amplitude of −3 sin(2x)?|3|−3;2;π|Amplitude is a nonnegative size.",
      "Period of 4 cos(2x)?|π|2π;4π;π/2|Cosine period two pi divides by two.",
      "Tan(π/2) is what?|Undefined|0;1;−1|Cosine is zero, so sine divided by cosine is undefined.",
      "Sin(θ + 2π) relates to sin θ how?|They are equal|They always have opposite signs;The first doubles;The first is zero|Sine repeats after a full turn."
    ],
  ),
  CoreMathUnit(
    title: "Analytic Geometry",
    objectives: [
      "Read conic parameters from equations.",
      "Complete squares for a circle.",
      "Distinguish semiaxes from full axes."
    ],
    focus:
        "Coordinate equations describe circles, ellipses, parabolas, and hyperbolas.",
    explanation:
        "A circle has (x − h)² + (y − k)² = r². The signs inside locate the center; the right side is radius squared. An ellipse x²/9 + y²/4 = 1 has semiaxes three and two. A hyperbola with a minus between those terms opens along its positive squared coordinate. In y² = 4px, the vertex is zero, focus (p, 0), and directrix x = −p. These forms assume the displayed axis alignment.",
    model: {
      "(x − 1)² + (y + 2)² = 9": "Center (1, −2), radius three.",
      "x²/9 + y²/4 = 1": "Horizontal semiaxis three; vertical two.",
      "y² = 8x": "p = 2, focus (2, 0), directrix x = −2."
    },
    worked:
        "Complete x² + y² − 4x + 6y − 12 = 0. Step 1: move twelve to the right. Step 2: add four and nine to complete both squares. Step 3: write (x − 2)² + (y + 3)² = 25. Step 4: center is (2, −3), radius five.",
    guided: "Find semiaxes of x²/16 + y²/9 = 1 and the focus of y² = 12x.",
    solution:
        "Semiaxes are four and three, so full axes are eight and six. In the parabola, 4p = 12 gives focus (3, 0).",
    mistakes:
        "Do not read squared radius as radius or denominators as semiaxes. Completing squares changes both equation sides. Standard forms depend on coordinate orientation.",
    recap:
        "Match the conic form and read parameters only after accounting for squares and signs.",
    questions: [
      "Center of (x − 1)² + (y + 2)² = 9?|(1, −2)|(−1, 2);(1, 2);(−1, −2)|The center makes both grouped coordinates zero.",
      "Radius of (x − 1)² + (y + 2)² = 9?|3|9;6;√3|Radius is the positive square root of nine.",
      "Horizontal semiaxis of x²/9 + y²/4 = 1?|3|9;6;2|The denominator is the semiaxis square.",
      "Full vertical axis length of x²/9 + y²/4 = 1?|4|2;8;9|The vertical semiaxis two is doubled.",
      "For y² = 8x, p equals what?|2|8;4;−2|Compare eight with four p.",
      "Focus of y² = 8x?|(2, 0)|(0, 2);(−2, 0);(0, −2)|The standard right-opening focus is p on the x-axis.",
      "Directrix of y² = 8x?|x = −2|x = 2;y = 2;y = −2|The directrix lies p units opposite the focus.",
      "Circle x² + y² − 4x + 6y − 12 = 0 has radius what?|5|12;25;3|Completing squares gives right side twenty-five.",
      "Semiaxes of x²/16 + y²/9 = 1?|4 and 3|16 and 9;8 and 6;2 and 3|Take positive square roots of denominators.",
      "Focus of y² = 12x?|(3, 0)|(0, 3);(12, 0);(−3, 0)|Four p equals twelve, so p is three.",
      "X²/9 − y²/4 = 1 describes which conic?|Hyperbola|Ellipse;Circle;A line|The difference of squared coordinate terms identifies this hyperbola."
    ],
  ),
  CoreMathUnit(
    title: "Intro Calculus",
    objectives: [
      "Interpret a limit near a point.",
      "Compute a difference quotient.",
      "Connect a derivative with instantaneous slope."
    ],
    focus: "Calculus studies limiting behavior and rates of change.",
    explanation:
        "For f(x) = x², the average rate from a to a + h is [(a + h)² − a²]/h for h ≠ 0. Expanding and cancelling gives 2a + h. As h tends to zero, the derivative is 2a. A limit concerns nearby values, not necessarily the value at the point. The expression (x² − 1)/(x − 1) is undefined at one, but simplifies to x + 1 nearby and has limit two.",
    model: {
      "[(a + h)² − a²]/h": "2a + h for nonzero h.",
      "h → 0": "Derivative 2a.",
      "(x² − 1)/(x − 1), x → 1": "Nearby rule x + 1 gives limit two."
    },
    worked:
        "Find derivative slope of x² at three. Step 1: form [(3 + h)² − 9]/h. Step 2: expand to (6h + h²)/h. Step 3: cancel nonzero h, giving 6 + h. Step 4: take h toward zero to get six.",
    guided:
        "Find average rate of x² from two to four, then its derivative at two.",
    solution:
        "Average rate is (16 − 4)/(4 − 2) = 6. The derivative at two is four; the interval rate and instantaneous rate need not match.",
    mistakes:
        "Do not set h = 0 before simplifying a quotient. A function can have a limit where its own value is undefined. Average and instantaneous rates are different concepts.",
    recap:
        "Use nearby values and valid simplification to obtain limits and instantaneous rates.",
    questions: [
      "Derivative of x² at x = 3?|6|3;9;12|The limiting slope is twice the input.",
      "Difference quotient of x² at a simplifies to what for nonzero h?|2a + h|2a;a² + h;h²|Expand the numerator before cancelling h.",
      "Limit of (x² − 1)/(x − 1) as x approaches one?|2|0;1;Undefined limit|For nearby nonzero denominator the rule equals x plus one.",
      "Value of (x² − 1)/(x − 1) at x = 1?|Undefined|2;1;0|The original denominator is zero.",
      "Average rate of x² from two to four?|6|4;8;12|Output change twelve divided by input change two.",
      "Derivative of x² at two?|4|2;6;8|Twice two equals four.",
      "Why not set h zero before quotient simplification?|It creates division by zero|It makes the slope one;It changes a into h;It removes limits forever|Simplify for nonzero h before taking its limit.",
      "Does a limit always require the function to be defined at the point?|No|Yes;Only for polynomials;Only at zero|Nearby behavior can approach a value despite a hole.",
      "Derivative of x² at five?|10|5;25;20|The general derivative is two x.",
      "Average rate of x² from one to three?|4|2;3;8|Eight units of output change over two input units.",
      "At x = 0, derivative of x² is what?|0|1;2;Undefined|The limiting slope is twice zero."
    ],
  ),
];
