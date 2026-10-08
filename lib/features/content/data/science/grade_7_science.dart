import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

final List<NorieTopicContent> grade7ScienceTopics = [
  _scientificInvestigation,
  _cellsMicroscopy,
  _matterParticles,
  _forceMotion,
  _earthSystems,
];

const Map<String, ScienceFigure> grade7ScienceFigures = {
  'sci-g7-5-links': ScienceFigure(
    picture: 'g7-earth',
    title: 'One landscape contains interacting Earth systems',
    kind: 'comparison',
    labels: ['Atmosphere', 'Hydrosphere', 'Biosphere', 'Geosphere'],
    details: [
      'Air carries gases and water vapor; clouds contain droplets and/or ice crystals.',
      'Water occurs at the surface, below ground, in organisms, as ice and in the air.',
      'Plants take up water, exchange gases and transfer water to the air by transpiration.',
      'Rock and soil influence infiltration and runoff, while roots help stabilize soil.',
    ],
    note:
        'Water arrows show material transfers, with branches and stores. Separate Sun input and outgoing-radiation arrows show energy transfer; energy does not cycle back to the Sun. Simplified sizes, routes and timescales.',
  ),
  'sci-g7-5-carbon': ScienceFigure(
    title: 'Carbon moves among several stores and pathways',
    kind: 'comparison',
    labels: [
      'Air to plants',
      'Plants to consumers',
      'Living things to air',
      'Dead material and soil'
    ],
    details: [
      'Photosynthesis incorporates carbon from atmospheric carbon dioxide into sugars.',
      'Feeding transfers carbon in food into consumer bodies.',
      'Respiration in plants, animals and other organisms returns carbon dioxide.',
      'Decomposition transfers carbon through decomposers and can release carbon dioxide; some carbon remains stored in soil.',
    ],
    note:
        'Selected branches of a carbon cycle, not a compulsory four-step route. Oceans and rocks provide other stores. Carbon matter cycles; captured light energy eventually spreads as heat.',
  ),
  'sci-g7-5-budget': ScienceFigure(
    title: 'A simplified garden water budget for one period',
    kind: 'bars',
    labels: ['Rain input', 'Runoff output', 'Vapor output', 'Storage increase'],
    details: [
      '100 L enters the defined plot.',
      '30 L leaves as runoff.',
      '50 L leaves through evaporation plus transpiration.',
      '100 − 30 − 50 = 20 L is the increase in water stored.',
    ],
    values: [100, 30, 50, 20],
    unit: 'L',
    note:
        'Only the stated inputs and outputs apply to this example. Starting storage of 40 L becomes 60 L. Storage increase is not another outflow, and infiltration within the plot is not automatically water leaving it.',
  ),
  'sci-g7-4-graph': ScienceFigure(
    picture: 'g7-motion',
    title: 'Cumulative distance tells a journey’s story',
    kind: 'comparison',
    labels: ['0–2 s', '2–4 s', '4–6 s'],
    details: [
      'Distance rises from 0 to 4 m: interval speed 4 ÷ 2 = 2 m/s.',
      'Distance remains at 4 m: no additional travel, so interval speed is 0 m/s.',
      'Distance rises from 4 to 8 m: interval speed (8 − 4) ÷ (6 − 4) = 2 m/s.',
    ],
    note:
        'Time is horizontal and cumulative distance is vertical. Straight segments represent constant interval speed; corners idealize changes. This graph does not show direction or the forces causing the motion.',
  ),
  'sci-g7-4-forces': ScienceFigure(
    title: 'Combine forces on one object, keeping direction',
    kind: 'comparison',
    labels: [
      '8 N right, 3 N left',
      '5 N right, 5 N left',
      'Weight down, support up'
    ],
    details: [
      'Opposite horizontal forces give a 5 N resultant to the right.',
      'The horizontal resultant is zero; velocity does not change if all other forces also balance.',
      'For a resting object on a level surface, equal opposing vertical forces can balance without either being absent.',
    ],
    note:
        'Every pair here acts on the same object. Forces on different interacting objects are not added as if they act on one object.',
  ),
  'sci-g7-4-speeds': ScienceFigure(
    title: 'Equal distances can have different average speeds',
    kind: 'bars',
    labels: ['Journey A: 12 m in 6 s', 'Journey B: 12 m in 4 s'],
    details: ['12 ÷ 6 = 2 m/s.', '12 ÷ 4 = 3 m/s.'],
    values: [2, 3],
    unit: 'm/s',
    note:
        'These bars show average speed, not elapsed time or force. Averages do not prove that either journey had constant speed throughout.',
  ),
  'sci-g7-3-states': ScienceFigure(
    title: 'Arrangement and motion explain familiar material behavior',
    kind: 'particles',
    labels: ['Solid', 'Liquid', 'Gas'],
    details: [
      'Particles remain close and vibrate about their positions in this ordered-solid example.',
      'Particles remain close but move past neighbors, allowing the liquid to flow.',
      'Particles are far apart relative to their sizes and move through the container.',
    ],
    note:
        'Dots are enlarged particle symbols, not actual colors or scale. Equal dot sizes and counts do not imply equal volumes for every real state. Not every solid has an ordered crystal arrangement.',
  ),
  'sci-g7-3-diffusion': ScienceFigure(
    picture: 'g7-diffusion',
    title: 'Random motion mixes particles without changing their identities',
    kind: 'comparison',
    labels: ['Partition present', 'Partition removed'],
    details: [
      'Six blue-model particles occupy one half and six amber-model particles the other.',
      'The same twelve particles spread through the closed box. Their colors identify types, not a change of substance.',
    ],
    note:
        'A conceptual gas-diffusion snapshot, not an exact timeline. Individual particles move in different directions; the net spreading reflects concentration differences. Motion continues after mixing.',
  ),
  'sci-g7-3-mass': ScienceFigure(
    title: 'A closed-container melting example preserves measured mass',
    kind: 'bars',
    labels: ['Before: ice + container', 'After: water + container'],
    details: [
      '140 g total: 80 g container plus 60 g ice.',
      '140 g total: 80 g container plus 60 g water.'
    ],
    values: [140, 140],
    unit: 'g',
    note:
        'A supplied idealized dataset with no material entering or leaving and the outside dry. The state changes; the water’s mass does not. Heat can cross the boundary without water leaving.',
  ),
  'sci-g7-2-instrument': ScienceFigure(
    picture: 'g7-microscope',
    title: 'A compound light microscope combines lenses and careful support',
    kind: 'comparison',
    labels: [
      'Illumination and stage',
      'Objective',
      'Eyepiece',
      'Focus and support'
    ],
    details: [
      'Light passes through the thin specimen on a slide supported by the stage.',
      'The lens close to the specimen forms the first magnified image.',
      'The viewing lens magnifies that image further.',
      'Focus adjusts the separation for a clear image; arm and base support the instrument.',
    ],
    note:
        'Simplified classroom transmitted-light model, not an optical ray tracing or measured instrument drawing. Begin at low power and follow teacher instructions to protect the slide and objective.',
  ),
  'sci-g7-2-view': ScienceFigure(
    title: 'More magnification usually means a smaller specimen field',
    kind: 'comparison',
    labels: ['100× total', '400× total', 'Size estimate'],
    details: [
      'A supplied calibrated field diameter is 4.0 mm.',
      'With the same eyepiece setup, four times the magnification gives an approximately 1.0 mm field diameter.',
      'Four equal cell widths spanning a 1.0 mm diameter suggest about 0.25 mm, or 250 μm, per cell.',
    ],
    note:
        'Example calibration, not a universal field size for every microscope. Magnification enlarges the image; it does not enlarge the actual cells or automatically improve resolution.',
  ),
  'sci-g7-2-evidence': ScienceFigure(
    title: 'A micrograph is evidence; a cell diagram is an explanatory model',
    kind: 'comparison',
    labels: [
      'Repeated boundaries',
      'Dark stained region',
      'Unseen small structure'
    ],
    details: [
      'A supplied plant micrograph may show cell-wall outlines; a membrane may not be separately resolved.',
      'A labeled prepared image can identify a nucleus; stain color alone is not a species test.',
      'A mitochondrion drawn in a model may not be distinguishable in a classroom image; invisibility is not absence.',
    ],
    note:
        'Use the image key, scale and sample description. Dye and diagram colors improve contrast rather than establishing natural colors or exact shapes.',
  ),
  'sci-g7-1-design': ScienceFigure(
    picture: 'g7-investigation',
    title: 'Change the surface; keep the cart journey comparable',
    kind: 'comparison',
    labels: ['Changed variable', 'Measured outcome', 'Controlled conditions'],
    details: [
      'Track surface A or B is the independent variable.',
      'Time for the cart to travel the same marked 0.60 m is the dependent variable.',
      'Use the same cart, ramp height and slope, release without a push, marked route and timing method.',
    ],
    note:
        'Teacher-supervised low table-top model. Use one cart across trials; the paired drawing compares conditions rather than claiming identical-looking carts are identical. Example results are hypothetical.',
  ),
  'sci-g7-1-means': ScienceFigure(
    title: 'Means of three supplied travel times',
    kind: 'bars',
    labels: ['Surface A', 'Surface B'],
    details: [
      'Trials 1.8, 2.0, 2.2 s; mean 2.0 s.',
      'Trials 2.8, 3.0, 3.2 s; mean 3.0 s.'
    ],
    values: [2.0, 3.0],
    unit: 's',
    note:
        'The timed route is 0.60 m in both conditions. A lower time means faster travel over that route. Means summarize these measurements; they are not proof about every cart or surface.',
  ),
  'sci-g7-1-claims': ScienceFigure(
    title: 'Separate a measurement from an explanation',
    kind: 'comparison',
    labels: ['Observation', 'Inference', 'Bounded conclusion'],
    details: [
      'The example mean time is 2.0 s on A and 3.0 s on B.',
      'Surface differences may affect the forces opposing the cart’s movement.',
      'Under the controlled conditions, the measured journey took longer on B.',
    ],
    note:
        'An explanation should be tested against evidence. This small study does not show that every material labeled rough behaves the same way.',
  ),
};

