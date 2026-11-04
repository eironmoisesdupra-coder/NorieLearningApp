import '../authored/core_math_unit.dart';
import '../authored/grade10_mathematics_core.dart';
import 'mathematics_authoring.dart';

final depedMath10 = <CoreMathUnit>[
  mathUnit(
      title: 'Arithmetic Sequences and Finite Sums',
      aims: [
        'Recognize a constant difference.',
        'Find an arithmetic nth term and missing means.',
        'Calculate finite arithmetic sums.'
      ],
      idea:
          'A sequence is an ordered list. Arithmetic sequences have a constant difference d. Starting with a₁, term n is aₙ = a₁ + (n - 1)d because there are n - 1 steps. Pairing first and last terms gives equal pair sums, so Sₙ = n(a₁ + aₙ)/2. Arithmetic means inserted between endpoints divide the total change into equal steps.',
      model: {
        'Sequence': '5, 9, 13, 17, ...',
        'Difference': 'd = 4',
        'Nth term': 'aₙ = 5 + 4(n - 1) = 4n + 1',
        'First five sum': '5(5 + 21)/2 = 65'
      },
      worked:
          'Find the twentieth term and sum of 7, 10, 13, .... Difference is three. a₂₀ = 7 + 19 × 3 = 64. S₂₀ = 20(7 + 64)/2 = 710. Check the first and last sum to seventy-one and there are ten pairs.',
      tryIt:
          'Insert three arithmetic means between 4 and 20. Find the sum of the resulting five terms.',
      check:
          'There are four equal gaps, so d = (20 - 4)/4 = 4. The means are eight, twelve, sixteen. Sum = 5(4 + 20)/2 = 60.',
      avoid:
          'Use n - 1 differences for the nth term. A sum is not the same as the last term.',
      remember:
          'Count gaps, find a constant difference, and pair endpoints for a finite sum.',
      bank: '''
Common difference of 6, 11, 16, 21?|5|6;4;11|Subtract consecutive terms.
Next term of 20, 17, 14?|11|12;10;17|Subtract three again.
Nth term of 3, 7, 11, ...?|4n - 1|4n + 3;3n + 4;n + 4|Use three plus n minus one times four.
Tenth term if a₁ = 2 and d = 3?|29|32;27;30|Two plus nine threes equals twenty-nine.
First five terms 2,4,6,8,10 sum to what?|30|20;25;50|Five times first plus last divided by two is thirty.
Arithmetic mean between 8 and 18?|13|10;12;26|Average the endpoints.
How many gaps separate term 1 from term 12?|11|12;13;10|There is one fewer gap than terms.
Which sequence is not arithmetic?|2,4,8,16|2,5,8,11;10,8,6,4;7,7,7,7|Its differences double rather than stay constant.
Fifteenth term of 4,9,14,...?|74|79;69;75|Four plus fourteen times five equals seventy-four.
Sum of first 20 positive integers?|210|200;190;400|Use twenty times one plus twenty divided by two.
Which term of 5,8,11,... equals 50?|16th|15th;17th;18th|Solve five plus three times n minus one equals fifty.
'''),
  mathUnit(
      title: 'Geometric Sequences and Series',
      aims: [
        'Find and apply a common ratio.',
        'Calculate finite geometric sums.',
        'Determine when an infinite geometric sum exists.'
      ],
      idea:
          'A geometric sequence multiplies by a constant ratio r. Its nth term is aₙ = a₁rⁿ⁻¹. For r ≠ 1, the first n terms sum to Sₙ = a₁(1 - rⁿ)/(1 - r). For r = 1, use na₁. An infinite geometric series has a finite sum only when |r| < 1, giving S = a₁/(1 - r). Alternating signs are possible when r is negative.',
      model: {
        'Sequence': '3, 6, 12, 24, ...',
        'Ratio': 'r = 2',
        'Term': 'aₙ = 3 × 2ⁿ⁻¹',
        'Convergent sum': '8 + 4 + 2 + ... = 8/(1 - 1/2) = 16'
      },
      worked:
          'Find the first five terms sum of 2, 6, 18, .... Here a₁ = 2 and r = 3. S₅ = 2(1 - 3⁵)/(1 - 3) = 242. Check by listing 2 + 6 + 18 + 54 + 162 = 242. An infinite sum does not converge because the ratio is greater than one.',
      tryIt:
          'Find term six of 5, 10, 20, .... Find 6 + 3 + 1.5 + ... continued without end.',
      check:
          'Term six is 5 × 2⁵ = 160. The infinite series has ratio one half, so its sum is 6/(1 - 1/2) = 12.',
      avoid:
          'A constant ratio is not a constant difference. Do not use the infinite-sum formula when |r| ≥ 1.',
      remember:
          'Identify the ratio, count multiplication steps, and check convergence before summing forever.',
      bank: '''
Common ratio of 4,12,36,...?|3|8;4;12|Divide each term by the previous term.
Next term of 81,27,9,...?|3|0;6;1|Multiply by one third.
Fifth term of 2,4,8,...?|32|16;64;10|Use two times two to the fourth.
Common ratio of 3,-6,12,-24,...?|-2|2;-3;3|Each term is negative two times the previous.
Sum 1 + 2 + 4 + 8.|15|8;16;14|Add the four terms.
Does 1 + 2 + 4 + ... have a finite infinite sum?|No|Yes, it is -1;Yes, it is 2;Yes, it is 0|Its ratio two has magnitude greater than one.
Infinite sum 4 + 2 + 1 + ...?|8|4;6;16|Use four divided by one minus one half.
When does an infinite geometric series converge?|When the magnitude of r is less than 1|When r > 1;For every r;Only when r = 1|The terms then shrink enough for partial sums to approach a limit.
Seventh term of 3,6,12,...?|192|96;384;21|Three times two to the sixth equals 192.
Sum of first four terms of 5,15,45,...?|200|180;135;205|The terms are five, fifteen, forty-five, and 135.
Infinite sum 9 - 3 + 1 - 1/3 + ...?|27/4|6;9/4;27/2|The ratio is negative one third, so divide nine by four thirds.
'''),
  mathUnit(
      title: 'Polynomial Division and Root Theorems',
      aims: [
        'Divide polynomials and include missing powers.',
        'Use the remainder and factor theorems.',
        'Find candidate rational roots and verify factors.'
      ],
      idea:
          'Polynomial division finds quotient and remainder so dividend = divisor × quotient + remainder. Insert zero coefficients for missing powers. Dividing P(x) by x - c leaves remainder P(c). Therefore x - c is a factor exactly when P(c) = 0. For integer coefficients, a rational root in lowest form p/q must have p dividing the constant and q dividing the leading coefficient. These are candidates, not guaranteed roots.',
      model: {
        'Dividend': 'x³ - 6x² + 11x - 6',
        'Test x = 1': '1 - 6 + 11 - 6 = 0',
        'Division by x - 1': 'Quotient x² - 5x + 6; remainder 0',
        'Complete factors': '(x - 1)(x - 2)(x - 3)'
      },
      worked:
          'Divide 2x³ + 3x² - 5x + 6 by x + 2. Synthetic value is -2. Bring down 2, multiply and add to get -1, then -3, then remainder 12. Quotient is 2x² - x - 3. Check P(-2) = 12, so x + 2 is not a factor.',
      tryIt:
          'Find the remainder when x³ - 4x + 1 is divided by x - 2. Is x - 3 a factor of x² - 5x + 6?',
      check:
          'Evaluate at two: 8 - 8 + 1 = 1. Evaluate the second polynomial at three: 9 - 15 + 6 = 0, so x - 3 is a factor.',
      avoid:
          'For x + 2 use c = -2. A remainder must have lower degree than the divisor. A listed rational candidate is not yet a root.',
      remember:
          'Divide accurately, evaluate to check remainders, and use zero remainders to establish factors.',
      bank: '''
Remainder on dividing x² + 3x + 2 by x - 1?|6|0;2;3|Evaluate the polynomial at one.
Which value tests the factor x + 4?|-4|4;0;1/4|Write the divisor as x minus negative four.
Is x - 2 a factor of x² - 4?|Yes|No;Only if x is positive;Only after rounding|The value at two is zero.
Divide x² - 9 by x - 3.|Quotient x + 3, remainder 0|Quotient x - 3, remainder 0;Quotient x, remainder -9;Quotient 1, remainder 0|The dividend is a difference of squares.
Which coefficient list represents x³ - 2x + 5?|1, 0, -2, 5|1, -2, 5;1, 2, 5;0, 1, -2, 5|Include zero for the missing x-squared term.
If P(5) = 0, which is a factor?|x - 5|x + 5;x;5x + 1|The factor theorem connects the root five with x minus five.
Possible rational roots of monic x² - 5x + 6 come from divisors of what?|6|5;0;11|For a monic polynomial the denominator candidates are one.
For division by a linear polynomial, a remainder is what?|A constant|Always quadratic;Always the quotient;Higher degree than the dividend|Its degree must be less than one.
Remainder of 2x³ - x + 4 divided by x + 1?|3|-3;5;7|Evaluate at negative one: negative two plus one plus four.
Factor x³ - 6x² + 11x - 6 after finding roots 1,2,3.|(x - 1)(x - 2)(x - 3)|(x + 1)(x + 2)(x + 3);x(x - 1)(x - 2);(x - 1)³|Each root contributes its corresponding linear factor.
Quotient and remainder of x² + 1 divided by x - 1?|x + 1, remainder 2|x - 1, remainder 0;x + 1, remainder 0;x, remainder 1|Rebuild x² + 1 = (x - 1)(x + 1) + 2.
'''),
  mathUnit(
      title: 'Polynomial Functions and Graph Behaviour',
      aims: [
        'Use degree and leading coefficient for end behaviour.',
        'Relate root multiplicity to touching or crossing.',
        'Connect factors with intercepts and a context.'
      ],
      idea:
          'A polynomial function has nonnegative integer powers and real coefficients. Far from zero, its leading term controls end behaviour. Even degree has both ends in the same direction; odd degree has opposite directions. A positive leading coefficient makes the right end rise. A root of odd multiplicity crosses the x-axis; one of even multiplicity touches and turns. The y-intercept is the constant term. Degree n allows at most n real roots and n - 1 turning points.',
      model: {
        'Function': 'P(x) = (x + 1)(x - 2)²',
        'Zeros': '-1 crosses; 2 touches',
        'Y-intercept': 'P(0) = 4',
        'Ends': 'Positive cubic: left down, right up'
      },
      worked:
          'Sketch y = -(x - 1)²(x + 2). It is cubic with negative leading coefficient, so left end rises and right end falls. The root one has multiplicity two, so the graph touches there. It crosses at negative two. At x = 0, y = -2, locating the y-intercept.',
      tryIt:
          'For y = (x - 3)(x + 1), find degree, zeros, y-intercept, and end directions.',
      check:
          'It is a positive quadratic, with zeros three and negative one. At zero its value is negative three. Both ends rise.',
      avoid:
          'A graph may have fewer real roots than its degree. A repeated root is not a separate x-intercept at a new position.',
      remember:
          'Read leading term, factors, multiplicities, and intercepts before plotting selected points.',
      bank: '''
Degree of 5x⁴ - 2x + 7?|4|5;2;7|The highest nonzero power is four.
Right-end behaviour of a polynomial with positive leading coefficient?|Rises|Falls;Always zero;Always horizontal|The positive highest-power term dominates for large positive x.
Both ends of y = x⁴ rise or fall?|Rise|Fall;Left rises and right falls;Left falls and right rises|Even degree and positive leading coefficient make both ends rise.
Y-intercept of y = x³ - 4x + 6?|6|-4;1;0|Set x equal to zero.
Root 2 in (x - 2)² has what multiplicity?|2|1;3;4|The factor is squared.
At an even-multiplicity real root, a polynomial graph usually does what?|Touches without crossing|Crosses;Has a gap;Becomes a vertical line|Its sign does not change across that root.
Zeros of (x + 4)(x - 1)?|-4 and 1|4 and -1;4 and 1;-4 and -1|Set each factor equal to zero.
Maximum possible turning points for a cubic?|2|3;4;1|Degree minus one is the upper bound.
End behaviour of y = -2x³ + x?|Left rises, right falls|Both rise;Both fall;Left falls, right rises|Odd degree gives opposite ends and the leading sign is negative.
Y-intercept of (x - 2)(x + 3)(x - 1)?|6|-6;0;3|At zero multiply negative two, three, and negative one.
How many distinct x-intercepts has (x - 1)²(x + 2)³?|2|5;3;1|The two distinct roots are one and negative two.
'''),
  grade10MathUnits[3],
  mathUnit(
      title: 'Chords Tangents Secants and Circle Theorems',
      aims: [
        'Use chord and arc angle relationships.',
        'Apply tangent and intersecting-segment theorems.',
        'Distinguish interior and exterior circle angles.'
      ],
      idea:
          'An inscribed angle is half its intercepted arc. An angle formed by intersecting chords inside a circle is half the sum of intercepted opposite arcs. An exterior angle formed by secants or tangents is half the difference of the far and near arcs. A tangent is perpendicular to the radius at contact. Tangent segments from one exterior point are equal. Intersecting chord pieces satisfy a × b = c × d; an external tangent t and secant satisfy t² = external part × whole secant.',
      model: {
        'Inside chords': 'Angle = (arc1 + arc2)/2',
        'Outside secants': 'Angle = (far arc - near arc)/2',
        'Chord products': '3 × 8 = 4 × 6',
        'Tangent-secant': 't² = 4 × (4 + 5) = 36'
      },
      worked:
          'Two secants from an exterior point have external and whole lengths 3 and 12 on the first, 4 and x on the second. Use 3 × 12 = 4x, so x = 9. The inside portion on the second is 9 - 4 = 5. Check whole lengths exceed their external portions.',
      tryIt:
          'Intersecting chord pieces are 2 and 12 on one chord, 3 and x on the other. Find x. Far and near arcs for an exterior angle are 140° and 60°. Find the angle.',
      check:
          'Use 2 × 12 = 3x, so x = 8. The exterior angle is half of 140 - 60, or forty degrees.',
      avoid:
          'The secant product uses external times whole, not external times internal. Interior chord angles use a sum; exterior angles use a difference.',
      remember:
          'Draw the point location and label whole versus partial segments before selecting a theorem.',
      bank: '''
Radius and tangent at contact meet at what angle?|90°|45°;180°;60°|A tangent is perpendicular to the contact radius.
Two tangents from one external point have lengths 7 and x. Find x.|7|14;3.5;49|Their tangent segments are equal.
An inscribed angle intercepts a 100° arc. Angle?|50°|100°;200°;25°|Take half the intercepted arc.
Intersecting chords intercept opposite arcs 80° and 120°. Angle?|100°|20°;200°;40°|Take half their sum.
Exterior secants intercept far arc 160° and near arc 60°. Angle?|50°|110°;100°;80°|Take half their difference.
Chord pieces 3 and 10 match pieces 5 and x. Find x.|6|15;2;8|Thirty equals five x.
A tangent t and secant external 4, whole 9 satisfy t = what?|6|36;13;5|The square of t is thirty-six.
External part is 3 and internal part 7. Whole secant length?|10|7;4;21|The whole includes both parts.
Secants have external/whole pairs 2,18 and 3,x. Find x.|12|6;9;27|Two times eighteen equals three x.
A tangent radius is 5 and exterior-point distance to centre is 13. Tangent length?|12|8;18;√194|The right triangle gives t² = 169 - 25 = 144.
Equal chords in the same circle subtend what kind of minor arcs?|Equal arcs|Always semicircles;Unequal arcs;Always 90° arcs|Equal chords correspond to equal central angles and arcs.
'''),
  mathUnit(
      title: 'Coordinate Distance and Circle Equations',
      aims: [
        'Find distances and midpoints on the Cartesian plane.',
        'Write a circle equation from centre and radius.',
        'Complete squares to recover a centre and radius.'
      ],
      idea:
          'Distance between (x₁,y₁) and (x₂,y₂) follows from a right triangle: d = √[(x₂ - x₁)² + (y₂ - y₁)²]. A midpoint averages each coordinate. A circle contains points at one fixed distance r from its centre (h,k), giving (x - h)² + (y - k)² = r². In expanded form, complete both squares and balance any added constants to recover the centre and radius.',
      model: {
        'Points': 'A(1,2), B(7,10)',
        'Distance': '√(6² + 8²) = 10',
        'Midpoint': '((1+7)/2, (2+10)/2) = (4,6)',
        'Circle': 'Centre (3,-2), radius 5: (x - 3)² + (y + 2)² = 25'
      },
      worked:
          'Find the centre and radius of x² + y² - 6x + 4y - 12 = 0. Move the constant: x² - 6x + y² + 4y = 12. Add nine and four on both sides: (x - 3)² + (y + 2)² = 25. Thus centre is (3,-2) and radius five.',
      tryIt:
          'Write the circle with centre (-1,4) and radius 3. Find the midpoint of (-2,1) and (6,5).',
      check: 'The equation is (x + 1)² + (y - 4)² = 9. The midpoint is (2,3).',
      avoid:
          'The right side is radius squared, not radius. Inside a square the centre signs are reversed. Average coordinates separately.',
      remember:
          'Distance builds the circle equation. Complete both squares and preserve equality.',
      bank: '''
Distance from (0,0) to (3,4)?|5|7;25;1|Square the differences and take the square root.
Midpoint of (2,4) and (8,10)?|(5,7)|(6,6);(10,14);(3,3)|Average the x coordinates and y coordinates.
Centre of (x - 2)² + (y + 5)² = 16?|(2,-5)|(-2,5);(2,5);(-2,-5)|Read h and k from the shifted squares.
Radius of x² + y² = 49?|7|49;14;√7|The right side is r squared.
Circle centre (0,0), radius 3 has equation what?|x² + y² = 9|x² + y² = 3;x + y = 9;x² - y² = 9|Use the distance squared from the origin.
Which point lies on x² + y² = 25?|(3,4)|(2,4);(5,5);(1,1)|Nine plus sixteen equals twenty-five.
Midpoint of (-4,2) and (2,-6)?|(-1,-2)|(-2,-4);(1,2);(-3,4)|Average negative four and two, then two and negative six.
Distance between (1,1) and (1,8)?|7|9;6;49|Only the vertical coordinate changes.
Circle centre (-3,2), radius 4 has equation what?|(x + 3)² + (y - 2)² = 16|(x - 3)² + (y + 2)² = 16;(x + 3)² + (y - 2)² = 4;(x - 3)² + (y - 2)² = 16|Use opposite signs inside squares and square the radius.
Centre of x² + y² + 4x - 6y - 3 = 0?|(-2,3)|(2,-3);(-4,6);(4,-6)|Complete squares to get (x + 2)² + (y - 3)² = 16.
Radius of x² + y² - 8x + 2y + 8 = 0?|3|9;4;√17|Complete squares: (x - 4)² + (y + 1)² = 9.
'''),
  grade10MathUnits[4],
  mathUnit(
      title: 'Measures of Position in Ungrouped Data',
      aims: [
        'Sort observations and locate quartiles.',
        'Interpret deciles and percentiles.',
        'State the positional convention being used.'
      ],
      idea:
          'Quartiles divide ordered data into four parts, deciles into ten, and percentiles into one hundred. The median is Q2 and P50. This lesson uses locator L = k(n + 1)/100 for Pk, with linear interpolation between neighbouring observations when L is fractional; Q1 uses k = 25 and Q3 uses k = 75. Other software conventions can differ, especially for small samples, so state the rule. A percentile is a position in a distribution, not a percent score on a test.',
      model: {
        'Ordered data': '10,20,30,40,50,60,70,80,90',
        'Q1 locator': '(9 + 1)/4 = 2.5 → 25',
        'Q2': '5th value = 50',
        'Q3 locator': '3(9 + 1)/4 = 7.5 → 75'
      },
      worked:
          'Find P60 of 2,4,6,8,10,12,14,16,18. There are nine observations. The locator is 0.60 × 10 = 6. The sixth observation is twelve. Thus P60 is twelve under this convention. For Q1 the locator is 2.5, halfway between four and six, giving five.',
      tryIt:
          'Using the model data, find D4 and P80. What does an 80th-percentile score describe?',
      check:
          'D4 = P40 has locator four, giving forty. P80 has locator eight, giving eighty. An 80th-percentile score is a relative standing: about eighty percent of observations are at or below it, with ties and convention affecting exact counts.',
      avoid:
          'Sort first. Do not read the percentile number itself as the data value. With tiny samples, some extreme locators fall outside the data; this lesson avoids those cases.',
      remember:
          'State the convention, calculate the locator, interpolate if needed, and interpret relative standing rather than test percent.',
      bank: '''
What must be done before locating quartiles?|Sort the data|Multiply all values;Remove the largest;Divide each score by 100|Positions refer to ordered observations.
Which quartile is the median?|Q2|Q1;Q3;Q4|The second quartile divides data in half.
P50 is equivalent to what?|Median|Maximum;Minimum;Range|The fiftieth percentile is the central position.
How many parts do deciles describe?|10|4;100;2|Deciles divide the distribution into ten shares.
D7 is which percentile?|P70|P7;P75;P30|Seven tenths equals seventy percent.
For n = 9, the P30 locator using k(n+1)/100 is what?|3|2.7;30;9|Multiply thirty hundredths by ten.
Model data Q1 under the stated convention?|25|20;30;10|Interpolate halfway between the second and third observations.
Model data Q3 under the stated convention?|75|70;80;90|The locator is 7.5, halfway between seventy and eighty.
In 5,10,15,20,25,30,35,39,45, what is P60 under the stated rule?|30|25;35;60|The sixth ordered value is thirty.
Being at the 90th percentile means what?|High relative standing in that group|Exactly 90% correct always;A raw score of 90 always;Higher than everyone|Percentiles describe rank relative to a distribution.
Why state the percentile convention?|Different valid locator rules can give different results|Only one rule exists in all software;It changes the data;It makes sorting unnecessary|Small-sample percentile methods can interpolate differently.
'''),
  mathUnit(
      title: 'Grouped Positions and Statistical Investigation',
      aims: [
        'Locate a percentile class using cumulative frequencies.',
        'Estimate a grouped percentile with class boundaries.',
        'Plan and interpret an ethical small statistical study.'
      ],
      idea:
          'Grouped data lose exact individual values. For a grouped percentile estimate use Pk = L + [(kN/100 - cf)/f]w, where L is the lower class boundary, cf the cumulative frequency before the class, f the class frequency, and w its width. This assumes values spread evenly inside the class and is an estimate. A statistical investigation asks a clear question, identifies a population and sample, obtains consent, records data, selects suitable summaries, and reports limits without claiming causation from a simple association.',
      model: {
        'Classes and counts': '0–9: 2; 10–19: 6; 20–29: 2; N = 10',
        'Cumulative counts': '2, 8, 10',
        'Median class': '10–19 because N/2 = 5 lies after 2 and at or before 8',
        'Estimate inputs': 'L = 9.5, cf = 2, f = 6, w = 10'
      },
      worked:
          'Estimate the grouped median from the model. The target count is five. The median class is 10–19 with lower boundary 9.5. Compute 9.5 + [(5 - 2)/6] × 10 = 14.5. Report this as an estimate; grouped data do not reveal the exact median of original observations.',
      tryIt:
          'For classes 0–9: 4, 10–19: 4, 20–29: 2, estimate P50 with the same boundary convention. What limitation follows from surveying only one class about the whole school?',
      check:
          'Target count is five, in 10–19. Use 9.5 + [(5 - 4)/4] × 10 = 12.0. One class may not represent the school, so generalization is limited.',
      avoid:
          'Use class boundaries rather than lower stated limits when the formula requires boundaries. Do not expose identifiable learner scores or infer cause from association alone.',
      remember:
          'Locate with cumulative counts, interpolate transparently, and report sampling and grouping limitations.',
      bank: '''
What is cumulative frequency?|Running total of frequencies|Only the largest count;Class width;Mean of boundaries|Each class adds to all earlier counts.
For counts 3,5,2, the cumulative counts are what?|3,8,10|3,5,2;3,15,30;0,3,5|Add frequencies successively.
For integer class 10–19, conventional continuous lower boundary is what?|9.5|10;19;19.5|A half-unit adjustment separates adjacent whole-number classes.
For class 10–19 with boundaries 9.5 and 19.5, width is what?|10|9;19;9.5|Subtract lower boundary from upper boundary.
In the model, which is the median class?|10–19|0–9;20–29;None|The fifth observation lies in cumulative positions three through eight.
In the model, cf before the median class equals what?|2|6;8;10|Only the first class precedes it.
Why is a grouped percentile usually an estimate?|Exact within-class values are unknown|Frequencies cannot be counted;All data are wrong;The total is missing always|Interpolation makes an assumption about unseen within-class positions.
What should come first in a statistical study?|A clear question and target population|A desired conclusion;A decorative graph;Deleting unusual values|The question guides what data should be collected.
Target is P75 in N = 40 grouped observations. Target count?|30|75;10;40|Compute 0.75 times forty.
L = 19.5, target = 15, cf = 10, f = 10, w = 10. Percentile estimate?|24.5|29.5;20;15|Add half a class width to the lower boundary.
Two measured variables rise together. What can a small observational study conclude safely?|They are associated in the sample|One certainly causes the other;Both are identical;No limitations matter|Association alone does not establish cause.
'''),
];
