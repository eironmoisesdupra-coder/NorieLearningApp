import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

/// Introductory university modules; all examples and figures are locally authored.
final List<NorieTopicContent> collegeScienceTopics = [
  _biology,
  _chemistry,
  _physics,
  _earth,
  _research,
];

const Map<String, ScienceFigure> collegeScienceFigures = {
  'college_biology_rates': ScienceFigure(
      title: 'Saturation is a diminishing response',
      kind: 'bars',
      labels: ['1 mmol/L', '2 mmol/L', '6 mmol/L'],
      details: [
        'One third of Vmax.',
        'Half of Vmax: this concentration is Km.',
        'Three quarters of Vmax.'
      ],
      values: [30, 45, 67.5],
      unit: 'micromol/min',
      note:
          'Model: Vmax = 90 micromol/min and Km = 2 mmol/L. Bars show initial rate at each substrate concentration, not elapsed time.'),
  'college_biology_inhibition': ScienceFigure(
      title: 'Distinguish capacity from substrate response',
      kind: 'comparison',
      labels: ['Uninhibited', 'Competitive inhibitor', 'Twice the enzyme'],
      details: ['Vmax 90; Km 2.', 'Vmax 90; apparent Km 6.', 'Vmax 180; Km 2.'],
      note:
          'Rates in micromol/min; Km in mmol/L. Ideal reversible competition, otherwise identical assay conditions.'),
  'college_biology_coupling': ScienceFigure(
      title: 'A coupled pathway has a shared intermediate',
      kind: 'process',
      labels: [
        'Unfavorable step',
        'Coupled favorable step',
        'Net transformation'
      ],
      details: [
        'A + B to AB requires +12 kJ/mol.',
        'A linked ATP-dependent step supplies -30 kJ/mol.',
        'The linked route totals -18 kJ/mol under the stated conditions.'
      ],
      note:
          'Add free-energy changes only for stoichiometrically matched steps. Merely placing two reactions together does not couple them.'),
  'college_chemistry_temperature': ScienceFigure(
      title: 'Temperature can reverse a driving force',
      kind: 'comparison',
      labels: ['250 K', '300 K', '350 K'],
      details: [
        'Delta G = +5 kJ/mol.',
        'Delta G = 0 kJ/mol.',
        'Delta G = -5 kJ/mol.'
      ],
      note:
          'Illustrative model: Delta H = +30 kJ/mol and Delta S = +0.100 kJ/(mol K), treated as constant across this range.'),
  'college_chemistry_direction': ScienceFigure(
      title: 'Composition determines the present direction',
      kind: 'comparison',
      labels: ['Q/K = 0.1', 'Q/K = 1', 'Q/K = 10'],
      details: [
        'ln(Q/K) < 0: forward change favored.',
        'ln(Q/K) = 0: equilibrium.',
        'ln(Q/K) > 0: reverse change favored.'
      ],
      note:
          'Delta G = RT ln(Q/K). Use dimensionless activities and the same balanced reaction at fixed temperature.'),
  'college_chemistry_path': ScienceFigure(
      title: 'Three questions about one reaction',
      kind: 'comparison',
      labels: [
        'Thermodynamic direction',
        'Equilibrium composition',
        'Reaction rate'
      ],
      details: [
        'Delta G at the current composition.',
        'K at the specified temperature.',
        'Activation barrier and kinetic mechanism.'
      ],
      note:
          'A catalyst changes the pathway and rates; it does not change Delta G or K for the same reaction and conditions.'),
  'college_physics_cycle': ScienceFigure(
      title: 'One cycle after release at the right turning point',
      kind: 'cycle',
      labels: [
        't = 0: x = +A',
        't = T/4: x = 0',
        't = T/2: x = -A',
        't = 3T/4: x = 0'
      ],
      details: [
        'v = 0; acceleration left.',
        'Velocity left at maximum speed; acceleration zero.',
        'v = 0; acceleration right.',
        'Velocity right at maximum speed; acceleration zero.'
      ],
      note:
          'Undamped horizontal spring. At t = T the starting state returns; position alone does not specify direction.'),
  'college_physics_energy': ScienceFigure(
      title: 'Stored energy grows with displacement squared',
      kind: 'bars',
      labels: ['x = 0', 'x = A/2', 'x = A'],
      details: [
        'All 1 J is kinetic.',
        '0.25 J elastic; 0.75 J kinetic.',
        'All 1 J is elastic.'
      ],
      values: [0, 0.25, 1],
      unit: 'J elastic energy',
      note:
          'k = 200 N/m and amplitude A = 0.10 m; total mechanical energy is 1 J throughout the undamped motion.'),
  'college_physics_damping': ScienceFigure(
      title: 'Energy accounting changes when damping is present',
      kind: 'comparison',
      labels: [
        'Ideal free oscillator',
        'Damped free oscillator',
        'Driven damped oscillator'
      ],
      details: [
        'Mechanical energy remains constant.',
        'Mechanical energy transfers to the environment.',
        'External work can balance dissipated energy.'
      ],
      note:
          'Resonance is a frequency response; finite damping limits the steady-state response.'),
  'college_earth_budget': ScienceFigure(
      title: 'A balanced illustrative top-of-atmosphere budget',
      kind: 'bars',
      labels: ['Incoming solar', 'Reflected solar', 'Outgoing infrared'],
      details: [
        '340 W/m2 averaged over the sphere.',
        '102 W/m2 for albedo 0.30.',
        '238 W/m2 balances absorbed sunlight.'
      ],
      values: [340, 102, 238],
      unit: 'W/m2',
      note:
          'Incoming = reflected + emitted in this ideal balance. These rounded model values are not a current observational estimate.'),
  'college_earth_feedback': ScienceFigure(
      title: 'Ice-albedo feedback amplifies an initial warming',
      kind: 'cycle',
      labels: [
        'Initial warming',
        'Less reflective ice',
        'More solar absorption'
      ],
      details: [
        'A perturbation raises temperature.',
        'Replacing ice with darker surfaces reduces albedo.',
        'Additional absorbed power can reinforce warming.'
      ],
      note:
          'A positive feedback amplifies a change; it does not imply unlimited warming or a beneficial outcome.'),
  'college_earth_carbon': ScienceFigure(
      title: 'Track a reservoir using both directions of exchange',
      kind: 'process',
      labels: [
        'Inputs: 12 GtC/year',
        'Atmospheric reservoir',
        'Outputs: 5 GtC/year'
      ],
      details: [
        'Illustrative total carbon entering.',
        'Inventory increases by 7 GtC each year if fluxes persist.',
        'Illustrative total carbon leaving.'
      ],
      note:
          'Invented budget for arithmetic; GtC measures carbon mass, not mass of CO2. All relevant boundary fluxes must be counted.'),
  'college_research_design': ScienceFigure(
      title: 'The pot, not each leaf, receives treatment',
      kind: 'process',
      labels: [
        '24 separate pots',
        'Random allocation',
        'One mean outcome per pot'
      ],
      details: [
        'Plants are grown in independently treated pots.',
        '12 receive nutrient A; 12 receive control solution.',
        'Five leaves per pot improve its measurement; n remains 12 per group.'
      ],
      note:
          'Keep light, water and measurement procedures comparable. Block by bench if a light gradient is expected.'),
  'college_research_interval': ScienceFigure(
      title: 'Separate an estimate from its uncertainty',
      kind: 'comparison',
      labels: [
        'Estimated effect',
        'Standard error',
        'Approximate 95% interval'
      ],
      details: [
        'Treatment minus control = 4 mm.',
        'SE of this difference = 1.5 mm.',
        'Using estimate +/- 2 SE gives 1 to 7 mm.'
      ],
      note:
          'The multiplier 2 is a supplied approximation, not an exact critical value for every sample size.'),
  'college_research_errors': ScienceFigure(
      title: 'A test can make either kind of decision error',
      kind: 'comparison',
      labels: ['Type I error', 'Type II error', 'Power'],
      details: [
        'Reject a null hypothesis that is true.',
        'Fail to reject a null hypothesis that is false.',
        'Probability of rejecting a false null at a specified effect.'
      ],
      note:
          'Error rates refer to repeated sampling under specified models, not probabilities that a particular conclusion is wrong.'),
};