final _scientificInvestigation = scienceTopic(
  grade: 'g7',
  order: 1,
  title: 'Scientific Investigation',
  subtitle: 'Design fair measurements and build claims that fit the evidence',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Write a testable question and distinguish independent, dependent and controlled variables.',
    'Plan repeatable measurements with appropriate units and comparable conditions.',
    'Calculate a mean and range and explain what repeated trials can and cannot establish.',
    'Use observations to justify a limited conclusion and identify a confounded comparison.',
  ],
  introduction:
      'One cart rolls down a smooth track in two seconds; another takes three seconds on a different track. Has the surface caused the difference, or did the cart, ramp or release also change? A scientific investigation must make the comparison informative before its numbers can answer the question.',
  prerequisiteTopicId: null,
  sections: [
    scienceSection('From curiosity to a testable question',
        '''An investigation gathers evidence to answer a question. Not every question is answered by the same method: some need observations of natural patterns, some need models, and some allow controlled experiments. A testable question identifies something observable or measurable. Does changing track surface alter the time a cart takes over a fixed route? is more useful here than Which surface is best? because best has no stated measurement.

A hypothesis is a proposed explanation that can be tested. A prediction states an expected observation if the explanation is useful. For example, if surface B opposes movement more under the chosen conditions, we predict a longer travel time on B. A supported prediction strengthens that explanation, but one matching result does not prove it is the only possible explanation.'''),
    scienceSection('Name the variables before measuring',
        '''A variable is a factor that can change. The independent variable is deliberately changed in an experiment: here, track surface A or B. The dependent variable is the measured outcome: travel time over a marked route. Controlled variables are conditions kept the same so they do not provide competing explanations.

For this test, use the same cart, ramp height and slope, marked 0.60 m route, release point, no-push release and timing method. Measure distance from the same defined start and finish. Keep a surface covering secure so it does not introduce an accidental obstacle. If the ramp is also steeper on A, both surface and slope could explain a time difference. This is a confounded comparison; its design cannot isolate the intended change.'''),
    scienceVisual('sci-g7-1-design',
        'Match the route and release conditions before comparing the surfaces.'),
    scienceSection('Record measurements so others can repeat them',
        '''A method states the equipment, sequence, quantities and decision rules. Record time in seconds, written s, and distance in meters, m. A table heading such as Travel time / s is clearer than a column of unlabeled numbers. Record each trial immediately, including unexpected values, rather than writing only the result you hoped for.

A stopwatch display might show hundredths of a second, but human reaction time can be much larger. Display detail is not a guarantee of measurement accuracy. Use a consistent timing rule, such as start when the front of the cart crosses the first mark and stop when it crosses the second. Repeated practice can reduce inconsistent technique, though it cannot remove every timing error.'''),
    scienceSection('Repeated trials show variation',
        '''Repeat the journey several times on each surface. Slight differences are normal because release and timing cannot be perfectly identical. A mean summarizes a set: add all readings and divide by their number. A range describes spread: subtract the lowest reading from the highest. Keep the original readings alongside both summaries.

Consistent repeated values improve confidence that a result is repeatable. However, repeated measurements can all share an error, such as a wrongly marked distance or a clock that runs too slowly. Repetition does not automatically create accuracy or remove a confound. A second group following the method provides a stronger check of reproducibility. Changing the order of A and B trials can also reduce the influence of steadily changing conditions.'''),
    scienceSection('Worked example: two sets of times',
        '''Surface A gives 1.8, 2.0 and 2.2 s. Surface B gives 2.8, 3.0 and 3.2 s. Step 1: calculate A's total, 1.8 + 2.0 + 2.2 = 6.0 s. Divide by three readings: mean 2.0 s. Step 2: B totals 9.0 s, so its mean is 3.0 s. Step 3: calculate each range: 2.2 − 1.8 = 0.4 s for A, and 3.2 − 2.8 = 0.4 s for B.

Step 4: compare the means using the same route. B takes 1.0 s longer on average in this dataset. Lower time over equal distance means faster travel, so A is faster here. The separate sets do not overlap, which supports a difference under the tested conditions. With only three trials, do not claim an exact universal difference for all carts, ramps and surfaces.'''),
    scienceVisual('sci-g7-1-means',
        'Compare mean times while retaining the individual trials and their spread.'),
    scienceSection('Guided example: summarize without hiding variation',
        'A third surface gives 2.1, 2.4 and 2.7 s over the same route. Calculate its mean and range. Its mean lies between A and B: does that automatically establish why it behaves differently? Which conditions must still be checked?'),
    scienceSection('Reveal: a summary is not a cause',
        'The total is 7.2 s, so the mean is 7.2 ÷ 3 = 2.4 s. The range is 2.7 − 2.1 = 0.6 s. The mean summarizes timing; it does not identify the cause. Check the same cart, slope, height, release, distance and timing method before attributing a difference to surface.',
        reveal: true),
    scienceSection('Observations, inferences and conclusions',
        '''An observation describes evidence, such as a recorded mean or a visible event. An inference interprets that evidence, such as suggesting a surface changes a force opposing motion. A conclusion answers the original question with evidence and qualifications. Under these conditions, mean time was longer on B than A is stronger than B is always slower because it matches the actual scope.

Two quantities changing together is a correlation. It does not alone establish a cause. If a survey finds taller seedlings in warmer locations, light or water might also differ. A well-controlled intervention helps distinguish explanations, but a conclusion should still state its sample and conditions. Revising a hypothesis after conflicting evidence is part of investigation, not a failure of science.'''),
    scienceVisual('sci-g7-1-claims',
        'State what was measured separately from the proposed reason.'),
    scienceSection('Safe investigation or data-only alternative',
        '''With a teacher, use a low, stable table-top ramp and a small cart, with a barrier preventing it from rolling off the work surface. Keep the route clear and release without pushing. Learners do not ride carts, build high ramps or stand on furniture. If equipment is unavailable, use the supplied dataset and draw a proposed setup.

Write the variable table, timing rule and planned repeats before any demonstration. Keep trials that disagree with your prediction. If one result seems unusual, inspect the notes for a documented cause and repeat the trial if appropriate; do not delete it simply to improve the mean. Report exclusions openly, along with their reasons.'''),
    scienceSection('Common mistakes',
        'A dependent variable is what is measured, not what is deliberately changed. Controlled variables are kept comparable; they are not every result written in the table. More decimal places do not ensure greater accuracy. A mean should not hide spread or missing trials. Repetition cannot repair a comparison where several causal factors changed together.'),
    scienceSection('Quick check',
        'A track study changes both surface and slope. Why is that a problem? Three readings total 12.6 s: what is their mean? Can ten repeated readings from a faulty clock guarantee an accurate time?'),
    scienceSection('Check your thinking',
        'Surface and slope provide competing explanations, so the study cannot isolate surface. The mean is 12.6 ÷ 3 = 4.2 s. Repetition can show consistency but cannot guarantee accuracy when the measuring system has a shared error.',
        reveal: true),
    scienceSection('Recap',
        'Define a measurable question, isolate the intended change, and record a repeatable method with units. Keep individual results, compare means and variation, and write a conclusion whose reach matches the evidence. Investigations improve when uncertainties and competing explanations are made visible.'),
  ],
  keyConcept:
      'A reliable scientific claim connects a clear question with controlled or well-described evidence, repeated measurements, appropriate summaries and honest limits.',
  questions: [
    [
      'A cart study changes the surface and measures travel time over the same marked route, using the same cart and release method. Which question matches the changed variable and measured outcome?',
      'How does surface affect travel time over the same marked route?',
      'How does cart mass affect travel time on one surface?',
      'How does ramp height affect travel time on one surface?',
      'How does surface affect the maximum load a cart carries?',
      'This study changes surface and measures travel time; the other questions change a different factor or measure a different outcome.',
      'Testable questions'
    ],
    [
      'The experiment deliberately changes surface A to B. What role does surface have?',
      'Independent variable',
      'Dependent variable',
      'Recorded mean',
      'Range of the times',
      'The independent variable is deliberately changed.',
      'Independent variable'
    ],
    [
      'The cart’s travel time is measured after changing the surface. What role does time have?',
      'Dependent variable',
      'Independent variable',
      'Controlled ramp height',
      'Hypothesis',
      'The dependent variable is the observed outcome.',
      'Dependent variable'
    ],
    [
      'Why is the same cart used on both surfaces?',
      'To keep a possible competing influence controlled',
      'To make the surface the measured time',
      'To eliminate the need for repeated trials',
      'To guarantee every trial has an identical time',
      'Cart differences could affect results, so the same cart helps isolate surface.',
      'Controlled variables'
    ],
    [
      'Which table heading gives a measurement and its unit correctly?',
      'Travel time / s',
      'Travel time / m',
      'Route distance / s',
      'Surface type / s',
      'Time is measured in seconds; distance uses meters.',
      'Units and records'
    ],
    [
      'Which description is an observation rather than an explanatory inference?',
      'The recorded mean on B is 3.0 s',
      'B may oppose the cart’s movement more strongly',
      'A surface force could explain the result',
      'A steeper slope might alter the outcome',
      'A recorded numerical result is evidence; the proposed reasons are inferences.',
      'Observation and inference'
    ],
    [
      'What calculation gives the mean of three readings?',
      'Add the readings and divide by three',
      'Subtract the lowest from the highest',
      'Choose only the middle trial',
      'Add the readings without dividing',
      'A mean is the total divided by the number of readings.',
      'Mean'
    ],
    [
      'Times are 1.8, 2.0 and 2.2 s. What is their mean?',
      '2.0 s',
      '6.0 s',
      '0.4 s',
      '2.2 s',
      'The total is 6.0 s; 6.0 ÷ 3 = 2.0 s.',
      'Mean calculation'
    ],
    [
      'Times are 2.8, 3.0 and 3.2 s. What is their range?',
      '0.4 s',
      '3.0 s',
      '9.0 s',
      '0.2 s',
      'Range = highest − lowest = 3.2 − 2.8 = 0.4 s.',
      'Range'
    ],
    [
      'A and B have mean times of 2.0 and 3.0 s over equal routes. What comparison follows?',
      'A is faster over the tested route',
      'B is faster because its time is larger',
      'Their speeds must be equal because distances match',
      'Time cannot inform a same-distance speed comparison',
      'For the same distance, a shorter journey time indicates faster travel.',
      'Interpreting times'
    ],
    [
      'A stopwatch shows hundredths of a second. Why might hand-timed accuracy still be poorer?',
      'Reaction time can exceed the displayed interval',
      'The number of digits guarantees no human error',
      'A detailed display removes release variation',
      'Repeated trials change seconds into meters',
      'Display precision does not remove timing and technique errors.',
      'Measurement limitations'
    ],
    [
      'Why keep individual readings after calculating a mean?',
      'They reveal variation that the mean alone hides',
      'They make units unnecessary',
      'They prove that every reading is accurate',
      'They remove the need to describe the method',
      'The same summary can conceal different spreads, so retain the original data.',
      'Variation'
    ],
    [
      'A ramp is steeper on A and the surface is different. Why is this comparison confounded?',
      'Both surface and slope could explain the time difference',
      'Travel time cannot be measured on a ramp',
      'Repeats always make two changes harmless',
      'The independent variable has become the mean',
      'Changing two possible causes prevents isolating the intended surface effect.',
      'Confounding'
    ],
    [
      'The same cart travels the same route under matched release conditions. Surface A times are 1.8, 2.0 and 2.2 s; surface B times are 2.8, 3.0 and 3.2 s. Which conclusion matches this three-trial study?',
      'Mean travel time was longer on B under the tested conditions',
      'Every surface B is slower for every possible cart',
      'One result proves surface is the only influence',
      'A longer time proves the clock is faulty',
      'Bound the claim to the actual conditions and measurements.',
      'Bounded conclusions'
    ],
    [
      'A third surface gives 2.1, 2.4 and 2.7 s. Which summary is correct?',
      'Mean 2.4 s; range 0.6 s',
      'Mean 7.2 s; range 0.6 s',
      'Mean 2.4 s; range 0.3 s',
      'Mean 0.6 s; range 2.4 s',
      '7.2 ÷ 3 = 2.4 s; 2.7 − 2.1 = 0.6 s.',
      'Two summaries'
    ],
    [
      'Ten trials use a clock that runs too slowly. What can repeats alone fail to correct?',
      'A shared measurement error',
      'The existence of individual readings',
      'The stated surface choices',
      'The number of trials in the mean',
      'Repeats can be consistent while all contain the same error.',
      'Accuracy versus consistency'
    ],
    [
      'Warmer locations contain taller seedlings, but water and light were not matched. Which interpretation is justified?',
      'The association does not isolate temperature as the cause',
      'Temperature is proven to be the only cause',
      'Water and light cannot affect a plant observation',
      'The correlation proves no variables need controlling',
      'Other conditions could explain the association; correlation alone does not establish cause.',
      'Correlation and cause'
    ],
    [
      'One trial conflicts with the prediction and has no documented mistake. What is the appropriate response?',
      'Retain it and investigate variation openly',
      'Delete it solely to make the mean fit the prediction',
      'Replace it with the predicted value',
      'Report only the fastest trial as the full dataset',
      'Unexpected results are evidence; excluding them needs an explicit defensible reason.',
      'Data integrity'
    ],
    [
      'Why alternate A and B trials instead of finishing all A trials first?',
      'It can reduce the influence of conditions changing over time',
      'It guarantees all results become identical',
      'It removes the need for a fixed route',
      'It makes surface no longer an independent variable',
      'Trial order can otherwise coincide with gradual changes in conditions.',
      'Trial order'
    ],
    [
      'Another group follows the same method and obtains a similar pattern. What does this add?',
      'Evidence that the result is reproducible',
      'Proof of a universal rule without limits',
      'A guarantee that both groups have no shared errors',
      'A replacement for reporting the first group’s data',
      'Independent reproduction strengthens confidence while not eliminating every limitation.',
      'Reproducibility'
    ],
    [
      'Three readings total 12.6 s and range from 4.0 to 4.4 s. Which mean and range follow?',
      '4.2 s and 0.4 s',
      '12.6 s and 0.4 s',
      '4.2 s and 4.4 s',
      '4.0 s and 0.2 s',
      'Mean = 12.6 ÷ 3 = 4.2 s; range = 4.4 − 4.0 = 0.4 s.',
      'Mastery: calculations'
    ],
    [
      'A repeated study changes cart mass, slope and surface together. Which revision isolates surface?',
      'Keep the cart and slope the same while comparing A and B',
      'Keep only the trial count the same',
      'Calculate a mean and ignore the changed conditions',
      'Compare the fastest A trial with the slowest B trial',
      'Design control must isolate the intended change; averaging cannot repair the confound.',
      'Mastery: design'
    ],
    [
      'A prediction fails despite a carefully documented method. What scientific action fits?',
      'Review the explanation and evidence, then revise or test alternatives',
      'Change the records to match the prediction',
      'Treat the hypothesis as proven by its wording',
      'Stop recording because unexpected observations are not data',
      'Hypotheses are tested against evidence and can be revised.',
      'Mastery: evidence and explanations'
    ],
  ],
);

