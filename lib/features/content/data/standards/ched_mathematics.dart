import 'standards_lesson.dart';

const chedMathematicsLessons = <StandardsLesson>[
  StandardsLesson(
    title: 'Patterns and Mathematics in Our World',
    objectives: [
      'Describe a numerical pattern using a rule.',
      'Distinguish a conjecture from a justified conclusion.',
      'Use a mathematical model while stating its limits.',
    ],
    explanation:
        'Mathematics describes relationships in objects, quantities, and change. '
        'A pattern may suggest a rule, but a few examples do not prove that the rule always holds. '
        'For the sequence 4, 7, 10, 13, a constant increase of 3 suggests the arithmetic rule '
        'a(n) = 4 + 3(n - 1). The rule predicts a fifth term of 16. A different rule could agree '
        'with the first four terms and disagree later, so state the assumed model. '
        'A jeepney fare model might use a base amount and an additional amount per kilometer. '
        'Its predictions apply only to the route, distance rules, and fare schedule assumed. '
        'Models help us reason; they are not exact copies of reality.',
    model: {
      'Observed terms: 4, 7, 10, 13': 'Successive differences are 3, 3, and 3.',
      'Assumption: the difference stays 3':
          'The model is a(n) = 3n + 1 for positive whole-number n.',
      'Prediction: a(5) = 16':
          'This follows from the model, not from four observations alone.',
    },
    worked:
        'A row of tiles has 5 tiles in design 1, 8 in design 2, and 11 in design 3. '
        '1. Compare counts: each new design adds 3. 2. State the constant-growth assumption. '
        '3. Write T(n) = 5 + 3(n - 1). 4. For design 6, T(6) = 5 + 15 = 20 tiles.',
    guided:
        'A savings plan begins with PHP 20 and adds PHP 10 each week. Counting the first deposit as week 1, what is the amount at week 5?',
    solution:
        'Under the stated plan, S(n) = 20 + 10(n - 1). Thus S(5) = 60 pesos. This is the accumulated balance only if each week adds PHP 10 and no money is withdrawn.',
    mistake:
        'Do not confuse the term number with the term value, or call a pattern a proof. A leaf arrangement can inspire mathematics without every plant following an exact sequence.',
    recap:
        'Observe, propose a rule, state assumptions, and check predictions against the situation.',
    questions: [
      [
        'Under constant addition, what follows 4, 7, 10, 13?',
        '16',
        '14',
        '15',
        '17',
        'Add the common difference 3 to 13.'
      ],
      [
        'What is the common difference of 5, 8, 11?',
        '3',
        '2',
        '5',
        '6',
        'Both 8 - 5 and 11 - 8 equal 3.'
      ],
      [
        'For a(n) = 3n + 1, what is a(4)?',
        '13',
        '12',
        '16',
        '4',
        'Substitute n = 4 to get 12 + 1.'
      ],
      [
        'Which statement is a model assumption?',
        'The increase remains 3 each step',
        'The first observed term is 4',
        'The third observed term is 10',
        'Four terms were recorded',
        'The continuation rule goes beyond the observed data.'
      ],
      [
        'For T(n) = 5 + 3(n - 1), how many tiles are in design 6?',
        '20',
        '18',
        '23',
        '15',
        'There are five increases of 3 after the initial 5.'
      ],
      [
        'Do four matching examples prove a rule for every positive integer?',
        'No',
        'Yes, always',
        'Only if written in a table',
        'Only if drawn in color',
        'Finite observations alone do not prove an unrestricted claim.'
      ],
      [
        'A model ignores withdrawals. Which situation violates that assumption?',
        'Money is taken from the savings account',
        'The planned amount is deposited',
        'Weeks are counted in order',
        'The first deposit is recorded',
        'A withdrawal changes the balance beyond the model.'
      ],
      [
        'For S(n) = 20 + 10(n - 1), what is S(5)?',
        'PHP 60',
        'PHP 50',
        'PHP 70',
        'PHP 100',
        'Start with 20, then add four amounts of 10.'
      ],
      [
        'Under constant multiplication, what follows 3, 6, 12, 24?',
        '48',
        '27',
        '36',
        '30',
        'Each term doubles.'
      ],
      [
        'A fare model uses an outdated fare schedule. What should be done?',
        'Update the assumptions before using its predictions',
        'Treat its answer as legally exact',
        'Ignore the date of the schedule',
        'Change only the passenger name',
        'A useful model must match the applicable conditions.'
      ],
      [
        'Which best separates evidence from inference?',
        'Recorded terms are evidence; the continuation rule is an inference',
        'A guessed rule is always an observation',
        'Any diagram is a proof',
        'A prediction cannot be checked',
        'The observed values and the proposed rule have different roles.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Mathematical Language, Sets, and Logic',
    objectives: [
      'Translate everyday claims into precise mathematical statements.',
      'Use union, intersection, and complements in a stated universe.',
      'Test conditional claims using counterexamples.',
    ],
    explanation:
        'Mathematical language makes assumptions and relationships explicit. Let U be all 30 learners in a class. '
        'Let A be learners who use a bus, and B learners who walk part of the trip. '
        'A union B includes learners in either group or both; A intersection B includes learners in both. '
        'The complement of A contains class members not in A, relative to U. '
        'A statement has a truth value; a question or command does not. '
        'The conditional "If a whole number is divisible by 4, then it is even" is true. '
        'Its converse is false: 6 is even but not divisible by 4. '
        'One counterexample disproves a universal claim. Definitions and quantifiers such as "all" and "some" matter.',
    model: {
      'Bus only: 12; both: 6; walk only: 4; neither: 8':
          'The four disjoint regions total 30 learners.',
      'Bus or walk: 12 + 6 + 4 = 22': 'Count the overlap only once.',
      'If divisible by 4, then even': 'The converse fails for 6.',
    },
    worked: 'In a class of 30, |A| = 18, |B| = 10, and |A intersection B| = 6. '
        '1. Add 18 + 10. 2. Subtract the overlap 6. 3. The union has 22 learners. '
        '4. The number in neither is 30 - 22 = 8.',
    guided:
        'In a universe of 20 people, 9 like tea, 8 like coffee, and 3 like both. How many like at least one? How many like neither?',
    solution:
        'The union is 9 + 8 - 3 = 14. The complement of that union has 20 - 14 = 6 people.',
    mistake:
        'In mathematics, "or" normally includes both. Do not reverse a conditional without checking it, or use a complement without specifying the universe.',
    recap:
        'Define the universe, distinguish and/or, and test general claims with precise reasoning.',
    questions: [
      [
        'Which is a statement with a truth value?',
        '8 is even',
        'Close the door',
        'What is your name?',
        'Please count',
        'The assertion about 8 can be judged true or false.'
      ],
      [
        'If |A| = 18, |B| = 10, and the overlap is 6, what is the union size?',
        '22',
        '28',
        '34',
        '12',
        'Subtract the overlap once from 18 + 10.'
      ],
      [
        'In a universe of 30, a union contains 22 people. How many are outside it?',
        '8',
        '22',
        '52',
        '16',
        'The complement has 30 - 22 people.'
      ],
      [
        'What does A intersection B contain?',
        'Members belonging to both sets',
        'Only members outside both sets',
        'Every member of the universe',
        'Only members in A but not B',
        'Intersection means simultaneous membership.'
      ],
      [
        'Which disproves the converse of "divisible by 4 implies even"?',
        '6',
        '8',
        '12',
        '16',
        '6 is even but not divisible by 4.'
      ],
      [
        'What is needed to interpret the complement of a set?',
        'A specified universal set',
        'A bar graph only',
        'A positive mean',
        'A large sample',
        'Complement is relative to the universe being considered.'
      ],
      [
        'Tea: 9, coffee: 8, both: 3. How many like at least one?',
        '14',
        '17',
        '20',
        '6',
        '9 + 8 - 3 = 14.'
      ],
      [
        'In a universe of 20 with 14 in a union, how many are in neither set?',
        '6',
        '14',
        '34',
        '3',
        'Subtract the union size from the universe size.'
      ],
      [
        'What disproves "Every prime number is odd"?',
        '2 is prime and even',
        '3 is prime and odd',
        '9 is odd and composite',
        '10 is composite and even',
        'A single prime that is not odd defeats the universal claim.'
      ],
      [
        'Which is the negation of "All learners attended"?',
        'At least one learner did not attend',
        'No learner attended',
        'All teachers attended',
        'Most learners attended',
        'Not all means at least one exception, not necessarily none.'
      ],
      [
        'A learner belongs to both A and B. How often is the learner counted in the union?',
        'Once',
        'Twice',
        'Never',
        'Four times',
        'A set contains each member once.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Problem Solving and Mathematical Models',
    objectives: [
      'Represent a practical problem with variables and equations.',
      'Solve a linear model and check units and constraints.',
      'Compare alternatives rather than accepting an unchecked answer.',
    ],
    explanation:
        'A mathematical solution starts with understanding the question, selecting a representation, carrying out a plan, '
        'and checking the result in context. Suppose printing shop A charges PHP 40 setup plus PHP 2 per page. '
        'Shop B charges PHP 10 setup plus PHP 3 per page. Let n be a nonnegative whole-number page count. '
        'Costs are A(n) = 40 + 2n and B(n) = 10 + 3n. Equal cost occurs when 40 + 2n = 10 + 3n, or n = 30. '
        'Below 30 pages, B is cheaper; above 30, A is cheaper. '
        'The model excludes discounts, taxes, and paper differences unless explicitly included. '
        'An algebraic value is not a finished answer until its unit and feasibility have been checked.',
    model: {
      '10 pages': 'A = PHP 60; B = PHP 40.',
      '30 pages': 'A = B = PHP 100.',
      '50 pages': 'A = PHP 140; B = PHP 160.',
    },
    worked:
        'Compare shops for 45 pages. 1. Set n = 45. 2. A costs 40 + 2(45) = 130. '
        '3. B costs 10 + 3(45) = 145. 4. A saves PHP 15, assuming equivalent service.',
    guided:
        'A school trip costs PHP 900 fixed plus PHP 60 per learner. What is the cost for 15 learners? If the budget is PHP 2,100, how many learners can the model fund?',
    solution:
        'C(15) = 900 + 60(15) = PHP 1,800. For the budget, 900 + 60n <= 2,100 gives n <= 20. The largest feasible whole-number count is 20.',
    mistake:
        'Do not add a per-page price only once, accept a negative passenger count, or round a maximum affordable count upward beyond the budget.',
    recap:
        'Define variables and units, solve, compare, and verify the result against real constraints.',
    questions: [
      [
        'What does n represent in A(n) = 40 + 2n?',
        'Number of pages',
        'Cost per page',
        'Setup fee',
        'Number of printers',
        'The variable counts pages.'
      ],
      [
        'What is A(10) for A(n) = 40 + 2n?',
        'PHP 60',
        'PHP 42',
        'PHP 400',
        'PHP 20',
        '40 + 2(10) = 60.'
      ],
      [
        'At how many pages do 40 + 2n and 10 + 3n cost the same?',
        '30',
        '10',
        '40',
        '50',
        'Subtracting 2n and 10 gives n = 30.'
      ],
      [
        'Which shop is cheaper for 50 pages?',
        'A: 40 + 2n',
        'B: 10 + 3n',
        'They cost the same',
        'Neither can be calculated',
        'A costs 140 and B costs 160.'
      ],
      [
        'What is the trip cost 900 + 60n for 15 learners?',
        'PHP 1,800',
        'PHP 960',
        'PHP 13,500',
        'PHP 1,500',
        'The variable part is 900, added to the fixed 900.'
      ],
      [
        'Under a PHP 2,100 budget, what is the largest n with 900 + 60n <= 2,100?',
        '20',
        '21',
        '35',
        '15',
        'After the fixed fee, 1,200 remains; 1,200/60 = 20.'
      ],
      [
        'Why is n = -2 inadmissible for a page count?',
        'A count of printed pages cannot be negative',
        'Negative numbers never exist',
        'Every equation has only positive roots',
        'A setup fee is zero',
        'The practical domain restricts the mathematical variable.'
      ],
      [
        'For 45 pages, how much cheaper is A than B?',
        'PHP 15',
        'PHP 30',
        'PHP 45',
        'PHP 130',
        '145 - 130 = 15.'
      ],
      [
        'An algebraic model gives 20.6 as the maximum affordable people. What count is feasible?',
        '20',
        '21',
        '20.6 people',
        '206',
        'A maximum whole-person count must be rounded down.'
      ],
      [
        'Which extra information could change the shop comparison?',
        'A bulk discount on orders above 40 pages',
        'The variable is named n',
        'The equation is written on paper',
        'Addition is commutative',
        'A bulk discount changes the cost rule.'
      ],
      [
        'What is the final check after solving a word problem?',
        'Check units, constraints, and the original question',
        'Erase all assumptions',
        'Assume every root is feasible',
        'Choose the largest numeral',
        'A solution must answer the actual situation, not only the equation.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Data, Statistics, and Responsible Interpretation',
    objectives: [
      'Compute and compare mean, median, and range.',
      'Distinguish a population, sample, and biased sampling method.',
      'Interpret association without claiming unsupported causation.',
    ],
    explanation:
        'Data management involves asking a question, collecting suitable data, summarizing it, and interpreting limitations. '
        'A population is the whole group of interest; a sample is the subset observed. '
        'A survey of volunteers from one club may not represent every student. '
        'For daily travel times 10, 15, 15, 20, and 90 minutes, the mean is 150/5 = 30 minutes. '
        'The median is 15, and the range is 90 - 10 = 80. The long journey raises the mean; '
        'the median describes a typical middle observation more robustly here. '
        'A graph must state units and use a fair scale. Two variables changing together does not prove that one causes the other; '
        'a third factor or reverse direction may explain an association.',
    model: {
      'Sorted times: 10, 15, 15, 20, 90 minutes': 'Sum 150; five observations.',
      'Mean 30; median 15': 'The unusually long journey pulls the mean upward.',
      'Club volunteers versus all students':
          'The sampling frame can exclude important groups.',
    },
    worked:
        'Summarize scores 4, 6, 6, 8. 1. Sort the values. 2. Mean = 24/4 = 6. '
        '3. Median = (6 + 6)/2 = 6. 4. Range = 8 - 4 = 4; include the score scale before interpreting.',
    guided:
        'Find the mean and median of 2, 3, 3, 4, 18. Which is more resistant to the extreme value?',
    solution:
        'The sum is 30, so the mean is 6. The middle sorted value is 3. The median is more resistant to the unusually high 18.',
    mistake:
        'Do not average percentages from unequal group sizes without weighting, or describe a correlation from a survey as proof of causation.',
    recap:
        'Use suitable summaries, explain the sample, label graphs, and separate association from causal evidence.',
    questions: [
      [
        'What is the mean of 10, 15, 15, 20, 90?',
        '30',
        '15',
        '20',
        '90',
        'Their sum is 150 and there are five observations.'
      ],
      [
        'What is the median of 10, 15, 15, 20, 90?',
        '15',
        '30',
        '10',
        '80',
        'The third sorted observation is 15.'
      ],
      [
        'What is the range of 10, 15, 15, 20, 90?',
        '80',
        '90',
        '30',
        '15',
        'Range is maximum minus minimum: 90 - 10.'
      ],
      [
        'Which is the population in a study of all students at a university?',
        'All students at that university',
        'Only the surveyed class',
        'Only volunteers',
        'Only graduates',
        'The population is the entire stated group of interest.'
      ],
      [
        'What is a risk of surveying only one sports club about all students?',
        'Selection bias',
        'Guaranteed representativeness',
        'A census of all students',
        'No possible measurement error',
        'Club members may differ from other students.'
      ],
      [
        'What is the mean of 4, 6, 6, 8?',
        '6',
        '4',
        '8',
        '24',
        'The sum is 24 divided by 4.'
      ],
      [
        'What is the median of 2, 3, 3, 4, 18?',
        '3',
        '6',
        '18',
        '4',
        'The middle of the five sorted values is 3.'
      ],
      [
        'A study finds umbrella use associated with wet roads. What can be concluded from association alone?',
        'The two occur together; causation is not established',
        'Umbrellas cause rain',
        'Wet roads manufacture umbrellas',
        'No further study can help',
        'Rain can be a common cause of both observations.'
      ],
      [
        'Which feature is essential on a travel-time graph?',
        'A clearly labeled time unit',
        'An unexplained truncated scale',
        'Only decorative colors',
        'A missing title and axis labels',
        'Readers must know what quantity is measured.'
      ],
      [
        'Why can the median better describe typical travel time when one trip is extremely long?',
        'It is less affected by an extreme value',
        'It always equals the largest value',
        'It ignores the order of the data',
        'It proves every journey is short',
        'The median depends on the middle position rather than the sum.'
      ],
      [
        'Ten of 20 students pass in A and 90 of 100 pass in B. What is the combined pass rate?',
        '100/120, about 83.3%',
        '70%',
        '140%',
        '50%',
        'Combine pass counts and total counts; do not take the unweighted average of rates.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Financial Mathematics and Informed Choices',
    objectives: [
      'Compute simple and compound interest with matched time units.',
      'Compare percentage changes and real purchasing power.',
      'Identify assumptions and costs omitted from a financial model.',
    ],
    explanation:
        'Financial mathematics supports decisions, not guaranteed profit predictions. Simple interest is I = Prt, '
        'where P is principal, r the rate per time period, and t the number of those periods. '
        'At 5% per year for 2 years, PHP 10,000 earns PHP 1,000 simple interest. '
        'With annual compounding the balance is P(1 + r)^t = 10,000(1.05)^2 = PHP 11,025. '
        'Compounding earns interest on earlier interest. Fees, taxes, inflation, and risk can change the outcome. '
        'A 20% discount followed by a 20% increase does not return the original price: 100 becomes 80, then 96. '
        'Compare alternatives using the same period and disclose the complete cash flows.',
    model: {
      'Simple, year 2': '10,000 + 10,000(0.05)(2) = PHP 11,000.',
      'Compounded annually, year 2':
          '10,000(1.05)^2 = PHP 11,025 before fees and taxes.',
      'Price 100, down 20%, then up 20%': '100 x 0.8 x 1.2 = 96.',
    },
    worked: 'A PHP 4,000 loan has simple interest of 6% per year for 6 months. '
        '1. Convert 6 months to 0.5 year. 2. Use r = 0.06. '
        '3. I = 4,000(0.06)(0.5) = 120. 4. Principal plus interest is PHP 4,120, excluding any fee.',
    guided:
        'Find the balance on PHP 5,000 compounded annually at 4% for 2 years, before taxes and fees.',
    solution:
        'A = 5,000(1.04)^2 = 5,408 pesos. Interest is 408 pesos. The rate and period are both annual.',
    mistake:
        'Do not enter 5 instead of 0.05 for 5%, mix months with an annual rate, or treat a quoted yield as a risk-free guarantee.',
    recap:
        'Match rates and time units, distinguish interest models, and account for fees, inflation, and risk.',
    questions: [
      [
        'What decimal represents 5%?',
        '0.05',
        '5',
        '0.5',
        '50',
        'Percent means per hundred.'
      ],
      [
        'What is simple interest on PHP 10,000 at 5% per year for 2 years?',
        'PHP 1,000',
        'PHP 500',
        'PHP 11,000',
        'PHP 25',
        'I = 10,000(0.05)(2).'
      ],
      [
        'What is the annual-compound balance of PHP 10,000 at 5% for 2 years?',
        'PHP 11,025',
        'PHP 11,000',
        'PHP 10,500',
        'PHP 12,000',
        '10,000(1.05)^2 = 11,025.'
      ],
      [
        'Six months expressed in years equals what?',
        '0.5',
        '6',
        '12',
        '2',
        'Six of twelve months is half a year.'
      ],
      [
        'What is simple interest on PHP 4,000 at 6% annually for half a year?',
        'PHP 120',
        'PHP 240',
        'PHP 1,440',
        'PHP 24',
        '4,000(0.06)(0.5) = 120.'
      ],
      [
        'A PHP 100 item is discounted 20%. What is its sale price?',
        'PHP 80',
        'PHP 120',
        'PHP 20',
        'PHP 96',
        'Multiply the original price by 0.8.'
      ],
      [
        'After PHP 100 falls 20% then rises 20%, what is the new amount?',
        'PHP 96',
        'PHP 100',
        'PHP 120',
        'PHP 80',
        'The second percentage applies to 80, not 100.'
      ],
      [
        'What makes compound interest differ from simple interest?',
        'Interest can earn further interest',
        'The principal must be negative',
        'Time has no effect',
        'Fees are automatically included',
        'Compounding applies interest to accumulated balances.'
      ],
      [
        'What is PHP 5,000 compounded annually at 4% for 2 years?',
        'PHP 5,408',
        'PHP 5,400',
        'PHP 5,200',
        'PHP 5,040',
        '5,000 x 1.04 x 1.04 = 5,408.'
      ],
      [
        'Savings grow 2% while prices rise 5%. What happens to approximate purchasing power?',
        'It decreases',
        'It necessarily increases 7%',
        'It stays exactly unchanged',
        'It doubles',
        'Prices grow faster than the nominal balance.'
      ],
      [
        'Two loans quote rates but only one discloses fees. What is needed for a fair comparison?',
        'Comparable total costs over the same period',
        'The shorter advertisement',
        'The larger printed percentage',
        'Ignoring repayment dates',
        'Fees, timing, and interest all affect the cost.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Graphs, Networks, and Fair Decisions',
    objectives: [
      'Represent a network using vertices and edges.',
      'Distinguish a path through locations from a route through every edge.',
      'Evaluate a decision using constraints and a stated fairness rule.',
    ],
    explanation:
        'A mathematical graph models connections, not necessarily a chart of measured values. '
        'Vertices can represent barangays and edges roads. Edge weights may represent distances or costs. '
        'The shortest route minimizes the sum of weights, not the number of roads alone. '
        'A route visiting each road exactly once is an Euler trail; in a connected undirected graph it exists '
        'when exactly zero or two vertices have odd degree. Visiting each location once is a different problem. '
        'Decision mathematics also makes fairness rules explicit. Sharing PHP 1,200 equally among 3 groups gives '
        'PHP 400 each; sharing in proportion to sizes 10, 20, 30 gives PHP 200, 400, 600. '
        'Neither rule can be called uniquely fair without explaining the intended goal.',
    model: {
      'A-B: 4 km; B-C: 3 km; A-C: 10 km':
          'A to B to C is 7 km, shorter than the direct 10 km edge.',
      'Triangle A-B-C-A':
          'Each vertex has degree 2; an Euler circuit is possible.',
      'Group sizes 10, 20, 30; fund PHP 1,200':
          'Proportional shares are PHP 200, 400, and 600.',
    },
    worked: 'Find a route from A to C. 1. List direct A-C = 10 km. '
        '2. List A-B-C = 4 + 3 = 7 km. 3. Compare 7 with 10. '
        '4. Choose A-B-C under a distance-only objective; road safety or closures could change the decision.',
    guided:
        'Three groups have 5, 10, and 15 members. Share PHP 600 in proportion to group size.',
    solution:
        'There are 30 members. Each member corresponds to PHP 20. Group shares are 100, 200, and 300 pesos; their sum is 600.',
    mistake:
        'Do not confuse an edge with a vertex, the fewest edges with the lowest total weight, or equal shares with proportional shares.',
    recap:
        'Define the network, objective, and constraints; state the fairness criterion before comparing decisions.',
    questions: [
      [
        'What represents a location in a road-network graph?',
        'A vertex',
        'A percentage',
        'A median',
        'An interest rate',
        'Vertices model locations; edges model connections.'
      ],
      [
        'What represents a road between two modeled locations?',
        'An edge',
        'A sample mean',
        'A universal quantifier',
        'A discount',
        'An edge connects modeled vertices.'
      ],
      [
        'A-B is 4 km and B-C is 3 km. What is the distance A-B-C?',
        '7 km',
        '12 km',
        '1 km',
        '10 km',
        'Add the two edge lengths.'
      ],
      [
        'A-C is 10 km and A-B-C is 7 km. Which minimizes distance?',
        'A-B-C',
        'A-C',
        'Both are 10 km',
        'The path with fewer letters',
        '7 is less than 10.'
      ],
      [
        'What is the degree of each vertex in a triangle graph?',
        '2',
        '1',
        '3',
        '6',
        'Two edges meet at each vertex.'
      ],
      [
        'A connected undirected graph has exactly two odd-degree vertices. What is possible?',
        'An Euler trail with different start and end vertices',
        'No route along any edge',
        'An Euler circuit starting anywhere',
        'A proof that every distance is equal',
        'An Euler trail starts and ends at the two odd vertices.'
      ],
      [
        'PHP 1,200 divided equally among 3 groups gives each how much?',
        'PHP 400',
        'PHP 200',
        'PHP 600',
        'PHP 300',
        '1,200/3 = 400.'
      ],
      [
        'For sizes 10, 20, 30 sharing PHP 1,200 proportionally, what does the smallest group receive?',
        'PHP 200',
        'PHP 400',
        'PHP 600',
        'PHP 120',
        '10/60 of 1,200 equals 200.'
      ],
      [
        'For sizes 5, 10, 15 sharing PHP 600 proportionally, what does the largest group receive?',
        'PHP 300',
        'PHP 200',
        'PHP 100',
        'PHP 600',
        '15/30 of the fund equals half, or 300.'
      ],
      [
        'Why may a shortest-distance route not be the best real route?',
        'Safety or closures may impose additional constraints',
        'Distance cannot be added',
        'All roads always have equal risk',
        'Vertices are not allowed in routes',
        'The objective and constraints must reflect the actual situation.'
      ],
      [
        'Before calling a fund allocation fair, what should be stated?',
        'The fairness rule and its purpose',
        'Only the largest share',
        'Only the number of banknotes',
        'A claim that all rules are identical',
        'Equal shares and proportional shares serve different goals.'
      ],
    ],
  ),
];