final _research = scienceTopic(
  grade: 'college',
  order: 5,
  title: 'Scientific Research',
  subtitle:
      'Design independent comparisons and interpret estimates with uncertainty',
  minutes: '40-45 minutes',
  prerequisiteTopicId: 'science.college.earth-science',
  objectives: [
    'Identify experimental units, controls, confounding and appropriate replication.',
    'Distinguish random assignment, random sampling, blinding and blocking.',
    'Calculate effect estimates, standard errors and supplied approximate intervals.',
    'Interpret p-values, error types and limits of causal and population claims.',
  ],
  introduction:
      'Twenty measurements can represent twenty independent experiments or twenty readings of one specimen. Those designs support different conclusions. This module follows a fictional plant-growth experiment from its research question to a defensible claim, extending the earlier data-analysis lessons.',
  sections: [
    scienceSection('Define the claim before collecting outcomes',
        '''Ask whether nutrient treatment A changes mean stem growth relative to a control over 14 days under specified growing conditions. Define the outcome as final stem length minus initial stem length in millimeters. State the target population, treatment dose, measurement timing and planned comparison. A null hypothesis might be that the population mean treatment-control difference is zero; an alternative allows a difference.

Pre-specifying the primary outcome, exclusion rules and analysis reduces the opportunity to select only favorable results after seeing the data. Exploratory analyses can be valuable, but label them as exploratory. Record unexpected observations and protocol deviations. A method must describe what actually happened rather than retrospectively rewriting the planned experiment as if every choice was fixed in advance.'''),
    scienceSection('Identify the independently treated unit',
        '''An experimental unit is the smallest unit independently assigned to a treatment. Suppose 24 separate pots each contain one plant. Assign 12 pots to A and 12 to control, with separate treatment application to each pot. If five leaves are measured from each plant, those leaves are subsamples within a pot. They do not turn 12 independently treated pots into 60 independent treatment replicates.

Repeated measurements can improve the precision of a pot-level outcome, but treating them as independent treatment units is pseudoreplication. If nutrient is applied to a shared tank that supplies several pots, the tank may instead be the independently treated unit. Identify how treatment is delivered before deciding what sample size means. Biological replication and technical measurement repetition answer different uncertainty questions.'''),
    scienceVisual('college_research_design',
        'Each pot receives treatment independently; subsampling leaves does not increase the number of randomized units.'),
    scienceSection('Assignment, sampling, blinding and blocking',
        '''Random assignment distributes units between treatments using chance. It helps balance potential confounders in expectation and supports causal comparisons when the experiment is otherwise valid. It does not guarantee identical groups in one small experiment. Random sampling selects units from a population and supports generalization to that population. Randomly assigning convenient greenhouse plants does not make them representative of every plant variety and climate.

Blinding the outcome assessor to treatment labels reduces measurement bias. Blocking groups similar units before randomizing within each group: for example, randomize A and control pots within each bench if benches have different light exposure. Giving all A pots the sunny bench and all controls the shaded bench confounds treatment with light. A control should match water, solvent and handling so that the intended nutrient difference is isolated.'''),
    scienceSection('Worked example: effect size and standard error',
        '''Suppose mean growth is 18 mm for A and 14 mm for control. The estimated effect is 18 - 14 = 4 mm, or about 28.6% of the control mean. The absolute difference and its units are the primary result here; the percentage depends on the reference value.

For n independent observations with sample standard deviation s, the estimated standard error of their mean is s/sqrt(n). It describes sampling uncertainty in a mean, while s describes variation among observations. If s = 6 mm and n = 9, SE = 2 mm. With similar variability and 36 independent observations, SE = 1 mm. Quadrupling independent sample size halves SE; simply rereading the same nine plants does not supply 36 independent plants. For independent groups, SE of the difference can be estimated as sqrt(sA^2/nA + sC^2/nC).'''),
    scienceSection('Guided example: build and interpret an interval',
        '''Assume the estimated treatment-control difference is 4 mm and its standard error is 1.5 mm. Using the supplied large-sample approximation estimate plus or minus 2 SE gives 4 +/- 3, an interval from 1 to 7 mm. Zero lies outside this approximate interval. The interval suggests positive effects compatible with the model but includes both small and larger benefits. Whether a 1 mm benefit matters depends on the scientific context.

A frequentist 95% confidence procedure covers the fixed population parameter in about 95% of repeated samples under its assumptions. It does not mean 95% of individual plants grow within the interval, and it is not a posterior probability statement about the parameter after observing this particular interval. Exact critical values depend on the design and distributional assumptions; a multiplier of 2 is a stated approximation, not a universal rule.'''),
    scienceVisual('college_research_interval',
        'The estimate is 4 mm; uncertainty spans 1 to 7 mm under the supplied approximation. Neither number describes all individual plants.'),
    scienceSection('What a p-value does and does not say',
        '''A p-value is the probability, under the null hypothesis and model assumptions, of a test statistic at least as extreme as the observed one in the specified test. A small p-value indicates incompatibility with that null-model combination. It is not the probability the null hypothesis is true, the probability the result happened by chance, or a measurement of effect size.

At a prechosen significance level alpha, reject the null if the p-value is below the criterion. Failing to reject does not establish equivalence or prove no effect. A noisy study may miss a meaningful difference. Report the estimate, uncertainty, sample design and assumptions alongside a test decision. For a matching two-sided test and interval, excluding the null value corresponds to rejection at the related significance level; an approximate interval only provides an approximate comparison.'''),
    scienceSection('Error rates, power and multiple comparisons',
        '''A Type I error rejects a true null. A Type II error fails to reject a false null. Power is the probability of rejecting a false null for a specified true effect, design and analysis. Under otherwise comparable conditions, more independent units can reduce standard errors and improve power, but they do not repair systematic measurement bias or confounding.

If 20 independent tests each use alpha = 0.05 and every null is true, the chance of at least one false rejection is 1 - 0.95^20, about 0.64. Independence is an explicit assumption of this calculation. Plan primary comparisons and use suitable multiplicity procedures for families of confirmatory tests. Selecting the smallest p-value without reporting the search exaggerates evidence.'''),
    scienceVisual('college_research_errors',
        'A nonsignificant result can reflect low power; a significant result can still be a false rejection under repeated sampling.'),
    scienceSection('Real-world connection and evidence activity',
        '''Imagine two laboratories obtain effects of 4 and 3 mm using independent plants. Agreement is encouraging, but inspect whether both use the same uncalibrated instrument or the same biased sampling method. Reproducible errors remain errors. Share sufficient methods, de-identified data where appropriate, analysis code and limitations to allow scrutiny while respecting participant consent and privacy when people are involved.

Audit this fictional report: all treated plants occupied one sunny tray, controls occupied one shaded tray, 50 leaves per tray were counted as n = 50, and only the best of ten outcomes was reported. Identify the three problems: light is confounded with treatment, leaves are not independent treatment replicates, and outcome selection obscures multiple comparisons. A larger count of leaves fixes none of these design problems.'''),
    scienceSection('Common mistakes and quick check',
        '''Do not confuse a standard deviation with a standard error, random assignment with representative sampling, or failure to reject with proof of equality. Statistical significance alone neither establishes causality in an observational study nor guarantees a practically important effect. Check how data were generated before interpreting a precise number.

Quick check: six independently treated pots per group each provide ten leaf readings. How many treatment units are there per group? An estimated effect is 2 mm with SE = 2 mm. Using estimate +/- 2 SE, what interval follows and does it exclude zero?'''),
    scienceSection('Reveal and recap',
        '''There are six independently treated pots per group, not sixty. The interval is 2 +/- 4, or -2 to 6 mm, which includes zero. It also includes meaningful positive effects, so the result does not prove absence of an effect. Recap: define the question and unit, randomize and control plausible confounders, estimate effects with uncertainty and keep the final claim within the design's causal and population limits.''',
        reveal: true),
  ],
  keyConcept:
      'Strong inference starts with independent units and a credible comparison; estimates, uncertainty and model assumptions determine what the evidence can support.',
  questions: [
    [
      'In the pot experiment, what defines the experimental unit?',
      'The unit independently assigned and given a treatment',
      'Every leaf photographed',
      'Every repeated instrument display',
      'The entire population the researcher hopes to describe',
      'Treatment allocation and delivery determine the independent experimental unit; subsamples do not automatically become replicates.',
      'Experimental unit'
    ],
    [
      'What does random assignment primarily support?',
      'A causal comparison by balancing confounders in expectation',
      'Automatic representation of every population',
      'Guaranteed identical groups in each experiment',
      'Removal of all measurement error',
      'Chance allocation reduces systematic treatment-confounder association in expectation but does not guarantee exact balance.',
      'Assignment'
    ],
    [
      'What does random sampling primarily address?',
      'Representation of a defined population',
      'Which treatment each sampled unit receives',
      'The numerical value of the intervention effect',
      'The elimination of every confounder in an observational comparison',
      'Sampling concerns how units enter the study; assignment concerns which intervention they receive.',
      'Sampling'
    ],
    [
      'Why blind the person measuring stem growth?',
      'To reduce treatment-related measurement bias',
      'To increase the number of independent pots',
      'To guarantee a significant p-value',
      'To replace a control group',
      'Masking treatment labels helps prevent expectations from affecting outcome assessment.',
      'Blinding'
    ],
    [
      'What is pseudoreplication in this lesson?',
      'Counting dependent subsamples as independent treatment replicates',
      'Repeating an experiment with new independently treated pots',
      'Reporting all preplanned outcomes',
      'Randomizing treatment within blocks',
      'Leaves from one treated pot share its treatment context and cannot each supply an independent treatment replicate.',
      'Replication'
    ],
    [
      'What does sample standard deviation describe?',
      'Variation among observations',
      'Only uncertainty in the estimated mean',
      'The probability the null is true',
      'The size of the target population',
      'Standard deviation summarizes spread among measured values; standard error instead concerns uncertainty in an estimator.',
      'Variation'
    ],
    [
      'What is a Type I error?',
      'Rejecting a null hypothesis that is true',
      'Failing to reject a null hypothesis that is false',
      'Obtaining any estimate with units',
      'Randomizing treatment allocation',
      'A false rejection is Type I; missing a false null is Type II.',
      'Decision errors'
    ],
    [
      'Treatment mean is 18 mm and control mean is 14 mm. Find the effect estimate.',
      '+4 mm',
      '+32 mm',
      '-4 mm',
      '+1.29 mm',
      'The specified contrast is treatment minus control: 18 - 14 = 4 mm.',
      'Effect calculation'
    ],
    [
      'With s = 6 mm and n = 9 independent observations, what is SE of the mean?',
      '2 mm',
      '6 mm',
      '0.67 mm',
      '18 mm',
      'SE = s/sqrt(n) = 6/3 = 2 mm. This estimates uncertainty in the mean, not the spread of individual observations.',
      'Standard error'
    ],
    [
      'With the same s = 6 mm but n = 36, what is SE?',
      '1 mm',
      '2 mm',
      '6 mm',
      '0.167 mm',
      'The square root of 36 is 6, so SE = 6/6 = 1 mm.',
      'Sample-size scaling'
    ],
    [
      'Estimate = 4 mm and SE = 1.5 mm. Using +/- 2 SE, what is the interval?',
      '1 to 7 mm',
      '2.5 to 5.5 mm',
      '-1.5 to 1.5 mm',
      '4 to 6 mm',
      'The margin is 2 x 1.5 = 3 mm; subtract and add it to 4.',
      'Interval calculation'
    ],
    [
      'Twelve pots per group each supply five leaf readings. How many independent treatment units are in each group?',
      '12 pots',
      '60 leaves',
      '5 leaves',
      '24 groups',
      'Each pot receives treatment independently. Its five leaf subsamples improve measurement without changing n from 12.',
      'Unit counting'
    ],
    [
      'A p-value of 0.03 is below a prechosen alpha of 0.05. What is the test decision?',
      'Reject the null under the specified test assumptions',
      'Declare a 97% probability that the alternative is true',
      'Prove the effect is large',
      'Prove that no bias exists',
      'The p-value meets the decision criterion, but neither posterior probability, practical magnitude nor absence of bias follows.',
      'Test interpretation'
    ],
    [
      'How does blocking by bench help a randomized plant experiment?',
      'It compares treatments within similar light environments',
      'It puts all treated plants on the sunniest bench',
      'It eliminates the need for any randomization',
      'It turns every leaf into a separate treatment unit',
      'Randomizing within bench blocks reduces the influence of between-bench light differences on the comparison.',
      'Blocking'
    ],
    [
      'All treated pots are sunny and controls shaded. Why is a causal nutrient claim weak?',
      'Light and treatment are confounded',
      'There are too many possible units of length',
      'The control mean cannot be calculated',
      'Random sampling always prevents confounding',
      'The observed difference could reflect light, nutrient or both; the design does not isolate the nutrient effect.',
      'Confounding'
    ],
    [
      'Which interpretation of a frequentist 95% confidence procedure is appropriate?',
      'It covers the fixed true parameter in about 95% of repeated samples under assumptions',
      'It contains 95% of individual plants',
      'This observed interval gives a 95% posterior probability without a prior model',
      'The effect must equal the interval midpoint exactly',
      'Coverage is a long-run property of the interval-generating procedure, not the spread of individual observations.',
      'Confidence interpretation'
    ],
    [
      'What does failure to reject a zero-effect null establish?',
      'The evidence did not meet the rejection criterion',
      'The two treatments are scientifically equivalent',
      'The true effect is exactly zero',
      'The study had infinite power',
      'A nonsignificant result may be imprecise and does not by itself establish equivalence or no effect.',
      'Null interpretation'
    ],
    [
      'What is statistical power defined for?',
      'A specified effect, design and test',
      'A universal probability that any conclusion is correct',
      'The total electrical power of measuring equipment',
      'Only the number of reported p-values',
      'Power is the probability of rejecting a false null for a specified true effect and study design.',
      'Power'
    ],
    [
      'Why does increasing sample size not repair a biased measuring instrument?',
      'Random uncertainty can shrink while systematic bias remains',
      'Large samples eliminate units',
      'Standard errors necessarily increase with n',
      'Bias and standard error are identical quantities',
      'More independent data can improve precision around a systematically shifted measurement, leaving accuracy unresolved.',
      'Bias versus precision'
    ],
    [
      'Twenty independent tests use alpha = 0.05 with all nulls true. Approximately what is the chance of at least one false rejection?',
      '0.64',
      '0.05',
      'Exactly 1.00',
      '0.0025',
      'The probability of no false rejection is 0.95^20, about 0.36; its complement is about 0.64.',
      'Multiplicity'
    ],
    [
      'Six pots per group each provide ten leaves. Effect = 2 mm and SE = 2 mm. Which report is defensible using +/- 2 SE?',
      'n = 6 per group; interval -2 to 6 mm; zero is included',
      'n = 60 per group; interval 0 to 4 mm; equality is proved',
      'n = 10 per group; interval 2 to 4 mm; causality is guaranteed',
      'n = 6 per group; interval -2 to 6 mm; all effects are impossible',
      'Pots are the units. The margin is 4 mm, giving -2 to 6; including zero does not rule out meaningful effects.',
      'Integrated inference'
    ],
    [
      'Independent groups each have s = 4 mm and n = 16. What is SE of their difference?',
      'About 1.41 mm',
      '1 mm',
      '2 mm',
      '8 mm',
      'SE difference = sqrt(16/16 + 16/16) = sqrt(2), about 1.41 mm. Independence is required for this expression.',
      'Two-group uncertainty'
    ],
    [
      'A randomized experiment on one convenient plant variety finds a small precise effect. Which conclusion is justified?',
      'The design supports a treatment comparison in these conditions; wider generalization needs evidence',
      'The effect must hold equally for every species and climate',
      'Precision proves there was no systematic bias',
      'Random assignment automatically creates a random population sample',
      'Random assignment strengthens the causal comparison, while sampling, setting and effect size constrain generalization and practical importance.',
      'Claim boundaries'
    ],
  ],
);

