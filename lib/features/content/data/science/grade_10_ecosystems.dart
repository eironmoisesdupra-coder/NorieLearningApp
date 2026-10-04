import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

const Map<String, ScienceFigure> grade10EcosystemsFigures = {
  'sci-g10-5-population': ScienceFigure(
      picture: 'g10-population',
      title: 'Interpret a population plateau',
      kind: 'comparison',
      labels: ['Early increase', 'Slowing growth', 'Limits of inference'],
      details: [
        'Counts rise from 20 to 40 to 65 rabbits.',
        'Counts then reach 80 and remain at 80 in the next survey.',
        'Measure resources and movement before naming the cause.'
      ],
      note:
          'Invented annual counts for the same area; all bars use a common zero and 100-rabbit maximum.'),
  'sci-g10-5-energy': ScienceFigure(
      picture: 'g10-energy',
      title: 'Calculate transfers from supplied production',
      kind: 'comparison',
      labels: ['Producers', 'Herbivores', 'Secondary consumers'],
      details: ['10,000 kJ/m²/year.', '1,500 kJ/m²/year.', '150 kJ/m²/year.'],
      note:
          'Same area and interval. These invented values give successive transfers of 15% and 10%, not a universal ten-percent law.'),
  'sci-g10-5-cascade': ScienceFigure(
      picture: 'g10-cascade',
      title: 'Trace an indirect effect through a community',
      kind: 'process',
      labels: ['More predators', 'Fewer herbivores', 'More plant biomass'],
      details: [
        'Predation can reduce herbivore abundance.',
        'Lower herbivore abundance can reduce grazing.',
        'Reduced grazing can allow plants to accumulate biomass.'
      ],
      note:
          'A conditional causal model, not an energy-flow diagram or guaranteed field result. Drought and other interactions also matter.'),
};

