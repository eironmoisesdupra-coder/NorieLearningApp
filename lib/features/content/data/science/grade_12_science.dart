import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';
import 'grade_12_ecology.dart';

final List<NorieTopicContent> grade12ScienceTopics = [
  _genetics,
  _equilibrium,
  _fields,
  _geology,
  grade12EcologyTopic,
];

const Map<String, ScienceFigure> grade12ScienceFigures = {
  'g12_genetics_flow': ScienceFigure(
      picture: 'g12-genetics',
      title: 'Read the template, then decode RNA',
      kind: 'process',
      labels: ['DNA template', 'Messenger RNA', 'Peptide'],
      details: [
        "3′-TAC CTT-5′ is read by RNA polymerase.",
        "5′-AUG GAA-3′ is synthesized and read in this frame.",
        'AUG specifies methionine; GAA specifies glutamate.'
      ],
      note:
          'Short coding-region model; RNA synthesis and ribosome reading proceed 5′ to 3′.'),
  'g12_genetics_regulation': ScienceFigure(
      title: 'Sequence and expression are different measurements',
      kind: 'comparison',
      labels: [
        'Same coding sequence',
        'Different RNA amount',
        'Different protein amount'
      ],
      details: [
        'Two cell types can carry the same gene.',
        'Regulatory proteins can alter transcription.',
        'Translation and protein breakdown also affect abundance.'
      ],
      note: 'RNA abundance alone does not establish protein activity.'),
  'g12_genetics_inheritance': ScienceFigure(
      title: 'Connect an allele to evidence',
      kind: 'process',
      labels: [
        'Inherited sequence',
        'Molecular consequence',
        'Observed phenotype'
      ],
      details: [
        'An allele can be transmitted in a gamete.',
        'A substitution may alter a codon or a regulatory site.',
        'Protein function and environment contribute to the trait.'
      ],
      note:
          'Association supports a hypothesis; controlled functional evidence strengthens a causal explanation.'),
  'g12_equilibrium_dynamic': ScienceFigure(
      picture: 'g12-equilibrium',
      title: 'Equal rates do not require equal amounts',
      kind: 'comparison',
      labels: [
        'A concentration',
        'B concentration',
        'Forward and reverse rates'
      ],
      details: [
        '0.20 mol/L at equilibrium.',
        '0.80 mol/L at equilibrium.',
        'Equal nonzero rates maintain these concentrations.'
      ],
      note: 'For A ⇌ B at this temperature, Kc = [B]/[A] = 4.'),
  'g12_equilibrium_quotient': ScienceFigure(
      title: 'Compare the present quotient with the target ratio',
      kind: 'comparison',
      labels: ['Q < K', 'Q = K', 'Q > K'],
      details: [
        'Net forward change increases the product ratio.',
        'The composition is at equilibrium.',
        'Net reverse change decreases the product ratio.'
      ],
      note:
          'Use the same balanced equation, concentration convention and temperature.'),
  'g12_equilibrium_stress': ScienceFigure(
      title: 'Distinguish composition, constant and speed',
      kind: 'comparison',
      labels: ['Add a reactant', 'Change temperature', 'Add a catalyst'],
      details: [
        'Changes Q immediately; K stays fixed at the same temperature.',
        'Can change K and the final equilibrium composition.',
        'Speeds approach to equilibrium without changing K.'
      ],
      note:
          'Pressure rules require a gaseous system and a specified change of volume or partial pressure.'),
  'g12_fields_vectors': ScienceFigure(
      picture: 'g12-fields',
      title: 'Opposite charges: midpoint field contributions add',
      kind: 'comparison',
      labels: [
        'Positive source at left',
        'Negative source at right',
        'Midpoint net field'
      ],
      details: [
        'Its field at the midpoint points right, away from positive.',
        'Its field at the midpoint points right, toward negative.',
        'Equal rightward contributions add; they do not cancel.'
      ],
      note:
          'Fixed equal-magnitude sources; field direction is defined using a positive test charge.'),
  'g12_fields_force': ScienceFigure(
      title: 'One field, opposite test-charge forces',
      kind: 'comparison',
      labels: [
        'Field +300 N/C',
        'Charge +2 microcoulombs',
        'Charge −2 microcoulombs'
      ],
      details: [
        'Rightward field at the chosen point.',
        'Force +0.0006 N, rightward.',
        'Force −0.0006 N, leftward.'
      ],
      note:
          'F = qE; a small test charge is assumed not to rearrange the sources.'),
  'g12_fields_potential': ScienceFigure(
      title: 'Potential decreases along a uniform field',
      kind: 'process',
      labels: ['Start at 10 V', 'Move 0.02 m right', 'Finish at 6 V'],
      details: [
        'Uniform electric field points right.',
        'E = 200 N/C; potential change = −Ed.',
        'Potential drop is 4 V; charge determines the energy change.'
      ],
      note:
          'Electrostatic field; displacement parallel to the field; edge effects neglected.'),
  'g12_geology_sequence': ScienceFigure(
      title: 'Combine relative-age clues',
      kind: 'process',
      labels: [
        'Deposit layers',
        'Cut layers with intrusion',
        'Erode and redeposit'
      ],
      details: [
        'In an undeformed sequence, lower layers formed earlier.',
        'The intrusion is younger than the layers it cuts.',
        'An erosion surface can represent missing time.'
      ],
      note:
          'Check overturning and other disturbances before applying a simple layer-order rule.'),
  'g12_geology_clock': ScienceFigure(
      picture: 'g12-geology',
      title: 'A half-life removes half of the parent remaining',
      kind: 'bars',
      labels: ['Clock starts', 'One half-life', 'Two half-lives'],
      details: [
        '100% parent remains.',
        '50% parent remains.',
        '25% parent remains.'
      ],
      values: [100, 50, 25],
      unit: '% parent',
      note:
          'Ideal closed mineral; known half-life and initial parent amount. Daughter shown in the picture assumes none initially.'),
  'g12_geology_hazard': ScienceFigure(
      title: 'A damaging event and its consequences are separate',
      kind: 'comparison',
      labels: ['Hazard', 'Exposure', 'Vulnerability'],
      details: [
        'Likelihood and intensity of a potentially damaging process.',
        'People and structures located where it can occur.',
        'How susceptible those exposed elements are to damage.'
      ],
      note:
          'A hazard probability over decades is not an exact earthquake date.'),
  ...grade12EcologyFigures,
};