final _earth = scienceTopic(
  grade: 'college',
  order: 4,
  title: 'Earth Science',
  subtitle:
      'Use conservation laws to analyze planetary energy and carbon budgets',
  minutes: '40-45 minutes',
  prerequisiteTopicId: 'science.college.university-physics',
  objectives: [
    'Calculate global mean absorbed solar power from irradiance and albedo.',
    'Interpret radiative balance, effective emission temperature and feedbacks.',
    'Distinguish reservoir inventories, gross fluxes and net accumulation.',
    'Evaluate the assumptions and time scales of simple Earth-system models.',
  ],
  introduction:
      'Earth receives sunlight over a disk but exchanges radiation across a sphere. It also exchanges carbon among air, ocean, organisms and rock. Choosing a boundary and tracking inputs, outputs and storage makes both systems quantitatively understandable.',
  sections: [
    scienceSection('Why incoming sunlight is divided by four',
        '''Solar irradiance S is power per area measured on a surface perpendicular to incoming rays near Earth. A planet of radius r intercepts sunlight across area pi r^2 but has total surface area 4 pi r^2. Thus its global mean incoming solar power per area is S/4. This geometric average includes both day and night; it does not imply equal sunlight at every place or time.

Planetary albedo alpha is the fraction of incoming solar power reflected to space. The globally averaged absorbed solar flux is (1 - alpha)S/4. Albedo is dimensionless. With the illustrative values S = 1360 W/m2 and alpha = 0.30, incoming mean is 340 W/m2, reflected mean is 102 W/m2 and absorbed mean is 238 W/m2. These rounded values support the model and are not presented as a current measurement of Earth's imbalance.'''),
    scienceVisual('college_earth_budget',
        'Conservation requires subtracting reflected sunlight before comparing absorbed power with emitted infrared.'),
    scienceSection('Radiative balance and the meaning of temperature',
        '''Define net top-of-atmosphere energy input N = absorbed solar flux - outgoing infrared flux. Positive N increases stored Earth-system energy; negative N decreases it. N = 0 is a radiative balance. A watt is a joule per second, so maintaining N = 2 W/m2 for 100 seconds adds 200 J/m2 in this simple accounting. The temperature response also depends on heat capacity and where energy is stored, especially in the ocean.

For an ideal effective blackbody emitter, outgoing infrared flux is sigma Te^4, where sigma is the Stefan-Boltzmann constant and Te is effective emission temperature in kelvin. At balance, Te = [(1 - alpha)S/(4 sigma)]^(1/4). With sigma about 5.67 x 10^-8 W/(m2 K4), the example absorbed flux gives Te about 255 K. This is an effective emission temperature, not a prediction that the actual surface must be 255 K. Atmospheric absorption and emission of infrared produce a different vertical temperature structure.'''),
    scienceSection('Worked example: a perturbation and its immediate effect',
        '''Hold S = 1360 W/m2 fixed and reduce albedo from 0.30 to 0.25. First find the change in absorbed fraction: 0.75 - 0.70 = 0.05. Multiply by S/4 = 340 W/m2: absorption increases by 17 W/m2, from 238 to 255. If outgoing infrared is initially unchanged at 238, the immediate N becomes +17 W/m2. This is an initial energy imbalance, not an instantaneous final temperature rise.

As the system warms, emission and other processes respond. In the simplest fixed-albedo blackbody model, emitted power rises as temperature to the fourth power, tending to restore balance. If absorbed power increased by a factor of 16, the equilibrium emission temperature would increase by a factor of two because the fourth root of 16 is two. This scaling is a mathematical model exercise, not a plausible near-term Earth scenario.'''),
    scienceSection('Distinguish a forcing from a feedback',
        '''A forcing is an imposed change to the energy budget; a feedback is a response that alters the initial change. Warming can reduce reflective ice cover. If darker surfaces replace it, albedo falls and more sunlight is absorbed, reinforcing warming: this is a positive ice-albedo feedback. Positive means amplifying, not desirable. Cooling can run the same feedback in the opposite direction by expanding reflective ice.

Temperature-dependent infrared emission is a stabilizing response: a warmer emitter loses more energy. Multiple feedbacks can act together, and an amplifying feedback need not produce unlimited change. Increasing greenhouse gas abundance changes infrared absorption and emission; it is not correctly described as merely increasing incoming solar power. A one-layer or blackbody model must be used within its stated assumptions rather than treated as a complete climate model.'''),
    scienceVisual('college_earth_feedback',
        'Trace the sign of each link: warming reduces ice, reduced ice lowers albedo and lower albedo raises absorption.'),
    scienceSection('Carbon: reservoirs are amounts, fluxes are rates',
        '''A carbon reservoir holds an inventory, such as gigatonnes of carbon, GtC. A flux transfers carbon between reservoirs, such as GtC/year. Atmosphere, ocean, living organisms, soil and rocks exchange carbon on different time scales. Photosynthesis transfers atmospheric carbon into organic material; respiration and decomposition return some of it. Air-sea exchange and ocean circulation redistribute carbon without creating it.

For a chosen reservoir, inventory change per time equals total input flux minus total output flux. Large gross exchanges can almost cancel, leaving a small net change. Fossil-fuel combustion transfers carbon from long-stored geological material into active reservoirs. Conservation of carbon does not require the atmospheric inventory to stay constant; carbon can be conserved globally while moving between compartments. GtC and gigatonnes of CO2 are different mass units. Pure CO2 contains 12 units of carbon mass for 44 units of molecular mass, so 1 GtC corresponds to about 3.67 GtCO2.'''),
    scienceVisual('college_earth_carbon',
        'Storage changes with the net flux, even when much larger exchanges occur in both directions.'),
    scienceSection('Guided example: budget and turnover time',
        '''Consider an invented atmospheric budget with total inputs 12 GtC/year and total outputs 5 GtC/year. Net accumulation is 7 GtC/year. If these fluxes stayed constant for three years, the inventory would grow by 21 GtC. If input remained 12 but output grew to 12, the inventory would stabilize; it would not return automatically to its earlier value. To reduce it, output must exceed input over the interval.

A simple steady-state reservoir with inventory M = 100 units and outflow F = 5 units/year has a turnover-time estimate M/F = 20 years. This ratio describes a box model under its assumptions. Atmospheric CO2 exchanges with multiple reservoirs that respond over different time scales, so one turnover time does not describe how long an added CO2 perturbation affects the climate system. Fast exchange of individual molecules and slow removal of an excess inventory are different questions.'''),
    scienceSection('Real-world connection and evidence activity',
        '''Satellite radiation measurements, ocean heat observations and carbon inventories constrain different parts of Earth-system budgets. A short atmospheric temperature fluctuation alone cannot determine whether the whole system is gaining energy: heat can move between atmosphere and ocean. Similarly, a local photosynthesis measurement is not a complete global carbon budget.

On paper, compare two fictional years. Year A has inputs 110 and outputs 108 GtC/year; Year B has inputs 112 and outputs 108. Net additions are 2 and 4. The input rises by only about 1.8%, but net accumulation doubles. Identify which measured flux uncertainties would matter most before claiming that a small difference between two large numbers is exact.'''),
    scienceSection('Common mistakes and quick check',
        '''Do not compare S directly with a globally averaged outgoing flux: first account for geometry and reflection. Do not identify effective emission temperature with surface temperature. Do not confuse a carbon inventory with an annual transfer, a positive feedback with a good outcome, or a balanced flux with an empty reservoir.

Quick check: S = 1200 W/m2 and alpha = 0.20. Find globally averaged absorbed power. If outgoing infrared is 235 W/m2, is the system gaining or losing energy? Separately, a reservoir receives 9 and loses 11 GtC/year: what is its annual change?'''),
    scienceSection('Reveal and recap',
        '''Absorbed power is 0.80 x 1200/4 = 240 W/m2. Net input is 240 - 235 = +5 W/m2, so stored energy increases. The carbon reservoir changes by 9 - 11 = -2 GtC/year, so its inventory decreases. Recap: choose a boundary, use comparable units and averaging, calculate inputs minus outputs, and state which responses a simplified model leaves out.''',
        reveal: true),
  ],
  keyConcept:
      'Earth-system change follows conservation: storage increases when inputs exceed outputs, while geometry, feedbacks and reservoir time scales determine how those budgets respond.',
  questions: [
    [
      'Why is globally averaged incoming solar flux S/4?',
      'The intercepting disk area is one quarter of the sphere area',
      'The Sun emits for only one quarter of each year',
      'Albedo always equals 0.25',
      'Earth has four separate atmospheres',
      'The ratio pi r^2 to 4 pi r^2 is 1/4, spreading intercepted power over the whole surface.',
      'Geometry'
    ],
    [
      'What is planetary albedo?',
      'The fraction of incoming solar power reflected to space',
      'The temperature of the ocean in kelvin',
      'The annual mass of carbon emitted',
      'The ratio of infrared frequency to time',
      'Albedo is a dimensionless reflected fraction, so higher albedo reduces absorption at fixed incoming flux.',
      'Albedo'
    ],
    [
      'Which formula gives global mean absorbed solar flux?',
      '(1 - alpha)S/4',
      'alpha S times 4',
      'S/(1 - alpha) without averaging',
      'S + alpha',
      'Multiply global mean incident flux S/4 by the fraction not reflected, 1 - alpha.',
      'Energy budget'
    ],
    [
      'What does positive net top-of-atmosphere energy input imply?',
      'Earth-system energy storage increases',
      'All locations immediately warm by the same amount',
      'Outgoing energy exceeds absorbed energy',
      'Carbon mass is created',
      'Positive absorbed-minus-emitted power adds stored energy; its temperature distribution depends on the system response.',
      'Storage'
    ],
    [
      'Which unit represents a carbon flux?',
      'GtC/year',
      'GtC alone',
      'Kelvin',
      'Joules without a time interval',
      'A flux is a transfer per time, unlike an inventory measured in carbon mass alone.',
      'Reservoir units'
    ],
    [
      'What makes ice-albedo feedback positive?',
      'It amplifies the initial temperature change',
      'It guarantees a beneficial outcome',
      'It guarantees infinite temperature',
      'It eliminates all outgoing radiation',
      'The loop reinforces warming or cooling; positive refers to amplification, not desirability or infinity.',
      'Feedback'
    ],
    [
      'Which process transfers atmospheric carbon into organic matter?',
      'Photosynthesis',
      'Combustion alone',
      'Respiration alone',
      'Infrared emission alone',
      'Photosynthesis incorporates carbon into organic molecules; respiration and combustion can return it.',
      'Carbon transfers'
    ],
    [
      'S = 1360 W/m2. What is globally averaged incoming flux?',
      '340 W/m2',
      '1360 W/m2',
      '5440 W/m2',
      '680 W/m2',
      'Divide the perpendicular irradiance by four: 1360/4 = 340.',
      'Solar calculation'
    ],
    [
      'For global mean incoming 340 W/m2 and alpha = 0.30, how much is absorbed?',
      '238 W/m2',
      '102 W/m2',
      '442 W/m2',
      '340 W/m2',
      'The absorbed fraction is 0.70, giving 0.70 x 340 = 238 W/m2.',
      'Absorption calculation'
    ],
    [
      'Absorption is 240 W/m2 and emission 238 W/m2. Find net input.',
      '+2 W/m2',
      '-2 W/m2',
      '+478 W/m2',
      'Zero',
      'Subtract outgoing from absorbed incoming power: 240 - 238 = +2.',
      'Imbalance calculation'
    ],
    [
      'A net input of 2 W/m2 lasts 100 s. How much energy per area is added?',
      '200 J/m2',
      '0.02 J/m2',
      '50 J/m2',
      '200 W/m2',
      'Energy equals power times time: 2 J/(s m2) x 100 s = 200 J/m2.',
      'Power and energy'
    ],
    [
      'Inputs are 12 and outputs 5 GtC/year. What is the net annual inventory change?',
      '+7 GtC/year',
      '+17 GtC/year',
      '-7 GtC/year',
      '+60 GtC/year',
      'The reservoir gains inputs minus outputs: 12 - 5 = 7 GtC/year.',
      'Carbon budget'
    ],
    [
      'A constant +7 GtC/year net flux persists for three years. Find added carbon.',
      '21 GtC',
      '7/3 GtC',
      '10 GtC',
      '21 GtC/year',
      'Multiply rate by duration: 7 x 3 = 21 GtC; the accumulated amount no longer has per-year units.',
      'Accumulation'
    ],
    [
      'A steady box holds 100 units and loses 5 units/year. What is M/F?',
      '20 years',
      '500 years',
      '0.05 years',
      '95 years',
      'Inventory divided by outgoing rate gives 100/5 = 20 years in the stated simple model.',
      'Turnover'
    ],
    [
      'Albedo falls from 0.30 to 0.25 at S = 1360 W/m2. What is the immediate absorption increase?',
      '17 W/m2',
      '68 W/m2',
      '5 W/m2',
      '255 W/m2',
      'The absorbed fraction rises by 0.05, so extra absorbed power is 0.05 x 1360/4 = 17 W/m2.',
      'Perturbation'
    ],
    [
      'Why is effective emission temperature not necessarily surface temperature?',
      'Atmospheric infrared absorption and emission create a vertical temperature structure',
      'Kelvin cannot describe surface temperature',
      'Earth emits no infrared radiation',
      'The geometric averaging equation removes the atmosphere physically',
      'The effective temperature represents outgoing radiation; a greenhouse atmosphere alters the relation between that emission and surface temperature.',
      'Model interpretation'
    ],
    [
      'In a fixed-albedo blackbody model, absorbed power increases sixteenfold. How does equilibrium emission temperature scale?',
      'It doubles',
      'It increases sixteenfold',
      'It halves',
      'It increases fourfold',
      'Balance gives T proportional to the fourth root of absorbed power; the fourth root of 16 is 2.',
      'Radiative scaling'
    ],
    [
      'Inputs and outputs become equal after a reservoir has grown. What follows?',
      'The elevated inventory stabilizes while fluxes remain equal',
      'The reservoir instantly returns to its old inventory',
      'The inventory becomes zero',
      'The outgoing flux must cease',
      'Zero net change holds the current inventory steady; removing an excess requires output to exceed input.',
      'Stabilization'
    ],
    [
      'Why cannot one atmospheric turnover time describe removal of an added CO2 perturbation?',
      'Multiple exchanging reservoirs respond on different time scales',
      'Carbon atoms are not conserved',
      'All reservoirs have identical turnover times',
      'Individual molecule exchange and excess-inventory removal are identical',
      'Fast exchange can move molecules without rapidly eliminating the excess across the coupled atmosphere-ocean-land system.',
      'Time scales'
    ],
    [
      'Year A inputs/outputs are 110/108; Year B are 112/108 GtC/year. How does net accumulation change?',
      'It doubles from 2 to 4 GtC/year',
      'It rises from 110 to 112 GtC/year',
      'It stays at 108 GtC/year',
      'It falls from 4 to 2 GtC/year',
      'Subtract gross outputs separately each year: 110 - 108 = 2 and 112 - 108 = 4.',
      'Gross versus net'
    ],
    [
      'S = 1200 W/m2, alpha = 0.20 and outgoing infrared = 235 W/m2. What is net input?',
      '+5 W/m2',
      '-5 W/m2',
      '+65 W/m2',
      '+725 W/m2',
      'Absorbed sunlight is 0.8 x 1200/4 = 240 W/m2; subtract 235 to obtain +5.',
      'Integrated energy budget'
    ],
    [
      'A reservoir receives 9 and loses 11 GtC/year for four years. What inventory change follows?',
      '-8 GtC',
      '+8 GtC',
      '-2 GtC',
      '-80 GtC',
      'The net rate is 9 - 11 = -2 GtC/year. Over four years the inventory falls by 8 GtC.',
      'Integrated carbon budget'
    ],
    [
      'Convert an emission of 3 GtC to CO2 mass using molecular masses 12 for C and 44 for CO2.',
      '11 GtCO2',
      '3 GtCO2',
      '0.82 GtCO2',
      '132 GtCO2',
      'Multiply carbon mass by 44/12: 3 x 44/12 = 11 GtCO2. The added oxygen contributes to molecular mass.',
      'Mass conversion'
    ],
  ],
);