final _cellsMicroscopy = scienceTopic(
  grade: 'g7',
  order: 2,
  title: 'Cells & Microscopy',
  subtitle:
      'Measure microscopic structures while separating image size from visible detail',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Connect microscope parts with illumination, magnification, support and focusing.',
    'Calculate total magnification and interpret a calibrated field of view.',
    'Estimate cell dimensions using millimeters and micrometers.',
    'Distinguish magnification, resolution and contrast and qualify claims about unseen structures.',
  ],
  introduction:
      'Zooming into a blurry photograph can make the blur larger without revealing a new detail. A microscope can also give a larger image without showing every cell structure. To learn from tiny cells, we need a clear image, a useful scale and careful interpretations.',
  prerequisiteTopicId: 'science.g7.scientific-investigation',
  sections: [
    scienceSection('Cells are small working systems',
        '''Cells carry out basic life activities, including taking in materials, releasing usable energy and maintaining internal conditions. A cell membrane controls movement across the boundary. Cytoplasm contains fluid and structures where many reactions occur. In typical plant and animal cells, a nucleus holds most genetic instructions. Mitochondria support release of usable energy from food in both groups.

Photosynthetic plant cells also contain chloroplasts, while a supporting cell wall lies outside their membrane. Many mature plant cells have a large central vacuole. Not every plant cell has chloroplasts: a root cell need not match a green leaf-cell model. These structural facts guide interpretation, but a labeled diagram includes parts that an ordinary classroom microscope may not show separately.'''),
    scienceSection('Light, specimen and lenses',
        '''A compound light microscope uses an objective close to the specimen and an eyepiece through which you look. In the transmitted-light classroom model, a lamp supplies light from below. Light passes through a thin specimen on a slide supported by the stage, then into the objective and eyepiece. Thick specimens can overlap and block light, so a thin prepared sample is useful.

The arm and base support the instrument; they do not magnify the image. Focusing changes the appropriate separation between specimen and objective to obtain a clear view. Carry and adjust equipment only as instructed by the teacher. Begin with the lowest-power objective, locate and center the region, then increase power if necessary. Watch that the objective does not contact the slide. A prepared micrograph is an equally valid way to study this lesson without equipment.'''),
    scienceVisual('sci-g7-2-instrument',
        'Distinguish the light route and lenses from parts that support and position them.'),
    scienceSection('Calculate magnification',
        '''Magnification compares apparent image size with the actual object size. For a compound microscope, total magnification equals eyepiece magnification multiplied by objective magnification. A 10× eyepiece with a 4× objective gives 40× total. The same eyepiece with a 10× objective gives 100×; with a 40× objective it gives 400×.

Do not add the lens numbers: 10 + 40 would give the wrong total. Changing magnification changes the image, not the real cell. A photograph displayed larger on a screen may no longer match its originally printed magnification. A scale bar remains useful if the image and bar are resized together, because it marks an actual specimen length represented in the image.'''),
    scienceSection('Resolution and contrast answer different questions',
        '''Resolution is the ability to distinguish close structures as separate. Magnification makes an image larger; resolution determines whether two neighboring details can be told apart. Enlarging the same blurred image cannot recover information that was not recorded. A higher-power objective may improve useful detail, but larger total magnification alone is not a guarantee.

Contrast is the visible difference between a structure and its surroundings. A transparent nucleus may be hard to distinguish; a teacher-prepared stain can improve contrast. The stain is not necessarily the cell's natural color and may affect living material. Do not infer an organism's species from dye color. Focusing, illumination and preparation all influence what can be observed, so an unclear image has several possible causes.'''),
    scienceSection('Field of view and size',
        '''The field of view is the area of specimen visible through the eyepiece. Its diameter is the width across the circular view. Increasing magnification with the same eyepiece setup generally decreases field diameter. If a calibrated field is 4.0 mm across at 100×, an approximately fourfold increase to 400× gives a 1.0 mm diameter. This relationship concerns specimen distance, not the physical eyepiece opening.

Small cell dimensions are often expressed in micrometers, μm. One millimeter equals 1,000 μm. Therefore 0.2 mm is 200 μm, not 2 μm. A field-size estimate assumes a calibration supplied for that instrument. Different eyepieces and instruments can have different fields, so do not treat the example diameter as universal.'''),
    scienceVisual('sci-g7-2-view',
        'Calculate the specimen field before using it to estimate a cell width.'),
    scienceSection('Worked example: estimate a cell width',
        '''A calibrated field is 1.2 mm across. Six similar cell widths fit approximately across its diameter without large gaps. Step 1: identify the actual specimen length represented: 1.2 mm. Step 2: divide by six widths: 1.2 ÷ 6 = 0.2 mm per cell. Step 3: convert units: 0.2 × 1,000 = 200 μm. Step 4: state that this is an estimate, not an exact measurement of every cell.

Cells may vary in size, a boundary may be unclear, and partial cells near the edge affect counting. Count across a straight diameter rather than around the circumference. For a precise length in a calibrated image, compare the feature with its scale bar or an appropriate measurement tool. Total magnification alone does not provide the actual cell width without an image or field length.'''),
    scienceSection('Guided example: two calculations',
        'A microscope has a 10× eyepiece and 20× objective. What is total magnification? A separately calibrated image has a 0.9 mm field diameter with three similar cell widths across it. Estimate one width in millimeters and micrometers. Explain why the second answer does not follow from magnification alone.'),
    scienceSection('Reveal: multiply lenses, divide lengths',
        'Total magnification is 10 × 20 = 200×. The estimated width is 0.9 ÷ 3 = 0.3 mm, or 300 μm. The width calculation uses the calibrated specimen field and the cell count; 200× alone does not supply either quantity.',
        reveal: true),
    scienceSection('Make claims from visible evidence',
        '''A micrograph is an image made using a microscope. A plant micrograph may show repeated wall outlines and a labeled stained nucleus, but the cell membrane may not be separately distinguishable from the wall. Many small organelles shown in textbooks cannot be confidently identified with a basic classroom light microscope. Failing to see a mitochondrion is not evidence that a plant cell lacks mitochondria.

Record visible evidence and identify uncertainty. A drawing can simplify and color structures to explain functions, while a micrograph records one sample under particular conditions. Neither represents every cell. Use the sample description, key and scale, and compare multiple cells before making a general claim.'''),
    scienceVisual('sci-g7-2-evidence',
        'A missing visible detail limits the observation, rather than proving the structure is absent.'),
    scienceSection('Safe comparison activity',
        '''Use teacher-supplied plant and animal micrographs with scale bars or prepared slides under supervision. Do not collect body fluids, cut tissue, culture unknown organisms or handle broken glass. Draw several cells from one field, recording total magnification or the scale bar, sample name and confidently visible features. Mark uncertain features rather than filling them in from memory.

Compare your observation drawing with a labeled model. Explain one structure the model teaches but the image does not resolve, and one actual image variation the tidy model hides. Do not point microscope illumination or any optical instrument toward the Sun.'''),
    scienceSection('Common mistakes',
        'Objective magnification is not total magnification. A larger image is not necessarily better resolved. Field diameter is specimen width, and it usually shrinks when magnification increases. Millimeters and micrometers differ by a factor of 1,000. Diagram colors, stain colors and invisible structures require careful interpretation.'),
    scienceSection('Quick check',
        'What total magnification combines 10× and 40× lenses? If four equal cell widths span 1.0 mm, estimate one width in μm. Can enlarging an already blurry photograph alone distinguish two unresolved details?'),
    scienceSection('Check your thinking',
        'The total is 400×. Each width is approximately 0.25 mm, or 250 μm. Enlargement alone cannot recover unresolved details; magnification and resolution are different properties.',
        reveal: true),
    scienceSection('Recap',
        'Use lenses and focusing to obtain a useful image, then interpret its scale. Multiply lens magnifications, estimate specimen dimensions from calibration, and distinguish larger images from clearer detail. A careful cell observation includes uncertainty rather than assuming every textbook part is visible.'),
  ],
  keyConcept:
      'Microscopy combines image enlargement, resolution, contrast and calibration. A useful cell claim depends on visible evidence and a reliable specimen scale.',
  questions: [
    [
      'Which microscope part is the lens nearest the specimen?',
      'Objective',
      'Eyepiece',
      'Stage',
      'Base',
      'The objective lies close to the specimen; the eyepiece is the viewing lens.',
      'Microscope parts'
    ],
    [
      'What job does the stage perform in the classroom microscope model?',
      'Supports the slide',
      'Magnifies the image for the observer',
      'Supplies illumination from below',
      'Adjusts the separation for focusing',
      'The stage positions and supports the specimen slide; lenses, lamp and focus controls have other jobs.',
      'Stage'
    ],
    [
      'Which route matches transmitted light through the microscope model?',
      'Lamp → specimen → objective → eyepiece',
      'Eyepiece → base → lamp → specimen',
      'Lamp → arm → base → eyepiece',
      'Specimen → stage support → base → objective',
      'Illumination passes through the thin specimen and then the lenses.',
      'Light route'
    ],
    [
      'How is total magnification calculated for the compound microscope?',
      'Eyepiece magnification × objective magnification',
      'Eyepiece magnification + objective magnification',
      'Objective magnification ÷ eyepiece magnification',
      'Field diameter × number of cells',
      'The two lens magnifications multiply.',
      'Total magnification'
    ],
    [
      'What does microscope resolution describe?',
      'Distinguishing close structures as separate',
      'Only how large the printed image appears',
      'Only the visible difference in color',
      'The diameter of the eyepiece opening alone',
      'Resolution concerns distinguishable detail, unlike magnification or contrast.',
      'Resolution'
    ],
    [
      'What does contrast help a learner do in a cell image?',
      'Distinguish a structure from its surroundings',
      'Determine cell size without any calibration',
      'Multiply the objective and eyepiece numbers',
      'Make real cells physically larger',
      'Contrast is the visible difference between a feature and its background.',
      'Contrast'
    ],
    [
      'Which conversion between cell-size units is correct?',
      '1 mm = 1,000 μm',
      '1 mm = 100 μm',
      '1 mm = 10 μm',
      '1 mm = 0.001 μm',
      'A micrometer is one-thousandth of a millimeter.',
      'Cell-size units'
    ],
    [
      'A 10× eyepiece combines with a 40× objective. What is the total?',
      '400×',
      '50×',
      '40×',
      '4×',
      '10 × 40 = 400, not 10 + 40.',
      'Magnification calculation'
    ],
    [
      'A calibrated field is 4.0 mm at 100×. About what diameter follows at 400× with the same eyepiece setup?',
      '1.0 mm',
      '16.0 mm',
      '4.0 mm',
      '0.25 mm',
      'Four times the magnification gives about one-fourth of the specimen field diameter.',
      'Field diameter'
    ],
    [
      'Six similar cell widths span 1.2 mm. What approximate width is estimated for one cell?',
      '0.2 mm',
      '7.2 mm',
      '1.2 mm',
      '0.6 mm',
      'Divide the field width by the count: 1.2 ÷ 6 = 0.2 mm.',
      'Cell-width estimate'
    ],
    [
      'What is 0.2 mm expressed in micrometers?',
      '200 μm',
      '20 μm',
      '2 μm',
      '2,000 μm',
      '0.2 × 1,000 = 200 μm.',
      'Unit conversion'
    ],
    [
      'Why center a specimen region before increasing power?',
      'A smaller field can otherwise exclude the desired region',
      'Centering replaces the need for an eyepiece lens',
      'It keeps specimen field diameter unchanged at every power',
      'It makes all cell structures automatically resolve',
      'The higher-magnification field is smaller, so locating and centering first is useful.',
      'Microscope technique'
    ],
    [
      'A larger digital copy of a blurry micrograph shows no new details. Which interpretation fits?',
      'Image enlargement alone has not improved its recorded resolution',
      'The real cells became larger',
      'Contrast must always equal magnification',
      'The field now contains a newly formed organelle',
      'Resizing cannot restore information absent from the original image.',
      'Image limits'
    ],
    [
      'A prepared stain makes the nucleus stand out from its surroundings. What does this demonstrate?',
      'Improved contrast, not proof of species or natural color',
      'The exact species of every stained cell',
      'That the cells have that color naturally',
      'That no cell structures can be damaged by preparation',
      'Staining can improve contrast but its color is not a species test or necessarily natural.',
      'Preparation evidence'
    ],
    [
      'A 10× eyepiece and 20× objective are used. Which total magnification follows?',
      '200×',
      '30×',
      '20×',
      '2×',
      'The product is 10 × 20 = 200×.',
      'Lens calculation'
    ],
    [
      'Three similar cell widths span a 0.9 mm calibrated field. Which estimate follows?',
      '0.3 mm, or 300 μm',
      '0.3 mm, or 30 μm',
      '2.7 mm, or 2,700 μm',
      '0.9 mm, or 900 μm',
      '0.9 ÷ 3 = 0.3 mm; multiply by 1,000 to convert to μm.',
      'Size and units'
    ],
    [
      'A plant micrograph does not show mitochondria clearly. Which conclusion is justified?',
      'The image may not resolve them; absence is not established',
      'Plant cells never contain mitochondria',
      'Only animal cells can release usable energy from food',
      'The image proves the specimen is not living material',
      'Plant cells have mitochondria, but basic microscopy may not distinguish them.',
      'Unseen structures'
    ],
    [
      'Why is a thin specimen useful in transmitted-light microscopy?',
      'It reduces overlapping material and allows light through more readily',
      'It removes the need for an objective',
      'It guarantees every organelle has natural bright colors',
      'It multiplies the eyepiece power without a lens change',
      'Thick samples can block light and overlap structures.',
      'Specimen thickness'
    ],
    [
      'A photograph and its scale bar are enlarged together. What remains useful?',
      'Their proportional comparison for actual specimen length',
      'The original printed magnification regardless of display size',
      'The paper’s new width as the real cell width',
      'The number of pixels alone as a micrometer unit',
      'A jointly resized scale bar still represents its labeled specimen length.',
      'Scale bars'
    ],
    [
      'Why qualify an estimate made from cells across a field diameter?',
      'Cell sizes, unclear boundaries and partial cells create uncertainty',
      'Division cannot be used for lengths',
      'All cells are exactly equal, so the estimate is unnecessary',
      'A field diameter always equals one cell width',
      'The method estimates typical widths under stated assumptions; it is not exact for every cell.',
      'Estimation limits'
    ],
    [
      'Four equal cell widths span a 1.0 mm calibrated field. What is the estimated width in μm?',
      '250 μm',
      '25 μm',
      '4,000 μm',
      '1,000 μm',
      '1.0 ÷ 4 = 0.25 mm; 0.25 × 1,000 = 250 μm.',
      'Mastery: cell dimensions'
    ],
    [
      'An image is large and sharp enough to separate two nearby boundaries, but the nucleus blends into its background. What property is lacking for the nucleus?',
      'Contrast',
      'Resolution of the two boundaries',
      'Total magnification calculation',
      'Field-size calibration',
      'The structure is difficult to distinguish from its surroundings, a contrast problem.',
      'Mastery: image quality'
    ],
    [
      'Two microscopes both show 400× total. Must their field diameters be the same?',
      'No; field size depends on the instrument and eyepiece calibration',
      'Yes; 400× always means a 1.0 mm field',
      'Yes; field size is the physical diameter of every cell',
      'No; only the number of visible cells determines field diameter',
      'Equal magnification alone does not determine a universal specimen field diameter.',
      'Mastery: calibration'
    ],
  ],
);

