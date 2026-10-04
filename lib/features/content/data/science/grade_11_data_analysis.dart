import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

const Map<String, ScienceFigure> grade11DataAnalysisFigures = {
  'sci-g11-5-replicates': ScienceFigure(
    picture: 'g11-replicates',
    title: 'A mean does not describe the whole dataset',
    kind: 'comparison',
    labels: ['Set A', 'Set B', 'Compare spread'],
    details: [
      '9, 10, 11 seconds: mean 10 s.',
      '6, 10, 14 seconds: mean 10 s.',
      'Ranges are 2 s and 8 s respectively.'
    ],
    note:
        'Invented repeated measurements on the same horizontal 0–16 s scale; each dot is one reading.',
  ),
  'sci-g11-5-slope': ScienceFigure(
    picture: 'g11-slope',
    title: 'Interpret slope with an intercept',
    kind: 'comparison',
    labels: ['Horizontal axis', 'Vertical axis', 'Gradient'],
    details: [
      'Time in seconds: 0, 1, 2, 3.',
      'Position in meters: 2, 4, 6, 8.',
      'Position rises 6 m in 3 s: slope 2 m/s.'
    ],
    note:
        'Idealized straight-line position data, x = 2 + 2t. A nonzero starting position is not a nonzero starting time.',
  ),
  'sci-g11-5-uncertainty': ScienceFigure(
    picture: 'g11-uncertainty',
    title: 'Read what the error bars mean',
    kind: 'comparison',
    labels: ['Group P', 'Group Q', 'Interpretation'],
    details: [
      'Mean 10 s, observed readings from 9 to 11 s.',
      'Mean 11 s, observed readings from 10 to 12 s.',
      'Bars show observed minimum–maximum, not confidence intervals.'
    ],
    note:
        'Invented triplicates P: 9, 10, 11 s; Q: 10, 11, 12 s. Overlapping ranges alone are not a significance test.',
  ),
};

