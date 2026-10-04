import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'science_lesson_builder.dart';
import 'grade_11_data_analysis.dart';

final List<NorieTopicContent> grade11ScienceTopics = [
  _cellBiology,
  _stoichiometry,
  _mechanics,
  _earthMaterials,
  grade11DataAnalysisTopic,
];

const Map<String, ScienceFigure> grade11ScienceFigures = {
  'sci-g11-1-transport': ScienceFigure(
      picture: 'g11-cell',
      title: 'Direction and energy distinguish transport',
      kind: 'comparison',
      labels: ['Simple diffusion', 'Facilitated diffusion', 'Active transport'],
      details: [
        'Small nonpolar molecules cross the lipid region down their concentration gradient.',
        'A channel or carrier provides a selective route down an electrochemical gradient.',
        'Energy input supports movement against an electrochemical gradient.'
      ],
      note:
          'For uncharged solutes, concentration determines the gradient; ions also respond to voltage.'),
  'sci-g11-1-energy': ScienceFigure(
      title: 'Couple a favorable reaction to cellular work',
      kind: 'process',
      labels: ['Food oxidation', 'ATP production', 'Coupled work'],
      details: [
        'Chemical energy is transferred through controlled reactions.',
        'ADP and phosphate are assembled into ATP using an energy input.',
        'ATP hydrolysis can be coupled to pumping, synthesis or movement.'
      ],
      note:
          'ATP is recycled; energy is transferred, not created. Some energy disperses as heat.'),
  'sci-g11-1-cycle': ScienceFigure(
      title: 'Replication and division require different checks',
      kind: 'cycle',
      labels: ['G1', 'S', 'G2', 'M'],
      details: [
        'Growth; conditions and DNA damage are checked before replication.',
        'DNA is replicated.',
        'Replication completion and DNA damage are checked before mitosis.',
        'Chromosome attachment is checked before separation; nuclear and cell division follow.'
      ],
      note:
          'A simplified eukaryotic cycle; checkpoint failure increases risk but does not alone guarantee cancer.'),
  'sci-g11-2-mole': ScienceFigure(
      picture: 'g11-stoichiometry',
      title: 'Coefficients count molecules or moles',
      kind: 'process',
      labels: ['2 mol H2', '1 mol O2', '2 mol H2O'],
      details: [
        '4 g using H = 1 g/mol.',
        '32 g using O = 16 g/mol.',
        '36 g total product under complete conversion.'
      ],
      note: '2H2 + O2 → 2H2O. The 2:1:2 ratio is not a gram ratio.'),
  'sci-g11-2-limiting': ScienceFigure(
      title: 'Compare product capacity from both reactants',
      kind: 'comparison',
      labels: ['3 mol H2 available', '2 mol O2 available', 'Hydrogen limits'],
      details: [
        'Can make 3 mol H2O.',
        'Can make 4 mol H2O if enough hydrogen exists.',
        '3 mol H2O form; 1.5 mol O2 react and 0.5 mol remain.'
      ],
      note:
          'Complete reaction in an ideal stoichiometric model; no competing reactions.'),
  'sci-g11-2-yield': ScienceFigure(
      title: 'Compare measured recovery with the predicted maximum',
      kind: 'bars',
      labels: ['Theoretical water', 'Recovered water'],
      details: [
        'Calculated from the limiting reactant.',
        'Measured isolated product.'
      ],
      values: [36, 27],
      unit: 'g',
      note:
          'Percent yield = 27/36 × 100 = 75%. Missing recovery does not mean atoms vanished.'),
  'sci-g11-3-vectors': ScienceFigure(
      picture: 'g11-mechanics',
      title: 'Add signed forces on the same cart',
      kind: 'comparison',
      labels: ['Rightward force', 'Leftward force', 'Net force'],
      details: ['+10 N.', '−4 N.', '+6 N; a 3 kg cart accelerates at +2 m/s².'],
      note:
          'Right is positive; horizontal model with constant mass. Balanced vertical forces do not affect this sum.'),
  'sci-g11-3-motion': ScienceFigure(
      title: 'Constant acceleration connects velocity and displacement',
      kind: 'process',
      labels: ['Start', 'After 3 s', 'Displacement'],
      details: [
        'Initial velocity +2 m/s; acceleration +2 m/s².',
        'Final velocity = 2 + 2 × 3 = +8 m/s.',
        'Average velocity = (2 + 8)/2 = +5 m/s; displacement = +15 m.'
      ],
      note:
          'These average-velocity and kinematics formulas require constant acceleration over the interval.'),
  'sci-g11-3-energy': ScienceFigure(
      title: 'Name the system before accounting for energy',
      kind: 'comparison',
      labels: ['Cart alone', 'Cart plus Earth', 'With frictional heating'],
      details: [
        'Gravity can do external work and change cart kinetic energy.',
        'Gravitational potential energy is included in the system.',
        'Mechanical energy may decrease as thermal energy increases.'
      ],
      note:
          'An isolated system conserves total energy; mechanical energy alone requires additional conditions.'),
  'sci-g11-4-mineral': ScienceFigure(
      title: 'Combine diagnostic properties',
      kind: 'comparison',
      labels: ['Hardness', 'Cleavage', 'Streak'],
      details: [
        'Resistance to scratching; compare against reference materials.',
        'Repeated flat break directions related to crystal structure.',
        'Color of a powdered mineral, when a usable streak is produced.'
      ],
      note:
          'Color alone is often unreliable; hardness is not resistance to breaking.'),
  'sci-g11-4-texture': ScienceFigure(
      picture: 'g11-materials',
      title: 'Texture preserves evidence of formation',
      kind: 'comparison',
      labels: [
        'Coarse interlocking crystals',
        'Cemented rounded grains',
        'Aligned mineral grains'
      ],
      details: [
        'Often evidence of slow cooling of magma.',
        'Evidence of sediment transport, deposition and lithification.',
        'Can record recrystallization under directed stress.'
      ],
      note:
          'Use several observations. These clues support histories but do not give an exact age or location.'),
  'sci-g11-4-cycle': ScienceFigure(
      title: 'A rock can follow several routes',
      kind: 'process',
      labels: [
        'Weathering and erosion',
        'Deposition and lithification',
        'Metamorphism or melting'
      ],
      details: [
        'Existing rock breaks down; particles are transported.',
        'Buried sediment may compact and cement into rock.',
        'Solid-state change produces metamorphic rock; melting followed by cooling produces igneous rock.'
      ],
      note:
          'There is no required single cycle order. Uplift can expose any rock type to weathering.'),
  ...grade11DataAnalysisFigures,
};