final _matterParticles = scienceTopic(
  grade: 'g7',
  order: 3,
  title: 'Matter & Particles',
  subtitle:
      'Explain diffusion, pressure and physical change with a moving-particle model',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Use particle arrangement and movement to explain state behavior and compressibility.',
    'Explain diffusion and temperature effects without claiming particles grow or stop moving.',
    'Compare gas pressure and volume changes under explicitly stated constraints.',
    'Account for material and measured mass across a defined system boundary.',
  ],
  introduction:
      'Air can be compressed, water usually resists compression, and a solid keeps its shape. Their particles are too small to see directly, yet a model of arrangement and motion explains these everyday differences. What can the model explain, and what must it leave out?',
  prerequisiteTopicId: 'science.g7.cells-microscopy',
  sections: [
    scienceSection('Tiny units, useful models',
        '''Matter has mass and occupies space. It consists of tiny particles, including atoms, molecules and ions. An atom is a small unit of an element; a molecule contains atoms joined together. In this lesson, a dot simply represents a particle. It may stand for a molecule rather than an entire visible grain. A sugar grain contains many particles; it is not one molecule.

Models connect behavior we can measure with structures too small for ordinary observation. Dot size and color make the diagram readable rather than showing actual particle dimensions or colors. Particles interact and move. The gaps between model dots do not need to be filled with another material called air: air itself consists of particles. A diagram is evidence-based explanation, not a microscope photograph.'''),
    scienceSection('State depends on arrangement and freedom to move',
        '''In a solid, particles are close together and vibrate about their positions, so the material usually keeps its own shape and volume. An ordered arrangement represents a crystalline solid; other solids can have less orderly structures. Solid particles are not completely motionless.

In a liquid, particles remain close but can move past one another. The liquid flows and takes the shape of the region of its container that it occupies while retaining a fairly definite volume. In a gas, particles are much farther apart relative to their sizes and travel through the available space. A gas has neither a fixed shape nor a fixed volume; it spreads to fill its container. The word fluid includes both liquids and gases because both can flow.'''),
    scienceVisual('sci-g7-3-states',
        'Compare spacing and movement; changing state does not mean a dot becomes larger.'),
    scienceSection('Compression and pressure',
        '''Compressing a gas brings particles closer together by reducing the gaps. It does not require the particles themselves to shrink. Liquids and solids are usually much harder to compress because their particles are already close. This comparison concerns ordinary conditions, not a claim that every material is perfectly incompressible.

Gas pressure arises from particles colliding with container walls. If the same amount of gas is squeezed into less volume at the same temperature, collisions per wall area occur more frequently and pressure rises. This statement keeps temperature and gas amount fixed. If a leak lets particles escape, a different explanation is needed. Treat sealed or heated containers as diagrams only; pressure can make real containers dangerous.'''),
    scienceSection('Temperature describes particle motion',
        '''Temperature is related to the average kinetic energy of particle motion. At a higher temperature, particles of the same substance generally have greater average motion energy. Individual particles have different speeds; a diagram arrow is not a promise that every particle moves at one exact speed. Cooling reduces average thermal motion, but ordinary cooled solids still have vibrating particles.

Thermal energy also depends on how much material is present and on its state and substance. Two samples at the same temperature need not contain the same total thermal energy. A large water sample and a small water sample can have the same temperature while differing in energy content. Do not treat temperature as a count of particles or as the same thing as total energy.'''),
    scienceSection('What can warming a gas change?',
        '''Consider two different constraints. In a rigid closed container, volume and particle number are fixed. Warming the gas generally increases pressure as faster-moving particles make stronger, more frequent wall collisions. The box cannot expand simply because particles move faster.

In a flexible container that can expand while the external pressure remains approximately constant, warming the same gas can increase its volume. Average spacing increases; individual particles do not swell into larger molecules. Which prediction applies depends on the boundary conditions. Saying warm gas always expands ignores a rigid container, while saying warm gas always has greater pressure ignores an expanding constant-pressure case. These are conceptual models, not learner heating experiments.'''),
    scienceSection('Diffusion is net spreading from random motion',
        '''Diffusion is the net spreading of particles from a region where their concentration is higher toward a region where it is lower, due to random motion. A particle does not know which region needs it and may move in either direction. The combined movement produces the overall spreading pattern. Diffusion occurs in gases and liquids; it is typically faster in gases under comparable everyday conditions.

In a closed box, remove a partition that separates two kinds of gas-model particles. They spread and mix while each type remains present. When the mixture becomes more uniform, particle motion continues. There may be no continuing net concentration change even though particles still cross regions. Bulk currents can also move materials; seeing color spread through water does not prove diffusion was the only process.'''),
    scienceVisual('sci-g7-3-diffusion',
        'Count both particle types before and after; mixing changes distribution, not identity or total number.'),
    scienceSection('Worked example: mass during melting',
        '''A closed container has a mass of 80 g and holds 60 g of ice. Step 1: add the masses: total 140 g. Step 2: let the ice change to liquid in the supplied model, with no water entering or leaving and no material sticking to the outside. Step 3: predict a total of 140 g afterward, including 60 g of water. The water particles change arrangement rather than disappearing.

Heat can enter a closed material system without water entering. During melting of a pure substance at a fixed pressure, added energy can change its state while the temperature remains nearly constant. It is therefore inaccurate to say every transfer of heat must immediately raise temperature. State and system boundaries matter when interpreting measurements.'''),
    scienceVisual('sci-g7-3-mass',
        'Compare the same contents-plus-container boundary before and after.'),
    scienceSection('Guided example: an open system',
        'The same 80 g container initially holds 60 g of water, totaling 140 g. After some water evaporates from the open container, the measured total is 136 g. How much water remains inside? How much left the measured system? Has water matter been destroyed?'),
    scienceSection('Reveal: follow matter across the boundary',
        'The remaining water is 136 − 80 = 56 g. The loss from the measured system is 140 − 136 = 4 g, now outside as water vapor in this example. The open container loses matter to its surroundings; the change does not show that matter was destroyed.',
        reveal: true),
    scienceSection('Safe observation of spreading',
        '''With teacher guidance, place a small drop of known food coloring into room-temperature water in a clear unbreakable cup and observe without stirring. Record the region occupied by color at several times. Do not taste, smell unknown substances closely, use hot water or heat sealed containers. A provided image sequence is a safe alternative.

The observation can demonstrate spreading, but tiny currents and the drop's initial motion may contribute alongside diffusion. Describe that limit rather than claiming the activity directly reveals individual molecules. For a particle-count task, use the closed-box diagram: six blue and six amber particles give twelve total both before and after mixing.'''),
    scienceSection('Common mistakes',
        'Solid particles vibrate; they are not fixed without motion. A gas expands through increased spacing, not swollen molecules. Cooling does not remove particles. Diffusion is random motion with a net pattern, not purposeful travel. An open-system mass loss can reflect matter leaving, while a closed-system physical change preserves its material mass.'),
    scienceSection('Quick check',
        'Why is a gas easier to compress than a liquid? Does a fully mixed gas stop moving? In the closed melting dataset, what changes and what stays the same?'),
    scienceSection('Check your thinking',
        'A gas has much larger gaps to reduce. Particles continue moving after mixing. Melting changes arrangement and state, while the water amount and the total closed-system mass remain the same.',
        reveal: true),
    scienceSection('Recap',
        'Use particle spacing, motion and interactions to explain state behavior, diffusion and gas pressure. Keep temperature distinct from total energy. Define whether the boundary is rigid, flexible, open or closed before predicting changes or interpreting a mass measurement.'),
  ],
  keyConcept:
      'Particles continue moving and interacting. Physical changes alter arrangement, spacing or distribution, while system boundaries determine how material and energy can enter or leave.',
  questions: [
    [
      'A solid keeps its shape under ordinary conditions. Which particle description helps explain this?',
      'Particles vibrate about positions while remaining close',
      'Particles travel far apart throughout any container',
      'Particles stop all motion at room temperature',
      'Particles have no interactions with neighbors',
      'Close particles with restricted movement support a solid’s shape; vibration still occurs.',
      'Solid motion'
    ],
    [
      'Why can a liquid flow while keeping a fairly definite volume?',
      'Close particles can move past one another',
      'Its particles must be far apart like a gas',
      'Its particles become larger when poured',
      'All its particles remain immobile in fixed rows',
      'Liquids have close particles with freedom to move past neighbors.',
      'Liquid behavior'
    ],
    [
      'In a model of air, what does a dot represent?',
      'A tiny particle such as a molecule',
      'An entire visible dust grain in every case',
      'A gap that must be filled with more air',
      'A microscope image of a naturally blue sphere',
      'Dots symbolize tiny units; size and color are explanatory choices.',
      'Particle models'
    ],
    [
      'Why is a gas usually easier to compress than a liquid?',
      'Gas particles have larger gaps that can be reduced',
      'Gas particles shrink into smaller molecules under any squeeze',
      'Liquid particles have larger gaps than gas particles',
      'Gas particles are initially more closely packed than liquid particles',
      'Compression reduces spacing; liquid particles are already close.',
      'Compressibility'
    ],
    [
      'Which events produce pressure against a gas container’s walls?',
      'Collisions of gas particles with the walls',
      'Expansion of individual gas particles into larger molecules',
      'Particles resting without movement against one wall',
      'Attraction between gas particles alone',
      'Moving particles transfer momentum in collisions with the walls, producing pressure.',
      'Gas pressure'
    ],
    [
      'What does diffusion describe in this lesson?',
      'Net spreading from higher to lower concentration through random motion',
      'Every particle deliberately moving only toward empty regions',
      'A compulsory change of one particle type into another',
      'All particle motion stopping after a partition is removed',
      'Random individual motion produces an overall concentration-spreading pattern.',
      'Diffusion'
    ],
    [
      'What does the term fluid include here?',
      'Liquids and gases',
      'Only liquids',
      'Only solids and liquids',
      'Only gases',
      'Both liquids and gases can flow.',
      'Fluids'
    ],
    [
      'After gases mix uniformly in a closed box, what happens to their particles?',
      'They continue moving without a continuing overall concentration change',
      'They all stop moving permanently',
      'They all become one new particle type automatically',
      'They leave the closed box because diffusion requires escape',
      'Uniformity does not remove ongoing particle motion.',
      'Motion after mixing'
    ],
    [
      'The same gas is compressed at fixed temperature with no leakage. What change is expected?',
      'Pressure rises as particles occupy less space',
      'Pressure falls because particles are fewer',
      'Each molecule grows larger',
      'The total gas mass must decrease',
      'With fixed amount and temperature, smaller volume increases wall collision frequency per area.',
      'Compression conditions'
    ],
    [
      'Gas warms in a rigid closed box. Which prediction fits the stated constraints?',
      'Pressure generally rises while volume stays fixed',
      'Volume must double regardless of the rigid boundary',
      'Particle number must increase',
      'All particles become stationary',
      'The rigid boundary fixes volume; warming increases average motion and pressure.',
      'Rigid gas model'
    ],
    [
      'The same gas warms in a flexible container at approximately constant pressure. What can increase?',
      'Container volume and average particle spacing',
      'The size of each individual molecule',
      'The number of particles without any entry',
      'The mass of each particle solely because it is warmer',
      'An expanding container increases spacing; particles themselves do not swell.',
      'Flexible gas model'
    ],
    [
      'Which statement distinguishes temperature from total thermal energy?',
      'Different amounts of the same material can share temperature but differ in energy content',
      'Equal temperature always means equal total energy for any amounts',
      'Temperature counts the total number of particles',
      'Temperature is the same quantity as container volume',
      'Amount of material matters for total energy as well as temperature, state and substance.',
      'Temperature and energy'
    ],
    [
      'A closed container is 80 g and its ice is 60 g. What total remains after melting without material transfer?',
      '140 g',
      '80 g',
      '60 g',
      '20 g',
      '80 + 60 = 140 g, and closed-system melting preserves the water mass.',
      'Closed-system mass'
    ],
    [
      'Six blue and six amber particles mix in the closed-box model. What total should remain?',
      '12 particles',
      '6 particles',
      '18 particles',
      '24 particles',
      'Mixing redistributes the same six of each type; 6 + 6 = 12.',
      'Particle conservation'
    ],
    [
      'An open 80 g container totals 136 g after evaporation. How much water remains inside?',
      '56 g',
      '136 g',
      '216 g',
      '4 g',
      'Subtract the container: 136 − 80 = 56 g.',
      'Mass accounting'
    ],
    [
      'An open container holds water that evaporates, with no other material entering or leaving. Its total measured mass falls from 140 g to 136 g. Which interpretation fits?',
      '4 g of water left the measured system as vapor',
      '4 g of matter was destroyed by evaporation',
      'The container gained 4 g of liquid water',
      'Every water particle lost its own mass',
      'The smaller measured system lost water to its surroundings; conservation does not require an open-container reading to stay constant.',
      'Open-system boundary'
    ],
    [
      'Why does observing food color spread in still water not isolate diffusion completely?',
      'Small currents and the drop’s initial motion may also move color',
      'Liquids cannot support diffusion',
      'Color movement proves molecules become visible individually',
      'Diffusion occurs only when all particles stop moving',
      'Visible spreading can have multiple transport mechanisms; state the observation’s limits.',
      'Observation limits'
    ],
    [
      'A learner draws larger molecules to explain warm gas occupying more space. What correction fits?',
      'Increase spacing rather than molecular size',
      'Increase molecule count even though no matter enters',
      'Reduce particle spacing to represent expansion',
      'Give all particles exactly the same speed and direction',
      'Expansion of this gas model changes average separation, not molecule size.',
      'Model correction'
    ],
    [
      'Ice melts at nearly constant temperature while receiving heat in the stated pure-substance model. What does the energy support?',
      'The change of state rather than a required immediate temperature rise',
      'Only a temperature rise before any state change',
      'A loss of water mass even in the closed container',
      'A decrease in the number of water particles',
      'A phase change can use added energy without an immediate temperature increase.',
      'Heat during change'
    ],
    [
      'One gas particle moves toward the higher-concentration side during diffusion. Does this contradict the model?',
      'No; random individual motion can differ from the net spreading direction',
      'Yes; every particle must move in only one direction',
      'Yes; concentration determines every individual particle’s direction',
      'Yes; a uniform mixture must have no particle movement',
      'Diffusion describes a net statistical pattern, not identical directions for every particle.',
      'Net versus individual motion'
    ],
    [
      'A closed model mixes six blue and six amber particles, but a new drawing contains eight blue and four amber. What must be corrected if no reaction or transfer occurred?',
      'Restore six of each type; mixing changes distribution, not identity',
      'Keep twelve total and ignore each type’s count',
      'Treat every color change as required by diffusion',
      'Add two more particles to make the box warmer',
      'Both total and type counts stay unchanged for this physical mixing model.',
      'Mastery: model conservation'
    ],
    [
      'Two warmed gas models predict different changes: one pressure increase and one volume increase. What must be specified to evaluate them?',
      'Whether the boundary is rigid or flexible and what quantities are held fixed',
      'Only the temperature change regardless of the boundary',
      'Only the initial particle count regardless of volume',
      'Only the initial volume regardless of pressure',
      'Boundary constraints determine which variable can change.',
      'Mastery: conditions'
    ],
    [
      'A container’s water mass decreases during evaporation. How can conservation be tested across a broader boundary?',
      'Account for water remaining and water transferred to the surroundings',
      'Count only the remaining liquid and call the missing mass destroyed',
      'Assume gas has no mass because it is invisible',
      'Ignore vapor whenever the container is open',
      'Matter crosses the open-container boundary; including transferred vapor restores the material accounting.',
      'Mastery: systems'
    ],
  ],
);

