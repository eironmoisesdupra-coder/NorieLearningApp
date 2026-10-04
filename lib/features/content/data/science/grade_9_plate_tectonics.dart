import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';

const Map<String, ScienceFigure> grade9PlateTectonicsFigures = {
  'sci-g9-5-seafloor': ScienceFigure(
      picture: 'g9-seafloor',
      title: 'Test spreading against age and magnetic evidence',
      kind: 'comparison',
      labels: ['Young center', 'Paired magnetic bands', 'Older outward'],
      details: [
        'New basalt forms at a ridge.',
        'Corresponding magnetic patterns occur on both sides.',
        'Ages generally increase away from the ridge.'
      ],
      note:
          'Original idealized drawing: widths are not an actual reversal chronology, and natural spreading can be asymmetric.'),
  'sci-g9-5-depth': ScienceFigure(
      picture: 'g9-subduction',
      title: 'Earthquake depth outlines a descending slab',
      kind: 'comparison',
      labels: ['Trench region', 'Descending slab', 'Depth pattern'],
      details: [
        'Some shallow earthquakes occur near plate contact.',
        'Earthquakes can occur within the sinking slab.',
        'Sources become deeper landward in this model.'
      ],
      note:
          'An unscaled section, not a forecast of individual earthquakes. The surrounding mantle is mostly solid.'),
  'sci-g9-5-gps': ScienceFigure(
      picture: 'g9-gps',
      title: 'Read a rate from repeated positions',
      kind: 'comparison',
      labels: ['Year 0', 'Year 1', 'Year 2'],
      details: [
        '0 cm relative to the reference.',
        '2 cm east relative to the reference.',
        '4 cm east relative to the reference.'
      ],
      note:
          'Invented one-dimensional data. Four centimeters in two years gives 2 cm/year east; the reference must remain consistent.'),
};