final _earthMaterials = scienceTopic(
  grade: 'g11',
  order: 4,
  title: 'Earth Materials',
  subtitle: 'Use mineral properties and rock textures as evidence of history',
  minutes: '30–35 minutes',
  prerequisiteTopicId: 'science.g11.mechanics',
  objectives: [
    'Distinguish mineral identity from rock classification.',
    'Interpret hardness, cleavage and streak using stated observations.',
    'Connect rock textures with cooling, sediment transport and metamorphism.',
    'Construct qualified formation histories from multiple clues.'
  ],
  introduction:
      'Two gray rocks can have very different histories, while two differently colored crystals can be the same mineral. A geologist therefore asks more than what a specimen looks like. Which properties are repeatable? How are its grains arranged? What processes could leave those clues, and what additional evidence would distinguish competing explanations?',
  sections: [
    scienceSection('A mineral is not simply a small rock',
        '''In the introductory geological definition, a mineral is a naturally occurring, generally inorganic solid with an ordered internal structure and a characteristic chemical composition that may vary within limits. A rock is an aggregate of minerals, mineraloids or other geological material. Some rocks are dominated by one mineral; others contain several. Glassy volcanic material lacks the long-range crystalline order required by this mineral definition, yet can form part or all of an igneous rock.

Mineral identity and rock classification answer different questions. Quartz is a mineral; granite is a rock commonly containing several minerals, including quartz and feldspar. Finding quartz in an unknown rock does not by itself identify that rock or its formation environment. Mineral composition, grain relationships, texture and field context contribute different evidence.'''),
    scienceSection('Hardness measures scratching, not strength',
        '''Hardness is resistance to scratching. In a controlled comparison, a harder material can scratch a softer one. The Mohs scale is an ordinal comparison scale, not a linear measurement: a hardness of 8 is not simply twice as hard as 4. For our identification exercises use these reference values: calcite 3, feldspar 6 and quartz 7. A test mark should be a real groove, not loose powder left on the surface.

If a specimen scratches calcite but is scratched by feldspar, its hardness lies between those references, approximately above 3 and below 6. That range narrows possibilities but does not uniquely identify a mineral. Hardness differs from toughness or resistance to breaking. A mineral can resist scratching yet break when struck. Never infer suitability for construction from hardness alone.'''),
    scienceSection('Cleavage, fracture and streak add evidence',
        '''Cleavage is a tendency to break along repeated flat planes related to weaker directions in a mineral’s crystal structure. Fracture describes other break surfaces. Quartz commonly shows curved, conchoidal fracture rather than cleavage; feldspar commonly has two cleavage directions near right angles. A naturally flat crystal face is not automatically evidence of cleavage. Look for repeated parallel break surfaces rather than a single external outline.

Streak is the color of powdered mineral, often examined using an appropriate unglazed plate when the mineral is softer than the plate. Surface color may vary with impurities, weathering or coatings, while streak can be more consistent. Hard minerals may scratch the plate instead of leaving a useful powder streak. A missing streak is therefore not a universal identity test.'''),
    scienceVisual('sci-g11-4-mineral',
        'Each test measures a different property; combine results instead of identifying by color alone.'),
    scienceSection('Worked example: narrow a mineral identity',
        '''A supplied reference card lists quartz as hardness 7 with no cleavage, feldspar as hardness 6 with two cleavage directions, and calcite as hardness 3. An unknown specimen scratches calcite, is scratched by quartz, and shows two repeated flat break directions near right angles. Step 1: the hardness test places it above calcite and below quartz. Step 2: repeated flat breaks provide cleavage evidence. Step 3: among the three listed choices, feldspar best fits both observations.

This is identification within a limited candidate set, not proof against every mineral in nature. Another mineral could share some properties. A field geologist may add luster, density, composition or other tests and inspect a fresh surface. State the candidate set when a classroom problem depends on it.'''),
    scienceSection('Cooling leaves an igneous texture',
        '''Igneous rocks form when molten material cools and solidifies. Slow cooling commonly allows crystals more time to grow, producing coarse interlocking grains. Faster cooling often produces finer crystals; extremely rapid cooling can produce glass. Gas bubbles trapped during solidification can leave vesicles, or holes. Cooling rate is a useful explanation of texture, but chemistry and growth conditions also matter.

A coarse crystalline sample commonly supports slow cooling below the surface. A fine-grained volcanic sample commonly supports faster cooling near the surface. A porphyritic texture contains larger crystals in a finer groundmass and can record more than one stage of cooling. Large crystals begin growing under earlier conditions, then the surrounding melt cools faster. Texture supports a history, not an exact cooling time or depth without additional measurements.'''),
    scienceSection('Sedimentary textures record transport and burial',
        '''Weathering breaks down or chemically alters existing material. Erosion removes it, transport moves it, and deposition leaves it in a new location. Clastic sedimentary rocks form from fragments that can become rock through lithification, including compaction and cementation. Compaction packs grains more closely; cementation deposits minerals in pore spaces that bind grains together. Not all sedimentary rocks are clastic: some form through chemical precipitation or biological accumulation.

Rounded grains can indicate abrasion during transport, while angular grains may suggest less abrasion, but hardness and transport conditions also influence shape. Sorting describes the range of grain sizes: well-sorted sediment has a narrow range, poorly sorted sediment a broad range. Layers may record changes in deposition. None of these clues alone uniquely determines a river, beach or desert setting; compare several observations and the surrounding geology.'''),
    scienceVisual('sci-g11-4-texture',
        'Grain relationships distinguish three histories more usefully than an isolated color label.'),
    scienceSection('Metamorphism changes rock without bulk melting',
        '''Metamorphic rocks form when existing rocks change in the solid state under heat, pressure, stress and chemically active fluids. Minerals can recrystallize or new minerals can form. Directed stress can align certain minerals, producing foliation: a planar fabric or arrangement. Foliation is not simply a stack of deposited sediment layers. Its mineral orientation records a different process.

Not every metamorphic rock is foliated. Marble can form by recrystallization of limestone and commonly lacks foliation; the original and new rock may both be dominated by calcite. If rock melts and the melt later solidifies, that product is igneous. The distinction is about the formation process, not whether a specimen ever experienced heat. Several stages can overprint one another in a long rock history.'''),
    scienceSection('The rock cycle is a network of possible changes',
        '''Any exposed rock type can weather. Sediment can be buried and lithified; existing rock can be metamorphosed; rock can melt and later crystallize. Uplift and erosion can expose deeply formed material. There is no compulsory sequence in which every rock must become sedimentary, then metamorphic, then igneous. A rock can remain in one setting for a long time or follow a shorter route between categories.

Separate the observation from the inference. “Interlocking crystals are visible” is an observation. “The magma cooled slowly” is an interpretation supported by that texture and other evidence. Neither sentence provides an absolute age. Determining age requires additional evidence and suitable methods, rather than assuming that coarse rocks are always older than fine rocks.'''),
    scienceVisual('sci-g11-4-cycle',
        'The arrows describe possible processes; they do not require every rock to visit every stage.'),
    scienceSection('Guided example: compare two histories',
        '''Sample A contains rounded grains cemented together in layers. Sample B contains elongated mineral grains with a common alignment and evidence of solid-state recrystallization. For each, name the observations, propose the broad rock class and identify one further fact you would want before naming a precise formation environment.

Then imagine Sample A buried and heated without melting until its minerals recrystallize. Explain how its later classification could change while preserving some earlier clues. A history can contain both deposition and metamorphism; choosing its present rock class does not erase its previous stages.'''),
    scienceSection('Reveal: evidence supports a bounded history',
        'A supports a clastic sedimentary history of transport, deposition and cementation. B supports metamorphism, with alignment consistent with directed stress. Regional setting or additional mineral and sediment features would help identify a precise environment. If A recrystallizes in the solid state, it can become metamorphic while retaining some inherited structure.',
        reveal: true),
    scienceSection('A safe specimen or photograph investigation',
        '''Use labeled classroom specimens or clear photographs approved by your teacher. Record grain size, shape, arrangement, visible pores and repeated planar surfaces before looking at the label. Group the evidence into observations and possible interpretations. Compare two proposed histories and write what extra observation would help distinguish them.

Use the supplied hardness results rather than scratching unknown building surfaces or breaking stones. Do not taste minerals, breathe rock dust or use acid on unidentified material. A photograph cannot establish hardness, streak or chemical composition, so mark those as unknown. Honest missing data are more useful than invented measurements when evaluating an identification.'''),
    scienceSection('Common mistakes and quick check',
        'Do not identify every mineral by color, treat hardness as toughness, call all planar patterns sedimentary bedding, or describe metamorphism as melting. Quick check: a coarse crystalline rock is found at the surface. Does its current location prove it cooled at the surface?'),
    scienceSection('Check your thinking',
        'No. Slow cooling below ground may have formed its coarse texture; later uplift and erosion could expose it. Present location and formation location can differ. Additional field evidence is needed to reconstruct that history.',
        reveal: true),
    scienceSection('Recap',
        'Use several mineral properties and distinguish scratch resistance from breaking behavior. Read rock textures as process evidence, then qualify the inferred history with composition and field context. Treat the rock cycle as possible pathways and keep observations separate from interpretations and unknowns.'),
  ],
  keyConcept:
      'Mineral properties and rock textures constrain formation histories, but reliable identification combines independent observations and states what remains uncertain.',
  questions: [
    [
      'Which feature belongs in the introductory definition of a mineral?',
      'Ordered internal structure',
      'A required mixture of several rocks',
      'A required gray surface color',
      'A required visible layered texture',
      'Minerals have ordered structures and characteristic compositions.',
      'Mineral definition'
    ],
    [
      'Which comparison correctly distinguishes quartz and granite?',
      'Quartz is a mineral; granite is a rock',
      'Quartz is a rock; granite is a mineral',
      'Both are single chemical elements',
      'Both are defined only by grain size',
      'Granite commonly contains multiple minerals, including quartz.',
      'Rock and mineral'
    ],
    [
      'What does mineral hardness measure?',
      'Resistance to scratching',
      'Resistance to every kind of breaking',
      'Age since crystallization',
      'Amount of sedimentary layering',
      'Hardness measures scratching, not toughness or age.',
      'Hardness'
    ],
    [
      'What is mineral cleavage?',
      'Repeated breaking along structurally favored flat planes',
      'Any rounded transport grain',
      'Any color variation on a surface',
      'A measure of cooling duration',
      'Cleavage reflects repeated weak directions in the crystal structure.',
      'Cleavage'
    ],
    [
      'What does a mineral streak describe?',
      'Color of its powder',
      'Color of the unpowdered outer surface',
      'Length of its largest crystal',
      'Age of its outer coating',
      'A usable streak is the powdered mineral color.',
      'Streak'
    ],
    [
      'Which process binds sediment grains by depositing minerals in pore spaces?',
      'Cementation',
      'Melting',
      'Cleavage',
      'Abrasion',
      'Cementation forms mineral bonds among deposited grains.',
      'Lithification'
    ],
    [
      'Which condition distinguishes metamorphism from igneous formation in this lesson?',
      'Rock changes in the solid state without bulk melting',
      'Rock must always form at the surface',
      'Rock must always contain rounded grains',
      'Rock must cool directly from a melt',
      'Metamorphism changes existing solid rock; solidification of melt is igneous.',
      'Metamorphism'
    ],
    [
      'A specimen scratches calcite at hardness 3 but is scratched by feldspar at 6. What range does this support?',
      'Hardness between about 3 and 6',
      'Hardness below 3',
      'Hardness above 6',
      'Hardness exactly 9',
      'The harder-than and softer-than comparisons bracket its scratch resistance.',
      'Hardness inference'
    ],
    [
      'Why is Mohs hardness 8 not interpreted as twice the hardness of 4?',
      'The scale is ordinal rather than linear',
      'All minerals have identical scratch resistance',
      'The scale measures rock age instead',
      'Every step represents an identical increase in scratch resistance',
      'Mohs values rank comparison materials; equal steps are not equal physical increments.',
      'Scale meaning'
    ],
    [
      'A hard mineral scratches a streak plate without leaving powder. What follows?',
      'This test did not provide a useful streak color',
      'The mineral has no internal structure',
      'The mineral must be calcite',
      'The mineral is necessarily sedimentary',
      'A harder specimen may scratch the plate instead of producing a diagnostic streak.',
      'Test limitations'
    ],
    [
      'Among quartz, feldspar and calcite, which best fits hardness near 6 and two cleavage directions near right angles?',
      'Feldspar',
      'Quartz',
      'Calcite',
      'All three equally',
      'The supplied reference combines feldspar hardness and cleavage.',
      'Combined identification'
    ],
    [
      'Coarse interlocking crystals in an igneous sample commonly support which history?',
      'Relatively slow cooling of molten material',
      'Only very rapid quenching',
      'Cementation of rounded sediment',
      'Only surface chemical weathering',
      'Slow cooling often allows more crystal growth.',
      'Cooling texture'
    ],
    [
      'Large crystals set in a much finer igneous groundmass can suggest what?',
      'More than one stage of cooling',
      'Exactly one fixed cooling rate is proven',
      'The sample must be a single mineral',
      'The sample could not have formed from melt',
      'Earlier crystal growth followed by faster cooling can produce porphyritic texture.',
      'Cooling history'
    ],
    [
      'A sediment sample has a narrow range of grain sizes. How is its sorting described?',
      'Well sorted',
      'Poorly sorted',
      'Foliated',
      'Glassy',
      'Sorting concerns grain-size range, not mineral hardness.',
      'Sediment sorting'
    ],
    [
      'Why do rounded grains alone not prove deposition on a beach?',
      'Several transport settings can abrade grains',
      'Rounding never involves transport',
      'All rounded grains form by melting',
      'Rounded grains always lack minerals',
      'Grain shape is useful but does not uniquely identify a depositional environment.',
      'Environmental inference'
    ],
    [
      'A rock shows aligned minerals produced during solid-state recrystallization. Which explanation best fits?',
      'Metamorphic foliation influenced by directed stress',
      'A required sequence of sediment deposition only',
      'Direct glass formation from quenching',
      'An absence of any previous rock',
      'Mineral alignment during metamorphism can produce foliation.',
      'Foliation'
    ],
    [
      'Why can a nonfoliated marble still be metamorphic?',
      'Metamorphism does not require foliation',
      'Marble must always be volcanic glass',
      'Only layered rocks undergo heating',
      'Absence of foliation proves no recrystallization',
      'Marble can form through solid-state recrystallization without a foliation fabric.',
      'Metamorphic variety'
    ],
    [
      'An existing rock melts completely and the melt cools into new rock. How is the new product classified by that final process?',
      'Igneous',
      'Metamorphic solely because heat was involved',
      'Clastic sedimentary',
      'Unclassified because melting prevents rock formation',
      'Solidification from melt is an igneous process.',
      'Formation process'
    ],
    [
      'Which statement separates observation from inference correctly?',
      'Visible interlocking grains are observed; slow cooling is inferred',
      'Slow cooling is directly seen in every present specimen',
      'An exact age is observed from grain size alone',
      'A gray color directly measures formation depth',
      'Texture is observable; the proposed process is an interpretation.',
      'Evidence language'
    ],
    [
      'A coarse igneous rock lies exposed at ground level. Which history remains possible?',
      'It cooled underground and was later exposed by uplift and erosion',
      'It necessarily cooled at its present surface position',
      'It must have formed by cementing sand',
      'Its present location proves an exact crystallization age',
      'Formation conditions and current location can differ.',
      'Multiple-stage history'
    ],
    [
      'An unknown among quartz, feldspar and calcite scratches feldspar and shows curved fracture without cleavage. Which candidate best fits?',
      'Quartz',
      'Calcite',
      'Feldspar',
      'All three fit equally',
      'Quartz has hardness 7 above feldspar 6 and commonly shows conchoidal fracture.',
      'Mastery mineral'
    ],
    [
      'A specimen has rounded cemented grains and layered deposits. Which sequence best explains these features?',
      'Transport, deposition and lithification',
      'Melting followed only by glass quenching',
      'Crystal growth followed only by solid-state alignment',
      'Only solid-state alignment with no sediment stage',
      'The combined grain and layering evidence supports clastic sedimentary formation.',
      'Mastery texture'
    ],
    [
      'A sedimentary rock recrystallizes under heat and directed stress without melting. What conclusion fits both process and history?',
      'It becomes metamorphic and may retain some older features',
      'It must become igneous whenever heated',
      'Its earlier sedimentary history becomes impossible',
      'It cannot change class without first melting',
      'Solid-state metamorphism can overprint rather than erase every earlier clue.',
      'Mastery rock pathway'
    ],
  ],
);

