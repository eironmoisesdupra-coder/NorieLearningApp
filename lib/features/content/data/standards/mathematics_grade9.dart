import '../authored/core_math_unit.dart';
import '../authored/grade8_mathematics_core.dart';
import '../authored/grade9_mathematics_core.dart';
import '../authored/grade10_mathematics_core.dart';
import 'mathematics_authoring.dart';

final depedMath9 = <CoreMathUnit>[
  grade9MathUnits[1],
  grade10MathUnits[0],
  mathUnit(
      title: 'Quadratic Inequalities and Rational Equations',
      aims: [
        'Solve a quadratic inequality using sign intervals.',
        'Exclude zero denominators in rational equations.',
        'Check transformed solutions in original equations.'
      ],
      idea:
          'A quadratic inequality asks where a quadratic is positive or negative. Factor, mark its zeros, and test the intervals between them. Strict inequalities exclude zero points; non-strict inequalities may include them. A rational equation contains variable denominators. List forbidden values first, then multiply by a common denominator to solve. Clearing denominators can produce a candidate that is forbidden in the original equation.',
      model: {
        'Quadratic': '(x - 2)(x - 5)',
        'Sign intervals':
            'Positive for x < 2; negative for 2 < x < 5; positive for x > 5',
        'Restriction': '1/(x - 3) requires x ≠ 3',
        'Equation': '2/x = 1/3 → x = 6, x ≠ 0'
      },
      worked:
          'Solve (x - 1)/(x - 2) = 2/(x - 2). Exclude x = 2. Multiply by x - 2 to get x - 1 = 2, hence x = 3. Substitute into the original: 2/1 = 2/1, so three is valid. For x² - 9 < 0, roots -3 and 3 bound the negative interval: -3 < x < 3.',
      tryIt: 'Solve x² - 4 ≥ 0. Solve 3/(x + 1) = 1 with its restriction.',
      check:
          'The upward quadratic is nonnegative outside its roots: x ≤ -2 or x ≥ 2. Exclude -1 in the rational equation; its solution x = 2 is allowed.',
      avoid:
          'Do not keep a root that makes an original denominator zero. An inequality solution is often an interval, not just its endpoints.',
      remember:
          'Use signs for inequality regions, restrictions for rational equations, and substitution to verify candidates.',
      bank: '''
Solve x² - 1 < 0.|-1 < x < 1|x < -1 or x > 1;x = ±1;All real x|The upward parabola is below zero between its roots.
Solve x² - 9 ≥ 0.|x ≤ -3 or x ≥ 3|-3 ≤ x ≤ 3;x = 0;No real x|It is nonnegative outside and at the roots.
Which value is excluded from 2/(x + 4)?|-4|4;2;0|Negative four makes the denominator zero.
Solve 2/x = 1/5.|10|5;2;0|Cross-multiplication gives x = ten, with x nonzero.
Solve 4/(x - 1) = 2.|3|1;2;-1|Four equals two times x minus one, so x is three.
Does x = 2 satisfy (x² - 4)/(x - 2) = 4?|No, it is undefined|Yes, after cancellation;Yes, because both sides are four;Only if rounded|The original denominator is zero.
Solve (x - 2)(x - 6) < 0.|2 < x < 6|x < 2 or x > 6;x = 2 or 6;All x|The factors have opposite signs between the roots.
What should be done before clearing denominators?|Record forbidden inputs|Discard all negative numbers;Square every term;Assume denominator is one|Original domain restrictions must survive the transformation.
Solve 5/(x + 2) = 1.|3|-2;5;7|Five equals x plus two.
Solve x² + 1 < 0 over the reals.|No solution|All real x;x < -1;x > 1|A real square is at least zero, so adding one is positive.
Solve (x - 1)(x + 2) ≤ 0.|-2 ≤ x ≤ 1|x ≤ -2 or x ≥ 1;-2 < x < 1 only;All x|The product is nonpositive between the roots, including both zeros.
'''),
  mathUnit(
      title: 'Quadratic Functions and Parabola Models',
      aims: [
        'Read vertex form and its transformations.',
        'Find intercepts and the axis of symmetry.',
        'Use a quadratic model with a sensible domain.'
      ],
      idea:
          'A quadratic function y = ax² + bx + c, a ≠ 0, graphs as a parabola. Vertex form y = a(x - h)² + k has vertex (h,k) and axis x = h. Positive a opens upward with a minimum; negative a opens downward with a maximum. Zeros are x-intercepts, while c is the y-intercept in standard form. A real problem can limit which x values make sense.',
      model: {
        'Function': 'y = (x - 2)² - 9',
        'Vertex': '(2, -9), minimum',
        'Axis': 'x = 2',
        'Intercepts': 'x = -1 or 5; y-intercept -5'
      },
      worked:
          'For y = x² - 6x + 5, complete the square: y = (x - 3)² - 4. The vertex is (3,-4) and the axis is x = 3. Factor x² - 6x + 5 = (x - 1)(x - 5), giving zeros one and five. The y-intercept is five. Plot symmetric pairs around x = 3.',
      tryIt:
          'State vertex and maximum or minimum of y = -2(x + 1)² + 8. Find its zeros.',
      check:
          'Vertex (-1,8) is a maximum because the coefficient is negative. Set (x + 1)² = 4; zeros are x = -3 and x = 1.',
      avoid:
          'In (x - h), the vertex coordinate is h, not -h. A projectile height model should not use negative time unless its context allows it.',
      remember:
          'Read vertex, opening, symmetry, and intercepts as connected features of the same quadratic.',
      bank: '''
Vertex of y = (x - 4)² + 2?|(4,2)|(-4,2);(4,-2);(2,4)|Vertex form directly gives h and k.
Axis of y = (x + 3)² - 1?|x = -3|x = 3;y = -1;y = 3|The x coordinate of the vertex is negative three.
Does y = -x² + 5 have a maximum or minimum?|Maximum|Minimum;Neither;Both at every point|A negative leading coefficient opens downward.
Y-intercept of y = 2x² - 3x + 7?|7|2;-3;0|Set x equal to zero.
Zeros of y = x² - 16?|-4 and 4|4 only;-8 and 8;-16 and 16|Factor into x minus four and x plus four.
Minimum value of y = 3(x - 2)² - 6?|-6|2;3;6|The squared term cannot be negative.
Vertex of y = x² - 4x + 3?|(2,-1)|(-2,3);(4,3);(2,1)|Complete the square to get (x - 2)² - 1.
Which graph opens upward?|y = 2x²|y = -x²;y = -3x²;y = -0.5x²|The leading coefficient is positive.
For y = (x - 1)², what is y when x = 4?|9|3;16;5|The square of four minus one is nine.
Height h = -t² + 6t has its maximum at which t?|3|0;6;9|Complete the square to get -(t - 3)² + 9.
Which x values give the same y for axis x = 2?|0 and 4|0 and 2;1 and 4;2 and 3|They lie equal distances on opposite sides of the axis.
'''),
  mathUnit(
      title: 'Direct Inverse Joint and Combined Variation',
      aims: [
        'Distinguish four variation structures.',
        'Find a constant of variation.',
        'Predict a new value using a model.'
      ],
      idea:
          'Direct variation has y = kx, so y/x is constant. Inverse variation has y = k/x, so xy is constant. Joint variation combines direct factors, such as y = kxz. Combined variation mixes direct and inverse factors, such as y = kx/z. Use known data to find k before substituting new values. The equations describe the assumed relationship, not every real-world situation.',
      model: {
        'Direct': 'y = 3x: doubling x doubles y',
        'Inverse': 'y = 24/x: doubling x halves y',
        'Joint': 'A = kbh',
        'Combined': 'y = kx/z'
      },
      worked:
          'A job takes six equally productive workers ten days. Assume time varies inversely with workers. Set t = k/w. Then k = 6 × 10 = 60 worker-days. For twelve workers, t = 60/12 = 5 days. Check the worker-day product remains sixty.',
      tryIt:
          'y varies jointly with x and z. When x = 2, z = 3, y = 24. Find y for x = 5 and z = 2.',
      check:
          'Use y = kxz. Since 24 = k × 2 × 3, k = 4. The new value is 4 × 5 × 2 = 40.',
      avoid:
          'A straight line with a nonzero intercept is not direct variation. Inverse variation keeps a product, not a ratio, constant.',
      remember:
          'Choose the relationship, solve for k, then use and check the new values.',
      bank: '''
Which equation shows direct variation?|y = 5x|y = x + 5;y = 5/x;y = x² + 5|The ratio y/x stays constant at five.
Which equation shows inverse variation?|y = 12/x|y = 12x;y = x + 12;y = 12 - x|The product xy stays twelve.
For y = kx, x = 3 and y = 18. Find k.|6|15;21;54|Divide eighteen by three.
For y = 4x, find y when x = 7.|28|11;3;49|Multiply four by seven.
For y = k/x, x = 5 and y = 8. Find k.|40|13;3;1.6|Multiply x and y.
For y = 40/x, find y when x = 10.|4|400;30;50|Divide forty by ten.
Which expresses y jointly proportional to x and z?|y = kxz|y = kx/z;y = k/(xz);y = k + x + z|Both direct factors multiply the constant.
If y = 2xz, x = 3, z = 4, find y.|24|9;12;18|Multiply two times three times four.
If y = 6x/z, x = 5, z = 3, find y.|10|90;14;2|Thirty divided by three equals ten.
Eight workers finish in 9 days. Under inverse variation, twelve workers need how long?|6 days|13.5 days;3 days;12 days|The product is seventy-two worker-days, divided by twelve.
If y varies directly with x and inversely with z, doubling both x and z does what to y?|Leaves it unchanged|Doubles it;Halves it;Quadruples it|The two scale factors cancel in kx/z.
'''),
  grade8MathUnits[3],
  mathUnit(
      title: 'Parallelogram Properties and Proofs',
      aims: [
        'Use side and angle properties of parallelograms.',
        'Apply diagonal bisection.',
        'Distinguish rectangles, rhombi, and squares.'
      ],
      idea:
          'A parallelogram has both pairs of opposite sides parallel. Opposite sides and angles are equal, adjacent angles are supplementary, and diagonals bisect each other. A rectangle is a parallelogram with four right angles and equal diagonals. A rhombus has four equal sides and perpendicular diagonals. A square has both sets of properties. A diagonal divides a parallelogram into two congruent triangles, supporting the side and angle results.',
      model: {
        'ABCD in order': 'AB ∥ CD and BC ∥ AD',
        'Sides': 'AB = CD; BC = AD',
        'Angles': '∠A = ∠C; ∠A + ∠B = 180°',
        'Diagonals meet at O': 'AO = OC and BO = OD'
      },
      worked:
          'In parallelogram ABCD, angle A is 68°. Its adjacent angle B is 180 - 68 = 112°. Opposite angle C is 68° and D is 112°. If AO = 7 cm, diagonal AC is 14 cm because O is its midpoint.',
      tryIt:
          'Opposite sides have lengths 3x + 2 and 5x - 6. Find x and the side length. Must a rhombus have equal diagonals?',
      check:
          'Set 3x + 2 = 5x - 6, giving x = 4 and length fourteen. A rhombus need not have equal diagonals; a square does.',
      avoid:
          'Do not assume every parallelogram has right angles or equal diagonals. Bisecting means halving each diagonal, not making the two diagonals equal.',
      remember:
          'Use the properties guaranteed by the named figure, and no stronger properties without proof.',
      bank: '''
Opposite sides of a parallelogram are what?|Equal and parallel|Always perpendicular;Always unequal;Always curved|Both pairs are parallel and have equal lengths.
Adjacent angles in a parallelogram total what?|180°|90°;270°;360°|Parallel sides make them supplementary.
One angle is 75°. Its opposite angle is what?|75°|105°;90°;150°|Opposite angles are equal.
One angle is 75°. An adjacent angle is what?|105°|75°;15°;285°|Subtract seventy-five from 180.
Diagonals of every parallelogram do what?|Bisect each other|Are equal;Are perpendicular;Bisect all angles|Each divides the other into equal halves.
Which special parallelogram always has equal diagonals?|Rectangle|Any rhombus;Any slanted parallelogram;Any kite|Rectangle diagonals have equal lengths.
Which special parallelogram always has perpendicular diagonals?|Rhombus|Any rectangle;Any parallelogram;Any trapezoid|All rhombi have perpendicular diagonals.
Which figure is both a rectangle and a rhombus?|Square|Any kite;Any trapezoid;Any triangle|A square has right angles and four equal sides.
If a parallelogram diagonal is 18 cm, each half is what?|9 cm|18 cm;36 cm;6 cm|Its diagonals bisect each other.
Opposite sides 2x + 5 and 4x - 1 are equal. Find x.|3|2;4;6|Solve six equals two x.
A rectangle diagonal is 13 cm. What is the other diagonal?|13 cm|6.5 cm;26 cm;Cannot determine|Rectangle diagonals are equal.
'''),
  mathUnit(
      title: 'Trapezoids Kites and Triangle Midsegments',
      aims: [
        'Use the triangle midsegment theorem.',
        'Find trapezoid midsegment lengths.',
        'Apply kite diagonal properties.'
      ],
      idea:
          'A segment joining midpoints of two triangle sides is parallel to the third side and half its length. A trapezoid midsegment joins the leg midpoints; its length is the average of the two parallel bases. This lesson uses trapezoid for a quadrilateral with exactly one parallel pair. In an isosceles trapezoid, legs and base angles match. A kite has two pairs of adjacent equal sides; its diagonals are perpendicular, and the symmetry diagonal bisects the other.',
      model: {
        'Triangle': 'Base 14 cm → midpoint segment 7 cm',
        'Trapezoid': 'Bases 8 and 14 cm → midsegment 11 cm',
        'Kite diagonals': 'Perpendicular; area = d1d2/2',
        'Isosceles trapezoid': 'Matching legs and equal angles on each base'
      },
      worked:
          'A trapezoid midsegment is 12 cm and one base is 9 cm. Write 12 = (9 + b)/2. Multiply by two to get 24 = 9 + b. Subtract nine: the other base is 15 cm. Check their average is twelve.',
      tryIt:
          'A triangle midsegment is 6 cm. Find the parallel side. A kite has perpendicular diagonals 10 and 8 cm. Find area.',
      check:
          'The parallel triangle side is twice six, or twelve centimetres. Kite area is 10 × 8 ÷ 2 = 40 cm².',
      avoid:
          'A triangle midsegment is half the third side, while a trapezoid midsegment averages two bases. Do not assume both kite diagonals bisect each other.',
      remember:
          'Mark midpoints and parallel bases. Use the theorem that matches the actual figure.',
      bank: '''
Triangle base is 18 cm. Parallel midsegment length?|9 cm|18 cm;36 cm;6 cm|A triangle midsegment is half the third side.
Triangle midsegment is 11 cm. Parallel side length?|22 cm|5.5 cm;11 cm;33 cm|Double the midsegment.
Trapezoid bases are 6 and 14 cm. Midsegment?|10 cm|8 cm;20 cm;7 cm|Average the two bases.
Trapezoid bases are 9 and 15 cm. Midsegment?|12 cm|6 cm;24 cm;13 cm|Their sum twenty-four divided by two is twelve.
What is true of an isosceles trapezoid's legs?|They are equal|They are parallel;They are perpendicular;They are its diagonals|Isosceles specifies equal nonparallel sides.
Kite diagonals meet at what angle?|90°|60°;45°;180°|Kite diagonals are perpendicular.
Area of a kite with diagonals 6 and 12 cm?|36 cm²|72 cm²;18 cm²;24 cm²|Multiply diagonal lengths and divide by two.
Does every kite have both diagonals bisecting each other?|No|Yes;Only if rotated;Only if drawn large|Only the symmetry diagonal is guaranteed to bisect the other.
A trapezoid midsegment is 17 cm and one base is 12 cm. Other base?|22 cm|29 cm;5 cm;34 cm|Twice seventeen minus twelve is twenty-two.
A triangle midpoint segment parallels a 25 cm side. Length?|12.5 cm|50 cm;25 cm;10 cm|Half of twenty-five is twelve and a half.
An isosceles trapezoid has one lower base angle 65°. Other lower base angle?|65°|115°;90°;130°|Angles on the same base are equal.
'''),
  grade9MathUnits[3],
  grade10MathUnits[2],
  mathUnit(
      title: 'Elevation Depression and Oblique Triangles',
      aims: [
        'Model elevation and depression with horizontal reference lines.',
        'Apply the sine rule to known opposite pairs.',
        'Apply the cosine rule to SAS or SSS data.'
      ],
      idea:
          'An angle of elevation is measured upward from a horizontal line; depression is downward. Draw a right-triangle model before choosing a trig ratio. For any triangle, a/sin A = b/sin B = c/sin C with opposite labels matched. This is the sine rule. The cosine rule c² = a² + b² - 2ab cos C works with two sides and their included angle or three sides. A sine-rule SSA situation can have two solutions, so check geometric possibilities.',
      model: {
        'Elevation': 'Observer horizontal → angle θ → line of sight upward',
        'Right triangle': 'height / horizontal distance = tan θ',
        'Opposite pairs': 'a opposite A, b opposite B, c opposite C',
        'Cosine rule': 'Included angle C lies between a and b'
      },
      worked:
          'Two sides are 5 m and 8 m with included angle 60°. Use the cosine rule: c² = 25 + 64 - 2 × 5 × 8 × 1/2 = 49. Thus c = 7 m. Check seven is between |8 - 5| and 8 + 5.',
      tryIt:
          'A tree is 10 m away horizontally and the elevation to its top is 45° from ground level. Find height. In a triangle A = 30°, B = 90°, a = 4 cm. Find b.',
      check:
          'tan 45° = 1, so the tree is ten metres high in this ground-level model. By the sine rule b = 4 × sin 90° / sin 30° = 8 cm.',
      avoid:
          'Angles of elevation begin at the horizontal, not vertical. Opposite sides must match their angles in the sine rule. Include observer eye height when given.',
      remember:
          'Draw and label first. Use right-triangle ratios, sine rule, or cosine rule according to the given information.',
      bank: '''
An angle of elevation is measured from what?|Horizontal upward|Vertical upward;Ground distance alone;A circle centre|It starts at the observer's horizontal line.
An angle of depression is measured in which direction?|Downward from horizontal|Upward from vertical;Along a wall only;Around a full circle|The line of sight falls below horizontal.
For a ground-level observer 8 m from a tree at 45° elevation, height?|8 m|4 m;16 m;8√2 m|Height equals distance times tan 45 degrees.
Which ratio is the sine rule?|a/sin A = b/sin B|a/cos A = b/cos B;a + A = b + B;a sin A = b sin B|Match each side with its opposite angle.
Which data directly suit the cosine rule?|Two sides and included angle|Only one side;Only two angles;Only one angle|SAS determines the third side through cosine.
Sides 3 and 4 include a 90° angle. Third side?|5|7;1;25|Cosine ninety is zero, giving the Pythagorean result.
If A = 30°, B = 90°, a = 5, find b.|10|5;2.5;5√3|Five divided by sin thirty gives ten.
If a = b in a triangle, what follows?|A = B|A + B = 90° always;C = 90° always;A = 2B|Equal sides face equal angles.
Sides 6 and 6 include 60°. Third side?|6|12;3;6√2|The cosine rule gives 36 + 36 - 36 = 36.
Eye height 1.5 m, horizontal distance 10 m, elevation 45°. Total height?|11.5 m|10 m;8.5 m;15 m|Add eye height to the ten-metre rise.
Why check both angles for some sine-rule SSA problems?|A sine value can match two supplementary angles|Sine is always negative;All triangles are right;Side lengths can be negative|Both an acute and an obtuse candidate may fit unless other data rule one out.
'''),
];