final _geology = scienceTopic(
  grade: 'g12',
  order: 4,
  title: 'Geologic Processes',
  subtitle:
      'Reconstruct events, calculate rates and evaluate uncertain hazards',
  minutes: '35–40 minutes',
  prerequisiteTopicId: 'science.g12.electric-fields',
  objectives: [
    'Reconstruct relative event order from layers and crosscutting relationships.',
    'Interpret radiometric ages using half-lives and closure assumptions.',
    'Calculate average geologic rates with consistent units.',
    'Distinguish hazard, exposure and vulnerability in evidence-based decisions.'
  ],
  introduction:
      'A cliff may preserve millions of years in a few layers, omit a long interval at an erosion surface, and record an intrusion that formed much later. A nearby fault can accumulate strain slowly and release it rapidly. Geologists combine different clocks and physical clues to explain both deep history and present hazards without pretending to know every event date.',
  sections: [
    scienceSection('Processes operate on different timescales',
        '''Weathering breaks down or chemically changes rock near the surface. Erosion removes and transports material; deposition leaves it elsewhere. Tectonic uplift can expose buried rock, while subsidence creates space for sediment to accumulate. Internal energy drives processes associated with plate motion and magmatism; solar energy and gravity support many surface processes. These systems interact rather than operating as unrelated cycles.

A slow average process can include rapid episodes. A river may move much of its sediment during a few floods, and a fault can release accumulated deformation in a short earthquake. Inferring a long-term average does not imply a constant speed at every moment. Present processes help interpret ancient evidence, but past rates and environmental conditions need not match those measured today.'''),
    scienceSection('Read relative age before assigning a number',
        '''In an undeformed sedimentary sequence that has not been overturned, lower layers were deposited before layers above them: superposition. A feature that cuts another feature is younger than what it cuts. An igneous intrusion cutting two layers therefore formed after both layers existed. Rock fragments enclosed inside another rock generally existed before the enclosing rock formed; these are inclusions.

An unconformity is a surface representing a break in the geologic record through erosion or nondeposition. It can hide events and time rather than representing instantaneous contact. Before ordering events, inspect folding, faulting and possible overturning. Relative-age principles give an order constrained by observations, not numerical dates or a guarantee that every historical event was preserved.'''),
    scienceVisual('g12_geology_sequence',
        'A crosscutting intrusion must postdate the layers it cuts; an erosion surface can remove part of the earlier record.'),
    scienceSection('Worked example: build a defensible sequence',
        '''Imagine lower sandstone S overlain by shale H in an upright sequence. A dike D cuts both S and H. An erosion surface truncates the dike and both layers; horizontal gravel G rests on that surface and is not cut by D. First apply superposition: S precedes H. Then apply crosscutting: D follows both. Truncation shows erosion follows D. Finally, deposition of G follows creation of the surface. The supported order is S, H, D, erosion, G.

This diagram does not reveal the duration between events. A thin gravel layer can be young above much older rock, and a narrow contact can represent a long missing interval. If a fault later cuts G and D, that fault movement is younger than both. If instead the fault is sealed beneath G, the observed movement preceded G. Describe the observed relationship before inferring its history.'''),
    scienceSection('Radioactive decay gives a quantitative clock',
        '''An unstable parent isotope decays into daughter products at a characteristic statistical rate. The half-life is the time for half of a large population of parent atoms to decay. After one half-life, one half remains; after two, one quarter; after three, one eighth. Equal intervals remove equal fractions of the parent remaining, not equal numbers of atoms. Individual decay events are unpredictable even though large populations follow a reliable pattern.

For an ideal closed mineral with known initial parent amount, parent fraction remaining is (1/2)^n after n half-lives. If one quarter remains and the half-life is 100 million years, two half-lives have elapsed, giving 200 million years. The half-life here is an invented convenient clock for practice, not a claim about a named isotope. Real methods choose isotope systems suited to the mineral and timescale.'''),
    scienceVisual('g12_geology_clock',
        'At each equal time step half of the remaining parent decays, leaving 100%, 50% and 25%.'),
    scienceSection('What event does an age actually date?',
        '''A radiometric result requires a known decay relationship, measurements and a model of initial daughter material and later exchange. A closed system has not gained or lost relevant parent or daughter atoms since the event being dated. Our simplest parent-fraction exercises supply the initial parent amount. Real geologists commonly measure isotope ratios and use methods that estimate or constrain initial daughter contributions rather than assuming every sample began with none.

The clock may record crystallization or cooling through conditions at which an isotope system becomes effectively closed. Later heating or fluid alteration can disturb or reset a system. An age of a mineral grain in sediment may date formation of that grain in an older source rock, not deposition of the sediment containing it. Agreement among appropriate methods, field relationships and repeated measurements strengthens a history; a numerical result without context can mislead.'''),
    scienceSection('Guided calculation: rates require compatible units',
        '''Average rate equals measured change divided by elapsed time. A fault offset of 30 m accumulated over 10,000 years gives 30/10,000 = 0.003 m/year, or 3 mm/year. Convert meters to millimeters by multiplying by 1,000. This is an average offset rate for the measured interval; it does not mean the fault moves smoothly by 3 mm every year or predicts the next earthquake date.

Now consider 12 cm of sediment deposited over 600 years with no compaction correction needed in the stated model. Convert 12 cm to 120 mm, then divide by 600: 0.20 mm/year. If the layer was compacted after burial, present thickness can underestimate original deposited thickness. If erosion removed sediment, the preserved thickness is also incomplete. A rate estimate depends on what the measured change actually represents.'''),
    scienceSection('Separate a hazard from its consequences',
        '''A hazard describes a potentially damaging process and its likelihood or intensity, such as strong shaking or a landslide. Exposure concerns people, buildings and infrastructure located where that process can affect them. Vulnerability describes how susceptible those exposed elements are to damage. Two places with similar shaking hazard can have different expected losses because construction and occupancy differ. Risk combines such factors; it is not simply another word for earthquake magnitude.

Mapping old landslide deposits, measuring ground deformation and recording earthquakes can inform models. Probability statements must specify the event, area and time interval. A 20% chance of a specified event in 30 years is neither a promise that it will happen in year six nor a guarantee that the other years are safe. A long-term probability assessment is different from a precise prediction of time, location and magnitude.'''),
    scienceVisual('g12_geology_hazard',
        'Reducing exposure or vulnerability can reduce expected consequences even when the underlying fault remains active.'),
    scienceSection('Evidence activity: compare maps and assumptions',
        '''Draw a fictional hillside with an old landslide deposit, a steep slope and two possible building sites. Site A is on the deposit with many occupied buildings; site B is outside the mapped deposit with fewer occupants. List evidence that could improve the comparison: slope material, drainage, rainfall history and mapping uncertainty. Do not assume being outside one mapped deposit proves no future landslide is possible. A hazard boundary reflects evidence and model limits.

Next compare two otherwise equally exposed towns facing the same shaking hazard: one has more vulnerable buildings. Strengthening those buildings targets vulnerability, while moving critical facilities away from the hazard targets exposure. Neither action removes the tectonic source. The exercise uses fictional maps to reason about evidence; real site decisions require local investigations and the relevant authorities’ assessments.'''),
    scienceSection('Common mistakes and quick check',
        '''Do not treat every radiometric age as the deposition age of a whole rock. Do not turn an average rate into an exact schedule. Do not interpret a gap in preserved strata as proof that nothing happened. Earth histories are constrained reconstructions that can improve when new evidence appears.

Quick check: a closed mineral retains one eighth of its original parent isotope. The stated half-life is 50 million years. How old is the clock, and would that necessarily be the deposition age of a sandstone containing the grain?'''),
    scienceSection('Reveal and recap',
        '''One eighth remains after three half-lives, so the clock records 150 million years since its relevant closure event under the model. It need not date sandstone deposition because the grain could have formed in an older source rock. Recap: establish event order, identify what a clock measures, test closure and initial-condition assumptions, calculate rates with units, and distinguish uncertain hazard estimates from exposure and vulnerability.''',
        reveal: true),
  ],
  keyConcept:
      'Geologic explanations combine ordered field evidence, clocks with explicit assumptions and rates over defined intervals; hazard probabilities guide decisions without specifying exact event dates.',
  questions: [
    [
      'Which process removes and transports weathered material?',
      'Erosion',
      'Crystallization',
      'Radioactive decay',
      'Cementation',
      'Erosion involves removal and transport, whereas weathering breaks down material in place.',
      'Processes'
    ],
    [
      'In an upright, undeformed sedimentary sequence, which layer is generally older?',
      'A lower layer than one above it',
      'The uppermost layer in every case',
      'The thickest layer regardless of position',
      'The layer with the darkest color',
      'Superposition orders lower layers before higher ones when the sequence has not been overturned.',
      'Superposition'
    ],
    [
      'A dike cuts a sandstone layer. Which age relationship follows?',
      'The dike is younger than the sandstone it cuts',
      'The dike is older than that sandstone',
      'Both must have formed simultaneously',
      'Their order depends only on their colors',
      'A crosscutting feature forms after the material through which it cuts.',
      'Crosscutting'
    ],
    [
      'What does an unconformity represent?',
      'A break in the preserved geologic record',
      'An interval guaranteed to contain every event',
      'A mineral with no radioactive isotopes',
      'A requirement that all layers are overturned',
      'Erosion or nondeposition can leave a surface representing missing geologic time.',
      'Unconformity'
    ],
    [
      'What fraction of parent remains after one half-life?',
      'One half',
      'One quarter',
      'Three quarters',
      'None',
      'A half-life removes half of the parent population, leaving half remaining.',
      'Half-life'
    ],
    [
      'What is required by a closed isotope-system model?',
      'No relevant parent or daughter exchange since closure',
      'No chemical elements anywhere in the mineral',
      'A constant number of parent atoms despite decay',
      'An absence of daughter products at every time',
      'Closure means relevant isotopes are not added or lost externally after the dated event.',
      'Closure'
    ],
    [
      'Which term describes people and structures located where a hazard can act?',
      'Exposure',
      'Half-life',
      'Superposition',
      'Crystallization',
      'Exposure concerns what lies in the area affected by a potentially damaging process.',
      'Exposure'
    ],
    [
      'A closed sample has one quarter of its initial parent remaining. How many half-lives elapsed?',
      'Two',
      'One',
      'Three',
      'Four',
      'Successive halves leave one half after one interval and one quarter after two.',
      'Decay reasoning'
    ],
    [
      'With a 100-million-year half-life, one quarter remaining represents how much elapsed time?',
      '200 million years',
      '25 million years',
      '100 million years',
      '400 million years',
      'One quarter corresponds to two half-lives, each lasting 100 million years.',
      'Clock calculation'
    ],
    [
      'Why can a sedimentary grain age exceed the deposition age of its host layer?',
      'The grain may have formed earlier in a source rock',
      'Sedimentary deposition reverses radioactive decay',
      'All grains crystallize only after their host layer',
      'A grain cannot preserve any earlier history',
      'A recycled mineral can preserve an older formation or closure event than later sediment deposition.',
      'Dated event'
    ],
    [
      'What can later heating do to an isotope clock?',
      'Disturb or reset the system under suitable conditions',
      'Always leave every isotope system unchanged',
      'Always change the isotope half-life to zero',
      'Guarantee that deposition and crystallization coincide',
      'Heating can allow isotope redistribution, altering what the measured clock records.',
      'Disturbance'
    ],
    [
      'What is the average rate for 30 m offset over 10,000 years?',
      '3 mm/year',
      '30 mm/year',
      '300 mm/year',
      '0.003 mm/year',
      '30/10000 = 0.003 m/year, equivalent to 3 mm/year.',
      'Rate units'
    ],
    [
      'A layer preserves 12 cm deposited over 600 years in the stated uncompacted model. What average rate follows?',
      '0.20 mm/year',
      '2.0 mm/year',
      '20 mm/year',
      '0.02 mm/year',
      'Convert 12 cm to 120 mm, then divide by 600 years to obtain 0.20 mm/year.',
      'Deposition rate'
    ],
    [
      'Two equally exposed towns have the same shaking hazard but different building strength. What factor differs?',
      'Vulnerability',
      'Isotope half-life',
      'Event location by definition',
      'Fault age by necessity',
      'Building susceptibility to damage is vulnerability, distinct from hazard and exposure.',
      'Risk factors'
    ],
    [
      'S lies below H, a dike cuts both, erosion truncates the dike, and uncut G overlies the surface. Which order fits?',
      'S, H, dike, erosion, G',
      'Dike, S, H, G, erosion',
      'G, erosion, dike, H, S',
      'S, G, erosion, H, dike',
      'Superposition, crosscutting and truncation jointly constrain the stated sequence.',
      'Sequence synthesis'
    ],
    [
      'A fault cuts both a dike and an overlying gravel layer. What is supported about that fault movement?',
      'It is younger than both cut features',
      'It must predate both features',
      'It occurred exactly halfway between their ages',
      'It necessarily occurred during gravel deposition',
      'The observed cutting relationship places that movement after the cut materials existed.',
      'Event evidence'
    ],
    [
      'A fault averages 3 mm/year over a long interval. Which claim goes beyond that evidence?',
      'It must move exactly 3 mm in every individual year',
      'Its cumulative offset can support a long-term rate',
      'Its motion may be episodic',
      'The measured interval matters to interpretation',
      'A long-term average does not establish constant annual motion or an earthquake schedule.',
      'Rate limits'
    ],
    [
      'A sediment layer was compacted after deposition. How can using present thickness affect the inferred original accumulation rate?',
      'It can underestimate the rate based on original deposited thickness',
      'It must overestimate that original rate',
      'It proves no deposition occurred',
      'It removes the need to know elapsed time',
      'Compaction reduces thickness, so present thickness can understate original deposited material per time.',
      'Preservation'
    ],
    [
      'A 20% probability of a specified event in 30 years means which statement?',
      'There is uncertainty over the stated event and interval',
      'The event must occur exactly in year six',
      'Every fifth year must contain the event',
      'The first 24 years are guaranteed safe',
      'A probability over an interval does not identify an exact occurrence date or a safe subinterval.',
      'Probability'
    ],
    [
      'Which action primarily reduces vulnerability under unchanged shaking hazard and exposure?',
      'Strengthening existing buildings',
      'Renaming the fault on a map',
      'Recalculating a mineral half-life',
      'Assuming no event will occur',
      'Strengthening buildings reduces susceptibility to damage without removing the seismic source.',
      'Risk reduction'
    ],
    [
      'A closed mineral has one eighth parent remaining and a 50-million-year half-life. What elapsed clock time follows?',
      '150 million years',
      '6.25 million years',
      '100 million years',
      '400 million years',
      'One eighth remains after three half-lives, giving 3 × 50 = 150 million years.',
      'Mastery clock'
    ],
    [
      'An intrusion age conflicts with a well-established cutting relationship. What is the strongest next step?',
      'Investigate sample context, closure and possible disturbance before revising the history',
      'Discard all field observations automatically',
      'Assume every mineral age dates sediment deposition',
      'Average unrelated ages without checking their meaning',
      'Independent evidence should be reconciled by testing which event the isotope result actually records.',
      'Mastery evidence'
    ],
    [
      'Moving a hospital outside a mapped hazard zone primarily changes which factor, while mapping uncertainty still matters?',
      'Exposure',
      'The radioactive decay constant',
      'The tectonic source mechanism',
      'The age order of sedimentary layers',
      'Relocation changes where the hospital is exposed; it does not eliminate the underlying geologic process.',
      'Mastery hazard'
    ],
  ],
);