final NorieTopicContent grade10EcosystemsTopic = scienceTopic(
  grade: 'g10',
  order: 5,
  title: 'Ecosystems',
  subtitle:
      'Connect population limits, energy budgets and evidence for conservation',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Explain how resources and population density affect growth and carrying capacity.',
    'Calculate trophic transfer efficiencies from supplied production values and units.',
    'Distinguish standing biomass from an energy production rate.',
    'Predict indirect community effects and evaluate conservation evidence.',
  ],
  introduction:
      'A fenced grassland gains rabbits, then their numbers level off. Is food running short, are predators increasing, or did rabbits move out through a broken fence? A count is evidence, but it does not explain itself. Connect population change with resources, energy and interactions before choosing a conservation action.',
  prerequisiteTopicId: 'science.g10.electricity-magnetism',
  sections: [
    scienceSection('Population change has several terms',
        '''A population consists of members of one species in an area. A community includes interacting populations; an ecosystem also includes water, soil, climate and other nonliving surroundings. Population change equals births plus immigration minus deaths minus emigration. Immigration means entry, and emigration means departure. A stable count can hide substantial births, deaths and movement.

For example, begin with 80 rabbits. During one interval, 12 are born, 3 arrive, 10 die and 5 leave. The net change is 12 + 3 − 10 − 5 = 0, so the final count remains 80. Zero net change does not mean that nothing happened. Use the same area, interval and survey method when comparing counts.'''),
    scienceSection('Resources set changing limits',
        '''When resources are plentiful, more breeding individuals can produce larger population increases. Unlimited growth cannot continue indefinitely in a finite habitat. Food, water, shelter and nesting space can become limiting factors. Competition for a limited resource often becomes stronger as population density rises. Disease transmission can also increase with crowding; these are examples of density-dependent effects.

Carrying capacity is the population an environment can sustain under its current conditions. It is not a permanent number stamped on a habitat. A drought can reduce plant growth and lower the resources available to herbivores. A storm may affect populations without being caused by their density. Real populations may fluctuate around, or temporarily exceed, a resource-supported level; the smooth leveling curve is a simplified model.'''),
    scienceVisual('sci-g10-5-population',
        'Describe the pattern first; investigate its cause separately.'),
    scienceSection('Worked example: a plateau is evidence, not a diagnosis',
        '''In an invented survey, rabbit counts in years 0, 1, 2, 3 and 4 are 20, 40, 65, 80 and 80. Subtract consecutive counts: increases are 20, 25, 15 and 0 rabbits. Growth slows late in this record. Limited resources could explain the plateau, but predation, disease or migration could also contribute.

To distinguish explanations, measure available vegetation and rainfall, record predator activity, and check whether the survey missed animals. Two counts of 80 do not prove an exact carrying capacity of 80 forever. A longer record and independent measurements strengthen an explanation. Carrying capacity concerns sustainable conditions, not simply the largest number ever observed.'''),
    scienceSection('Energy production differs from biomass',
        '''Producers capture energy, usually from sunlight, and store some as chemical energy in organic matter. Primary consumers feed on producers; secondary consumers feed on primary consumers. A trophic level describes a feeding position, and an omnivore may feed at more than one level. Food-web arrows usually point from the eaten resource toward the consumer receiving energy.

Standing biomass is the mass of living material present at a particular time, commonly expressed as dry grams per square meter, g/m². Production measures new material or its energy accumulated over an interval. Here we use kilojoules per square meter per year, kJ/m²/year. Comparing these production rates requires matching area and time. A small standing stock can produce material rapidly, so biomass alone cannot reveal annual energy transfer.'''),
    scienceVisual('sci-g10-5-energy',
        'Read the shared units before dividing one trophic production rate by another.'),
    scienceSection('Worked example: calculate, do not assume, efficiency',
        '''Use supplied annual production: producers 10,000, herbivores 1,500, and secondary consumers 150 kJ/m²/year. Transfer efficiency equals production at the receiving level divided by production at the preceding level, multiplied by 100. First transfer: 1,500 ÷ 10,000 × 100 = 15%. Second transfer: 150 ÷ 1,500 × 100 = 10%. The values differ; ten percent is not a universal law.

Across both transfers, secondary-consumer production is 150 ÷ 10,000 × 100 = 1.5% of producer production. Not all production is eaten, and not all eaten material is assimilated. Organisms also use energy in respiration, releasing heat. Uneaten remains and wastes can feed detrital and decomposer pathways. Energy is conserved overall but is not all available as production at the next feeding level.'''),
    scienceSection('Guided example: keep the denominator meaningful',
        '''A second supplied system has producer production of 8,000 kJ/m²/year and herbivore production of 1,600 kJ/m²/year. Identify the receiving level first: herbivores. Divide 1,600 by 8,000 to obtain 0.20, then multiply by 100: 20% transfer. If secondary-consumer production is 240 in the same units, the next transfer is 240 ÷ 1,600 × 100 = 15%.

Across the whole chain, 240 ÷ 8,000 × 100 = 3%. Using 8,000 as the denominator for the second transfer would answer a different question. These percentages describe the supplied model. They do not predict every grassland, season or food web, and grams of standing biomass cannot be substituted for these energy rates.'''),
    scienceSection('Interactions create indirect effects',
        '''Predation benefits a consumer while harming its prey. Competition can reduce both competitors' access to limited resources. In mutualism, both interacting species benefit; animal pollination can provide food to an animal while assisting plant reproduction. These interactions connect population changes across a community.

A trophic cascade is an indirect effect transmitted through feeding relationships. More predators can reduce herbivores; reduced grazing can then increase plant biomass. That is a conditional prediction, not a guarantee. Drought could limit plants even when herbivores decline. Alternative prey, movement and changes in behavior can modify the chain. Distinguish arrows showing causal effects in a cascade from arrows showing the direction of energy transfer in a food web.'''),
    scienceVisual('sci-g10-5-cascade',
        'A predator can affect plants indirectly through herbivore grazing.'),
    scienceSection('Disturbance and conservation need comparisons',
        '''A disturbance such as fire, flooding or habitat clearing changes resources and community conditions. Effects depend on intensity, extent and timing; recovery need not restore exactly the previous community. Conservation should address measured pressures and monitor outcomes, rather than assume every population responds identically.

Suppose native plant cover rises from 30% to 50% at a restored site, while a comparable untreated site rises from 30% to 35%. The restored site gains 20 percentage points; the untreated site gains 5. The difference in changes is 15 percentage points. This is consistent with a restoration benefit, but sites may differ in rainfall or grazing. Replicated comparable sites, repeated surveys and records of these factors make the inference stronger.'''),
    scienceSection('Paper activity and common mistakes',
        '''Draw the rabbit bars and list two competing explanations for the plateau. Next draw three production bars using the first energy dataset and calculate each transfer. Finally predict what might happen to plants if herbivores decline during severe drought. Explain why less grazing alone cannot guarantee increased plant growth.

Correct three errors: a stable population still has individual turnover; carrying capacity can change when conditions change; and energy flows through an ecosystem while matter can be recycled. Do not describe energy as returning unchanged to producers through decomposers. Do not label a 20-percentage-point cover increase a 20% relative increase; the two calculations use different denominators.'''),
    scienceSection(
        'Quick check: reveal your reasoning',
        '''A model has producer production of 6,000 and herbivore production of 900 kJ/m²/year. What transfer efficiency follows, and would a measured 900 g/m² of herbivore biomass answer the same question?

900 ÷ 6,000 × 100 = 15%. A standing biomass of 900 g/m² is a mass snapshot, not annual energy production, so it cannot replace the numerator. Check the quantity and units before calculating.''',
        reveal: true),
    scienceSection('Recap: connect budgets with evidence',
        '''Births, deaths and movement change populations. Resources and interactions create limits that shift with conditions. Energy production rates support transfer calculations; standing biomass measures a different quantity. Cascades predict indirect effects with assumptions. Strong conservation conclusions compare repeated measurements and alternative explanations, linking an action to evidence rather than to a single attractive story.'''),
  ],
  keyConcept:
      'Ecosystem explanations connect changing populations, resource limits and measured energy transfers. Quantitative comparisons and competing explanations help distinguish plausible predictions from supported conservation conclusions.',
  questions: [
    [
      'What can an unchanged count of 80 rabbits conceal?',
      'Births and arrivals balanced by deaths and departures',
      'The absence of every birth and death',
      'Unlimited resources for every rabbit',
      'A permanent carrying capacity of exactly 80',
      'Population size is a net result; opposing gains and losses can leave the total unchanged.',
      'Population balance'
    ],
    [
      'Which process adds individuals by movement into the surveyed habitat?',
      'Immigration',
      'Emigration',
      'Respiration',
      'Predation',
      'Immigration adds arriving individuals, whereas emigration removes departing individuals.',
      'Population balance'
    ],
    [
      'Which condition can make competition stronger as rabbits become crowded?',
      'Limited food shared by more individuals',
      'Food supply increasing without limit',
      'Every individual using different unlimited resources',
      'No individuals needing food',
      'Density-dependent competition becomes stronger when more individuals share a limited resource.',
      'Limiting factors'
    ],
    [
      'A long drought reduces available vegetation. What can happen to rabbit carrying capacity?',
      'It can decrease under the new resource conditions',
      'It must remain fixed forever',
      'It must equal the highest historical count',
      'It becomes independent of food',
      'Carrying capacity depends on current conditions; reduced vegetation can support fewer herbivores.',
      'Carrying capacity'
    ],
    [
      'Which unit describes a snapshot of dry standing plant biomass?',
      'g/m²',
      'kJ/m²/year',
      'Rabbits/year',
      'Percent transfer per consumer',
      'Grams per square meter measure mass present per area, not an annual energy production rate.',
      'Biomass and production'
    ],
    [
      'Which statement distinguishes energy from matter in an ecosystem?',
      'Matter can cycle while energy transfers include heat release',
      'Energy returns unchanged from decomposers to sunlight',
      'Both remain entirely inside one organism',
      'Matter is created whenever an animal eats',
      'Matter can be recycled; energy flows through pathways and much becomes dispersed as heat.',
      'Energy flow'
    ],
    [
      'Why is the predator-to-plant effect in the cascade indirect?',
      'It passes through changes in herbivore grazing',
      'Predators produce sunlight for plants',
      'Plants receive no environmental influences',
      'Predators are always the producers',
      'Predators can influence herbivores, which change grazing pressure on plants.',
      'Trophic cascades'
    ],
    [
      'Start with 80 rabbits: 12 births, 3 arrivals, 10 deaths and 5 departures. What is the final count?',
      '80 rabbits',
      '95 rabbits',
      '65 rabbits',
      '110 rabbits',
      'Calculate 80 + 12 + 3 − 10 − 5 = 80; gains and losses balance in this interval.',
      'Population balance'
    ],
    [
      'Rabbit counts rise from 65 to 80 in one year. What is the net increase?',
      '15 rabbits',
      '25 rabbits',
      '65 rabbits',
      '145 rabbits',
      'Subtract the earlier count from the later count: 80 − 65 = 15 rabbits.',
      'Population data'
    ],
    [
      'In the supplied chain, producers produce 10,000 and herbivores 1,500 kJ/m²/year. What is the transfer?',
      '15%',
      '10%',
      '1.5%',
      '85%',
      'Divide receiving production by preceding production: 1,500 ÷ 10,000 × 100 = 15%.',
      'Transfer efficiency'
    ],
    [
      'Secondary consumers produce 150 while herbivores produce 1,500 kJ/m²/year. What is this transfer?',
      '10%',
      '15%',
      '1.5%',
      '90%',
      'For this adjacent transfer use herbivores as denominator: 150 ÷ 1,500 × 100 = 10%.',
      'Transfer efficiency'
    ],
    [
      'Producer and secondary-consumer production are 10,000 and 150 kJ/m²/year. What fraction as a percentage reaches the final level?',
      '1.5%',
      '10%',
      '15%',
      '25%',
      'Across the two transfers, compare final with initial production: 150 ÷ 10,000 × 100 = 1.5%.',
      'Whole-chain transfer'
    ],
    [
      'Why can 900 g/m² of biomass not replace 900 kJ/m²/year in the transfer calculation?',
      'Mass at one time differs from energy produced per time',
      'The two units are always interchangeable',
      'Every gram always contains one kilojoule',
      'Time never matters in production',
      'A biomass snapshot and annual energy production are different quantities with different units.',
      'Biomass and production'
    ],
    [
      'Both a pollinator feeding and a plant reproducing benefit from their interaction. Which relationship fits?',
      'Mutualism',
      'Competition',
      'Predation on the pollinator',
      'Emigration',
      'Mutualism describes benefits to both participants, as in this supplied pollination example.',
      'Species interactions'
    ],
    [
      'Two yearly rabbit counts are 80. Which next step best tests a resource-limitation explanation?',
      'Measure food availability and track other gains and losses',
      'Declare carrying capacity permanently fixed at 80',
      'Assume no births occurred in either year',
      'Stop surveying because all causes are known',
      'Independent resource and population measurements can distinguish resource limitation from other explanations.',
      'Evaluating evidence'
    ],
    [
      'A second chain has production 8,000 → 1,600 → 240 kJ/m²/year. What is the second transfer efficiency?',
      '15%',
      '20%',
      '3%',
      '35%',
      'The second transfer compares 240 with 1,600, giving 15%; 3% would compare final with initial.',
      'Transfer efficiency'
    ],
    [
      'Herbivores decline, but a severe drought continues. Which plant prediction is justified?',
      'Less grazing may help, but water limitation can prevent growth',
      'Plant biomass must rise by exactly 10%',
      'All plants must disappear immediately',
      'Predators now directly supply water to plants',
      'Reduced grazing can help plants, but drought is another limiting factor that may dominate the response.',
      'Conditional predictions'
    ],
    [
      'Restored plant cover changes 30%→50%; untreated cover changes 30%→35%. What is the difference in changes?',
      '15 percentage points',
      '20 percentage points',
      '5 percentage points',
      '85 percentage points',
      'Restored gain is 20 points and untreated gain is 5 points; their difference is 15 percentage points.',
      'Conservation data'
    ],
    [
      'Which study improvement best strengthens that restoration comparison?',
      'Repeat measurements across multiple comparable sites',
      'Use only the largest restored-site result',
      'Ignore rainfall and grazing differences',
      'Replace all measured values with an assumed ten percent',
      'Replication and repeated comparable surveys help separate an intervention effect from site differences and chance.',
      'Evaluating evidence'
    ],
    [
      'Why does energy not transferred to the next consumer level still matter ecologically?',
      'Some enters detrital pathways and some disperses as heat',
      'It is all destroyed when an organism breathes',
      'It all becomes next-level production automatically',
      'It always returns unchanged as sunlight',
      'Uneaten material and waste can support decomposers, while respiration releases energy as heat.',
      'Energy pathways'
    ],
    [
      'A new habitat has 60 rabbits, 9 births, 4 arrivals, 7 deaths and 2 departures. Predict the final count.',
      '64 rabbits',
      '60 rabbits',
      '73 rabbits',
      '51 rabbits',
      'Apply all four terms: 60 + 9 + 4 − 7 − 2 = 64 rabbits.',
      'Population balance'
    ],
    [
      'A supplied chain has producer production 5,000 and herbivore production 1,000 kJ/m²/year. Which conclusion follows?',
      'Its first transfer is 20%, calculated from the supplied rates',
      'Every ecosystem has a 20% transfer',
      'Its transfer is 10% regardless of the data',
      'Its herbivore standing biomass must be 1,000 g/m²',
      '1,000 ÷ 5,000 × 100 = 20%; this rate calculation establishes neither a universal rule nor standing biomass.',
      'Transfer efficiency'
    ],
    [
      'Predators increased and plants grew at one site, but rainfall also increased. What is the strongest interpretation?',
      'A cascade is plausible, but rainfall and herbivore data must also be examined',
      'Predators alone are proven to cause all plant growth',
      'Rainfall rules out every predator effect',
      'Plant growth proves a fixed carrying capacity',
      'A causal explanation must consider alternative factors; herbivore and rainfall measurements can test the cascade.',
      'Evaluating evidence'
    ],
  ],
);
