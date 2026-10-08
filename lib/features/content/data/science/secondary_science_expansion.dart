import '../../domain/norie_content_models.dart';
import 'science_expansion_builder.dart';
import 'science_figure.dart';

const secondaryExpansionFigures = <String, ScienceFigure>{
  'sci-g7-expansion': ScienceFigure(
      title: 'Equal volumes, different masses',
      kind: 'bars',
      labels: ['Material A: 10 cm³', 'Material B: 10 cm³'],
      details: ['Mass 20 g; density 2 g/cm³.', 'Mass 80 g; density 8 g/cm³.'],
      values: [20, 80],
      unit: 'g',
      note:
          'The bar height is mass, not density. Equal volumes allow their mass comparison to reveal which is denser.'),
  'sci-g8-expansion': ScienceFigure(
      title: 'Same force on two contact areas',
      kind: 'comparison',
      labels: ['100 N over 0.01 m²', '100 N over 0.02 m²'],
      details: ['Pressure = 10,000 Pa.', 'Pressure = 5,000 Pa.'],
      note:
          'Pressure is force divided by contact area. Doubling area halves pressure when force stays fixed.'),
  'sci-g9-expansion': ScienceFigure(
      title: 'Tracing matter in photosynthesis',
      kind: 'process',
      labels: [
        'Carbon dioxide + water',
        'Light absorbed by chlorophyll',
        'Sugar + oxygen'
      ],
      details: [
        'Reactants supply atoms.',
        'Light provides energy for the process.',
        'Atoms are rearranged into products.'
      ],
      note:
          '6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂. Light supplies energy, not carbon atoms; the equation summarizes many reactions.'),
  'sci-g10-expansion': ScienceFigure(
      title: 'Converging lens: two object positions',
      kind: 'comparison',
      labels: [
        'Object beyond twice focal length',
        'Object inside focal length'
      ],
      details: [
        'A smaller inverted real image forms between f and 2f on the far side.',
        'An upright enlarged virtual image appears on the object side.'
      ],
      note:
          'A real image can be formed on a screen. A virtual image requires extending outgoing rays backward; rays do not actually meet there.'),
};

