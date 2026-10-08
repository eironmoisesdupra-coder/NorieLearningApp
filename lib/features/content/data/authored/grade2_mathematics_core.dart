import 'core_math_unit.dart';

const grade2MathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "Place Value to 1000",
    objectives: [
      "Read hundreds, tens, and ones.",
      "Write expanded form.",
      "Compare numbers using their highest place."
    ],
    focus:
        "A three-digit number groups quantities into hundreds, tens, and ones.",
    explanation:
        "Ten ones make one ten, and ten tens make one hundred. In 342, the 3 means 300, the 4 means 40, and the 2 means 2. Write 342 = 300 + 40 + 2. A zero can hold an empty place: 305 has no tens, not no value. Compare hundreds first, then tens if hundreds match, then ones. A thousand is ten hundreds; 1000 needs a new place.",
    model: {
      "305": "3 hundreds + 0 tens + 5 ones",
      "342": "3 hundreds + 4 tens + 2 ones",
      "470 > 407": "Hundreds match; seven tens exceeds zero tens."
    },
    worked:
        "Build 526. Step 1: show five hundreds. Step 2: add two tens. Step 3: add six ones. Step 4: combine 500 + 20 + 6 = 526.",
    guided: "Write 608 in expanded form and compare it with 680.",
    solution:
        "608 = 600 + 0 + 8. Both have six hundreds, but 680 has eight tens, so 680 is greater.",
    mistakes:
        "Do not swap tens and ones. The zero in 608 holds the tens place; it does not erase the six hundreds.",
    recap:
        "Each digit value depends on its place. Compare from the largest place and keep zero placeholders.",
    questions: [
      "What is the value of 3 in 342?|300|3;30;342|The 3 counts three hundreds.",
      "Which expanded form is 526?|500 + 20 + 6|50 + 20 + 6;500 + 2 + 6;500 + 60 + 2|Five hundreds, two tens, and six ones total 526.",
      "How many tens are in the tens place of 305?|0|3;5;30|The middle zero represents no tens.",
      "Which number is larger: 470 or 407?|470|407;They are equal;Neither is three-digit|Hundreds match; compare seven tens with zero tens.",
      "Four hundreds and eight ones make what?|408|480;48;4008|The missing tens place is held by zero.",
      "What is one more than 999?|1000|990;100;9990|Regroup ten ones, ten tens, and ten hundreds.",
      "Which digit is in the ones place of 761?|1|7;6;76|The rightmost digit counts single ones.",
      "What is 600 + 30 + 9?|639|693;609;936|The digits record six hundreds, three tens, nine ones.",
      "Seven hundreds, two tens, and four ones make what?|724|742;274;704|Combine 700 + 20 + 4.",
      "Which is greater: 608 or 680?|680|608;They are equal;Both are 600|Eight tens is more than zero tens.",
      "How many hundreds make 1000?|10|1;100;1000|Ten groups of one hundred total one thousand."
    ],
  ),
  CoreMathUnit(
    title: "Addition Strategies",
    objectives: [
      "Decompose addends into tens and ones.",
      "Regroup ten ones into one ten.",
      "Check a sum with another strategy."
    ],
    focus: "Adding by place value helps us combine two-digit quantities.",
    explanation:
        "Split each addend into tens and ones. For 46 + 27, combine 40 + 20 = 60 and 6 + 7 = 13. Thirteen ones are one ten and three ones, so 60 + 13 = 73. You may instead count on or bridge to a nearby ten. All strategies must keep the original quantities unchanged. Check with a second method rather than guessing from one digit.",
    model: {
      "46 + 27": "40 + 20 + 6 + 7",
      "60 + 13": "60 + 10 + 3 = 73",
      "38 + 5": "38 + 2 + 3 = 43"
    },
    worked:
        "Find 58 + 16. Step 1: add 50 + 10 = 60. Step 2: add 8 + 6 = 14. Step 3: regroup 14 as 10 + 4. Step 4: combine 60 + 10 + 4 = 74.",
    guided:
        "Use making a ten to find 39 + 7. Split the seven without changing its total.",
    solution: "Split seven into one and six. 39 + 1 = 40, then 40 + 6 = 46.",
    mistakes:
        "Do not drop the regrouped ten. Splitting seven into one and six keeps all seven; adding seven again would double-count it.",
    recap:
        "Decompose, combine matching places, regroup if needed, and check the total.",
    questions: [
      "46 + 27 equals what?|73|63;83;72|Sixty tens-value plus thirteen ones gives 73.",
      "58 + 16 equals what?|74|64;73;84|Sixty plus fourteen equals seventy-four.",
      "To bridge 38 + 5 to forty, split five into what?|2 and 3|1 and 3;2 and 5;3 and 4|Thirty-eight needs two, leaving three of the five.",
      "Which decomposition preserves 27?|20 + 7|2 + 7;20 + 2;70 + 2|Two tens and seven ones still total 27.",
      "How do thirteen ones regroup?|1 ten and 3 ones|3 tens and 1 one;13 tens;1 ten and 13 ones|Ten of the thirteen become one ten.",
      "35 + 20 equals what?|55|37;45;75|Add two tens while keeping five ones.",
      "Which checks 46 + 27 = 73?|73 − 27 = 46|73 + 27 = 46;46 − 27 = 73;27 − 73 = 46|Removing one addend rebuilds the other.",
      "29 + 1 equals what?|30|20;291;28|One more completes the next ten.",
      "39 + 7 equals what?|46|45;47;36|One makes forty and the remaining six make 46.",
      "67 + 25 equals what?|92|82;91;102|Eighty plus twelve regroups to ninety-two.",
      "Fourteen red beads and twenty-eight blue beads total what?|42|32;41;52|Add thirty plus twelve to obtain forty-two beads."
    ],
  ),
  CoreMathUnit(
    title: "Subtraction Strategies",
    objectives: [
      "Subtract tens and ones with regrouping.",
      "Explain an exchanged ten.",
      "Check subtraction using addition."
    ],
    focus:
        "Subtraction finds what remains or the difference between quantities.",
    explanation:
        "For 52 − 28, two ones cannot lose eight ones in a whole-number take-away model. Exchange one of the five tens for ten ones: four tens and twelve ones still total 52. Subtract eight ones to leave four, and two tens to leave two tens. The answer is 24. A number line can instead count up from 28 to 52: two to 30, twenty to 50, and two to 52.",
    model: {
      "52": "5 tens + 2 ones = 4 tens + 12 ones",
      "52 − 28": "(40 − 20) + (12 − 8) = 24",
      "Check": "24 + 28 = 52"
    },
    worked:
        "Find 63 − 37. Step 1: exchange one ten to write five tens and thirteen ones. Step 2: 13 − 7 = 6. Step 3: 5 tens − 3 tens = 2 tens. Step 4: 26 + 37 = 63 checks the result.",
    guided: "Find 41 − 19 and check by addition.",
    solution:
        "Exchange a ten: three tens and eleven ones. 11 − 9 = 2 and 3 tens − 1 ten = 2 tens. 22 + 19 = 41.",
    mistakes:
        "Do not subtract the smaller digit from the larger regardless of place. Exchanging a ten changes both the tens and ones counts but not the total.",
    recap:
        "Regroup without changing the starting number, subtract corresponding places, and add to check.",
    questions: [
      "52 − 28 equals what?|24|36;34;26|Exchange a ten: twelve ones minus eight leaves four.",
      "63 − 37 equals what?|26|34;36;24|Thirteen minus seven gives six; fifty minus thirty gives twenty.",
      "Which equals 52 after exchanging a ten?|4 tens and 12 ones|5 tens and 12 ones;4 tens and 2 ones;12 tens and 4 ones|Forty plus twelve still makes fifty-two.",
      "Which addition checks 41 − 19 = 22?|22 + 19 = 41|41 + 19 = 22;22 + 41 = 19;19 − 22 = 41|The remainder plus removed quantity rebuilds the start.",
      "80 − 30 equals what?|50|77;110;40|Eight tens minus three tens leaves five tens.",
      "37 − 0 equals what?|37|0;36;38|Removing nothing keeps the quantity unchanged.",
      "Count up from 28 to 52. The total increase is what?|24|80;20;26|Two to thirty, twenty to fifty, and two to fifty-two.",
      "Why does a ten become ten ones?|Both represent the same quantity|A ten becomes one one;The number must grow;The ones are discarded|Place-value exchange preserves the total.",
      "41 − 19 equals what?|22|32;24;20|Regroup to three tens and eleven ones, then subtract.",
      "72 − 46 equals what?|26|34;36;24|Six tens and twelve ones minus four tens and six ones gives 26.",
      "A box has fifty pencils; seventeen leave. How many remain?|33|43;37;67|Regroup fifty as forty and ten, then subtract seventeen."
    ],
  ),
  CoreMathUnit(
    title: "Equal Groups",
    objectives: [
      "Identify equal-sized groups.",
      "Connect repeated addition with multiplication.",
      "Separate group count from group size."
    ],
    focus: "Equal groups let us count several sets using one repeated size.",
    explanation:
        "Three plates with four crackers each contain 4 + 4 + 4 = 12 crackers. There are three groups, each with size four. Write 3 × 4 = 12 using groups first in this lesson. An array shows three rows of four objects. Four groups of three also total twelve, but describe a different grouping. Unequal groups cannot be modeled as one fixed group size times their count.",
    model: {
      "3 groups of 4": "4 + 4 + 4 = 12",
      "Array: 3 rows × 4 columns": "Each row has four; all rows total twelve."
    },
    worked:
        "Count five bags holding two shells each. Step 1: count five bags. Step 2: note two shells in every bag. Step 3: add 2 + 2 + 2 + 2 + 2. Step 4: total ten; write 5 × 2 = 10.",
    guided:
        "Four boxes each hold three crayons. Give repeated addition, group count, group size, and total.",
    solution:
        "There are four groups of three. 3 + 3 + 3 + 3 = 12, so twelve crayons.",
    mistakes:
        "Do not add group count to group size. Three groups of four is twelve, not seven. Check that every group has the stated size.",
    recap:
        "For equal groups, total equals group count multiplied by group size.",
    questions: [
      "Three groups of four total what?|12|7;9;16|Add four three times.",
      "Five groups of two total what?|10|7;12;5|Five copies of two make ten.",
      "Four boxes each contain three crayons. Group size is what?|3|4;7;12|Each single box holds three crayons.",
      "Which addition shows four groups of three?|3 + 3 + 3 + 3|4 + 3;4 + 4 + 4 + 4;3 + 3 + 3|One three is needed for each of four groups.",
      "An array has two rows of five. Total objects are what?|10|7;25;2|Two complete rows each contribute five.",
      "Are groups of two, two, and three equal groups?|No|Yes;Only if arranged in rows;Only if named bags|One group has a different size.",
      "Three groups of four and four groups of three have what equal?|The total of twelve|The group count;The group size;Every arrangement|Both products are twelve despite different groupings.",
      "Two groups of zero have what total?|0|2;20;1|Neither empty group contributes objects.",
      "Six groups of three contain what?|18|9;15;21|Add six copies of three.",
      "Seven pairs of socks contain how many socks?|14|7;9;12|Each pair contains two socks.",
      "Which describes twenty objects as equal groups?|Four groups of five|Four groups of six;Three groups of five;Two groups of eight|Four equal fives total twenty."
    ],
  ),
  CoreMathUnit(
    title: "Length, Time & Money",
    objectives: [
      "Use matching measurement units.",
      "Find simple elapsed times.",
      "Calculate total cost and change."
    ],
    focus: "Measurement and money problems need numbers with clear units.",
    explanation:
        "A ruler measures length from its zero mark, not necessarily its edge. Centimeters and meters are length units; one meter equals one hundred centimeters. On a clock, an hour has sixty minutes. From 2:15 to 2:45 is thirty minutes. For money, combine the listed amounts, then subtract cost from the amount paid to find change. Do not add centimeters to minutes: the quantities describe different things.",
    model: {
      "1 meter": "100 centimeters",
      "2:15 → 2:45": "30 minutes elapsed",
      "Pay 50 credits; cost 32": "Change = 50 − 32 = 18 credits"
    },
    worked:
        "Buy items costing twelve and seventeen credits with forty credits. Step 1: total cost 12 + 17 = 29. Step 2: compare cost with forty. Step 3: change = 40 − 29 = 11. Step 4: check 29 + 11 = 40.",
    guided:
        "A lesson begins at 3:10 and ends at 3:35. How long is it? A thirty-credit purchase is paid with fifty; find change.",
    solution:
        "The duration is twenty-five minutes. Change is twenty credits because 50 − 30 = 20.",
    mistakes:
        "Start ruler readings at zero or subtract the start reading. An hour is sixty minutes, not one hundred. Change is payment minus cost.",
    recap:
        "Name the quantity and unit, then choose addition or subtraction that matches the situation.",
    questions: [
      "One meter equals how many centimeters?|100|10;60;1000|One meter is one hundred centimeters.",
      "An hour contains how many minutes?|60|100;24;30|Clock hours divide into sixty minutes.",
      "From 2:15 to 2:45 is how long?|30 minutes|15 minutes;45 minutes;60 minutes|Subtract fifteen from forty-five within the same hour.",
      "A fifty-credit payment covers thirty-two credits. Change is what?|18 credits|82 credits;22 credits;32 credits|Payment minus cost gives the change.",
      "Lengths three centimeters and five centimeters total what?|8 cm|2 cm;15 cm;8 minutes|Add lengths measured in the same unit.",
      "A ruler mark starts at two and ends at seven centimeters. Length is what?|5 cm|7 cm;9 cm;2 cm|Subtract the start reading from the end reading.",
      "Items cost twelve and seventeen credits. Total is what?|29 credits|5 credits;30 credits;40 credits|Join the two costs by addition.",
      "Can three centimeters and four minutes be added as one length?|No|Yes, seven centimeters;Yes, seven minutes;Only on paper|Length and time are different quantities.",
      "From 3:10 to 3:35 is how long?|25 minutes|45 minutes;10 minutes;35 minutes|Within one hour the difference is twenty-five minutes.",
      "Pay forty credits for a twenty-nine-credit purchase. Change is what?|11 credits|69 credits;21 credits;29 credits|Forty minus twenty-nine equals eleven.",
      "Two equal lengths of forty centimeters total what?|80 cm|20 cm;40 cm;100 cm|Add forty and forty with the same length unit."
    ],
  ),
];
