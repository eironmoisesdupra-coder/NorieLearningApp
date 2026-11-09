import '../authored/core_math_unit.dart';
import 'mathematics_authoring.dart';

final depedMath1 = <CoreMathUnit>[
  mathUnit(
      title: 'Shapes and Numbers to 100',
      aims: [
        'Name shapes by their sides and corners.',
        'Count and compare numbers to 100.',
        'Use position words through tenth.'
      ],
      idea:
          'A triangle has three straight sides and three corners. A square has four equal sides and four square corners. A rectangle has four square corners. Turning a shape does not change its name. Two matching triangles can make a square. Count each object once. Ten groups of ten make 100. On a number line, numbers grow as you move right. First, second, and third tell positions, not how many.',
      model: {
        'Triangle': '3 sides and 3 corners, even when turned.',
        'Square': '4 equal sides and 4 square corners.',
        'Number line': '16, 17, 18, 19, 20: each step adds one.',
        'Position': 'A, B, C: B is second from the left.'
      },
      worked:
          'Count 3 groups of ten and 4 loose shells. First count the groups: 10, 20, 30. Next count four more: 31, 32, 33, 34. Write 34. Check by counting every shell once.',
      tryIt:
          'A row from the left is Ana, Ben, Cora. Who is third? Which is greater, 18 or 15?',
      check:
          'Cora is third. Count Ana first and Ben second. Eighteen is greater: it is three steps after fifteen.',
      avoid:
          'Do not call a turned square a different shape. Start counting positions at the end named in the question.',
      remember:
          'Use sides and corners to name shapes. Count once per object. A position tells a place in a row.',
      bank: '''
How many sides has a triangle?|3|2;4;5|Trace the three straight edges.
Which shape has four equal sides and four square corners?|Square|Triangle;Circle;Pentagon|All four sides match and each corner is square.
What comes just after 69?|70|68;60;79|One more than 69 is 70.
What is one less than 40?|39|41;30;49|Move one step back from 40.
Which is greater: 17 or 12?|17|12;They are equal;Neither is a number|Seventeen comes after twelve when counting.
Put 9, 3, 12 in order from least.|3, 9, 12|12, 9, 3;9, 3, 12;3, 12, 9|Start with three, then nine, then twelve.
From the left, a row is cat, dog, hen. Which is second?|Dog|Cat;Hen;None|The dog follows the first animal.
How many are ten groups of ten?|100|10;20;90|Count tens ten times to reach one hundred.
Two matching triangles join along a square's diagonal. What whole do they make?|A square|A circle;A line;A single triangle|The diagonal splits the square into two matching triangles.
What number is 8 tens and 2 ones?|82|28;80;12|Eighty and two make eighty-two.
A learner is ninth in line. One learner stands just behind. What position is that learner?|Tenth|Eighth;First;Ninth|The position after ninth is tenth.
'''),
  mathUnit(
      title: 'Putting Together to 20',
      aims: [
        'Split a number into two parts.',
        'Add by counting on to 20.',
        'Find a missing part in an addition story.'
      ],
      idea:
          'Addition puts groups together. In 6 + 3, keep six in mind and count three more: seven, eight, nine. A number can have different parts: 8 is 5 and 3 or 4 and 4. Adding zero leaves the group unchanged. Swapping the two groups does not change how many there are.',
      model: {
        'Part': '7 red beads',
        'Other part': '5 blue beads',
        'Whole': '7 + 5 = 12 beads',
        'Make ten': '7 + 3 + 2 = 10 + 2'
      },
      worked:
          'Add 8 + 5. First notice eight needs two to make ten. Split five into two and three. Add 8 + 2 = 10. Add the three left over: 13. Check by counting five steps after eight.',
      tryIt:
          'There are 6 birds. Four more land. How many now? What part is missing in 7 + __ = 10?',
      check:
          'Six and four make ten birds. Seven needs three more to make ten, so the missing part is three.',
      avoid:
          'Count on after the starting number, not including it as the first added step. Zero is not one extra object.',
      remember:
          'Put together, count on, or make ten. Both parts must be counted.',
      bank: '''
What is 4 + 3?|7|6;8;1|Count five, six, seven after four.
What is 9 + 0?|9|0;10;90|Zero adds no objects.
What is 6 + 6?|12|11;13;0|Two groups of six contain twelve.
Which has the same total as 3 + 8?|8 + 3|8 - 3;3 + 3;8 + 8|Changing the order of the parts keeps the total.
What is missing in 5 + __ = 9?|4|3;5;9|Five needs four more to reach nine.
What is 10 + 7?|17|7;16;18|Ten and seven ones make seventeen.
Which two parts make 10?|6 and 4|6 and 3;5 and 4;8 and 3|Six plus four reaches ten.
What is 7 + 8?|15|14;16;1|Use 7 + 3 + 5 to make fifteen.
Nine shells and five more make how many?|14|13;15;4|Nine plus one makes ten and four remain.
What is missing in __ + 6 = 18?|12|11;13;24|Twelve and six make eighteen.
Lia has 8 red and 4 blue buttons. She adds 3 green buttons. Total?|15|12;14;16|First 8 + 4 = 12, then 12 + 3 = 15.
'''),
  mathUnit(
      title: 'Measuring and Adding Tens and Ones',
      aims: [
        'Measure with equal small units.',
        'Split two-digit numbers into tens and ones.',
        'Add without exchanging tens.'
      ],
      idea:
          'To measure a pencil with clips, use clips of the same size. Place them end to end with no gaps or overlaps. A longer object uses more of the same unit. In 43, four tens mean forty and three ones mean three. Add tens to tens and ones to ones. Counting by twos, fives, or tens is a quick way to count equal groups.',
      model: {
        'Pencil': '[clip][clip][clip][clip] = 4 equal clips long',
        '43': '4 tens + 3 ones',
        '43 + 25': '6 tens + 8 ones = 68',
        'Count fives': '5, 10, 15, 20'
      },
      worked:
          'Add 32 + 14. Split into 30 + 2 and 10 + 4. Join the tens: 40. Join the ones: 6. Put them together: 46. Check that the ones total less than ten, so no exchange is needed.',
      tryIt:
          'A book is 6 clips long and a card is 4 of the same clips long. How much longer is the book? Add 51 + 26.',
      check:
          'The book is two clips longer because 6 - 4 = 2. Add 50 + 20 = 70 and 1 + 6 = 7 to get 77.',
      avoid:
          'Different-sized clips cannot be compared fairly. In 43, the four means forty, not four.',
      remember:
          'Measure with one repeated unit. Keep tens and ones in their own places when adding.',
      bank: '''
What value does 6 have in 64?|60|6;4;64|Six is in the tens place.
What number is 5 tens and 8 ones?|58|85;13;50|Fifty plus eight is fifty-eight.
What is 24 + 13?|37|36;47;11|Two tens plus one ten and four plus three ones make 37.
What comes after 35 when counting by fives?|40|36;45;30|Add another five.
What comes after 76 when counting by twos?|78|77;80;74|Two more than 76 is 78.
Which gives a fair length measurement?|Equal clips with no gaps|Mixed clips;Clips with gaps;Clips piled up|Repeated equal units must touch end to end.
A ribbon is 8 cubes long. A string is 5 of the same cubes long. Difference?|3 cubes|13 cubes;5 cubes;8 cubes|Eight minus five leaves three units.
What is 42 + 7?|49|47;59;35|Keep four tens and add two plus seven ones.
Which number is largest?|91|19;81;89|Nine tens exceed eight tens or one ten.
What is 63 + 24?|87|77;89;39|Six tens plus two tens and three plus four ones make 87.
Two sticks measure 3 and 5 equal blocks. End to end they measure what?|8 blocks|2 blocks;15 blocks;5 blocks|Join the lengths: three plus five equals eight.
'''),
  mathUnit(
      title: 'Taking Away and Finding Parts',
      aims: [
        'Subtract by taking away.',
        'Subtract tens and ones without exchanging.',
        'Find a missing number and check with addition.'
      ],
      idea:
          'Subtraction can tell how many are left or how far apart two groups are. Take three from eight to leave five. For 58 - 24, take two tens from five tens and four ones from eight ones. The answer is three tens and four ones. Addition can check subtraction: the part left plus the part removed makes the starting whole.',
      model: {
        'Whole': '58 = 5 tens and 8 ones',
        'Remove': '24 = 2 tens and 4 ones',
        'Left': '34 = 3 tens and 4 ones',
        'Check': '34 + 24 = 58'
      },
      worked:
          'There are 17 mangoes and 6 are sold. Start at seventeen. Take away six: 17 - 6 = 11. Check eleven left and six sold make seventeen. Answer: eleven mangoes.',
      tryIt: 'Find 76 - 32. Then find the missing part in 9 + __ = 16.',
      check:
          'Seven tens minus three tens is four tens. Six ones minus two ones is four ones: 44. Nine needs seven more to make sixteen.',
      avoid:
          'Do not reverse the numbers just to subtract a larger digit. These examples need no exchange. An equals sign means both sides name the same amount.',
      remember:
          'Whole minus part gives the other part. Add the two parts to check.',
      bank: '''
What is 9 - 4?|5|4;6;13|Remove four from nine and five remain.
What is 18 - 8?|10|8;26;9|Eight ones leave one ten.
What is 67 - 25?|42|52;44;92|Six minus two tens and seven minus five ones give 42.
What is 45 - 3?|42|48;15;43|Remove three ones from five ones.
What is missing in 6 + __ = 14?|8|7;9;20|Six and eight make fourteen.
What is missing in 15 - __ = 9?|6|5;7;24|Nine left plus six removed rebuilds fifteen.
Which equals 8 - 3?|9 - 4|8 + 3;9 - 3;7 - 3|Both expressions equal five.
How can you check 36 - 12 = 24?|24 + 12 = 36|36 + 12 = 24;24 - 12 = 36;36 - 24 = 24|Add the part left and the part taken away.
A tray has 16 eggs. Five are used. How many remain?|11|10;12;21|Sixteen minus five is eleven.
What is 89 - 46?|43|33;45;53|Eight minus four tens and nine minus six ones leave 43.
Ben has 19 cards and Ana has 12. How many more has Ben?|7|31;6;8|Subtract twelve from nineteen to compare the groups.
'''),
  mathUnit(
      title: 'Picture Data and Repeating Patterns',
      aims: [
        'Read a picture chart with one picture per object.',
        'Make a total and compare categories.',
        'Find and repeat a pattern unit.'
      ],
      idea:
          'Ask the same question to each person and record one answer each. A picture chart can show one picture for each vote. Count the pictures in each row. Keep rows lined up so they are easy to compare. A repeating pattern has a small part that repeats in the same order, such as red, blue, red, blue. The repeating part is red, blue.',
      model: {
        'Fruit survey': 'One star means one vote.',
        'Banana row': '* * * * = 4 votes',
        'Mango row': '* * = 2 votes',
        'Pattern': 'A B B / A B B / A B B'
      },
      worked:
          'Four learners choose banana and two choose mango. Count all six votes. Compare four with two: banana has two more votes. For A B B A B B, mark groups of three. The next letter starts a new group, so it is A.',
      tryIt:
          'A chart has 3 cat pictures and 5 dog pictures, one picture per pet. Which pet is more common? Extend 2, 4, 2, 4.',
      check:
          'Dogs are more common by two because 5 - 3 = 2. The number pattern repeats 2, 4, so the next two terms are 2, 4.',
      avoid:
          'A picture means one here, not five or ten. Do not treat a repeating pattern as a growing number pattern.',
      remember:
          'Read the picture key, count each row, and compare. Find the smallest repeating part before extending a pattern.',
      bank: '''
One picture means one vote. A row has 6 pictures. Votes?|6|1;5;12|Count one vote for each picture.
Red has 4 votes and blue has 3. Total?|7|1;6;8|Add four and three votes.
Cats have 2 votes and dogs have 5. Which has more?|Dogs|Cats;Equal;Cannot compare|Five is greater than two.
Five votes versus two votes differ by how many?|3|7;2;5|Subtract two from five.
What follows A B A B A?|B|A;C;D|The repeating unit is A B.
What follows clap tap tap clap tap tap?|Clap|Tap;Jump;Silence|A new clap tap tap unit begins.
Which is the repeating unit of 1 3 3 1 3 3?|1 3 3|1 3;3 1;1 1|The three-term block repeats exactly.
What is a fair way to record a class fruit vote?|One answer per learner|Count one learner twice;Guess every answer;Skip quiet learners|Each learner should contribute once.
A chart has 7 sun pictures and 4 rain pictures. Total days?|11|3;10;12|Seven plus four equals eleven.
Extend square circle triangle square circle __.|Triangle|Square;Circle;Rectangle|The third shape completes the repeating group.
Ana says 3 pictures always mean 6 votes. The key says one picture is one vote. Correct total?|3 votes|6 votes;9 votes;1 vote|Use this chart's key rather than guessing a scale.
'''),
  mathUnit(
      title: 'Halves Quarters and Turns',
      aims: [
        'Recognize equal halves and quarters.',
        'Compare half and quarter of the same whole.',
        'Follow clockwise and counterclockwise turns.'
      ],
      idea:
          'A half is one of two equal parts. A quarter is one of four equal parts. Equal parts must be the same size. For the same whole, a half is larger than a quarter. Two quarters make a half. Turning changes which way an object faces. Clockwise turns follow clock hands. A quarter turn is one of four equal turns around. Two quarter turns make a half turn.',
      model: {
        'Whole strip': '[1/4][1/4][1/4][1/4]',
        'Half strip': 'Two quarters = 1/2',
        'Quarter turn clockwise': 'Up becomes right',
        'Half turn': 'Up becomes down'
      },
      worked:
          'A sandwich is cut into four equal pieces. One piece is one quarter. Two pieces are two quarters, which make a half. Check that all four pieces rebuild the whole. If an arrow points up, one clockwise quarter turn makes it point right.',
      tryIt:
          'How many quarters make one whole? An arrow points right. Where does a half turn point it?',
      check:
          'Four equal quarters make one whole. A half turn points the arrow the opposite way, so right becomes left.',
      avoid:
          'Four unequal pieces are not four quarters. Compare fractions only when the wholes are the same size.',
      remember:
          'Two halves or four quarters make a whole. A half turn faces the opposite direction.',
      bank: '''
One of two equal parts is called what?|A half|A quarter;A whole;A corner|Two equal parts split one whole into halves.
One of four equal parts is called what?|A quarter|A half;Two wholes;A side|Four equal parts make quarters.
How many halves make a whole?|2|1;3;4|Join the two equal halves.
How many quarters make a whole?|4|2;3;8|Four equal quarters rebuild the whole.
Of the same loaf, which is more: half or quarter?|Half|Quarter;Equal;Neither|Half contains two quarters.
Two quarters of a whole equal what?|One half|One quarter;Two wholes;One whole|Two of the four equal pieces are half.
An arrow points up. Quarter turn clockwise points where?|Right|Left;Down;Up|Follow a clock hand from up toward right.
An arrow points up. Quarter turn counterclockwise points where?|Left|Right;Down;Up|Turn against the clock hands toward left.
An arrow points down. Half turn points where?|Up|Down;Left;Right|Half a turn points in the opposite direction.
Three quarters plus one quarter make what?|One whole|One half;Two quarters;Two wholes|All four equal pieces are present.
Which cut makes halves?|Two equal-sized pieces|One tiny and one large piece;Three equal pieces;Four unequal pieces|Halves require exactly two equal parts.
'''),
  mathUnit(
      title: 'Peso Coins Bills and Change',
      aims: [
        'Read peso amounts to 100.',
        'Combine coins and bills.',
        'Solve one-step buying and change problems.'
      ],
      idea:
          'The peso sign is ₱. A coin or bill has a written value. Its value is not its physical size. We can make one amount in different ways: two ₱10 coins have the same value as a ₱20 bill. Add prices to find the total. Subtract the price from the money paid to find change.',
      model: {
        '₱20': '₱10 + ₱10',
        '₱50 + ₱20': '₱70 altogether',
        'Pay ₱50 for ₱30': '₱50 - ₱30 = ₱20 change'
      },
      worked:
          'A pen costs ₱12 and a pad costs ₱15. First join the tens: ₱20. Then join the ones: ₱7. The total is ₱27. Check 12 + 15 = 27. The total is less than ₱100.',
      tryIt:
          'You pay ₱50 for a ₱35 snack. How much change? Can three ₱20 bills pay for a ₱60 item exactly?',
      check:
          '₱50 - ₱35 = ₱15 change. Three twenties make ₱60, so they pay exactly.',
      avoid:
          'Change is money paid minus price, not their sum. Count values rather than the number of coins.',
      remember:
          'Different coins and bills can make equal amounts. Add prices and subtract to find change.',
      bank: '''
Two ₱5 coins are worth what?|₱10|₱5;₱2;₱25|Five plus five makes ten pesos.
A ₱20 bill and a ₱10 coin total what?|₱30|₱10;₱20;₱40|Twenty plus ten equals thirty.
Which is worth more?|₱50 bill|₱20 bill;₱10 coin;₱5 coin|Fifty exceeds twenty, ten, and five.
What is ₱23 + ₱14?|₱37|₱36;₱47;₱9|Add two tens and one ten, then three and four ones.
Pay ₱20 for a ₱12 item. Change?|₱8|₱32;₱12;₱10|Twenty minus twelve leaves eight.
How many ₱10 coins make ₱50?|5|4;6;10|Count ten, twenty, thirty, forty, fifty.
Which equals ₱40?|Two ₱20 bills|Two ₱10 coins;One ₱50 bill;Four ₱5 coins|Twenty plus twenty makes forty.
What is ₱70 - ₱20?|₱50|₱90;₱40;₱60|Remove two tens from seven tens.
A snack costs ₱24 and juice costs ₱15. Total?|₱39|₱9;₱38;₱49|Twenty-four plus fifteen is thirty-nine.
Pay ₱50 for a ₱28 book. Change?|₱22|₱78;₱32;₱28|Twenty-eight plus twenty-two rebuilds fifty.
Which pays ₱100 exactly?|Two ₱50 bills|One ₱50 bill;Three ₱20 bills;Five ₱10 coins|Fifty plus fifty equals one hundred.
'''),
  mathUnit(
      title: 'Clock Time and Calendar Days',
      aims: [
        'Read hour, half-hour, and quarter-hour times.',
        'Put days and months in order.',
        'Solve short time and calendar problems.'
      ],
      idea:
          'The short hand tells the hour. The long hand tells minutes. At an o’clock time the long hand points to 12. At half past it points to 6. At quarter past it points to 3, and at quarter to it points to 9. There are seven days in a week and twelve months in a year. A calendar places each date under its day of the week.',
      model: {
        '3:00': 'Short hand at 3; long hand at 12.',
        '3:15': 'Quarter past 3; long hand at 3.',
        '3:30': 'Half past 3; short hand between 3 and 4.',
        '3:45': 'Quarter to 4; long hand at 9.'
      },
      worked:
          'A game begins at 2:00 and lasts half an hour. First read the hour as two. A half hour moves the long hand halfway around to six. The end time is 2:30. Check the hour hand is between two and three.',
      tryIt:
          'What time is a quarter hour after 4:00? If today is Tuesday, what day is tomorrow?',
      check:
          'A quarter hour after 4:00 is 4:15. The next day after Tuesday is Wednesday.',
      avoid:
          'The long hand at 3 means fifteen minutes, not three minutes. A month is not always exactly four weeks.',
      remember:
          'Read both hands. Use the calendar to check dates, weekdays, and month order.',
      bank: '''
At 5:00, where is the long hand?|12|5;6;3|An o’clock time has zero minutes.
Half past 7 is what time?|7:30|7:00;7:15;7:45|Half an hour is thirty minutes.
Quarter past 8 is what time?|8:15|8:30;8:45;9:15|A quarter hour is fifteen minutes.
Quarter to 6 is what time?|5:45|6:15;6:45;5:15|Fifteen minutes before six is 5:45.
How many days are in one week?|7|5;6;12|A week runs through seven named days.
Which day comes after Friday?|Saturday|Thursday;Sunday;Monday|Saturday follows Friday.
Which month comes after March?|April|February;May;January|The month order is January, February, March, April.
How many months are in one year?|12|7;10;30|There are twelve named months.
A lesson starts at 9:00 and lasts one hour. End time?|10:00|9:30;8:00;11:00|Move forward one whole hour.
If the calendar shows the 10th is Monday, what day is the 12th?|Wednesday|Tuesday;Thursday;Sunday|The 11th is Tuesday and the 12th is Wednesday.
What is half an hour after 11:30?|12:00|11:00;11:45;12:30|Thirty more minutes complete the hour.
'''),
];