final NorieTopicContent grade9PlateTectonicsTopic = scienceTopic(
  grade: 'g9',
  order: 5,
  title: 'Plate Tectonics',
  subtitle:
      'Use rock records, earthquake depths and measured motion to test a changing Earth',
  minutes: 'About 45–50 minutes',
  objectives: [
    'Combine seafloor age and magnetic patterns as evidence for spreading.',
    'Interpret a dipping pattern of earthquake sources as evidence for subduction.',
    'Calculate average motion rates and distinguish one-sided from full spreading rates.',
    'Explain elastic rebound and limits of GPS and hotspot evidence.',
  ],
  introduction:
      'An ocean can widen even though its water does not push continents apart. A plate map is a scientific explanation built from measurements: dated rocks, magnetic patterns, earthquake locations and repeated positions. Your task is to connect those observations and decide what each can actually establish.',
  prerequisiteTopicId: 'science.g9.motion-forces',
  sections: [
    scienceSection('From boundary names to testable evidence',
        '''The lithosphere includes crust and the rigid uppermost mantle. It is divided into plates that can include both continental and oceanic regions. Below it, hotter mantle is mostly solid but deforms slowly over long times. Plates do not float on a planet-wide ocean of liquid magma. Gravity acting on sinking, relatively dense slabs and on elevated oceanic lithosphere helps drive motion as part of mantle convection.

Divergent boundaries separate, convergent boundaries approach, and transform boundaries slide past. Those names summarize relative movement; evidence must establish the movement. A single volcano cannot identify a boundary by itself. Ask what the theory predicts about rock ages, magnetic records and earthquake depths, then compare multiple observations.'''),
    scienceSection('A ridge makes an age pattern',
        '''At an oceanic spreading ridge, rising mantle can partially melt as pressure decreases. Magma cools into new oceanic crust. That crust moves away as more crust forms. A spreading model therefore predicts youngest crust near the ridge and generally older crust farther away on either side. Rock dating tests this prediction; simply seeing a ridge is weaker evidence.

Imagine dated samples 0, 20 and 40 kilometers east of a ridge with ages 0, 1 and 2 million years. This ideal pattern supports a roughly constant one-sided spreading rate. Matching ages at corresponding distances west provide another check. Actual oceans contain faults, unequal rates and missing records, so perfect mirror symmetry is a useful model rather than a universal rule.'''),
    scienceVisual('sci-g9-5-seafloor',
        'Combine age information with the paired magnetic record instead of treating colored stripes as direct photographs.'),
    scienceSection('Magnetism supplies an independent pattern',
        '''As basalt cools, magnetic minerals can preserve the direction of the magnetic field at formation. Earth has experienced reversals of magnetic polarity. Normal and reversed describe the recorded field relative to the present field; they do not mean good and bad rock, positive and negative electric charge, or opposite plate travel directions.

Successive periods of crust formation leave bands of different polarity. Spreading predicts corresponding sequences on both sides of the ridge. Compare the order of the bands, not just their colors. Matching patterns combined with independently dated rocks strongly support seafloor spreading. Stripe widths depend on both formation duration and spreading rate; one wide stripe alone does not prove faster motion. A polarity reversal does not cause plates to reverse their movement.'''),
    scienceSection('Worked example: one side or both sides?',
        '''A sample is 40 km from the ridge and 2 million years old. Step 1: divide distance by elapsed time: 40 ÷ 2 = 20 km per million years. Step 2: convert units. One kilometer is 100,000 cm and one million years is 1,000,000 years, so 1 km per million years equals 0.1 cm/year. The one-sided average rate is therefore 2 cm/year.

Step 3: identify what moved. This calculation concerns one plate relative to the ridge. If the opposite side spreads equally fast in the opposite direction, matching samples separate at 2 + 2 = 4 cm/year. Calling the first answer the full spreading rate would halve the true separation rate in this symmetric model. These are averages over the supplied interval, not a promise of constant speed.'''),
    scienceSection('Earthquake depths reveal recycling',
        '''If ocean crust forms continually, where does older material go? At many convergent boundaries, oceanic lithosphere bends and sinks into the mantle at a subduction zone. A trench marks the surface region where the plate descends. Earthquake sources can trace a dipping zone: shallow near the trench, then deeper beneath the overriding plate. This depth pattern provides evidence unavailable from a flat map of surface volcanoes.

Earthquakes also occur within the descending slab, so do not put every source on a shallow plate interface. Ridges and transform boundaries mainly have shallow earthquakes; a deep dipping pattern is especially informative about subduction. Depth alone does not give earthquake magnitude or predict an exact future event. Surface shaking also depends on distance, local ground and other conditions.'''),
    scienceVisual('sci-g9-5-depth',
        'Read the direction of increasing source depth. This schematic provides no measured depths or distances.'),
    scienceSection('Elastic rebound connects slow motion and sudden slip',
        '''A fault is a fracture or zone along which rock blocks move. Friction can lock part of a fault while surrounding plate motion continues. Nearby rock deforms elastically, storing energy. When the locked region slips, some stored energy travels as seismic waves and the rocks partly spring toward a less strained shape. This is elastic rebound.

Slow average plate motion therefore does not imply smooth sliding everywhere at every moment. Nor does an earthquake mean an entire plate suddenly stops moving afterward. A measured average rate cannot supply the date of the next rupture: locking, stress and fault properties vary. Use this mechanism to explain the difference between accumulating deformation and rapid energy release, not to make an unsupported earthquake prediction.'''),
    scienceSection('Guided example: measure a modern rate',
        '''GPS instruments repeatedly measure station positions relative to a chosen reference. Use an invented eastward record: year 0 at 0 cm, year 1 at 2 cm, year 2 at 4 cm. First find displacement: 4 − 0 = 4 cm east. Then divide by the two-year interval: 4 ÷ 2 = 2 cm/year east. Direction matters; a rate without a reference can be misleading.

Now try a second record: a station shifts 15 cm east over 5 years. The average is 15 ÷ 5 = 3 cm/year east. If that rate stayed constant for another 4 years, the additional displacement would be 3 × 4 = 12 cm east. The conditional prediction is a model, not guaranteed motion. Short GPS records and million-year rock records average over different intervals.'''),
    scienceVisual('sci-g9-5-gps',
        'Use change in position divided by elapsed time; keep the reference and units consistent.'),
    scienceSection('Hotspot tracks and the limits of a model',
        '''A chain of volcanic centers can become older away from an active center as a plate passes over a relatively persistent magma source. Under an approximately stationary hotspot assumption, the direction from the young active center toward older centers indicates plate travel. This offers evidence that differs from ridge magnetism or GPS.

However, hotspots need not remain perfectly fixed, and volcanic histories can be complicated. Do not treat every volcano as a plate boundary or every island chain as proof of a motionless source. Compare the age sequence, locations and other motion evidence. An explanation becomes stronger when independent measurements agree, while disagreement invites checking assumptions, uncertainty and the time intervals being compared.'''),
    scienceSection('Observation activity and common mistakes',
        '''Draw a ridge on paper. On both sides, arrange three paired bands in the same outward polarity order and label their ages youngest to oldest. Predict where a newly formed sample belongs. Then make one side wider to represent faster spreading and notice that matching age bands need not sit at equal distances. This paper model needs no heat, chemicals or internet access.

Correct three tempting errors: magnetic polarity records field direction rather than plate direction; a one-sided rate becomes a full rate only after including the other side; and a solid mantle can flow slowly without being a liquid ocean. Always distinguish an observed quantity, such as a dated rock age, from an inference, such as a long-term motion rate.'''),
    scienceSection(
        'Quick check: reveal your reasoning',
        '''Two matching samples lie 30 km on either side of a ridge and are 3 million years old. What are the one-sided and full separation rates if spreading is symmetric?

Each side: 30 ÷ 3 = 10 km per million years = 1 cm/year. Full separation: 1 + 1 = 2 cm/year. Using the 60 km sample-to-sample distance directly gives the same full result. The assumed symmetry matters.''',
        reveal: true),
    scienceSection('Recap: several records, one tested explanation',
        '''Young ridge crust and matching magnetic sequences support spreading. A dipping earthquake zone supports a descending slab. GPS directly tracks recent position changes in a stated reference; hotspot age chains add evidence with source-motion assumptions. Rates require consistent units and clearly identified endpoints. Together these records explain moving and recycled lithosphere while leaving exact earthquake timing unresolved.'''),
  ],
  keyConcept:
      'Plate tectonics is tested with converging evidence. Rock ages, magnetism, earthquake depths and position measurements constrain movement, but each record has limits and a particular time scale.',
  questions: [
    [
      'What does the lithosphere include?',
      'Crust and rigid uppermost mantle',
      'Only liquid magma',
      'Only continental crust',
      'Only the deep core',
      'A plate contains crust plus rigid uppermost mantle, not merely a continent.',
      'Lithosphere'
    ],
    [
      'Where is oceanic crust generally youngest?',
      'Near its spreading ridge',
      'Always near a trench',
      'Farthest from every ridge',
      'Only beside continents',
      'New oceanic crust forms at the ridge and generally ages as it travels away.',
      'Seafloor age'
    ],
    [
      'What do normal and reversed magnetic bands record?',
      'Field directions when rocks cooled',
      'Opposite plate travel directions',
      'Positive and negative electric charges',
      'Water temperature changes only',
      'Cooling magnetic minerals preserve field direction, not the direction of plate travel.',
      'Magnetic record'
    ],
    [
      'Which movement defines a transform boundary?',
      'Plates slide past each other',
      'Plates move directly apart',
      'One plate always sinks vertically',
      'Two plates become motionless',
      'Transform boundaries describe relative sliding past, mainly with shallow earthquakes.',
      'Boundaries'
    ],
    [
      'Which pattern supports subduction?',
      'Earthquake sources deepen along a dipping zone',
      'All ocean rocks have the same age',
      'No earthquakes occur near plates',
      'All volcanoes lie at spreading ridges',
      'A dipping distribution of earthquake sources can trace a descending slab.',
      'Subduction'
    ],
    [
      'What can GPS stations measure repeatedly?',
      'Positions relative to a reference',
      'Exact dates of future earthquakes',
      'All ancient magnetic reversals directly',
      'Only the mass of ocean water',
      'Repeated referenced positions reveal displacement over measured time intervals.',
      'GPS'
    ],
    [
      'What is elastic rebound?',
      'Partial recovery of strained rock during fault slip',
      'Instant melting of the entire mantle',
      'Reversal of every plate direction',
      'Creation of magnetic bands by rain',
      'Locked faults allow strain to build; slip releases energy and rock partly rebounds.',
      'Elastic rebound'
    ],
    [
      'A sample is 60 km from a ridge and 3 million years old. Its one-sided average rate is?',
      '2 cm/year',
      '20 cm/year',
      '0.2 cm/year',
      '6 cm/year',
      '60 ÷ 3 = 20 km per million years; multiplying by 0.1 gives 2 cm/year.',
      'Rate conversion'
    ],
    [
      'Two sides spread at 3 cm/year each in opposite directions. Their full separation rate is?',
      '6 cm/year',
      '3 cm/year',
      '1.5 cm/year',
      '9 cm/year',
      'The separation grows by both outward displacements: 3 + 3 = 6 cm/year.',
      'Full spreading'
    ],
    [
      'A station moves 12 cm east in 4 years. Its average velocity is?',
      '3 cm/year east',
      '48 cm/year east',
      '8 cm/year west',
      '0.33 cm/year east',
      'Displacement divided by elapsed time gives 12 ÷ 4 = 3 cm/year east.',
      'GPS rate'
    ],
    [
      'Why can a wide magnetic stripe not prove a faster rate by itself?',
      'Its polarity interval may have lasted longer',
      'Wide stripes contain no minerals',
      'All stripes must have identical widths',
      'Magnetic bands measure earthquake magnitude',
      'Width depends on both spreading rate and the duration of crust formation in that polarity interval.',
      'Evidence limits'
    ],
    [
      'What can happen while part of a fault remains locked?',
      'Surrounding rock accumulates elastic strain',
      'All nearby plate motion must end',
      'Every rock becomes liquid immediately',
      'The next rupture date becomes certain',
      'Surrounding motion can deform rock even while friction locks a fault region.',
      'Strain'
    ],
    [
      'In a stationary-hotspot model, a chain gets older westward from its active center. Plate motion is?',
      'Westward',
      'Eastward',
      'Necessarily downward only',
      'Impossible to infer in this model',
      'Under the stated fixed-source assumption, older centers have been carried west from the active center.',
      'Hotspot model'
    ],
    [
      'Why might recent GPS and ancient rock rates differ?',
      'They average over different time intervals',
      'GPS measures only magnetic polarity',
      'Rock ages cannot support any rates',
      'Plate speed must always be constant',
      'Different averaging intervals and changing motion can produce different estimates without invalidating both records.',
      'Time scales'
    ],
    [
      'Matching rocks 50 km apart across a ridge are 5 million years old. What is their average separation rate?',
      '1 cm/year',
      '2 cm/year',
      '10 cm/year',
      '0.1 cm/year',
      'The full endpoint distance gives 50 ÷ 5 = 10 km per million years = 1 cm/year.',
      'Endpoints'
    ],
    [
      'A station averages 2.5 cm/year east. If unchanged for 4 more years, additional displacement is?',
      '10 cm east',
      '6.5 cm east',
      '0.625 cm west',
      '25 cm west',
      'The conditional model gives displacement = rate × time = 2.5 × 4 = 10 cm east.',
      'Conditional prediction'
    ],
    [
      'A ridge has paired polarity sequences and crust ages increasing outward. Best conclusion?',
      'Two different records support spreading',
      'Magnetic reversals cause earthquake dates',
      'All plates move at exactly this ridge rate',
      'The mantle must be wholly liquid',
      'Ages and magnetic ordering independently match predictions of crust forming and moving away.',
      'Combined evidence'
    ],
    [
      'Earthquakes dip beneath a continent. What extra information would a flat epicenter map omit?',
      'Source depths below the surface',
      'Whether map symbols have colors',
      'The existence of the continent',
      'All horizontal source locations',
      'Depth measurements reveal the descending geometry that a surface-only location map cannot show.',
      'Depth evidence'
    ],
    [
      'Two matching-age bands lie 20 km east and 30 km west of a ridge. What should be checked?',
      'Whether spreading was asymmetric',
      'Whether matching ages force equal distances',
      'Whether both rocks must be electrically charged',
      'Whether the ridge had no crust formation',
      'Unequal distances at matching ages can reflect different average rates on the two sides.',
      'Asymmetry'
    ],
    [
      'A student predicts an exact earthquake date from a plate rate. Best correction?',
      'Average motion alone does not determine rupture timing',
      'Divide the rate by two for the exact date',
      'Magnetic polarity supplies the missing calendar day',
      'Use a hotspot chain as a universal earthquake clock',
      'Fault locking, stress and rock properties vary; a motion average is not an exact rupture forecast.',
      'Forecast limits'
    ],
    [
      'A rock lies 80 km east of a ridge and is 4 million years old. The west side spreads equally fast. Full rate?',
      '4 cm/year',
      '2 cm/year',
      '8 cm/year',
      '20 cm/year',
      'One side gives 80 ÷ 4 × 0.1 = 2 cm/year; both outward sides together give 4 cm/year.',
      'Mastery spreading'
    ],
    [
      'Which account links slow deformation to a sudden earthquake?',
      'Friction locks a fault, strain builds, then slip releases energy',
      'The whole mantle melts, then every plate stops',
      'Magnetic polarity switches, fixing the rupture date',
      'A GPS station causes a fault to unlock',
      'Elastic rebound connects continued surrounding motion, stored strain and rapid fault slip.',
      'Mastery mechanism'
    ],
    [
      'An age-ordered volcanic chain suggests westward motion, but its source may have moved. Best next step?',
      'Compare independent motion evidence and source assumptions',
      'Declare all hotspots permanently stationary',
      'Reject every possible use of rock ages',
      'Infer exact future earthquakes from the oldest island',
      'Hotspot tracks require assumptions; GPS and rock records provide independent checks over stated intervals.',
      'Mastery evidence'
    ],
  ],
);
