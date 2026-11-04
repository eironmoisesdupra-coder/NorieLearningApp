import '../authored/core_math_unit.dart';
import '../authored/grade6_mathematics_core.dart';
import '../authored/grade7_mathematics_core.dart';
import 'mathematics_authoring.dart';

final depedMath7 = <CoreMathUnit>[
  mathUnit(
      title: 'Polygon Angles and Classification',
      aims: [
        'Classify regular, irregular, convex, and non-convex polygons.',
        'Relate adjacent interior and exterior angles.',
        'Calculate angle sums and side counts.'
      ],
      idea:
          'A polygon is a simple closed figure of straight segments. Regular polygons have equal sides and equal interior angles. A convex polygon has every interior angle less than 180°; a non-convex polygon has an inward corner greater than 180°. Draw diagonals from one vertex of a convex n-sided polygon to form n - 2 triangles. Its interior sum is (n - 2) × 180°. One exterior angle at each vertex, taken in the same direction, sums to 360°. An interior angle and its adjacent exterior angle sum to 180°.',
      model: {
        'Pentagon': '5 sides; interior sum = 3 × 180° = 540°',
        'Regular hexagon': 'Interior 120°; exterior 60°',
        'Regular octagon': 'Interior 135°; exterior 45°',
        'Side count': 'n = 360° ÷ regular exterior angle'
      },
      worked:
          'A regular polygon has exterior angle 36°. Divide 360 by 36 to obtain ten sides. Its adjacent interior angle is 180 - 36 = 144°. Check its interior sum: 10 × 144 = 1440°, equal to (10 - 2) × 180.',
      tryIt:
          'Find each interior angle of a regular pentagon. What exterior angle belongs to a regular octagon?',
      check:
          'The pentagon sum is 540°, so each angle is 108°. An octagon exterior angle is 360 ÷ 8 = 45°.',
      avoid:
          'The interior sum is not 360° for every polygon. The division 360/n gives exterior, not interior, angles.',
      remember:
          'Use triangle partitions for interior sums and one full turn for exterior sums.',
      bank: '''
Interior angle sum of a hexagon?|720°|360°;540°;1080°|Six minus two gives four triangles of 180 degrees.
Each exterior angle of a regular pentagon?|72°|108°;60°;120°|Divide a full turn by five.
Each interior angle of a regular octagon?|135°|45°;120°;140°|Subtract its 45-degree exterior angle from 180.
A regular polygon has exterior angle 30°. Sides?|12|6;10;15|360 divided by 30 equals twelve.
A regular polygon has ten sides. Interior sum?|1440°|1800°;1080°;360°|Eight triangles give 1440 degrees.
Adjacent interior and exterior angles total what?|180°|90°;270°;360°|They form a straight angle.
What makes a polygon non-convex?|An interior angle greater than 180°|Any unequal side;All sides equal;Exactly five sides|A reflex inward corner makes a simple polygon non-convex.
Is every equal-sided polygon regular?|No, its angles must also be equal|Yes always;Only if red;Only if rotated|Equal angles and equal sides are both needed.
A regular hexagon has side 7 cm. Perimeter?|42 cm|49 cm;35 cm;14 cm|Six equal sides total six times seven.
A polygon's interior sum is 900°. How many sides?|7|5;6;8|Solve (n - 2)180 = 900 to get n = 7.
Interior angle is 156° in a regular polygon. Side count?|15|12;24;30|Exterior is 24 degrees, and 360 divided by 24 is fifteen.
'''),
  grade6MathUnits[1],
  grade6MathUnits[0],
  grade7MathUnits[0],
  mathUnit(
      title: 'Roots and Real Number Subsets',
      aims: [
        'Find square roots of perfect squares and cube roots of perfect cubes.',
        'Identify rational and irrational numbers.',
        'Locate an irrational root between integers.'
      ],
      idea:
          'The principal square root of a nonnegative number is nonnegative: √49 = 7. A cube root reverses cubing, so ∛(-8) = -2. An integer ratio with nonzero denominator is rational. Terminating and repeating decimals are rational. An irrational number cannot be written as such a ratio; √2 is an example. Whole numbers fit inside integers, integers inside rational numbers, and rational numbers inside real numbers. Irrational numbers are real but not rational.',
      model: {
        'Square model': 'An 8 by 8 square has area 64, so √64 = 8',
        'Cube model': 'A 3 by 3 by 3 cube has volume 27, so ∛27 = 3',
        'Bounds': '9 < 11 < 16, so 3 < √11 < 4',
        'Subsets': 'Whole ⊂ integers ⊂ rational ⊂ real'
      },
      worked:
          'Classify √50 and locate it. Seven squared is 49 and eight squared is 64. Thus √50 is between seven and eight. Fifty is not a perfect square, so its root is irrational. It is still a real number.',
      tryIt: 'Find √121 and ∛64. Between which integers does √30 lie?',
      check:
          'Eleven squared is 121 and four cubed is 64. Since 25 < 30 < 36, √30 lies between five and six.',
      avoid:
          '√36 means six, not plus or minus six; x² = 36 has two solutions. A long decimal is not automatically irrational.',
      remember:
          'Use known squares and cubes to reverse powers and bound roots. Classify by exact number properties.',
      bank: '''
What is √81?|9|8;18;±9|The principal square root is nonnegative and nine squared is 81.
What is ∛125?|5|25;3;15|Five cubed equals 125.
What is ∛(-27)?|-3|3;-9;9|Negative three cubed is negative twenty-seven.
Which number is irrational?|√3|0.75;-4;2/7|Three is not a perfect square.
Which subset contains -5 but not 1/2?|Integers|Whole numbers;Natural numbers only;Irrational numbers|Integers include negative whole-number values but not fractional halves.
Between which integers is √20?|4 and 5|3 and 4;5 and 6;2 and 3|Sixteen is less than twenty and twenty less than twenty-five.
Is 0.333... with threes repeating rational?|Yes, it equals 1/3|No, every endless decimal is irrational;No, it has no value;Only if rounded|Repeating decimals can be written as integer ratios.
What is √0?|0|1;Undefined;-1|Zero squared is zero.
Between which integers is √70?|8 and 9|7 and 8;9 and 10;6 and 7|Sixty-four and eighty-one bound seventy.
Which statement is true?|Every integer is rational|Every rational is an integer;Every real is rational;Every irrational is whole|An integer can be written over denominator one.
What is √144 + ∛8?|14|10;16;20|Twelve plus two equals fourteen.
'''),
  mathUnit(
      title: 'Unit Conversions Cylinders and Pyramids',
      aims: [
        'Convert within SI and across stated measurement systems.',
        'Derive cylinder volume from circular layers.',
        'Compare pyramid volume with a matching prism.'
      ],
      idea:
          'A conversion changes units without changing an amount. Multiply by a ratio equal to one, such as 100 cm / 1 m. For different systems use the given fact, such as 1 inch = 2.54 cm. A cylinder stacks equal circular layers; V = πr²h. A rectangular pyramid holds one third of the volume of a prism with the same base and perpendicular height: V = lwh/3.',
      model: {
        'SI conversion': '2.5 m × 100 cm/m = 250 cm',
        'Across systems': '10 inches × 2.54 cm/inch = 25.4 cm',
        'Cylinder': 'Base area πr², height h',
        'Pyramid': 'Base area lw; perpendicular height h; V = lwh/3'
      },
      worked:
          'A square pyramid has base side 6 cm and height 10 cm. Base area is 36 cm². The matching prism volume is 360 cm³. Divide by three: pyramid volume is 120 cm³. Check cubic rather than square units.',
      tryIt:
          'Using π = 3.14, find the volume of a cylinder of radius 2 cm and height 8 cm. Convert 4 inches using 2.54 cm per inch.',
      check:
          'Cylinder volume is 3.14 × 4 × 8 = 100.48 cm³. Four inches equal 10.16 cm.',
      avoid:
          'Do not use diameter as radius. A pyramid slant height is not its perpendicular height. Cubic conversions cube the length factor.',
      remember:
          'Label dimensions and units first. Cylinder volume stacks bases; pyramid volume takes one third of a matching prism.',
      bank: '''
Convert 3.2 km to metres.|3200 m|320 m;32 m;0.0032 m|Multiply by one thousand.
Convert 4500 g to kilograms.|4.5 kg|45 kg;450 kg;0.45 kg|Divide by one thousand.
Using 1 inch = 2.54 cm, convert 5 inches.|12.7 cm|7.54 cm;25.4 cm;2 cm|Multiply five by 2.54.
Using 1 foot = 12 inches, convert 3 feet.|36 inches|15 inches;4 inches;24 inches|Three groups of twelve equal thirty-six.
A cylinder has radius 3 cm and height 4 cm. Exact volume?|36π cm³|12π cm³;24π cm³;9π cm³|Square three, multiply by four and pi.
A rectangular pyramid has base 5 by 6 cm and height 9 cm. Volume?|90 cm³|270 cm³;45 cm³;180 cm³|Multiply base area thirty by nine and divide by three.
A pyramid and prism share base and height. Pyramid volume is what fraction of prism volume?|1/3|1/2;2/3;3|The volume comparison gives one third.
What height is used in a pyramid volume formula?|Perpendicular height|Any sloping edge;Base diagonal;Perimeter|Height measures the perpendicular distance to the base plane.
Convert 1 m³ to cm³.|1000000 cm³|100 cm³;1000 cm³;10000 cm³|Cube the factor one hundred.
A cylinder diameter is 10 cm and height 2 cm. Exact volume?|50π cm³|200π cm³;20π cm³;100π cm³|The radius is five, so volume is pi times twenty-five times two.
A square pyramid has volume 48 cm³ and base area 16 cm². Height?|9 cm|3 cm;6 cm;12 cm|Solve 48 = 16h/3 to obtain nine.
'''),
  mathUnit(
      title: 'Sets Subsets and Venn Regions',
      aims: [
        'Describe well-defined sets and subsets.',
        'Find unions and intersections.',
        'Use Venn regions without double-counting.'
      ],
      idea:
          'A set is a collection with clear membership. Write its elements inside braces. A subset has every element in the larger set. The intersection A ∩ B contains shared elements. The union A ∪ B contains elements in either set, counting shared elements only once. In a Venn diagram the overlap is the intersection. A universal set gives the full collection being considered, so a complement means outside the set but still inside that universe.',
      model: {
        'A': '{1, 2, 3, 4}',
        'B': '{3, 4, 5}',
        'Overlap A ∩ B': '{3, 4}',
        'Either A ∪ B': '{1, 2, 3, 4, 5}'
      },
      worked:
          'In a class of thirty, eighteen play chess, fourteen play badminton, and six play both. Chess only is 18 - 6 = 12; badminton only is 14 - 6 = 8. The union is 12 + 6 + 8 = 26. Four play neither. Check all four regions total thirty.',
      tryIt:
          'Let U = {1, 2, 3, 4, 5, 6}, A = {2, 4, 6}, B = {1, 2, 3}. Find A ∩ B and the complement of A.',
      check:
          'Only two is shared, so the intersection is {2}. The universal elements outside A are {1, 3, 5}.',
      avoid:
          'Union does not count repeated members twice. A complement depends on the named universal set.',
      remember:
          'Place shared members in the overlap first. Subsets preserve membership, not size alone.',
      bank: '''
For A = {1,2,3} and B = {3,4}, what is A ∩ B?|{3}|{1,2,3,4};{1,2};{4}|Three is the only shared element.
For A = {1,2} and B = {2,3}, what is A ∪ B?|{1,2,3}|{2};{1,2,2,3};{1,3}|Union includes either set without duplicate members.
Which is a subset of {2,4,6}?|{2,6}|{2,5};{1};{8}|Every listed element must belong to the larger set.
How many elements are in {a,b,c}?|3|1;2;6|Count each distinct member once.
What does an empty set contain?|No elements|Zero as its only element;Every number;One blank element|Having no members differs from containing the number zero.
In a Venn diagram, what is the overlap?|Intersection|Union only;Universal boundary;Complement of both|It contains members shared by both sets.
U = {1,2,3,4}, A = {2,4}. Complement of A?|{1,3}|{2,4};{1,2,3,4};{5}|Use members of U outside A.
Two disjoint sets have what intersection?|Empty set|Their union;Both sets;The universe|Disjoint sets share no members.
There are 12 in A, 9 in B, and 4 in both. How many in the union?|17|21;25;5|Add twelve and nine, then subtract the double-counted four.
Out of 25 learners, 20 are in A ∪ B. How many in neither?|5|20;45;0|Subtract the union from the universal total.
A has 15 members and 7 are also in B. How many in A only?|8|22;7;15|Remove the overlap from A.
'''),
  mathUnit(
      title: 'Sampling Frequency Tables and Graph Choice',
      aims: [
        'Distinguish a population from a sample.',
        'Organize values in frequency and stem-and-leaf displays.',
        'Choose and interpret bar, line, and pie graphs.'
      ],
      idea:
          'A population is the whole group of interest. A sample is a smaller group used to learn about it. Random selection helps avoid choosing only convenient or similar people. A frequency counts how often a value appears. Bar graphs compare categories, line graphs show change over ordered time, and pie graphs show shares of one total. A stem-and-leaf plot keeps original numbers by separating tens and ones; always provide its key.',
      model: {
        'Data': '12, 14, 14, 18, 21, 23',
        'Stem 1': 'Leaves 2, 4, 4, 8',
        'Stem 2': 'Leaves 1, 3',
        'Key': '1 | 2 means 12, not 1.2'
      },
      worked:
          'For 2, 3, 2, 4, 3, 2, count frequency: two occurs three times, three twice, four once. Sum frequencies to get six, matching the data count. To estimate travel choices of the whole school, randomly sample learners across grades instead of asking only a cycling club.',
      tryIt:
          'In the model, how many values are at least twenty? Which graph fits daily temperature over a week?',
      check:
          'The stem two has two leaves, so two values are at least twenty. A line graph is suitable for ordered daily temperatures.',
      avoid:
          'A large biased sample can still mislead. Read graph scales: a cut-off axis can exaggerate differences.',
      remember:
          'Select a sample that represents the population. Count every observation and choose a graph that matches the question.',
      bank: '''
What is a sample?|A selected part of a population|The entire population always;Only the largest value;A graph title|It is a subset studied to learn about the whole.
Which school travel survey is less biased?|Random learners from all grades|Only cyclists;Only one friendship group;Only late arrivals|Broader random selection avoids restricting travel types.
Frequency of 4 in 4, 2, 4, 3, 4?|3|2;4;5|The value four appears three times.
Which graph fits monthly rainfall over one year?|Line graph|Unlabelled picture;Venn diagram;Only a shape net|Ordered time changes suit a line graph.
Which graph compares favourite fruit categories?|Bar graph|Number line only;Triangle diagram;Clock face|Separate bars compare category counts.
What must pie-graph sectors total?|100%|50%;200%;360%|All categories together make the full data total.
With stem 2 and leaf 5 meaning 25, what do stem 3 and leaf 7 mean?|37|3.7;73;10|Stem is tens and leaf is ones.
Model data median for 12,14,14,18,21,23?|16|14;18;17|Average the two middle values fourteen and eighteen.
Frequencies are 5, 8, 7. Total observations?|20|15;56;13|Add all category frequencies.
A graph axis begins at 95 rather than 0. What should a reader do?|Check whether the scale exaggerates differences|Ignore labels;Assume all values are under five;Treat bars as exact percentages|The truncated baseline can change visual impressions.
What graph keeps each original two-digit value?|Stem-and-leaf plot|Pie chart alone;Bar chart with only totals;Unlabelled line|Each leaf preserves one observed number.
'''),
  grade6MathUnits[2],
  grade7MathUnits[2],
  grade7MathUnits[3],
  mathUnit(
      title: 'Formulas and Nonnegative Unknowns',
      aims: [
        'Build equations from bar models.',
        'Evaluate expressions by substitution.',
        'Rearrange a formula using equality.'
      ],
      idea:
          'A variable stands for a value that may be unknown or change. A constant is a fixed value. Three equal boxes and two loose beads totalling seventeen make 3x + 2 = 17. Equality stays true when the same operation is applied to both sides. A formula connects named quantities. From P = 2l + 2w, subtract 2w and divide by two to make l the subject: l = (P - 2w)/2.',
      model: {
        'Bar model': '[x][x][x] + 2 = 17',
        'Remove 2': '[x][x][x] = 15',
        'Equal groups': 'x = 15 ÷ 3 = 5',
        'Formula': 'A = bh → h = A/b when b ≠ 0'
      },
      worked:
          'A taxi charges a fixed ₱40 plus ₱12 per kilometre. A ₱100 trip gives 40 + 12d = 100. Subtract forty to get 12d = 60. Divide by twelve: d = 5 km. Check 40 + 12 × 5 = 100 and the distance is nonnegative.',
      tryIt: 'Solve 4x + 7 = 31. Rearrange v = d/t to make d the subject.',
      check:
          'Subtract seven to obtain 4x = 24, then divide by four: x = 6. Multiply v = d/t by t to obtain d = vt, with t nonzero in the starting formula.',
      avoid:
          'Apply an operation to both sides, not just one term. Substitution requires multiplication signs or clear brackets.',
      remember:
          'Translate the relationship, keep equality balanced, and check the value in its original context.',
      bank: '''
Translate five more than twice n.|2n + 5|5n + 2;2(n + 5);n + 7|Twice the number is formed before adding five.
Evaluate 3x + 4 for x = 2.|10|14;9;6|Substitute two: six plus four equals ten.
Solve x + 8 = 19.|11|27;10;12|Subtract eight from both sides.
Solve 5x = 35.|7|30;40;5|Divide both sides by five.
Solve 2x + 3 = 17.|7|10;8;5|Subtract three, then divide fourteen by two.
In 6a + 9, which is the variable?|a|6;9;15|The letter names a changeable or unknown value.
From A = lw, make w the subject for l ≠ 0.|w = A/l|w = Al;w = A - l;w = l/A|Divide both sides by length.
From P = 2l + 2w, make l the subject.|l = (P - 2w)/2|l = P - w;l = P/2 + w;l = 2P - w|Subtract twice width, then divide by two.
Solve 6x - 5 = 25.|5|4;6;30|Add five to get thirty, then divide by six.
An item costs ₱15 each plus ₱10 delivery. Total ₱85. Number of items?|5|6;7;4|Solve 15n + 10 = 85.
Given C = 2πr, what is r?|C/(2π)|2πC;C - 2π;2C/π|Divide both sides by the nonzero factor two pi.
'''),
  mathUnit(
      title: 'Experimental Outcomes and Relative Frequency',
      aims: [
        'Record repeated experimental outcomes.',
        'Represent outcomes in tables.',
        'Use relative frequency without assuming certainty.'
      ],
      idea:
          'An experiment can have different outcomes, such as heads and tails in a coin toss. A trial is one repetition. Define the event before collecting data, then record every result. Relative frequency is event count divided by trials. It estimates how often an event has occurred. More repetitions may stabilize an estimate, but earlier results do not force the next independent result.',
      model: {
        'Trials': '20 coin tosses',
        'Heads': '12 tallies → frequency 12',
        'Tails': '8 tallies → frequency 8',
        'Relative frequency': 'Heads 12/20 = 0.6; tails 8/20 = 0.4'
      },
      worked:
          'A die is rolled forty times. A prime face appears eighteen times. The prime faces on a normal die are two, three, and five. The observed relative frequency is 18/40 = 0.45. Report this as 45% of these trials, not a guarantee of the next forty trials.',
      tryIt:
          'Red occurs 21 times in 60 draws with replacement. Find the relative frequency. What counts as one trial?',
      check:
          '21/60 = 7/20 = 35%. One trial is one draw followed by returning the counter, so the bag contents reset.',
      avoid:
          'Do not discard unwanted results. State whether counters are replaced because this changes later available outcomes.',
      remember:
          'Define, repeat, record, and divide event count by total trials. Describe the data without promising future outcomes.',
      bank: '''
One repetition of an experiment is called what?|Trial|Population;Variable only;Average|A trial is one performed experiment.
Heads occurs 14 times in 25 tosses. Relative frequency?|14/25|14/11;25/14;1/14|Use heads count divided by all tosses.
Blue occurs 9 times in 30 draws. Observed percent?|30%|9%;21%;90%|Nine thirtieths equals three tenths.
Which faces are prime on a die labelled 1 to 6?|2, 3, 5|1, 2, 3;2, 4, 6;1, 3, 5|One is not prime and four and six are composite.
Frequencies are 6 heads and 4 tails. Trial total?|10|2;24;6|Add every outcome count.
What should a frequency table include?|Every trial outcome|Only successful trials;Only expected outcomes;Only the first trial|Complete recording prevents biased frequencies.
Does a fair coin remember previous tosses?|No|Yes;Only after ten tosses;Only after heads|Independent tosses do not retain prior outcomes.
An event occurs zero times in 10 trials. Is it necessarily impossible?|No|Yes;Only on a die;Always certain|A possible event may fail to appear in a small set of trials.
An event occurs 32 times in 80 trials. Relative frequency?|0.4|0.32;0.8;2.5|Divide 32 by 80.
What does drawing with replacement mean?|Return the object before the next draw|Remove it permanently;Change its colour;Always choose another bag|Returning it resets the contents.
A table lists frequencies 8, 12, and 5. What percent belongs to frequency 5?|20%|5%;25%;50%|There are twenty-five trials, and five twenty-fifths is twenty percent.
'''),
  mathUnit(
      title: 'Scientific Notation and Powers of Ten',
      aims: [
        'Write large and small numbers in scientific notation.',
        'Multiply and divide scientific notation.',
        'Align powers before addition or subtraction.'
      ],
      idea:
          'Scientific notation is a × 10ⁿ with 1 ≤ a < 10 and integer n. Positive exponents make large numbers and negative exponents make small ones. In products multiply coefficients and add exponents; in quotients divide coefficients and subtract exponents. For sums, first express both numbers with the same power of ten. Renormalize the coefficient if it is outside the required interval.',
      model: {
        'Large': '4500000 = 4.5 × 10⁶',
        'Small': '0.00072 = 7.2 × 10⁻⁴',
        'Product': '(3 × 10⁴)(2 × 10³) = 6 × 10⁷',
        'Sum': '4 × 10⁵ + 3 × 10⁴ = 4.3 × 10⁵'
      },
      worked:
          'Divide 8.4 × 10⁷ by 2 × 10³. Divide coefficients: 8.4/2 = 4.2. Subtract exponents: 7 - 3 = 4. Answer 4.2 × 10⁴. Check 42,000 × 2,000 = 84,000,000.',
      tryIt:
          'Write 0.00056 in scientific notation. Multiply (4 × 10³)(5 × 10²).',
      check:
          '0.00056 = 5.6 × 10⁻⁴. The product is 20 × 10⁵ = 2 × 10⁶ after normalizing.',
      avoid:
          'Do not add exponents when adding numbers. A negative exponent is not a negative quantity.',
      remember:
          'Keep one nonzero digit before the decimal. Choose the exponent rule that matches the operation.',
      bank: '''
Write 63000 in scientific notation.|6.3 × 10⁴|63 × 10³;6.3 × 10³;0.63 × 10⁵|Move the decimal four places while keeping the coefficient between one and ten.
Write 0.0042 in scientific notation.|4.2 × 10⁻³|4.2 × 10³;42 × 10⁻³;4.2 × 10⁻²|The decimal shifts three places from the coefficient.
What is 7 × 10³ in ordinary notation?|7000|700;0.007;70000|Ten cubed is one thousand.
What is 3 × 10⁻²?|0.03|0.3;300;0.003|Divide three by one hundred.
Multiply (2 × 10⁴)(3 × 10²).|6 × 10⁶|6 × 10⁸;5 × 10⁶;6 × 10²|Multiply coefficients and add exponents.
Divide 9 × 10⁸ by 3 × 10².|3 × 10⁶|3 × 10⁴;6 × 10⁶;3 × 10¹⁰|Nine divided by three is three and eight minus two is six.
Normalize 24 × 10⁵.|2.4 × 10⁶|2.4 × 10⁴;24 × 10⁶;0.24 × 10⁵|Reducing the coefficient by ten requires raising the power by one.
Add 2 × 10³ + 5 × 10³.|7 × 10³|7 × 10⁶;10 × 10³;7 × 10⁰|The shared power remains unchanged.
Add 3 × 10⁵ + 2 × 10⁴.|3.2 × 10⁵|5 × 10⁹;5 × 10⁵;3.02 × 10⁵|Rewrite the second term as 0.2 × 10⁵.
Multiply (6 × 10⁻³)(2 × 10²).|1.2 × 10⁰|1.2 × 10⁻¹;12 × 10⁵;8 × 10⁻¹|The initial product is 12 × 10⁻¹, equal to 1.2.
Subtract 8 × 10⁶ - 3 × 10⁵.|7.7 × 10⁶|5 × 10¹;5 × 10⁶;7.97 × 10⁶|Rewrite three hundred thousand as 0.3 million.
'''),
];