final _forceMotion = scienceTopic(
  grade: 'g7',
  order: 4,
  title: 'Force & Motion',
  subtitle:
      'Calculate speed, read cumulative-distance graphs and combine directed forces',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Calculate average speed with distance and elapsed time in consistent units.',
    'Interpret slopes and stationary intervals on a cumulative-distance–time graph.',
    'Calculate the resultant of forces along one line and distinguish force from motion direction.',
    'Explain balanced forces, changes in velocity and qualitative effects of mass.',
  ],
  introduction:
      'A cart can travel quickly while the forces on it balance, and it can briefly move left while a net force acts right. To explain movement, we must distinguish where an object travels, how fast it travels, and what changes its motion.',
  prerequisiteTopicId: 'science.g7.matter-particles',
  sections: [
    scienceSection('Describe the journey before explaining it',
        '''Motion is a change of position relative to a chosen reference. A person seated in a moving bus is at rest relative to the seat but moving relative to the roadside. State the reference when comparing descriptions. Distance is the total length of the path traveled. It does not depend on whether the final position is near the start.

Average speed is total distance divided by elapsed time. When distance is in meters and time in seconds, speed is in meters per second, m/s. A journey of 12 m in 6 s has average speed 12 ÷ 6 = 2 m/s. This average does not guarantee exactly 2 m was covered in every second: the object might have sped up, slowed down or paused.'''),
    scienceSection('Use quantities and units together',
        '''For comparable journeys, a greater distance in the same time means greater average speed. Over the same distance, a smaller time means greater speed. Journey B covers 12 m in 4 s, so its average is 3 m/s, compared with Journey A's 2 m/s. Do not multiply distance and time to obtain speed; the unit m/s reflects division.

Use consistent units. If a route is 600 cm, that is 6 m because 100 cm = 1 m. At 3 s, its average speed is 6 ÷ 3 = 2 m/s. Speed describes how fast, while velocity includes direction as well. Two objects can have equal speeds while traveling in opposite directions, so their velocities differ.'''),
    scienceVisual('sci-g7-4-speeds',
        'Compare distance divided by time rather than judging from total distance alone.'),
    scienceSection('Cumulative-distance graphs',
        '''A cumulative-distance–time graph places elapsed time on the horizontal axis and total distance traveled on the vertical axis. Cumulative means added up from the start. At 0 s our model distance is 0 m; at 2 s it is 4 m; at 4 s it is still 4 m; at 6 s it is 8 m. Read the axis units before calculating.

A rising straight segment means a constant positive speed during that interval in the model. A steeper rise means greater speed when the scales are the same. A horizontal segment means distance is not increasing, so the object is stationary during that interval. Cumulative distance cannot decrease because returning toward the start still adds traveled distance. A position graph can decrease; it is a different graph.'''),
    scienceVisual('sci-g7-4-graph',
        'The horizontal interval shows a pause, not motion along a physically flat road.'),
    scienceSection('Worked example: calculate interval and whole-journey speed',
        '''Step 1: for 0–2 s, divide the distance increase by the time increase: (4 − 0) ÷ (2 − 0) = 2 m/s. Step 2: for 2–4 s, distance increase is zero, giving 0 m/s. Step 3: for 4–6 s, use changes rather than the final coordinate alone: (8 − 4) ÷ (6 − 4) = 2 m/s.

Step 4: calculate the whole-journey average using all elapsed time, including the pause: 8 ÷ 6 is approximately 1.33 m/s. It is lower than either moving interval's speed. Using 8 ÷ 4 would incorrectly omit the two-second stop. The graph describes distance and time; it does not by itself identify travel direction, road shape or the forces causing changes.'''),
    scienceSection('A force has magnitude and direction',
        '''A force is a push or pull due to an interaction. Its magnitude is measured in newtons, N, and its direction matters. Gravity pulls an object toward Earth. A supporting surface can push upward, while friction can oppose relative sliding. A force diagram selects one object and shows forces acting on that object, not every force anywhere nearby.

Net force, or resultant force, combines those directed forces. For forces along one line, add magnitudes if they point the same way and subtract if they oppose. With 8 N right and 3 N left, the net force is 8 − 3 = 5 N right. With 5 N in each direction, the net is zero. Merely adding all numbers would lose direction and give a wrong result.'''),
    scienceVisual('sci-g7-4-forces',
        'Choose one object and one line of action before combining the forces.'),
    scienceSection('Balanced does not mean motionless',
        '''Balanced forces give zero net force. An object already at rest can remain at rest; an object already moving can continue with constant velocity, meaning constant speed in a straight line. Balanced forces do not require that every force is absent. A resting book can have a downward weight balanced by an upward support force.

An unbalanced net force produces acceleration, the rate at which velocity changes. Velocity can change in speed, direction, or both. A cart moving right with a rightward net force speeds up in the simple straight-line case. A cart moving left with a rightward net force initially slows down; it does not instantly start moving right. Motion direction and force direction answer different questions. At equal net force, a more massive object has a smaller acceleration than a less massive object.'''),
    scienceSection('Guided example: opposing pulls',
        'A model cart is moving left. Two horizontal forces act on it: 9 N right and 4 N left. Calculate the net force and direction. Does it initially increase or reduce the cart’s leftward speed? What happens if those forces later become 4 N in each direction and other forces balance?'),
    scienceSection('Reveal: calculate force, then relate it to motion',
        'The net force is 9 − 4 = 5 N right. It initially reduces the leftward speed because it acts opposite the movement. Later, equal opposing forces give zero net force; the cart retains whatever velocity it has then in the ideal model. Zero net force does not itself make a moving cart stop.',
        reveal: true),
    scienceSection('Why everyday moving objects often stop',
        '''A rolling or sliding object on a real surface encounters opposing interactions, such as friction and air resistance. If there is no forward interaction balancing them, the net force opposes motion and speed decreases. It is inaccurate to infer that continued motion always requires a forward net force. What requires a net force is a change in velocity.

Interactions involve pairs of forces on different objects. A hand pushes a cart and the cart pushes the hand. Those forces do not cancel when finding the cart's net force because one acts on the cart and the other on the hand. First choose the object, then include only the forces acting on it.'''),
    scienceSection('Safe measurement activity',
        '''With a teacher, mark a short, clear level route for a small cart using removable tape. Keep it on a low stable work surface with a stopping barrier, or use a floor route away from feet and walkways. Record several travel times over the same measured distance without running after it or riding it. A supplied motion table can replace practical equipment.

Calculate each trial's average speed with units. Draw the cumulative-distance model from its supplied points, using equal time intervals and a clear scale. Do not draw a decreasing cumulative distance to represent a return journey. Never infer a numerical force from speed alone without additional information.'''),
    scienceSection('Common mistakes',
        'Distance is path length, not just change of position. Whole-journey time includes stops. A flat cumulative-distance segment means rest, not a flat road. Balanced forces can accompany motion. Net force changes velocity, while its direction need not match the present direction of motion. Forces on different objects cannot be combined as if acting on one.'),
    scienceSection('Quick check',
        'A cart travels 600 cm in 3 s: what is its average speed in m/s? Opposing horizontal forces are 7 N right and 2 N left: what is the net? Can a constant-speed turn occur with zero net force?'),
    scienceSection('Check your thinking',
        '600 cm = 6 m, so the average is 2 m/s. The net is 5 N right. A turn changes velocity direction even if speed is constant, so zero net force cannot explain that change.',
        reveal: true),
    scienceSection('Recap',
        'Describe motion with a reference, distance, time and direction. Read graphs as measurements, calculate speeds over the correct intervals, and combine forces on the same object with direction intact. Balanced forces preserve velocity; unbalanced forces change it.'),
  ],
  keyConcept:
      'Speed describes distance traveled per time; net force explains changes in velocity. Graph slopes, force directions and system choice must be interpreted separately.',
  questions: [
    [
      'A route is 12 m and takes 6 s. Which expression calculates average speed?',
      '12 m ÷ 6 s',
      '12 m × 6 s',
      '6 s ÷ 12 m',
      '12 m + 6 s',
      'Average speed is distance divided by elapsed time.',
      'Speed formula'
    ],
    [
      'Which unit fits speed calculated from meters and seconds?',
      'm/s',
      'm × s',
      's/m',
      'N',
      'Meters per second expresses distance traveled per time; newtons measure force.',
      'Speed units'
    ],
    [
      'On the cumulative-distance graph, which quantity is on the horizontal axis?',
      'Elapsed time',
      'Total distance traveled',
      'Net force',
      'Object mass',
      'The horizontal axis gives time; vertical distance accumulates along the path.',
      'Graph axes'
    ],
    [
      'What does a horizontal cumulative-distance segment mean during that interval?',
      'The object is stationary',
      'The road is physically flat',
      'The object is moving at its highest speed',
      'The object must be returning toward its start',
      'No added distance means no travel during the interval.',
      'Stationary interval'
    ],
    [
      'What feature distinguishes velocity from speed?',
      'Velocity also includes direction',
      'Velocity is measured only in newtons',
      'Speed always includes direction while velocity does not',
      'Velocity is the total force on an object',
      'Speed is how fast; velocity combines speed and direction.',
      'Speed and velocity'
    ],
    [
      'Opposing forces of 5 N right and 5 N left act on one object. What is the horizontal net force?',
      '0 N',
      '10 N right',
      '10 N left',
      '5 N right',
      'Equal opposite forces on one object balance.',
      'Balanced forces'
    ],
    [
      'Which quantity describes the rate at which an object’s velocity changes?',
      'Acceleration',
      'Average speed',
      'Cumulative distance',
      'Net force',
      'Acceleration is change of velocity per unit time, including a speed or direction change.',
      'Acceleration'
    ],
    [
      'What average speed results from 12 m in 4 s?',
      '3 m/s',
      '48 m/s',
      '0.33 m/s',
      '8 m/s',
      'Average speed is distance divided by elapsed time: 12 m ÷ 4 s = 3 m/s.',
      'Speed calculation'
    ],
    [
      'The graph reaches 4 m at 2 s and stays there until 4 s. What is the speed from 2–4 s?',
      '0 m/s',
      '2 m/s',
      '4 m/s',
      '1 m/s',
      'Distance increase is zero during the two-second interval.',
      'Reading a pause'
    ],
    [
      'From 4–6 s, cumulative distance rises from 4 m to 8 m. What interval speed follows?',
      '2 m/s',
      '4 m/s',
      '1.33 m/s',
      '0.5 m/s',
      '(8 − 4) ÷ (6 − 4) = 4 ÷ 2 = 2 m/s.',
      'Interval speed'
    ],
    [
      'Forces are 8 N right and 3 N left on one object. What is their net?',
      '5 N right',
      '11 N right',
      '5 N left',
      '11 N left',
      'Subtract opposing magnitudes and retain the larger-force direction.',
      'Directed resultant'
    ],
    [
      'A book rests on a level table. What can its balanced vertical forces include?',
      'Downward weight and equal upward support',
      'No gravity because the book is stationary',
      'Only upward support with no opposing force',
      'Downward weight with no possible support',
      'Zero net force can result from two nonzero balanced forces.',
      'Support and weight'
    ],
    [
      'An already moving object has zero net force in the ideal model. What happens to its velocity?',
      'It remains constant',
      'It immediately becomes zero',
      'Its speed must increase each second',
      'Its direction must continually change',
      'Balanced forces preserve motion with constant speed and direction.',
      'Newton’s first-law behavior'
    ],
    [
      'Which statement about the cumulative-distance graph is correct?',
      'Its value cannot decrease during a return journey',
      'Its value must fall whenever direction reverses',
      'Its slope measures the road’s physical gradient',
      'Its axes directly provide the force magnitude',
      'Returning still adds traveled distance; position and cumulative distance are different.',
      'Distance versus position'
    ],
    [
      'What is the whole-journey average for 8 m traveled over 6 s including the pause?',
      'Approximately 1.33 m/s',
      '2 m/s',
      '0.75 m/s',
      '4 m/s',
      'Use total distance and all elapsed time: 8 ÷ 6 ≈ 1.33 m/s.',
      'Average including stops'
    ],
    [
      'A cart moves left while the net force is right. What occurs initially in the straight-line model?',
      'Its leftward speed decreases',
      'It instantly moves right at unchanged speed',
      'Its leftward speed increases',
      'Its velocity cannot change',
      'A net force opposing present motion initially slows the object.',
      'Force versus motion direction'
    ],
    [
      'A rider travels 4 m out and 4 m back in 4 s. What is the average speed?',
      '2 m/s',
      '0 m/s',
      '1 m/s',
      '0.5 m/s',
      'Total path length is 8 m, so 8 ÷ 4 = 2 m/s, even though the finish is at the start.',
      'Path length'
    ],
    [
      'Two carts experience the same net force. Which qualitative comparison follows if one has more mass?',
      'The more massive cart has smaller acceleration',
      'The more massive cart must have larger acceleration',
      'Both must have identical acceleration regardless of mass',
      'Neither can accelerate because their forces match each other',
      'At equal net force, more mass produces a smaller change in velocity per time.',
      'Mass and acceleration'
    ],
    [
      'Why does an unpowered rolling cart often slow on a real surface?',
      'Opposing interactions create a net force against its motion',
      'Motion requires a forward net force even without opposition',
      'The cart’s distance must decrease whenever it slows',
      'A zero net force always removes its velocity',
      'Friction and resistance can leave an unbalanced opposing resultant.',
      'Real-world slowing'
    ],
    [
      'A hand pushes a cart, and the cart pushes the hand. Why do those forces not cancel in the cart’s force sum?',
      'They act on different objects',
      'Equal forces always add to zero on any selected object',
      'The force on the hand must be added to the cart’s weight',
      'Interaction forces have no directions',
      'Include only forces acting on the selected cart.',
      'Choosing the object'
    ],
    [
      'A journey of 600 cm takes 3 s. What average speed in m/s follows?',
      '2 m/s',
      '200 m/s',
      '0.5 m/s',
      '18 m/s',
      '600 cm = 6 m; 6 ÷ 3 = 2 m/s.',
      'Mastery: consistent units'
    ],
    [
      'A left-moving cart has 9 N right and 4 N left forces. Which combined conclusion is correct?',
      'Net 5 N right, initially reducing its leftward speed',
      'Net 13 N left, increasing its leftward speed',
      'Net 5 N left, initially reducing its rightward speed',
      'Net zero because the two forces point oppositely',
      'Subtract the opposing forces, then compare the resultant direction with present motion.',
      'Mastery: resultant and motion'
    ],
    [
      'An object moves at constant speed around a curved path. Which explanation fits?',
      'Its changing direction requires a nonzero net force',
      'Constant speed proves all forces balance',
      'A curved path is impossible unless speed increases',
      'Its cumulative traveled distance must decrease',
      'Velocity includes direction, so turning changes velocity even at constant speed.',
      'Mastery: changing direction'
    ],
  ],
);