final _fields = scienceTopic(
  grade: 'g12',
  order: 3,
  title: 'Electric Fields',
  subtitle: 'Use vectors and energy to explain electric interactions',
  minutes: '35–40 minutes',
  prerequisiteTopicId: 'science.g12.chemical-equilibrium',
  objectives: [
    'Determine field directions and combine one-dimensional contributions.',
    'Calculate force from a signed test charge and electric field.',
    'Relate potential difference to energy and electric work.',
    'State the conditions required for point-charge and uniform-field models.'
  ],
  introduction:
      'A small charged particle placed between two fixed charges can accelerate even though nothing touches it. A field describes the electric influence already present at its location. To predict motion and energy changes, distinguish the sources creating the field from the test charge experiencing it, and keep direction separate from magnitude.',
  sections: [
    scienceSection('Define the field before placing a test charge',
        '''The electric field E at a location is the electric force per unit positive test charge: E = F/q. It is a vector, carrying both magnitude and direction. Its SI unit is newtons per coulomb, N/C. A sufficiently small test charge samples the field without substantially rearranging the source charges. The sources and their arrangement determine the field; changing an ideal test charge does not change that preexisting field.

Field direction is the direction a positive test charge would be pushed. Around a positive source it points outward; around a negative source it points inward. A negative test charge experiences force opposite the field. Distinguish these two uses of sign: the source sign helps set E, while the test-charge sign determines how F relates to E at that point.'''),
    scienceSection('The point-charge model and distance',
        '''For a stationary point source in vacuum, the field magnitude at distance r is E = k|Q|/r², where Q is the source charge and k is approximately 9.0 × 10⁹ N m²/C². Air is often close enough to vacuum for these introductory examples. Other materials can alter the relationship. The absolute-value bars mean the magnitude is nonnegative; use the source sign and geometry separately to assign direction.

Doubling r reduces the magnitude to one quarter because the squared distance becomes four times larger. Doubling source charge magnitude doubles the field at unchanged r. These statements apply to the point-charge model, not every extended charge arrangement. A point model also breaks down inside an extended source or when its size cannot be neglected relative to the distance.'''),
    scienceSection('Superposition means adding vectors',
        '''With several fixed sources, calculate each source field at the same observation point and add the vectors. In one dimension, choose right as positive. A +400 N/C contribution and a −100 N/C contribution give +300 N/C, a rightward field. Adding only magnitudes would incorrectly give 500 N/C. Equal opposing contributions cancel; equal contributions pointing the same way add.

At the midpoint between equal positive source charges, the field from the left charge points right and the field from the right charge points left, so they cancel. Between equal opposite charges, with positive on the left and negative on the right, both midpoint fields point right: away from positive and toward negative. Their magnitudes add. For noncollinear fields, resolve components along perpendicular axes before summing; our numerical exercises stay on one line.'''),
    scienceVisual('g12_fields_vectors',
        'Do not decide cancellation from the source signs alone. Draw each field direction at the observation point.'),
    scienceSection('Worked example: a point-source calculation',
        '''Place a +2.0 nanocoulomb source at the origin and observe a point 0.30 m to its right. Convert nanocoulombs: 2.0 nC = 2.0 × 10⁻⁹ C. Substitute into the magnitude formula: E = (9.0 × 10⁹)(2.0 × 10⁻⁹)/(0.30)² = 18/0.09 = 200 N/C. Because the source is positive and the point is to its right, the field points right.

Move the observation point to 0.60 m on the same side. The distance doubles, so E becomes 50 N/C, still rightward. A negative source of the same magnitude at the origin would give the same magnitudes but leftward fields at these observation points. Check the length conversion before squaring; entering centimeters as though they were meters creates a large error.'''),
    scienceSection('From field to force: keep the sign of q',
        '''Once E is known, use F = qE. For a one-dimensional field of +300 N/C and a test charge +2.0 microcoulombs, q = +2.0 × 10⁻⁶ C. The force is +0.0006 N, pointing right. Replace the test charge with −2.0 microcoulombs and the force becomes −0.0006 N, pointing left. The field remains +300 N/C in the ideal fixed-source model.

Force does not directly specify velocity. By Newton’s second law, the net force determines acceleration for a known mass. A negative charge initially moving right in a rightward electric field can slow down before reversing, if the electric force is the only force. Its instantaneous motion need not point along its acceleration. Also account for gravity or other forces when the problem does not explicitly neglect them.'''),
    scienceVisual('g12_fields_force',
        'The field arrow is the same in both cases; the negative test charge reverses the force arrow.'),
    scienceSection('Potential is energy per charge, not a vector arrow',
        '''Electric potential V is electric potential energy per unit charge, measured in joules per coulomb, called volts. Potential is a scalar; field is a vector. Only potential differences are needed for energy changes, and choosing a different reference zero does not alter those differences. If a charge moves from initial to final potential, ΔV = Vf − Vi and its electric potential-energy change is ΔU = qΔV.

In an electrostatic field, the work done by the electric field is Wfield = −ΔU = −qΔV. Positive field work transfers energy out of electric potential energy. If no other forces do work, kinetic energy increases by that amount. External work equals ΔU only for a controlled move with no kinetic-energy change and with no other non-electric work. Do not equate field work and external work without naming which agent does the work.'''),
    scienceSection('Uniform fields connect distance and potential',
        '''Between large parallel oppositely charged plates, sufficiently far from edges, the electric field can be approximated as uniform. Potential decreases in the field direction. For a displacement d parallel to a uniform field, ΔV = −Ed when d is taken positive along E. A perpendicular displacement has no potential change in this model. The relation uses displacement along the field, not the total length of an arbitrary curved route.

Worked example: E = 200 N/C to the right, and a particle moves 0.02 m right. Then ΔV = −200 × 0.02 = −4 V. Starting at 10 V gives a final potential of 6 V. A +3 microcoulomb charge has ΔU = (3 × 10⁻⁶)(−4) = −12 microjoules, so the field does +12 microjoules of work. A negative charge on the same displacement has the opposite energy-change sign.'''),
    scienceVisual('g12_fields_potential',
        'Potential drops from 10 V to 6 V over a 0.02 m rightward displacement in the stated uniform field.'),
    scienceSection('Guided activity: audit arrows and energy separately',
        '''Draw two source charges on paper, positive at left and negative at right, and mark their midpoint. Draw each source contribution at that one point before adding. Use equal arrow lengths because the source magnitudes and midpoint distances match. Then place a negative test charge at the midpoint and draw its force. Explain why the force is leftward even though both field contributions point right.

For a separate energy check, move a −2 microcoulomb charge from 12 V to 7 V. First calculate ΔV = −5 V. Next calculate ΔU = (−2 microcoulombs)(−5 V) = +10 microjoules. Finally, Wfield = −10 microjoules. If an external agent moves it slowly with unchanged kinetic energy and no other work, that agent supplies +10 microjoules. The charge sign is essential at the energy step.'''),
    scienceSection('Common mistakes and quick check',
        '''Field lines are representations, not physical tracks that particles must follow. Dense line spacing can represent stronger field in a consistently drawn diagram, but the count is a drawing convention. A zero net field at a point does not require zero potential there: vector cancellation and a scalar reference are different matters.

Quick check: contributions at a point are +500 and −200 N/C. A −1 microcoulomb test charge is placed there. State the net field and force, and explain whether the negative test charge changes the field direction.'''),
    scienceSection('Reveal and recap',
        '''The net field is +300 N/C. Multiplying by −1 × 10⁻⁶ C gives −0.0003 N, a leftward force. In the ideal small-test-charge model it does not reverse the source field. Recap: locate the observation point, add field vectors, multiply by signed q for force, and use signed potential difference for energy. Check that every formula matches its stated model conditions.''',
        reveal: true),
  ],
  keyConcept:
      'Source charges create a vector field; signed test charge determines force, while potential difference determines energy change through ΔU = qΔV.',
  questions: [
    [
      'What is the SI unit of electric field?',
      'N/C',
      'J',
      'C/s',
      'N m',
      'Electric field is force per charge, so its unit is newtons per coulomb.',
      'Units'
    ],
    [
      'Which direction defines an electric field arrow?',
      'The force direction on a positive test charge',
      'The velocity of every negative charge',
      'The motion of the source charge',
      'The direction of increasing potential in every case',
      'Field direction is defined by the force a positive test charge would experience.',
      'Field definition'
    ],
    [
      'At a point to the right of a positive isolated source, where does its field point?',
      'Right, away from the source',
      'Left, toward the source',
      'Up regardless of position',
      'There is no field without a moving test charge',
      'A positive point source produces an outward field, rightward at the stated point.',
      'Source direction'
    ],
    [
      'Which equation connects force and the known field?',
      'F = qE',
      'F = E/q',
      'F = q/E',
      'F = q + E',
      'Multiplying field in N/C by charge in C gives force in N, including its sign.',
      'Force relation'
    ],
    [
      'Electric potential is which kind of quantity?',
      'A scalar measured in volts',
      'A vector measured in newtons',
      'A vector measured in coulombs',
      'A scalar measured in meters only',
      'Potential is energy per charge, a scalar whose unit is the volt.',
      'Potential'
    ],
    [
      'How is potential difference defined from initial to final position?',
      'Final potential minus initial potential',
      'Initial potential plus final potential',
      'The magnitude of either potential alone',
      'Charge divided by displacement',
      'The signed change ΔV is Vf − Vi, which must be retained for energy calculations.',
      'Potential difference'
    ],
    [
      'Which expression gives electric potential-energy change?',
      'ΔU = qΔV',
      'ΔU = q/ΔV',
      'ΔU = E/q',
      'ΔU = ΔV − q',
      'Charge times potential difference gives the signed electric potential-energy change.',
      'Energy relation'
    ],
    [
      'A point-source distance doubles. How does its field magnitude change?',
      'It becomes one quarter as large',
      'It becomes one half as large',
      'It doubles',
      'It stays unchanged',
      'The inverse-square law divides the field by four when distance doubles.',
      'Inverse square'
    ],
    [
      'Right is positive. Fields +400 and −100 N/C act at the same point. What is their sum?',
      '+300 N/C',
      '+500 N/C',
      '−300 N/C',
      '−500 N/C',
      'Signed one-dimensional addition gives 400 − 100 = +300 N/C.',
      'Superposition'
    ],
    [
      'At the midpoint between equal positive sources, what is the net electric field?',
      'Zero because equal opposite vectors cancel',
      'Twice either field to the right',
      'Twice either field to the left',
      'Nonzero because all positive charges have the same sign',
      'At the midpoint the outward contributions have equal magnitudes and opposite directions.',
      'Cancellation'
    ],
    [
      'Positive source left, equal negative source right: where does the midpoint field point?',
      'Right because the two contributions add',
      'Left because the charges cancel',
      'It is zero because source magnitudes match',
      'Up because the signs differ',
      'At the midpoint, away from positive and toward negative both mean rightward.',
      'Opposite sources'
    ],
    [
      'What force acts on +2 microcoulombs in +300 N/C?',
      '+0.0006 N',
      '−0.0006 N',
      '+600 N',
      '+150 N',
      'Convert microcoulombs to 10⁻⁶ C, then multiply 2 × 10⁻⁶ by 300.',
      'Force calculation'
    ],
    [
      'A negative test charge sits in a rightward field. Which force direction follows?',
      'Leftward',
      'Rightward',
      'Always upward',
      'Zero for every negative charge',
      'The negative sign of q reverses the force relative to the field direction.',
      'Test-charge sign'
    ],
    [
      'What approximation supports a uniform field between parallel plates?',
      'Observation far from edges of sufficiently large plates',
      'Any location around any point charge',
      'All curved paths have equal length',
      'Source charge must be zero',
      'Large plates have approximately uniform interior fields when edge effects are neglected.',
      'Model conditions'
    ],
    [
      'A +2 nC point source is 0.30 m left of a point. With k = 9 × 10⁹, what field does it create there?',
      '200 N/C rightward',
      '200 N/C leftward',
      '60 N/C rightward',
      '20 N/C leftward',
      'kQ/r² = 18/0.09 = 200 N/C, and the positive source field points away to the right.',
      'Point-source calculation'
    ],
    [
      'A particle moves 0.02 m along a uniform 200 N/C field. What is its potential change?',
      '−4 V',
      '+4 V',
      '−10000 V',
      '+0.0001 V',
      'Potential decreases along the field: ΔV = −Ed = −200 × 0.02 = −4 V.',
      'Uniform potential'
    ],
    [
      'A +3 microcoulomb charge moves through ΔV = −4 V. What is the electric field work?',
      '+12 microjoules',
      '−12 microjoules',
      '+0.75 microjoules',
      '−7 microjoules',
      'ΔU = −12 microjoules, so work by the electric field is its negative, +12 microjoules.',
      'Work'
    ],
    [
      'A negative charge is initially moving right in a rightward field with no other force. What can happen first?',
      'It slows while accelerating left',
      'It must instantly acquire leftward velocity',
      'It accelerates right because its velocity is rightward',
      'Its force is zero until it stops',
      'Force and acceleration point left, but an initial rightward velocity can persist while decreasing.',
      'Force versus velocity'
    ],
    [
      'A −2 microcoulomb charge goes from 12 V to 7 V. What is ΔU?',
      '+10 microjoules',
      '−10 microjoules',
      '+38 microjoules',
      '−2.5 microjoules',
      'The potential change is −5 V; multiplying two negative quantities gives +10 microjoules.',
      'Signed energy'
    ],
    [
      'When does external work equal ΔU for moving a charge?',
      'When kinetic energy is unchanged and no other non-electric work occurs',
      'For every motion regardless of acceleration',
      'Only when electric field work is positive',
      'Whenever the test charge is negative',
      'With unchanged kinetic energy and only electric work plus that external agent, external work equals the potential-energy increase.',
      'Work conditions'
    ],
    [
      'Contributions are +600 and −200 N/C. What force acts on −2 microcoulombs?',
      '−0.0008 N',
      '+0.0008 N',
      '−0.0016 N',
      '+0.0004 N',
      'Net E is +400 N/C; multiplying by −2 × 10⁻⁶ C gives −0.0008 N.',
      'Mastery vectors'
    ],
    [
      'A charge moves perpendicular to a uniform electrostatic field. What is the potential change?',
      'Zero in the stated model',
      'Always positive',
      'Always negative',
      'Equal to the full field magnitude in volts',
      'Only displacement along the field contributes to the potential difference in this uniform model.',
      'Mastery potential'
    ],
    [
      'A +1 microcoulomb charge moves from 9 V to 3 V with only electric work. What kinetic-energy change follows?',
      '+6 microjoules',
      '−6 microjoules',
      '+12 microjoules',
      'Zero because potential is a scalar',
      'ΔU = −6 microjoules, so electric work and the kinetic-energy increase are +6 microjoules.',
      'Mastery energy'
    ],
  ],
);