final secondaryScienceExpansion = <String, NorieTopicContent>{
  'g7': expansionLesson(
    grade: 'g7',
    title: 'Density and Floating',
    prerequisite: 'science.g7.earth-systems',
    objectives: [
      'Calculate density from mass and volume.',
      'Use displacement to find an irregular solid volume.',
      'Predict floating by comparing average densities.'
    ],
    introduction:
        'A large wooden block can float while a small metal bolt sinks. Mass alone cannot explain this. Density compares how much mass occupies a given volume.',
    explanation:
        'Density = mass ÷ volume. For mass in grams and volume in cubic centimeters, the density unit is g/cm³. A 60 g sample occupying 20 cm³ has density 3 g/cm³. This is a property of that material under the stated conditions, not its total mass. Cutting a uniform block in half halves both mass and volume, leaving density unchanged. A balance measures mass; a ruler or graduated cylinder can help measure volume. Use units consistently and distinguish mass from weight, which is a force.',
    application:
        'For an irregular solid that does not dissolve, place enough water in a graduated cylinder and record the initial level. Submerge the solid fully, avoiding trapped air, and record the final level. The difference is displaced volume; 1 mL equals 1 cm³. Floating depends on average object density compared with the fluid, assuming the object is free to move. A hollow metal boat includes air in its overall volume, so its average density can be less than water even though the metal itself is denser.',
    worked:
        'A stone has mass 54 g. Water rises from 30 mL to 48 mL when it is submerged. Step 1: volume = 48 − 30 = 18 cm³. Step 2: density = 54 ÷ 18 = 3 g/cm³. Step 3: compare with water at about 1 g/cm³. This stone is denser and tends to sink. Using 48 mL as the stone volume would include water already in the cylinder.',
    guided:
        'A uniform block has mass 24 g and volume 30 cm³. Calculate its density and predict whether it floats in water. If it is cut into two equal parts, predict each part density.',
    solution:
        'Density = 24 ÷ 30 = 0.8 g/cm³, less than water, so it tends to float. Each half has mass 12 g and volume 15 cm³, still 0.8 g/cm³.',
    mistakes:
        'Heavier does not automatically mean denser. Divide mass by volume, not volume by mass. In displacement, subtract initial volume. Compare the average density of a hollow object, not only its shell material.',
    recap:
        'Density relates mass to volume. Displacement uses the change in water level. Under ordinary free-floating conditions, objects less dense on average than their fluid float; denser objects tend to sink.',
    figure: secondaryExpansionFigures['sci-g7-expansion']!,
    questions: [
      'Which expression gives density?|Mass divided by volume|Volume divided by mass|Mass plus volume|Weight times time|Density measures mass per unit volume, so divide mass by volume.|Density',
      'A 40 g solid occupies 10 cm³. Its density is what?|4 g/cm³|0.25 g/cm³|400 g/cm³|30 g/cm³|The ratio 40 g ÷ 10 cm³ gives 4 g/cm³.|Calculation',
      'Water rises from 25 mL to 37 mL around a stone. Stone volume is what?|12 cm³|37 cm³|25 cm³|62 cm³|Subtract initial water level from final level: 37 − 25 = 12 cm³.|Displacement',
      'A block density is 0.6 g/cm³ in water near 1 g/cm³. It tends to do what?|Float|Sink because every solid sinks|Dissolve necessarily|Become denser instantly|Its average density is lower than the surrounding water.|Floating',
      'Cutting a uniform material into equal halves changes its density how?|It stays the same|It doubles|It halves|It becomes zero|Mass and volume halve together, so their ratio remains unchanged.|Density',
      'Which unit is appropriate when mass is g and volume is cm³?|g/cm³|cm³/g|g·s|m/s|Density is mass per volume, giving grams per cubic centimeter.|Units',
      'Why can a hollow steel boat float?|Air lowers its overall average density|Steel always has less density than water|All heavy objects float|Water has no density|The overall boat volume includes air, reducing average density.|Floating',
      'What can trapped air on a submerged stone do?|Make measured displacement too large|Remove the initial water|Change grams to seconds|Make all stones identical|Air bubbles add displaced volume and can bias the calculated density.|Measurement',
      'A 72 g sample displaces 24 mL. Its density is what?|3 g/cm³|0.33 g/cm³|96 g/cm³|48 g/cm³|Volume is 24 cm³ and 72 ÷ 24 gives 3 g/cm³.|Calculation',
      'A 100 g block and 20 g block have equal density. What must differ?|Their volumes in the same ratio|Their material must differ|Their density unit changes|The lighter one has zero volume|At equal density, a fivefold mass requires a fivefold volume.|Density',
      'Why is the final cylinder level alone not stone volume?|It includes the water present initially|It is always measured in grams|It never depends on volume|It equals density automatically|Displacement volume is the final reading minus the initial water volume.|Displacement',
    ],
  ),
  'g8': expansionLesson(
    grade: 'g8',
    title: 'Pressure in Solids and Fluids',
    prerequisite: 'science.g8.weather-climate',
    objectives: [
      'Calculate pressure using force and area.',
      'Explain how contact area changes pressure.',
      'Describe increasing liquid pressure with depth.'
    ],
    introduction:
        'A wide snowshoe reduces sinking, while a narrow edge concentrates a force. Pressure describes force spread over area. Fluids also exert pressure on surfaces.',
    explanation:
        'Pressure = perpendicular force ÷ area. In SI units, force in newtons divided by area in square meters gives pascals, Pa. The same force produces more pressure over a smaller area. A 100 N force on 0.01 m² produces 10,000 Pa; on 0.02 m² it produces 5,000 Pa. Convert the area before dividing. Since 1 m² contains 10,000 cm², 100 cm² is 0.01 m², not 1 m². Pressure is a ratio, while force is the total push on a surface.',
    application:
        'A fluid at rest exerts pressure in all directions at a point. Liquid pressure increases with depth because deeper liquid supports more liquid above it. In the same liquid at the same depth, pressure does not depend on whether the container is wide or narrow. Atmospheric pressure is also present above an open liquid. The formula p = ρgh describes the additional liquid pressure below the surface, with density ρ, gravitational field strength g, and depth h. Total absolute pressure includes the surface pressure.',
    worked:
        'A crate exerts 240 N on the floor over 0.08 m². Step 1: use perpendicular force 240 N. Step 2: divide by area: 240 ÷ 0.08 = 3,000 Pa. Step 3: turning it onto a 0.04 m² face keeps force unchanged but halves area. Pressure becomes 240 ÷ 0.04 = 6,000 Pa. The weight has not doubled; the pressure has.',
    guided:
        'A swimmer moves from depth 1 m to 3 m in the same still water. Predict the change in additional liquid pressure. Does widening the pool at depth 3 m change the pressure there?',
    solution:
        'In p = ρgh, only h changes, so tripling depth triples the additional liquid pressure. Widening the pool does not change pressure at the same depth in the same liquid.',
    mistakes:
        'Do not call force and pressure the same quantity. Doubling area halves pressure for a fixed force. Additional liquid pressure excludes atmospheric pressure; tripling depth does not triple total absolute pressure.',
    recap:
        'Pressure is force per area. Smaller contact area increases pressure at fixed force. Additional static liquid pressure is ρgh and increases with depth; total pressure also includes the pressure at the surface.',
    figure: secondaryExpansionFigures['sci-g8-expansion']!,
    questions: [
      'Which is the SI unit of pressure?|Pascal|Newton only|Joule|Kilogram|A pascal is one newton per square meter, a force-per-area unit.|Units',
      'A 60 N force acts over 0.02 m². Pressure is what?|3000 Pa|1.2 Pa|60 Pa|30 Pa|Pressure = 60 ÷ 0.02 = 3000 newtons per square meter.|Calculation',
      'At fixed force, doubling contact area does what to pressure?|Halves it|Doubles it|Leaves it unchanged|Makes it zero|Area is the divisor, so doubling area halves the pressure.|Contact area',
      'Why do snowshoes reduce sinking compared with narrow shoes?|Weight spreads over greater area|They remove gravity|They double the wearer mass|Snow cannot exert force|A wider area reduces pressure for the same weight.|Contact area',
      'At greater depth in the same still liquid, pressure is generally what?|Greater|Smaller|Always zero|Independent of depth|Additional liquid pressure increases with depth according to ρgh.|Fluid pressure',
      'Which is the conversion of 100 cm² to m²?|0.01 m²|1 m²|100 m²|0.1 m²|One square meter contains 10,000 square centimeters.|Units',
      'At the same depth in the same liquid, which container gives greater static pressure?|Neither solely because of width|The wider one always|The narrower one always|The heavier container always|Static pressure depends on depth and liquid density, not container width.|Fluid pressure',
      'The formula ρgh below an open water surface gives what?|Additional liquid pressure|Atmospheric pressure alone|Total force without area|Always total absolute pressure|The expression gives pressure due to liquid depth above the point.|Fluid pressure',
      'A box force is 200 N over 0.05 m². Pressure is what?|4000 Pa|10 Pa|1000 Pa|0.00025 Pa|Dividing 200 by 0.05 yields 4000 Pa.|Calculation',
      'Depth doubles with density and g fixed. Additional liquid pressure does what?|Doubles|Halves|Stays constant|Becomes negative|In ρgh, additional pressure is directly proportional to depth.|Fluid pressure',
      'A student says pressure doubled so box weight doubled. What else could explain it?|Contact area halved at fixed weight|Area doubled at fixed weight|Area stayed fixed with lower weight|All forces disappeared|Pressure can double because area halves while force stays the same.|Contact area',
    ],
  ),
  'g9': expansionLesson(
    grade: 'g9',
    title: 'Photosynthesis and Plant Matter',
    prerequisite: 'science.g9.plate-tectonics',
    objectives: [
      'Trace matter and energy through photosynthesis.',
      'Explain why most new plant dry mass comes from carbon dioxide.',
      'Evaluate a controlled test of light and starch formation.'
    ],
    introduction:
        'A small seed can become a much larger plant. Water and minerals matter, but soil alone does not explain the new dry mass. Photosynthesis incorporates carbon from the air into sugars.',
    explanation:
        'Photosynthesis uses light energy to form sugars from carbon dioxide and water, releasing oxygen. In plants, chloroplasts contain chlorophyll that absorbs light. A summary equation is 6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂. Count atoms on both sides: six carbon atoms, twelve hydrogen atoms, and eighteen oxygen atoms are conserved. The equation summarizes a sequence of reactions, not one instant collision. Light provides energy; it does not provide carbon atoms. Plants use sugars for respiration and to build substances such as cellulose.',
    application:
        'Carbon dioxide enters leaves through stomata; water reaches leaves through transport tissues from roots. Mineral nutrients are essential but are not the main source of carbon in plant dry matter. Plants also respire in light and darkness, transferring energy from food for cell processes. For a classroom light-and-starch test, an adult can destarch a plant, cover part of a leaf, provide light, and compare covered and exposed regions using a safe supervised starch test. The covered region is a comparison within the same leaf; temperature, water, and time should be similar.',
    worked:
        'A learner claims sunlight becomes the mass of a new stem. Step 1: identify the atoms in sugars and cellulose. Step 2: carbon atoms come mainly from carbon dioxide, and water supplies other reactant atoms. Step 3: light supplies energy for the reactions, not atoms. Step 4: connect sugars to growing tissues. This separates the source of matter from the source of energy.',
    guided:
        'In a light test, the exposed region of a destarched leaf tests positive for starch while the opaque-covered region does not. State a supported conclusion and one control needed. Does this prove the plant stopped respiration?',
    solution:
        'Under these conditions, light exposure supported starch formation. Use the same leaf and time, with comparable water and temperature. The result does not show respiration stopped; living plant cells continue respiration.',
    mistakes:
        'Plants do not obtain their carbon mainly by eating soil. Oxygen is a product of photosynthesis, but plants also use oxygen for respiration. A positive starch test is evidence consistent with sugar production and storage, not a direct measurement of every photosynthetic step.',
    recap:
        'Photosynthesis transfers light energy into chemical stores while rearranging carbon dioxide and water into sugars and oxygen. Trace atoms separately from energy. Plant growth and respiration both use products of photosynthesis.',
    figure: secondaryExpansionFigures['sci-g9-expansion']!,
    questions: [
      'What is the main source of carbon in plant sugars?|Carbon dioxide|Sunlight atoms|Soil grains alone|Oxygen gas alone|Photosynthesis incorporates carbon atoms from carbon dioxide into sugars.|Matter source',
      'Which pair are reactants in the photosynthesis summary equation?|Carbon dioxide and water|Sugar and oxygen|Nitrogen and salt|Cellulose and iron|Carbon dioxide and water supply matter for photosynthetic sugar formation.|Photosynthesis',
      'What role does light play in photosynthesis?|It supplies energy|It supplies carbon atoms|It replaces all water|It is an enzyme|Light energy drives the formation of sugars; it is not a carbon source.|Energy',
      'Where is chlorophyll located in a typical leaf cell?|Chloroplasts|Only cell walls|Only the nucleus|Only mitochondria|Chloroplasts contain chlorophyll that absorbs light for photosynthesis.|Cell structures',
      'Which gas is released in the photosynthesis summary?|Oxygen|Helium|Methane only|Nitrogen only|Oxygen is a product in the overall photosynthesis equation.|Products',
      'How many carbon atoms are in C₆H₁₂O₆?|6|12|18|1|The subscript six after C gives six carbon atoms in the molecule.|Conservation',
      'When do living plant cells carry out respiration?|In light and darkness|Only when leaves are covered|Only at noon|Never|Plants respire to support cell processes both in light and darkness.|Respiration',
      'Why cover part of a destarched leaf in a light test?|To compare exposed and unexposed regions|To add new carbon atoms|To stop every cell process|To measure root mass directly|The opaque cover changes light exposure for a comparison region.|Investigation',
      'A growing plant gains dry mass with little soil mass lost. What best explains carbon gain?|Carbon dioxide was incorporated|Light was converted to carbon atoms|Minerals are its only matter source|The atoms were created from nothing|Atmospheric carbon dioxide provides much of the carbon in new plant matter.|Matter source',
      'Covered leaf region lacks starch while exposed region has it. What conclusion is supported?|Light supported starch formation under these conditions|All covered cells died immediately|Respiration never occurred|Water was unnecessary|The controlled contrast supports a role for light in starch formation.|Investigation',
      'Why must the photosynthesis summary conserve atoms?|Reactions rearrange existing atoms|Light creates all atoms|Atoms disappear in green leaves|Products have no mass|Chemical reactions conserve atoms by rearranging them into products.|Conservation',
    ],
  ),
  'g10': expansionLesson(
    grade: 'g10',
    title: 'Lenses and Image Formation',
    prerequisite: 'science.g10.ecosystems',
    objectives: [
      'Trace principal rays through a converging lens.',
      'Distinguish real images from virtual images.',
      'Calculate an image position using the thin-lens relation.'
    ],
    introduction:
        'A magnifying glass and a camera can use converging lenses, yet produce different kinds of images. Object distance relative to focal length explains why.',
    explanation:
        'A converging lens refracts rays parallel to its principal axis toward a focal point on the far side. A ray through the center of an ideal thin lens continues approximately straight. Trace these two rays from the top of an object to locate an image. If outgoing rays actually meet, the image is real and can be formed on a screen. If they spread apart, extending them backward may locate a virtual image. The light does not really pass through that backward intersection. Ray diagrams are geometric models; the ray lines are not solid threads of light.',
    application:
        'For a converging thin lens use 1/f = 1/dₒ + 1/dᵢ, with positive f, positive real object distance dₒ, and positive dᵢ for a real image on the opposite side. A virtual image on the object side has negative dᵢ in this convention. With an object beyond 2f, the image is smaller, inverted, and between f and 2f. At 2f it is equal in size. Between f and 2f it is enlarged and real. Inside f it is enlarged, upright, and virtual. Never focus sunlight through a lens toward eyes or flammable materials.',
    worked:
        'A converging lens has f = 10 cm and the object is 30 cm away. Step 1: 1/dᵢ = 1/10 − 1/30 = 2/30 = 1/15. Step 2: dᵢ = 15 cm on the opposite side. Step 3: magnification m = −dᵢ/dₒ = −15/30 = −0.5. The negative sign means inverted; magnitude 0.5 means half the object height.',
    guided:
        'Use f = 10 cm and dₒ = 5 cm. Compute 1/dᵢ, then dᵢ. Is the image real or virtual, and can a screen capture it at that location?',
    solution:
        '1/dᵢ = 1/10 − 1/5 = −1/10, so dᵢ = −10 cm. It is a virtual image on the object side. A screen there cannot capture the image because outgoing rays do not actually meet there.',
    mistakes:
        'A virtual image is visible but cannot be projected onto a screen at its apparent location. Do not add distances directly in the thin-lens equation; use reciprocals. State a sign convention before interpreting negative distances.',
    recap:
        'Use principal rays or the thin-lens relation to locate an image. Real rays meet for a real image; backward extensions locate a virtual image. Object position relative to f determines image type, orientation, and size.',
    figure: secondaryExpansionFigures['sci-g10-expansion']!,
    questions: [
      'Rays parallel to the principal axis through an ideal converging lens meet where?|At the far focal point|At every point equally|Always at the object|Only at the lens edge|A converging lens refracts rays parallel to its principal axis toward the far focal point.|Ray tracing',
      'Which image can be projected onto a screen at its image position?|A real image|Every virtual image|Only an upright virtual image|No lens image|Real outgoing rays actually meet, allowing a screen to receive the image.|Image type',
      'An object inside the focal length gives what for a converging lens?|Upright enlarged virtual image|Smaller real image|Always no visible image|Inverted image exactly at 2f|Inside f, outgoing rays diverge and their backward extensions form a virtual image.|Object position',
      'For a thin lens, take f positive for a converging lens, dₒ positive for a real object, and dᵢ positive for a real image on the opposite side. Which relation is the thin-lens equation?|1/f = 1/dₒ + 1/dᵢ|f = dₒ + dᵢ|f = dₒ × dᵢ|dᵢ = f always|The thin-lens relation adds reciprocal object and image distances.|Calculation',
      'For f = 10 cm and dₒ = 20 cm, dᵢ is what?|20 cm|10 cm|30 cm|5 cm|1/dᵢ = 1/10 − 1/20 = 1/20, so the image is at 20 cm.|Calculation',
      'A negative magnification for a real object indicates what?|Inverted image|No image|Image has negative physical height|Lens absorbs all light|The sign indicates image orientation relative to the object.|Magnification',
      'For a real object and converging thin lens, use 1/f = 1/dₒ + 1/dᵢ with positive f and dₒ, and positive dᵢ on the side opposite the object. What does negative dᵢ indicate?|Virtual image on the object side|Real image behind the screen|Negative light speed|A broken lens|Negative image distance locates a virtual image on the same side as the object.|Sign convention',
      'Why must a lens never focus sunlight toward eyes?|Concentrated light can cause injury|It makes virtual light harmless|It cancels all energy|It reduces sunlight to zero|A lens can concentrate sunlight dangerously; avoid eyes and flammable materials.|Safety',
      'For f = 12 cm and dₒ = 36 cm, find dᵢ.|18 cm|48 cm|24 cm|6 cm|1/dᵢ = 1/12 − 1/36 = 2/36 = 1/18.|Calculation',
      'An object beyond 2f forms what image through a converging lens?|Smaller inverted real image|Larger upright virtual image|Equal image on the object side|No image under any conditions|For dₒ greater than 2f, the real image lies between f and 2f and is smaller.|Object position',
      'Why can a virtual image be seen but not projected at its apparent position?|Backward ray extensions meet there, not actual rays|The eye creates all light|The object has disappeared|Virtual means completely invisible|The apparent image point comes from extensions of diverging outgoing rays.|Image type',
    ],
  ),
};