final _mechanics = scienceTopic(
  grade: 'g11',
  order: 3,
  title: 'Mechanics',
  subtitle: 'Connect vectors, motion equations, forces and energy accounts',
  minutes: '30–35 minutes',
  prerequisiteTopicId: 'science.g11.stoichiometry',
  objectives: [
    'Distinguish scalar distance and speed from vector displacement and velocity.',
    'Solve one-dimensional motion with constant acceleration and stated signs.',
    'Connect a free-body force sum to acceleration.',
    'Use work and energy with an explicit system boundary.'
  ],
  introduction:
      'A cart can move right while its acceleration points left. It can also travel far and finish where it started. These are not contradictions: direction, change and system boundaries answer different questions. Mechanics becomes more reliable when each calculation begins with a sketch and a statement of what is being measured.',
  sections: [
    scienceSection('Direction belongs in the quantity',
        '''Distance is the total length of a path, while displacement is final position minus initial position. Distance is a scalar; displacement is a vector with magnitude and direction. Speed describes how fast path length accumulates, while velocity describes position change per time with direction. Average speed is total distance/elapsed time; average velocity is displacement/elapsed time.

Imagine walking 6 m east and then 2 m west in 4 s. Choose east as positive. Distance is 8 m, displacement is +4 m, average speed is 2 m/s and average velocity is +1 m/s. If a trip returns to its start, displacement and average velocity are zero even though distance and average speed need not be. The sign is part of the vector description, not a label for whether the motion is successful.'''),
    scienceSection('Combine vectors before taking magnitudes',
        '''Along one line, choose a positive direction and add signed components. Opposite forces subtract because their components have opposite signs. In two perpendicular directions, components describe independent parts of the same vector. A displacement of 3 m east followed by 4 m north has magnitude √(3² + 4²) = 5 m, while the traveled distance is 7 m. Adding magnitudes would lose the geometry.

This lesson uses simple perpendicular components and one-dimensional motion; a full direction angle is not required. Draw the east and north arrows head to tail. The displacement arrow joins the start directly to the finish. Its length represents magnitude only if the drawing uses a consistent scale. An illustrative sketch without scale can show direction but cannot supply a numerical answer by measurement.'''),
    scienceSection('Acceleration describes velocity change',
        '''Average acceleration is change in velocity divided by elapsed time: a = (v − u)/t, where u is initial velocity and v is final velocity. For constant acceleration, this average equals acceleration throughout the interval. If right is positive, a cart slowing from +8 m/s to +2 m/s in 3 s has a = (2 − 8)/3 = −2 m/s².

Negative acceleration does not always mean slowing down. A cart moving left with velocity −2 m/s and acceleration −2 m/s² increases its leftward speed. Speed decreases when velocity and acceleration point in opposite directions, and increases when they point in the same direction. At an instant of zero velocity, acceleration can still be nonzero, as when an object reverses its direction.'''),
    scienceSection('Use motion equations within their conditions',
        '''For constant acceleration along a fixed axis, v = u + at and displacement s = ut + ½at². An equivalent displacement formula is s = ((u + v)/2)t, because velocity changes linearly with time. Another useful relation is v² = u² + 2as. These equations do not apply across an interval with changing acceleration unless the motion is broken into appropriate segments.

A velocity-time graph makes the assumptions visible. Its slope gives acceleration. The signed area between the graph and the time axis gives displacement. A region below the axis contributes negative displacement. With constant acceleration, the graph is a straight line, so its area can be calculated as a rectangle plus a triangle. A position-time graph is different: its slope gives velocity, not acceleration.'''),
    scienceVisual('sci-g11-3-motion',
        'The straight change from +2 to +8 m/s gives an average velocity of +5 m/s.'),
    scienceSection('Worked example: link force and motion',
        '''A 3 kg cart experiences 10 N right and 4 N left. Ignore other horizontal forces and suppose the vertical forces balance. Step 1: choose right positive. Step 2: sum horizontal forces: Fnet = +10 − 4 = +6 N. Step 3: use Newton’s second law for constant mass, Fnet = ma, giving a = 6/3 = +2 m/s².

If its initial velocity is +2 m/s and those forces stay constant for 3 s, final velocity is 2 + 2 × 3 = +8 m/s. Displacement is 2 × 3 + ½ × 2 × 3² = +15 m. The force sum determines acceleration, not velocity directly. Initial velocity is still needed to predict the later motion.'''),
    scienceVisual('sci-g11-3-vectors',
        'Every horizontal force shown acts on the same cart; their signed sum determines its acceleration.'),
    scienceSection('Keep a free-body diagram about one object',
        '''A free-body diagram shows external forces acting on the chosen object, such as weight, support, friction and an applied pull. Do not place the equal and opposite force that the object exerts on another object into the same force sum. Newton’s third-law pair acts on different objects, so it does not automatically cancel in the equation for either object separately.

Zero net force means zero acceleration in an inertial reference frame. It allows rest or constant velocity. Balanced forces do not require zero velocity, and ongoing motion does not require a forward net force. The idealized cart model assumes a suitable inertial frame, constant mass and stated negligible forces; if those assumptions fail, the calculation must be reconsidered.'''),
    scienceSection('Work changes kinetic energy',
        '''For a constant force, work is W = Fd cos θ, where d is displacement magnitude and θ is the angle between force and displacement. A force in the displacement direction does positive work, an opposing force does negative work, and a perpendicular force does zero work. For the parallel examples here, use signed W = F × s with consistent components.

Kinetic energy is K = ½mv², a nonnegative scalar. The work-energy theorem says net work on a particle-like object equals its change in kinetic energy. For the 3 kg cart speeding from 2 to 8 m/s, initial K is 6 J and final K is 96 J, so ΔK = 90 J. Net work over 15 m is 6 N × 15 m = 90 J. Agreement connects force-based and energy-based descriptions.'''),
    scienceSection('Potential energy belongs to an interaction',
        '''Near Earth’s surface, gravitational potential-energy change is ΔUg = mgΔh using approximately constant g. Use g = 10 m/s² for this lesson’s calculations. Potential energy belongs to the object-Earth interaction; selecting the object plus Earth as the system includes this store. Raising 2 kg by 3 m increases Ug by 2 × 10 × 3 = 60 J. The chosen zero height is arbitrary, but changes between the same two heights agree.

If only gravity transfers between kinetic and gravitational potential energy within that system and friction is negligible, K + Ug stays constant. A 2 kg object falling from rest through 3 m then gains 60 J kinetic energy. If friction or drag transfers energy into thermal energy, mechanical energy can decrease. Total energy remains conserved when all stores and transfers in an isolated system are included.'''),
    scienceVisual('sci-g11-3-energy',
        'Different system boundaries place gravitational energy transfer in different parts of the account.'),
    scienceSection('Guided example: stopping without reversing',
        '''A cart moves at +6 m/s and has constant acceleration −2 m/s² for 3 s. Find final velocity and displacement. Decide whether the displacement is negative merely because acceleration is negative. Draw a velocity-time line from the initial to final velocity and use its area as an independent check.

Use paper and pencil or a small hand-moved object on a clear table to model the signs; do not launch objects or attempt high-speed tests. Mark equal time intervals on a sketch and compare the changing spacing. The calculation describes an ideal motion segment. Extending the same acceleration beyond 3 s would reverse velocity, so the time interval is part of the answer.'''),
    scienceSection('Reveal: check both equations and graph',
        'Final velocity is 6 − 2 × 3 = 0 m/s. Displacement is 6 × 3 + ½ × (−2) × 9 = +9 m. The velocity-time triangle has area ½ × 3 × 6 = +9 m. The cart moves right throughout this interval while slowing to rest.',
        reveal: true),
    scienceSection('Common mistakes and quick check',
        'Do not equate negative acceleration with negative velocity, add perpendicular vector magnitudes as ordinary scalars, or use constant-acceleration equations without checking their condition. Mechanical energy and total energy are not interchangeable. Quick check: friction removes 12 J from a sliding object’s mechanical energy. Must total energy have disappeared?'),
    scienceSection('Check your thinking',
        'No. Include the surface and thermal energy in the system account. A 12 J mechanical decrease can accompany a 12 J thermal increase in an otherwise isolated ideal account. If the chosen system is smaller, energy may also cross its boundary.',
        reveal: true),
    scienceSection('Recap',
        'Choose axes and system boundaries, separate vector changes from scalar magnitudes, and state the time interval. Sum forces on one object to find acceleration. Use motion equations only under their conditions, and check compatible answers using work and energy.'),
  ],
  keyConcept:
      'A consistent axis, force diagram and system boundary allow motion and energy calculations to describe the same event without contradicting one another.',
  questions: [
    [
      'Which quantity is a vector describing final position minus initial position?',
      'Displacement',
      'Distance',
      'Speed',
      'Kinetic energy',
      'Displacement includes magnitude and direction between endpoints.',
      'Vector quantities'
    ],
    [
      'What is the definition of average velocity over a journey?',
      'Displacement divided by elapsed time',
      'Distance divided by elapsed time',
      'Final speed divided by mass',
      'Net force divided by displacement',
      'Average velocity uses signed position change.',
      'Average velocity'
    ],
    [
      'What must be true over an interval to use s = ut + ½at² as taught here?',
      'Acceleration is constant along the chosen axis',
      'Velocity is always zero',
      'Distance equals zero',
      'Every force is absent',
      'The equation assumes constant acceleration for that interval.',
      'Kinematic conditions'
    ],
    [
      'In a velocity-time graph, which feature gives acceleration?',
      'Slope',
      'Signed area',
      'Vertical-axis unit alone',
      'Total horizontal-axis length alone',
      'Acceleration is velocity change per time, the graph slope.',
      'Graph interpretation'
    ],
    [
      'Which force collection belongs in a free-body diagram for a cart?',
      'External forces acting on the cart',
      'Only forces the cart exerts on the floor',
      'Only the largest force on the cart',
      'Both members of every third-law pair regardless of object',
      'Choose one object and include the forces acting on it.',
      'Free-body diagrams'
    ],
    [
      'Which formula gives kinetic energy for a mass m moving at speed v?',
      'K = ½mv²',
      'K = mv',
      'K = mg',
      'K = m/v²',
      'Kinetic energy depends on mass and speed squared.',
      'Kinetic energy'
    ],
    [
      'A constant force perpendicular to displacement does how much work on a particle-like object?',
      'Zero',
      'Fd',
      '−Fd',
      'Twice Fd',
      'cos 90° = 0, so perpendicular force contributes no work.',
      'Work direction'
    ],
    [
      'A learner walks 6 m east then 2 m west in 4 s. What is average velocity, with east positive?',
      '+1 m/s',
      '+2 m/s',
      '−1 m/s',
      '+4 m/s',
      'Displacement is +4 m, so average velocity is 4/4 = +1 m/s.',
      'Journey vectors'
    ],
    [
      'A path goes 3 m east then 4 m north. What is displacement magnitude?',
      '5 m',
      '7 m',
      '1 m',
      '12 m',
      'Perpendicular components give √(3² + 4²) = 5 m.',
      'Perpendicular vectors'
    ],
    [
      'Velocity changes from +8 to +2 m/s in 3 s. What is average acceleration?',
      '−2 m/s²',
      '+2 m/s²',
      '+10/3 m/s²',
      '−6 m/s²',
      'Divide the signed velocity change by elapsed time: (2 − 8)/3 = −2 m/s².',
      'Acceleration calculation'
    ],
    [
      'A cart has velocity −2 m/s and acceleration −2 m/s². What happens to its speed initially?',
      'It increases while moving left',
      'It decreases while moving left',
      'It stays constant because signs match',
      'It instantly becomes zero',
      'Velocity and acceleration point in the same direction, increasing speed.',
      'Signs and speed'
    ],
    [
      'A 3 kg cart has 10 N right and 4 N left as its only horizontal forces. What is acceleration?',
      '2 m/s² right',
      '2 m/s² left',
      '14/3 m/s² right',
      '6 m/s² right',
      'Net force is 6 N right; 6/3 = 2 m/s² right.',
      'Net force'
    ],
    [
      'With u = +2 m/s, a = +2 m/s² and t = 3 s, what is final velocity?',
      '+8 m/s',
      '+6 m/s',
      '+15 m/s',
      '−4 m/s',
      'v = u + at = 2 + 2 × 3 = 8 m/s.',
      'Velocity prediction'
    ],
    [
      'With u = +2 m/s, constant a = +2 m/s² and t = 3 s, what is displacement?',
      '+15 m',
      '+9 m',
      '+6 m',
      '+24 m',
      's = 2 × 3 + ½ × 2 × 9 = 15 m.',
      'Displacement prediction'
    ],
    [
      'A cart travels with constant nonzero velocity in an inertial frame. Which net-force statement follows?',
      'Net force is zero',
      'Net force must point forward',
      'Net force must equal its velocity',
      'Net force must equal its weight horizontally',
      'Constant velocity implies zero acceleration and therefore zero net force.',
      'Force interpretation'
    ],
    [
      'Why do a cart’s push on a hand and the hand’s push on the cart not cancel in the cart’s force equation?',
      'They act on different objects',
      'One member is not a real force',
      'Third-law forces have unequal magnitudes',
      'The cart is always accelerating',
      'The cart equation includes forces on the cart, not its force on the hand.',
      'Interaction pairs'
    ],
    [
      'A 3 kg cart speeds from 2 to 8 m/s. What net work is required?',
      '90 J',
      '96 J',
      '6 J',
      '18 J',
      'ΔK = ½ × 3 × (64 − 4) = 90 J.',
      'Work-energy calculation'
    ],
    [
      'Using g = 10 m/s², lifting 2 kg through 3 m changes object-Earth gravitational potential energy by how much?',
      '+60 J',
      '+6 J',
      '+15 J',
      '−60 J',
      'ΔUg = mgΔh = 2 × 10 × 3 = 60 J.',
      'Potential energy'
    ],
    [
      'A cart begins at +6 m/s and accelerates at −2 m/s² for 3 s. Which final velocity and displacement are correct?',
      '0 m/s and +9 m',
      '0 m/s and −9 m',
      '+12 m/s and +27 m',
      '−6 m/s and 0 m',
      'The cart stops after moving right: v = 0 and s = 18 − 9 = +9 m.',
      'Stopping motion'
    ],
    [
      'Friction reduces mechanical energy by 12 J in an otherwise isolated object-surface model. Which account can conserve total energy?',
      'Thermal energy increases by 12 J',
      'Total energy decreases by 12 J with no other change',
      'Gravitational potential energy must increase by 12 J',
      'Kinetic energy must increase by 12 J as well',
      'Mechanical energy can transfer into thermal energy within the full system.',
      'System energy'
    ],
    [
      'A 2 kg cart has horizontal forces +7 N and −3 N. Starting from rest under constant forces, what velocity follows after 4 s?',
      '+8 m/s',
      '+16 m/s',
      '+2 m/s',
      '−8 m/s',
      'Net force is +4 N, acceleration +2 m/s², and v = 0 + 2 × 4 = +8 m/s.',
      'Mastery dynamics'
    ],
    [
      'An object travels 5 m right then 5 m left in 10 s. Which pair is average speed and average velocity?',
      '1 m/s and 0 m/s',
      '0 m/s and 1 m/s',
      '1 m/s and 1 m/s',
      '0.5 m/s and −0.5 m/s',
      'Distance is 10 m but displacement is zero.',
      'Mastery displacement'
    ],
    [
      'A 2 kg object falls from rest through 3 m with negligible drag and g = 10 m/s². What happens in the object-Earth system?',
      'Potential energy falls 60 J and kinetic energy rises 60 J',
      'Both energies fall 60 J',
      'Kinetic energy rises 30 J while 30 J disappears',
      'Potential energy stays fixed because Earth is included',
      'With only the stated gravitational exchange, mechanical energy is conserved.',
      'Mastery energy'
    ],
  ],
);