final _equilibrium = scienceTopic(
  grade: 'g12',
  order: 2,
  title: 'Chemical Equilibrium',
  subtitle: 'Predict net change from reaction quotients and balanced amounts',
  minutes: '35–40 minutes',
  prerequisiteTopicId: 'science.g12.genetics-molecular-biology',
  objectives: [
    'Explain dynamic equilibrium using equal opposing rates.',
    'Write concentration quotients from balanced equations.',
    'Compare Q and K to predict net reaction direction.',
    'Calculate simple equilibrium concentrations and qualify stress predictions.'
  ],
  introduction:
      'A sealed reacting mixture can keep the same color for hours while molecules continue changing identity. Constant appearance does not mean that chemistry has stopped. Equilibrium connects microscopic opposing reactions to a stable macroscopic composition, and a reaction quotient helps predict what happens when that composition is disturbed.',
  sections: [
    scienceSection('Dynamic balance in a reversible reaction',
        '''Write A ⇌ B to indicate forward conversion of A into B and reverse conversion of B into A. In a closed system at fixed conditions, a mixture may reach dynamic equilibrium: the forward and reverse reaction rates are equal. Molecules still react, but neither substance has a net concentration change. Equal rates do not require equal concentrations. Rate depends on how often productive reaction events occur, not simply on whether two amounts match.

Before equilibrium, both directions can occur while their rates differ. A net forward change means forward reaction exceeds reverse reaction over the interval; it does not mean reverse reaction is absent. Our calculations concern an idealized homogeneous mixture at constant volume unless a different condition is stated. A continuously supplied open reactor can have constant concentrations for other reasons, so constant readings alone do not prove equilibrium.'''),
    scienceVisual('g12_equilibrium_dynamic',
        'A can remain at 0.20 mol/L while B remains at 0.80 mol/L because their opposing conversion rates balance.'),
    scienceSection('Build a quotient from the balanced equation',
        '''For aA + bB ⇌ cC + dD, our dilute-solution concentration model uses Qc = [C]^c[D]^d / ([A]^a[B]^b). Square brackets represent molar concentration, measured here in mol/L. Stoichiometric coefficients become exponents; they do not become multipliers outside the brackets. For A ⇌ 2B, the expression is [B]²/[A]. For A ⇌ B, it is simply [B]/[A]. Always write the balanced equation before building the expression.

At equilibrium the quotient has the equilibrium value Kc. For a given written reaction, K depends on temperature. In rigorous thermodynamics, equilibrium constants use dimensionless activities relative to standard states; this lesson uses the standard introductory concentration approximation for suitable dilute mixtures. Pure solids and pure liquids are omitted from that expression because their activities are approximately constant while those phases remain present. Dissolved substances are not omitted merely because they are in a liquid solution.'''),
    scienceSection('K describes composition, not how fast it appears',
        '''A large K favors products in the written equilibrium expression; a small K favors reactants. This does not automatically tell you the percentage yield without the starting composition and stoichiometry. K also says nothing by itself about how rapidly equilibrium is approached. A product-favored reaction can be slow because of a kinetic barrier. A catalyst provides a faster reaction pathway in both directions and speeds the approach to the same equilibrium at the same temperature.

Reversing the written equation reverses numerator and denominator, so the new equilibrium constant is 1/K. If A ⇌ B has K = 4, then B ⇌ A has K = 0.25 at that temperature. This is not a physical change to the mixture. It is a change in the way the same equilibrium is described. The equation and its constant must always travel together.'''),
    scienceSection('Worked example: use Q to choose a direction',
        '''Suppose A ⇌ B has Kc = 4 at the stated temperature. A sample presently has [A] = 0.60 mol/L and [B] = 0.40 mol/L. Calculate Qc = 0.40/0.60, about 0.67. Since Q is below K, the product-to-reactant ratio is too small for equilibrium. Net forward reaction consumes A and makes B, raising that ratio. It proceeds toward Q = K rather than converting all A automatically.

If another sample has [A] = 0.10 and [B] = 0.90 mol/L, Q = 9, above K. Net reverse reaction makes A and consumes B, decreasing the ratio. If Q = 4, no net reaction direction is favored under the stated conditions, although both reactions continue. Comparing Q and K is more reliable than guessing from which substance has the larger concentration.'''),
    scienceVisual('g12_equilibrium_quotient',
        'Q is calculated from the current mixture; K is the equilibrium comparison at its temperature.'),
    scienceSection('Worked concentration calculation with a conservation check',
        '''Start a constant-volume A ⇌ B mixture with [A] = 1.00 mol/L and [B] = 0, and let Kc = 4. Let x mol/L of A convert to B. The equilibrium concentrations are 1.00 − x and x. Insert these into the expression: x/(1.00 − x) = 4. Multiply through: x = 4.00 − 4x, so 5x = 4.00 and x = 0.80 mol/L. Therefore [A] = 0.20 and [B] = 0.80 mol/L.

Check both requirements: 0.80/0.20 = 4, and the concentrations still sum to 1.00 mol/L because this particular equation converts one molecule to one molecule at constant volume. The sum-of-concentrations rule is not universal. For A ⇌ 2B, a forward change of x consumes x of A but produces 2x of B. Balanced stoichiometry, not a memorized concentration-sum rule, determines the change row.'''),
    scienceSection('Stress predictions need specified conditions',
        '''Adding A to an equilibrium A ⇌ B mixture at constant volume lowers Q immediately, so net forward reaction follows. K stays unchanged if temperature stays the same. Removing B also lowers Q and favors net forward replacement of some B. These responses partially oppose the disturbance; they do not necessarily restore every concentration to its previous value. Distinguish the immediate mixing change from the later reaction adjustment.

For gaseous N2 + 3H2 ⇌ 2NH3, reducing volume at constant temperature increases partial pressures and favors the side with fewer gas particles, here ammonia. If both sides have the same total gaseous coefficient, this simple volume change does not shift the ideal-gas equilibrium. Adding an inert gas at fixed volume and temperature leaves reacting-gas partial pressures unchanged, so it does not shift that ideal equilibrium. Pressure alone is too vague: specify how it changes.'''),
    scienceVisual('g12_equilibrium_stress',
        'Changing temperature differs fundamentally from adding a catalyst or changing concentration at fixed temperature.'),
    scienceSection('Temperature changes the equilibrium target',
        '''If the forward reaction is exothermic, it transfers heat to the surroundings. Raising temperature favors the endothermic reverse direction, and the forward reaction equilibrium constant decreases. Cooling favors the exothermic direction. For an endothermic forward reaction, warming increases its equilibrium constant. Treating heat as a conceptual product or reactant can guide the direction, but do not put a numerical heat concentration into the quotient.

An industrial choice therefore involves both equilibrium composition and rate. Cooling an exothermic process may favor product thermodynamically while slowing the approach. A catalyst can improve rate without changing the equilibrium constant. This lesson predicts direction for specified changes; it does not supply reaction-specific rate laws or enough information to optimize a real factory.'''),
    scienceSection('Guided activity: test the quotient before guessing',
        '''Use paper counters for a fictional one-to-one A ⇌ B system. Treat each counter as 0.10 mol/L in a fixed volume, with K = 4. Begin with five A and five B counters. Calculate Q = 1, then move one A counter to B at a time. At two A and eight B counters, Q = 4. This bookkeeping finds the equilibrium composition for the given total, but the counters do not model random molecular kinetics or a reaction mechanism.

Now use a total concentration of 0.50 mol/L and K = 4. Write [B] = 4[A] and [A] + [B] = 0.50. Combining gives 5[A] = 0.50, so [A] = 0.10 and [B] = 0.40 mol/L. Explain why both this mixture and the 1.00 mol/L example satisfy the same K with different individual concentrations.'''),
    scienceSection('Common mistakes and quick check',
        '''Equilibrium is not equal amounts, complete conversion or stopped reactions. A catalyst is not a way to raise equilibrium yield at unchanged temperature. A stress rule without a balanced equation and conditions can mislead. Always check nonnegative concentrations, the equation coefficients and the calculated quotient.

Quick check: A ⇌ B has K = 4, and its present concentrations are 0.30 mol/L A and 0.60 mol/L B. Is it at equilibrium, and does adding a catalyst change the target ratio?'''),
    scienceSection('Reveal and recap',
        '''Q = 0.60/0.30 = 2, below 4, so net forward change is expected. A catalyst can speed the approach but leaves the target K unchanged at this temperature. Recap: write the equation, build Q, compare it with K, track changes using stoichiometry, then check both equilibrium and conservation constraints.''',
        reveal: true),
  ],
  keyConcept:
      'Equilibrium balances reaction rates; Q compared with temperature-dependent K predicts net change, while stoichiometry constrains the final composition.',
  questions: [
    [
      'What is equal at dynamic chemical equilibrium?',
      'Forward and reverse reaction rates',
      'All reactant and product concentrations',
      'The masses of every substance',
      'The number of each molecule present',
      'Opposing rates balance, allowing concentrations to remain constant without being equal.',
      'Dynamic balance'
    ],
    [
      'What happens microscopically at equilibrium?',
      'Both forward and reverse reactions continue',
      'All molecular motion stops',
      'Only the forward reaction continues',
      'Every reactant molecule has disappeared',
      'Dynamic equilibrium involves continuing reactions with equal opposing rates.',
      'Dynamics'
    ],
    [
      'For A ⇌ B, which quotient is used here?',
      '[B]/[A]',
      '[A] + [B]',
      '[A] − [B]',
      '[A] × [B]',
      'The product concentration is divided by the reactant concentration for this one-to-one equation.',
      'Quotient'
    ],
    [
      'For A ⇌ 2B, what is the concentration quotient?',
      '[B]²/[A]',
      '2[B]/[A]',
      '[B]/(2[A])',
      '[A]/[B]²',
      'The balanced coefficient two becomes an exponent on the product concentration.',
      'Exponents'
    ],
    [
      'When is Q equal to K?',
      'At equilibrium under the stated conditions',
      'Whenever both concentrations are equal',
      'Only before any product forms',
      'Whenever a catalyst is absent',
      'K is the equilibrium value of the quotient for the stated reaction and temperature.',
      'Equilibrium condition'
    ],
    [
      'Which change can change K for the same written reaction?',
      'Changing temperature',
      'Adding a catalyst at fixed temperature',
      'Adding reactant at fixed temperature',
      'Removing product at fixed temperature',
      'Temperature changes the equilibrium constant; composition changes initially alter Q.',
      'Temperature'
    ],
    [
      'Which component is omitted in the introductory equilibrium expression while its phase remains?',
      'A pure solid',
      'A dissolved reactant',
      'A dissolved product',
      'A reacting gas',
      'The activity of a pure solid is approximately constant while that phase remains present.',
      'Phases'
    ],
    [
      'Q = 0.5 and K = 4. What net direction is expected?',
      'Forward toward products',
      'Reverse toward reactants',
      'No net change because Q is positive',
      'The direction cannot depend on these values',
      'Q below K means the product ratio must increase through net forward change.',
      'Direction'
    ],
    [
      'Q = 9 and K = 4. Which change moves toward equilibrium?',
      'Net reverse reaction lowers Q',
      'Net forward reaction raises Q',
      'No molecular reactions occur',
      'K rises to 9 at unchanged temperature',
      'When Q exceeds K, net reverse reaction reduces the quotient toward K.',
      'Reverse change'
    ],
    [
      'At equilibrium [A] = 0.20 and [B] = 0.80 mol/L for A ⇌ B. What is Kc?',
      '4',
      '0.25',
      '0.60',
      '1.00',
      'Divide the product concentration by the reactant concentration: 0.80/0.20 = 4.',
      'Calculation'
    ],
    [
      'A ⇌ B has K = 4. What is K for B ⇌ A at the same temperature?',
      '0.25',
      '4',
      '8',
      '−4',
      'Reversing the equation takes the reciprocal of the original equilibrium constant.',
      'Equation direction'
    ],
    [
      'A catalyst is added without changing temperature. What follows?',
      'Equilibrium is approached faster without changing K',
      'K necessarily doubles',
      'Only the forward rate increases',
      'All reactants must eventually vanish',
      'Catalysis accelerates both directions and does not change the equilibrium target.',
      'Catalysts'
    ],
    [
      'A forward change consumes x mol/L of A in A ⇌ 2B. How much B forms?',
      '2x mol/L',
      'x mol/L',
      'x/2 mol/L',
      '4x mol/L',
      'The balanced one-to-two ratio requires twice the concentration change for B at constant volume.',
      'Stoichiometry'
    ],
    [
      'What happens to K for an exothermic forward reaction when temperature rises?',
      'It decreases',
      'It always remains unchanged',
      'It becomes negative',
      'It necessarily doubles',
      'Warming favors the endothermic reverse direction, reducing the forward equilibrium constant.',
      'Thermal stress'
    ],
    [
      'Initially A = 1.00 and B = 0 mol/L for A ⇌ B with K = 4. Which equilibrium pair is valid?',
      'A = 0.20, B = 0.80 mol/L',
      'A = 0.50, B = 0.50 mol/L',
      'A = 0.80, B = 0.20 mol/L',
      'A = 0.25, B = 1.00 mol/L',
      'Only 0.20 and 0.80 satisfy both B/A = 4 and the conserved one-to-one total of 1.00.',
      'Equilibrium amounts'
    ],
    [
      'At fixed volume and temperature, A is added to equilibrium A ⇌ B. Which immediate comparison follows?',
      'Q decreases below K',
      'K decreases below Q',
      'Q and K must both double',
      'Q is unchanged because the reaction is reversible',
      'Increasing the denominator lowers Q immediately; K remains temperature-fixed.',
      'Composition stress'
    ],
    [
      'Why does reducing volume favor ammonia in N2 + 3H2 ⇌ 2NH3 at fixed temperature?',
      'The product side has fewer gas particles by its coefficients',
      'Ammonia has the largest formula subscript',
      'Compression changes the balanced coefficients',
      'Total concentration must remain constant during compression',
      'The gas-particle count falls from four coefficient units to two on the product side.',
      'Gas equilibrium'
    ],
    [
      'An inert gas is added at fixed volume and temperature in an ideal-gas mixture. What is predicted?',
      'No shift because reacting-gas partial pressures are unchanged',
      'A shift toward fewer gas particles in every reaction',
      'A shift toward more gas particles in every reaction',
      'A larger K because total pressure rises',
      'At fixed volume and temperature, inert gas does not alter the reacting species partial pressures.',
      'Pressure conditions'
    ],
    [
      'Why might cooling an exothermic process fail to give fast production?',
      'It can favor equilibrium product while slowing reaction rates',
      'It must remove all products at equilibrium',
      'Equilibrium yield and rate are the same quantity',
      'A smaller temperature always makes K zero',
      'Composition preference and kinetic speed are distinct, so favorable yield can accompany slower reaction.',
      'Kinetics versus equilibrium'
    ],
    [
      'A ⇌ B has total concentration 0.50 mol/L and K = 4. Which is [A] at equilibrium?',
      '0.10 mol/L',
      '0.40 mol/L',
      '0.25 mol/L',
      '2.00 mol/L',
      'B = 4A and A + B = 0.50 imply 5A = 0.50, giving A = 0.10 mol/L.',
      'Conservation'
    ],
    [
      'For A ⇌ B, [A] = 0.40 and [B] = 0.80 mol/L with K = 4. What is justified?',
      'Q = 2 and net forward reaction is expected',
      'Q = 2 and net reverse reaction is expected',
      'Q = 4 and the mixture is at equilibrium',
      'Q = 0.5 and K must change immediately',
      'The quotient is 0.80/0.40 = 2, below K, so forward change raises the product ratio.',
      'Mastery quotient'
    ],
    [
      'A ⇌ 2B begins with A = 1.00 and B = 0 mol/L. A decreases by 0.20 mol/L. What is the resulting B concentration?',
      '0.40 mol/L',
      '0.20 mol/L',
      '0.10 mol/L',
      '0.80 mol/L',
      'Each mole of A consumed forms two moles of B, so the product concentration rises by 0.40.',
      'Mastery stoichiometry'
    ],
    [
      'Which explanation correctly separates a catalyst from heating for an exothermic forward reaction?',
      'Catalysis preserves K; heating decreases the forward K',
      'Both necessarily increase K',
      'Catalysis lowers K; heating preserves K',
      'Both stop the reverse reaction',
      'A catalyst changes approach speed, whereas heating changes the equilibrium constant and favors the endothermic reverse.',
      'Mastery conditions'
    ],
  ],
);

