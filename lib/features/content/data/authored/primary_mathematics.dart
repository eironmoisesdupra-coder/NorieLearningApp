import '../../domain/norie_content_models.dart';
import 'authored_lesson_visual.dart';
import 'subject_lesson_builder.dart';

const primaryMathVisuals = <String, AuthoredLessonVisual>{
  'mathematics-g1-authored': AuthoredLessonVisual(
      title: 'Make a full group of ten',
      labels: ['7 counters + 3 empty places', '7 + 3 = 10'],
      details: [
        'A ten-frame has ten places. Seven are filled and three remain.',
        'Filling the three places makes one complete group of ten.'
      ],
      note:
          'Each counter represents one. The two parts make the same total ten.'),
  'mathematics-g2-authored': AuthoredLessonVisual(
      title: 'Equal jumps of five',
      labels: ['0 → 5 → 10 → 15 → 20', '4 jumps × 5 each = 20'],
      details: [
        'Each arrow increases the number by five.',
        'Count jumps, not landing points: four equal jumps end at twenty.'
      ],
      note:
          'This number-line model begins at zero. A different start changes the landing numbers.'),
  'mathematics-g3-authored': AuthoredLessonVisual(
      title: 'A whole divided into fourths',
      labels: [
        '0 → 1/4 → 2/4 → 3/4 → 4/4 = 1',
        'Three equal intervals from zero'
      ],
      details: [
        'Four equal intervals make one whole unit.',
        'The third landing point is 3/4, not 3/5.'
      ],
      note:
          'The denominator counts equal intervals in one whole, not the number of tick marks.'),
  'mathematics-g4-authored': AuthoredLessonVisual(
      title: 'Compare using equal-sized parts',
      labels: ['2/3 = 8/12', '3/4 = 9/12'],
      details: [
        'Multiply numerator and denominator by four.',
        'Multiply numerator and denominator by three.'
      ],
      note: 'Eight twelfths is less than nine twelfths, so 2/3 < 3/4.'),
  'mathematics-g5-authored': AuthoredLessonVisual(
      title: 'Two-thirds of three-fourths',
      labels: [
        'Whole rectangle: 3 × 4 = 12 equal cells',
        'Overlap: 2 × 3 = 6 cells',
        '6/12 = 1/2'
      ],
      details: [
        'Thirds in one direction and fourths in the other create twelfths.',
        'Shade two of three rows and three of four columns. Six cells have both shadings.',
        'The overlap represents (2/3) × (3/4).'
      ],
      note: 'The model refers to the same whole rectangle throughout.',
      ordered: true),
  'mathematics-g6-authored': AuthoredLessonVisual(
      title: 'Compare price for one notebook',
      labels: ['3 notebooks for 90 credits', '5 notebooks for 125 credits'],
      details: [
        '90 ÷ 3 = 30 credits per notebook.',
        '125 ÷ 5 = 25 credits per notebook.'
      ],
      note:
          'For equivalent notebooks, the second pack has lower unit price, though its total cost is higher.'),
};