final _physics = scienceTopic(
  grade: 'college',
  order: 3,
  title: 'University Physics',
  subtitle: 'Derive harmonic motion and test it with energy and limiting cases',
  minutes: '40-45 minutes',
  prerequisiteTopicId: 'science.college.general-chemistry',
  objectives: [
    'Derive the acceleration equation for a mass on an ideal spring.',
    'Connect displacement, velocity, acceleration, period and angular frequency.',
    'Calculate mechanical-energy partitions and parameter scaling.',
    'Explain how damping and external driving change the ideal model.',
  ],
  introduction:
      'A suspended instrument, a vibrating molecule and a spring-mounted mass can all oscillate near stable equilibrium. The same mathematical structure connects force, motion and energy. We use a horizontal spring so gravity and the support force cancel vertically and the horizontal dynamics can be examined directly.',
  sections: [
    scienceSection('From force law to differential equation',
        '''Let x measure displacement from equilibrium, positive to the right. An ideal spring obeys F = -kx, where k is stiffness in N/m. The minus sign means the force is restoring: rightward displacement produces leftward force. With mass m, Newton's law gives m d2x/dt2 = -kx, or d2x/dt2 = -(k/m)x. Defining angular frequency omega = sqrt(k/m) gives a = -omega^2 x.

This model assumes a linear spring, negligible spring mass and no damping or external drive. It approximates many systems near stable equilibrium, but not every periodic motion is simple harmonic. At larger deformations a real spring may no longer have constant k. Position determines acceleration in this model, while velocity also depends on where the object is within its cycle.'''),
    scienceSection('Differentiate displacement to predict motion',
        '''A solution is x(t) = A cos(omega t + phi), where amplitude A is nonnegative and phase phi sets the initial state. Differentiating gives v(t) = -A omega sin(omega t + phi). Differentiating again gives a(t) = -A omega^2 cos(omega t + phi), equal to -omega^2 x as required. The maximum speed is A omega, and the maximum acceleration magnitude is A omega^2.

One complete cycle changes the phase by 2 pi radians, so period T = 2 pi/omega = 2 pi sqrt(m/k). Frequency f = 1/T counts cycles per second in hertz, while omega = 2 pi f is in radians per second. They are not numerically interchangeable. Releasing from rest at x = +A at t = 0 gives phi = 0 in this convention.'''),
    scienceVisual('college_physics_cycle',
        'At the two equilibrium crossings position and acceleration match, but the velocities point in opposite directions.'),
    scienceSection('Worked example: calculate one full model',
        '''Let m = 0.50 kg, k = 200 N/m and A = 0.10 m. Compute k/m = 400 per second squared, so omega = 20 rad/s. Then T = 2 pi/20 = about 0.314 s and f = about 3.18 Hz. Maximum speed is A omega = 2.0 m/s. Maximum acceleration magnitude is A omega^2 = 40 m/s2.

At x = +0.050 m, force is -200 x 0.050 = -10 N and acceleration is -10/0.50 = -20 m/s2. The sign indicates leftward acceleration. The object might be moving right and slowing down, or moving left and speeding up. Position alone does not tell which: the initial conditions and elapsed time are also needed.'''),
    scienceSection('Energy provides an independent check',
        '''An ideal spring stores elastic potential energy U = kx^2/2. Kinetic energy is K = mv^2/2. With no damping or driving, E = K + U is constant and equals kA^2/2 because velocity is zero at a turning point. At equilibrium U = 0 and speed is largest. At x = A/2, U/E = x^2/A^2 = 1/4, so K/E = 3/4, not one half.

For the worked model E = 200 x 0.10^2/2 = 1 J. At x = 0.050 m, U = 0.25 J and K = 0.75 J. Solve v magnitude = sqrt(2K/m) = sqrt(3) = about 1.73 m/s. This determines speed but leaves two possible velocity signs. Energy cannot by itself tell the direction of travel.'''),
    scienceVisual('college_physics_energy',
        'At half the amplitude, only one quarter of the total energy is stored in the spring; displacement and energy are not proportional.'),
    scienceSection('Guided example: change a parameter before calculating',
        '''Suppose the mass is quadrupled while k and A stay fixed. Since omega = sqrt(k/m), omega halves; T doubles and maximum speed halves. Total energy kA^2/2 stays fixed because neither k nor A changed. If instead stiffness is quadrupled with mass and amplitude fixed, omega doubles, T halves and total energy quadruples.

Now double only amplitude within the linear regime. Period is unchanged, maximum speed doubles and total energy quadruples. The amplitude-independent period is a prediction of the ideal linear model, not a universal property of oscillators. Measuring period at several amplitudes is one way to test whether that approximation remains suitable.'''),
    scienceSection('Damping transfers energy; driving supplies it',
        '''A common damping model adds a force -b v, opposite velocity. The equation becomes m d2x/dt2 + b dx/dt + kx = 0. For weak enough damping the mass still oscillates while its amplitude decays. Mechanical energy leaves the oscillator through processes such as heating of the surroundings. Total energy is conserved when those surroundings are included; oscillator mechanical energy alone is not.

External periodic driving adds an applied force that can supply work. The long-term amplitude depends on driving frequency, damping and force magnitude. Resonance is a large response near a characteristic frequency; damping limits that response and can shift the frequency of its maximum. In steady driven motion, average energy input can balance dissipation. It is incorrect to assume every real resonant system acquires infinite amplitude.'''),
    scienceVisual('college_physics_damping',
        'Before applying conservation of oscillator mechanical energy, check whether energy crosses the chosen system boundary.'),
    scienceSection('Real-world connection and model-testing activity',
        '''Vibration isolation and measuring instruments depend on both stiffness and damping. A very stiff mount raises the natural frequency; damping reduces persistent motion after a disturbance. A successful design therefore needs a frequency-dependent response, not just a rule that stiffer is always better.

Use fictional measurements rather than a hazardous apparatus: a mass-spring system completes 10 cycles in 4.0 s. The measured T is 0.40 s and f is 2.5 Hz. If the mass is quadrupled with the same spring, predict 10 cycles in 8.0 s. Explain a disagreement by checking damping, effective moving mass, spring linearity and timing uncertainty before rejecting Newton's law. Repeated timing of several cycles reduces the relative influence of a single start-stop timing error.'''),
    scienceSection('Common mistakes and quick check',
        '''Zero velocity at a turning point does not mean zero acceleration: the restoring force is largest there. Zero acceleration at equilibrium does not mean the object stops. Do not use omega as cycles per second or replace x^2 with x in elastic energy. Keep displacement signs separate from nonnegative speed and energy.

Quick check: m = 2 kg, k = 8 N/m, A = 0.50 m. Find omega, maximum speed and total energy. At x = 0, identify acceleration and whether speed is minimal or maximal.'''),
    scienceSection('Reveal and recap',
        '''Omega = sqrt(8/2) = 2 rad/s; maximum speed = 0.50 x 2 = 1 m/s; energy = 8 x 0.50^2/2 = 1 J. At equilibrium acceleration is zero and speed is maximal. Recap: derive a restoring acceleration, differentiate the position model, check results with energy, state initial conditions for direction and revise the energy balance when damping or driving is present.''',
        reveal: true),
  ],
  keyConcept:
      'Linear restoring force produces harmonic acceleration; derivatives and energy conservation give complementary predictions, while damping and driving determine energy exchange.',
  questions: [
    [
      'For x > 0 in F = -kx with k > 0, which way does the spring force point?',
      'Toward negative x',
      'Toward positive x',
      'Perpendicular to x only',
      'It must be zero',
      'The negative sign makes the force point toward equilibrium, opposite the positive displacement.',
      'Restoring force'
    ],
    [
      'Which equation characterizes ideal simple harmonic acceleration?',
      'a = -omega^2 x',
      'a = +omega x',
      'a = zero everywhere',
      'a = -x/omega^2',
      'Combining F = -kx with F = ma gives a = -(k/m)x = -omega^2 x.',
      'Dynamics'
    ],
    [
      'What is angular frequency for an ideal mass-spring system?',
      'sqrt(k/m)',
      'sqrt(m/k)',
      'k/m without a square root',
      '2 pi times the amplitude',
      'The equation of motion identifies omega squared with k/m.',
      'Angular frequency'
    ],
    [
      'What is the relation between frequency f and period T?',
      'f = 1/T',
      'f = T',
      'f = T^2',
      'f = 2 pi T',
      'Frequency counts cycles per second; period is seconds per cycle, so they are reciprocals.',
      'Period'
    ],
    [
      'At an ideal oscillator turning point, which statement is true?',
      'Speed is zero and acceleration magnitude is maximal',
      'Speed and acceleration are both zero',
      'Speed is maximal and acceleration is zero',
      'Kinetic energy is maximal',
      'Displacement magnitude equals A, so restoring force is largest even as velocity reverses through zero.',
      'Phase'
    ],
    [
      'What is the spring potential energy at displacement x?',
      'kx^2/2',
      'kx/2',
      'mv/2',
      'k/x^2',
      'Elastic energy is quadratic in extension or compression, obtained from work against the linear force.',
      'Energy'
    ],
    [
      'Which assumption belongs to the ideal undamped model?',
      'Linear restoring force with negligible damping',
      'Constant nonzero friction is essential',
      'Stiffness increases every cycle',
      'Energy is supplied each cycle by an external drive',
      'The simple free harmonic model uses constant k and excludes damping and driving.',
      'Model assumptions'
    ],
    [
      'm = 0.50 kg and k = 200 N/m. Find omega.',
      '20 rad/s',
      '400 rad/s',
      '0.05 rad/s',
      '100 rad/s',
      'omega = sqrt(200/0.50) = sqrt(400) = 20 rad/s.',
      'Frequency calculation'
    ],
    [
      'If omega = 20 rad/s, approximately what is T?',
      '0.314 s',
      '20 s',
      '3.18 s',
      '125.7 s',
      'T = 2 pi/omega = 2 pi/20, approximately 0.314 s.',
      'Period calculation'
    ],
    [
      'A = 0.10 m and omega = 20 rad/s. What is maximum speed?',
      '2.0 m/s',
      '0.005 m/s',
      '40 m/s',
      '200 m/s',
      'Maximum speed is A omega = 0.10 x 20 = 2.0 m/s.',
      'Velocity calculation'
    ],
    [
      'For k = 200 N/m and x = +0.050 m, what is force?',
      '-10 N',
      '+10 N',
      '-1000 N',
      '+4 N',
      'F = -kx = -200 x 0.050 = -10 N, directed toward negative x.',
      'Force calculation'
    ],
    [
      'For k = 200 N/m and A = 0.10 m, find total ideal energy.',
      '1 J',
      '10 J',
      '2 J',
      '0.01 J',
      'E = kA^2/2 = 200 x 0.01/2 = 1 J. At a turning point all of this mechanical energy is stored in the spring.',
      'Energy calculation'
    ],
    [
      'At x = A/2, what fraction of total ideal energy is elastic?',
      'One quarter',
      'One half',
      'Three quarters',
      'All of it',
      'U/E = x^2/A^2 = (1/2)^2 = 1/4. The remaining three quarters is kinetic energy, because total energy is conserved.',
      'Energy partition'
    ],
    [
      'A system makes 10 cycles in 4.0 s. What is its frequency?',
      '2.5 Hz',
      '0.40 Hz',
      '40 Hz',
      '10 Hz',
      'Frequency is cycles divided by time: 10/4.0 = 2.5 Hz.',
      'Timing'
    ],
    [
      'Quadruple mass while holding k and A fixed. What happens to period?',
      'It doubles',
      'It quadruples',
      'It halves',
      'It stays unchanged',
      'T is proportional to sqrt(m), so multiplying mass by four multiplies period by two.',
      'Scaling'
    ],
    [
      'Double amplitude at fixed m and k in the linear regime. What happens to energy and period?',
      'Energy quadruples; period is unchanged',
      'Energy doubles; period doubles',
      'Energy is unchanged; period halves',
      'Energy halves; period quadruples',
      'E depends on A squared, while T = 2 pi sqrt(m/k) contains no amplitude.',
      'Amplitude scaling'
    ],
    [
      'At x = 0, the ideal oscillator has which acceleration and speed?',
      'Zero acceleration and maximum speed',
      'Maximum acceleration and zero speed',
      'Zero acceleration and zero speed throughout',
      'Positive acceleration and minimum speed',
      'The spring force vanishes at equilibrium while all mechanical energy is kinetic.',
      'State interpretation'
    ],
    [
      'At a given nonzero x, why can there be two possible velocities?',
      'The oscillator can pass that position in opposite directions',
      'The spring stiffness is necessarily negative',
      'Energy is not conserved even ideally',
      'Position always determines a unique velocity sign',
      'Energy fixes speed magnitude; the same position can occur on the outward and return parts of the cycle.',
      'Initial conditions'
    ],
    [
      'What happens to mechanical energy in a freely damped oscillator?',
      'It transfers to the surroundings',
      'It remains fixed while amplitude decays',
      'It becomes negative mass',
      'It disappears from the universe',
      'Damping performs negative work on the oscillator; energy conservation includes energy delivered to the environment.',
      'Damping'
    ],
    [
      'Why is infinite steady amplitude not a general prediction for real resonance?',
      'Finite damping removes energy and limits the response',
      'Driving forces never transfer energy',
      'All real springs have zero stiffness',
      'Resonance requires zero motion',
      'Dissipation can balance average input from a periodic drive, giving finite amplitude.',
      'Driven systems'
    ],
    [
      'm = 2 kg, k = 8 N/m and A = 0.50 m. Which set is correct?',
      'omega = 2 rad/s; maximum speed = 1 m/s; E = 1 J',
      'omega = 4 rad/s; maximum speed = 2 m/s; E = 2 J',
      'omega = 0.5 rad/s; maximum speed = 0.25 m/s; E = 1 J',
      'omega = 2 rad/s; maximum speed = 1 m/s; E = 4 J',
      'sqrt(8/2) = 2; A omega = 1; kA^2/2 = 8 x 0.25/2 = 1.',
      'Integrated dynamics'
    ],
    [
      'Total energy is 1 J and m = 0.50 kg. At x = A/2, approximately what is speed?',
      '1.73 m/s',
      '2.00 m/s',
      '1.00 m/s',
      '0.50 m/s',
      'U is one quarter of E, leaving K = 0.75 J; speed = sqrt(2 x 0.75/0.50) = sqrt(3), about 1.73.',
      'Energy reasoning'
    ],
    [
      'Quadruple k with m and A unchanged. Which combination follows in the ideal model?',
      'Period halves and energy quadruples',
      'Period doubles and energy halves',
      'Period is unchanged and energy doubles',
      'Period quarters and energy stays fixed',
      'T is proportional to 1/sqrt(k), while E = kA^2/2 is proportional to k at fixed amplitude.',
      'Combined scaling'
    ],
  ],
);

