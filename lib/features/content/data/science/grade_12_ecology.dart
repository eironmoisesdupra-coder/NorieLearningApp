import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

const Map<String, ScienceFigure> grade12EcologyFigures = {
  'sci-g12-5-sampling': ScienceFigure(
      picture: 'g12-sampling',
      title: 'Estimate density from sampled area',
      kind: 'comparison',
      labels: ['Sample', 'Density', 'Extrapolation'],
      details: [
        'Four 1 m² quadrats contain 2, 4, 3 and 3 plants.',
        '12 plants / 4 m² = 3 plants/m².',
        'For a representative sample: 300 plants in 100 m².'
      ],
      note:
          'Invented counts. The drawn quadrats show counts, not their positions in a field.'),
  'sci-g12-5-diversity': ScienceFigure(
      picture: 'g12-diversity',
      title: 'Richness and evenness answer different questions',
      kind: 'comparison',
      labels: ['Community A', 'Community B', 'Defined index'],
      details: [
        'Two species: counts 4 and 4.',
        'Two species: counts 7 and 1.',
        '1 − Σpᵢ² is 0.50 for A and 0.21875 for B.'
      ],
      note:
          'Equal sample sizes of eight. This is the squared-proportions convention, not the finite-sample pair-count estimator.'),
  'sci-g12-5-niche': ScienceFigure(
      picture: 'g12-niche',
      title: 'Test a competition explanation',
      kind: 'comparison',
      labels: ['Without competitor', 'With competitor', 'Inference'],
      details: [
        'Persistence across moisture 2–8.',
        'Persistence across moisture 5–8.',
        'A controlled comparison can test competitive restriction.'
      ],
      note:
          'Invented relative moisture units; only one niche dimension, not a universal field rule.'),
};

