import 'core_math_unit.dart';

const collegeMathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "College Algebra",
    objectives: [
      "Solve with domain restrictions.",
      "Handle two absolute-value branches.",
      "Use sign intervals for a quadratic inequality."
    ],
    focus:
        "A transformed equation must preserve restrictions and all valid branches.",
    explanation:
        "In (x + 2)/(x − 1) = 3, exclude x = 1 before multiplying by x − 1. Solving gives x = 5/2, which passes the original check. The equation abs(2x − 1) = 5 splits into 2x − 1 = 5 or −5, yielding x = 3 or −2. For (x − 1)(x − 3) < 0, the factors have opposite signs only between one and three; strict inequality excludes the endpoints.",
    model: {
      "(x + 2)/(x − 1) = 3": "x = 5/2; excluded x = 1.",
      "abs(2x − 1) = 5": "Solutions three and negative two.",
      "(x − 1)(x − 3) < 0": "Solution interval 1 < x < 3."
    },
    worked:
        "Solve 1/x + 1 = 2. Step 1: exclude zero. Step 2: subtract one, giving 1/x = 1. Step 3: multiply by permitted x to get x = 1. Step 4: original left side equals two.",
    guided: "Solve ln(x − 2) = 0 and explain why x = 2 is excluded.",
    solution:
        "The argument must be positive, so x > 2. Exponentiating gives x − 2 = 1, hence x = 3. At two the logarithm argument is zero.",
    mistakes:
        "Do not accept an excluded denominator root or omit the negative absolute-value branch. The sign of a product changes at roots with odd multiplicity.",
    recap:
        "Solve within the original domain, examine all branches, and verify sign-based solution sets.",
    questions: [
      "(x + 2)/(x − 1) = 3 gives x what?|5/2|1;−5/2;2|Multiplication gives x plus two equals three x minus three.",
      "Which x is excluded from (x + 2)/(x − 1)?|1|−2;0;3|The denominator must be nonzero.",
      "abs(2x − 1) = 5 gives solutions what?|3 and −2|3 only;−2 only;2 and −3|Solve the positive and negative five branches.",
      "Solution to (x − 1)(x − 3) < 0?|1 < x < 3|x < 1 or x > 3;x = 1 or 3;All real x|The factors have opposite signs between the roots.",
      "Does (x − 1)(x − 3) < 0 include x = 1?|No|Yes;Only if x is integer;Only with x = 3|At the endpoint the product is zero, not negative.",
      "1/x + 1 = 2 gives x what?|1|0;2;−1|The equation reduces to one over x equals one.",
      "For a real natural logarithm, argument must be what?|Positive|Nonnegative;Any real;Only negative|Zero and negative arguments are excluded.",
      "1/x = 2/x over nonzero x has what?|No solution|x = 0;All nonzero x;x = 2|Multiplying by valid x leaves false equality one equals two.",
      "ln(x − 2) = 0 gives x what?|3|2;1;0|The logarithm argument must equal e to zero, which is one.",
      "abs(x + 1) = 4 gives solutions what?|3 and −5|3 only;−5 only;5 and −3|Set x plus one equal positive or negative four.",
      "For (x − 2)(x − 5) < 0, which value works?|3|1;2;6|Three makes one factor positive and the other negative."
    ],
  ),
  CoreMathUnit(
    title: "Precalculus",
    objectives: [
      "Compose functions in the stated order.",
      "Find an inverse with domain care.",
      "Connect exponential and logarithmic ranges."
    ],
    focus: "Composition and inverses prepare function rules for calculus.",
    explanation:
        "For f(x) = 2x + 1 and g(x) = x², f(g(x)) = 2x² + 1 while g(f(x)) = (2x + 1)²; order generally matters. To invert y = 2x + 1, exchange input and output and solve, giving f⁻¹(x) = (x − 1)/2. An inverse function needs one-to-one behavior. Squaring on all real inputs is not one-to-one, but restricting its input to nonnegative values gives inverse square root. The exponential 3ˣ has positive range, and its inverse logarithm has positive domain.",
    model: {
      "f(g(x))": "2x² + 1",
      "g(f(x))": "(2x + 1)²",
      "Inverse of 2x + 1": "(x − 1)/2"
    },
    worked:
        "Find inverse of h(x) = 3x − 6. Step 1: write y = 3x − 6. Step 2: solve x = (y + 6)/3. Step 3: rename input to obtain h⁻¹(x) = (x + 6)/3. Step 4: composition returns x.",
    guided:
        "For f(x) = 2x + 1 and g(x) = x², find both compositions at x = 2. State the real domain of √(x − 2).",
    solution:
        "f(g(2)) = 9 and g(f(2)) = 25. The square-root domain requires x ≥ 2.",
    mistakes:
        "Do not reverse composition order. An inverse is not the reciprocal 1/f. Restrict a many-to-one rule before claiming an inverse function.",
    recap:
        "Compose in order and preserve domain and range when finding inverse relationships.",
    questions: [
      "For f = 2x + 1 and g = x², f(g(x)) is what?|2x² + 1|(2x + 1)²;2x + x²;2x² + 2|Apply g first, then f.",
      "For f(x) = 2x + 1 and g(x) = x², g(f(x)) is what?|(2x + 1)²|2x² + 1;x² + 1;2x + 1|Apply f first, then square its output.",
      "Inverse of f(x) = 2x + 1?|f⁻¹(x) = (x − 1)/2|f⁻¹(x) = 1/(2x + 1);f⁻¹(x) = 2x − 1;f⁻¹(x) = (x + 1)/2|Solve the output equation for its input.",
      "Is x² on all real x one-to-one?|No|Yes;Only at zero;Only because outputs are positive|Opposite nonzero inputs share an output.",
      "Inverse of x² restricted to x ≥ 0?|√x|−√x;1/x²;x/2|The nonnegative restriction selects a unique root.",
      "Real domain of √(x − 2)?|x ≥ 2|x > 0;All real x;x ≤ 2|The radicand must be nonnegative.",
      "Range of 3ˣ on real x?|Positive real numbers|All real numbers;Only integers;Nonpositive numbers|An exponential with positive base never becomes zero or negative.",
      "What does inverse-function notation mean here?|Undo the input-output mapping|Take a reciprocal;Change every sign;Square the rule|An inverse reverses the original mapping.",
      "For f = 2x + 1, g = x², f(g(2)) is what?|9|25;5;8|Square two, then double four and add one.",
      "For f(x) = 2x + 1 and g(x) = x², g(f(2)) is what?|25|9;5;4|Apply f to get five, then square.",
      "Inverse of h(x) = 3x − 6?|h⁻¹(x) = (x + 6)/3|h⁻¹(x) = 3x + 6;h⁻¹(x) = 1/(3x − 6);h⁻¹(x) = (x − 6)/3|Solve for input by adding six and dividing by three."
    ],
  ),
  CoreMathUnit(
    title: "Differential Calculus",
    objectives: [
      "Differentiate composite and implicit functions.",
      "Relate rates with the chain rule.",
      "Use a local linear approximation."
    ],
    focus:
        "Derivatives connect local slopes to relationships among changing quantities.",
    explanation:
        "For e^(x²), chain rule gives 2x e^(x²). In x² + y² = 25 with y depending on x, differentiate to obtain 2x + 2y y′ = 0, so y′ = −x/y when y ≠ 0. Related rates apply the same reasoning through time: if A = πr², then dA/dt = 2πr dr/dt. Linear approximation uses f(a) + f′(a)(x − a) for nearby x, and is an approximation rather than an exact identity.",
    model: {
      "e^(x²)": "Derivative 2x e^(x²).",
      "x² + y² = 25": "y′ = −x/y for y ≠ 0.",
      "A = πr²": "dA/dt = 2πr dr/dt."
    },
    worked:
        "Find tangent slope on x² + y² = 25 at (3, 4). Step 1: differentiate implicitly. Step 2: isolate y′ = −x/y. Step 3: substitute three and four. Step 4: slope is −3/4.",
    guided:
        "At radius three with dr/dt = 2, find area rate. Approximate √4.04 from the value and derivative at four.",
    solution:
        "Area rate is 2π × 3 × 2 = 12π. Square-root derivative at four is 1/4, so approximation is 2 + (1/4)(0.04) = 2.01.",
    mistakes:
        "When differentiating y² implicitly, include y′. Related rates need current values and compatible units. Local linear estimates are not exact values away from the base point.",
    recap:
        "Use chain relationships explicitly and distinguish exact derivatives from approximate predictions.",
    questions: [
      "Derivative of e^(x²)?|2x e^(x²)|e^(x²);2e^(x²);x²e^(x²)|Multiply exponential outer derivative by inner derivative two x.",
      "For x² + y² = 25, y′ where y ≠ 0?|−x/y|−y/x;x/y;−2x|Differentiate y squared with its chain factor.",
      "Slope of x² + y² = 25 at (3, 4)?|−3/4|3/4;−4/3;4/3|Substitute into negative x over y.",
      "Derivative of x eˣ?|eˣ(1 + x)|eˣ;x eˣ;2x eˣ|The product rule gives two terms.",
      "For A = πr², area rate equals what?|2πr dr/dt|π(dr/dt)²;2πr;πr² dr/dt|Differentiate the radius as a changing time function.",
      "Radius three and dr/dt two gives area rate what?|12π|6π;9π;18π|Multiply two pi, current radius, and radius rate.",
      "Linear approximation near a uses what?|f(a) + f′(a)(x − a)|f(a) + f′(x);f(a)(x − a);f′(a) only|Use base value plus tangent-rate correction.",
      "Why does differentiating y² produce 2y y′?|y depends on x|Every square adds a variable;The derivative is always zero;It doubles x|Chain rule includes the inner derivative.",
      "Approximate √4.04 using base four.|2.01|2.04;2.004;4.01|A quarter times 0.04 adds 0.01 to two.",
      "For xy = 1 and x ≠ 0, y′ is what?|−y/x|y/x;−x/y;1|Product rule gives y plus x y-prime equal zero.",
      "At (0, 5) on x² + y² = 25, slope is what?|0|1;Undefined;5|The implicit slope is negative zero over five."
    ],
  ),
  CoreMathUnit(
    title: "Integral Calculus",
    objectives: [
      "Use substitution with its differential.",
      "Apply integration by parts.",
      "Test an improper integral through a limit."
    ],
    focus: "Integration techniques depend on how an expression is built.",
    explanation:
        "For ∫2x(x² + 1)³ dx, choose u = x² + 1 and du = 2x dx. The integral becomes ∫u³ du = u⁴/4 + C. Integration by parts follows the product rule: ∫u dv = uv − ∫v du. For ∫x eˣ dx, choosing u = x gives x eˣ − eˣ + C. An improper integral with an infinite endpoint is a limit; convergence must be checked, not assumed.",
    model: {
      "∫2x(x² + 1)³ dx": "(x² + 1)⁴/4 + C",
      "∫x eˣ dx": "x eˣ − eˣ + C",
      "∫ from 1 to ∞ of 1/x² dx": "Limit of 1 − 1/b is one."
    },
    worked:
        "Evaluate ∫₀¹2x(x² + 1)³ dx. Step 1: choose u = x² + 1. Step 2: bounds become one and two. Step 3: evaluate [u⁴/4] from one to two. Step 4: result is (16 − 1)/4 = 15/4.",
    guided: "Find ∫eˣ dx and determine whether ∫₁∞1/x dx converges.",
    solution:
        "The antiderivative is eˣ + C. The improper integral is the limit of ln b, which grows without bound, so it diverges.",
    mistakes:
        "Changing variable requires changing the differential and either the bounds or substituting back. Infinite bounds are handled by limits. Integration by parts is not simply multiplying antiderivatives.",
    recap:
        "Match substitution or parts to structure, and justify convergence at improper boundaries.",
    questions: [
      "For ∫2x(x² + 1)³ dx, useful substitution is what?|u = x² + 1|u = 2x only;u = x³;u = 1|Its differential matches two x dx.",
      "With u = x² + 1, du is what?|2x dx|dx;x² dx;2 dx|Differentiate the chosen inner expression.",
      "Antiderivative of 2x(x² + 1)³?|(x² + 1)⁴/4 + C|(x² + 1)³ + C;(x² + 1)⁴ + C;2x⁴ + C|Integrate the transformed cube then substitute back.",
      "Integration-by-parts rule is what?|∫u dv = uv − ∫v du|∫u dv = uv + ∫v du;∫u dv = u′v′;∫u dv = uv only|Rearrange the integrated product derivative.",
      "Antiderivative of x eˣ?|x eˣ − eˣ + C|x eˣ + C;eˣ + C;x²eˣ/2 + C|Parts gives the product minus the remaining exponential integral.",
      "Integral of 1/x² from one to infinity?|1|0;2;Diverges|Endpoint expression one minus one over b approaches one.",
      "Integral of 1/x from one to infinity does what?|Diverges|Converges to one;Converges to zero;Converges to two|Its logarithmic endpoint grows without bound.",
      "What defines an improper infinite-endpoint integral?|A limit of finite-endpoint integrals|Substitution of infinity as a real number;Always zero;Always a finite area|Convergence is established by a limit.",
      "Integral of 2x(x² + 1)³ from zero to one?|15/4|15/2;4/15;4|Changed bounds one and two give fifteen fourths.",
      "An antiderivative of eˣ is what?|eˣ + C|x eˣ + C;ln x + C;1/eˣ + C|Exponential differentiates to itself.",
      "When x goes from zero to one in u = x² + 1, u bounds are what?|1 and 2|0 and 1;0 and 2;−1 and 1|Evaluate the substitution at both endpoints."
    ],
  ),
  CoreMathUnit(
    title: "Linear Algebra",
    objectives: [
      "Solve a small linear system.",
      "Relate rank and nullity.",
      "Check an eigenvector using matrix multiplication."
    ],
    focus: "Linear algebra studies systems, vector spaces, and matrix actions.",
    explanation:
        "For 2x + y = 5 and x − y = 1, adding gives 3x = 6, so (x, y) = (2, 1). The coefficient determinant is −3, nonzero, so the square system has a unique solution. Matrix [[1, 2], [2, 4]] has proportional rows and rank one; with two columns its nullity is one. The vector (−2, 1) maps to zero. An eigenvector is nonzero and satisfies Av = λv; a diagonal matrix [[2, 0], [0, 3]] maps (1, 0) to twice itself.",
    model: {
      "[[1, 2], [2, 4]]": "Rank one; nullspace includes (−2, 1).",
      "Rank + nullity": "Equals the number of columns.",
      "[[2, 0], [0, 3]] × (1, 0)": "2(1, 0), eigenvalue two."
    },
    worked:
        "Check whether v = (0, 1) is an eigenvector of diag(2, 3). Step 1: multiply to get (0, 3). Step 2: compare with the input. Step 3: output equals three times v. Step 4: v is nonzero, so eigenvalue is three.",
    guided:
        "Find rank and nullity of [[1, 1], [2, 2]]. Are (1, 2) and (2, 4) independent?",
    solution:
        "The matrix has one independent row, rank one and nullity one. The vectors are dependent because the second is twice the first.",
    mistakes:
        "Zero is not an eigenvector. Nonzero determinant matters only for the relevant square matrix. Rank counts independent directions, not just nonzero rows before reduction.",
    recap:
        "Use row relationships, dimension counts, and direct multiplication to verify linear-algebra claims.",
    questions: [
      "Solution of 2x + y = 5 and x − y = 1?|(2, 1)|(1, 2);(3, −1);(0, 5)|Adding gives three x equals six.",
      "Determinant of [[2, 1], [1, −1]]?|−3|3;−1;1|Two times negative one minus one equals negative three.",
      "Rank of [[1, 2], [2, 4]]?|1|2;0;4|The second row is twice the first.",
      "A matrix has two columns and rank one. Its nullity is what?|1|2;0;3|Rank plus nullity equals two.",
      "Which vector is in the nullspace of [[1, 2], [2, 4]]?|(−2, 1)|(2, 1);(1, 2);(0, 1)|Both row products with negative two and one equal zero.",
      "For diag(2, 3), eigenvalue of (1, 0)?|2|3;0;5|The output is twice the input.",
      "Can zero be an eigenvector?|No|Yes;Only for zero eigenvalue;Only for invertible matrices|Eigenvectors are defined to be nonzero.",
      "Are (1, 0) and (0, 1) independent?|Yes|No;Only if added;Only with equal coordinates|Neither is a scalar multiple of the other.",
      "Rank and nullity of [[1, 1], [2, 2]]?|1 and 1|2 and 0;0 and 2;2 and 2|One independent row leaves one nullspace dimension.",
      "Are (1, 2) and (2, 4) independent?|No|Yes;Only for positive scalars;Only if written as columns|The second is twice the first.",
      "For diag(2, 3), eigenvalue of (0, 1)?|3|2;0;5|Its output is three times itself."
    ],
  ),
];