final _stoichiometry = scienceTopic(
  grade: 'g11',
  order: 2,
  title: 'Stoichiometry',
  subtitle: 'Track moles, limiting reactants and recoverable product',
  minutes: '30–35 minutes',
  prerequisiteTopicId: 'science.g11.cell-biology',
  objectives: [
    'Convert between mass, amount in moles and particle count using supplied constants.',
    'Use balanced coefficients as mole ratios.',
    'Identify a limiting reactant and calculate excess remaining.',
    'Distinguish theoretical yield, actual yield and percent yield.'
  ],
  introduction:
      'A balanced equation tells you which substances react, but a laboratory also needs to know how much product is possible. Adding more of one reactant may accomplish nothing if the other runs out. Stoichiometry turns a particle-level equation into a quantitative plan and helps explain why recovered product differs from a calculated maximum.',
  sections: [
    scienceSection('Count particles through the mole',
        '''Atoms and molecules are too small to count one at a time in ordinary samples. Amount of substance, measured in moles, connects a particle count to measurable quantities. One mole contains exactly 6.02214076 × 10²³ specified entities. For this lesson, use the rounded calculation value 6.02 × 10²³ entities per mole. Always name the entity: atoms, molecules, ions or formula units are different counting choices.

For a molecular substance, N = n × NA, where N is molecule count, n is amount in moles and NA is the Avogadro constant. Thus 0.50 mol of water contains approximately 3.01 × 10²³ water molecules. Each water molecule contains two hydrogen atoms, so its hydrogen-atom count is twice its molecule count. A mole is a counting unit, not a fixed mass shared by every substance.'''),
    scienceSection('Mass becomes moles through molar mass',
        '''Molar mass M is mass per mole. Use n = m/M to convert mass m into amount n, and m = nM to convert back. Units expose mistakes: grams divided by grams per mole leaves moles. We use these rounded atomic molar masses throughout: H = 1, O = 16, C = 12, N = 14 and Ca = 40 g/mol. They are supplied calculation constants, not claims of exact measured atomic masses.

Add each atom contribution to obtain a compound molar mass. H2 has M = 2 g/mol, O2 has M = 32 g/mol and H2O has M = 18 g/mol. CO2 has M = 44 g/mol; CaCO3 has M = 100 g/mol. Therefore 9 g H2O represents 9/18 = 0.50 mol, while 9 g CO2 represents 9/44 mol. Equal masses generally contain different amounts of different substances.'''),
    scienceSection('Balance atoms before using ratios',
        '''Consider 2H2 + O2 → 2H2O. Both sides contain four hydrogen atoms and two oxygen atoms per displayed reaction group. Coefficients multiply whole formulas; changing a subscript would change the substance. The coefficients therefore describe a 2:1:2 ratio of molecules, and equally a 2:1:2 ratio of moles. They do not describe a 2:1:2 mass ratio.

With the supplied molar masses, 2 mol H2 has mass 4 g, 1 mol O2 has mass 32 g and 2 mol H2O has mass 36 g. Total mass balances: 4 + 32 = 36 g. Different masses per mole explain how unequal reactant masses can obey a simple molecular ratio. In these calculations assume the stated reaction proceeds as written, with no competing reactions.'''),
    scienceVisual('sci-g11-2-mole',
        'A balanced reaction connects particle count, amount and mass without confusing them.'),
    scienceSection('Worked example: a mass-to-mass chain',
        '''How much water can 6 g H2 produce when oxygen is available in excess? Step 1: convert the given mass to moles: 6 g ÷ 2 g/mol = 3 mol H2. Step 2: multiply by the equation ratio, 2 mol H2O per 2 mol H2, giving 3 mol H2O. Step 3: convert product amount to mass: 3 mol × 18 g/mol = 54 g H2O.

The product exceeds the original hydrogen mass because oxygen adds mass. The reaction consumes 1.5 mol O2, or 48 g. Reactant mass is 6 + 48 = 54 g, agreeing with product mass. This check catches the mistaken belief that the listed initial reactant must supply all product mass. Keep the mole ratio visible rather than memorizing a special formula for water.'''),
    scienceSection('The limiting reactant sets the ceiling',
        '''When amounts of both reactants are specified, do not assume either is in excess. Calculate the product each could make if the other were unlimited. The smaller product capacity sets the theoretical yield, and its reactant is limiting. The reactant with the smaller mass or smaller mole amount is not necessarily limiting; coefficients determine the required proportions.

For 3 mol H2 and 2 mol O2, hydrogen could produce 3 mol H2O, whereas oxygen could produce 4 mol H2O. Hydrogen therefore limits production to 3 mol H2O. Only 1.5 mol O2 is consumed, leaving 0.5 mol O2. The limiting reactant is fully consumed in this ideal complete-reaction model. In real reactions that stop before completion, the word theoretical describes the maximum predicted under the stated assumptions.'''),
    scienceVisual('sci-g11-2-limiting',
        'Compare capacities in the same product units before deciding which reactant limits.'),
    scienceSection('Worked example: smaller mass is not the rule',
        '''Mix 8 g H2 with 32 g O2 in the calculation model. Convert both: hydrogen is 8/2 = 4 mol; oxygen is 32/32 = 1 mol. Hydrogen could make 4 mol water, while oxygen could make only 2 mol. Oxygen is limiting even though it has the larger supplied mass.

The theoretical water yield is 2 × 18 = 36 g. Making it uses 2 mol H2, so 2 mol H2 remain, equivalent to 4 g. Check the complete mass account: the initial 40 g becomes 36 g water plus 4 g unreacted hydrogen. This is a paper calculation, not a home experiment; hydrogen and oxygen mixtures must not be ignited for this lesson.'''),
    scienceSection('Yield describes recovered product',
        '''Theoretical yield is the maximum product predicted from the limiting reactant for the stated reaction. Actual yield is the amount obtained and measured. Percent yield = actual yield/theoretical yield × 100%. The two quantities must use matching units and refer to the same product. If the theoretical yield is 36 g and 27 g of pure water is recovered, percent yield is 27/36 × 100 = 75%.

A lower actual yield can reflect incomplete reaction, competing reactions or product lost during transfer and separation. These explanations do not violate conservation of matter: atoms remain somewhere, although they may not be in the collected product. An apparent yield above 100% does not show extra atoms were created. It suggests wet or impure product, an incorrect measurement or a faulty calculation assumption that must be investigated.'''),
    scienceVisual('sci-g11-2-yield',
        'The common zero baseline compares actual recovery with the predicted ceiling.'),
    scienceSection('Guided example: change the equation',
        '''For the model reaction CaCO3 → CaO + CO2, use CaCO3 = 100 g/mol and CO2 = 44 g/mol. Assume complete decomposition with no side reaction. Starting from 25 g CaCO3, determine the theoretical CO2 mass, then calculate percent yield if 8.8 g CO2 is collected. First write the amount of CaCO3, then the 1:1 mole ratio, and only then the CO2 mass.

The equation differs from the water example, but the reasoning chain remains mass → moles → coefficient ratio → moles → mass. Before using a ratio, check atom balance: one calcium, one carbon and three oxygen atoms occur on each side. Subscripts inside CO2 contribute to molar mass; the coefficient before CO2 determines its reaction ratio.'''),
    scienceSection('Reveal: keep the units through the chain',
        'The starting amount is 25/100 = 0.25 mol CaCO3. The 1:1 ratio gives 0.25 mol CO2, with theoretical mass 0.25 × 44 = 11 g. Percent yield is 8.8/11 × 100 = 80%. The uncollected 20% is a recovery difference, not proof that carbon atoms disappeared.',
        reveal: true),
    scienceSection('A paper reaction-inventory investigation',
        '''Use paired paper circles to represent hydrogen molecules and differently colored pairs for oxygen molecules. Begin with six H2 cards and four O2 cards. Rearrange atoms on paper into H2O groups without adding or removing circles. You can form six water groups and have one O2 pair left. Record the beginning, consumed and remaining amounts in separate columns.

Repeat with the hydrogen supply unchanged but twice as many oxygen pairs. Water production stays limited by hydrogen. Then explain why adding only excess reactant does not improve the theoretical yield. This model represents discrete reaction counts, not the motion, collision rates or actual energy changes of molecules. Its useful feature is conserved atom inventory.'''),
    scienceSection('Common mistakes and quick check',
        'Never apply coefficients directly to grams, alter formulas to balance an equation, or identify the limiting reactant by mass alone. Do not divide theoretical yield by actual yield. Quick check: a reaction can make 12 g product from one reactant and 18 g from the other. Which capacity controls the maximum, and what would 9 g collected represent?'),
    scienceSection('Check your thinking',
        'The 12 g capacity controls because both reactants are needed. The percent yield is 9/12 × 100 = 75%. Using 18 g in the denominator would ignore the shortage of the first reactant.',
        reveal: true),
    scienceSection('Recap',
        'Specify the entity and supplied molar masses, balance the equation, convert given masses to moles and use coefficient ratios. Compare both reactant capacities when needed. Calculate theoretical product from the limiting reactant, account for excess remaining, then compare measured actual product with the theoretical amount.'),
  ],
  keyConcept:
      'Balanced coefficients connect moles; the limiting reactant sets theoretical yield, while percent yield compares actual recovery with that prediction.',
  questions: [
    [
      'Using NA = 6.02 × 10²³ per mole, what does 1 mol H2O count?',
      '6.02 × 10²³ water molecules',
      '6.02 × 10²³ grams of water',
      'Exactly one water molecule',
      'Exactly 18 water molecules',
      'The named entities in one mole of water are water molecules.',
      'Mole meaning'
    ],
    [
      'Using H = 1 and O = 16 g/mol, what is the molar mass of H2O?',
      '18 g/mol',
      '17 g/mol',
      '34 g/mol',
      '16 g/mol',
      'Two hydrogen contributions plus one oxygen contribution give 2 × 1 + 16 = 18.',
      'Molar mass'
    ],
    [
      'Which expression converts a mass m into amount n when molar mass is M?',
      'Mass divided by molar mass',
      'Mass multiplied by molar mass',
      'Molar mass divided by mass',
      'Mass plus molar mass',
      'Dividing grams by grams per mole leaves moles.',
      'Mass conversion'
    ],
    [
      'In 2H2 + O2 → 2H2O, what is the H2:O2 mole ratio?',
      '2:1',
      '1:2',
      '1:1',
      '2:3',
      'The coefficients give two moles hydrogen for one mole oxygen.',
      'Coefficient ratios'
    ],
    [
      'Why must the subscript in H2O remain unchanged when balancing this reaction?',
      'Changing it would change the substance formula',
      'Subscripts represent grams supplied',
      'Every subscript is a reaction coefficient',
      'The oxygen subscript supplies the reaction mole ratio',
      'Balance using coefficients that multiply whole formulas.',
      'Balancing equations'
    ],
    [
      'What does theoretical yield describe in the stated ideal reaction model?',
      'Maximum product predicted from the limiting reactant',
      'Every measured impurity in the collection vessel',
      'The starting mass of the excess reactant only',
      'The difference between atomic molar masses',
      'Theoretical yield is the stoichiometric ceiling under the assumptions.',
      'Yield meaning'
    ],
    [
      'Which ratio defines percent yield?',
      'Actual yield/theoretical yield × 100%',
      'Theoretical yield/actual yield × 100%',
      'Excess mass/limiting mass × 100%',
      'Molar mass/particle count × 100%',
      'Compare actual recovery to the predicted maximum using matching units.',
      'Percent yield'
    ],
    [
      'How many moles are in 9 g water when M = 18 g/mol?',
      '0.50 mol',
      '2 mol',
      '162 mol',
      '9 mol',
      'Divide mass by molar mass: n = 9/18 = 0.50 mol.',
      'Amount calculation'
    ],
    [
      'How many molecules are in 0.50 mol H2O using NA = 6.02 × 10²³?',
      '3.01 × 10²³',
      '1.204 × 10²⁴',
      '6.02 × 10²³',
      '0.50 × 10²³',
      'Multiply 0.50 by the supplied Avogadro constant.',
      'Particle calculation'
    ],
    [
      'For 2H2 + O2 → 2H2O, how much water can 6 g H2 make with excess oxygen? Use H2 = 2 and H2O = 18 g/mol.',
      '54 g',
      '6 g',
      '108 g',
      '27 g',
      '6/2 = 3 mol H2 gives 3 mol H2O, or 54 g.',
      'Mass to mass'
    ],
    [
      'Why can 6 g hydrogen produce 54 g water in the worked reaction?',
      'Reacting oxygen contributes the remaining mass',
      'Hydrogen atoms gain mass from nothing',
      'Mole ratios remove conservation of matter',
      'The balance counts only liquids',
      'The consumed oxygen contributes 48 g, so total reactant mass is 54 g.',
      'Mass accounting'
    ],
    [
      'With 3 mol H2 and 2 mol O2 in 2H2 + O2 → 2H2O, which reactant limits?',
      'H2',
      'O2',
      'H2O',
      'Neither because their amounts differ',
      'Hydrogen can make 3 mol water while oxygen could support 4 mol.',
      'Limiting reactant'
    ],
    [
      'After complete reaction of 3 mol H2 with 2 mol O2, how much O2 remains?',
      '0.50 mol',
      '1.50 mol',
      '2 mol',
      '3 mol',
      'Three moles hydrogen consume 1.5 mol oxygen, leaving 2 − 1.5 = 0.5.',
      'Excess remaining'
    ],
    [
      'If theoretical product is 36 g and actual product is 27 g, what is percent yield?',
      '75%',
      '133%',
      '9%',
      '25%',
      'Compare actual with theoretical recovery: 27/36 × 100 = 75%.',
      'Yield calculation'
    ],
    [
      'For 2H2 + O2 → 2H2O, 8 g H2 and 32 g O2 are supplied. Use molar masses 2 and 32 g/mol. Which conclusion is justified?',
      'Oxygen limits despite having the greater mass',
      'Hydrogen limits because it has the smaller mass',
      'Both supplies must be completely consumed',
      'Product mass must be 8 g',
      'The supplies are 4 mol H2 and 1 mol O2; oxygen supports only 2 mol water.',
      'Limiting comparison'
    ],
    [
      'In the 8 g H2 plus 32 g O2 model, 36 g water forms. What completes the conserved mass inventory?',
      '4 g unreacted H2',
      '4 g newly created O2',
      '40 g additional water',
      'No remaining matter',
      'Initial mass 40 g equals 36 g product plus 4 g excess hydrogen.',
      'Inventory reasoning'
    ],
    [
      'A reaction sample reports 110% yield. Which follow-up best fits stoichiometry?',
      'Check moisture, impurities, measurements and assumptions',
      'Conclude atoms were created',
      'Declare the balanced equation unnecessary',
      'Assume the reaction coefficients increased during collection',
      'An apparent excess yield indicates an issue with product purity, measurement or the model.',
      'Yield evaluation'
    ],
    [
      'For CaCO3 → CaO + CO2, what CO2 mass follows from 25 g CaCO3? Use 100 and 44 g/mol respectively.',
      '11 g',
      '25 g',
      '44 g',
      '5.68 g',
      '25/100 = 0.25 mol; 1:1 gives 0.25 × 44 = 11 g CO2.',
      'New equation transfer'
    ],
    [
      'A carbonate calculation predicts 11 g CO2, but 8.8 g is collected. What yield is this?',
      '80%',
      '125%',
      '20%',
      '2.2%',
      'Divide collected mass by theoretical mass: 8.8/11 × 100 = 80%.',
      'Recovery reasoning'
    ],
    [
      'A paper model has six H2 pairs and four O2 pairs. Doubling only O2 leaves what maximum number of water molecules?',
      '6',
      '12',
      '8',
      '16',
      'Hydrogen already limits; six H2 molecules support six H2O molecules.',
      'Changing supply'
    ],
    [
      'For 2H2 + O2 → 2H2O, 2 mol H2 and 2 mol O2 react completely as allowed. What product and excess result?',
      '2 mol H2O and 1 mol O2 remaining',
      '4 mol H2O and no excess',
      '1 mol H2O and 2 mol H2 remaining',
      '2 mol H2O and 1 mol H2 remaining',
      'Two moles hydrogen consume one mole oxygen and produce two moles water.',
      'Mastery limiting'
    ],
    [
      'For CaCO3 → CaO + CO2, 50 g CaCO3 yields 17.6 g collected CO2. Use molar masses 100 and 44 g/mol. What is percent yield?',
      '80%',
      '40%',
      '125%',
      '35.2%',
      'Theoretical CO2 is 50/100 × 44 = 22 g; 17.6/22 × 100 = 80%.',
      'Mastery yield'
    ],
    [
      'A student multiplies 10 g reactant by a 2:1 coefficient ratio to claim 20 g product without molar masses. What correction is needed?',
      'Convert to moles, apply the ratio, then convert product moles to mass',
      'Change the product subscript to two',
      'Treat every substance as having the same molar mass',
      'Ignore the balanced coefficients entirely',
      'Coefficients relate moles, so mass conversion requires the relevant molar masses.',
      'Mastery method'
    ],
  ],
);

