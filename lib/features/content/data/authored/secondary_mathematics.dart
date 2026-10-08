import '../../domain/norie_content_models.dart';
import 'authored_lesson_visual.dart';
import 'subject_lesson_builder.dart';

const secondaryMathVisuals = <String, AuthoredLessonVisual>{
  'mathematics-g7-authored': AuthoredLessonVisual(
      title: 'Scale 1 cm to 4 m',
      labels: ['Drawing: 2 cm', 'Actual: 8 m', 'Drawing: 5 cm → Actual: 20 m'],
      details: [
        'Two drawing centimeters each represent four meters.',
        'Multiply 2 × 4 to convert drawing length to actual length.',
        'The same scale factor applies to every corresponding length.'
      ],
      note: 'Convert to the same units before interpreting the ratio 1:400.'),
  'mathematics-g8-authored': AuthoredLessonVisual(
      title: 'Slope from two points',
      labels: [
        'A = (1, 2), B = (4, 8)',
        'Rise = 8 − 2 = 6',
        'Run = 4 − 1 = 3',
        'Slope = 6/3 = 2'
      ],
      details: [
        'Keep coordinate pairs together.',
        'Subtract y-values in the same point order.',
        'Subtract x-values in that order.',
        'Each increase of one in x corresponds to two in y.'
      ],
      note: 'Using B minus A for both differences preserves the sign.',
      ordered: true),
  'mathematics-g9-authored': AuthoredLessonVisual(
      title: 'Factor x² + 5x + 6',
      labels: [
        'Find a pair: 2 + 3 = 5 and 2 × 3 = 6',
        '(x + 2)(x + 3)',
        'x² + 3x + 2x + 6'
      ],
      details: [
        'The pair supplies the linear coefficient and constant term.',
        'Write one number in each binomial.',
        'Expanding checks the middle coefficient is five.'
      ],
      note:
          'Factoring an expression does not by itself declare an equation equal to zero.',
      ordered: true),
  'mathematics-g10-authored': AuthoredLessonVisual(
      title: 'Two shirts and three hats',
      labels: [
        'Blue shirt → red, gray, or green hat',
        'White shirt → red, gray, or green hat',
        '2 × 3 = 6 outfits'
      ],
      details: [
        'This branch gives three different outfits.',
        'The other branch also gives three.',
        'Each leaf represents one shirt-and-hat choice.'
      ],
      note:
          'The product assumes all three hats are allowed with either shirt.'),
};