final _chemistry = scienceTopic(
  grade: 'college',
  order: 2,
  title: 'General Chemistry',
  subtitle: 'Connect enthalpy, entropy, composition and chemical equilibrium',
  minutes: '40-45 minutes',
  prerequisiteTopicId: 'science.college.general-biology',
  objectives: [
    'Calculate Gibbs free-energy changes with consistent temperature and energy units.',
    'Predict temperature dependence from the signs of enthalpy and entropy changes.',
    'Use reaction quotients and equilibrium constants to determine reaction direction.',
    'Distinguish thermodynamic favorability, equilibrium extent and kinetic speed.',
  ],
  introduction:
      'A reaction can release heat yet fail to favor products under some conditions. Conversely, a process that absorbs heat can be favorable. The missing pieces are entropy, temperature and composition. This module develops the energy argument behind the equilibrium rules studied in Grade 12.',
  sections: [
    scienceSection('Choose the system and state the conditions',
        '''Enthalpy H describes an energy state useful for constant-pressure processes. A negative reaction enthalpy Delta H means the system releases heat under the usual constant-pressure, pressure-volume-work conditions. Entropy S describes the distribution of energy among accessible microscopic arrangements. It is a state function, not a synonym for visible untidiness. A process can decrease system entropy while increasing total entropy of system plus surroundings.

At fixed temperature and pressure, Gibbs energy combines these effects: Delta G = Delta H - T Delta S. A negative reaction Delta G favors forward change at the specified composition; zero indicates equilibrium; positive favors reverse change. Use absolute temperature in kelvin. The criterion is thermodynamic: it supplies neither a reaction time nor a detailed mechanism.'''),
    scienceSection('Worked example: units determine the answer',
        '''For an illustrative process, Delta H = +30 kJ/mol and Delta S = +100 J/(mol K). Convert entropy to +0.100 kJ/(mol K) before combining it with enthalpy. At 250 K, T Delta S = 25 kJ/mol, so Delta G = 30 - 25 = +5 kJ/mol. Forward change is unfavorable at the stated conditions. At 350 K, Delta G = 30 - 35 = -5 kJ/mol, so forward change is favorable.

Solving 0 = Delta H - T Delta S gives a crossover at T = 30/0.100 = 300 K. This calculation treats Delta H and Delta S as approximately constant over this temperature range. Real substances can change heat capacity or phase, so extending that approximation arbitrarily far is unjustified.'''),
    scienceVisual('college_chemistry_temperature',
        'The increasing T Delta S term eventually outweighs a positive enthalpy change in this model.'),
    scienceSection('Read the signs before calculating',
        '''If Delta H is negative and Delta S positive, both terms favor negative Delta G at positive temperatures. If Delta H is positive and Delta S negative, both oppose it. If both are positive, sufficiently high temperature can make the entropy term dominate. If both are negative, low temperature can favor the enthalpy contribution while high temperature can make the entropy penalty dominate. Apply these sign rules within a range where the supplied quantities describe the same process.

For Delta H = -40 kJ/mol and Delta S = -0.100 kJ/(mol K), Delta G at 300 K is -40 - (300 x -0.100) = -10 kJ/mol. At 500 K it is +10 kJ/mol in the constant-parameter model. Carefully retain the minus sign before T Delta S; subtracting a negative entropy contribution adds a positive term.'''),
    scienceSection('Standard change and actual change are different',
        '''Delta G standard, written Delta G degree, refers to specified standard states. It does not automatically equal the reaction free-energy change in an arbitrary mixture. Actual composition enters through Delta G = Delta G degree + RT ln Q. Here R = 8.314 J/(mol K), T is kelvin, ln is the natural logarithm and Q is a dimensionless reaction quotient based on activities relative to standard states.

For A reversibly forming 2 B, Q = a(B)^2/a(A). In a dilute ideal solution, a solute activity is approximated by its concentration divided by the standard concentration, 1 mol/L. Pure solids and pure liquids have approximately unit activity in the usual model and do not appear as variable concentration factors. Gas activities are related to partial pressures relative to standard pressure. The balanced coefficients become exponents; changing the written reaction changes its Q and K.'''),
    scienceSection('Equilibrium links K to energy',
        '''At equilibrium Q = K and Delta G = 0. Substitution gives Delta G degree = -RT ln K. Combining the two equations gives Delta G = RT ln(Q/K). Thus Q below K gives a negative logarithm and favors forward change. Q above K favors reverse change. A large K indicates a product-favored equilibrium ratio for the written reaction, not necessarily complete conversion for every starting mixture.

Reversing a reaction changes K to 1/K and changes the sign of Delta G degree. Doubling every stoichiometric coefficient squares K and doubles Delta G degree. These transformations follow because reaction free energies add and logarithms turn multiplication into addition. A catalyst changes neither K nor Delta G degree at the same temperature.'''),
    scienceVisual('college_chemistry_direction',
        'The relevant comparison is Q/K; even a negative standard change does not guarantee forward change in every mixture.'),
    scienceSection('Guided calculation: compare a mixture with equilibrium',
        '''At 300 K a reaction has K = 10 and the current Q = 1. Use Delta G = RT ln(Q/K). With ln(0.1) = -2.303, the result is 8.314 x 300 x (-2.303) = about -5744 J/mol, or -5.74 kJ/mol. Forward change is favored. If Q becomes 100 at the same temperature, Q/K = 10 and the result becomes +5.74 kJ/mol, favoring reverse change.

Now take A reversibly forming 2 B with ideal activities a(A) = 0.50 and a(B) = 0.20. Square the product activity: Q = 0.20^2/0.50 = 0.08. If K = 0.20, Q is smaller than K; the mixture changes forward. Do not subtract Q from K as an energy: they are dimensionless ratios, while Delta G carries energy per reaction amount.'''),
    scienceSection('Real-world connection: favorable does not mean fast',
        '''Fuel oxidation can have a favorable free-energy change but still require initiation because an activation barrier limits its rate. Catalysts can enable useful rates without changing the equilibrium destination. Process design therefore asks separate questions: Is the desired direction favorable at the operating composition? What equilibrium mixture is possible? How quickly can it be approached?

For a paper activity, classify four fictional processes using the four sign combinations of Delta H and Delta S. Then calculate Delta G for +24 kJ/mol and +0.080 kJ/(mol K) at 200, 300 and 400 K. The answers are +8, 0 and -8 kJ/mol. Annotate the temperature range assumption and explain why these results alone do not specify a safe operating rate or reaction mechanism.'''),
    scienceVisual('college_chemistry_path',
        'Direction, extent and speed are related engineering questions but require different evidence.'),
    scienceSection('Common mistakes and quick check',
        '''Do not put Celsius into T Delta S or RT. Do not mix joules with kilojoules. Do not replace actual Delta G with Delta G degree unless Q = 1. A negative Delta G is not a guarantee that all reactant disappears: composition changes until equilibrium is reached if the system can equilibrate.

Quick check: Delta H = -20 kJ/mol, Delta S = -50 J/(mol K), T = 300 K. What is Delta G? Separately, if Q = K, what is the actual reaction Delta G regardless of the value of K?'''),
    scienceSection('Reveal and recap',
        '''Convert -50 J to -0.050 kJ: Delta G = -20 - (300 x -0.050) = -5 kJ/mol. At Q = K the reaction Delta G is zero because ln(Q/K) = ln 1 = 0. Recap: establish conditions, use compatible units, distinguish standard from actual changes, construct Q from the balanced reaction and keep kinetic speed separate from thermodynamic direction.''',
        reveal: true),
  ],
  keyConcept:
      'At fixed temperature and pressure, reaction direction follows actual Delta G = RT ln(Q/K); standard energy, composition and kinetic barriers must be interpreted separately.',
  questions: [
    [
      'At fixed temperature and pressure, which actual Delta G favors forward reaction?',
      'A negative value',
      'A positive value',
      'Only an infinite value',
      'Only a value equal to the activation barrier',
      'Negative actual reaction Gibbs energy means forward change reduces Gibbs energy under the specified conditions.',
      'Direction'
    ],
    [
      'Which temperature scale is required in Delta G = Delta H - T Delta S?',
      'Kelvin',
      'Celsius without conversion',
      'Fahrenheit without conversion',
      'Any scale with the same numerical value',
      'The formula requires absolute temperature, measured in kelvin.',
      'Units'
    ],
    [
      'Which statement describes entropy appropriately?',
      'A state function related to accessible microscopic arrangements',
      'The activation barrier of every reaction',
      'Only visible clutter in a container',
      'The rate at which reactants collide',
      'Entropy concerns microscopic energy distribution and states; visible disorder is an unreliable substitute.',
      'Entropy'
    ],
    [
      'What is actual Delta G at equilibrium?',
      'Zero',
      'Always equal to -1 kJ/mol',
      'Always equal to Delta H',
      'Always infinitely negative',
      'At equilibrium Q = K, so RT ln(Q/K) = RT ln 1 = 0.',
      'Equilibrium'
    ],
    [
      'For A reversibly forming 2 B, what is Q?',
      'a(B)^2/a(A)',
      'a(B)/a(A)^2',
      'a(A)/a(B)^2',
      '2a(B) - a(A)',
      'Activities are multiplied and raised to balanced stoichiometric coefficients, products over reactants.',
      'Reaction quotient'
    ],
    [
      'What does an ideal catalyst change at fixed temperature?',
      'The kinetic pathway and rates',
      'The equilibrium constant for the same reaction',
      'The reaction standard free-energy difference',
      'The stoichiometric conservation of atoms',
      'A catalyst lowers kinetic barriers without altering the thermodynamic end-state difference or K.',
      'Kinetics'
    ],
    [
      'What does a negative Delta H describe under the stated constant-pressure conditions?',
      'Heat released by the system',
      'Guaranteed fast conversion',
      'A negative absolute temperature',
      'Guaranteed positive entropy change',
      'An exothermic process has negative enthalpy change; rate and entropy require separate information.',
      'Enthalpy'
    ],
    [
      'Convert +100 J/(mol K) to kJ/(mol K).',
      '+0.100 kJ/(mol K)',
      '+100000 kJ/(mol K)',
      '+10 kJ/(mol K)',
      '+1 kJ/(mol K)',
      'There are 1000 J in 1 kJ, so divide 100 by 1000.',
      'Unit conversion'
    ],
    [
      'Delta H = +30 kJ/mol and Delta S = +0.100 kJ/(mol K). Find Delta G at 250 K.',
      '+5 kJ/mol',
      '-5 kJ/mol',
      '+55 kJ/mol',
      '-25 kJ/mol',
      'Delta G = 30 - 250 x 0.100 = 5 kJ/mol. The positive result means forward change is unfavorable at these stated conditions.',
      'Energy calculation'
    ],
    [
      'For constant Delta H = +30 kJ/mol and Delta S = +0.100 kJ/(mol K), at what temperature does Delta G change sign?',
      '300 K',
      '3 K',
      '3000 K',
      '30 K',
      'Set Delta G to zero: T = Delta H/Delta S = 30/0.100 = 300 K.',
      'Temperature dependence'
    ],
    [
      'With Delta H < 0 and Delta S > 0, what sign does Delta G have at positive T in the model?',
      'Negative',
      'Positive',
      'Always zero',
      'Undefined solely because T is positive',
      'Both the negative enthalpy and the subtraction of positive T Delta S make Delta G negative.',
      'Sign reasoning'
    ],
    [
      'If Q = 0.05 and K = 0.20, which net direction is favored?',
      'Forward',
      'Reverse',
      'Neither because Q equals K',
      'Impossible to tell without reaction speed',
      'Q/K = 0.25, whose natural logarithm is negative; forward change is favored regardless of how fast it occurs.',
      'Quotient comparison'
    ],
    [
      'If K = 25 for a reaction, what is K for its reverse?',
      '0.04',
      '25',
      '50',
      '625',
      'Reversing swaps the numerator and denominator in the equilibrium quotient, giving 1/25 = 0.04.',
      'Reaction reversal'
    ],
    [
      'If K = 3, what is K after doubling every reaction coefficient?',
      '9',
      '6',
      '1.5',
      '1/3',
      'Every activity exponent doubles, so the new constant is K squared: 3^2 = 9.',
      'Reaction scaling'
    ],
    [
      'At 300 K, K = 10 and Q = 1. Use R = 8.314 and ln(0.1) = -2.303. Find Delta G.',
      'About -5.74 kJ/mol',
      'About +5.74 kJ/mol',
      'About -5744 kJ/mol',
      'Exactly zero',
      'RT ln(Q/K) = -5744 J/mol approximately; converting joules to kilojoules gives -5.74.',
      'Quotient energy'
    ],
    [
      'For A forming 2 B, a(A) = 0.50 and a(B) = 0.20. What is Q?',
      '0.08',
      '0.40',
      '1.25',
      '0.02',
      'Square the B activity before dividing: 0.20^2/0.50 = 0.04/0.50 = 0.08.',
      'Activity calculation'
    ],
    [
      'A reaction has negative Delta G degree but Q is greater than K. What follows?',
      'Actual Delta G is positive and reverse change is favored',
      'Forward change must still be favored',
      'K must be zero',
      'The standard free-energy formula is invalid',
      'Standard favorability does not fix every mixture; Q/K greater than one gives positive actual Delta G.',
      'Standard versus actual'
    ],
    [
      'When does actual Delta G equal Delta G degree?',
      'When Q = 1',
      'Whenever K = 1 regardless of Q',
      'Whenever a catalyst is present',
      'Whenever all concentrations are zero',
      'RT ln Q vanishes at Q = 1, so the actual and standard quantities coincide.',
      'Standard states'
    ],
    [
      'Why can extrapolating a constant Delta H and Delta S model too far fail?',
      'Heat capacities or phases may change over the range',
      'Kelvin temperatures are always negative',
      'Entropy has no physical units',
      'Gibbs energy cannot depend on temperature',
      'The supplied quantities can vary with temperature and phase; the fixed-parameter approximation has a limited range.',
      'Model limits'
    ],
    [
      'A reaction is strongly product-favored but slow. Which intervention can speed equilibration without changing K?',
      'Add an appropriate catalyst at the same temperature',
      'Redefine the standard state as product only',
      'Multiply K by reaction time',
      'Assume negative Delta G eliminates barriers',
      'A catalyst changes kinetic pathways while preserving K for the same reaction and temperature.',
      'Process reasoning'
    ],
    [
      'Delta H = -20 kJ/mol and Delta S = -50 J/(mol K). Find Delta G at 300 K.',
      '-5 kJ/mol',
      '-35 kJ/mol',
      '+5 kJ/mol',
      '+14980 kJ/mol',
      'Convert entropy to -0.050 kJ/(mol K), then compute -20 - 300(-0.050) = -5.',
      'Integrated units'
    ],
    [
      'K = 4 for A forming B. Reverse the reaction and double its coefficients. What is the new K?',
      '1/16',
      '8',
      '16',
      '1/8',
      'Reverse gives 1/4. Doubling the reversed coefficients squares that number: (1/4)^2 = 1/16.',
      'Combined transformations'
    ],
    [
      'At 300 K Q/K = 10. With ln 10 = 2.303 and R = 8.314 J/(mol K), which conclusion is correct?',
      'Delta G is about +5.74 kJ/mol; reverse is favored, but speed is unspecified',
      'Delta G is about -5.74 kJ/mol; forward is instantaneous',
      'Delta G is zero because temperature is fixed',
      'Delta G is +5744 kJ/mol and K must change',
      'RT ln 10 is about +5744 J/mol = +5.74 kJ/mol. Its sign sets direction; it supplies no kinetic rate.',
      'Thermodynamic inference'
    ],
  ],
);

