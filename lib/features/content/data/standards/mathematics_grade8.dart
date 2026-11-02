import '../authored/core_math_unit.dart';
import '../authored/grade8_mathematics_core.dart';
import 'mathematics_authoring.dart';

final depedMath8 = <CoreMathUnit>[
  mathUnit(
      title: 'Factoring Polynomial Forms',
      aims: [
        'Extract a greatest common monomial factor.',
        'Factor differences of squares and trinomials.',
        'Recognize cube patterns and verify by expansion.'
      ],
      idea:
          'Factoring rewrites a sum as a product. First extract the greatest common factor. A difference of squares a² - b² factors as (a - b)(a + b). In x² + bx + c, seek two integers with sum b and product c. For ax² + bx + c, splitting the middle term can enable grouping. Cube identities are a³ + b³ = (a + b)(a² - ab + b²) and a³ - b³ = (a - b)(a² + ab + b²). Always expand to verify.',
      model: {
        'Common factor': '6x² + 9x = 3x(2x + 3)',
        'Difference of squares': 'x² - 25 = (x - 5)(x + 5)',
        'Trinomial': 'x² + 7x + 12 = (x + 3)(x + 4)',
        'Cube difference': 'x³ - 8 = (x - 2)(x² + 2x + 4)'
      },
      worked:
          'Factor 2x² + 7x + 3. Multiply the first and last coefficients: six. Choose six and one, which sum to seven. Split: 2x² + 6x + x + 3. Group: 2x(x + 3) + 1(x + 3). Factor: (2x + 1)(x + 3). Expand to check.',
      tryIt: 'Factor 3x² - 12 completely and factor x² - 6x + 9.',
      check:
          'Extract three, then use a difference of squares: 3(x - 2)(x + 2). The trinomial is the perfect square (x - 3)².',
      avoid:
          'A sum of squares is not a difference of squares. Stop only when each factor is fully factored over the intended number system.',
      remember:
          'Take out the common factor first, identify a pattern, and verify by multiplication.',
      bank: '''
Factor 4x + 8.|4(x + 2)|4(x + 8);x(4 + 8);8(x + 4)|Four is common to both terms.
Factor x² - 16.|(x - 4)(x + 4)|(x - 4)²;(x - 8)(x + 2);x(x - 16)|Use the difference of two squares.
Factor x² + 5x + 6.|(x + 2)(x + 3)|(x + 1)(x + 6);(x - 2)(x - 3);(x + 5)(x + 1)|Two and three sum to five and multiply to six.
Factor x² - 7x + 12.|(x - 3)(x - 4)|(x + 3)(x + 4);(x - 2)(x - 6);(x - 1)(x - 12)|Negative three and negative four sum to negative seven.
Factor x² + 10x + 25.|(x + 5)²|(x - 5)²;(x + 10)(x + 5);x(x + 25)|The middle term is twice x times five.
Factor 6x² + 12x.|6x(x + 2)|6(x + 2);x(6x + 2);12x(x + 1)|Both terms contain six x.
Factor x³ - 1.|(x - 1)(x² + x + 1)|(x - 1)³;(x + 1)(x² - x + 1);x(x² - 1)|Use the difference of cubes identity.
Which expression expands to x² - 9?|(x - 3)(x + 3)|(x - 3)²;(x + 3)²;(x - 9)(x + 1)|The middle terms cancel and the constant is negative nine.
Factor 2x² + 9x + 4.|(2x + 1)(x + 4)|(2x + 4)(x + 1);(2x - 1)(x - 4);(x + 2)(x + 4)|Expansion gives 2x² + 8x + x + 4.
Factor 5x² - 45 completely.|5(x - 3)(x + 3)|5(x - 9)(x + 9);(5x - 3)(x + 3);5(x - 3)²|Take out five, then factor x² - 9.
Factor x³ + 8.|(x + 2)(x² - 2x + 4)|(x + 2)³;(x - 2)(x² + 2x + 4);(x + 8)(x² - x + 1)|Apply the sum of cubes with b equal to two.
'''),
  mathUnit(
      title: 'Rational Algebraic Expressions',
      aims: [
        'State restrictions from original denominators.',
        'Simplify products and quotients by factoring.',
        'Add rational expressions using a common denominator.'
      ],
      idea:
          'A rational algebraic expression is a quotient of polynomials with a nonzero denominator. Record excluded values before cancelling. Cancel common factors, never separate terms in a sum. For addition, rename using a common denominator. For division, multiply by the reciprocal and require the original divisor to be defined and nonzero.',
      model: {
        'Original': '(x² - 9)/(x - 3), x ≠ 3',
        'Factored': '(x - 3)(x + 3)/(x - 3)',
        'Simplified': 'x + 3, still x ≠ 3',
        'Addition': '1/x + 1/(2x) = 3/(2x), x ≠ 0'
      },
      worked:
          'Simplify (x² - 4)/(x² + x - 6). Factor to (x - 2)(x + 2)/[(x + 3)(x - 2)]. Original exclusions are x ≠ -3, 2. Cancel the common factor x - 2 to get (x + 2)/(x + 3), retaining both exclusions.',
      tryIt: 'Simplify 6x²/(3x), then add 2/x + 3/x. State restrictions.',
      check:
          'Cancel the common factor 3x to get 2x, with x ≠ 0. Like denominators allow adding numerators: 5/x, again x ≠ 0.',
      avoid:
          'Cancelling does not restore an excluded input. For (x + 2)/x you cannot cancel the x term through addition.',
      remember:
          'Restrict, factor, cancel factors, and retain every original restriction.',
      bank: '''
What input is excluded from 1/(x - 4)?|4|-4;0;1|The denominator becomes zero at four.
Simplify 8x/(4x), x ≠ 0.|2|2x;4;1/2|Cancel the whole common factor four x.
Simplify (x² - 1)/(x - 1), x ≠ 1.|x + 1|x - 1;x;1|Factor the numerator as (x - 1)(x + 1).
Add 2/x + 5/x for x ≠ 0.|7/x|7/(2x);10/x;3/x|Add numerators with the same denominator.
Simplify (x + 3)/x for x ≠ 0.|1 + 3/x|3;4;x + 3|Split the quotient into x/x and 3/x.
Multiply (2/x)(3/5), x ≠ 0.|6/(5x)|5/(3x);6x/5;5/(6x)|Multiply numerators and denominators.
Divide (4/x) by (2/x), x ≠ 0.|2|2/x;8/x²;1/2|Multiply by x/2 and cancel.
What inputs are excluded from 1/[(x - 2)(x + 5)]?|2 and -5|-2 and 5;2 and 5;0 only|Each denominator factor must remain nonzero.
Add 1/x + 1/(3x), x ≠ 0.|4/(3x)|2/(4x);2/(3x);4/x|Rewrite the first fraction as 3/(3x).
Simplify (x² - 25)/(x + 5), x ≠ -5.|x - 5|x + 5;x² - 5;1|Factor and cancel x + 5.
After cancelling x - 2 from a fraction originally undefined at 2, is x = 2 now allowed?|No|Yes always;Only if positive;Only if an integer|The original domain restriction remains.
'''),
  grade8MathUnits[0],
  grade8MathUnits[2],
  mathUnit(
      title: 'Graphing Linear Inequalities and Regions',
      aims: [
        'Test ordered pairs in two-variable inequalities.',
        'Choose dashed or solid boundaries.',
        'Find the overlap in a system of inequalities.'
      ],
      idea:
          'A linear inequality in two variables describes a region, not just a line. Graph its boundary equation first. Use a solid line for ≤ or ≥ because equality is included; use a dashed line for < or >. Test a point not on the boundary and shade the side that makes the inequality true. A system requires all inequalities, so its solution is the overlapping region.',
      model: {
        'Boundary': 'y = 2x + 1',
        'Inequality': 'y > 2x + 1: dashed line, shade above',
        'Test point': '(0, 0): 0 > 1 is false, so do not shade its side',
        'System': 'x ≥ 0 and y ≥ 0: first quadrant including both axes'
      },
      worked:
          'Graph x + y ≤ 6. The boundary passes through (6,0) and (0,6). Draw it solid because equality is allowed. Test (0,0): zero is at most six, so shade the side containing the origin. If x ≥ 0 and y ≥ 0 are also required, keep only the first-quadrant triangular region.',
      tryIt:
          'Does (2,3) satisfy y < 2x? Should its boundary be solid? Describe the overlap of y ≥ 1 and y ≤ 4.',
      check:
          'Three is less than four, so (2,3) works. The boundary is dashed. The second system is a horizontal strip between y = 1 and y = 4, with both edges included.',
      avoid:
          'Do not shade automatically above every line. Rewrite or test a point. The solution to a system is intersection, not union.',
      remember:
          'Boundary, inclusion, test point, shading, then overlap: each step has a meaning.',
      bank: '''
Boundary for y < 3x + 2 should be what?|Dashed|Solid;A circle;No boundary|Strict inequality excludes equality.
Boundary for y ≥ x - 1 should be what?|Solid|Dashed;Invisible;Only a dot|Equality belongs to the solution.
Does (1,4) satisfy y > 2x?|Yes|No;Only on the boundary;Only if x is negative|Four is greater than two.
Does (3,1) satisfy x + y ≤ 3?|No|Yes;Always;Only on an axis|Three plus one is four, exceeding three.
For y ≤ 5, which side is shaded?|Below including the line|Above only;Only the line;Neither side|All y values at most five are included.
The solution to two simultaneous inequalities is what?|Their overlapping region|Their union always;Only both boundary lines;Only the origin|Each selected point must satisfy both.
Does (0,0) satisfy x + y < 8?|Yes|No;Only if 8 is negative;Only on the boundary|Zero is less than eight.
What does x ≥ 0 describe?|On or right of the vertical axis|Only above the horizontal axis;Left only;Only the horizontal axis|The x coordinate must be nonnegative.
Does (2,5) satisfy y ≥ x + 1 and y ≤ 6?|Yes|No, first fails;No, second fails;No, both fail|Five is at least three and at most six.
Nonnegative x,y satisfy x + y ≤ 10. Which point is excluded?|(7,5)|(2,3);(0,10);(4,4)|Its coordinate sum twelve exceeds ten.
What region satisfies y > 2 and y < 2?|No points|All points;The line y = 2;The first quadrant|No number is both greater and less than two.
'''),
  grade8MathUnits[1],
  mathUnit(
      title: 'Geometric Reasoning and Triangle Congruence',
      aims: [
        'Distinguish definitions, postulates, and theorems.',
        'Use SSS, SAS, ASA, AAS, or right-triangle hypotenuse-leg.',
        'Match corresponding parts in a proof.'
      ],
      idea:
          'Geometry begins with undefined terms such as point, line, and plane. A definition gives a term meaning. A postulate is accepted as a starting statement; a theorem requires proof. Congruent triangles have all corresponding sides and angles equal. SSS uses three matching sides; SAS uses two sides and their included angle; ASA uses two angles and the included side. AAS also works. For right triangles, a matching hypotenuse and leg are sufficient.',
      model: {
        'Correspondence': '△ABC ≅ △DEF means A↔D, B↔E, C↔F',
        'SAS': 'AB=DE, AC=DF, ∠A=∠D',
        'SSS': 'AB=DE, BC=EF, AC=DF',
        'After congruence': 'Corresponding parts, such as ∠B and ∠E, are equal'
      },
      worked:
          'Triangles ABC and ADC share AC. Suppose AB = AD and BC = DC. The shared side AC equals itself by reflexivity. The three pairs of sides match, so the triangles are congruent by SSS. Therefore corresponding angles ABC and ADC are equal.',
      tryIt:
          'Two triangles have sides 5 and 7 with the included angle 40° in each. Which criterion applies? Is AAA enough for congruence?',
      check:
          'SAS applies because the angle is between the known sides. AAA gives matching shape but not necessarily size, so it proves similarity, not congruence.',
      avoid:
          'SSA is not generally a congruence test. Keep corresponding vertices in order when writing a congruence statement.',
      remember:
          'Give a reason for each fact, establish a valid congruence condition, then use corresponding parts.',
      bank: '''
Which is an undefined basic term in Euclidean geometry?|Point|Isosceles triangle;Perpendicular bisector;Rectangle|Point is a starting term rather than defined using simpler geometry terms.
A statement accepted as a starting assumption is what?|Postulate|Proved theorem;Numerical answer;Counterexample|A postulate is accepted without proof within the system.
A statement supported by proof is what?|Theorem|Guess only;Undefined term;Measurement error|A theorem follows from accepted facts and reasoning.
Three matching side pairs establish which criterion?|SSS|AAA;SSA always;Only parallelism|Side-side-side fixes size and shape.
Two sides and their included angle establish what?|SAS|SSA always;AAA;Only AAS|The angle must lie between the two known sides.
Does AAA establish congruence?|No, only similarity|Yes always;Only for large triangles;Only for rotated triangles|Angles do not fix side lengths.
If △ABC ≅ △PQR, which corresponds to BC?|QR|PQ;PR;QP|Vertex order pairs B with Q and C with R.
Why does a shared side equal itself?|Reflexive property|Angle addition;Parallel postulate;Area formula|Any segment has its own length.
Two right triangles share equal hypotenuse and one equal leg. Congruent?|Yes, hypotenuse-leg|No criterion exists;Only if equilateral;Only if upright|The right angle and given sides fix the remaining leg.
If AB=DE, ∠A=∠D, ∠B=∠E, which criterion applies?|ASA|SSS;SSA;AAA only|The known side lies between the known angles.
After proving △ABC ≅ △ADC with the stated order, which angle equals ∠BAC?|∠DAC|∠ADC;∠ACD;∠ABC|Corresponding A angles match under that vertex order.
'''),
  mathUnit(
      title: 'Triangle Inequalities and Parallel Lines',
      aims: [
        'Test whether three lengths form a triangle.',
        'Relate side lengths to opposite angles.',
        'Use angle pairs from a transversal of parallel lines.'
      ],
      idea:
          'The sum of any two triangle sides must exceed the third. The longest side lies opposite the largest angle. An exterior triangle angle equals the sum of the two remote interior angles, so it exceeds each alone. When a transversal crosses parallel lines, corresponding angles and alternate interior angles are equal; same-side interior angles sum to 180°. These relationships can also prove lines parallel.',
      model: {
        'Side test': '3 + 4 > 5, so 3,4,5 can form a triangle',
        'Failed test': '2 + 3 = 5, so 2,3,5 cannot',
        'Parallel lines': 'Alternate interior angles: 65° and 65°',
        'Same-side interior': '65° + 115° = 180°'
      },
      worked:
          'Two triangle sides are 6 and 9 cm. Let the third side be x. The triangle inequality gives x > 9 - 6 = 3 and x < 9 + 6 = 15. So 3 < x < 15. If a parallel-line corresponding angle is 72°, its matching angle is also 72° and its adjacent straight-line angle is 108°.',
      tryIt:
          'Can 4, 7, 12 form a triangle? Two remote interior angles are 35° and 65°. Find their exterior angle.',
      check:
          'No, because four plus seven is eleven, less than twelve. The exterior angle is 35 + 65 = 100°.',
      avoid:
          'Equality fails the triangle side test: the figure would flatten. Equal angle rules require known or proved parallel lines.',
      remember:
          'Use strict side bounds and clearly identify the angle pair before applying a parallel-line rule.',
      bank: '''
Can sides 2, 3, 6 form a triangle?|No|Yes;Only if right;Only if tilted|Two plus three is less than six.
Can sides 5, 6, 8 form a triangle?|Yes|No;Only if equilateral;Only if parallel|The smallest pair sums to eleven, greater than eight.
Two sides are 4 and 9. Third side x must satisfy what?|5 < x < 13|5 ≤ x ≤ 13;x > 13;x < 5|Use the difference and sum as strict bounds.
Which side faces the largest angle?|Longest side|Shortest side;Any side equally;Only the base|Larger opposite sides correspond to larger angles.
Remote interior angles 40° and 70° give exterior angle what?|110°|30°;70°;180°|Add the two remote interior angles.
Parallel-line corresponding angle to 58° equals what?|58°|122°;32°;180°|Corresponding angles are equal for parallel lines.
Parallel-line same-side interior partner of 58° equals what?|122°|58°;32°;238°|They sum to one hundred eighty degrees.
Parallel-line alternate interior angles are what?|Equal|Always right;Always complementary;Always obtuse|Parallel lines create equal alternate interior pairs.
Sides 7, 10, x form a triangle. Which x is possible?|8|3;17;20|Eight lies strictly between three and seventeen.
A triangle has angles 30°, 60°, 90°. Which opposite side is longest?|Side opposite 90°|Side opposite 30°;Side opposite 60°;All equal|The largest angle faces the longest side.
Two sides of each of two triangles match. Their included angles are 50° and 70°. Which third side is longer?|The side opposite 70°|The side opposite 50°;They must be equal;No comparison is possible|The hinge theorem gives the larger third side to the larger included angle.
'''),
  mathUnit(
      title: 'Sample Spaces and Simple Probability',
      aims: [
        'List equally likely outcomes.',
        'Find event probabilities and complements.',
        'Compare theoretical and experimental probabilities.'
      ],
      idea:
          'A sample space lists every possible outcome. An event is a selected subset. With equally likely outcomes, P(event) is event size divided by sample-space size. The complement includes all outcomes not in the event, so its probability is 1 - P(event). Use a table or tree to avoid missing outcomes in two-stage experiments. Observed trial frequencies need not exactly equal theoretical probabilities.',
      model: {
        'Two coins': 'HH, HT, TH, TT',
        'Exactly one head': 'HT and TH: 2 of 4 outcomes',
        'At least one head': 'HH, HT, TH: 3 of 4',
        'No heads': 'TT: complement of at least one head'
      },
      worked:
          'Roll a fair die. The event prime is {2,3,5}, so its probability is 3/6 = 1/2. Its complement is {1,4,6}, also 1/2. One is not prime. In twenty actual rolls the prime count may be other than ten.',
      tryIt:
          'Toss two fair coins. Find the probability of two tails and of at least one head.',
      check:
          'TT is one of four equally likely outcomes, so two tails has probability 1/4. Its complement, at least one head, has probability 3/4.',
      avoid:
          'HH, mixed, TT are not three equally likely outcomes: mixed has two ordered outcomes. Do not count one as a prime.',
      remember:
          'List the full space, identify the event, count consistently, and check with a complement.',
      bank: '''
How many ordered outcomes have two coin tosses?|4|2;3;6|The space is HH, HT, TH, TT.
Probability of HH on two fair coin tosses?|1/4|1/2;1/3;3/4|One of four equally likely outcomes is HH.
Probability of exactly one head in two fair tosses?|1/2|1/4;3/4;1|HT and TH are two of four.
Probability of at least one head in two fair tosses?|3/4|1/4;1/2;1|Only TT has no head.
Probability of a number greater than 4 on a fair die?|1/3|1/6;1/2;2/3|Five and six are two of six.
If P(A) = 0.3, what is P(not A)?|0.7|0.3;1.3;0|Complements total one.
Probability of an impossible event?|0|1;1/2;-1|No sample-space outcomes are favourable.
Probability of a certain event?|1|0;2;1/2|Every outcome is favourable.
A bag has 5 red and 3 blue equal counters. Chance of blue?|3/8|3/5;5/8;1/3|Three blue counters out of eight total.
Probability of not rolling a 6 on a fair die?|5/6|1/6;1/5;0|Five faces belong to the complement.
Heads occurs 16 times in 40 tosses. Experimental probability?|2/5|1/2;3/5;1/16|Divide sixteen by forty, regardless of the theoretical half.
'''),
];
