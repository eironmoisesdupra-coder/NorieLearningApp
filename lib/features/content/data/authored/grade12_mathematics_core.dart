import 'core_math_unit.dart';

const grade12MathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "Limits",
    objectives: [
      "Compute nearby-value limits.",
      "Compare one-sided limits.",
      "Separate a limit from a point value."
    ],
    focus:
        "A limit describes what function outputs approach as inputs approach a target.",
    explanation:
        "For (x² − 4)/(x − 2), direct substitution gives zero divided by zero, not a result. Factoring gives x + 2 for x ≠ 2, so the limit at two is four even though the original value is undefined. A two-sided limit exists only when left and right approaches agree. If f(x) is zero for x < 0 and one for x ≥ 0, the one-sided limits at zero differ. Continuity requires the limit to equal the defined point value.",
    model: {
      "(x² − 4)/(x − 2), x → 2": "Cancel for nearby x; limit four.",
      "Step: zero on left, one on right":
          "Two-sided limit at zero does not exist.",
      "3/x as x → +∞": "Outputs tend to zero."
    },
    worked:
        "Find the limit of (x² − 9)/(x − 3) at three. Step 1: factor numerator as (x − 3)(x + 3). Step 2: cancel only for x ≠ 3. Step 3: nearby outputs follow x + 3. Step 4: approach three to obtain six.",
    guided:
        "If g(x) = 2x + 2 for x ≠ 0 but g(0) = 5, find the limit at zero and decide continuity.",
    solution:
        "The limit is two, but g(0) is five. They differ, so g is not continuous at zero.",
    mistakes:
        "Zero divided by zero signals that another method is needed, not that the limit is zero. A point value alone cannot establish a limit.",
    recap:
        "Simplify valid nearby expressions, compare both approaches, and test continuity separately.",
    questions: [
      "Limit of (x² − 4)/(x − 2) as x approaches two?|4|0;2;Undefined necessarily|Nearby values equal x plus two.",
      "Value of (x² − 4)/(x − 2) at x = 2?|Undefined|4;0;2|The denominator vanishes at two.",
      "Limit of (x² − 9)/(x − 3) at three?|6|0;3;9|Nearby rule x plus three approaches six.",
      "Left limit zero and right limit one at a point imply what?|No two-sided limit|Limit zero;Limit one;Limit one half|Both approaches must agree.",
      "Limit of 3/x as x tends to positive infinity?|0|3;1;Positive infinity|The denominator grows while numerator stays fixed.",
      "For g(x) = 2x + 2 except g(0) = 5, limit at zero?|2|5;0;No limit|Nearby values use the linear rule.",
      "For g(x) = 2x + 2 when x ≠ 0 and g(0) = 5, is g continuous at zero?|No|Yes;Only from above;Only because five is positive|The limit two differs from the point value five.",
      "What does 0/0 from direct substitution tell?|The direct method is inconclusive|The limit equals zero;The limit equals one;No limit can ever exist|Further algebra or another argument is needed.",
      "Limit of (x² − 16)/(x − 4) at four?|8|4;0;16|Cancel the factor to obtain nearby rule x plus four.",
      "Limit of (2x + 1)/(x − 1) as x tends to positive infinity?|2|0;1;3|Divide by x; the leading-coefficient ratio is two.",
      "For f(x) = 7x − 2, limit at x = 3?|19|21;5;−2|This polynomial is continuous, so substitution gives nineteen."
    ],
  ),
  CoreMathUnit(
    title: "Derivatives",
    objectives: [
      "Use power and constant rules.",
      "Apply product and chain rules.",
      "Interpret a derivative value as a rate."
    ],
    focus:
        "Differentiation gives local rates; compound expressions need matching rules.",
    explanation:
        "The power rule gives d(xⁿ)/dx = nxⁿ⁻¹ where the expression and derivative are defined. A constant has derivative zero, and terms can be differentiated separately. Product rule is (uv)′ = u′v + uv′. Chain rule differentiates an outer function then multiplies by the inner derivative: [(3x + 1)²]′ = 2(3x + 1) × 3. Trigonometric derivative rules here use radians. For sqrt x, derivative 1/(2√x) is valid for x > 0.",
    model: {
      "(3x³ − 2x + 5)′": "9x² − 2",
      "[(3x + 1)²]′": "6(3x + 1)",
      "(x² sin x)′": "2x sin x + x² cos x"
    },
    worked:
        "Find the derivative rate of 3x³ − 2x + 5 at two. Step 1: differentiate each term. Step 2: get 9x² − 2. Step 3: substitute x = 2. Step 4: rate is thirty-four units of output per input unit.",
    guided: "Differentiate (2x − 1)³ and find the derivative of x⁴ at x = −1.",
    solution:
        "Chain rule gives 6(2x − 1)². The second derivative expression is 4x³, which equals −4 at negative one.",
    mistakes:
        "Do not multiply derivatives to differentiate a product. Keep the inner factor in the chain rule, and distinguish a function value from its derivative value.",
    recap:
        "Choose the rule matching expression structure and state its domain and rate interpretation.",
    questions: [
      "Derivative of x³?|3x²|x²;3x³;x⁴/4|Bring down the exponent and reduce it by one.",
      "Derivative of constant seven?|0|7;1;x|A fixed value has zero rate.",
      "Derivative of 3x³ − 2x + 5?|9x² − 2|9x² + 5;3x² − 2;9x³ − 2|Differentiate terms and remove constant rate.",
      "Derivative of (3x + 1)²?|6(3x + 1)|2(3x + 1);3(3x + 1);6x + 1|Multiply the outer derivative by inner derivative three.",
      "Product rule for uv is what?|u′v + uv′|u′v′;u′ + v′;uv′ only|Each factor contributes one rate term.",
      "Derivative of sin x with radians?|cos x|−cos x;sin x;−sin x|The standard sine derivative uses radians.",
      "Derivative of √x for x > 0?|1/(2√x)|2√x;1/√x;√x/2|Apply the half-power rule.",
      "Derivative of x² sin x?|2x sin x + x² cos x|2x cos x;2x sin x;x² sin x|Use the product rule with both contributions.",
      "Derivative rate of 3x³ − 2x + 5 at two?|34|17;36;22|Substitute into nine x squared minus two.",
      "Derivative of (2x − 1)³?|6(2x − 1)²|3(2x − 1)²;6(2x − 1);2(2x − 1)³|Outer derivative three times inner derivative two.",
      "Derivative of x⁴ at x = −1?|−4|4;1;0|Four times negative one cubed is negative four."
    ],
  ),
  CoreMathUnit(
    title: "Integrals",
    objectives: [
      "Find polynomial antiderivatives.",
      "Use endpoints for definite integrals.",
      "Distinguish signed accumulation from total area."
    ],
    focus:
        "Integration describes accumulated change and reverses differentiation.",
    explanation:
        "An antiderivative of x² is x³/3 because differentiating x³/3 returns x². Indefinite integrals include + C, since constants differentiate to zero. For xⁿ with n ≠ −1, an antiderivative is xⁿ⁺¹/(n + 1) on an appropriate domain. A definite integral from a to b is F(b) − F(a) when the fundamental theorem applies. Negative integrand values contribute negative signed area; total geometric area must count them positively.",
    model: {
      "∫x² dx": "x³/3 + C",
      "∫ from 0 to 2 of x dx": "[x²/2] from 0 to 2 = 2",
      "∫ from −1 to 1 of x dx": "Signed area zero; total area one."
    },
    worked:
        "Evaluate integral of 3x² from zero to two. Step 1: choose antiderivative x³. Step 2: evaluate upper endpoint to get eight. Step 3: evaluate lower endpoint to get zero. Step 4: subtract to obtain eight.",
    guided:
        "Find an antiderivative of 4x³, then evaluate integral of 2x from one to three.",
    solution:
        "An antiderivative is x⁴ + C. The definite integral is [x²] from one to three = 9 − 1 = 8.",
    mistakes:
        "Do not omit the constant from an indefinite integral. Reverse endpoints changes sign. A signed integral can cancel even when geometric area is positive.",
    recap:
        "Check an antiderivative by differentiating, and use upper minus lower values for accumulation.",
    questions: [
      "An antiderivative of x² is what?|x³/3|2x;x³;x²/2|Differentiate x cubed divided by three to check.",
      "Why add C in an indefinite integral?|Different constants have the same derivative|Every integral is zero;It changes the derivative;It is an endpoint|Differentiation removes additive constants.",
      "Integral of x from zero to two?|2|4;1;0|Evaluate x squared over two at the endpoints.",
      "Integral of 3x² from zero to two?|8|4;12;6|The antiderivative x cubed gives eight minus zero.",
      "Integral of x from −1 to 1?|0|1;2;−1|Positive and negative signed contributions cancel.",
      "Total geometric area under y = x between −1 and 1?|1|0;2;−1|Two right triangles each have area one half.",
      "For F an antiderivative, definite integral from a to b equals what?|F(b) − F(a)|F(a) − F(b);F(a) + F(b);F(b)/F(a)|Use upper endpoint minus lower.",
      "Does the simple power antiderivative rule cover n = −1?|No|Yes;Only for positive x;Only with C = 0|It would divide by zero; logarithms handle that case.",
      "An antiderivative of 4x³?|x⁴ + C|12x² + C;4x⁴ + C;x³ + C|Differentiate x to the fourth to recover four x cubed.",
      "Integral of 2x from one to three?|8|9;6;4|The endpoint squares give nine minus one.",
      "Reversing endpoints of an integral does what?|Reverses its sign|Always doubles it;Keeps every value;Makes it undefined|Direction changes signed accumulation."
    ],
  ),
  CoreMathUnit(
    title: "Probability Distributions",
    objectives: [
      "Describe a discrete random variable.",
      "Check probability totals.",
      "Calculate expected value from weighted outcomes."
    ],
    focus: "A distribution pairs each possible value with its probability.",
    explanation:
        "Let X count heads in two independent fair coin tosses. The probabilities are P(X = 0) = 1/4, P(X = 1) = 1/2, and P(X = 2) = 1/4. Probabilities are nonnegative and sum to one. Expected value is ΣxP(X = x), giving one head; this is a long-run average, not a guarantee for each trial. Variance is E(X²) − [E(X)]², giving one half here.",
    model: {
      "X = 0, 1, 2": "Probabilities 1/4, 1/2, 1/4.",
      "Expected X": "0 × 1/4 + 1 × 1/2 + 2 × 1/4 = 1",
      "Variance": "E(X²) = 3/2; variance = 1/2"
    },
    worked:
        "Find expectation for values zero and four with probabilities 3/4 and 1/4. Step 1: check probabilities total one. Step 2: multiply each value by its probability. Step 3: add zero and one. Step 4: expectation one is not itself a possible observed value.",
    guided:
        "For values one and three, each probability one half, find expectation and variance.",
    solution:
        "Expectation is two. E(X²) = (1 + 9)/2 = 5, so variance is 5 − 4 = 1.",
    mistakes:
        "Do not average values without weights unless probabilities match. Expected value may be outside the listed outcomes but remains between their minimum and maximum.",
    recap:
        "Validate the probability model, weight every outcome, and distinguish expectation from individual results.",
    questions: [
      "Heads in two independent fair tosses: probability of X = 1?|1/2|1/4;3/4;1|HT and TH are two of four paths.",
      "Expected number of heads in two independent fair coin tosses?|1|0;2;1/2|Weighted outcomes average to one head.",
      "What must discrete distribution probabilities sum to?|1|0;Number of outcomes;Largest value|All possible outcomes exhaust probability one.",
      "Can a listed probability be negative?|No|Yes;Only with negative outcomes;Only if expectation is zero|Probabilities are nonnegative.",
      "Values zero and four with probabilities 3/4 and 1/4 have expectation what?|1|2;3;4|Four times one quarter equals one.",
      "Must expectation be a possible observed outcome?|No|Yes;Only with equal probabilities;Only with two values|It is an average, not necessarily a listed value.",
      "For X counting heads in two independent fair coin tosses, E(X²) is what?|3/2|1;2;1/2|One contributes one half and four contributes one.",
      "Variance of the number of heads in two independent fair coin tosses?|1/2|1;3/2;2|Subtract expectation squared one from three halves.",
      "Values one and three with equal probabilities have expectation what?|2|1;3;4|Equal weights average the values.",
      "Variance of values one and three with equal probabilities?|1|2;4;5|Second moment five minus mean square four gives one.",
      "Probabilities 0.4, 0.4, 0.4 for exhaustive outcomes form a valid distribution?|No|Yes;Only for three outcomes;Only if values are zero|Their sum 1.2 exceeds one."
    ],
  ),
  CoreMathUnit(
    title: "Applied Mathematics",
    objectives: [
      "Build a linear model with units.",
      "Solve a break-even equation.",
      "Identify model assumptions and feasible values."
    ],
    focus:
        "An applied answer is useful only when the equation matches the situation.",
    explanation:
        "In an invented production model, cost C(q) = 100 + 5q credits contains fixed cost one hundred and five credits per item. Revenue R(q) = 9q credits assumes every item sells at nine. Break-even solves R = C, giving 4q = 100 and q = 25. Profit is R − C = 4q − 100. The model assumes constant rates and ignores other costs; q is a nonnegative item count, usually an integer.",
    model: {
      "Cost: 100 + 5q": "Fixed one hundred plus variable cost.",
      "Revenue: 9q": "Nine credits per sold item.",
      "Profit: 4q − 100": "Break-even at q twenty-five."
    },
    worked:
        "Find profit from thirty items. Step 1: cost is 100 + 5 × 30 = 250. Step 2: revenue is 9 × 30 = 270. Step 3: subtract cost from revenue. Step 4: profit is twenty credits under the stated assumptions.",
    guided:
        "If fixed cost is sixty, variable cost four, and price seven, find break-even quantity. State what changes if not every produced item sells.",
    solution:
        "Break-even is 60/(7 − 4) = 20 items. If some items do not sell, revenue must use sold quantity, so the original equal-quantity model no longer applies.",
    mistakes:
        "Do not confuse revenue with profit. A solved negative or fractional item count needs feasibility interpretation. The equations describe an invented simplified case, not a guaranteed real business outcome.",
    recap:
        "Identify quantities and units, solve the model, and check assumptions and feasibility before interpreting the result.",
    questions: [
      "For C(q) = 100 + 5q, fixed cost is what?|100 credits|5 credits;105 credits;q credits|The constant term remains when q is zero.",
      "For R(q) = 9q, revenue from thirty sold items?|270 credits|39 credits;250 credits;30 credits|Multiply unit price by sold count.",
      "Cost of thirty items in C(q) = 100 + 5q?|250 credits|150 credits;270 credits;105 credits|Add fixed cost to five times thirty.",
      "For cost C(q) = 100 + 5q and revenue R(q) = 9q, profit at q = 30?|20 credits|270 credits;250 credits;520 credits|Profit is revenue minus cost.",
      "Break-even for 9q = 100 + 5q occurs at q what?|25|20;100;4|Four q equals one hundred.",
      "Profit expression for revenue 9q and cost 100 + 5q?|4q − 100|14q + 100;4q + 100;9q − 100|Subtract the entire cost expression.",
      "Why restrict produced item count to nonnegative values?|Negative production is infeasible here|All linear equations forbid negatives;Profit cannot be negative;Fixed cost must vanish|The variable represents a physical count.",
      "What assumption supports R(q) = 9q for produced q?|Every produced item sells at nine credits|No items sell;Price changes arbitrarily;Cost is zero|Revenue depends on sold count and fixed unit price.",
      "Fixed sixty, cost four per item, price seven. Break-even count?|20|15;60;3|Solve three q equals sixty.",
      "Fixed cost sixty, variable cost four per item, price seven: profit from twenty-five sold items?|15 credits|75 credits;175 credits;160 credits|Margin three times twenty-five minus sixty is fifteen.",
      "If some produced items remain unsold, what needs changing?|Use sold count for revenue|Assume revenue unchanged;Delete all costs;Make production negative|The original equal sold-and-produced assumption fails."
    ],
  ),
];