final _biology = scienceTopic(
  grade: 'college',
  order: 1,
  title: 'General Biology',
  subtitle:
      'Explain metabolic regulation using enzyme kinetics and energy coupling',
  minutes: '40-45 minutes',
  prerequisiteTopicId: null,
  objectives: [
    'Relate enzyme catalysis to activation barriers without changing equilibrium.',
    'Calculate initial rates from a Michaelis-Menten model and state its assumptions.',
    'Distinguish competitive inhibition from changes in enzyme concentration.',
    'Evaluate coupled reactions and the limits of evidence from an enzyme assay.',
  ],
  introduction:
      'Why does doubling a nutrient concentration sometimes produce almost no increase in a cell reaction? Enzymes have finite catalytic capacity. This module connects molecular binding, measurable rates and metabolic control; it builds on cell structure and gene expression.',
  sections: [
    scienceSection('Catalysis controls speed, not the equilibrium destination',
        '''An enzyme supplies a reaction pathway with a lower activation free-energy barrier. Its active site positions reactants and stabilizes transition-state interactions. The enzyme participates in the mechanism but is regenerated, so one enzyme molecule can complete many catalytic cycles. Substrate specificity reflects molecular recognition, not a claim that an enzyme is a rigid lock.

An enzyme does not change the free-energy difference between the initial and final states or the equilibrium constant. It speeds approach to equilibrium in both directions. A favorable reaction may still be extremely slow without a suitable pathway. In a living cell, concentrations change because products are removed and substrates supplied: a metabolic steady state is not necessarily thermodynamic equilibrium.'''),
    scienceSection('Build a measurable initial-rate model',
        '''In the minimal mechanism E + S reversibly forms ES, which can release E + product. Measure the initial product-formation rate v before substrate depletion or product accumulation materially changes the conditions. For a simple Michaelis-Menten enzyme, v = Vmax[S]/(Km + [S]). Vmax is the limiting rate at substrate saturation; Km is the substrate concentration giving half that rate. Km and [S] must share concentration units, while v and Vmax share rate units.

The usual model assumes a roughly steady ES concentration during measurement, substrate greatly exceeding enzyme, and negligible reverse reaction from product initially. Cooperative enzymes can have different responses. Km is a kinetic parameter combining binding and catalytic steps; it is not universally a direct dissociation constant. Compare parameter estimates only under specified temperature, pH and assay conditions.'''),
    scienceVisual('college_biology_rates',
        'The rise from 2 to 6 mmol/L is threefold in substrate but only 1.5-fold in rate: saturation matters.'),
    scienceSection('Worked example: evaluate the rate and its units',
        '''Take Vmax = 90 micromol/min, Km = 2 mmol/L and [S] = 6 mmol/L. First form the dimensionless fraction 6/(2 + 6) = 0.75. Multiplying gives v = 67.5 micromol/min. This is a rate of product amount for the specified assay, not a substrate concentration. At [S] = 2 mmol/L the fraction is one half, giving 45 micromol/min.

At [S] much smaller than Km, the denominator is approximately Km, so rate is approximately proportional to [S]. At [S] much greater than Km, the fraction approaches one and further substrate has little effect. Vmax is approached asymptotically in this model; a finite [S] does not make the fraction exactly one.'''),
    scienceSection('Perturb the system: inhibitor or enzyme amount?',
        '''In ideal reversible competitive inhibition, substrate and inhibitor binding are mutually exclusive. At a fixed inhibitor concentration the apparent Km rises, while Vmax stays unchanged: sufficiently high substrate can approach the original limiting rate. Suppose the apparent Km becomes 6 mmol/L with Vmax still 90. At [S] = 6, rate is now 90 x 6/(6 + 6) = 45 micromol/min.

Doubling active enzyme concentration instead doubles Vmax when substrate is maintained and other conditions are identical; it does not change Km for this model. If Vmax becomes 180 while Km stays 2, at [S] = 6 the rate becomes 135 micromol/min. A single low rate cannot establish inhibition type. Measure multiple substrate concentrations with controls before comparing kinetic models.'''),
    scienceVisual('college_biology_inhibition',
        'Compare the limiting capacity and half-saturation concentration separately; a slower single measurement is insufficient.'),
    scienceSection('Guided example: infer, then test',
        '''A control enzyme has Vmax = 80 micromol/min and Km = 4 mmol/L. Predict its rate at [S] = 4: the substrate equals Km, so the rate is 40 micromol/min. A treated sample has the same limiting rate but reaches half of it at [S] = 12. These observations are consistent with increased apparent Km, as in competitive inhibition. They do not identify a binding site or prove a unique molecular mechanism.

To investigate, collect initial-rate measurements over a range below and above each apparent Km, with equal enzyme amounts, matched solvent controls and stable pH and temperature. Include a no-enzyme blank to detect background product signal. Independent enzyme preparations test reproducibility; repeated instrument readings of one mixture mainly estimate measurement precision.'''),
    scienceSection('Couple transformations through a mechanism',
        '''Free-energy changes for linked reaction steps add when their equations are added with matching stoichiometry. An unfavorable step with Delta G = +12 kJ/mol can be driven by a mechanistically coupled step with Delta G = -30 kJ/mol: the net change is -18 kJ/mol under those conditions. Cells can couple ATP-dependent transformations through shared intermediates or molecular machines. Simply mixing two unrelated reactions does not transfer usable energy between them.

ATP is continually regenerated by metabolism; it is not created by an enzyme. Cellular ATP hydrolysis free energy depends on concentrations and conditions. The -30 kJ/mol value here is a supplied exercise value, not a universal cellular constant. A negative net Delta G indicates a favorable direction, not how fast the linked process runs.'''),
    scienceVisual('college_biology_coupling',
        'Energy accounting establishes whether a linked route is favorable; the coupling mechanism still has to exist.'),
    scienceSection('Real-world connection and evidence activity',
        '''Biotechnology uses enzyme assays to choose substrate concentrations and compare reaction conditions. At nearly saturated substrate, extra substrate may be expensive with little gain, while additional active enzyme can raise throughput. In a whole cell, transport and other pathway steps may become limiting, so a purified-enzyme result is not automatically a prediction of organism growth.

On paper, calculate rates for Vmax = 100 and Km = 5 at [S] = 1, 5 and 20 in matching concentration units: about 16.7, 50 and 80 in the supplied rate units. Plot concentration horizontally and rate vertically. Explain why the curve bends toward a limit. Then predict the effect of doubling enzyme at maintained substrate: each calculated initial rate doubles under this model.'''),
    scienceSection('Common mistakes and quick check',
        '''Do not label Km as a rate or equate it unconditionally with binding affinity. Do not infer that enzymes change equilibrium because they increase product formation early in an assay. Do not assume a purified assay includes membrane transport, gene regulation or allosteric control in a cell.

Quick check: Vmax = 120 micromol/min, Km = 3 mmol/L and [S] = 9 mmol/L. Find v. If a competitive inhibitor raises apparent Km to 9, what is the new rate at the same substrate concentration?'''),
    scienceSection('Reveal and recap',
        '''The control rate is 120 x 9/(3 + 9) = 90 micromol/min. The inhibited rate is 120 x 9/(9 + 9) = 60 micromol/min. Both still approach the same Vmax as substrate becomes very large. Recap: distinguish rate from thermodynamic direction, track units and assumptions, measure enough concentrations to test a model, and require a physical mechanism for energy coupling.''',
        reveal: true),
  ],
  keyConcept:
      'Enzyme kinetics describes rates under specified conditions; catalytic capacity, substrate response and thermodynamic driving force are distinct quantities.',
  questions: [
    [
      'What does an enzyme lower?',
      'The activation barrier of a reaction pathway',
      'The equilibrium constant',
      'The amount of matter conserved',
      'The free-energy difference between fixed end states',
      'Catalysis offers a lower-barrier pathway while leaving the free-energy difference of the same initial and final states unchanged.',
      'Catalysis'
    ],
    [
      'In the stated Michaelis-Menten model, what does Km measure?',
      'Substrate concentration at half Vmax',
      'Product amount per second at saturation',
      'The equilibrium ratio of products to reactants',
      'The number of active enzyme molecules',
      'Substituting [S] = Km gives v = Vmax/2; Km therefore has concentration units.',
      'Kinetics'
    ],
    [
      'Why measure initial reaction rates?',
      'To minimize substrate depletion and product accumulation effects',
      'To ensure every substrate molecule is consumed',
      'To force the mixture to equilibrium first',
      'To eliminate the need to control temperature',
      'Early measurements approximate the supplied substrate concentration and avoid substantial reverse reaction from accumulated product.',
      'Assay design'
    ],
    [
      'Which units can describe Vmax in an amount-based assay?',
      'Micromol per minute',
      'Millimol per liter',
      'Kilojoules per mole',
      'Seconds per liter',
      'Vmax is a reaction rate, so an amount of product per time is appropriate for this assay.',
      'Units'
    ],
    [
      'Under ideal reversible competitive inhibition, what changes?',
      'Apparent Km rises while Vmax stays fixed',
      'Km falls while Vmax doubles',
      'Both Km and Vmax must vanish',
      'The equilibrium constant rises',
      'Mutually exclusive binding requires more substrate for a given fraction of the same limiting rate.',
      'Inhibition'
    ],
    [
      'Doubling active enzyme at maintained substrate changes which parameter?',
      'Vmax doubles',
      'Km necessarily doubles',
      'Equilibrium constant doubles',
      'Substrate concentration must double',
      'Twice as many active catalytic sites provide twice the limiting capacity under otherwise identical model conditions.',
      'Enzyme amount'
    ],
    [
      'What is necessary for one reaction to drive another?',
      'A mechanism linking the transformations',
      'Merely placing both in one container',
      'An enzyme that changes equilibrium',
      'Identical substrate names',
      'Coupling requires a shared intermediate or other mechanism so the favorable transformation drives the unfavorable one.',
      'Coupling'
    ],
    [
      'Vmax = 90 micromol/min, Km = 2 mmol/L, [S] = 2 mmol/L. Find v.',
      '45 micromol/min',
      '90 micromol/min',
      '22.5 micromol/min',
      '180 micromol/min',
      'v = 90 x 2/(2 + 2) = 45 micromol/min because substrate equals Km.',
      'Rate calculation'
    ],
    [
      'For Vmax = 90 and Km = 2, what rate occurs at [S] = 6 in matching units?',
      '67.5',
      '30',
      '45',
      '270',
      'The occupied-rate fraction is 6/8 = 0.75, giving 90 x 0.75 = 67.5.',
      'Rate calculation'
    ],
    [
      'With Vmax = 90, apparent Km = 6 and [S] = 6, what is the rate?',
      '45 in the Vmax units',
      '90 in the Vmax units',
      '15 in the Vmax units',
      '67.5 in the Vmax units',
      'The inhibitor raises the half-saturation concentration to 6; at that concentration the rate is half of 90.',
      'Inhibition calculation'
    ],
    [
      'What approximation holds when [S] is much smaller than Km?',
      'v is approximately Vmax[S]/Km',
      'v is exactly Vmax at all concentrations',
      'v is independent of substrate',
      'v must be negative',
      'Km dominates the denominator, leaving a rate approximately proportional to substrate concentration.',
      'Limiting cases'
    ],
    [
      'At [S] much greater than Km, what does extra substrate do in this model?',
      'Produces a relatively small further rate increase',
      'Doubles rate for every small addition',
      'Makes the rate negative',
      'Changes the enzyme into product',
      'The fraction [S]/(Km + [S]) is already near one, so the rate approaches its limiting value.',
      'Saturation'
    ],
    [
      'Linked steps have Delta G values +12 and -30 kJ/mol. What is their net change?',
      '-18 kJ/mol',
      '+42 kJ/mol',
      '+18 kJ/mol',
      '-360 kJ/mol',
      'For matching stoichiometric steps add the changes: 12 - 30 = -18 kJ/mol.',
      'Coupling calculation'
    ],
    [
      'What does a no-enzyme assay blank help detect?',
      'Background signal not due to the added enzyme',
      'The exact molecular binding site',
      'The equilibrium constant without measurements',
      'All transport limits in a living organism',
      'A blank reveals product-like signal or nonenzymatic background that could otherwise be counted as enzyme activity.',
      'Controls'
    ],
    [
      'One substrate concentration gives a lower treated rate. What can be concluded?',
      'Activity is lower there, but inhibition type is not established',
      'The inhibitor is certainly competitive',
      'The enzyme equilibrium constant has fallen',
      'The enzyme has certainly been destroyed',
      'Different mechanisms or enzyme amounts can lower one measured rate; a range of substrate concentrations is needed.',
      'Inference'
    ],
    [
      'A treated enzyme retains Vmax but needs more substrate for half Vmax. Which model fits?',
      'Increased apparent Km',
      'Decreased apparent Km with unchanged Vmax',
      'Zero catalytic capacity',
      'A changed thermodynamic equilibrium alone',
      'The half-maximal concentration defines apparent Km; a larger required concentration indicates a larger value.',
      'Parameter interpretation'
    ],
    [
      'Why is Km not always a direct binding dissociation constant?',
      'It combines binding and catalytic rate constants',
      'It has no units',
      'It is always identical to Vmax',
      'It measures total enzyme mass only',
      'The minimal kinetic mechanism contains substrate binding, release and catalytic conversion; Km generally reflects more than binding alone.',
      'Model limits'
    ],
    [
      'The substrate-response curve is strongly cooperative. What is the sound response?',
      'Check a model that accommodates cooperative behavior',
      'Force every point onto simple Michaelis-Menten kinetics',
      'Assume substrate concentration is a rate',
      'Conclude that equilibrium cannot exist',
      'The simple noncooperative model has stated limits; systematic departures require a more appropriate mechanism and model.',
      'Model selection'
    ],
    [
      'A purified enzyme doubles its rate. Why may a whole-cell pathway not double?',
      'Transport or another reaction can become limiting',
      'Cells do not conserve matter',
      'Enzyme catalysis stops existing in cells',
      'Whole-cell rates always equal Vmax',
      'A pathway includes interacting steps; increasing one capacity need not increase flux if another capacity limits it.',
      'Metabolic systems'
    ],
    [
      'A favorable coupled route is observed to run slowly. Is this contradictory?',
      'No; the route may still have a substantial activation barrier',
      'Yes; negative Delta G fixes a rapid rate',
      'Yes; every favorable reaction is instantaneous',
      'No; negative Delta G means equilibrium cannot change',
      'Thermodynamic favorability and kinetic accessibility answer different questions; a favorable route can be slow.',
      'Thermodynamics and rates'
    ],
    [
      'Vmax = 120, Km = 3 and [S] = 9. An inhibitor raises apparent Km to 9. What are the two rates?',
      '90 then 60 in the supplied rate units',
      '60 then 90 in the supplied rate units',
      '120 then 120 in the supplied rate units',
      '30 then 10 in the supplied rate units',
      'Control: 120 x 9/12 = 90. Treated: 120 x 9/18 = 60. Vmax stays fixed in this competitive model.',
      'Integrated kinetics'
    ],
    [
      'At maintained [S] = Km, an assay has rate 40. Twice the active enzyme is added under identical conditions. Predict the new rate.',
      '80 in the same rate units',
      '40 in the same rate units',
      '20 in the same rate units',
      '160 in the same rate units',
      'Initially Vmax = 80 because v is half Vmax. Doubling enzyme gives Vmax = 160 and v = 80 at unchanged [S] = Km.',
      'Capacity reasoning'
    ],
    [
      'A +20 kJ/mol step is claimed to be driven by a separate -35 kJ/mol reaction. What evidence is still needed?',
      'A coupling mechanism; the linked net would be -15 kJ/mol',
      'Proof that adding the numbers changes both equilibrium constants',
      'Proof that any mixture necessarily runs at Vmax',
      'No evidence because proximity guarantees coupling',
      'The arithmetic gives -15 for appropriately linked stoichiometric steps, but a mechanism must make them occur together.',
      'Coupling evidence'
    ],
  ],
);