final _cellBiology = scienceTopic(
  grade: 'g11',
  order: 1,
  title: 'Cell Biology',
  subtitle:
      'Connect selective transport, energy coupling and controlled division',
  minutes: '30–35 minutes',
  prerequisiteTopicId: null,
  objectives: [
    'Predict membrane transport from permeability, gradients and energy supply.',
    'Explain how ATP coupling supports cellular work.',
    'Connect DNA replication and chromosome separation to cell-cycle checkpoints.',
    'Interpret cell observations without claiming more than the evidence supports.'
  ],
  introduction:
      'A living cell maintains a composition different from its surroundings, even though molecules constantly move. It also builds new material and sometimes divides. How can a thin membrane, chemical reactions and a control system cooperate to keep those processes coordinated? Follow one cell from exchanging materials to preparing a reliable division.',
  sections: [
    scienceSection('A boundary with selective routes',
        '''The plasma membrane is a phospholipid bilayer with embedded proteins. The water-facing heads and water-avoiding interior create a selective barrier, not an impermeable wall. Small nonpolar molecules such as oxygen can cross the lipid region relatively easily. Charged ions have difficulty crossing that region without proteins. Molecular size, charge, lipid solubility and available transport proteins therefore influence permeability. A concentration difference alone does not guarantee rapid crossing.

Earlier cell lessons identified organelles and diffusion. Now connect structure to a prediction: an oxygen gradient may drive oxygen across a membrane, while an ion gradient can persist if suitable channels remain closed. The membrane does not consciously choose. Its physical structure and regulated proteins determine which routes are available.'''),
    scienceSection('Separate direction from mechanism',
        '''Diffusion is the net spreading that results from random molecular motion. For an uncharged solute, net passive movement is down its concentration gradient, from higher toward lower concentration. At dynamic equilibrium molecules still cross in both directions, but equal opposing rates give no net transfer.

Facilitated diffusion uses a channel or carrier protein and remains passive. Using a protein does not automatically mean using ATP. For ions, both concentration and electrical attraction matter: their combined driving force is the electrochemical gradient. Active transport uses an energy source to move material against that gradient. Primary active transport can couple pumping directly to ATP hydrolysis. Other transport systems use a previously established ion gradient; their energy dependence is indirect. Distinguish a route, a direction and an energy source instead of treating those as interchangeable labels.'''),
    scienceVisual('sci-g11-1-transport',
        'Identify the direction of net transport and whether an energy source is needed.'),
    scienceSection('Osmosis depends on the actual barrier',
        '''Osmosis is net water movement across a selectively permeable membrane. In the simple model used here, water crosses freely while the dissolved solute cannot cross. With other conditions equal, water moves toward the side with more nonpenetrating solute. An animal cell placed in a sufficiently dilute surrounding solution may swell; in a more concentrated solution it may shrink. A rigid plant cell wall can resist expansion, so identical water movement does not produce identical outcomes in all cells.

Always state the permeability assumption. If the solute can cross readily, the concentration difference may dissipate and the long-term prediction changes. Equal total solute concentrations also need care when solutes have different permeability. Our examples deliberately use a single nonpenetrating solute so that the reasoning remains explicit.'''),
    scienceSection('Energy is transferred through coupling',
        '''ATP is a short-term energy-transfer molecule, not an unlimited store and not a source that creates energy. ATP hydrolysis produces ADP and phosphate. Under cellular conditions the overall reaction can release usable free energy. Enzymes can couple this favorable reaction to an otherwise unfavorable process, such as moving ions against their gradient or joining smaller molecules into a larger one.

Breaking a chemical bond by itself requires energy. The useful net release depends on the entire reaction, including the formation and interactions of its products. Saying that energy simply appears when an ATP bond breaks misses this balance. ATP must be regenerated from ADP and phosphate with an energy input. Consequently a cell continually transfers energy through a cycle of ATP production and use, while some energy disperses as heat.'''),
    scienceVisual('sci-g11-1-energy',
        'Follow energy transfer and ATP recycling without suggesting energy is created.'),
    scienceSection('Respiration supports work across the cell',
        '''Cellular respiration transfers chemical energy from fuel molecules into usable forms including ATP. In eukaryotic cells, glycolysis begins in the cytosol and produces a small ATP gain. Later aerobic stages involve mitochondria. Electron transport helps establish a proton gradient across the inner mitochondrial membrane; proton movement through ATP synthase helps drive ATP formation. Oxygen acts as the final electron acceptor in aerobic electron transport, rather than directly turning into ATP.

An interruption of oxygen supply can reduce ATP production from this aerobic pathway. That can impair ATP-dependent pumps and other cellular work. It does not mean every ATP molecule disappears instantly: existing ATP, glycolysis and alternative metabolic responses matter. The defensible prediction is reduced support for energy-demanding processes, qualified by the cell type and the duration of the interruption.'''),
    scienceSection('Worked example: diagnose a transport result',
        '''A model cell begins with 10 concentration units of an uncharged solute inside and 2 outside. A carrier moves it outward without ATP use. Step 1: compare concentrations; outward is down the concentration gradient. Step 2: identify the route; a carrier protein is involved. Step 3: combine the evidence; this is facilitated diffusion, not active transport.

Now suppose a separate pump keeps moving the same solute inward, from 2 toward 10 units, using ATP. That transport is against the gradient and is active. If ATP supply is blocked, predict that this pump slows or stops, while passive movement through open routes can continue. Do not predict immediate equality unless the routes, available time and other conditions justify it.'''),
    scienceSection('Replication before separation',
        '''In the eukaryotic cell cycle, G1 includes growth and preparation. DNA is copied during S phase. G2 provides further preparation before M phase, which includes mitosis and usually cytokinesis. Mitosis separates replicated chromosomes into daughter nuclei; cytokinesis divides the cell contents. These events are related but are not the same process.

After DNA replication, each replicated chromosome has two sister chromatids. Before their separation, a cell can have twice its earlier DNA amount without twice the chromosome count, when chromosomes are counted by their joined centromere units. For example, a cell with 8 chromosomes in G1 has 8 replicated chromosomes and 16 chromatids after S phase. After normal division, each daughter receives 8 chromosomes. Copying DNA first allows both daughters to receive a complete set.'''),
    scienceVisual('sci-g11-1-cycle',
        'The cycle diagram separates DNA copying from chromosome segregation.'),
    scienceSection('Control points prevent some errors',
        '''Checkpoints regulate whether the cycle proceeds. A G1 checkpoint can delay replication when conditions are unsuitable or DNA is damaged. G2 checks help prevent entry into mitosis with incomplete replication or damaged DNA. During mitosis, the spindle checkpoint delays chromosome separation until attachment requirements are satisfied. These are regulated molecular interactions, not visual inspections by a cell.

If damage is repairable, a pause can allow repair. Severe damage may lead to programmed cell death. Failure of growth controls can contribute to uncontrolled proliferation, but one failed checkpoint does not establish that a cell is cancerous. Multiple changes and the tissue context matter. Cell-cycle evidence supports a mechanism or risk assessment; it should not become an unsupported diagnosis.'''),
    scienceSection('Guided example and paper investigation',
        '''Sketch two compartments with 5 nonpenetrating solute dots inside and 15 outside, using equal compartment volumes. Allow only water through the boundary. Predict initial net water movement and whether an animal cell shrinks or swells. Then add an ATP-powered pump drawing a different solute into the cell against its gradient. Explain why the two arrows can point in different directions.

Use paper dots instead of exposing living tissue to chemicals. Change just one model feature, such as allowing the first solute to cross. Annotate which earlier conclusion no longer follows. This activity tests how a prediction depends on assumptions rather than treating arrows in a diagram as universal rules.'''),
    scienceSection('Reveal: apply each mechanism separately',
        'Water initially moves outward toward the greater nonpenetrating solute concentration, so the animal cell tends to shrink. The separate pump can move its solute inward because ATP coupling supplies energy. If the original solute becomes permeable, its distribution can change; the original sustained osmotic prediction no longer follows automatically.',
        reveal: true),
    scienceSection('Common mistakes and quick check',
        'A protein route is not proof of active transport. Equilibrium does not stop molecular motion. DNA replication is not itself cell division, and more DNA does not necessarily mean more chromosomes before separation. Quick check: a cell has finished copying DNA but has a damaged chromosome. Which stage-specific control could delay entry into mitosis?'),
    scienceSection('Check your thinking',
        'The G2 checkpoint can delay entry into mitosis while damage is addressed. The spindle checkpoint instead concerns chromosome attachment before separation. Distinguishing the stages explains why both controls are useful.',
        reveal: true),
    scienceSection('Recap',
        'Explain transport by naming the substance, permeability, gradient and energy source. Explain cellular work through coupled reactions and ATP regeneration. Explain reliable division by separating DNA replication, chromosome segregation and checkpoint control. In each case, state the conditions supporting your prediction.'),
  ],
  keyConcept:
      'A cell coordinates selective exchange, energy coupling and regulated division; predictions require both a mechanism and its operating conditions.',
  questions: [
    [
      'Which feature most directly hinders a dissolved ion from crossing a bare phospholipid bilayer?',
      'The water-avoiding lipid interior',
      'The presence of open ion channels',
      'The ion concentration difference alone',
      'The similar water concentrations alone',
      'Charged ions cross the hydrophobic interior poorly without suitable proteins.',
      'Selective permeability'
    ],
    [
      'An uncharged solute uses a carrier to move down its concentration gradient without ATP. Name the mechanism.',
      'Facilitated diffusion',
      'Primary active transport',
      'Simple diffusion through the lipid interior',
      'Bulk transport in a vesicle',
      'A protein-assisted passive route is facilitated diffusion.',
      'Transport mechanisms'
    ],
    [
      'At dynamic equilibrium across an open membrane route, what continues?',
      'Equal opposing molecular transfers',
      'Net transfer only outward',
      'Net transfer only inward',
      'No crossing despite continued motion on each side',
      'Random motion continues while equal rates cancel net transfer.',
      'Dynamic equilibrium'
    ],
    [
      'In the lesson model, osmosis describes net movement of which substance?',
      'Water',
      'Only dissolved salt ions',
      'Only nonpenetrating solute',
      'Water and solute in a fixed 1:1 ratio',
      'Osmosis concerns water crossing a selectively permeable barrier.',
      'Osmosis'
    ],
    [
      'Which description of ATP best fits cellular work?',
      'A recyclable energy-transfer molecule',
      'A long-term reserve that needs no regeneration',
      'A molecule used only during DNA replication',
      'A molecule that releases energy through bond breaking alone',
      'ATP transfers energy and must be regenerated using an energy input.',
      'ATP coupling'
    ],
    [
      'During which eukaryotic cell-cycle phase is DNA replicated?',
      'S phase',
      'G1 only',
      'Cytokinesis only',
      'Chromosome separation only',
      'S phase is the DNA synthesis phase preceding division.',
      'DNA replication'
    ],
    [
      'Which event is specifically cytokinesis?',
      'Division of the cell contents',
      'Copying each DNA molecule',
      'Separating replicated chromosomes into daughter nuclei',
      'Attaching chromosomes to spindle fibers',
      'Cytokinesis partitions the cell, whereas mitosis divides the nucleus.',
      'Cell division'
    ],
    [
      'A model animal cell contains 12 units of nonpenetrating solute; equal surrounding volume contains 3. Water alone crosses. Predict the initial response.',
      'Water enters and the cell tends to swell',
      'Water exits and the cell tends to shrink',
      'Solute exits through the impermeable boundary',
      'No water moves in either direction',
      'Water moves toward higher nonpenetrating solute concentration in this model.',
      'Osmotic prediction'
    ],
    [
      'Why can an ion move differently from an uncharged solute with the same concentration gradient?',
      'Voltage also contributes to the ion electrochemical gradient',
      'Ions always move toward lower concentration regardless of voltage',
      'Every ion channel directly hydrolyzes ATP',
      'Only voltage matters and concentration has no effect',
      'Charged particles respond to electrical as well as concentration differences.',
      'Electrochemical gradient'
    ],
    [
      'A pump moves an uncharged solute from 2 to 10 concentration units using ATP. What supports its classification as active?',
      'Movement against the gradient coupled to energy use',
      'Movement through a carrier regardless of direction',
      'Movement down the concentration gradient without energy input',
      'Equal inward and outward transfer rates',
      'The uphill movement and ATP coupling identify active transport.',
      'Active transport'
    ],
    [
      'Why is saying that breaking an ATP bond alone releases energy incomplete?',
      'Net release depends on the whole reaction, including products',
      'Bond breaking alone supplies all energy regardless of products',
      'Only the number of bonds determines energy change',
      'ATP synthesis and hydrolysis both release the same net energy',
      'Bond breaking requires energy; overall reaction energetics determine the net change.',
      'Reaction energetics'
    ],
    [
      'Which role does oxygen play in aerobic mitochondrial electron transport?',
      'Final electron acceptor',
      'The molecule directly phosphorylated into ATP',
      'The substrate broken down during glycolysis',
      'The proton channel through the inner membrane',
      'Oxygen accepts electrons at the end of aerobic electron transport.',
      'Aerobic respiration'
    ],
    [
      'An 8-chromosome cell completes S phase without separating sister chromatids. Which count fits the stated convention?',
      '8 replicated chromosomes and 16 chromatids',
      '16 chromosomes and 8 chromatids',
      '4 chromosomes and 8 chromatids',
      '8 chromosomes and 4 chromatids',
      'Replication doubles chromatids and DNA, not the pre-separation centromere-based chromosome count.',
      'Chromosome accounting'
    ],
    [
      'Which checkpoint most directly delays separation when a chromosome lacks suitable spindle attachment?',
      'Spindle checkpoint',
      'G1 checkpoint before replication',
      'G2 checkpoint before mitosis',
      'The S-phase DNA copying process itself',
      'The spindle checkpoint regulates progression before chromosome separation.',
      'Cycle checkpoints'
    ],
    [
      'After ATP supply falls, an ATP-dependent pump slows but a solute still crosses an open channel down its gradient. What does this show?',
      'Passive and active transport can respond differently',
      'All membrane transport requires direct ATP use',
      'The membrane has become completely impermeable',
      'Every channel must have become an ATP-powered pump',
      'Passive movement can continue while energy-dependent pumping is impaired.',
      'Transport evidence'
    ],
    [
      'Two cells face the same dilute solution, but the plant cell has a rigid wall. Why need their outcomes differ?',
      'The wall resists expansion caused by water entry',
      'The wall makes the interior solute concentration irrelevant',
      'The wall prevents any initial water movement',
      'The wall reverses the direction of osmotic movement',
      'A wall provides mechanical resistance without reversing the osmotic driving force.',
      'Cell context'
    ],
    [
      'A solute previously assumed impermeable actually crosses readily. Which response is most scientifically justified?',
      'Reassess the long-term osmotic prediction',
      'Keep the original prediction regardless of permeability',
      'Conclude all water movement stops instantly',
      'Assume the original solute difference remains fixed forever',
      'Permeability changes solute distribution and therefore the osmotic conditions.',
      'Model assumptions'
    ],
    [
      'A damaged cell pauses before DNA replication. Which interpretation fits the lesson?',
      'G1 control may be delaying replication',
      'The spindle checkpoint is checking attachment before S phase',
      'G2 control has delayed replication before G1',
      'The cell must already have completed cytokinesis',
      'G1 control can respond to unsuitable conditions and DNA damage before S phase.',
      'Checkpoint reasoning'
    ],
    [
      'Why does an oxygen interruption not justify claiming that every ATP-dependent process stops instantly?',
      'Existing ATP and other ATP-producing pathways can contribute temporarily',
      'Oxygen is needed only for membrane diffusion',
      'Existing ATP reserves guarantee indefinite pump activity',
      'Glycolysis instantly replaces every lost aerobic ATP contribution',
      'Timing, existing reserves and glycolytic ATP production qualify the prediction.',
      'Energy limitation'
    ],
    [
      'One cell-cycle checkpoint fails in an experiment. Which conclusion stays within the evidence?',
      'A protective control is impaired, but cancer is not established by this alone',
      'The single result proves cancer in every descendant',
      'All other cycle controls must have failed as well',
      'The cell must be unable to enter S phase again',
      'Checkpoint failure can increase risk without proving a full cancer diagnosis.',
      'Limits of inference'
    ],
    [
      'A model cell has 4 concentration units of nonpenetrating solute inside and 16 outside; only water crosses. What initial outcome follows?',
      'Net outward water movement and shrinking tendency',
      'Net inward water movement and swelling tendency',
      'No net water movement because solute cannot cross',
      'Water and nonpenetrating solute exit together',
      'The external nonpenetrating solute concentration is higher, drawing net water outward.',
      'Mastery osmosis'
    ],
    [
      'A 6-chromosome parent replicates DNA and divides normally. How many chromosomes does each daughter receive?',
      '6',
      '12',
      '3',
      '24',
      'Replication supplies two copies so each normal daughter inherits the original chromosome number.',
      'Mastery division'
    ],
    [
      'A treatment reduces the mitochondrial proton gradient. Which consequence best connects the taught mechanisms?',
      'Less support for ATP synthase, potentially impairing ATP-dependent pumps',
      'More ATP synthesis because a smaller gradient offers less resistance',
      'No effect on ATP synthesis because only oxygen concentration matters',
      'All passive channels must stop when ATP production decreases',
      'The gradient drives ATP synthesis, whose output supports coupled cellular work.',
      'Mastery coupling'
    ],
  ],
);