final _genetics = scienceTopic(
  grade: 'g12',
  order: 1,
  title: 'Genetics & Molecular Biology',
  subtitle:
      'Connect inherited sequence, gene expression and biological evidence',
  minutes: '35–40 minutes',
  prerequisiteTopicId: null,
  objectives: [
    'Transcribe a short oriented DNA template and translate supplied codons.',
    'Explain how regulation changes expression without changing coding sequence.',
    'Distinguish molecular effects of substitutions and frameshifts.',
    'Evaluate inheritance and functional evidence without genetic determinism.'
  ],
  introduction:
      'A skin cell and a nerve cell usually carry the same inherited genome, yet make different sets of proteins. Meanwhile, two people can inherit different versions of a gene and show similar traits. To explain these observations, follow information from DNA to a functional product, then ask where regulation, variation and environment enter the explanation.',
  sections: [
    scienceSection('From an allele to a molecular mechanism',
        '''A gene is a DNA region whose expression produces a functional RNA or contributes to a protein product. An allele is a sequence version at a genomic location. A genotype describes the alleles present; a phenotype is an observable characteristic arising through biological processes. These words name different levels of explanation. A sequence difference is not automatically a visible difference, and a visible difference is not automatically evidence for a different allele.

For protein-coding genes, transcription produces RNA using one DNA strand as a template. Translation uses the message to assemble an amino-acid chain. The chain must fold and sometimes be processed or combined with other components before becoming functional. Some genes instead produce functional RNAs that are not translated. The familiar DNA-to-RNA-to-protein pathway is therefore a model of protein-coding expression, not a claim that all genes encode proteins.'''),
    scienceSection('Direction matters when copying information',
        '''The two DNA strands run in opposite directions. Their ends are labeled 5′ and 3′ according to sugar-carbon positions. RNA polymerase reads a template strand in the 3′ to 5′ direction and builds RNA in the 5′ to 3′ direction. In transcription, template A pairs with RNA U, template T with RNA A, C with G, and G with C. RNA uses uracil rather than thymine.

The coding DNA strand has the same base sequence as the RNA, written in the same 5′ to 3′ direction, except that DNA has T where RNA has U. Do not complement the coding strand as though it were the template. First identify which strand is supplied and mark its ends. In eukaryotes, a newly made RNA usually undergoes processing; removal of introns and joining of exons help produce a mature message. Alternative splicing can join exons differently, producing different messages from one gene.'''),
    scienceVisual('g12_genetics_flow',
        'Read orientation labels before applying base-pair rules. The displayed fragment is already in the specified reading frame.'),
    scienceSection('Worked example: from template to peptide',
        '''Use this short coding-region model: template DNA is 3′-TAC CTT-5′. Step 1: read the template from its 3′ end. Step 2: pair each base to construct 5′-AUG GAA-3′. Step 3: split the message into codons, groups of three RNA bases, in the stated reading frame. For this lesson, AUG specifies methionine, GAA and GAG specify glutamate, UUU specifies phenylalanine, and UAA is a stop signal. Thus this fragment specifies methionine followed by glutamate.

A ribosome reads mRNA 5′ to 3′. Transfer RNAs help match codons with amino acids through complementary anticodons; a stop codon signals termination rather than adding an amino acid. The genetic code is redundant: different codons can specify the same amino acid. It is not ambiguous in the supplied table: each listed sense codon has one amino-acid meaning. A two-codon fragment illustrates decoding, not the full length of a typical gene.'''),
    scienceSection('Regulation changes when, where and how much',
        '''Transcription factors and other regulatory proteins influence whether transcription machinery can use a gene. A promoter is a DNA region involved in initiating transcription. A change in a regulatory region can alter RNA production even when the protein-coding sequence is unchanged. Cells also regulate RNA lifetime, translation and protein breakdown. Measuring abundant RNA does not prove that abundant active protein is present.

Consider two cell cultures with the same coding sequence. After a signal, culture A contains twice as much of a particular mRNA, while culture B does not change. Increased transcription is one hypothesis; slower RNA breakdown is another. Measuring newly synthesized RNA could help distinguish them. A careful explanation names the measured quantity and does not jump directly from RNA abundance to protein activity or whole-organism behavior.'''),
    scienceVisual('g12_genetics_regulation',
        'Different RNA and protein amounts can arise at several regulatory steps.'),
    scienceSection('Mutation effects depend on location and context',
        '''A substitution changes a base. If a coding-strand change converts GAA to GAG, the corresponding RNA codon still specifies glutamate using our table: this is a synonymous coding change. It leaves that amino acid unchanged, although synonymous changes can sometimes affect other processes. A substitution that changes an amino acid is a missense change; one that creates an early stop is a nonsense change. Effects depend on the protein and the position affected.

An insertion or deletion of one base within a translated coding region usually shifts the downstream reading frame. Grouping later bases into new triplets can change many amino acids and encounter a stop. Adding three bases preserves the downstream frame but can still change function by adding an amino acid. Mutations do not occur because organisms need a particular improvement. A mutation in a body cell is not ordinarily transmitted through gametes; a variant present in a gamete can be inherited.'''),
    scienceSection('Guided example: inheritance is a probability model',
        '''Suppose a simplified autosomal recessive condition appears only with genotype aa; Aa individuals are unaffected carriers in this model. Two Aa parents each transmit A or a with probability one half. Combine gametes: AA, Aa, aA and aa are equally probable, giving a one-quarter probability of aa for each offspring. The two heterozygous combinations represent the same genotype. Four offspring are not guaranteed to include exactly one aa child; the prediction concerns repeated independent outcomes under the model assumptions.

Now connect the model to molecules. If a supplies a low-function enzyme and one A copy provides enough activity, the recessive pattern has a possible mechanism. A pedigree consistent with recessive inheritance supports that model, but small families may also fit alternatives. Many actual traits involve several genes, environment and incomplete correspondence between genotype and phenotype. State the simplified assumptions instead of applying the one-gene rule to every human characteristic.'''),
    scienceVisual('g12_genetics_inheritance',
        'Trace a proposed causal chain and identify which links have actually been measured.'),
    scienceSection('Evidence activity: test a proposed causal link',
        '''On paper, make columns for DNA sequence, RNA amount, protein activity and phenotype. Compare two invented cultures grown under the same conditions: reference allele, RNA 10 units, activity 8 units; variant allele, RNA 10 units, activity 2 units. The equal RNA measurement makes a large RNA-abundance difference an unlikely explanation for the activity difference in this experiment. Altered protein function remains a hypothesis; it is not proven by these two measurements alone.

Design a stronger comparison: use otherwise matched cells differing at the proposed variant, include repeated cultures and measure activity with the same method. Restoring the reference sequence and recovering activity would strengthen a causal account. Avoid collecting classmates’ private genetic or family information. This activity evaluates molecular evidence using fictional data and does not diagnose anyone.'''),
    scienceSection('Common mistakes and a quick check',
        '''Do not confuse replication, which copies DNA, with transcription, which produces RNA. Do not call every sequence change harmful: location and molecular consequences matter. Do not infer that a gene absent from an RNA measurement is absent from the genome. Expression can vary while the DNA remains present.

Quick check: a coding DNA triplet changes from GAA to GAG, RNA abundance is unchanged, and the supplied codon table assigns both RNA codons to glutamate. What is justified about the peptide sequence at this position, and what remains untested?'''),
    scienceSection('Reveal and recap',
        '''The amino acid remains glutamate at this position, so the supplied evidence supports a synonymous coding change. It does not establish that every aspect of expression or function is unchanged; those require suitable measurements. Recap the reasoning route: identify template and direction, construct RNA, read codons in frame, consider regulation and protein function, then connect measured effects to inheritance and phenotype with explicit assumptions.''',
        reveal: true),
  ],
  keyConcept:
      'Inherited DNA influences traits through regulated molecular processes; sequence, RNA, protein function and phenotype require distinct evidence.',
  questions: [
    [
      'Which process makes RNA from a DNA template?',
      'Transcription',
      'Translation',
      'DNA replication',
      'Protein folding',
      'Transcription uses a DNA template to synthesize an RNA strand.',
      'Information flow'
    ],
    [
      'What is an allele?',
      'A sequence version at a genomic location',
      'A three-amino-acid protein fragment',
      'Any environmental influence on a trait',
      'The amount of RNA in a cell',
      'Alleles are sequence versions; expression amount and phenotype are different levels.',
      'Alleles'
    ],
    [
      'In which direction is an RNA strand synthesized?',
      '5′ to 3′',
      '3′ to 5′ only',
      'From both ends toward the middle',
      'Without a chemically defined direction',
      'RNA polymerase adds nucleotides so the new RNA grows 5′ to 3′.',
      'Orientation'
    ],
    [
      'Which RNA base pairs with template DNA A?',
      'U',
      'T',
      'C',
      'G',
      'RNA contains uracil, which pairs with template adenine during transcription.',
      'Pairing'
    ],
    [
      'What does a ribosome directly read during translation?',
      'mRNA codons',
      'DNA promoters',
      'tRNA anticodons',
      'Chromosome copy numbers',
      'The ribosome reads triplets in mRNA to direct amino-acid assembly.',
      'Translation'
    ],
    [
      'Which description best fits gene regulation?',
      'Control of the timing and amount of expression',
      'Mandatory replacement of a coding sequence',
      'Conversion of every RNA into DNA',
      'Equal production of all proteins in every cell',
      'Regulation changes when, where and how much a gene is expressed.',
      'Regulation'
    ],
    [
      'What does the supplied UAA codon signal?',
      'Termination of translation',
      'Addition of glutamate',
      'Addition of methionine',
      'Initiation of DNA replication',
      'UAA is a stop signal in the supplied code, not an amino-acid instruction.',
      'Codons'
    ],
    [
      'Template DNA is 3′-TAC-5′. What RNA is produced?',
      '5′-AUG-3′',
      '5′-TAC-3′',
      '5′-UAC-3′',
      '5′-ATG-3′',
      'Complementary pairing with the oriented template produces AUG in RNA.',
      'Transcription reasoning'
    ],
    [
      'Coding DNA is 5′-ATG GAA-3′. Which RNA matches it?',
      '5′-AUG GAA-3′',
      '5′-UAC CUU-3′',
      '5′-ATG GAA-3′',
      '5′-GAA AUG-3′',
      'RNA matches the coding strand in the same direction except U replaces T.',
      'Coding strand'
    ],
    [
      'Using AUG = methionine and GAA = glutamate, what does AUG GAA encode?',
      'Methionine then glutamate',
      'Glutamate then methionine',
      'Two methionines',
      'A stop then glutamate',
      'Read the supplied mRNA codons in their stated 5′ to 3′ order.',
      'Decoding'
    ],
    [
      'Why can GAA to GAG be synonymous?',
      'Both codons specify glutamate in the supplied code',
      'Every substitution preserves an amino acid',
      'RNA has no reading frame',
      'GAG always stops translation',
      'Code redundancy allows these two different codons to specify the same amino acid.',
      'Substitutions'
    ],
    [
      'Which change usually shifts the downstream reading frame?',
      'One-base insertion inside the translated coding region',
      'Three-base insertion inside that region',
      'Increased transcription without a sequence change',
      'Reduced protein breakdown',
      'Adding one base changes how downstream bases are grouped into triplets.',
      'Frameshifts'
    ],
    [
      'Two cells share coding DNA but differ in mRNA amount. Which mechanism could explain this?',
      'Different transcription regulation',
      'Necessarily different chromosome numbers',
      'Identical expression in both cells',
      'A different genetic code must be operating',
      'Regulatory differences can change RNA production while coding sequence remains the same.',
      'Expression'
    ],
    [
      'In the stated Aa × Aa recessive model, what is the probability of aa per offspring?',
      'One quarter',
      'One half',
      'Three quarters',
      'Exactly one child in every family',
      'Independent one-half chances of transmitting a combine to give one quarter.',
      'Inheritance'
    ],
    [
      'RNA is equal but measured enzyme activity differs between matched cultures. Which next test best probes causation by a variant?',
      'Restore the reference sequence and remeasure activity in repeated matched cultures',
      'Assume RNA abundance proves identical proteins',
      'Change both the growth medium and all measured genes',
      'Infer the variant is causal from its name alone',
      'A controlled sequence restoration tests whether activity follows the proposed cause.',
      'Causal evidence'
    ],
    [
      'A signal doubles mRNA abundance. Which additional result favors increased transcription over slower RNA decay?',
      'An increase in newly synthesized RNA',
      'Unchanged steady-state protein abundance',
      'Slower measured RNA decay',
      'An unchanged coding sequence',
      'New RNA synthesis directly informs transcription, separating it from RNA persistence.',
      'Regulatory evidence'
    ],
    [
      'A mutation occurs only in a skin cell. Which inheritance claim is best supported?',
      'It is not ordinarily transmitted through gametes',
      'Every future child must inherit it',
      'It must be present in every egg or sperm',
      'It changes every cell of the parent immediately',
      'An isolated somatic mutation is not ordinarily carried by the germ line.',
      'Somatic variation'
    ],
    [
      'A three-base insertion preserves the downstream frame. What follows?',
      'Function can still change because an amino acid can be added',
      'Function must be unchanged',
      'All downstream codons must shift by one base',
      'Transcription must cease everywhere',
      'Preserving the frame does not guarantee an unchanged protein or unchanged function.',
      'Mutation limits'
    ],
    [
      'Four offspring of carrier parents are all unaffected. Does this refute the stated recessive probability model?',
      'No; probabilities do not enforce an exact small-family ratio',
      'Yes; exactly one affected child is required',
      'Yes; each parent must transmit only A',
      'No; the model predicts zero affected offspring',
      'Independent outcomes can depart from expected proportions in a small sample.',
      'Probability evidence'
    ],
    [
      'Why does abundant mRNA alone not establish abundant active protein?',
      'Translation, protein breakdown and processing can alter the outcome',
      'mRNA is always unrelated to protein synthesis',
      'Every mRNA molecule produces exactly one permanent protein',
      'Protein activity is determined only by chromosome number',
      'Several regulated steps separate RNA abundance from active protein abundance.',
      'Evidence limits'
    ],
    [
      'Template DNA is 3′-AAA-5′. Using UUU = phenylalanine, what is the decoded fragment?',
      'RNA UUU specifying phenylalanine',
      'RNA AAA specifying phenylalanine',
      'DNA TTT directly translated by a ribosome',
      'RNA UAA adding phenylalanine',
      'Template A pairs with RNA U, producing UUU, whose supplied meaning is phenylalanine.',
      'Mastery decoding'
    ],
    [
      'A promoter variant lowers RNA but leaves the coding sequence unchanged. Which explanation fits?',
      'A regulatory change can reduce production of the same encoded protein',
      'The protein amino-acid sequence must gain one residue',
      'The mutation must be a coding frameshift',
      'All cell types must lose the entire gene',
      'Promoter changes can affect transcription without altering the encoded amino-acid sequence.',
      'Mastery regulation'
    ],
    [
      'A variant tracks a trait in a small pedigree. What conclusion is strongest?',
      'It supports an inheritance hypothesis that needs further molecular and family evidence',
      'It proves a complete molecular mechanism',
      'It proves environment has no influence',
      'It establishes the same inheritance model for every trait',
      'Pedigree association is evidence, but does not alone establish mechanism or exclude alternatives.',
      'Mastery evidence'
    ],
  ],
);
