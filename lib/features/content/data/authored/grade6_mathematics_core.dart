import 'core_math_unit.dart';

const grade6MathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "Ratios & Rates",
    objectives: [
      "Interpret ordered ratios.",
      "Find equivalent ratios.",
      "Calculate a unit rate."
    ],
    focus:
        "Ratios compare quantities; unit rates express an amount per one unit.",
    explanation:
        "A mixture with two red beads for three blue beads has red-to-blue ratio 2:3. Doubling both counts gives 4:6, the same relationship. The red fraction of all beads is 2/5, not 2/3, because the whole includes both colors. A rate can compare different units: 150 kilometers in three hours is fifty kilometers per hour. Divide distance by time to find the amount per one hour.",
    model: {
      "Red:blue = 2:3": "Total parts five; red share 2/5.",
      "4:6 = 2:3": "Both quantities scale by two.",
      "150 km in 3 h": "150 ÷ 3 = 50 km/h"
    },
    worked:
        "Scale a recipe using four cups of water for two cups of concentrate. Step 1: divide both by two to get 2:1. Step 2: three cups of concentrate needs six cups of water. Step 3: check 6:3 simplifies to 2:1. Step 4: keep water-to-concentrate order.",
    guided:
        "Find the rate for 180 kilometers in four hours. If red:blue is 3:2, what fraction of all beads is red?",
    solution:
        "The rate is forty-five kilometers per hour. Red occupies three of five total parts, or 3/5.",
    mistakes:
        "Do not reverse ratio order or scale just one term. A part-to-part ratio differs from a part-to-whole fraction.",
    recap:
        "Keep comparison order and units explicit; equivalent ratios scale both quantities together.",
    questions: [
      "Red:blue is 2:3. Equivalent ratio is what?|4:6|4:3;2:6;3:2|Doubling both terms preserves the relationship.",
      "Red:blue is 2:3. Red fraction of all beads?|2/5|2/3;3/5;3/2|There are five total ratio parts.",
      "150 km in three hours gives rate what?|50 km/h|450 km/h;147 km/h;3 km/h|Divide distance by three hours.",
      "Water:concentrate is 4:2. Simplest ratio?|2:1|4:1;1:2;2:2|Divide both quantities by two.",
      "At water:concentrate 2:1, three cups concentrate needs water what?|6 cups|3 cups;5 cups;1.5 cups|Water amount is twice concentrate.",
      "Which preserves a ratio?|Multiply both terms by five|Add five to just one;Multiply one term only;Reverse terms always|Equal scaling preserves the comparison.",
      "Twenty items in four boxes gives how many per box?|5|16;80;4|Divide total items by equal box count.",
      "Ratio blue:red = 3:2 means what?|Three blue per two red|Three red per two blue;Five blue per one red;Both quantities equal|The order matches named quantities.",
      "180 km in four hours gives rate what?|45 km/h|720 km/h;176 km/h;40 km/h|One-hour rate is 180 divided by four.",
      "Red:blue = 3:2. Red share of total?|3/5|3/2;2/5;2/3|Three of five combined parts are red.",
      "At five liters per minute, four minutes supplies what?|20 liters|9 liters;1.25 liters;25 liters|Multiply rate by elapsed minutes."
    ],
  ),
  CoreMathUnit(
    title: "Percent",
    objectives: [
      "Convert percent to a fraction or decimal.",
      "Find a percent of an amount.",
      "Separate a change amount from a final amount."
    ],
    focus:
        "Percent means parts per hundred and provides a shared comparison scale.",
    explanation:
        "Twenty percent is 20/100 = 0.20 = 1/5. To find twenty percent of eighty, multiply 0.20 × 80 = 16. A twenty-five-percent reduction on eighty removes twenty, leaving sixty; the percentage amount and final amount differ. For ten percent, divide by ten. For fifty percent, take half. Always identify the base amount: twenty percent of fifty differs from twenty percent of one hundred.",
    model: {
      "20%": "20/100 = 0.2",
      "25% of 80": "One quarter of eighty is twenty.",
      "80 reduced by 25%": "80 − 20 = 60"
    },
    worked:
        "Increase a quantity of fifty by ten percent. Step 1: convert ten percent to 0.1. Step 2: calculate 0.1 × 50 = 5. Step 3: add five to fifty. Step 4: final amount is fifty-five, not five.",
    guided:
        "Find thirty percent of sixty. Then find the final amount after reducing sixty by thirty percent.",
    solution: "0.3 × 60 = 18. The reduced amount is 60 − 18 = 42.",
    mistakes:
        "Do not use twenty instead of 0.20 when multiplying for twenty percent. A percent increase is calculated from the specified starting base.",
    recap:
        "Convert percent to parts per hundred, calculate the change, then apply that change to the base.",
    questions: [
      "20% as a decimal is what?|0.2|20;2;0.02|Twenty hundredths equals two tenths.",
      "25% of eighty is what?|20|25;60;2000|A quarter of eighty is twenty.",
      "Eighty reduced by 25% leaves what?|60|20;55;100|Subtract the twenty-unit reduction from eighty.",
      "50% of thirty is what?|15|50;60;5|Fifty percent means one half.",
      "10% of fifty is what?|5|10;40;500|One tenth of fifty equals five.",
      "Fifty increased by 10% becomes what?|55|5;60;45|Add the five-unit increase to fifty.",
      "Which fraction equals 75%?|3/4|1/4;3/5;75/10|Seventy-five hundredths simplifies to three fourths.",
      "Why identify the percent base?|The same percent of different bases gives different amounts|The base never matters;Every base is one hundred;Percent has no quantities|Percent scales the stated whole amount.",
      "30% of sixty is what?|18|30;42;180|Three tenths of sixty equals eighteen.",
      "Sixty reduced by 30% becomes what?|42|18;90;30|Subtract eighteen from sixty.",
      "Twelve is what percent of forty?|30%|12%;40%;3%|Twelve divided by forty is 0.3."
    ],
  ),
  CoreMathUnit(
    title: "Integers",
    objectives: [
      "Order positive and negative integers.",
      "Add and subtract using direction.",
      "Distinguish value from distance to zero."
    ],
    focus: "Integers extend counting numbers to positions below zero.",
    explanation:
        "On an increasing number line, negative numbers lie left of zero. Negative two is greater than negative five because it lies farther right. Adding a positive number moves right; adding a negative moves left. Subtracting a number adds its opposite: −3 − (−5) = −3 + 5 = 2. Absolute value measures distance to zero, so |−7| = 7 even though −7 is smaller than −2.",
    model: {
      "−5 < −2 < 0 < 3": "Positions increase left to right.",
      "−3 + 5 = 2": "Move five units right.",
      "−3 − (−5) = 2": "Subtracting negative five adds positive five."
    },
    worked:
        "Find −4 + 7. Step 1: start at negative four. Step 2: move four right to zero. Step 3: move the remaining three right. Step 4: result is positive three.",
    guided:
        "Find 2 − 6 and −2 − (−4). State the absolute value of negative eight.",
    solution:
        "2 − 6 = −4. Subtracting negative four adds four, so −2 − (−4) = 2. The absolute value is eight.",
    mistakes:
        "The larger absolute value is not always the larger integer. Keep the subtraction sign distinct from a negative-number sign.",
    recap:
        "Order by position and subtract by adding the opposite; absolute value is nonnegative distance.",
    questions: [
      "Which is greater: −2 or −5?|−2|−5;They are equal;Neither is an integer|Negative two lies farther right.",
      "−4 + 7 equals what?|3|−11;11;−3|Move seven right from negative four.",
      "2 − 6 equals what?|−4|4;8;−8|Moving six left from two lands at negative four.",
      "−3 − (−5) equals what?|2|−8;8;−2|Add the opposite of negative five.",
      "Absolute value of −7 is what?|7|−7;0;14|Distance to zero is seven units.",
      "Which lies between −3 and 1?|0|−4;2;3|Zero is greater than negative three and less than one.",
      "Add −2 and −6.|−8|8;4;−4|Two moves left combine to eight units left.",
      "What is the opposite of −9?|9|−9;0;1/9|Opposites are equally distant on opposite sides of zero.",
      "−2 − (−4) equals what?|2|−6;6;−2|Add positive four to negative two.",
      "Which ordered list increases?|−5, −1, 0, 4|4, 0, −1, −5;−1, −5, 0, 4;0, −1, −5, 4|The numbers move from left to right.",
      "Temperature moves from −3 to 5. Increase is what?|8 degrees|2 degrees;−8 degrees;5 degrees|Subtract the initial negative value: five plus three."
    ],
  ),
  CoreMathUnit(
    title: "Expressions & Variables",
    objectives: [
      "Interpret a variable in an expression.",
      "Substitute a given value.",
      "Combine like terms and distribute."
    ],
    focus:
        "Variables let one expression describe many possible numerical cases.",
    explanation:
        "In 3x + 2, x stands for a number and 3x means three times that number. If x = 4, the value is 3 × 4 + 2 = 14. Terms such as 3x and 5x are alike and combine to 8x; 3x and 5 are unlike and stay separate. Distribution rewrites 2(x + 3) as 2x + 6 because both addends are doubled. An equation sets expressions equal, while an expression alone does not solve for x.",
    model: {
      "x = 4 in 3x + 2": "3 × 4 + 2 = 14",
      "3x + 5x": "Eight copies of x = 8x",
      "2(x + 3)": "2x + 6"
    },
    worked:
        "Evaluate 2x + 5 at x = 6. Step 1: replace x with six. Step 2: multiply 2 × 6 = 12. Step 3: add five to get seventeen. Step 4: check that substitution used the same x value everywhere.",
    guided: "Expand 3(x + 4), then evaluate it when x = 2.",
    solution:
        "The expansion is 3x + 12. At x = 2 it gives six plus twelve, or eighteen.",
    mistakes:
        "Do not interpret 3x as thirty-x or 3 + x. Distribution must reach every grouped term. Unlike terms cannot be merged into one coefficient.",
    recap:
        "Substitute consistently, combine matching variable terms, and distribute to all addends.",
    questions: [
      "At x = 4, 3x + 2 equals what?|14|9;12;18|Three times four plus two equals fourteen.",
      "3x + 5x simplifies to what?|8x|15x;8x²;3x + 5|Add coefficients of like terms.",
      "2(x + 3) expands to what?|2x + 6|2x + 3;x + 6;5x|Multiply both grouped terms by two.",
      "At x = 6, 2x + 5 equals what?|17|13;11;22|Substitute six, multiply, then add.",
      "What does 3x mean?|Three times x|Three plus x;Thirty plus x;x divided by three|Juxtaposition here denotes multiplication.",
      "Which terms are like terms?|4y and 7y|4y and 7;4y and 7x;4y and y²|They share the same variable and exponent.",
      "Is x + 2 alone an equation?|No|Yes, every variable is an equation;Only if x is positive;Only if two is positive|An equation needs an equality relation.",
      "5x − 2x simplifies to what?|3x|7x;10x;3|Subtract coefficients of matching terms.",
      "3(x + 4) expands to what?|3x + 12|3x + 4;x + 12;7x|Multiply x and four by three.",
      "At x = 2, 3x + 12 equals what?|18|17;14;30|Six plus twelve gives eighteen.",
      "At n = 5, n + n + 1 equals what?|11|6;10;15|Both occurrences of n use the given value five."
    ],
  ),
  CoreMathUnit(
    title: "Statistics",
    objectives: [
      "Find mean, median, mode, and range.",
      "Order data before finding the median.",
      "Interpret an average without inventing observations."
    ],
    focus: "Different summaries describe center or spread in different ways.",
    explanation:
        "For data 2, 4, 4, 6, 9, the sum is twenty-five and there are five values, so mean = 5. In sorted order the middle value is four, the median. Four occurs most often, so it is the mode. Range = largest − smallest = 9 − 2 = 7. The mean need not be a value observed. A very large observation can pull the mean upward more strongly than the median.",
    model: {
      "2, 4, 4, 6, 9": "Mean 5; median 4; mode 4; range 7.",
      "3, 5, 7": "Mean and median both 5.",
      "1, 1, 2, 2": "Both one and two are modes."
    },
    worked:
        "Analyze 1, 3, 3, 5. Step 1: sort the values. Step 2: mean = 12 ÷ 4 = 3. Step 3: median averages the middle pair, (3 + 3)/2 = 3. Step 4: mode is three and range is four.",
    guided: "Find mean and median of 2, 3, 10. Explain why they differ.",
    solution:
        "The mean is fifteen divided by three, or five. The median is three. The high value ten pulls the mean above the middle observation.",
    mistakes:
        "Do not divide by the number of distinct values for the mean. Count every observation. Sort before finding a median and average both middle values for even counts.",
    recap:
        "Choose the summary that fits the question and report center and spread separately.",
    questions: [
      "Mean of 2, 4, 4, 6, 9?|5|4;6;7|The sum twenty-five divided by five observations is five.",
      "Median of 2, 4, 4, 6, 9?|4|5;6;9|The third of five ordered observations is four.",
      "Mode of 2, 4, 4, 6, 9?|4|2;6;9|Four occurs more often than any other value.",
      "Range of 2, 4, 4, 6, 9?|7|5;9;2|Subtract minimum two from maximum nine.",
      "Before finding a median, what is needed?|Put values in order|Delete repeats;Add one to each;Choose the largest|Middle position is defined in ordered data.",
      "Can a mean be absent from the observed values?|Yes|No;Only if data are negative;Only with one observation|An average need not equal a recorded value.",
      "Mean of 3, 5, 7?|5|3;7;15|Fifteen divided by three is five.",
      "Modes of 1, 1, 2, 2?|1 and 2|1 only;2 only;3|Both values share the greatest frequency.",
      "Mean of 2, 3, 10?|5|3;10;15|The sum fifteen divided by three gives five.",
      "Median of 2, 3, 10?|3|5;2;10|Three is the middle ordered value.",
      "Median of 1, 3, 5, 7?|4|3;5;7|Average the two middle values three and five."
    ],
  ),
];