final secondaryMathematics = <String, NorieTopicContent>{
  'g7': subjectLesson(
      subject: 'Mathematics',
      grade: 'g7',
      title: 'Scale Drawings and Real Distances',
      prerequisite: 'mathematics.g7.geometry-probability',
      objectives: [
        'Convert drawing lengths using a stated scale.',
        'Write a unit-consistent scale ratio.',
        'Distinguish length scale from area scale.'
      ],
      introduction:
          'A map can represent a large place on a small page. Its scale connects every drawing length with the corresponding real distance, provided the map has not been resized without updating the scale.',
      explanation:
          'At a scale of one centimeter to four meters, each drawing centimeter represents four actual meters. Multiply drawing centimeters by four to obtain actual meters. To convert backward, divide actual meters by four. A ratio such as 1:400 uses matching units: four meters is four hundred centimeters, so one drawing centimeter corresponds to four hundred real centimeters. Do not call the ratio 1:4 while mixing centimeters and meters. Every corresponding length in the drawing uses the same proportional factor.',
      application:
          'A rectangular garden drawn three centimeters by five centimeters at this scale is twelve meters by twenty meters. Its actual area is 12 × 20 = 240 m². The drawing area is fifteen cm². Areas involve two length dimensions, so a dimensionless length scale factor k gives area factor k². If a photocopy doubles every drawing length, its written numerical scale is no longer valid unless updated. A graphical scale bar resized with the map still shows corresponding lengths.',
      worked:
          'A path measures 7.5 cm on a map whose scale is 1 cm to 2 km. Step 1: identify the conversion: two kilometers for each centimeter. Step 2: multiply 7.5 × 2 = 15 km. Step 3: retain the distance unit. Converting the ratio to matching centimeters would give 1:200,000, not 1:2.',
      guided:
          'A room is eight meters wide. At 1 cm to 2 m, how wide should its drawing be? If both actual dimensions of a rectangle are three times another, what happens to area?',
      solution:
          'The drawing width is 8 ÷ 2 = 4 cm. Tripling both dimensions multiplies area by 3 × 3 = 9.',
      mistakes:
          'A scale ratio requires the same units on both sides. Divide rather than multiply when going from actual distance back to drawing distance. An area factor is not the same as a length factor. Resizing can invalidate a numerical scale.',
      recap:
          'State the scale and units, then multiply or divide in the correct direction. Same-unit ratios express proportional lengths. Area changes by the square of a dimensionless length factor.',
      visual: secondaryMathVisuals['mathematics-g7-authored']!,
      questions: [
        'At 1 cm to 4 m, 3 cm represents what?|12 m|3 m|7 m|0.75 m|Each drawing centimeter represents four meters, so multiply three by four.|Scale conversion',
        'At 1 cm to 4 m, an actual 20 m length is drawn how long?|5 cm|80 cm|20 cm|4 cm|Convert backward by dividing twenty actual meters by four meters per centimeter.|Scale conversion',
        'The scale 1 cm to 4 m has which same-unit ratio?|1:400|1:4|4:1|400:4|Four meters is four hundred centimeters, giving 1:400.|Units',
        'At 1 cm to 2 km, 7.5 cm represents what?|15 km|3.75 km|9.5 km|75 km|Multiply the drawing length 7.5 by two kilometers per centimeter.|Scale conversion',
        'A length scale factor of three gives which area factor?|9|3|6|1|Area has two length dimensions, so the factor is three squared.|Area scale',
        'What can invalidate a printed numerical scale?|Resizing the map without updating it|Changing paper color only|Reading it twice|Keeping the original dimensions|Resizing changes drawing lengths relative to the unchanged printed scale.|Model interpretation',
        'A 3 cm by 5 cm drawing uses 1 cm to 4 m. Actual area is what?|240 m²|60 m²|15 m²|32 m²|Actual sides are twelve and twenty meters, giving 240 square meters.|Area scale',
        'Why must a ratio use matching units?|It compares lengths on one numerical basis|It removes all dimensions from reality|It makes every map 1:1|It changes kilometers to time|A same-unit ratio avoids treating one centimeter as equal to one meter.|Units',
        'At 1 cm to 2 m, an 8 m wall should be drawn how long?|4 cm|16 cm|8 cm|2 cm|Eight meters divided by two meters per centimeter gives four centimeters.|Scale conversion',
        'A rectangle doubles both dimensions. Its area does what?|Quadruples|Doubles|Halves|Stays fixed|The area factor is two times two, or four.|Area scale',
        'Which scale bar remains useful if enlarged with the map?|A graphical distance bar resized together|An unchanged numerical ratio alone|Only a title font|A compass direction label only|A graphical bar enlarges with map distances and keeps their correspondence.|Model interpretation',
      ]),
  'g8': subjectLesson(
      subject: 'Mathematics',
      grade: 'g8',
      title: 'Slope from Two Points',
      prerequisite: 'mathematics.g8.pythagorean-theorem',
      objectives: [
        'Calculate slope using consistent coordinate differences.',
        'Interpret positive, negative, and zero slopes.',
        'Identify why a vertical line has undefined slope.'
      ],
      introduction:
          'Slope compares how a line changes vertically with how it changes horizontally. It gives a constant rate of change for a straight line, rather than just the height of one point.',
      explanation:
          'For points (x₁, y₁) and (x₂, y₂), slope m = (y₂ − y₁)/(x₂ − x₁), provided the denominator is nonzero. Use the same point order in both differences. For (1, 2) and (4, 8), the rise is six and the run is three, so slope is two. Reversing both differences gives −6/−3, still two. Reversing only one changes the sign incorrectly. A positive slope rises as x increases; a negative slope falls.',
      application:
          'A horizontal line has zero rise with nonzero run, so its slope is zero. A vertical line has zero run; division by zero is undefined, so it has no finite slope. When coordinates represent quantities, slope has units such as liters per minute. Its numerical value depends on the chosen units. A graph that stretches one axis can look steeper without changing the underlying data slope; calculate from the scale rather than visual angle alone.',
      worked:
          'Use points (2, 9) and (5, 3). Step 1: y-change = 3 − 9 = −6. Step 2: x-change = 5 − 2 = 3. Step 3: m = −6/3 = −2. Step 4: interpret: y decreases by two for each one-unit increase in x along this line.',
      guided:
          'Find the slope through (−1, 4) and (3, 4). Then consider points (2, 1) and (2, 7). Why do the two results differ?',
      solution:
          'The first slope is (4 − 4)/(3 − (−1)) = 0/4 = 0, a horizontal line. The second has run 2 − 2 = 0 and slope 6/0 undefined, a vertical line.',
      mistakes:
          'Keep coordinate pairs intact. Subtract in the same order above and below. Zero slope and undefined slope are different: the first has zero rise, the second zero run. Do not judge slope only from a stretched picture.',
      recap:
          'Slope is change in y divided by change in x. Use consistent point order and data units. Positive rises, negative falls, horizontal is zero, and vertical is undefined.',
      visual: secondaryMathVisuals['mathematics-g8-authored']!,
      questions: [
        'Slope through (1, 2) and (4, 8) is what?|2|3|6|1/2|The rise is six and run is three, so slope is two.|Slope calculation',
        'Which expression gives slope?|Change in y divided by change in x|Change in x divided by change in y|Sum of y coordinates|Product of x coordinates|Slope measures vertical change per horizontal change.|Slope meaning',
        'A line falls as x increases. Its slope is what?|Negative|Positive|Always zero|Always undefined|A negative y-change for a positive x-change gives negative slope.|Slope sign',
        'A horizontal line has which slope?|0|1|Undefined|−1|Its rise is zero while its run can be nonzero.|Special lines',
        'A vertical line has which slope?|Undefined|0|1|Its y-intercept always|Its run is zero, and division by zero is undefined.|Special lines',
        'Reversing both differences in a slope ratio does what?|Keeps the slope unchanged|Always changes its sign|Makes it zero|Makes every line vertical|Both numerator and denominator change sign, leaving their quotient the same.|Point order',
        'A tank gains 12 L in 3 min along a straight graph. Slope is what?|4 L/min|36 L/min|0.25 L/min|9 L/min|Slope is volume change divided by time change: twelve over three.|Rate units',
        'Why can a stretched axis make a line look steeper?|Display aspect changes while data ratio stays fixed|The data must change|All slopes become one|Coordinates lose their units|Visual angle depends on axis display scales, so calculate the data ratio.|Graph interpretation',
        'Slope through (2, 9) and (5, 3) is what?|−2|2|−3|1/2|Consistent differences give (3 − 9)/(5 − 2) = −6/3.|Slope calculation',
        'Slope through (−1, 4) and (3, 4) is what?|0|4|−4|Undefined|Equal y-values give zero rise over a run of four.|Special lines',
        'A learner computes (8 − 2)/(1 − 4). What fixes the sign?|Use (8 − 2)/(4 − 1)|Keep the inconsistent order|Add all coordinates|Replace run with zero|Use the same second-minus-first order for both coordinate differences.|Point order',
      ]),
  'g9': subjectLesson(
      subject: 'Mathematics',
      grade: 'g9',
      title: 'Factoring Monic Quadratics',
      prerequisite: 'mathematics.g9.intro-statistics',
      objectives: [
        'Find factor pairs using a sum and product.',
        'Check a quadratic factorization by expansion.',
        'Use zero-product reasoning only when an equation equals zero.'
      ],
      introduction:
          'A quadratic expression can sometimes be written as two linear factors. Factoring reveals structure and can help solve equations, but rewriting an expression is different from solving an equation.',
      explanation:
          'Expanding (x + p)(x + q) gives x² + (p + q)x + pq. Therefore, to factor a monic quadratic x² + bx + c over integers, seek integers p and q whose sum is b and product is c. For x² + 5x + 6, choose two and three: their sum is five and product six. The factors are (x + 2)(x + 3). If c is positive, the two numbers have the same sign. If c is negative, they have opposite signs. A monic quadratic has leading coefficient one.',
      application:
          'For x² − 5x + 6, the pair is −2 and −3. Their product is positive six and sum negative five. For x² + x − 6, use three and negative two. Not every monic quadratic has integer factors: a search can fail without the expression being invalid. When an equation is (x + p)(x + q) = 0, the zero-product property says at least one factor is zero. It does not justify setting each factor to zero when the product equals some nonzero value.',
      worked:
          'Solve x² − x − 12 = 0. Step 1: find integers multiplying to −12 and adding to −1: −4 and 3. Step 2: write (x − 4)(x + 3) = 0. Step 3: set x − 4 = 0 or x + 3 = 0, giving x = 4 or x = −3. Step 4: expand the factors to check the original coefficients.',
      guided:
          'Factor x² + 7x + 12, then solve x² + 7x + 12 = 0. Explain why the expression alone does not already state its value is zero.',
      solution:
          'Three and four multiply to twelve and add to seven, so the expression is (x + 3)(x + 4). In the equation equal to zero, roots are −3 and −4. An expression by itself can have many values as x changes.',
      mistakes:
          'The chosen pair must satisfy both sum and product. Watch signs, especially for a negative constant. Factoring does not mean roots are positive versions of the factor constants. Use zero-product reasoning only after the equation is arranged equal to zero.',
      recap:
          'For x² + bx + c, seek a pair summing to b and multiplying to c, then verify by expansion. To solve, first make the factored equation equal zero and set each factor equal zero.',
      visual: secondaryMathVisuals['mathematics-g9-authored']!,
      questions: [
        'Which pair factors x² + 5x + 6?|2 and 3|1 and 6|−2 and −3|5 and 6|Two and three have sum five and product six.|Factor pairs',
        'Expand (x + 2)(x + 3).|x² + 5x + 6|x² + 6x + 5|x² + 6|2x² + 3x|The cross terms are three x and two x, giving five x.|Expansion',
        'Which pair fits x² − 5x + 6?|−2 and −3|2 and 3|−1 and 6|1 and −6|Both numbers are negative so their sum is negative five and product positive six.|Signs',
        'A negative constant product requires integer factor-pair signs to be what?|Opposite|Both positive|Both zero|Both negative|Opposite signs give a negative product.|Signs',
        'What makes a quadratic monic?|Leading coefficient is one|Constant is zero|Every root is positive|Linear term is absent|Monic means the coefficient of the highest-degree term is one.|Quadratic structure',
        'From (x + 2)(x + 3) = 0, which roots follow?|−2 and −3|2 and 3|0 and 5|6 and 1|Each factor can be zero, giving x = −2 or x = −3.|Zero-product property',
        'Can zero-product reasoning be applied directly to (x + 2)(x + 3) = 6?|No, the product is not zero|Yes, roots are always −2 and −3|Yes, because six is positive|Only if x is positive|The zero-product property requires the product to equal zero.|Zero-product property',
        'Why should factors be expanded to check them?|To verify all original coefficients|To remove every x|To guarantee all roots are integers|To turn a quadratic into a constant|Expansion confirms that the proposed factors match the expression.|Verification',
        'Factor x² + 7x + 12.|(x + 3)(x + 4)|(x + 2)(x + 6)|(x − 3)(x − 4)|(x + 1)(x + 12)|Three and four have the required sum seven and product twelve.|Factor pairs',
        'Solve x² − x − 12 = 0.|x = 4 or x = −3|x = −4 or x = 3|x = 12 only|x = 1 only|The factorization (x − 4)(x + 3) gives the two stated roots.|Zero-product property',
        'A pair has correct product but wrong sum. Is it valid for factoring?|No, both conditions must hold|Yes, only product matters|Yes, only positive numbers matter|It makes every quadratic zero|The sum controls the linear coefficient and must also match.|Factor pairs',
      ]),
  'g10': subjectLesson(
      subject: 'Mathematics',
      grade: 'g10',
      title: 'Counting Outcomes with Trees',
      prerequisite: 'mathematics.g10.probability-combinatorics',
      objectives: [
        'List outcomes systematically using stages.',
        'Apply the product rule when each stage has fixed choices.',
        'Distinguish outcome counts from equally likely probabilities.'
      ],
      introduction:
          'A tree diagram lists decisions in stages. Each complete path is one outcome. It helps us count without omitting possibilities or counting the same one twice.',
      explanation:
          'Suppose an outfit uses one of two shirts and one of three hats. Start with two shirt branches. From each shirt branch, draw three hat branches. There are six complete paths, giving 2 × 3 = 6 outfits. The product rule applies when each first choice is followed by the same number of allowed second choices. A path such as blue shirt and red hat is one outcome, not two separate outfits. Write labels clearly so distinct paths correspond to distinct outcomes.',
      application:
          'Restrictions can change branch counts. If one hat cannot be used with the white shirt, the blue branch has three choices and the white branch two. Add branch totals, 3 + 2 = 5, rather than using 2 × 3 blindly. For a two-letter code with no repetition from A, B, C, the first position has three choices and the second two, producing six ordered codes. AB and BA are different when order matters. Counting paths alone gives probabilities only if the complete outcomes are equally likely.',
      worked:
          'A code uses one letter from A or B and one digit from 1, 2, or 3. Step 1: branch into A and B. Step 2: attach digits 1, 2, 3 to each. Step 3: list A1, A2, A3, B1, B2, B3. Six distinct paths match 2 × 3. If all codes are chosen equally, a code beginning with A has probability 3/6 = 1/2.',
      guided:
          'Choose a two-letter code from A, B, C without repetition. How many codes are possible? Then explain why counting codes would not establish equal likelihood if a program favored A as its first letter.',
      solution:
          'There are 3 × 2 = 6 ordered codes. A biased first-letter choice can make their probabilities unequal even though the number of possible codes is still six.',
      mistakes:
          'Add branch totals when restrictions give different numbers of choices. Do not count intermediate branches as complete outcomes. State whether order matters and whether repetition is allowed. Possible does not mean equally likely.',
      recap:
          'Count complete paths in a labeled tree. Multiply fixed stage counts or add unequal branch totals. Translate counts into probability only with a justified equal-likelihood model.',
      visual: secondaryMathVisuals['mathematics-g10-authored']!,
      questions: [
        'Two shirts and three unrestricted hats make how many outfits?|6|5|3|2|Each of two shirts has three hat choices, so multiply two by three.|Product rule',
        'What represents one complete outcome in a choice tree?|A full path through all stages|Every branch separately|Only the root|Only the first decision|A complete path selects one option at every required stage.|Tree representation',
        'One shirt allows three hats and another two. Total outfits are what?|5|6|2|3|Add unequal branch totals: three plus two gives five.|Restrictions',
        'Two letters without repetition from A, B, C give how many ordered codes?|6|9|3|2|There are three first choices and two remaining second choices.|No repetition',
        'Are AB and BA different in an ordered code?|Yes|No, order never matters|Only if letters repeat|Only if they are numbers|Different positions produce different ordered codes.|Order',
        'Why does counting possibilities alone not always give probabilities?|Outcomes may be unequally likely|Trees cannot count|There must be infinitely many outcomes|Probability ignores all choices|Probability from simple counts requires equal likelihood of complete outcomes.|Probability model',
        'List outcomes for A or B then 1 or 2. Which list is complete?|A1, A2, B1, B2|A1, B2 only|A, B, 1, 2|A1, A1, B1, B1|Each letter is paired with each digit once.|Systematic listing',
        'If two-letter repetition from A, B, C is allowed, how many codes?|9|6|3|12|Both positions have three choices, so there are three times three.|Repetition',
        'Three first choices each allow four second choices. Count complete outcomes.|12|7|4|3|The fixed two-stage product is three times four.|Product rule',
        'Three of six equally likely codes start with A. Their probability is what?|1/2|1/6|3|6|Favorable outcomes divided by total outcomes gives three sixths.|Probability model',
        'A program favors A but can still produce all six codes. What remains unchanged?|The number of possible codes|Each code probability necessarily|The first-letter bias disappears|All codes become impossible|Bias changes probabilities, not the count of outcomes still possible.|Probability model',
      ]),
};
