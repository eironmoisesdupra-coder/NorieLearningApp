import 'core_math_unit.dart';

const grade4MathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "Multi-Digit Operations",
    objectives: [
      "Align number places.",
      "Regroup in addition and subtraction.",
      "Use place value for multiplication and division."
    ],
    focus:
        "Larger numbers use the same place-value operations as smaller numbers.",
    explanation:
        "Align ones beneath ones, tens beneath tens, and hundreds beneath hundreds. In 256 + 187, thirteen ones become one ten and three ones. Tens then total fourteen, so regroup again. Subtraction may exchange a hundred for ten tens before exchanging a ten for ones. Multiplication distributes across places: 23 × 4 = 20 × 4 + 3 × 4. Division asks which product rebuilds the dividend.",
    model: {
      "256 + 187": "13 ones; 14 tens; 4 hundreds → 443",
      "23 × 4": "80 + 12 = 92",
      "84 ÷ 4": "80 ÷ 4 + 4 ÷ 4 = 21"
    },
    worked:
        "Compute 504 − 268. Step 1: exchange one hundred so there are four hundreds and ten tens. Step 2: exchange one ten, leaving nine tens and fourteen ones. Step 3: subtract to get six ones, three tens, and two hundreds. Step 4: check 236 + 268 = 504.",
    guided: "Use place-value splitting to compute 125 × 3, then check 96 ÷ 3.",
    solution:
        "125 × 3 = 300 + 60 + 15 = 375. Since 3 × 32 = 96, the quotient is 32.",
    mistakes:
        "Regrouped value must appear in the next place. A zero in the middle may require exchange from a higher place. Keep division shares consistent.",
    recap:
        "Align places, preserve value during exchange, and check with inverse operations.",
    questions: [
      "256 + 187 equals what?|443|433;343;453|Regroup thirteen ones and fourteen tens.",
      "504 − 268 equals what?|236|346;244;336|Exchange a hundred and then a ten before subtracting.",
      "23 × 4 equals what?|92|27;82;96|Eighty plus twelve gives ninety-two.",
      "84 ÷ 4 equals what?|21|20;24;80|Eighty divided by four is twenty; four divided by four is one.",
      "125 × 3 equals what?|375|128;325;350|Multiply each place value and add the products.",
      "Which alignment is correct for addition?|Ones under ones|Last nonzero digits together;Hundreds under ones;Largest digits together|Corresponding place values must be combined.",
      "When ten tens regroup, they become what?|One hundred|One ten;Ten hundreds;One thousand|Ten groups of ten total one hundred.",
      "Which checks 504 − 268 = 236?|236 + 268 = 504|504 + 268 = 236;236 − 268 = 504;268 × 236 = 504|Addition rebuilds the starting number.",
      "368 + 257 equals what?|625|615;525;635|Fifteen ones and twelve tens regroup to six hundreds.",
      "96 ÷ 3 equals what?|32|31;33;36|Three thirty-twos total ninety-six.",
      "Four boxes each hold 214 beads. Total beads?|856|218;816;846|Four times 200, ten, and four gives 800 + 40 + 16."
    ],
  ),
  CoreMathUnit(
    title: "Factors & Multiples",
    objectives: [
      "Find factor pairs.",
      "Distinguish factors from multiples.",
      "Identify common factors and common multiples."
    ],
    focus: "Factors divide a number exactly; multiples count repeated copies.",
    explanation:
        "Factors of twelve come in pairs: 1 × 12, 2 × 6, and 3 × 4. The positive factors are 1, 2, 3, 4, 6, 12. Multiples of twelve include 12, 24, 36, and continue without a largest positive multiple. A prime number is greater than one with exactly two positive factors; a composite has more. One is neither prime nor composite. Common factors divide both numbers, while common multiples are divisible by both.",
    model: {
      "12 factors": "1, 2, 3, 4, 6, 12",
      "Common factors of 12 and 18": "1, 2, 3, 6; greatest is 6",
      "Multiples of 4 and 6": "First shared positive multiple is 12"
    },
    worked:
        "Find the least common multiple of four and six. Step 1: list 4, 8, 12, 16. Step 2: list 6, 12, 18. Step 3: identify twelve as the first positive match. Step 4: check twelve divides by both without a remainder.",
    guided:
        "Find the greatest common factor of ten and fifteen. Decide whether thirteen is prime.",
    solution:
        "The shared factors are one and five, so the greatest is five. Thirteen has only one and thirteen as factors, so it is prime.",
    mistakes:
        "Factors are not the same as multiples. A common factor cannot exceed either positive number; a positive common multiple can exceed both.",
    recap:
        "Use exact products and divisibility to find pairs, primes, greatest common factors, and least common multiples.",
    questions: [
      "Which is a factor of twelve?|3|5;7;8|Twelve divided by three is the whole number four.",
      "Which is a multiple of six?|18|16;17;19|Eighteen is three copies of six.",
      "How many positive factors does a prime have?|2|1;3;0|Its only positive factors are one and itself.",
      "Why is one not prime?|It has only one positive factor|It has three factors;It is even;It has no factor|Prime numbers need exactly two distinct positive factors.",
      "Greatest common factor of 12 and 18?|6|12;18;3|Six divides both and exceeds their other common factors.",
      "Least common positive multiple of 4 and 6?|12|24;6;4|Twelve is the first positive number divisible by both.",
      "Which is prime?|13|12;15;21|Thirteen has no positive factors besides one and itself.",
      "Which pair multiplies to thirty?|5 and 6|5 and 5;4 and 6;3 and 9|Five sixes total thirty.",
      "Greatest common factor of 10 and 15?|5|10;15;3|Five is the largest factor shared by both.",
      "Least common positive multiple of 3 and 5?|15|8;10;5|Fifteen divides exactly by three and five.",
      "Which statement about multiples of seven is true?|They continue without a largest positive multiple|Only seven is a multiple;They all divide seven;There are exactly seven|Adding another seven always produces a larger multiple."
    ],
  ),
  CoreMathUnit(
    title: "Equivalent Fractions",
    objectives: [
      "Multiply both fraction terms by one factor.",
      "Simplify using common factors.",
      "Check equivalence by equal amounts."
    ],
    focus:
        "Equivalent fractions name the same quantity using different partitions.",
    explanation:
        "If a half is split into two equal smaller parts, the whole has four parts and two are selected: 1/2 = 2/4. Multiply numerator and denominator by the same nonzero number to preserve the ratio. Simplifying reverses this by dividing both by a common factor. For 6/8, divide both by two to obtain 3/4. Adding the same number to both generally changes the fraction.",
    model: {
      "1/2 = 2/4 = 4/8": "Each describes half of the same whole.",
      "6/8 → 3/4": "Divide selected and total part counts by two.",
      "2/3 → 8/12": "Multiply both by four."
    },
    worked:
        "Rewrite 3/5 with denominator twenty. Step 1: find 20 ÷ 5 = 4. Step 2: multiply numerator three by four. Step 3: write 12/20. Step 4: divide both terms by four to check 3/5.",
    guided: "Find the missing numerator in ?/18 = 2/3, then simplify 15/20.",
    solution:
        "Multiply three by six to get eighteen, so numerator is twelve. Divide fifteen and twenty by five to get 3/4.",
    mistakes:
        "Do not scale only the denominator or add a common number. Equivalence preserves the amount relative to the same whole.",
    recap:
        "Multiply or divide numerator and denominator together by the same nonzero factor.",
    questions: [
      "Which equals 1/2?|4/8|1/8;3/8;5/8|Four is half of eight.",
      "6/8 simplifies to what?|3/4|6/4;3/8;2/3|Divide both terms by two.",
      "3/5 with denominator twenty has numerator what?|12|3;15;8|The denominator is multiplied by four, so scale the numerator too.",
      "2/3 with denominator twelve is what?|8/12|2/12;6/12;10/12|Multiply both terms by four.",
      "Which operation preserves a fraction?|Multiply both terms by three|Add three to both;Multiply denominator only;Subtract numerator only|A common nonzero factor preserves the ratio.",
      "10/15 simplifies to what?|2/3|1/3;2/5;3/2|Divide both terms by five.",
      "Can equivalent fractions refer to different-sized wholes and guarantee equal physical pieces?|No|Yes, always;Only if denominators match;Only if numerators match|Equal fractions do not make unequal whole sizes equal.",
      "Which equals one whole?|9/9|1/9;8/9;9/1|All nine ninths make one whole.",
      "Find the numerator: ?/18 = 2/3.|12|6;9;2|Multiply both terms of two thirds by six.",
      "15/20 simplifies to what?|3/4|3/5;5/4;1/4|Divide numerator and denominator by five.",
      "Which pair is equivalent?|3/4 and 9/12|3/4 and 3/12;3/4 and 9/4;3/4 and 4/5|Scaling both terms by three preserves three fourths."
    ],
  ),
  CoreMathUnit(
    title: "Decimals",
    objectives: [
      "Read tenths and hundredths.",
      "Connect fractions to decimal notation.",
      "Compare decimals using place value."
    ],
    focus: "Decimals extend place value to parts smaller than one.",
    explanation:
        "The first digit after the decimal point counts tenths; the second counts hundredths. In 0.42, four tenths and two hundredths total forty-two hundredths. Ten hundredths make one tenth. Thus 0.4 = 0.40: a trailing zero records no extra hundredths. Compare matching places, not the number of digits. For example, 0.8 = 0.80 is greater than 0.75. Align decimal points when adding or subtracting.",
    model: {
      "0.42": "4 tenths + 2 hundredths = 42/100",
      "0.4 = 0.40": "A trailing zero preserves the amount.",
      "0.80 > 0.75": "Eight tenths exceeds seven tenths."
    },
    worked:
        "Add 0.27 and 0.5. Step 1: write 0.5 as 0.50. Step 2: align tenths and hundredths. Step 3: add 27 hundredths and 50 hundredths. Step 4: write 0.77.",
    guided: "Compare 0.63 and 0.7. Write 31/100 as a decimal.",
    solution: "0.7 = 0.70, so it exceeds 0.63. Thirty-one hundredths is 0.31.",
    mistakes:
        "More decimal digits do not always mean a larger number. A leading placeholder in 0.05 gives five hundredths, not five tenths.",
    recap:
        "Use decimal places as fractional units and align those units to compare or operate.",
    questions: [
      "The 4 in 0.42 represents what?|Four tenths|Four ones;Four hundredths;Forty ones|The first decimal place counts tenths.",
      "0.42 equals which fraction?|42/100|42/10;4/2;2/100|Two decimal places here describe hundredths.",
      "Which equals 0.4?|0.40|0.04;4.0;0.44|Trailing zero hundredths adds no quantity.",
      "Which is greater: 0.8 or 0.75?|0.8|0.75;They are equal;Neither is positive|Compare eighty hundredths with seventy-five.",
      "0.05 represents what?|Five hundredths|Five tenths;Five ones;Fifty tenths|The zero holds the tenths place.",
      "0.27 + 0.50 equals what?|0.77|0.32;0.275;0.72|Add matching hundredths.",
      "One tenth equals how many hundredths?|10|1;100;5|Ten hundredths regroup into one tenth.",
      "What should align in decimal addition?|Decimal points and matching places|Last written digits only;Largest digits only;Only whole-number digits|Aligned places represent the same unit size.",
      "Which is greater: 0.63 or 0.7?|0.7|0.63;They are equal;0.063|Seventy hundredths exceeds sixty-three.",
      "31/100 as a decimal is what?|0.31|3.1;0.031;31.0|Thirty-one hundredths occupies two decimal places.",
      "0.90 − 0.25 equals what?|0.65|0.75;1.15;0.85|Ninety hundredths minus twenty-five leaves sixty-five."
    ],
  ),
  CoreMathUnit(
    title: "Angles & Symmetry",
    objectives: [
      "Classify angle sizes.",
      "Recognize reflection symmetry.",
      "Distinguish turning from reflecting."
    ],
    focus:
        "Angles measure turns, and symmetry describes matching reflected parts.",
    explanation:
        "A right angle measures ninety degrees, like a square corner. An acute angle is smaller than ninety; an obtuse angle lies between ninety and one hundred eighty. A straight angle is one hundred eighty degrees. Lengthening the arms of an angle does not change its opening. A line of reflection symmetry divides a shape so folding along it matches the two parts. A square has four such lines; a non-square rectangle has two.",
    model: {
      "Acute 40°; right 90°; obtuse 120°": "Compare openings, not arm lengths.",
      "Square": "Two midlines and two diagonals are symmetry lines.",
      "Non-square rectangle":
          "Its midlines reflect matching halves; diagonals do not."
    },
    worked:
        "Classify a 125-degree angle. Step 1: compare with ninety. Step 2: it is larger. Step 3: compare with one hundred eighty; it is smaller. Step 4: name it obtuse.",
    guided:
        "Classify seventy degrees and state whether turning a square changes its four sides.",
    solution:
        "Seventy degrees is acute. Turning changes orientation but leaves the square sides and corner sizes unchanged.",
    mistakes:
        "An angle with long arms is not necessarily large. A line through a shape is a symmetry line only when reflected parts match.",
    recap:
        "Classify angles by degree measure and test symmetry through matching reflections.",
    questions: [
      "A right angle measures what?|90°|45°;180°;360°|A right angle is a quarter-turn.",
      "An angle of forty degrees is what?|Acute|Right;Obtuse;Straight|Forty is less than ninety.",
      "An angle of 120 degrees is what?|Obtuse|Acute;Right;Straight|It lies between ninety and one hundred eighty.",
      "A straight angle measures what?|180°|90°;360°;0°|A straight angle is half a full turn.",
      "How many reflection-symmetry lines does a square have?|4|2;3;1|Two midlines and two diagonals match its halves.",
      "How many does a non-square rectangle have?|2|4;3;0|Only its horizontal and vertical midlines reflect matching halves.",
      "Lengthening angle arms without changing their opening does what?|Keeps angle size unchanged|Doubles it;Makes it straight;Makes it zero|Angle size measures the opening rather than arm length.",
      "What tests a reflection-symmetry line?|The reflected halves match|It touches one corner;It is long;It is drawn in red|Reflection across the line must map the shape to itself.",
      "Seventy degrees is what type?|Acute|Obtuse;Right;Straight|Seventy is below ninety degrees.",
      "125 degrees is what type?|Obtuse|Acute;Right;Straight|It exceeds ninety but is below one hundred eighty.",
      "Turning a square changes which property?|Its orientation|Its number of sides;Its corner sizes;Its equal side lengths|Rotation preserves shape dimensions and angles."
    ],
  ),
];