final NorieTopicContent grade12EcologyTopic = scienceTopic(
  grade: 'g12',
  order: 5,
  title: 'Ecology',
  subtitle: 'Estimate populations and evaluate community evidence',
  minutes: 'About 50–55 minutes',
  objectives: [
    'Estimate abundance from quadrats and mark–recapture while explaining assumptions.',
    'Calculate and interpret a clearly defined diversity index.',
    'Distinguish niche evidence from a species distribution pattern.',
    'Evaluate sustainable management using replicated ecological and social evidence.',
  ],
  introduction:
      'Two wetlands contain the same number of species. One is dominated by a single species; the other has balanced abundances. A survey also reports fewer frogs after restoration, but observers changed their search method. Ecology needs more than counts: sampling design, detection, community structure and explicit assumptions determine what those numbers mean.',
  prerequisiteTopicId: 'science.g12.geologic-processes',
  sections: [
    scienceSection('Define the population and sampling design',
        '''Abundance is the number of individuals in a defined population; density divides that number by area or volume. Before sampling, define the species, boundary, season and counting rule. A quadrat is a frame enclosing a known area, useful for plants and relatively stationary organisms. Decide how to count plants crossing an edge, then apply that rule consistently. A count of stems may differ from a count of genetically distinct plants.

Randomly chosen locations reduce convenient-site bias. If a habitat contains distinct wet and dry zones, stratified sampling selects locations within each zone and combines estimates according to zone area. Sampling only beside a path may miss the habitat interior. More quadrats improve coverage, but repeating many counts at one convenient location does not repair biased placement.'''),
    scienceVisual('sci-g12-5-sampling',
        'Connect the count to the area actually sampled before estimating a whole habitat.'),
    scienceSection('Worked example: quadrat density and extrapolation',
        '''Four randomly placed, nonoverlapping 1 m² quadrats contain 2, 4, 3 and 3 plants. Total count is 12 and sampled area is 4 m². Estimated density is 12/4 = 3 plants/m². For a representative 100 m² meadow, estimated abundance is 3 × 100 = 300 plants. This is an estimate, not a census of every plant.

Spatial clustering makes counts variable. Report the individual counts and sampling method, not just the mean. Suppose a separate meadow has a 20 m² wet zone at 5 plants/m² and an 80 m² dry zone at 1 plant/m². Estimated total is 20 × 5 + 80 × 1 = 180 plants; density is 180/100 = 1.8 plants/m². An unweighted average of 5 and 1 would incorrectly treat unequal zones as equal areas.'''),
    scienceSection('Estimate mobile populations with mark–recapture',
        '''For a simple two-sample model, capture, mark and release M individuals. After they mix back into the population, capture C individuals and count R marked recaptures. If the marked fraction R/C represents the population fraction M/N, estimated abundance is N ≈ MC/R. With M = 40, C = 50 and R = 10, N ≈ 40 × 50/10 = 200 individuals. The ten recaptures belong to the second sample of fifty; they are not fifty additional animals.

This model assumes demographic and geographic closure during sampling: no relevant births, deaths, arrivals or departures. Marks must remain recognizable, marking must not change survival or capture probability, and marked animals must mix sufficiently. Equal catchability is an important simplification. Animals that avoid traps after marking can make R too small and the estimate too large. With zero recaptures this formula cannot produce a finite estimate; it does not prove an infinite population. Small samples can also give unstable estimates.'''),
    scienceSection('Detection is part of the observation',
        '''A survey count combines abundance with the probability of detecting an individual. Frogs may call less in cooler weather even if their abundance is unchanged. Standardize effort, timing and conditions where possible; record differences that remain. Repeated surveys or appropriate detection models can help separate presence from detection. Failure to observe a species is not automatic proof of absence.

Use paper tokens for the classroom mark–recapture activity rather than handling wildlife. Mark forty tokens in a mixed bag, draw fifty without replacement within that sample, and count marked tokens. Return the sample and repeat. Compare estimates with the known bag total. Variation between draws shows sampling uncertainty even when the model assumptions are deliberately satisfied.'''),
    scienceSection('Community diversity needs a named measure',
        '''Species richness is the number of species observed. Evenness describes how evenly individuals are distributed among those species. Communities with counts 4 and 4, and 7 and 1, both have richness two and eight individuals, but their evenness differs. Compare surveys using comparable effort and identification methods because rare species are easier to miss in small samples.

Here define a Simpson diversity measure as 1 − Σpᵢ², where pᵢ is the proportion of individuals belonging to species i and Σ means add across species. Calculate each proportion, square it, add the squares, then subtract from one. Larger values indicate greater diversity under this convention. Other sources use the name Simpson index for the sum itself or its reciprocal, so always state the formula. This lesson uses squared sample proportions, not a finite-sample pair-count correction.'''),
    scienceVisual('sci-g12-5-diversity',
        'The same richness can hide a large difference in dominance.'),
    scienceSection('Guided example: compare two communities',
        '''For community A, counts 4 and 4 give proportions 0.5 and 0.5. The sum of squares is 0.25 + 0.25 = 0.50, so diversity is 0.50. For B, counts 7 and 1 give 0.875 and 0.125. Squaring and adding gives 0.765625 + 0.015625 = 0.78125; diversity is 0.21875. A is more diverse under this measure because it is more even.

If all individuals belong to one species, the value is 1 − 1² = 0. Two equally abundant species give 0.5, not one. The index is not a percentage of ecosystem health. A high value cannot alone establish native-species recovery, water quality or resilience. Record species identities and other relevant indicators alongside the index.'''),
    scienceSection('A niche is more than a location',
        '''A habitat describes where an organism lives. Its niche concerns the resources, conditions and interactions associated with persistence and reproduction. A fundamental niche describes conditions permitting persistence without restricting biotic interactions in the simplified model used here. A realized niche reflects the interactions actually present. Competition can restrict resource use; different feeding times or resources can allow species to coexist.

Imagine a plant persisting across relative soil moisture values 2–8 without a competitor but only 5–8 with that competitor. This supports competitive restriction if other conditions are controlled. A field distribution alone is weaker evidence: seed arrival, herbivory or unmeasured soil chemistry might explain the pattern. The diagram illustrates one dimension and one competition mechanism, not a rule that every interaction always narrows every niche.'''),
    scienceVisual('sci-g12-5-niche',
        'Compare a proposed mechanism with alternative explanations and a controlled test.'),
    scienceSection('Sustainability is a monitored decision',
        '''Sustainable management aims to maintain ecological functions and resources over time while considering human needs. Harvest below an estimated population increase is not automatically safe: the estimate may be biased, recruitment varies, and other mortality continues. Monitor abundance, recruitment, habitat condition and harvest effort, and revise limits when evidence changes. A short-term increase in yield can conceal declining breeding stock.

For restoration, compare repeated before-and-after observations at multiple treated and comparable untreated sites. Standardize sampling and examine rainfall, detection and land-use differences. Include native-species composition, water quality and effects on local livelihoods rather than declaring success from one diversity score. Define the objective in advance, measure relevant outcomes, and adapt management transparently when results contradict predictions.'''),
    scienceSection('Common mistakes and quick check',
        '''A larger sample does not automatically remove placement bias. A low recapture fraction can reflect capture behavior rather than a huge population. Equal richness does not imply equal evenness, and a diversity index is not a universal health score. A restricted distribution does not alone prove competition.

Try this: twenty individuals are marked; a later sample contains thirty, of which six are marked. Estimate abundance and name one assumption. Then calculate the defined diversity measure for counts 3 and 3. Explain why neither answer is a complete management recommendation.'''),
    scienceSection('Reveal: connect numbers to assumptions',
        '''Mark–recapture gives 20 × 30/6 = 100 individuals, assuming closure, mixing and suitable capture probabilities with retained marks. Counts 3 and 3 give proportions 0.5 and 0.5, so diversity is 0.50. These calculations summarize particular evidence; management also needs uncertainty, species identities, habitat conditions and the consequences of an action.''',
        reveal: true),
    scienceSection('Recap: infer carefully, then monitor',
        '''Define the population and sample area, account for spatial structure, and distinguish observation from detection. Estimate abundance with explicit assumptions. Name a diversity formula and interpret richness and evenness separately. Test niche mechanisms rather than inferring them from location alone. Sustainable decisions connect repeated ecological evidence with clear objectives, human needs and revision when conditions change.'''),
  ],
  keyConcept:
      'Ecological estimates depend on sampling and detection. Quantitative diversity and niche models become useful management evidence when their assumptions, uncertainty and ecological context remain explicit.',
  questions: [
    [
      'What does population density express?',
      'Individuals per unit area or volume',
      'The number of different species only',
      'The fraction of marked animals only',
      'The total area without a count',
      'Density relates abundance to the area or volume occupied.',
      'Population density'
    ],
    [
      'Which sampling tool best fits stationary meadow plants?',
      'Quadrats of known area',
      'A count of calls with no area record',
      'A trap-response score alone',
      'A harvest total without effort',
      'Quadrats connect stationary-organism counts to known sampled areas.',
      'Quadrat sampling'
    ],
    [
      'What is species richness?',
      'The number of species observed',
      'The fraction belonging to the dominant species',
      'The total count of all individuals',
      'The area of the most common habitat',
      'Richness counts species, whereas abundance counts individuals.',
      'Richness and evenness'
    ],
    [
      'What does evenness describe?',
      'How balanced species abundances are',
      'How equal all quadrat areas are',
      'How many habitat zones exist',
      'How long sampling takes',
      'Evenness describes the distribution of individuals among species.',
      'Richness and evenness'
    ],
    [
      'Which condition belongs to the simple closed mark–recapture model?',
      'No relevant population gains or losses between samples',
      'All marks disappear before recapture',
      'Marked animals avoid every trap',
      'New individuals enter throughout sampling',
      'Closure excludes relevant births, deaths and movements during the estimation interval.',
      'Mark recapture assumptions'
    ],
    [
      'Why can a frog survey miss a present species?',
      'Detection is imperfect under the survey conditions',
      'Presence guarantees a call at every visit',
      'Every missing record proves local extinction',
      'Counting effort never affects observations',
      'An organism can be present without being detected, for example when it does not call.',
      'Detection'
    ],
    [
      'Which statement best describes an ecological niche?',
      'Conditions, resources and interactions supporting persistence',
      'Only the map coordinate of a sighting',
      'Only the number of individuals captured',
      'Only the physical area of a quadrat',
      'A niche concerns persistence and resource use, beyond the location called habitat.',
      'Ecological niche'
    ],
    [
      'Twelve plants occur in four 1 m² quadrats. What is estimated density?',
      '3 plants/m²',
      '12 plants/m²',
      '4 plants/m²',
      '48 plants/m²',
      'Divide twelve counted plants by the four square meters sampled.',
      'Quadrat calculation'
    ],
    [
      'A representative density is 3 plants/m² across 100 m². What abundance is estimated?',
      '300 plants',
      '30 plants',
      '103 plants',
      '0.03 plants',
      'Multiply density by habitat area: 3 × 100 = 300 plants.',
      'Quadrat extrapolation'
    ],
    [
      'For M = 40, C = 50 and R = 10, what is the simple abundance estimate?',
      '200 individuals',
      '20 individuals',
      '90 individuals',
      '500 individuals',
      'Use MC/R: 40 × 50 divided by 10 gives 200 individuals.',
      'Mark recapture calculation'
    ],
    [
      'Counts 4 and 4 give what value of 1 − Σpᵢ²?',
      '0.50',
      '0.25',
      '0.75',
      '1.00',
      'Each proportion is one half; subtract 0.25 + 0.25 from one.',
      'Diversity calculation'
    ],
    [
      'Counts 7 and 1, compared with 4 and 4, have which property?',
      'Equal richness but lower evenness',
      'Greater richness and equal evenness',
      'Lower richness and greater evenness',
      'Equal richness and equal evenness',
      'Both contain two species, but seven-to-one abundance is less balanced.',
      'Diversity interpretation'
    ],
    [
      'If all sampled individuals belong to one species, what is 1 − Σpᵢ²?',
      '0',
      '0.5',
      '1',
      '2',
      'The single species has proportion one, so the index is 1 minus 1 squared.',
      'Diversity calculation'
    ],
    [
      'A plant persists at moisture 2–8 alone and 5–8 with a competitor. What does a controlled comparison support?',
      'Competition restricts persistence in part of the tested interval',
      'Competition expands persistence below moisture 2',
      'Moisture never affects this plant',
      'The realized interval spans all moisture values',
      'The competitor treatment removes persistence from the lower part of the tested range.',
      'Niche comparison'
    ],
    [
      'A wet zone is 20 m² at 5 plants/m²; a dry zone is 80 m² at 1 plant/m². What total is estimated?',
      '180 plants',
      '300 plants',
      '600 plants',
      '120 plants',
      'Weight by area: 20 × 5 plus 80 × 1 equals 180 plants.',
      'Stratified estimate'
    ],
    [
      'Marked animals avoid traps after release. Holding M and C fixed, how can this affect MC/R?',
      'Smaller R can bias the estimate upward',
      'Smaller R must make the estimate smaller',
      'Trap behavior cannot affect R',
      'The formula becomes an exact census',
      'Recaptures enter the denominator; fewer recaptures increase the calculated estimate.',
      'Assumption violations'
    ],
    [
      'A survey gets zero marked recaptures. What is justified?',
      'This formula cannot give a finite abundance estimate',
      'The population is proven infinite',
      'The population contains no unmarked animals',
      'Abundance must equal the first sample size',
      'Division by zero prevents this estimate; zero recaptures do not prove an infinite population.',
      'Estimator limitations'
    ],
    [
      'One hundred quadrats are all placed beside a path. What is the main concern?',
      'More samples may preserve the same location bias',
      'Sample size guarantees habitat representation',
      'Density cannot be calculated from quadrats',
      'Every quadrat must contain equal counts',
      'Repeated convenient placement can miss systematically different interior habitat.',
      'Sampling bias'
    ],
    [
      'A restored wetland has a higher diversity index. Which evidence is still needed for native recovery?',
      'Species identities and comparable repeated surveys',
      'Only more decimal places in the same index',
      'A different index name without a formula',
      'Only the largest individual organism',
      'A diversity score does not identify native species or establish a restoration effect.',
      'Management evidence'
    ],
    [
      'A plant is absent from a dry site. Which investigation best tests competition as the cause?',
      'Compare competitor presence and removal while controlling other conditions',
      'Assume the distribution proves competition',
      'Count only plants where they already thrive',
      'Change water and competitors together without comparison',
      'A controlled competitor comparison helps separate competition from moisture and other causes.',
      'Niche evidence'
    ],
    [
      'Twenty marked animals mix into a closed population; thirty are sampled with six recaptures. Estimate abundance.',
      '100 individuals',
      '60 individuals',
      '150 individuals',
      '600 individuals',
      'MC/R = 20 × 30/6 = 100, conditional on the model assumptions.',
      'Mark recapture mastery'
    ],
    [
      'Two communities have counts 3:3 and 5:1. Using 1 − Σpᵢ², which has the higher value?',
      '3:3 because abundances are more even',
      '5:1 because dominance always increases this index',
      'Both because equal richness fixes the index',
      'Neither because sample size must exceed ten',
      'The 3:3 community has value 0.50; 5:1 has 1 − 26/36, about 0.278.',
      'Diversity mastery'
    ],
    [
      'Which plan best supports sustainable harvest decisions?',
      'Monitor abundance, recruitment, habitat and effort, then revise limits',
      'Set permanent limits from one high count',
      'Use yield alone even if breeding stock falls',
      'Ignore detection when survey methods change',
      'Monitoring multiple relevant indicators helps detect changing conditions and revise decisions.',
      'Sustainability mastery'
    ],
  ],
);
