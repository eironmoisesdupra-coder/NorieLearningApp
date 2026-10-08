import '../../domain/norie_content_models.dart';
import 'science_expansion_builder.dart';
import 'science_figure.dart';

// Accuracy references for these originally authored explanations and examples:
// https://openstax.org/books/university-physics-volume-2/pages/1-4-heat-transfer-specific-heat-and-calorimetry
// https://openstax.org/books/university-physics-volume-3/pages/10-3-radioactive-decay
// https://biosci.mcdb.ucsb.edu/biochemistry/tw-kin/enzymeinhibition.htm
// No text, diagrams, or media are copied from these sources.

const advancedExpansionFigures = <String, ScienceFigure>{
  'sci-g11-expansion': ScienceFigure(
      title: 'Ideal mixing of equal water masses',
      kind: 'process',
      labels: ['100 g at 60°C', '100 g at 20°C', '200 g at 40°C'],
      details: [
        'Warm sample loses heat.',
        'Cool sample gains the same heat.',
        'Both reach one equilibrium temperature.'
      ],
      note:
          'The 40°C prediction assumes no heat exchange with the container or surroundings and no phase change.'),
  'sci-g12-expansion': ScienceFigure(
      title: 'Remaining parent nuclei over half-lives',
      kind: 'bars',
      labels: ['0 half-lives', '1 half-life', '2 half-lives', '3 half-lives'],
      details: [
        'Start with 800 parent nuclei.',
        'Expected remaining: 400.',
        'Expected remaining: 200.',
        'Expected remaining: 100.'
      ],
      values: [800, 400, 200, 100],
      unit: 'parent nuclei',
      note:
          'Each interval halves the remaining parent population, not the original population again. Small samples fluctuate around this expectation.'),
  'sci-college-expansion': ScienceFigure(
      title: 'Initial enzyme rates approach saturation',
      kind: 'bars',
      labels: ['[S] = 1 mM', '[S] = 2 mM', '[S] = 6 mM'],
      details: ['v = 20 µmol/min.', 'v = 30 µmol/min.', 'v = 45 µmol/min.'],
      values: [20, 30, 45],
      unit: 'µmol/min',
      note:
          'For Vmax = 60 µmol/min and Km = 2 mM, v = Vmax[S]/(Km + [S]). Rate rises toward Vmax rather than increasing linearly forever.'),
};

