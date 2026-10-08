import 'core_math_unit.dart';

const grade7MathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "Rational Numbers",
    objectives: [
      "Represent rational quantities as fractions.",
      "Operate with signed fractions.",
      "Check signs and magnitude."
    ],
    focus:
        "A rational number is a ratio of integers with a nonzero denominator.",
    explanation:
        "Fractions such as −3/4, integers such as five, and terminating or repeating decimals are rational. Use common denominators for addition: −1/2 + 3/4 = −2/4 + 3/4 = 1/4. Multiply numerator products and denominator products; one negative factor makes a negative product, while two make a positive product. Dividing by a nonzero fraction multiplies by its reciprocal. A zero divisor remains undefined.",
    model: {
      "−1/2 + 3/4": "−2/4 + 3/4 = 1/4",
      "−2/3 × 3/4": "−6/12 = −1/2",
      "−3/5 ÷ 9/10": "−3/5 × 10/9 = −2/3"
    },
    worked:
        "Compute −3/5 ÷ 9/10. Step 1: verify the divisor is nonzero. Step 2: multiply by reciprocal 10/9. Step 3: obtain −30/45. Step 4: simplify to −2/3 and check its negative sign.",
    guided: "Find −1/4 + 5/8 and (−2/3)(−3/5).",
    solution:
        "The sum is −2/8 + 5/8 = 3/8. The product is 6/15 = 2/5, positive because both factors are negative.",
    mistakes:
        "Keep signs while finding common denominators. Flip the divisor for division, not the dividend. A fraction denominator cannot be zero.",
    recap:
        "Rational-number operations combine fraction rules with sign rules and nonzero-divisor restrictions.",
    questions: [
      "−1/2 + 3/4 equals what?|1/4|−1/4;1/2;5/4|Change negative one half to negative two fourths.",
      "−2/3 × 3/4 equals what?|−1/2|1/2;−2/7;−3/2|The product is negative six twelfths.",
      "−3/5 ÷ 9/10 equals what?|−2/3|−27/50;2/3;−3/2|Multiply by ten ninths and simplify.",
      "Two negative nonzero factors produce what sign?|Positive|Negative;Zero;Undefined always|The two sign reversals produce a positive product.",
      "0.125 equals which fraction?|1/8|1/4;1/5;1/125|125 thousandths simplifies to one eighth.",
      "The infinitely repeating decimal 0.333... equals what?|1/3|3/10;33/100;1/30|A repeating third is rational, unlike a finite truncation.",
      "2/7 + (−2/7) equals what?|0|4/7;2/7;−4/7|Opposite numbers add to zero.",
      "Which denominator is forbidden for a rational-number representation?|0|1;2;−3|Division by zero is undefined.",
      "−1/4 + 5/8 equals what?|3/8|1/2;−3/8;7/8|Add negative two eighths to five eighths.",
      "(−2/3)(−3/5) equals what?|2/5|−2/5;1/5;−1/5|Two negatives multiply to positive six fifteenths.",
      "Which is larger: −3/4 or −1/4?|−1/4|−3/4;They are equal;Neither is rational|Negative one fourth lies closer to zero and farther right."
    ],
  ),
  CoreMathUnit(
    title: "Proportions",
    objectives: [
      "Solve equivalent-ratio equations.",
      "Recognize a constant rate.",
      "Distinguish proportional relationships from offsets."
    ],
    focus: "A proportion states that two ratios are equal.",
    explanation:
        "In 2/3 = x/12, the denominator scales by four, so x = 8. Cross-products provide another check: 2 × 12 = 3x. Denominators must be nonzero. A proportional relationship has form y = kx with constant k, and its graph passes through the origin. The rule y = 2x + 1 is not proportional because its ratio y/x changes and it gives y = 1 at x = 0.",
    model: {
      "2/3 = 8/12": "Both ratios have the same value.",
      "y = 3x": "Every pair has rate three when x is nonzero.",
      "y = 2x + 1": "An added offset prevents direct proportionality."
    },
    worked:
        "Solve x/4 = 6/8. Step 1: simplify 6/8 to 3/4. Step 2: compare matching denominators. Step 3: x = 3. Step 4: check 3 × 8 = 4 × 6.",
    guided:
        "If five identical notebooks cost eighty credits at a fixed unit price, what do eight cost? State the proportionality constant.",
    solution:
        "The unit price is sixteen credits per notebook. Eight cost 128; k = 16 in cost = 16 × count.",
    mistakes:
        "An equal difference alone does not prove a proportion. Cross-multiplication requires valid nonzero denominators, and a graph through the origin alone must also follow a constant straight-line rate.",
    recap:
        "Equivalent ratios and constant rates define direct proportions; added fixed amounts do not.",
    questions: [
      "2/3 = x/12 gives x what?|8|6;4;18|Scale both terms by four.",
      "x/4 = 6/8 gives x what?|3|6;12;2|Six eighths equals three fourths.",
      "Which rule is proportional?|y = 3x|y = 3x + 2;y = x²;y = 3 + x|The ratio y to x stays three.",
      "For y = 4x, constant of proportionality is what?|4|x;0;1/4|Four is the multiplier of x.",
      "A direct-proportion graph must include what point?|(0, 0)|(1, 0);(0, 1);(4, 1)|Zero input gives zero output.",
      "Why is y = 2x + 1 not directly proportional?|It includes a nonzero fixed offset|Its slope is positive;It uses numbers;It is a line|The extra one changes y divided by x.",
      "Three items cost forty-two at a fixed rate. One costs what?|14|39;45;126|Divide the total by three equal items.",
      "Which checks 2/3 = 8/12?|2 × 12 = 3 × 8|2 + 12 = 3 + 8;2 × 3 = 8 × 12;2 − 3 = 8 − 12|Equal cross-products verify valid ratios.",
      "Five notebooks cost eighty at a fixed rate. Eight cost what?|128|83;100;160|Each costs sixteen, so eight cost 128.",
      "If y = 5x and x = 7, y is what?|35|12;2;57|Multiply seven by the constant rate five.",
      "4/5 = x/20 gives x what?|16|8;4;25|The denominator quadruples, so the numerator does too."
    ],
  ),
  CoreMathUnit(
    title: "Algebraic Expressions",
    objectives: [
      "Combine matching variable powers.",
      "Distribute positive and negative factors.",
      "Evaluate a simplified expression."
    ],
    focus:
        "An algebraic expression records operations involving variable quantities.",
    explanation:
        "Like terms have the same variable part including exponents. Thus 3x² + 2x² = 5x², but 3x and 2x² stay distinct. A coefficient is the numerical multiplier; a constant has no variable. Distribution gives 2(3x − 4) = 6x − 8. A minus before parentheses multiplies every term by negative one, so −(x − 3) = −x + 3. Equivalent expressions have the same value for all permitted inputs.",
    model: {
      "2(3x − 4) + 5x": "6x − 8 + 5x = 11x − 8",
      "−(x − 3)": "−x + 3",
      "3x² + 2x²": "5x², not 5x⁴"
    },
    worked:
        "Simplify 3(x + 2) − x. Step 1: distribute to get 3x + 6 − x. Step 2: combine three x minus one x. Step 3: write 2x + 6. Step 4: at x = 4, both forms give fourteen.",
    guided: "Simplify 2(3x − 4) + 5x and evaluate at x = 2.",
    solution:
        "The result is 11x − 8. At x = 2, it gives twenty-two minus eight, or fourteen.",
    mistakes:
        "Adding powers does not add their exponents; multiplication is different. Distribute a negative sign to every grouped term, not only the first.",
    recap:
        "Combine matching variable parts, distribute to all terms, and check equivalence with substitution.",
    questions: [
      "3x² + 2x² simplifies to what?|5x²|5x⁴;6x²;5x|Combine coefficients of matching squared terms.",
      "2(3x − 4) expands to what?|6x − 8|6x − 4;5x − 8;6x + 8|Double both terms.",
      "−(x − 3) equals what?|−x + 3|−x − 3;x + 3;x − 3|Multiply both terms by negative one.",
      "Coefficient of x in −3x + 7?|−3|3;7;x|The coefficient includes its negative sign.",
      "Constant term of 5x − 9?|−9|5;9;x|The constant has no variable and retains its sign.",
      "3x + 2x² can be combined to one like term?|No|Yes, 5x³;Yes, 5x²;Yes, 6x³|The variable powers differ.",
      "3(x + 2) − x simplifies to what?|2x + 6|2x + 2;4x + 6;3x + 5|Distribute then combine three x minus one x.",
      "At x = 4, 2x + 6 equals what?|14|10;18;8|Two times four plus six gives fourteen.",
      "2(3x − 4) + 5x simplifies to what?|11x − 8|11x − 4;6x − 3;10x − 8|Distribute and join the six x and five x terms.",
      "At x = 2, 11x − 8 equals what?|14|6;30;22|Twenty-two minus eight equals fourteen.",
      "4a − 7a simplifies to what?|−3a|3a;11a;−28a|Subtract coefficients while preserving the variable."
    ],
  ),
  CoreMathUnit(
    title: "Equations & Inequalities",
    objectives: [
      "Use inverse operations on both sides.",
      "Represent an inequality solution set.",
      "Reverse inequality direction when dividing by a negative."
    ],
    focus:
        "Equations identify equal values; inequalities describe ordered values.",
    explanation:
        "To solve 2x + 5 = 17, subtract five on both sides and divide both by two, giving x = 6. Doing the same valid operation on both sides preserves equality. For x + 3 < 7, subtract three to get x < 4, a set of values rather than one number. Multiplying or dividing an inequality by a negative reverses its direction: −2x > 8 becomes x < −4. Check a value in the original statement.",
    model: {
      "2x + 5 = 17": "2x = 12 → x = 6",
      "x + 3 < 7": "x < 4; four itself is excluded.",
      "−2x > 8": "x < −4 after division by negative two."
    },
    worked:
        "Solve 3(x − 2) = 12. Step 1: divide both sides by three. Step 2: obtain x − 2 = 4. Step 3: add two, giving x = 6. Step 4: check 3(6 − 2) = 12.",
    guided:
        "Solve −3x ≤ 12 and name a value satisfying the original inequality.",
    solution:
        "Divide by negative three and reverse direction: x ≥ −4. For x = 0, zero is at most twelve, so it satisfies.",
    mistakes:
        "Do not operate on only one side. Dividing by a negative reverses inequality direction. A strict inequality excludes its boundary value.",
    recap:
        "Balance both sides, track inequality signs, and verify solutions in the original relation.",
    questions: [
      "2x + 5 = 17 gives x what?|6|11;12;5|Subtract five and divide twelve by two.",
      "x + 3 < 7 simplifies to what?|x < 4|x > 4;x < 10;x = 4|Subtract three on both sides without reversing.",
      "−2x > 8 simplifies to what?|x < −4|x > −4;x < 4;x = −4|Division by a negative reverses direction.",
      "Which satisfies x < 4?|3|4;5;6|A strict bound excludes four and larger values.",
      "3(x − 2) = 12 gives x what?|6|2;4;14|Divide by three then add two.",
      "Why use an operation on both equation sides?|To preserve equality|To remove all variables;To force zero;To change the solution|Equal quantities remain equal under the same valid operation.",
      "Does x ≤ 5 include five?|Yes|No;Only with negative x;Only if x is integer|The equality part includes the boundary.",
      "When is an inequality direction reversed here?|Multiplying or dividing by a negative|Adding any positive;Subtracting any positive;Dividing by a positive|A negative factor reverses numerical order.",
      "−3x ≤ 12 simplifies to what?|x ≥ −4|x ≤ −4;x ≥ 4;x = 4|Divide by negative three and reverse the sign.",
      "5x − 4 = 21 gives x what?|5|17;25;4|Add four then divide twenty-five by five.",
      "Which checks x = 6 in 2x + 5 = 17?|2 × 6 + 5 = 17|2 + 6 + 5 = 17;2 × 5 + 6 = 17;6 + 5 = 17|Substitute into the original equation."
    ],
  ),
  CoreMathUnit(
    title: "Geometry & Probability",
    objectives: [
      "Find triangle area from perpendicular height.",
      "Use angle sums.",
      "Calculate probabilities from equally likely outcomes."
    ],
    focus:
        "Geometry measures shapes; probability compares favorable and possible outcomes.",
    explanation:
        "A triangle area is one half of base times perpendicular height. A base of eight and height five gives twenty square units. Triangle interior angles total one hundred eighty degrees. For a fair six-sided die, each face has probability 1/6; three even faces give 3/6 = 1/2. Counting favorable outcomes over total works when outcomes are equally likely. Do not use slanted side length as height without checking perpendicularity.",
    model: {
      "Triangle: base 8, height 5": "Area = 8 × 5 ÷ 2 = 20",
      "Angles 50°, 60°, ?": "Missing angle = 70°",
      "Fair die: even faces 2, 4, 6": "Probability 3/6 = 1/2"
    },
    worked:
        "Find a triangle third angle when the others are forty and sixty-five degrees. Step 1: use total one hundred eighty. Step 2: add known angles to 105. Step 3: subtract to obtain seventy-five. Step 4: check 40 + 65 + 75 = 180.",
    guided:
        "Find triangle area with base ten and height six. For a fair die, find probability of a number greater than four.",
    solution:
        "Area is thirty square units. Two faces, five and six, exceed four, so probability is 2/6 = 1/3.",
    mistakes:
        "Height must be perpendicular to the chosen base. Probability counts need a justified equal-likelihood assumption; a biased die may not match simple counts.",
    recap:
        "Use geometric definitions and explicit probability assumptions rather than visual guesses.",
    questions: [
      "Triangle base eight, height five. Area?|20 square units|40 square units;13 square units;26 square units|Take half of the base-height product.",
      "Triangle angles fifty and sixty degrees. Third angle?|70°|110°;130°;90°|Subtract their sum from one hundred eighty.",
      "Fair six-sided die gives probability of an even number what?|1/2|1/6;1/3;2/3|Three of six equally likely faces are even.",
      "Probability of rolling a seven on a standard six-sided die?|0|1;1/6;7/6|Seven is not a possible face.",
      "What height is used in triangle area?|Perpendicular distance to the base|Any slanted side;Perimeter;Angle measure|The area formula uses perpendicular height.",
      "Triangle base ten, height six. Area?|30 square units|60 square units;16 square units;32 square units|Half of sixty equals thirty.",
      "Triangle angles forty and sixty-five. Third angle?|75°|105°;85°;65°|The known sum 105 leaves seventy-five.",
      "When does favorable divided by total apply directly?|Equally likely outcomes|All outcomes have different probabilities;No outcomes exist;Only the largest outcome counts|Equal likelihood makes outcome counts proportional to chances.",
      "Fair die probability of a number greater than four?|1/3|1/2;1/6;2/3|Two of six faces qualify.",
      "Fair coin probability of heads?|1/2|0;1;2|One of two equally likely outcomes is heads.",
      "Triangle base twelve, perpendicular height three. Area?|18 square units|36 square units;15 square units;30 square units|Half of twelve times three is eighteen."
    ],
  ),
];