final _earthSystems = scienceTopic(
  grade: 'g7',
  order: 5,
  title: 'Earth Systems',
  subtitle: 'Trace material and energy across air, water, life and rocky Earth',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Identify major Earth systems and explain their overlap in a familiar landscape.',
    'Trace selected water and carbon pathways while distinguishing material cycles from energy flow.',
    'Calculate a simple water-storage change from defined inputs and outputs.',
    'Explain how a change can affect several systems and evaluate the limits of a model.',
  ],
  introduction:
      'Rain falls on a garden, seeps into soil, enters roots and later returns to the air. At which point is it only a water story? Air, plants, soil and energy are involved throughout. Earth systems help us follow these connections rather than studying each part as an isolated box.',
  prerequisiteTopicId: 'science.g7.force-motion',
  sections: [
    scienceSection('Four connected systems',
        '''The atmosphere is the envelope of gases around Earth. The hydrosphere includes Earth's water: oceans, rivers, groundwater, water vapor and frozen water. Frozen water is also studied as the cryosphere. The biosphere contains living organisms and the regions where life occurs. The geosphere includes land, seafloor, rocks, minerals, soil and Earth's interior.

These terms describe interacting systems rather than four sealed layers. Soil contains mineral material, water, air spaces, roots and microbes. A plant is part of the biosphere, but the water inside it also belongs to the hydrosphere. Different scientists may organize subdivisions differently for their questions. State what a term includes rather than assuming that each object can belong to only one system.'''),
    scienceSection('Transfers, stores and boundaries',
        '''A store holds material for a time, such as water in a lake or carbon in wood. A transfer moves material or energy between places. The water reaching a leaf has followed transfers from soil to root and upward through the plant. It can stay temporarily before leaving as water vapor. Not every particle completes the same route or takes the same time.

A system boundary defines what you include in a study. The whole Earth exchanges energy with space, while a garden also exchanges water, gases and organisms with its surroundings. An input crosses into the defined system; an output crosses out. Movement inside the boundary is an internal transfer, not automatically an input or output. Identifying the boundary prevents counting the same movement twice.'''),
    scienceSection('Water connects air, ground and life',
        '''Evaporation changes liquid water to vapor and transfers water toward the atmosphere. Transpiration releases water vapor from plants. Together these can be described as evapotranspiration. Condensation forms liquid droplets from vapor, and clouds contain droplets and/or ice crystals rather than being made only of water gas. Precipitation returns water to the surface as rain, snow or other forms.

Surface runoff travels along the ground. Infiltration enters soil; some water is stored there, some enters roots, and some moves deeper toward groundwater. Gravity contributes to downward and downhill movement. Solar energy supplies much of the energy for surface evaporation. These routes branch: precipitation need not become runoff immediately, and infiltrated water need not instantly reach a groundwater store.'''),
    scienceVisual('sci-g7-5-links',
        'Find a material transfer between two systems, then distinguish it from an energy arrow.'),
    scienceSection('Carbon follows multiple routes',
        '''Carbon is an element present in many materials, including carbon dioxide, living tissue and some rocks. During photosynthesis, plants use carbon dioxide and water with light energy to make sugars, releasing oxygen. Carbon from air becomes part of plant matter. Animals obtain carbon through food; feeding moves material rather than creating carbon from nothing.

Plants, animals and many other organisms respire, releasing carbon dioxide while obtaining usable energy from food. Decomposers process dead material and waste, moving carbon through their bodies and releasing some as carbon dioxide. Some carbon stays in soil, water or other stores for longer periods. Oceans exchange carbon with the atmosphere, and rock-related pathways can operate over very long times. The cycle is a network of routes, not a single mandatory chain.'''),
    scienceVisual('sci-g7-5-carbon',
        'Respiration and decomposition create return routes; some material remains stored instead of returning immediately.'),
    scienceSection('Energy flows through the system',
        '''Material cycles reuse atoms across stores and processes. Energy behaves differently. Sunlight enters Earth's system; some is reflected, and absorbed energy can warm surfaces, drive evaporation and support photosynthesis. Food transfers some captured energy through living organisms. Energy eventually spreads to surroundings as heat, and Earth emits energy to space as radiation.

This outgoing energy is not returned as useful sunlight to the beginning of a biological cycle. Matter recycling does not imply an energy loop. Earth's interior also supplies energy to geological processes, including long-term movement and volcanism. A landscape model may show only solar input, so it is a selected explanation rather than every energy source and pathway.'''),
    scienceSection('Worked example: a water budget',
        '''A water budget accounts for inputs, outputs and change in storage during a stated period. Our model garden starts with 40 L stored. It receives 100 L of rainfall; 30 L leaves as runoff, and 50 L leaves as evaporation plus transpiration. Assume no other input or output for this example. Step 1: add the available water, 40 + 100 = 140 L. Step 2: total the outputs, 30 + 50 = 80 L. Step 3: subtract: final storage is 140 − 80 = 60 L.

Step 4: compare final with initial storage: 60 − 40 = a 20 L increase. Storage increase is not the same as final storage. Water infiltrating from the surface into soil is still inside this defined plot, so do not subtract it again unless it crosses the boundary. A real study must check additional groundwater flows and measurement uncertainty.'''),
    scienceVisual('sci-g7-5-budget',
        'Distinguish rainfall input, two outputs, the storage change and the final stored amount.'),
    scienceSection('Guided example: a second period',
        'Another model plot starts with 35 L stored, receives 80 L, loses 20 L as runoff and 30 L as water vapor, and has no other flows. Calculate final storage and its change. Would a real measurement disagreeing with the prediction prove that water was destroyed?'),
    scienceSection('Reveal: account for flows and uncertainty',
        'Available water is 35 + 80 = 115 L. Outputs total 20 + 30 = 50 L. Final storage is 115 − 50 = 65 L, an increase of 30 L from the starting 35 L. A disagreement calls for checking overlooked flows, boundary definitions and measurement errors, not assuming water matter was destroyed.',
        reveal: true),
    scienceSection('One change can affect several systems',
        '''Removing plant cover changes the biosphere, but the effects can spread. Roots help stabilize soil and plant cover can reduce the impact of falling rain. With less cover, some locations experience more runoff and erosion, changing geosphere material and hydrosphere transport. Less transpiration can alter water transfer to air. Results depend on soil, slope, rainfall and what replaces the vegetation.

A feedback occurs when a change causes effects that influence the original change. In a vulnerable site, vegetation loss can increase soil erosion, making regrowth harder and encouraging further vegetation loss. This can amplify the initial change; it is not a universal outcome at every site. Predict relationships carefully and seek measurements rather than assuming one disturbance affects only one system.'''),
    scienceSection('Safe systems observation',
        '''Use a teacher-provided landscape photograph or observe a garden from a safe path. Identify rock or soil, water, air and living things. Draw two specific transfers with directional arrows and label what moves. Add sunlight as a separate energy input. Do not enter rivers, unstable slopes, drainage channels or areas affected by severe weather, and do not disturb animals or dig unknown soil.

For a data-only investigation, check a supplied water budget and list which unmeasured flows could explain an imbalance. The diagram should state its boundary and period. Comparing multiple observations is more useful than a beautiful picture whose arrows have no defined meaning.'''),
    scienceSection('Common mistakes',
        'Earth systems overlap rather than occupying completely separate boxes. Clouds are not only water vapor. Infiltration is not automatically an outflow from every chosen boundary. Final storage differs from storage change. Plants respire as well as photosynthesize. Carbon and water can cycle, but energy does not return as reusable sunlight.'),
    scienceSection('Quick check',
        'A root takes in soil water: which systems interact? What final storage follows from 40 L initially plus 100 L input minus 80 L output? Why must the carbon diagram show branches and stores?'),
    scienceSection('Check your thinking',
        'Biosphere and hydrosphere interact within the geosphere’s soil setting. Final storage is 60 L, a 20 L increase. Carbon has several routes and storage times; not every atom immediately follows one fixed sequence.',
        reveal: true),
    scienceSection('Recap',
        'Describe interacting systems, trace stores and transfers, and define the boundary before counting flows. Use budgets to test material accounting and keep energy arrows distinct from matter cycles. A change in one system can propagate through several others, with outcomes that depend on conditions.'),
  ],
  keyConcept:
      'Earth’s air, water, living and geological systems exchange material and energy. Budgets follow matter across boundaries, while cycles, stores and feedbacks explain connected changes.',
  questions: [
    [
      'Which Earth system includes the surrounding envelope of gases?',
      'Atmosphere',
      'Geosphere',
      'Biosphere',
      'Cryosphere',
      'The atmosphere is Earth’s gas envelope.',
      'Earth systems'
    ],
    [
      'Which statement correctly describes the hydrosphere’s scope in this lesson?',
      'It includes groundwater and atmospheric water vapor',
      'It includes only liquid water in oceans',
      'It includes only rain after it reaches the ground',
      'It includes only water outside living organisms',
      'The hydrosphere includes water in different states and locations.',
      'Hydrosphere scope'
    ],
    [
      'A soil sample contains roots, microbes, minerals, water and air. What does this illustrate?',
      'Earth systems overlap and interact',
      'Every sample belongs to only one isolated system',
      'The hydrosphere cannot occur underground',
      'Living things are separate from all physical surroundings',
      'Soil connects living, geological, water and air components.',
      'System overlap'
    ],
    [
      'What is a store in an Earth-system model?',
      'A place holding material for a time',
      'A movement of material between places',
      'A measured rate of water flow',
      'Only a transfer crossing a study boundary',
      'Stores retain material temporarily or for long periods; transfers describe movement.',
      'Stores'
    ],
    [
      'What makes a water transfer an output for a defined plot?',
      'It crosses outward through the plot’s study boundary',
      'It changes location anywhere inside the plot',
      'It becomes stored in a root within the plot',
      'It falls as rain into the plot',
      'Outputs leave the chosen system; internal movement is different.',
      'System boundaries'
    ],
    [
      'Which process transfers plant water to air as vapor?',
      'Transpiration',
      'Infiltration',
      'Surface runoff',
      'Condensation',
      'Transpiration releases water vapor from plants.',
      'Water transfers'
    ],
    [
      'What visible material makes up clouds in this lesson?',
      'Liquid droplets and/or ice crystals',
      'Only invisible water vapor',
      'Only dry atmospheric gases',
      'Only mineral dust with no water',
      'Water vapor is invisible; clouds contain condensed droplets or ice.',
      'Cloud composition'
    ],
    [
      'A plant incorporates carbon from air into sugar. Which process is responsible?',
      'Photosynthesis',
      'Respiration',
      'Decomposition',
      'Feeding on other organisms',
      'Photosynthesis uses carbon dioxide with water and light energy to form sugars.',
      'Carbon uptake'
    ],
    [
      'Which statement about plants and carbon return is correct?',
      'Plants respire and can release carbon dioxide',
      'Plants only photosynthesize and never respire',
      'Only animals take part in carbon transfers',
      'Carbon stays permanently in every leaf once absorbed',
      'Plant respiration is one return pathway within the carbon network.',
      'Respiration'
    ],
    [
      'Why should a carbon-cycle diagram include stores and branches?',
      'Carbon can follow different routes and remain stored for different times',
      'Every atom must follow one identical four-step route immediately',
      'Carbon leaves all Earth systems as sunlight',
      'Branches prove carbon is created during feeding',
      'Several pathways and storage times make the cycle a network.',
      'Cycle networks'
    ],
    [
      'Which distinction between matter and energy is accurate?',
      'Atoms can cycle through stores, while useful energy flows and spreads as heat',
      'Food energy remains permanently stored with no heat loss',
      'Matter cycles only if energy follows an identical closed loop',
      'Energy and carbon are recycled in exactly the same way',
      'Material recycling does not return energy as reusable sunlight.',
      'Matter and energy'
    ],
    [
      'A plot starts at 40 L and receives 100 L. How much is available before its stated outputs?',
      '140 L',
      '100 L',
      '60 L',
      '40 L',
      'Initial storage plus input is 40 + 100 = 140 L.',
      'Water-budget input'
    ],
    [
      'Runoff is 30 L and evaporation plus transpiration is 50 L. What is the total stated output?',
      '80 L',
      '20 L',
      '50 L',
      '150 L',
      'The two outputs add: 30 + 50 = 80 L.',
      'Water-budget output'
    ],
    [
      'Why is infiltration not subtracted as another output if water remains inside the defined plot’s soil?',
      'It is an internal transfer within that boundary',
      'Its volume is already included in vapor output',
      'All soil water is outside the plot regardless of its boundary',
      'Moving below the surface always means leaving every study system',
      'Whether a movement is input, output or internal depends on the chosen boundary.',
      'Internal transfers'
    ],
    [
      'For initial storage 40 L, input 100 L and output 80 L, what final storage and change follow?',
      '60 L final; 20 L increase',
      '20 L final; 60 L increase',
      '140 L final; 100 L increase',
      '80 L final; 40 L increase',
      '40 + 100 − 80 = 60 L; 60 − 40 = 20 L increase.',
      'Storage and change'
    ],
    [
      'A plot starts at 35 L, receives 80 L and loses 50 L. What is its final storage?',
      '65 L',
      '30 L',
      '115 L',
      '85 L',
      '35 + 80 − 50 = 65 L; 30 L is the increase, not final storage.',
      'Second budget'
    ],
    [
      'A real budget does not balance with the measured flows. What should be checked first?',
      'Overlooked flows, boundary definitions and measurement errors',
      'Remove storage entirely from the accounting',
      'Assume all rainfall disappears once it infiltrates',
      'Treat evaporation as destruction of water matter',
      'A discrepancy can reveal missing transfers or uncertain measurements.',
      'Budget uncertainty'
    ],
    [
      'Removing plant cover increases erosion at a studied site. Which connected systems directly describe soil entering runoff?',
      'Geosphere material transported by hydrosphere water',
      'Biosphere organisms carried by atmosphere winds',
      'Hydrosphere water frozen into cryosphere ice',
      'Geosphere rock transferring heat into the atmosphere',
      'Erosion moves geological material with water; vegetation change can affect that transfer.',
      'Linked effects'
    ],
    [
      'At a vulnerable site, erosion after plant loss makes regrowth harder and causes more plant loss. What is this relationship?',
      'An amplifying feedback on the initial change',
      'A one-way transfer with no returning influence',
      'A universal outcome independent of site conditions',
      'Stored water with no interaction involving organisms',
      'Effects return to influence and amplify the original change under the stated conditions.',
      'Feedback'
    ],
    [
      'Which arrow should be distinguished from water-material arrows in the landscape model?',
      'Incoming sunlight energy',
      'Water vapor leaving a leaf',
      'Rain reaching soil',
      'Runoff entering a water store',
      'Sunlight is energy input; the other arrows transfer water matter.',
      'Reading system diagrams'
    ],
    [
      'A plot starts at 35 L, gains 80 L, loses 20 L runoff and 30 L vapor. What storage increase follows?',
      '30 L',
      '65 L',
      '50 L',
      '115 L',
      'Inputs minus outputs give change: 80 − 20 − 30 = 30 L; final storage is 65 L.',
      'Mastery: change in storage'
    ],
    [
      'A learner draws plant → animal → decomposer → plant as one loop and labels every arrow sunlight. What is the essential correction?',
      'Distinguish material cycling from food-energy transfer and heat loss',
      'Label sunlight as carbon matter in every organism',
      'Remove every return of mineral material because only energy cycles',
      'Make heat return to the Sun as useful light in the same loop',
      'Materials can return through several processes; energy flows through organisms and spreads to surroundings.',
      'Mastery: matter versus energy'
    ],
    [
      'Rain enters soil, then roots, then air through leaves. Which explanation respects system interactions?',
      'Water moves through overlapping hydrosphere, geosphere, biosphere and atmosphere settings',
      'Water must stop being part of the hydrosphere when inside a plant',
      'Each stage belongs to an isolated system with no transfers',
      'The route proves every rainfall particle follows exactly that path',
      'Water connects systems, and the illustrated route is one possibility among branches and stores.',
      'Mastery: connected systems'
    ],
  ],
);
