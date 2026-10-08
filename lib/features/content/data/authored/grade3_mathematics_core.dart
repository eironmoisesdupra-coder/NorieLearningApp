import 'core_math_unit.dart';

const grade3MathUnits = <CoreMathUnit>[
  CoreMathUnit(
    title: "Multiplication Facts",
    objectives: [
      "Connect arrays and products.",
      "Use a known fact to derive another.",
      "Interpret a multiplication word problem."
    ],
    focus:
        "Multiplication counts equal groups; related facts reduce memorization.",
    explanation:
        "An array of four rows with six dots in each has 4 × 6 = 24 dots. Turning the array shows 6 × 4 = 24, the same total. Split a group to use a known fact: 7 × 6 = (5 × 6) + (2 × 6) = 30 + 12 = 42. Multiplying by one keeps a quantity; multiplying by zero gives zero. A fact describes a total, so retain the item unit in a story problem.",
    model: {
      "4 rows × 6 dots": "24 dots in the array",
      "7 × 6": "5 × 6 + 2 × 6 = 42",
      "6 × 4 = 4 × 6": "Turning changes grouping, not the total."
    },
    worked:
        "Find 8 × 4. Step 1: know 4 × 4 = 16. Step 2: eight groups is twice four groups. Step 3: double sixteen to get thirty-two. Step 4: check 5 × 4 + 3 × 4 = 20 + 12 = 32.",
    guided: "Use 5 × 7 and 1 × 7 to find 6 × 7.",
    solution:
        "Thirty-five plus seven equals forty-two. Six groups split into five groups and one group.",
    mistakes:
        "Do not add the two factors instead of multiplying. Splitting seven groups into five and two means adding the two products.",
    recap:
        "Arrays, turning, splitting, and doubling connect multiplication facts.",
    questions: [
      "4 × 6 equals what?|24|10;20;28|Four equal sixes total twenty-four.",
      "7 × 6 equals what?|42|13;36;48|Five sixes plus two sixes gives thirty plus twelve.",
      "Which equals 6 × 4?|4 × 6|6 + 4;6 − 4;6 × 6|Turning the array preserves the total.",
      "9 × 1 equals what?|9|1;10;0|One group of nine keeps nine.",
      "5 × 0 equals what?|0|5;1;50|Five empty groups contribute no objects.",
      "Which split computes 7 × 8?|5 × 8 + 2 × 8|5 × 8 + 2;7 + 8;5 × 8 × 2 × 8|The seven groups split into five and two.",
      "An array has three rows of nine dots. Total is what?|27|12;18;36|Three nine-dot rows total twenty-seven.",
      "Twice the product 4 × 4 equals what?|32|16;24;8|Doubling sixteen gives thirty-two.",
      "6 × 7 equals what?|42|35;49;13|Five sevens plus one seven gives forty-two.",
      "Eight bags each hold five shells. Total shells are what?|40|13;35;45|Eight equal groups of five total forty.",
      "Use 10 × 6 to find 9 × 6.|54|60;66;56|Remove one six from sixty."
    ],
  ),
  CoreMathUnit(
    title: "Division Facts",
    objectives: [
      "Interpret equal sharing and grouping.",
      "Use multiplication to check a quotient.",
      "Distinguish remainder from quotient."
    ],
    focus: "Division asks how equal groups fit into a total.",
    explanation:
        "Sharing twenty-four beads equally among six children gives four each: 24 ÷ 6 = 4. Grouping twenty-four into sets of four gives six sets: 24 ÷ 4 = 6. The same total supports two questions. Multiplication checks division because divisor × quotient rebuilds the total when no remainder occurs. If seventeen objects form groups of five, there are three full groups and two left; 17 = 5 × 3 + 2.",
    model: {
      "24 ÷ 6 = 4": "Six equal shares of four rebuild twenty-four.",
      "24 ÷ 4 = 6": "Six groups of four fit.",
      "17 ÷ 5": "Three full groups, remainder two."
    },
    worked:
        "Share thirty-five stickers among five pupils. Step 1: identify total thirty-five. Step 2: identify five equal shares. Step 3: recall 5 × 7 = 35. Step 4: each receives seven; check five shares total thirty-five.",
    guided:
        "Arrange twenty-nine counters into groups of six. Find full groups and leftovers.",
    solution:
        "Four groups use twenty-four counters. Five remain; 29 = 6 × 4 + 5. The remainder is smaller than six.",
    mistakes:
        "Do not mix the number of groups with the size of each group. A remainder must be smaller than the divisor or another full group could be made.",
    recap:
        "Division shares or groups a total; multiplication verifies the quotient and remainder.",
    questions: [
      "24 ÷ 6 equals what?|4|6;18;30|Six fours rebuild twenty-four.",
      "24 ÷ 4 equals what?|6|4;20;28|Six groups of four fit in twenty-four.",
      "35 ÷ 5 equals what?|7|5;6;8|Five sevens total thirty-five.",
      "Which checks 42 ÷ 7 = 6?|7 × 6 = 42|42 × 7 = 6;7 + 6 = 42;42 − 6 = 7|Divisor times quotient rebuilds the dividend.",
      "17 objects in groups of five give what?|3 groups and 2 left|2 groups and 3 left;3 groups and 5 left;4 groups and 2 left|Fifteen objects fill three groups, leaving two.",
      "Why must a remainder be less than group size?|Otherwise another group fits|Remainders are always zero;The divisor changes;The total disappears|A full group cannot remain uncounted.",
      "0 ÷ 4 equals what?|0|4;1;Undefined|Four equal shares of nothing each contain zero.",
      "Can twelve objects be shared into zero groups by ordinary division?|No, division by zero is undefined|Yes, twelve each;Yes, zero each;Yes, one each|No quotient multiplied by zero rebuilds twelve.",
      "29 in groups of six gives what?|4 groups and 5 left|5 groups and 4 left;4 groups and 6 left;6 groups and 4 left|Twenty-four fill four groups; five remain.",
      "Forty-eight pencils shared among eight pupils give how many each?|6|8;7;5|Eight sixes total forty-eight.",
      "63 ÷ 9 equals what?|7|6;8;9|Nine sevens rebuild sixty-three."
    ],
  ),
  CoreMathUnit(
    title: "Fractions",
    objectives: [
      "Name equal parts of a whole.",
      "Interpret numerator and denominator.",
      "Identify equivalent simple fractions."
    ],
    focus: "A fraction describes equal-sized parts relative to a chosen whole.",
    explanation:
        "In 3/4, the denominator four says the whole has four equal parts; the numerator three says three are selected. Unequal slices do not represent fourths. The same amount can have more than one name: one half of a rectangle equals two fourths when each half is split equally. Fractions refer to a whole, so comparing portions requires the same whole size. Four fourths makes one whole.",
    model: {
      "3/4": "Select three of four equal parts.",
      "1/2 = 2/4": "Splitting each half into two preserves its size.",
      "4/4 = 1": "All equal parts form the whole."
    },
    worked:
        "Describe three shaded parts of six equal parts. Step 1: identify six equal parts in the whole. Step 2: count three shaded. Step 3: write 3/6. Step 4: observe half the parts are shaded, so 3/6 = 1/2.",
    guided:
        "Four of eight equal squares are colored. Name the fraction and another equivalent name.",
    solution: "The fraction is 4/8. Four is half of eight, so it equals 1/2.",
    mistakes:
        "The denominator counts all equal parts, not only shaded ones. More pieces do not automatically mean more of the whole.",
    recap:
        "Fractions count equal parts. Preserve the whole and recognize equivalent amounts.",
    questions: [
      "Three of four equal parts are shaded. Fraction is what?|3/4|4/3;1/4;3/3|Three selected parts out of four total parts gives three fourths.",
      "In 2/5, what does five tell?|Equal parts in the whole|Selected parts only;Number of wholes;The answer is five|The denominator describes the whole partition.",
      "Which equals one half?|2/4|1/4;3/4;2/3|Two of four equal parts is half.",
      "All seven equal parts are selected. Fraction equals what?|1|1/7;6/7;7 wholes|Seven sevenths completes one whole.",
      "Which drawing could model fourths?|Four equal regions|Four unequal regions;Three equal regions;Five unequal regions|Fourth-sized parts require an equal four-part partition.",
      "One of three equal parts is what?|1/3|3/1;1/2;2/3|One selected third is one third.",
      "Which is greater for the same whole: 1/4 or 3/4?|3/4|1/4;They are equal;Neither is a number|Three equal fourths exceed one fourth.",
      "Why name the whole when comparing portions?|Different whole sizes change physical amounts|Fractions never have wholes;Only colors matter;Denominators must always be ten|Half of a large whole can exceed half of a smaller whole.",
      "Four of eight equal parts is equivalent to what?|1/2|1/4;3/4;2/3|Four is half of eight.",
      "Two of six equal parts gives which fraction?|2/6|6/2;4/6;2/2|Count selected parts over total equal parts.",
      "Which fraction names one whole?|5/5|1/5;5/1;4/5|Five equal fifths fill the whole."
    ],
  ),
  CoreMathUnit(
    title: "Area & Perimeter",
    objectives: [
      "Count square units of area.",
      "Find the boundary length of a rectangle.",
      "Distinguish area units from perimeter units."
    ],
    focus: "Area measures a covered surface; perimeter measures its boundary.",
    explanation:
        "A rectangle five centimeters long and three centimeters wide covers five rows of three unit squares, or fifteen square centimeters. Its perimeter adds all four sides: 5 + 3 + 5 + 3 = 16 cm. Area uses square units because each unit covers a small surface. Perimeter uses ordinary length units. Rectangles can share a perimeter while having different areas; the quantities answer different questions.",
    model: {
      "5 cm × 3 cm": "Area = 15 cm²",
      "5 + 3 + 5 + 3": "Perimeter = 16 cm",
      "4 cm × 4 cm":
          "Area 16 cm², perimeter 16 cm: equal numbers, different units."
    },
    worked:
        "Use a six-by-two rectangle. Step 1: count six columns and two rows. Step 2: multiply 6 × 2 = 12 square units. Step 3: add boundary lengths 6 + 2 + 6 + 2. Step 4: report area twelve square units and perimeter sixteen units.",
    guided:
        "Find area and perimeter of a seven-centimeter by four-centimeter rectangle.",
    solution: "Area is 7 × 4 = 28 cm². Perimeter is 7 + 4 + 7 + 4 = 22 cm.",
    mistakes:
        "Do not multiply side lengths for perimeter. Two rectangles with the same perimeter need not cover the same area.",
    recap:
        "Multiply rows and columns for rectangular area; add every boundary side for perimeter.",
    questions: [
      "A 5 cm by 3 cm rectangle has area what?|15 cm²|16 cm²;8 cm²;30 cm²|Five times three unit squares gives fifteen.",
      "A 5 cm by 3 cm rectangle has perimeter what?|16 cm|15 cm;8 cm;30 cm|Add both copies of each side length.",
      "Which unit describes area?|Square centimeters|Centimeters only;Minutes;Grams|Area counts two-dimensional unit squares.",
      "A square of side four has area what?|16 square units|8 square units;4 square units;12 square units|Four rows of four give sixteen squares.",
      "A square of side four has perimeter what?|16 units|8 units;4 units;12 units|Add the four equal side lengths.",
      "Can rectangles with equal perimeters have different areas?|Yes|No, always identical;Only if units vanish;Only if neither is rectangular|For example six-by-two and four-by-four both have perimeter sixteen.",
      "A six-by-two rectangle covers how many unit squares?|12|16;8;24|Two rows of six cover twelve squares.",
      "What does perimeter measure?|Boundary length|Covered surface;Object mass;Elapsed time|Perimeter travels around the shape edges.",
      "A 7 cm by 4 cm rectangle has area what?|28 cm²|22 cm²;11 cm²;56 cm²|Seven times four gives twenty-eight square centimeters.",
      "A 7 cm by 4 cm rectangle has perimeter what?|22 cm|28 cm;11 cm;14 cm|Add seven, four, seven, and four.",
      "Two adjacent 1 cm squares cover area what?|2 cm²|1 cm²;6 cm²;2 cm|Each unit square contributes one square centimeter."
    ],
  ),
  CoreMathUnit(
    title: "Data & Graphs",
    objectives: [
      "Read a frequency table.",
      "Compare counts using differences.",
      "Use a bar scale instead of visual guessing."
    ],
    focus:
        "Tables and bars summarize counted observations with labeled categories.",
    explanation:
        "A class survey records red: four pupils, blue: six, and green: three. The total is 4 + 6 + 3 = 13. Blue has the largest count, and it exceeds red by two. A bar chart must label the categories and count scale. If one scale interval represents two pupils, a bar at three intervals represents six pupils. Read the scale before comparing heights, and do not confuse a count with a category name.",
    model: {
      "Red: 4; blue: 6; green: 3":
          "Thirteen responses, if each pupil chooses once.",
      "Blue − red": "6 − 4 = 2 more pupils.",
      "Scale: two pupils per interval": "Three intervals mean six pupils."
    },
    worked:
        "Read cats: five, dogs: eight, birds: two. Step 1: identify counts and categories. Step 2: add 5 + 8 + 2 = 15. Step 3: largest category is dogs. Step 4: dogs exceed cats by 8 − 5 = 3.",
    guided:
        "For apples: seven and oranges: four, find the total and difference. State what one bar-scale interval of two means.",
    solution:
        "There are eleven choices total and three more apples than oranges. Each scale interval represents two observations.",
    mistakes:
        "The tallest drawn bar cannot be interpreted without its scale. A survey total equals pupil count only if each pupil contributes exactly one response.",
    recap:
        "Use labeled counts, sum for totals, subtract for differences, and read the scale.",
    questions: [
      "Table red 4, blue 6, green 3. Total responses?|13|10;12;14|Add the three category counts.",
      "Table red 4, blue 6, green 3. Largest category?|Blue|Red;Green;All equal|Six exceeds four and three.",
      "Blue has six and red four. Difference is what?|2|10;4;6|Subtract four from six.",
      "A bar has three intervals at two pupils per interval. Count?|6|3;5;2|Multiply intervals by their scale value.",
      "Cats 5, dogs 8, birds 2. Total is what?|15|13;10;8|Add five, eight, and two.",
      "Cats 5 and dogs 8. How many more dogs?|3|13;5;8|Difference means eight minus five.",
      "What must a bar chart count axis show?|Its scale|Only decoration;Only survey title;Only category color|The scale links height to a number of observations.",
      "When does response total equal pupil total?|Each pupil chooses exactly once|Each pupil chooses any number;No labels exist;Bars are colorful|One response per pupil creates a one-to-one count.",
      "Apples 7 and oranges 4. Total choices?|11|3;12;7|Add both counts.",
      "Apples 7 and oranges 4. How many more apples?|3|11;4;7|Subtract the smaller count from the larger.",
      "Five bar intervals each mean two votes. Votes are what?|10|5;7;2|Five equal intervals times two gives ten."
    ],
  ),
];