final NorieTopicContent grade11DataAnalysisTopic = scienceTopic(
  grade: 'g11',
  order: 5,
  title: 'Scientific Data Analysis',
  subtitle:
      'Connect measurements, uncertainty and models to justified conclusions',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Distinguish repeatability, accuracy, instrument resolution and measurement uncertainty.',
    'Calculate means, ranges and relative uncertainty while stating their limitations.',
    'Interpret a straight-line slope, intercept and residual with correct units.',
    'Evaluate replicated comparisons without confusing association with causation.',
  ],
  introduction:
      'Two laboratory groups report the same average reaction time. One group has tightly clustered readings; the other has widely scattered readings. Which result is more repeatable, and could either still be biased? Scientific analysis preserves the observations, describes their variation, and explains how much confidence a conclusion deserves.',
  prerequisiteTopicId: 'science.g11.earth-materials',
  sections: [
    scienceSection('Define the measurement before collecting numbers',
        '''A measured quantity needs a clear operational definition: exactly what is observed and how. For a reaction-time investigation, define the starting signal and stopping response, record seconds, and keep the procedure consistent. Instrument resolution is the smallest displayed increment. A timer displaying hundredths of a second has resolution 0.01 s; this does not make a human response accurate to 0.01 s.

Record raw readings with units, instrument details and conditions before calculating summaries. Do not replace inconvenient observations with expected values. Repeated readings of one person help assess that person's repeatability under those conditions. To compare populations of people, include independent participants; measuring one person twenty times does not create twenty independent people.'''),
    scienceSection('Precision, accuracy and sources of uncertainty',
        '''Precision describes agreement among repeated measurements under stated conditions. Accuracy concerns agreement with a reference value. A balance that always reads 0.5 g too high can give very consistent readings and still be biased. Checking suitable reference masses can reveal that offset; averaging alone cannot remove it. Subtracting an established offset is a correction, and the correction itself may have uncertainty.

Random variation produces scatter between readings. Systematic effects can shift many readings in the same direction. Measurement uncertainty describes the dispersion of values reasonably attributed to the measured quantity using available information. It can include repeatability, calibration and other contributions. Uncertainty is not simply a mistake, and precision alone does not establish accuracy. State the method used when reporting a plus-or-minus value.'''),
    scienceVisual('sci-g11-5-replicates',
        'Locate individual readings before comparing their mean and spread.'),
    scienceSection('Worked example: the same mean, different spread',
        '''For invented set A, the readings are 9, 10 and 11 s. The arithmetic mean is their sum divided by the number of readings: (9 + 10 + 11)/3 = 10 s. The range is maximum minus minimum: 11 − 9 = 2 s. For set B, 6, 10 and 14 s also average 10 s, but the range is 14 − 6 = 8 s. A is more repeatable in this small sample.

The mean describes a center; the range describes observed spread and is sensitive to extreme readings. Neither gives the cause of variation. Range depends on sample size, so compare sampling procedures too. More independent repetitions can improve estimation of a mean when conditions remain stable, but cannot guarantee removal of calibration bias. Standard deviation is another spread measure, but its calculation is outside this lesson.'''),
    scienceSection('Report a stated uncertainty convention',
        '''For a simple classroom summary only, we may report mean ± half the observed range. Set A then becomes 10 ± 1 s, because half of 2 s is 1 s. For asymmetric data this interval need not include every reading. This convention is neither a confidence interval nor a complete measurement-uncertainty budget. Use it only when explicitly requested, and label it.

Relative uncertainty compares a stated uncertainty with the magnitude of the measured value: uncertainty/value × 100%. For 10 ± 1 s, it is 1/10 × 100 = 10%. The units cancel. A supplied result 20 ± 1 cm has relative uncertainty 5%, although its absolute uncertainty is also one unit. Compare relative uncertainty only with attention to the quantities and reporting conventions.'''),
    scienceVisual('sci-g11-5-uncertainty',
        'Read the bar definition; different kinds of error bars support different conclusions.'),
    scienceSection('Guided example: compare without overstating',
        '''Group P measures 9, 10 and 11 s; group Q measures 10, 11 and 12 s. Calculate the means: 10 s and 11 s. Both ranges are 2 s. Here the horizontal bars deliberately span each observed minimum and maximum, not a confidence interval around a population mean. The observed intervals overlap from 10 to 11 s.

You can report that Q's sample mean is 1 s higher. You cannot decide statistical significance from this overlap alone. The sample size, independence, distribution and meaning of the bars matter. Likewise, overlapping bars do not prove identical populations. Collect more independent observations under comparable conditions and choose an appropriate statistical analysis before claiming a reliable population difference.'''),
    scienceSection('Build a graph that preserves meaning',
        '''Put the explanatory variable on the horizontal axis and the response on the vertical axis. Label both quantities and units, show a readable scale, and plot the original pairs. For a cart, time t is measured in seconds and position x in meters. Idealized pairs are (0, 2), (1, 4), (2, 6) and (3, 8). These lie on x = 2 + 2t.

The intercept is the predicted position at t = 0: 2 m. Slope is change in vertical quantity divided by change in horizontal quantity. Use two points well separated on the model line: (8 − 2)/(3 − 0) = 2 m/s. Here slope is velocity. Dividing a single position by its time would ignore the nonzero starting position and give the wrong velocity.'''),
    scienceVisual('sci-g11-5-slope',
        'The gradient triangle uses changes, not the final coordinate alone.'),
    scienceSection('Check how well a model describes observations',
        '''A straight-line model summarizes a relationship; experimental points need not lie exactly on it. A residual is observed response minus model-predicted response at the same input. If x = 2 + 2t predicts 6 m at 2 s, but a measured position is 6.3 m, the residual is +0.3 m. A negative residual means the observation lies below the prediction.

A curved pattern of residuals suggests a straight line may miss structure, such as changing velocity. Do not delete a large residual merely to improve the graph. Check transcription, equipment and conditions; keep a record of any justified exclusion. Interpolation predicts inside the measured input interval. Extrapolation goes beyond it, where the relationship may change. Neither a good fit nor correlation alone establishes causation.'''),
    scienceSection('Use design and evidence together',
        '''Suppose warmer rooms are associated with faster responses, but warm-room participants also had more practice. Practice is a confounding variable: it could help explain the response difference. To investigate temperature, use comparable procedures and participants, distribute practice comparably, and assign conditions randomly where feasible. Independent replication checks whether a result persists beyond one trial or participant.

Write conclusions in layers: describe the measured pattern, quantify it with units and spread, connect it to a model, then state limitations and alternative explanations. Three replicates support a description of those three observations; they do not establish a universal law. Stronger evidence comes from a suitable design and transparent reporting, not from adding decimal places to an uncertain average.'''),
    scienceSection('Paper activity and common mistakes',
        '''Plot both triplicate sets on one time axis. Calculate each mean and range, then write one valid comparison and one claim the data cannot establish. Sketch the cart graph and mark the horizontal run of 3 s and vertical rise of 6 m. Explain why the slope has units m/s while the intercept has units m.

Correct these errors: fine display resolution guarantees accuracy; a mean contains all the information; overlapping range bars prove no effect; a fitted line proves causation; repeated readings remove every bias. Each confuses a useful tool with a stronger claim than that tool supports.'''),
    scienceSection(
        'Quick check: reveal the reasoning',
        '''A new set is 18, 20 and 22 cm. Under the stated classroom convention, find the mean, range, half-range summary and relative uncertainty.

Mean = 60/3 = 20 cm. Range = 22 − 18 = 4 cm. Half-range = 2 cm, giving 20 ± 2 cm. Relative uncertainty = 2/20 × 100 = 10%. This labeled summary does not automatically include calibration effects or provide a confidence interval.''',
        reveal: true),
    scienceSection('Recap: make the claim match the evidence',
        '''Define measurements, preserve raw data and distinguish repeated readings from independent samples. Report a center and spread, name the uncertainty convention, and check calibration. Read graphs using units, intercepts, slopes and residuals. Evaluate alternative explanations before making causal claims. A scientifically useful conclusion says both what the observations support and what further evidence is needed.'''),
  ],
  keyConcept:
      'Scientific data analysis connects transparent measurements and their uncertainty to quantitative models. Replication, appropriate graphs and explicit limitations make a conclusion stronger than a mean or fitted line alone.',
  questions: [
    [
      'A timer displays steps of 0.01 s. What does this directly specify?',
      'Its display resolution',
      'Its accuracy for human reactions',
      'Its calibration offset',
      'Its sample mean',
      'Resolution is the smallest displayed increment; it does not establish overall accuracy.',
      'Measurement resolution'
    ],
    [
      'Repeated mass readings cluster closely but are all above a checked reference. Which description fits?',
      'Precise but biased readings',
      'Accurate readings with large random scatter',
      'A lack of repeatability',
      'Proof that the reference changed',
      'Close agreement shows precision; disagreement with the reference indicates bias.',
      'Precision and accuracy'
    ],
    [
      'What calculation gives the arithmetic mean of three readings?',
      'Add the readings and divide by three',
      'Subtract the smallest from the largest',
      'Add the largest and smallest only',
      'Divide the sum by the largest reading',
      'The arithmetic mean is the sum divided by the number of readings.',
      'Mean and range'
    ],
    [
      'What does a minimum–maximum bar explicitly represent?',
      'The smallest and largest observed values',
      'A guaranteed confidence interval',
      'The instrument calibration correction',
      'The population mean without uncertainty',
      'A minimum–maximum bar shows observed extent; it is not automatically a confidence interval.',
      'Error bar meaning'
    ],
    [
      'What is the principal limitation of measuring one participant twenty times?',
      'It does not provide twenty independent participants',
      'It prevents assessment of within-person repeatability',
      'It necessarily eliminates calibration bias',
      'It makes all twenty readings identical',
      'Repeated measurements can assess that person, but independent participants are needed for population sampling.',
      'Independent replication'
    ],
    [
      'For a position-versus-time graph, what are the slope units?',
      'Meters per second',
      'Meters',
      'Seconds per meter',
      'Meters per second squared',
      'Slope divides a position change in meters by a time change in seconds.',
      'Slope and units'
    ],
    [
      'Which action is justified when a reading lies far from the fitted line?',
      'Check records and conditions before deciding how to handle it',
      'Delete it solely because it lowers agreement',
      'Replace it with the model prediction',
      'Assume it proves the entire model correct',
      'Investigate unusual observations and document justified decisions rather than hiding disagreement.',
      'Data integrity'
    ],
    [
      'Readings are 9, 10 and 11 s. What are their mean and range?',
      'Mean 10 s; range 2 s',
      'Mean 10 s; range 1 s',
      'Mean 30 s; range 2 s',
      'Mean 11 s; range 9 s',
      'The sum is 30 s, so mean is 10 s; maximum minus minimum is 2 s.',
      'Mean and range'
    ],
    [
      'Sets 9, 10, 11 s and 6, 10, 14 s share a mean. What distinguishes them?',
      'The second has a larger observed range',
      'The first has a larger mean',
      'The second must be more accurate',
      'The first has more independent readings',
      'The observed ranges are 2 s and 8 s; equal means conceal different spread.',
      'Spread'
    ],
    [
      'Under mean ± half-range, how should 9, 10 and 11 s be summarized?',
      '10 ± 1 s',
      '10 ± 2 s',
      '30 ± 1 s',
      '10 ± 0.01 s',
      'Half the range is (11 − 9)/2 = 1 s; the mean is 10 s.',
      'Stated uncertainty'
    ],
    [
      'A supplied result is 20 ± 1 cm. What is its relative uncertainty?',
      '5%',
      '1%',
      '20%',
      '95%',
      'Use 1/20 × 100 = 5%; numerator and denominator use the same units.',
      'Relative uncertainty'
    ],
    [
      'The model is x = 2 + 2t, with x in meters and t in seconds. What is its intercept?',
      '2 m',
      '2 m/s',
      '0 s',
      '4 m',
      'At t = 0, position is 2 m. The intercept has the vertical quantity’s units.',
      'Intercept'
    ],
    [
      'The model predicts 6 m, and an observation is 6.3 m. What is the residual?',
      '+0.3 m',
      '−0.3 m',
      '+12.3 m',
      '+0.3 m/s',
      'Residual equals observed minus predicted: 6.3 − 6 = +0.3 m.',
      'Residuals'
    ],
    [
      'Cart positions are 2 m at 0 s and 8 m at 3 s on a model line. What slope follows?',
      '2 m/s',
      '8/3 m/s',
      '6 m/s',
      '0.5 s/m',
      'Use changes: (8 − 2)/(3 − 0) = 2 m/s, not final position divided by time.',
      'Slope and units'
    ],
    [
      'P has mean 10 s and observed interval 9–11 s; Q has mean 11 s and observed interval 10–12 s. Which statement is justified?',
      'Q’s sample mean is 1 s higher; overlap alone is not a significance test',
      'Overlap proves identical population means',
      'The sample mean difference proves a universal 1 s effect',
      'Range bars guarantee a 95% confidence interval',
      'Describe the observed difference while recognizing that range overlap does not determine significance.',
      'Comparing evidence'
    ],
    [
      'A balance has an established +0.5 g offset. Why is taking more readings alone insufficient?',
      'Averaging does not remove the shared systematic offset',
      'A smaller observed range proves the offset has vanished',
      'The offset decreases in direct proportion to sample size',
      'Displaying extra decimal places corrects the offset',
      'A common offset persists through averaging; calibration and a justified correction address it.',
      'Systematic effects'
    ],
    [
      'Residuals form a clear curved pattern around a straight-line fit. What should be investigated?',
      'Whether the straight-line model misses a nonlinear relationship',
      'Whether the mean residual alone confirms the line is adequate',
      'Whether a steeper plotting scale eliminates the underlying curvature',
      'Whether the central data points alone justify discarding the curved ends',
      'A systematic residual pattern suggests structure remains unexplained by the model.',
      'Model evaluation'
    ],
    [
      'A model was measured only from 0 to 3 s. Predicting at 10 s is which action?',
      'Extrapolation that needs additional justification',
      'Interpolation because the response can still be calculated',
      'A measured response because the line passes through that location',
      'An estimate with the same support as a prediction at 2 s',
      'Ten seconds lies outside the measured interval, where the relationship may change.',
      'Prediction limits'
    ],
    [
      'Warm-room participants respond faster but also had more practice. What strengthens a temperature test?',
      'Make practice comparable and assign temperature conditions randomly where feasible',
      'Give only warm-room participants additional practice',
      'Report only the fastest warm-room response',
      'Assume a fitted line excludes practice effects',
      'Practice is a possible confounder; comparable procedures and random assignment strengthen causal interpretation.',
      'Confounding'
    ],
    [
      'For 18, 20 and 22 cm, what is the relative uncertainty using half-range?',
      '10%',
      '20%',
      '5%',
      '2%',
      'Mean is 20 cm; half-range is 2 cm; 2/20 × 100 = 10%.',
      'Stated uncertainty'
    ],
    [
      'New readings are 28, 30 and 32 s. Which labeled classroom summary follows?',
      '30 ± 2 s, using half the observed range',
      '30 ± 4 s, using half the observed range',
      '90 ± 2 s, using half the observed range',
      '30 ± 2 s, guaranteed to be a confidence interval',
      'Mean is 90/3 = 30 s, range is 4 s and half-range is 2 s; the convention is not a confidence interval.',
      'Mean and uncertainty'
    ],
    [
      'A straight model gives 5 m at 1 s and 17 m at 4 s. What is the velocity represented by its slope?',
      '4 m/s',
      '17/4 m/s',
      '12 m/s',
      '0.25 m/s',
      'Subtract both coordinates: (17 − 5)/(4 − 1) = 12/3 = 4 m/s.',
      'Slope and units'
    ],
    [
      'Three readings from one instrument agree closely, but no reference check was made. Which conclusion is strongest?',
      'Repeatability is good in this sample; accuracy still needs evidence',
      'All sources of measurement uncertainty are zero',
      'The readings establish accuracy for every future measurement',
      'The display resolution proves the absence of bias',
      'Close repetition supports precision under those conditions, while a shared bias remains possible.',
      'Evidence limits'
    ],
  ],
);
