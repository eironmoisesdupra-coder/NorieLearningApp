import 'core_math_unit.dart';

const grade8MathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "Linear Equations",
    objectives: [
      "Solve equations with variables on both sides.",
      "Recognize identities and contradictions.",
      "Check a solution by substitution."
    ],
    focus:
        "Linear equations can have one solution, every real solution, or no solution.",
    explanation:
        "In 3x + 2 = x + 10, subtract x from both sides, then subtract two: 2x = 8, so x = 4. Distribution may be needed first. If variables cancel and a true statement remains, as in 2(x + 3) = 2x + 6, every real x works. If cancellation leaves a false statement such as 1 = 3, there is no solution. These cases differ from a single solved value.",
    model: {
      "3x + 2 = x + 10": "2x = 8 → x = 4",
      "2(x + 3) = 2x + 6": "6 = 6: identity",
      "2x + 1 = 2x + 3": "1 = 3: contradiction"
    },
    worked:
        "Solve 6x − 5 = 2x + 11. Step 1: subtract 2x to obtain 4x − 5 = 11. Step 2: add five. Step 3: divide sixteen by four, giving x = 4. Step 4: both original sides equal nineteen.",
    guided: "Solve 4(x − 2) = 2x + 6 and classify 5x + 2 = 5x + 2.",
    solution:
        "Expand to 4x − 8 = 2x + 6, giving 2x = 14 and x = 7. The second equation is an identity for all real x.",
    mistakes:
        "Cancellation does not always imply x = 0. Inspect the remaining statement. Use distribution before combining terms.",
    recap:
        "Balance and simplify; then distinguish a unique value, a true identity, and a contradiction.",
    questions: [
      "3x + 2 = x + 10 gives x what?|4|8;6;12|Subtract x and two, then divide by two.",
      "2(x + 3) = 2x + 6 has how many real solutions?|All real numbers|One, x = 0;None;Only x = 3|Both sides are the same expression.",
      "2x + 1 = 2x + 3 has what solution set?|No solution|All real numbers;x = 2;x = 0|Subtracting 2x leaves false equality one equals three.",
      "5x − 7 = 3x + 9 gives x what?|8|2;16;−8|Two x equals sixteen.",
      "6x − 5 = 2x + 11 gives x what?|4|6;16;2|Four x equals sixteen.",
      "Why expand 4(x − 2) before combining terms?|To include both distributed products|To remove equality;To multiply only x;To force x = 0|Four multiplies x and negative two.",
      "After cancellation, 7 = 7 indicates what?|An identity|A contradiction;x = 7;x = 0|The remaining statement is true independently of x.",
      "After cancellation, 0 = 5 indicates what?|No solution|Every real solution;x = 5;x = 0|A false statement cannot be satisfied.",
      "4(x − 2) = 2x + 6 gives x what?|7|3;14;−7|Expansion leads to two x equals fourteen.",
      "For x = 4, 6x − 5 equals what?|19|24;11;29|Twenty-four minus five is nineteen.",
      "7x + 4 = 3x + 24 gives x what?|5|4;7;20|Subtract three x and four, leaving four x equals twenty."
    ],
  ),
  CoreMathUnit(
    title: "Functions",
    objectives: [
      "Test whether every input has one output.",
      "Evaluate a function rule.",
      "Read domain and range from a finite table."
    ],
    focus: "A function assigns exactly one output to each input in its domain.",
    explanation:
        "The relation (1, 2), (2, 4), (3, 6) is a function because each input has one output. The relation (1, 2), (1, 3) is not: input one has two different outputs. Different inputs may share an output. In f(x) = 2x − 3, f(4) means substitute four, giving five; it does not mean f times four. Domain lists permitted inputs; range lists resulting outputs. On a graph, a vertical line may meet a function graph at most once.",
    model: {
      "Inputs 1, 2, 3 → outputs 2, 4, 6": "One output per input.",
      "Input 1 → outputs 2 and 3": "Not a function.",
      "f(4) = 2 × 4 − 3": "Output five."
    },
    worked:
        "Use f(x) = x² on domain {−2, 0, 2}. Step 1: substitute each input. Step 2: outputs are four, zero, four. Step 3: domain remains {−2, 0, 2}. Step 4: range is {0, 4}; repeated output four is listed once.",
    guided:
        "For g(x) = 3x + 1, find g(−2). Does (1, 4), (2, 4) define a function?",
    solution:
        "g(−2) = −6 + 1 = −5. The relation is a function: each input has one output despite sharing four.",
    mistakes:
        "A function need not have different outputs for different inputs. Use the stated domain and distinguish input from output.",
    recap:
        "Check input uniqueness, substitute into rules, and list domain and range accurately.",
    questions: [
      "For f(x) = 2x − 3, f(4) is what?|5|8;1;11|Substitute four and calculate eight minus three.",
      "Which relation is not a function?|(1, 2), (1, 3)|(1, 2), (2, 3);(1, 4), (2, 4);(0, 0), (1, 1)|One input has two different outputs.",
      "Can different function inputs share one output?|Yes|No;Only if inputs are zero;Only if outputs are negative|One-output-per-input does not require one-input-per-output.",
      "Domain of pairs (1, 2), (3, 4) is what?|{1, 3}|{2, 4};{1, 2};{3, 4}|The first coordinates are inputs.",
      "Range of pairs (1, 2), (3, 4) is what?|{2, 4}|{1, 3};{1, 2};{3, 4}|The second coordinates are outputs.",
      "For f(x) = x², f(−3) is what?|9|−9;6;−6|Squaring multiplies negative three by itself.",
      "What does a vertical-line test inspect?|Whether one x has multiple y-values|Whether slope is positive;Whether all outputs differ;Whether every line is horizontal|Two intersections at one x violate input uniqueness.",
      "For x² on inputs −2, 0, 2, the range is what?|{0, 4}|{−2, 0, 2};{−4, 0, 4};{4}|The outputs four, zero, four give two distinct values.",
      "For g(x) = 3x + 1, g(−2) is what?|−5|−7;7;5|Three times negative two plus one equals negative five.",
      "Is (1, 4), (2, 4) a function?|Yes|No, outputs repeat;Only if four changes;Only if inputs match|Each input has exactly one output.",
      "For f(x) = 2x − 3, which input gives output seven?|5|2;7;10|Solve two x minus three equals seven."
    ],
  ),
  CoreMathUnit(
    title: "Systems of Equations",
    objectives: [
      "Find a pair satisfying both equations.",
      "Use substitution or elimination.",
      "Recognize one, no, or infinitely many solutions."
    ],
    focus: "A system solution must satisfy every equation at the same time.",
    explanation:
        "For x + y = 8 and x − y = 2, add equations to eliminate y: 2x = 10, so x = 5 and y = 3. Substitution works too: y = 8 − x can replace y in the second equation. In a graph, two nonparallel lines meet once. Parallel distinct lines have no common solution; equivalent equations describe the same line and infinitely many pairs.",
    model: {
      "x + y = 8; x − y = 2": "Add → 2x = 10 → (x, y) = (5, 3)",
      "x + y = 4; x + y = 6": "No pair can have both sums.",
      "x + y = 4; 2x + 2y = 8": "Same condition, infinitely many pairs."
    },
    worked:
        "Solve 2x + y = 10 and x + y = 7. Step 1: subtract the second equation from the first. Step 2: x = 3. Step 3: substitute into x + y = 7 to get y = 4. Step 4: check 2(3) + 4 = 10.",
    guided: "Solve x + y = 9 and x − y = 3, then verify both.",
    solution:
        "Adding gives 2x = 12, so x = 6. Then y = 3. Six plus three is nine and six minus three is three.",
    mistakes:
        "A pair working in only one equation is not a system solution. Subtraction must affect every term on both sides.",
    recap:
        "Combine equations to remove a variable, recover the other, and check both original equations.",
    questions: [
      "x + y = 8 and x − y = 2 give what pair?|(5, 3)|(3, 5);(4, 4);(6, 2)|Adding gives x five, then y three.",
      "2x + y = 10 and x + y = 7 give what pair?|(3, 4)|(4, 3);(5, 2);(2, 5)|Subtract equations to get x three.",
      "Adding x + y = 8 and x − y = 2 cancels which variable?|y cancels|x cancels;Both variables vanish;No operation is allowed|Positive y and negative y sum to zero.",
      "x + y = 4 and x + y = 6 has what?|No solution|Exactly one;All pairs;Only (4, 6)|The same sum cannot equal four and six.",
      "x + y = 4 and 2x + 2y = 8 has what?|Infinitely many solutions|No solution;Only (2, 2);Exactly two solutions|The second equation is twice the first.",
      "What must a system solution satisfy?|Both equations|Only the first;Only the simpler one;Neither after elimination|A common pair works throughout the system.",
      "For x + y = 8, which substitution is valid?|y = 8 − x|y = 8 + x;y = x − 8;y = 8x|Subtract x from both sides.",
      "Two distinct parallel lines have how many intersections?|0|1;2;Infinitely many|Parallel lines never meet.",
      "x + y = 9 and x − y = 3 give what pair?|(6, 3)|(3, 6);(5, 4);(7, 2)|Adding gives x six and substitution gives y three.",
      "For (3, 4), value of 2x + y is what?|10|7;11;14|Double three and add four.",
      "x + y = 10 and x − y = 4 give what pair?|(7, 3)|(3, 7);(6, 4);(8, 2)|Adding gives two x equals fourteen."
    ],
  ),
  CoreMathUnit(
    title: "Exponents & Radicals",
    objectives: [
      "Apply exponent laws with restrictions.",
      "Interpret principal square roots.",
      "Simplify radicals using square factors."
    ],
    focus:
        "Exponents describe repeated products; square roots reverse squaring with a chosen sign.",
    explanation:
        "For the same nonzero base, multiplying powers adds exponents and dividing subtracts them: 2³ × 2² = 2⁵ = 32. A power of a power multiplies exponents: (2³)² = 2⁶ = 64. A nonzero number to power zero is one, and x⁻² = 1/x² for x ≠ 0. The square-root symbol gives the nonnegative principal root, so √36 = 6, while solving x² = 36 gives x = ±6. Simplify √50 using 50 = 25 × 2.",
    model: {
      "2³ × 2²": "2⁵ = 32",
      "√50": "√25 × √2 = 5√2",
      "√36 versus x² = 36":
          "Principal root six; equation solutions positive and negative six."
    },
    worked:
        "Simplify √72. Step 1: find square factor thirty-six. Step 2: write √(36 × 2). Step 3: separate positive roots. Step 4: obtain 6√2 and check its square is seventy-two.",
    guided:
        "Calculate 3⁻² and simplify √98. State whether zero can be used in the negative-power example.",
    solution:
        "3⁻² = 1/9. √98 = √(49 × 2) = 7√2. Zero is excluded as a base for negative powers.",
    mistakes:
        "Do not add exponents when adding terms. √36 is not ±6; that pair solves the square equation. Negative exponents do not mean negative values automatically.",
    recap:
        "Use the correct power rule, keep nonzero-base restrictions, and distinguish roots from equation solutions.",
    questions: [
      "2³ × 2² equals what?|32|64;12;10|Add exponents to get two to the fifth.",
      "(2³)² equals what?|64|32;16;12|Multiply exponents: two to the sixth.",
      "For nonzero x, x⁰ equals what?|1|0;x;Undefined always|The zero-power rule requires nonzero base.",
      "3⁻² equals what?|1/9|−9;9;−1/9|A negative exponent gives a reciprocal.",
      "Principal square root of thirty-six?|6|−6;±6;18|The root symbol selects the nonnegative root.",
      "Solutions of x² = 36 are what?|6 and −6|6 only;−6 only;18 and −18|Both numbers square to thirty-six.",
      "√50 simplifies to what?|5√2|25√2;2√5;10√5|Factor fifty into twenty-five times two.",
      "Why exclude zero in x⁻²?|The reciprocal would divide by zero|Zero is negative;Every exponent forbids zero;Zero has no square|Negative powers use a nonzero denominator.",
      "√72 simplifies to what?|6√2|36√2;8√2;3√2|Thirty-six is a square factor; six times square root two is simplified.",
      "√98 simplifies to what?|7√2|49√2;14√2;2√7|Ninety-eight is forty-nine times two.",
      "5⁴ ÷ 5² equals what?|25|125;625;10|Subtract exponents to obtain five squared."
    ],
  ),
  CoreMathUnit(
    title: "Pythagorean Theorem",
    objectives: [
      "Identify the hypotenuse.",
      "Find a missing right-triangle side.",
      "Test whether a triangle is right."
    ],
    focus:
        "In a right triangle, the squares of the shorter sides sum to the hypotenuse square.",
    explanation:
        "For perpendicular legs a and b and hypotenuse c, a² + b² = c². The hypotenuse lies opposite the right angle and is longest. Legs three and four give c² = 9 + 16 = 25, hence c = 5. To find a missing leg, subtract the known leg square from c². The relation is for right triangles; do not apply it to an arbitrary triangle without checking.",
    model: {
      "3² + 4² = 5²": "Nine plus sixteen equals twenty-five.",
      "c = 13, a = 5": "b² = 169 − 25 = 144 → b = 12",
      "Sides 2, 3, 4": "4 + 9 ≠ 16, so not right."
    },
    worked:
        "Find the diagonal of a six-by-eight rectangle. Step 1: its sides form perpendicular legs. Step 2: square to get thirty-six and sixty-four. Step 3: diagonal square is one hundred. Step 4: the positive diagonal length is ten.",
    guided:
        "A right triangle has hypotenuse seventeen and leg eight. Find the other leg.",
    solution:
        "The missing square is 289 − 64 = 225, giving the positive length fifteen.",
    mistakes:
        "Do not add side lengths instead of squares or choose a negative length. Identify the hypotenuse before rearranging the formula.",
    recap:
        "Use the right angle to choose legs and hypotenuse, then square, add or subtract, and take a positive root.",
    questions: [
      "Right-triangle legs three and four give hypotenuse what?|5|7;1;25|Square sum is twenty-five, whose positive root is five.",
      "Where is the hypotenuse?|Opposite the right angle|Always horizontal;Opposite the smallest angle;Any chosen side|It is the longest side of a right triangle.",
      "Hypotenuse thirteen and leg five give other leg what?|12|18;8;144|Subtract twenty-five from 169 and take the positive root.",
      "Rectangle sides six and eight give diagonal what?|10|14;2;100|The diagonal is the hypotenuse of a right triangle.",
      "Does 2² + 3² equal 4²?|No|Yes;Only for centimeters;Only for rotated triangles|Thirteen is not sixteen.",
      "Which formula is correct for right-triangle legs a and b?|a² + b² = c²|a + b = c;a² − b² = c²;ab = c|The theorem compares the squared side lengths.",
      "Why use the positive square root for a length?|Lengths are nonnegative|All roots are negative;Both signs give different physical lengths;Squaring changes units to time|A side length is not a signed coordinate.",
      "Legs five and twelve give hypotenuse what?|13|17;7;169|Twenty-five plus 144 equals 169.",
      "Hypotenuse seventeen and leg eight give other leg what?|15|9;25;225|Square difference is 225, giving fifteen.",
      "Legs nine and twelve give hypotenuse what?|15|21;3;225|Eighty-one plus 144 is 225.",
      "Can the theorem be used directly for every triangle?|No, a right angle is required|Yes;Only for equal sides;Only for small triangles|The squared-side relation is specific to right triangles."
    ],
  ),
];