final advancedScienceExpansion = <String, NorieTopicContent>{
  'g11': expansionLesson(
    grade: 'g11',
    title: 'Heat Transfer and Calorimetry',
    prerequisite: 'science.g11.scientific-data-analysis',
    objectives: [
      'Distinguish heat transfer from temperature.',
      'Calculate thermal energy using Q = mcΔT.',
      'Apply energy conservation to an ideal mixing problem.'
    ],
    introduction:
        'A warm object transfers energy to a cooler one until thermal equilibrium is reached. Temperature alone does not tell us how much energy transfers: mass and material properties also matter.',
    explanation:
        'Heat is energy transferred because of a temperature difference. Temperature describes thermal state; it is not a stored amount of heat. For a sample without phase change, Q = mcΔT, where m is mass, c is specific heat capacity, and ΔT = final minus initial temperature. A positive Q means energy enters the sample, and a negative Q means it leaves. With c in J/(g·°C), use mass in grams and temperature change in °C. Water has approximately c = 4.18 J/(g·°C) under ordinary classroom conditions. A Celsius temperature difference has the same numerical size as a kelvin difference.',
    application:
        'A calorimeter limits energy exchange with the surroundings. In an ideal isolated mixing model, energy lost by a warm sample equals energy gained by the cooler sample. Thus ΣQ = 0, including the container if its heat capacity matters. Thermal equilibrium means the final temperature is shared. For equal masses of the same material with no phase change or losses, it is the mean of the two initial temperatures. Unequal masses or different specific heat capacities require balancing mcΔT rather than averaging blindly.',
    worked:
        'Heat 50 g of water from 20°C to 30°C. Step 1: ΔT = 30 − 20 = 10°C. Step 2: use c = 4.18 J/(g·°C). Step 3: Q = 50 × 4.18 × 10 = 2090 J. Step 4: the positive sign means water gains energy. If the same sample cools back to 20°C, Q = −2090 J for the water in this model.',
    guided:
        'Mix 100 g of water at 60°C with 100 g at 20°C in an ideal insulated container. Write the energy balance, cancel common factors, and find the final temperature. State one real-world reason a result could differ.',
    solution:
        '100c(T − 60) + 100c(T − 20) = 0. Cancel 100c to get 2T − 80 = 0, so T = 40°C. Heat absorbed by the container or exchanged with the surroundings can shift the measured result.',
    mistakes:
        'Use a temperature change, not the final temperature, in mcΔT. Do not mix kilograms with a specific heat given per gram. The average temperature rule applies only when the relevant heat capacities are equal. Phase changes need a latent-heat term.',
    recap:
        'Heat is transferred energy; temperature is a thermal-state measure. Use consistent units in Q = mcΔT. In an isolated calorimetry model, include all significant energy gains and losses and set their sum to zero.',
    figure: advancedExpansionFigures['sci-g11-expansion']!,
    questions: [
      'What does heat mean in this lesson?|Energy transferred due to a temperature difference|Temperature stored in degrees|Mass of warm matter|An object permanent substance|Heat describes energy transfer, whereas temperature describes thermal state.|Heat and temperature',
      'In Q = mcΔT, ΔT represents what?|Final minus initial temperature|Final temperature alone|Mass divided by temperature|Initial plus final temperature|The equation uses the change in temperature, not an absolute reading.|Calorimetry',
      'Heat 10 g water by 5°C with c = 4.18 J/(g·°C). Q is what?|209 J|20.9 J|41.8 J|2.09 J|Multiply mass, specific heat, and change: 10 × 4.18 × 5 = 209 J.|Calculation',
      'Use Q = mcΔT with positive mass and specific heat, and ΔT = final minus initial temperature. A cooling sample has which sign of Q?|Negative|Always positive|Always zero|No possible sign|Final temperature is lower, so ΔT and Q are negative for the cooling sample.|Energy signs',
      'Equal masses of water at 50°C and 10°C mix ideally. Final temperature is what?|30°C|60°C|40°C|20°C|Equal heat capacities allow the mean: (50 + 10) ÷ 2 = 30°C.|Energy balance',
      'Equal masses of water at 50°C and 10°C mix without phase change, with the same specific heat. Which additional assumption permits using their simple mean as the final temperature?|No significant container or environmental heat exchange|Any container mass is ignored even if large|Both samples change phase|The specific heats must differ|The mean requires equal sample heat capacities and no significant other exchanges.|Model assumptions',
      'At fixed mass and ΔT, doubling specific heat does what to Q?|Doubles Q|Halves Q|Leaves Q unchanged|Makes Q negative automatically|Energy transfer is directly proportional to c when other factors are fixed.|Specific heat',
      'When melting occurs at constant temperature, what term is needed?|Latent heat|Only mc times zero|Only final temperature|Only container color|Phase change transfers energy despite no temperature rise, requiring latent heat.|Phase change',
      'Heat 25 g water from 18°C to 22°C with c = 4.18. Q is what?|418 J|2300 J|104.5 J|41.8 J|The change is 4°C, so Q = 25 × 4.18 × 4 = 418 J.|Calculation',
      'A real container warms during mixing. How should its energy enter the model?|Include its heat gain in the balance|Assume its gain is always zero|Count it as lost mass|Replace ΔT with absolute temperature|The container can absorb energy and must be included when significant.|Energy balance',
      'Why is averaging unequal water masses usually wrong?|Their heat capacities differ because their masses differ|Water cannot reach equilibrium|Temperature has no unit|Energy conservation fails|Each sample heat capacity is mc; unequal masses weight the balance differently.|Model assumptions',
    ],
  ),
  'g12': expansionLesson(
    grade: 'g12',
    title: 'Radioactive Decay and Half-Life',
    prerequisite: 'science.g12.ecology',
    objectives: [
      'Calculate remaining parent nuclei after whole half-lives.',
      'Distinguish random individual decay from population patterns.',
      'Evaluate assumptions in a simple radiometric-age model.'
    ],
    introduction:
        'An unstable nucleus can transform by radioactive decay. We cannot predict when one particular nucleus decays, yet large populations show a reliable pattern that supports measurements of time.',
    explanation:
        'A half-life is the time for the expected number of undecayed parent nuclei in a large sample to halve. After n half-lives, N = N₀(1/2)ⁿ. The same fraction of the remaining population decays in each interval. Starting with 800 parent nuclei, the expectations after one, two, and three half-lives are 400, 200, and 100. This is not subtraction of 400 every time. Individual decays are random, so small samples fluctuate. Half-life is a property of the isotope; ordinary temperature changes do not usually alter nuclear decay rates appreciably.',
    application:
        'For continuous time use N = N₀e^(−λt), where λ is the decay constant and half-life = ln(2)/λ. Activity A = λN is the expected number of decays per time, so activity also halves with the parent population when λ stays fixed. Radiometric dating compares isotope quantities within a justified geological model. The simplified closed-system model assumes a known initial parent amount or a way to infer it, appropriate treatment of initial daughter isotope, and no later loss or gain of parent or daughter. Real dating methods test these assumptions rather than assuming every rock is suitable.',
    worked:
        'An isotope half-life is 5 years. A sample begins with 160 mg of parent isotope. Step 1: 15 years is 15 ÷ 5 = 3 half-lives. Step 2: remaining fraction = (1/2)³ = 1/8. Step 3: parent amount = 160 ÷ 8 = 20 mg. This is parent isotope remaining, not total material mass; daughter products may still be present in the sample.',
    guided:
        'A closed sample retains 25% of its initial parent isotope. Its half-life is 12 years. Find the elapsed time and explain whether every nucleus waited exactly one half-life before decaying.',
    solution:
        '25% = 1/4 = (1/2)², so two half-lives have elapsed: 2 × 12 = 24 years. Individual decays are random; the half-life describes the population, not a timer inside each nucleus.',
    mistakes:
        'Half-life does not mean all nuclei disappear after two intervals. Parent isotope loss is not necessarily loss of total sample mass. A measured ratio alone does not prove an age unless the dating-model assumptions are justified.',
    recap:
        'Each half-life halves the remaining parent population. Use exponential fractions, distinguish population expectations from random single decays, and state closed-system and initial-isotope assumptions when interpreting ages.',
    figure: advancedExpansionFigures['sci-g12-expansion']!,
    questions: [
      'After one half-life, what fraction of parent nuclei is expected to remain?|1/2|1/4|0|1|A half-life halves the expected undecayed parent population.|Half-life',
      'After three half-lives, what fraction remains?|1/8|1/3|3/4|0|Repeated halving gives (1/2)³ = 1/8.|Calculation',
      'A sample starts with 200 mg parent. After two half-lives, parent amount is what?|50 mg|100 mg|0 mg|150 mg|Two halvings leave one quarter of 200 mg, which is 50 mg.|Calculation',
      'What can be predicted for one unstable nucleus?|A decay probability, not an exact decay time|The exact second from half-life alone|It waits precisely one half-life|It cannot decay early|Radioactive decay is random for an individual nucleus.|Random decay',
      'If half-life is 4 years, 12 years contains how many half-lives?|3|4|8|48|Divide elapsed time by half-life: 12 ÷ 4 = 3.|Calculation',
      'With λ fixed, activity is proportional to what?|Number of remaining parent nuclei|Container color|Only daughter mass|Room width|Activity A = λN is proportional to the parent population.|Activity',
      'What does a closed isotope system mean in the simplified dating model?|No parent or daughter enters or leaves|No light enters the room|No temperature variation ever|No decay occurs|The model requires no later gain or loss of relevant isotopes.|Dating assumptions',
      'After decay, does parent loss necessarily mean equal total sample mass loss?|No; daughter products can remain|Yes; all daughters vanish|Yes; matter ceases to exist|No; parent nuclei never change|The parent isotope transforms and daughter products may remain in the sample.|Parent and daughter',
      'A sample retains 12.5% parent with half-life 6 years. Elapsed time is what?|18 years|12 years|6 years|48 years|12.5% is 1/8, three half-lives, so time is 3 × 6 = 18 years.|Calculation',
      'After one half-life activity is 40 Bq. After another it is expected to be what?|20 Bq|0 Bq|80 Bq|40 Bq|Activity halves again as the remaining parent population halves.|Activity',
      'A rock lost some parent isotope after formation. Why question the simple age?|The closed-system assumption is violated|Decay must have stopped|All isotope ratios become equal|Half-life becomes a distance|Later parent loss can change the measured ratio independently of elapsed decay time.|Dating assumptions',
    ],
  ),
  'college': expansionLesson(
    grade: 'college',
    title: 'Enzyme Kinetics',
    prerequisite: 'science.college.scientific-research',
    objectives: [
      'Interpret substrate saturation in initial-rate data.',
      'Calculate rates using the Michaelis–Menten model.',
      'Distinguish competitive inhibition from changes in enzyme concentration.'
    ],
    introduction:
        'Enzymes catalyze reactions by lowering activation barriers. Initial-rate measurements show how substrate concentration influences reaction speed and help test models of enzyme behavior.',
    explanation:
        'For a simple enzyme under Michaelis–Menten assumptions, v = Vmax[S]/(Km + [S]). Here v is initial rate, [S] is substrate concentration, Vmax is the limiting rate at substrate saturation, and Km is the substrate concentration at half Vmax. When [S] is much smaller than Km, rate is approximately proportional to [S]. When [S] greatly exceeds Km, rate approaches Vmax because enzyme active sites are occupied much of the time. Km is not generally identical to a binding dissociation constant: it combines rate constants in the kinetic mechanism.',
    application:
        'Measure initial rates before substrate depletion or product accumulation meaningfully alters the conditions. Keep pH, temperature, and enzyme concentration controlled when comparing substrate concentrations. The model assumes an appropriate simple mechanism and a steady-state enzyme-substrate intermediate after a short initial transient; it does not describe every enzyme. In ideal reversible competitive inhibition, inhibitor competes with substrate for the active site, increasing apparent Km while leaving Vmax unchanged. Higher substrate can overcome this model effect. Increasing enzyme concentration instead increases Vmax proportionally if other conditions remain suitable.',
    worked:
        'Let Vmax = 60 µmol/min and Km = 2 mM. At [S] = 2 mM, v = 60 × 2/(2 + 2) = 30 µmol/min, half Vmax. At [S] = 6 mM, v = 60 × 6/(2 + 6) = 45 µmol/min. Tripling substrate here raises rate only by a factor of 1.5. Saturation explains why the response is not linear across the whole range.',
    guided:
        'A competitive inhibitor doubles apparent Km from 2 to 4 mM, while Vmax stays 60 µmol/min. Compute rate at [S] = 2 mM with inhibitor and compare with the uninhibited 30 µmol/min. What happens as substrate becomes very large?',
    solution:
        'With inhibitor, v = 60 × 2/(4 + 2) = 20 µmol/min, lower than 30. As substrate becomes very large relative to apparent Km, both models approach the same Vmax of 60 µmol/min.',
    mistakes:
        'Vmax is an asymptotic saturation rate, not necessarily a measured rate at any one finite substrate concentration. Km has concentration units, not rate units. Do not infer an inhibition mechanism from one low rate alone; fit multiple concentrations and examine model assumptions.',
    recap:
        'Michaelis–Menten kinetics relates initial rate to substrate concentration through saturation. At [S] = Km, rate is half Vmax. Competitive inhibition changes apparent Km in the ideal model; enzyme amount changes Vmax. Interpret fits within their experimental assumptions.',
    figure: advancedExpansionFigures['sci-college-expansion']!,
    questions: [
      'At [S] = Km in the Michaelis–Menten model, v equals what?|Vmax/2|Vmax|2Vmax|Zero|Substituting Km gives VmaxKm/(Km + Km) = Vmax/2.|Kinetics model',
      'What are the units of Km when [S] is in mM?|mM|µmol/min|Seconds only|No units|Km is added to substrate concentration and therefore has concentration units.|Units',
      'Why does rate approach a plateau as substrate increases?|Enzyme active sites approach saturation|All substrate disappears instantly|Enzyme mass grows automatically|The reaction no longer conserves atoms|At high substrate, finite enzyme catalytic capacity limits the rate.|Saturation',
      'Vmax = 40 and Km = 3. At [S] = 3, v is what in the same rate unit?|20|40|10|120|At substrate equal to Km, the initial rate is half of Vmax.|Calculation',
      'Ideal competitive inhibition changes which parameters?|Apparent Km increases and Vmax stays fixed|Vmax doubles and Km vanishes|Both necessarily become zero|Km stays fixed and Vmax always doubles|Competition raises the apparent substrate requirement without changing saturation capacity.|Inhibition',
      'Why measure initial rather than late reaction rates?|To limit substrate depletion and product effects|To guarantee every enzyme fits the model|To avoid recording temperature|To make all errors zero|Initial rates reduce changes caused by substrate depletion and accumulating products.|Experimental design',
      'Doubling enzyme concentration under suitable fixed conditions tends to do what?|Double Vmax|Halve Vmax|Double Km necessarily|Make v independent of enzyme|More enzyme provides proportionally more catalytic capacity, raising Vmax.|Enzyme concentration',
      'Is Km always equal to a binding dissociation constant?|No; it combines mechanism rate constants|Yes for every enzyme|Yes because both lack units|No because it measures mass|Km is a kinetic composite and is not generally identical to a binding constant.|Model limits',
      'Vmax = 90, Km = 2, [S] = 4. Compute v.|60|45|180|30|The model gives 90 × 4/(2 + 4) = 60 in the rate unit.|Calculation',
      'An inhibitor raises apparent Km but leaves fitted Vmax fixed. Which model is consistent?|Ideal competitive inhibition|Simply doubling enzyme concentration|All possible mechanisms proven equally|No possible inhibition|This parameter pattern is consistent with the ideal competitive model, subject to fit validity.|Inhibition',
      'One inhibited rate is low at one substrate concentration. What is the best next inference?|More concentrations and controls are needed to identify mechanism|Competitive inhibition is proven uniquely|Km has no units|Vmax must be zero|One point cannot uniquely determine kinetic parameters or an inhibition mechanism.|Experimental design',
    ],
  ),
};