final primaryMathematics = <String, NorieTopicContent>{
  'g1': subjectLesson(
      subject: 'Mathematics',
      grade: 'g1',
      title: 'Making Ten',
      prerequisite: 'mathematics.g1.shapes-patterns',
      objectives: [
        'Find the missing part of ten.',
        'Show two groups that make ten.',
        'Use making ten to explain a small addition.'
      ],
      introduction:
          'Ten is a helpful group. If a frame has ten places, we can see how many are filled and how many are still empty. The two parts always make ten.',
      explanation:
          'Put one counter in each place of a ten-frame. If seven places are filled, count the empty places: one, two, three. Seven and three make ten. Write 7 + 3 = 10. You can also begin with three counters and add seven; the total is still ten. Other pairs include 1 and 9, 2 and 8, 4 and 6, and 5 and 5. The parts can change while the total stays ten. Count every counter once and do not put two counters in one place.',
      application:
          'You can use a drawing of ten boxes instead of real counters. Fill the boxes in order so empty places are easy to see. Making ten also helps with an addition such as 8 + 5. Eight needs two more to make ten. Split five into two and three. Add the two to eight, then the three left over: 10 + 3 = 13. The five counters did not disappear; they were separated into two smaller groups.',
      worked:
          'Find the missing number in 6 + ? = 10. Step 1: show six counters in ten places. Step 2: count four empty places. Step 3: fill them to make ten. The missing part is four, so 6 + 4 = 10. Check by counting all ten counters once.',
      guided:
          'Draw ten boxes and fill nine. How many more are needed? Next use that missing part to explain 9 + 3 without counting all twelve from the beginning.',
      solution:
          'Nine needs one more to make ten. Split three into one and two. Nine plus one is ten; ten plus two is twelve. Therefore 9 + 3 = 12.',
      mistakes:
          'The missing part is the number of empty places, not the filled places. When splitting an addend, keep both parts: splitting three into one and two does not change its total. Ten places hold ten single counters.',
      recap:
          'Two parts can make ten. Count empty ten-frame places to find a missing part. For addition, first make ten and then add the part left over.',
      visual: primaryMathVisuals['mathematics-g1-authored']!,
      questions: [
        'Seven counters fill a ten-frame. How many places are empty?|3|7|10|2|Ten places minus seven filled places leaves three empty.|Parts of ten',
        'Which pair makes ten?|4 and 6|4 and 5|6 and 6|3 and 8|Four plus six makes the complete group of ten.|Parts of ten',
        'Find the missing part: 8 + ? = 10.|2|8|3|1|Eight needs two more to reach ten counters.|Missing part',
        'Five counters and five more make what total?|10|5|9|11|The two groups of five fill all ten places.|Parts of ten',
        'To make ten first in 9 + 4, split four into which parts?|1 and 3|2 and 3|4 and 1|1 and 1|Nine needs one; the other three of the four are added afterward.|Making ten addition',
        'After making ten in 8 + 5, three remain. What is the total?|13|10|12|15|Eight and two make ten, then the remaining three make thirteen.|Making ten addition',
        'Why must each place hold just one counter in this model?|Each place represents one|Each place represents five|Empty places count double|The frame changes size|One counter per place lets ten places represent exactly ten.|Ten-frame model',
        'Which equation shows the same ten as 2 + 8?|8 + 2 = 10|8 + 3 = 10|2 + 2 = 10|8 − 2 = 10|Changing the order of these parts does not change the total.|Parts of ten',
        'There are six filled places. What completes ten?|4 more counters|6 more counters|3 more counters|10 more counters|Six plus four fills the ten-frame without extra counters.|Missing part',
        'Use making ten to find 7 + 5.|12|10|11|13|Split five into three and two: seven plus three is ten, then add two.|Making ten addition',
        'A learner splits four into one and three for 9 + 4. What follows 9 + 1?|Add the remaining 3|Throw away the 3|Add all 4 again|Subtract the 1|After using one to make ten, three of the original four remain.|Making ten addition',
      ]),
  'g2': subjectLesson(
      subject: 'Mathematics',
      grade: 'g2',
      title: 'Equal Jumps on a Number Line',
      prerequisite: 'mathematics.g2.length-time-money',
      objectives: [
        'Continue a sequence of equal jumps.',
        'Connect repeated addition with equal groups.',
        'Find and correct an unequal jump.'
      ],
      introduction:
          'Counting one by one works, but equal groups let us count more efficiently. A number line shows where each equal jump lands and makes a counting pattern visible.',
      explanation:
          'Start at zero and make jumps of two. The landing numbers are 2, 4, 6, 8, and 10. Each jump adds the same amount. Five jumps of two represent five equal groups of two, or 2 + 2 + 2 + 2 + 2 = 10. The zero is the starting point, not a completed jump. With jumps of five, the landings are 5, 10, 15, and 20. Mark spaces evenly on a drawn line so the distances represent equal number changes.',
      application:
          'Suppose four bags each contain five shells. The bags are equal groups, so use four jumps of five from zero. After each jump, count one bag. The final landing gives twenty shells. If groups have different sizes, one fixed jump length does not model them correctly. You can also begin at a different number: three jumps of five from ten land at fifteen, twenty, and twenty-five. The step size remains five, but the starting value contributes to the final number.',
      worked:
          'Find the total in three groups of four. Step 1: start at zero. Step 2: add four to land at four. Step 3: add another four to land at eight. Step 4: add the third four to land at twelve. Three jumps, not four marked points, represent the three groups.',
      guided:
          'Start at five and make three equal jumps of five. Write every landing number. Then explain why the answer differs from three jumps of five starting at zero.',
      solution:
          'The landings are ten, fifteen, and twenty. Starting at five includes five already present; from zero the same three jumps would end at fifteen.',
      mistakes:
          'Do not count the starting mark as a jump. A pattern of 2, 4, 7, 9 does not use only jumps of two: the jump from four to seven is three. State the starting number as well as the step size.',
      recap:
          'Equal jumps show repeated addition and equal groups. Count the arrows, keep the jump size fixed, and include the starting value when finding the final landing.',
      visual: primaryMathVisuals['mathematics-g2-authored']!,
      questions: [
        'Continue equal jumps of two: 2, 4, 6, __.|8|7|9|12|Each landing is two more than the preceding one.|Equal jumps',
        'Four jumps of five from zero end at what?|20|15|25|9|Repeated addition gives 5 + 5 + 5 + 5 = 20.|Equal groups',
        'Which number is the start before any jump in the diagram?|0|5|10|20|Zero is the starting point and does not count as a completed jump.|Number-line model',
        'Three groups of four contain how many objects?|12|7|16|10|Three equal groups of four give 4 + 4 + 4 = 12.|Equal groups',
        'Which sequence uses only jumps of five?|5, 10, 15, 20|5, 10, 16, 20|5, 11, 15, 20|5, 9, 15, 20|Every neighboring difference in the first sequence is five.|Equal jumps',
        'Two jumps of two starting at six land finally at what?|10|4|8|12|Start with six, then add two twice: eight and ten.|Starting value',
        'Why are evenly spaced marks useful on a number line?|They represent equal number changes|They make zero a group|They change addition into subtraction|They remove the starting value|Equal drawn spacing communicates equal numerical intervals.|Number-line model',
        'Two bags have three shells and six shells. Can equal jumps of three model two equal bags?|No, the groups are unequal|Yes, each has three|Yes, each has six|Only if the line is red|The bag sizes differ, so a single repeated group size does not model them.|Equal groups',
        'Five jumps of two from zero end at what?|10|7|12|5|Five equal additions of two total ten.|Equal groups',
        'Correct the jump pattern 5, 10, 16, 20 for jumps of five.|Replace 16 with 15|Replace 10 with 11|Replace 20 with 21|Replace 5 with 6|The third landing from zero should be fifteen in steps of five.|Pattern correction',
        'Three jumps of five from ten end at what?|25|15|20|30|The starting ten plus fifteen from three jumps gives twenty-five.|Starting value',
      ]),
  'g3': subjectLesson(
      subject: 'Mathematics',
      grade: 'g3',
      title: 'Fractions on a Number Line',
      prerequisite: 'mathematics.g3.data-graphs',
      objectives: [
        'Divide one whole into equal fraction intervals.',
        'Locate a fraction by counting from zero.',
        'Recognize a whole written as a fraction.'
      ],
      introduction:
          'Fractions are numbers with positions on a number line. To place them accurately, first decide what one whole is, then divide its length into equal parts.',
      explanation:
          'The distance from zero to one represents one whole unit. Divide that distance into four equal intervals. Each interval has length one fourth, written 1/4. The points are 0, 1/4, 2/4, 3/4, and 4/4. Four fourths reach one whole, so 4/4 = 1. The denominator tells the number of equal intervals in one whole. The numerator counts how many such intervals you move from zero. There are five marked points but four intervals; count spaces rather than all marks.',
      application:
          'A fraction position depends on the size of the chosen whole. When comparing fractions on one number line, keep zero and one fixed. Unequal spaces do not represent equal fraction parts. You can also extend the line past one: five fourths lies one fourth beyond one. Fractions with the same denominator can be compared by counting intervals: 3/4 is farther right than 1/4, so it is greater. For positive numbers, positions farther right are larger.',
      worked:
          'Locate 2/3. Step 1: mark zero and one. Step 2: divide their distance into three equal intervals. Step 3: move two intervals from zero. The second landing is 2/3. The next landing, 3/3, is one. The numerator two counts intervals traveled, not total intervals in the whole.',
      guided:
          'A line from zero to one has six equal intervals. Name the first and fifth landing points. Which is farther right? How many sixths make one?',
      solution:
          'The first is 1/6 and the fifth is 5/6. Five sixths is farther right and greater. Six sixths equals one whole.',
      mistakes:
          'Four parts must be equal to represent fourths. Do not use the number of tick marks as the denominator. A numerator larger than the denominator can represent a number beyond one, not an impossible fraction.',
      recap:
          'Fix the whole from zero to one, divide it equally using the denominator, and count numerator intervals from zero. Equal numerator and denominator represent one whole.',
      visual: primaryMathVisuals['mathematics-g3-authored']!,
      questions: [
        'A whole is divided into four equal intervals. One interval is what?|1/4|1/5|4/1|1/3|Four equal intervals in one whole make each interval one fourth.|Equal parts',
        'Where is 3/4 on a fourths number line?|Third landing from zero|Fourth landing past one|Third whole number|The starting zero|The numerator three counts three fourth-sized intervals from zero.|Fraction position',
        'How many fourths equal one whole?|4|3|5|1|Four equal fourths fill the whole distance from zero to one.|Whole fractions',
        'Which fraction is greater: 1/5 or 4/5?|4/5|1/5|They are equal|Neither is a number|Four fifths lies farther right than one fifth on the same whole.|Comparison',
        'Five marks from zero to one define four equal spaces. The denominator is what?|4|5|1|0|The denominator counts intervals, not all marked points.|Equal parts',
        'Which partition correctly models thirds?|Three equal intervals|Three unequal intervals|Four equal intervals|One mark anywhere|Thirds require three equal parts of the same whole.|Equal parts',
        'Where does 5/4 lie compared with one?|One fourth to its right|At zero|One fourth to its left|Exactly at one|Four fourths is one; one additional fourth gives five fourths.|Beyond one',
        'What should stay fixed while comparing positions on one fraction line?|The whole from zero to one|Only the pencil color|Only numerator font|The number of titles|A common whole gives the fraction positions a shared scale.|Whole unit',
        'A line has six equal intervals per whole. Fourth landing is what?|4/6|6/4|4/7|1/4|Four intervals traveled out of six per whole gives four sixths.|Fraction position',
        'Which is another way to write 1 as a fraction?|3/3|1/3|3/1|2/3|Three thirds complete exactly one whole.|Whole fractions',
        'Why is 3/8 farther right than 1/8?|It includes three equal eighth intervals instead of one|Its denominator is larger|It uses a different whole|Every fraction equals one|With the same whole and denominator, more intervals mean a larger number.|Comparison',
      ]),
  'g4': subjectLesson(
      subject: 'Mathematics',
      grade: 'g4',
      title: 'Comparing Unlike Fractions',
      prerequisite: 'mathematics.g4.angles-symmetry',
      objectives: [
        'Build equivalent fractions with a common denominator.',
        'Compare unlike fractions for the same whole.',
        'Explain why denominator size alone cannot decide order.'
      ],
      introduction:
          'Two thirds and three fourths use different part sizes. Comparing them becomes clearer when both are written using equal-sized parts of the same whole.',
      explanation:
          'Equivalent fractions name the same amount. Multiply both numerator and denominator by the same nonzero whole number: 2/3 = 4/6 because each third is split into two sixths. To compare 2/3 and 3/4, choose a common denominator such as twelve. Two thirds becomes eight twelfths, and three fourths becomes nine twelfths. Now the parts are equally sized, so compare eight with nine. Thus 2/3 < 3/4. Changing only the denominator would change the amount.',
      application:
          'A common denominator can be a common multiple; it need not be the smallest one, though a smaller useful denominator reduces the numbers. Benchmarks also help: 3/8 is less than one half because half of eight parts is four. Always specify the same whole when comparing portions. Half of a large pizza may be physically larger than three fourths of a small one, even though 1/2 < 3/4 as numbers. The fraction comparison assumes a shared unit.',
      worked:
          'Compare 3/5 and 5/8. Step 1: use denominator forty. Step 2: 3/5 = 24/40 and 5/8 = 25/40. Step 3: twenty-four is less than twenty-five, so 3/5 < 5/8. Check that both numerator and denominator were multiplied: by eight in the first fraction and five in the second.',
      guided:
          'Compare 5/6 and 3/4 using twelfths. Show each multiplication and then write the inequality.',
      solution:
          '5/6 = 10/12 by multiplying both numbers by two. 3/4 = 9/12 by multiplying both by three. Therefore 5/6 > 3/4.',
      mistakes:
          'A larger denominator alone does not mean a larger fraction. Multiplying only a numerator does not preserve value. Compare portions of the same whole, and put the inequality opening toward the greater value.',
      recap:
          'Rewrite unlike fractions using a common denominator and compare numerators. Equivalent fractions multiply numerator and denominator together. Keep the whole fixed when interpreting portions.',
      visual: primaryMathVisuals['mathematics-g4-authored']!,
      questions: [
        'Which is equivalent to 2/3?|8/12|2/12|8/3|3/2|Multiplying numerator and denominator by four gives eight twelfths.|Equivalence',
        'Which denominator can compare thirds and fourths?|12|7|5|3|Twelve is a multiple of both three and four.|Common denominator',
        'Compare 8/12 and 9/12.|8/12 < 9/12|8/12 > 9/12|They are equal|Neither can be compared|With equal denominators, eight parts is less than nine parts.|Comparison',
        'Which is greater: 2/3 or 3/4?|3/4|2/3|They are equal|Both exceed one|Eight twelfths is less than nine twelfths.|Comparison',
        'To preserve 3/5 when changing denominator to 20, numerator becomes what?|12|3|8|15|Multiply both numerator and denominator by four.|Equivalence',
        'Which fraction is less than one half?|3/8|5/8|4/6|3/4|Half of eight parts is four, and three eighths is less.|Benchmarks',
        'Can 24 be used to compare 2/3 and 3/4?|Yes, it is a common multiple|No, only 12 can work|No, it must be a prime|Yes, without changing numerators|Twenty-four is divisible by both denominators, though twelve is smaller.|Common denominator',
        'What must match to compare physical fractions of pizzas directly?|The whole pizza size|Only the topping name|Only the plate color|Only the eater name|Fraction portions refer to a whole; different whole sizes change physical amounts.|Whole unit',
        'Compare 5/6 and 3/4.|5/6 > 3/4|5/6 < 3/4|They are equal|Both equal 1/2|Ten twelfths is greater than nine twelfths.|Comparison',
        'Which is greater: 3/5 or 5/8?|5/8|3/5|They are equal|Neither is positive|Three fifths is 24/40 and five eighths is 25/40.|Comparison',
        'A learner writes 2/3 = 2/12. What corrects this?|Multiply the numerator by four too|Leave the numerator unchanged|Multiply only the numerator by twelve|Add twelve to both numbers|Changing denominator three to twelve requires multiplying both by four.|Equivalence',
      ]),
  'g5': subjectLesson(
      subject: 'Mathematics',
      grade: 'g5',
      title: 'Multiplying Fractions with Area Models',
      prerequisite: 'mathematics.g5.numerical-expressions',
      objectives: [
        'Interpret fraction multiplication as a part of a part.',
        'Connect an area overlap with numerator and denominator products.',
        'Simplify a product without changing its value.'
      ],
      introduction:
          'Two thirds of three fourths is a part of an amount that is already part of a whole. An area model shows why we multiply both numerators and both denominators.',
      explanation:
          'Draw one rectangle for the whole. Divide it into three equal rows and shade two. Divide the same rectangle into four equal columns and shade three in another direction. There are 3 × 4 = 12 equal cells. The overlapping region contains 2 × 3 = 6 cells. Therefore (2/3) × (3/4) = 6/12 = 1/2. The overlap measures a part of a part. It is not the union of every shaded cell; counting all cells with either color models a different question.',
      application:
          'For fractions a/b and c/d, their product is ac/bd when denominators are nonzero. Simplifying divides numerator and denominator by a common factor. In a recipe, half of three fourths of a cup is three eighths of a cup. Multiplying a positive amount by a positive fraction smaller than one reduces it. So a product need not be larger than both factors. Use the same whole in a diagram and label the quantity in a word problem so the answer has meaning.',
      worked:
          'Find (3/5) × (2/3). Step 1: form fifteen equal cells using fifths in one direction and thirds in the other. Step 2: six cells overlap, so the product is 6/15. Step 3: divide numerator and denominator by three to get 2/5. Check that 2/5 is less than each factor because each factor is between zero and one.',
      guided:
          'A ribbon is 4/5 meter long. Use 1/2 of it for a bookmark. Multiply to find the length used and explain why the answer is not 4/10 meters plus another half meter.',
      solution:
          '(1/2) × (4/5) = 4/10 = 2/5 meter. Half refers to a share of the existing ribbon; it is not an extra length to add.',
      mistakes:
          'Multiply denominators as well as numerators. For unlike-fraction multiplication, a common denominator is unnecessary. Count only the overlap in the area model. Simplify by dividing both numbers by the same factor.',
      recap:
          'Fraction multiplication takes a part of a part. Equal grid cells show the products of denominators and numerators. Simplify the resulting fraction and interpret it in the original unit.',
      visual: primaryMathVisuals['mathematics-g5-authored']!,
      questions: [
        'What is (1/2) × (3/4)?|3/8|4/6|3/4|1/8|Multiply numerators and denominators: 1 × 3 over 2 × 4.|Fraction product',
        'A thirds-by-fourths grid contains how many equal cells?|12|7|3|4|Three rows times four columns make twelve equal cells.|Area model',
        'Two rows and three columns overlap in how many cells?|6|5|12|1|The overlap includes 2 × 3 = 6 cells.|Area model',
        'Simplify 6/12.|1/2|6/6|1/6|2/1|Divide numerator and denominator by six to preserve the value.|Simplification',
        'Multiplying a positive amount by 1/2 does what?|Halves it|Always doubles it|Adds one half to it|Leaves it unchanged|One half of an amount is half the original amount.|Product meaning',
        'Which region represents a fraction product in the two-shading model?|The overlap|Every cell with either shading|Only the unshaded cells|Only the border|The overlap shows the part that belongs to both selected shares.|Area model',
        'What is (3/5) × (2/3) simplified?|2/5|5/8|1/5|6/8|The product is 6/15, which simplifies by three to 2/5.|Fraction product',
        'Is a common denominator needed before fraction multiplication?|No|Yes, always|Only if both are positive|Only if one numerator is one|Multiply numerator products and denominator products directly.|Procedure',
        'One third of 3/4 meter is what length?|1/4 meter|1 meter|3/7 meter|1/3 meter|The product is 3/12 meter, which simplifies to one fourth.|Word problem',
        'What is (2/5) × (5/6) simplified?|1/3|7/11|2/6 plus 5|5/3|The product 10/30 simplifies to 1/3.|Fraction product',
        'Why is (2/3) × (3/4) smaller than 3/4?|It takes only two thirds of that amount|Multiplication always adds|The whole grew|The denominator is ignored|A fraction between zero and one takes only part of the other positive factor.|Product meaning',
      ]),
  'g6': subjectLesson(
      subject: 'Mathematics',
      grade: 'g6',
      title: 'Unit Prices and Better Buys',
      prerequisite: 'mathematics.g6.statistics',
      objectives: [
        'Calculate a price per one item.',
        'Compare packages using consistent units.',
        'Distinguish lower unit price from lower total cost.'
      ],
      introduction:
          'The cheaper package is not always the better value per item. A unit rate compares each package on the same scale, such as credits per notebook or credits per kilogram.',
      explanation:
          'A unit price is cost divided by quantity. Three notebooks costing ninety credits have unit price 90 ÷ 3 = 30 credits per notebook. Five costing 125 credits have unit price 125 ÷ 5 = 25 credits per notebook. The second package costs more overall but less for each notebook. Write the unit in the order used: credits per notebook is different from notebooks per credit. Reversing the division gives another rate, not the same unit price.',
      application:
          'Compare equivalent items with the same unit. A 500 g packet costs eighty credits, so it costs 160 credits per kilogram because 500 g is half a kilogram. A 1 kg packet costs 150 credits, so its unit price is lower. A purchase decision also depends on the quantity you need and the money available. A larger package with a lower unit price may be unsuitable if it exceeds the budget or cannot be used. Unit price answers a precise question about cost per quantity; it does not decide every practical issue.',
      worked:
          'Pack A has four pens for sixty credits; pack B has six for eighty-four. Step 1: A costs 60 ÷ 4 = 15 per pen. Step 2: B costs 84 ÷ 6 = 14 per pen. Step 3: B has lower unit price, but its total cost is twenty-four credits higher. Explain both facts instead of calling it simply cheaper.',
      guided:
          'A 2 kg bag costs 180 credits and a 3 kg bag costs 255. Find each unit price. Which has lower price per kilogram? Which total purchase costs less?',
      solution:
          'The rates are ninety and eighty-five credits per kilogram. The 3 kg bag has the lower unit price, while the 2 kg bag has the lower total price of 180 credits.',
      mistakes:
          'Do not compare a price per gram with a price per kilogram without converting. Divide cost by quantity for unit price. A lower unit price does not guarantee the larger package fits the budget.',
      recap:
          'Unit price puts packages on a common one-unit scale. Divide cost by quantity, use matching units, and report unit value separately from total purchase cost.',
      visual: primaryMathVisuals['mathematics-g6-authored']!,
      questions: [
        'Three notebooks cost 90 credits. Unit price is what?|30 credits per notebook|3 credits per notebook|270 credits per notebook|90 notebooks per credit|Divide total cost ninety by three notebooks.|Unit rate',
        'Five notebooks cost 125 credits. Unit price is what?|25 credits per notebook|120 credits per notebook|625 credits per notebook|5 credits per notebook|The unit price is 125 ÷ 5 = 25 credits per notebook.|Unit rate',
        'Which rate expresses unit price?|Credits per kilogram|Kilograms per credit|Credits plus kilograms|Only package color|Unit price gives cost for one quantity unit.|Units',
        'A 500 g packet costs 80 credits. Price per kilogram is what?|160 credits|80 credits|40 credits|500 credits|One kilogram contains two such half-kilogram quantities.|Unit conversion',
        'A pack has lower unit price but higher total price. Is that possible?|Yes, it can contain more items|No, unit and total are identical|Only if quantity is zero|Only if prices have no units|A larger pack can cost more overall while costing less per item.|Total and unit price',
        'Four pens cost 60 credits. Six cost 84. Which has lower unit price?|Six-pen pack|Four-pen pack|Both equal|Neither can be compared|The rates are fifteen and fourteen credits per pen.|Comparison',
        'What must match before comparing unit prices?|The quantity units|The package color|The store logo only|The word count on the label|Rates must refer to the same quantity unit for direct comparison.|Units',
        'Why might a lower-unit-price large pack be unsuitable?|Its total cost can exceed the budget|Its unit price is always false|It has no quantity|Division stops working|A unit rate does not remove practical budget and quantity constraints.|Decision interpretation',
        'A 2 kg bag costs 180 credits. Its unit price is what?|90 credits per kg|180 credits per kg|360 credits per kg|2 credits per kg|Divide total cost 180 by two kilograms.|Unit rate',
        'A 3 kg bag costs 255 credits. Compare it with 90 credits per kg.|It is lower at 85 credits per kg|It is higher at 255 credits per kg|It is equal at 90 credits per kg|It is zero per kg|The calculated rate 255 ÷ 3 = 85 is lower than ninety.|Comparison',
        'A learner divides notebooks by cost and labels the answer credits per notebook. What is wrong?|The rate is inverted|The notebook count must be zero|All division is invalid|A label changes the calculation|Quantity divided by cost gives notebooks per credit, not credits per notebook.|Units',
      ]),
};
