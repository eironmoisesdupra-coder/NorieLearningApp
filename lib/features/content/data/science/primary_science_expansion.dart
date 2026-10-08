import '../../domain/norie_content_models.dart';
import 'science_expansion_builder.dart';
import 'science_figure.dart';

const primaryExpansionFigures = <String, ScienceFigure>{
  'sci-g1-expansion': ScienceFigure(
      title: 'Two ways to move a toy wagon',
      kind: 'comparison',
      labels: ['Push', 'Pull'],
      details: [
        'Hands move the wagon away.',
        'A hand draws its handle closer.'
      ],
      note:
          'Arrows would point away for a push and toward the hand for a pull. Both are forces.'),
  'sci-g2-expansion': ScienceFigure(
      title: 'What a magnet attracts',
      kind: 'comparison',
      labels: ['Iron nail', 'Wooden block', 'Plastic lid'],
      details: [
        'Moves toward the magnet.',
        'Does not move toward the magnet.',
        'Does not move toward the magnet.'
      ],
      note:
          'Test the same magnet at the same distance. Material matters; shiny does not mean magnetic.'),
  'sci-g3-expansion': ScienceFigure(
      title: 'Morning and afternoon temperatures',
      kind: 'bars',
      labels: ['Morning', 'Afternoon'],
      details: ['Read 22 degrees Celsius.', 'Read 28 degrees Celsius.'],
      values: [22, 28],
      unit: '°C',
      note:
          'The common scale shows a 6°C rise. These are two measurements, not every moment of the day.'),
  'sci-g4-expansion': ScienceFigure(
      title: 'A complete torch circuit',
      kind: 'cycle',
      labels: ['Cell', 'Wire', 'Bulb', 'Return wire'],
      details: [
        'Supplies energy.',
        'Connects one terminal to the bulb.',
        'Changes electrical energy to light and heat.',
        'Connects the bulb to the other terminal.'
      ],
      note:
          'This is a connection diagram. A working circuit needs an unbroken path through the bulb between both cell terminals.'),
  'sci-g5-expansion': ScienceFigure(
      title: 'Recovering salt from a solution',
      kind: 'process',
      labels: [
        'Salt and water',
        'Salt solution',
        'Evaporation',
        'Salt crystals'
      ],
      details: [
        'Stir the mixture.',
        'Salt particles spread through the water.',
        'Water leaves as water vapor.',
        'Salt remains after water leaves.'
      ],
      note:
          'The salt has not vanished. Evaporation separates dissolved salt; ordinary filter paper cannot trap its dissolved particles.'),
  'sci-g6-expansion': ScienceFigure(
      title: 'Food through the digestive tract',
      kind: 'process',
      labels: ['Mouth', 'Stomach', 'Small intestine', 'Large intestine'],
      details: [
        'Chewing and saliva begin digestion.',
        'Churning and gastric juices continue digestion.',
        'Most nutrient absorption occurs here.',
        'Water absorption helps form feces.'
      ],
      note:
          'Food travels through the tract. Digestion breaks food down; absorption moves substances across the intestinal wall.'),
};

final primaryScienceExpansion = <String, NorieTopicContent>{
  'g1': expansionLesson(
    grade: 'g1',
    title: 'Pushes and Pulls',
    prerequisite: 'science.g1.materials-around-us',
    objectives: [
      'Tell a push from a pull using a real object.',
      'Describe how a force can start or stop a toy.',
      'Compare gentle and stronger pushes safely.'
    ],
    introduction:
        'A toy wagon stays still until something moves it. Your hands can push it away or pull it closer. Today we look carefully at what our hands do and what the wagon does next.',
    explanation:
        'A push moves an object away from the person pushing. A pull draws an object closer to the person pulling. Both are forces. You push a door to open it in one direction, and pull its handle to open it in the other direction. A force can start a still toy, stop a moving toy, or change the direction it moves. Watch the object before and after your hand acts. That helps you describe the change instead of guessing from the shape of the toy.',
    application:
        'Use a small toy on a clear table with an adult. Keep it away from the edge. First push it gently away. Next pull it toward you using its handle. Say the action aloud each time. Compare two pushes on the same toy from the same starting place. A stronger push may make it go farther, but a rough rug can slow it sooner than a smooth table. Keep the surface the same when comparing pushes. Never push a person, heavy furniture, or anything breakable.',
    worked:
        'Mia puts a toy car on a smooth floor. Step 1: the car is still. Step 2: her hand pushes the back of the car away from her. Step 3: the car starts moving away. We call this a push because of the direction her hand acts. When she catches it gently, her hand applies a force that stops the car.',
    guided:
        'Leo holds the handle of a wagon in front of him. He brings the handle closer to his body. Is this a push or pull? What could he do to stop a slowly moving wagon safely?',
    solution:
        'It is a pull: the handle comes closer to Leo. With adult help he can hold the handle to stop the slow wagon. A force can stop motion as well as start it.',
    mistakes:
        'Moving does not always mean pulling: a push also makes things move. A toy that stops has not become living or tired; the surface slows it. Do not compare a gentle push on a rug with a strong push on a table and decide that only strength mattered.',
    recap:
        'A push acts away; a pull acts closer. Pushes and pulls can start, stop, or turn an object. Compare the same toy on the same surface to observe what changes.',
    figure: primaryExpansionFigures['sci-g1-expansion']!,
    questions: [
      'Ana moves a toy away with her hand. What is her action?|A push|A pull|A sound|A smell|Her hand pushes the toy away from her body.|Push and pull',
      'Ben brings a wagon handle closer. What is he doing?|Pulling|Pushing|Melting|Growing|Drawing the handle closer is a pull on the wagon.|Push and pull',
      'A still car starts rolling after a gentle push. What changed?|Its motion|Its material|Its color|Its age|The force started the car moving; its material stayed the same.|Changing motion',
      'Which action can stop a slowly rolling toy safely?|Gently catching it|Painting it|Looking away|Smelling it|A hand can apply a force to stop a slow toy.|Changing motion',
      'For comparing two pushes, which thing should stay the same?|The floor surface|The direction of the Sun|The day name|The toy color only|The same surface makes the comparison of pushes more useful.|Fair comparison',
      'Which object is safe for this activity with an adult?|A small toy wagon|A heavy cupboard|A hot pan|A glass vase|A small toy on a clear surface avoids heavy or breakable objects.|Safe observation',
      'A car rolls less far on a rug than a smooth table. What may explain it?|The rug slows it more|The car became alive|The rug pulls with hands|The car changed color|A rough surface can slow a rolling toy sooner.|Changing motion',
      'Which shows a force changing direction?|A hand turns a rolling ball|A still ball is watched|A ball is named|A ball is drawn on paper|Turning the rolling ball changes its direction with a force.|Changing motion',
      'Nina closes a drawer by moving it away from her. Which force is this?|Push|Pull|Taste|Light|The drawer moves away from Nina as she pushes it closed.|Push and pull',
      'A child says forces only start motion. Which observation corrects this?|A hand stops a rolling toy|A toy stays its color|A toy is plastic|A child names the toy|Stopping a rolling toy shows a force can also stop motion.|Changing motion',
      'Two children compare pushes on different floors. How can they improve?|Use the same toy and floor|Use heavier furniture|Change everything again|Close their eyes|Keeping toy and surface the same helps compare the pushes fairly.|Fair comparison',
    ],
  ),
  'g2': expansionLesson(
    grade: 'g2',
    title: 'Exploring Magnets',
    prerequisite: 'science.g2.earth-sky',
    objectives: [
      'Test which materials a magnet attracts.',
      'Describe attraction and repulsion between poles.',
      'Use observations to correct a magnetic-material prediction.'
    ],
    introduction:
        'A magnet can move an iron nail without touching it. But it does not pull every object. We will compare materials and the ends of magnets to find a pattern.',
    explanation:
        'Magnets attract iron and some materials containing iron, including many steel objects. Wood and plastic are not attracted by an ordinary magnet. Not every metal is magnetic: an aluminum object need not move toward a magnet. Predict first, then test rather than deciding by shine or color. A magnet has two poles, called north and south. Two unlike poles attract, drawing closer. Two like poles repel, pushing apart. These forces can act across a small gap.',
    application:
        'With an adult, test a large magnet with a wooden block, a plastic lid, and a steel paper clip. Keep the starting distance similar and record attracted or not attracted for each. Then use two labeled bar magnets. Bring north near south slowly and observe attraction. Bring north near north and observe repulsion. Keep magnets away from electronic devices, and never put magnets or small objects in your mouth. A failed test from far away does not prove a material is nonmagnetic; test at a suitable small distance.',
    worked:
        'Lila predicts that all shiny objects are attracted. Step 1: she tests a steel clip and it moves toward the magnet. Step 2: she tests aluminum foil and it does not. Step 3: both look shiny, but their materials differ. Her evidence supports a better claim: this magnet attracts the steel clip, not every shiny object.',
    guided:
        'Two labeled bar magnets have south poles facing one another. Predict their motion. Then decide whether a wooden ruler should move toward one magnet.',
    solution:
        'Two south poles are like poles, so they repel. The wooden ruler is not attracted. The pole test and the material test answer different questions.',
    mistakes:
        'A magnet does not attract all metals. Attraction alone does not mean two magnets have like poles: unlike poles attract. A steel clip can be attracted even though it has no north or south label.',
    recap:
        'Use a test to identify magnetic materials. Many iron and steel objects attract; wood and plastic do not. Unlike magnetic poles attract, and like poles repel.',
    figure: primaryExpansionFigures['sci-g2-expansion']!,
    questions: [
      'Which tested material is usually attracted by a classroom magnet?|Iron|Wood|Plastic|Paper|Iron is a magnetic material attracted by an ordinary magnet.|Magnetic materials',
      'A magnet does not attract an aluminum strip. What follows?|Not all metals attract|All metals attract|Aluminum is wood|The strip has vanished|Aluminum is metal, so its result disproves the all-metals claim.|Magnetic materials',
      'North faces south on two bar magnets. What happens?|They attract|They repel|They melt|They grow|North and south are unlike poles, which attract each other.|Poles',
      'Two north poles face each other. What happens?|They repel|They attract|They become plastic|They lose all mass|Like poles repel, so two north poles push apart.|Poles',
      'Which is a useful test record?|Material and observed motion|Only object color|Only learner name|Only date without results|Recording material and motion connects evidence to a prediction.|Evidence',
      'Why keep the test gap similar for each object?|Distance affects the force|It changes wood into iron|It makes all metals attract|It removes both poles|Similar distances make material comparisons more informative.|Fair comparison',
      'Which magnet safety rule fits this investigation?|Keep magnets out of mouths|Taste each magnet|Place magnets in a phone|Swallow small clips|Magnets and small objects must never be put in the mouth.|Safe observation',
      'A plastic lid stays still near a magnet. What is supported?|This lid is not attracted|All lids are iron|Magnets pull plastic strongly|Nothing can ever move it|The observation describes attraction, not whether other forces can move it.|Evidence',
      'South faces south and the magnets separate. Which rule explains this?|Like poles repel|Like poles attract|All objects repel|Wood attracts south poles|The two south poles are alike, so repulsion is expected.|Poles',
      'A clip moves across a small gap toward a magnet. What does this show?|Force can act without contact|Every force requires touching|The clip is alive|The gap has no air|Magnetic attraction can act across a small gap without contact.|Magnetic force',
      'One shiny clip attracts but shiny foil does not. What should the claim be?|Shine alone does not predict attraction|Everything shiny attracts|No metal attracts|Only red objects attract|Different shiny materials give different results, so shine is insufficient.|Evidence',
    ],
  ),
  'g3': expansionLesson(
    grade: 'g3',
    title: 'Measuring Temperature',
    prerequisite: 'science.g3.weather-patterns',
    objectives: [
      'Read temperatures on a Celsius scale.',
      'Compare temperatures using a difference.',
      'Record measurements under consistent conditions.'
    ],
    introduction:
        'Two cups can feel different to your hand, but a thermometer gives a number we can compare. Temperature describes how hot or cold something is. We will read a scale and use evidence to describe warming.',
    explanation:
        'A thermometer measures temperature. On a Celsius scale the mark °C tells us the unit. First find the numbered marks. Next count the equal spaces between them to find what one small division represents. If 20 and 30 have five equal spaces between them, each space is 2°C. A level two spaces above 20 is therefore 24°C. Read the scale straight on at eye level. A tilted view can make the level seem higher or lower. Let the reading settle before writing it down.',
    application:
        'To compare morning and afternoon air temperature, use the same thermometer at the same shaded location. A thermometer in direct sunshine may become warmer than the shaded air you intended to measure. Record the time, number, and unit. A single warm afternoon does not describe the climate of a place. It is one observation. Use a safe classroom thermometer with adult guidance; do not handle broken glass or put a thermometer in boiling water.',
    worked:
        'The morning reading is 22°C and the afternoon reading is 28°C. Step 1: compare the numbers; 28 is larger, so afternoon is warmer. Step 2: subtract 28 − 22 = 6. Step 3: report a rise of 6°C. The afternoon temperature is 28°C; the change is 6°C. These are different answers to different questions.',
    guided:
        'A scale has marks at 10°C and 20°C with ten equal spaces. The liquid level is three spaces above 10°C. Read it, then find the change if the next reading is 18°C.',
    solution:
        'Each space is (20 − 10) ÷ 10 = 1°C. Three spaces above 10 gives 13°C. The rise to 18°C is 18 − 13 = 5°C.',
    mistakes:
        'Do not count marks as spaces: five spaces join six marks. A larger temperature is warmer, but a larger change is not itself the final temperature. Always write °C so the number has a clear unit.',
    recap:
        'Find the value of one scale division, read at eye level, and record the unit. Compare temperatures by subtraction. Keep instrument and location consistent when observing a change over time.',
    figure: primaryExpansionFigures['sci-g3-expansion']!,
    questions: [
      'What does a thermometer measure?|Temperature|Length|Mass|Sound pitch|A thermometer measures how hot or cold something is.|Measurement',
      'Which unit belongs to a Celsius reading?|°C|cm|g|min|Degrees Celsius, written °C, identify the temperature scale.|Units',
      'A scale rises from 20 to 30 in five equal spaces. Each space is what?|2°C|1°C|5°C|10°C|The ten-degree interval divided by five spaces gives 2°C per space.|Scale reading',
      'Two 2°C spaces above 20°C indicate what?|24°C|22°C|40°C|18°C|Two spaces add 4°C to 20°C, giving 24°C.|Scale reading',
      'Which is warmer: 18°C or 25°C?|25°C|18°C|Both equally warm|Neither has temperature|On the same scale, the larger temperature is warmer.|Comparison',
      'Air warms from 21°C to 27°C. What is the rise?|6°C|27°C|48°C|21°C|Subtract the initial value from the final one: 27 − 21 = 6°C.|Temperature change',
      'Where should eyes be to read a liquid scale accurately?|Level with the liquid top|Far above the scale|Looking from below|Behind the instrument|Reading at eye level avoids a tilted view of the scale.|Measurement',
      'For comparing shaded air across a day, what should stay fixed?|Thermometer and shaded location|Only shirt color|Only notebook brand|Only the observer height|The same instrument and location reduce unrelated measurement differences.|Fair comparison',
      'Ten equal spaces join 10°C and 20°C. Four above 10°C read what?|14°C|40°C|24°C|6°C|Each space is 1°C, so four spaces above 10 indicate 14°C.|Scale reading',
      'A cup cools from 30°C to 23°C. By how much?|7°C|53°C|23°C|30°C|Cooling amount is 30 − 23 = 7°C, not the final reading.|Temperature change',
      'One reading is sunny and one shaded. Why is the comparison weaker?|Sunlight can warm the instrument|Shade changes the unit|Celsius cannot compare days|All thermometers read the same|Direct sunlight can change instrument temperature independently of shaded air.|Fair comparison',
    ],
  ),
  'g4': expansionLesson(
    grade: 'g4',
    title: 'Building Simple Circuits',
    prerequisite: 'science.g4.earth-moon-sun',
    objectives: [
      'Trace a complete circuit through a cell and bulb.',
      'Predict what an open switch does.',
      'Distinguish conductors from insulators in a simple circuit.'
    ],
    introduction:
        'A torch lights when its parts make a complete electrical circuit. A cell, bulb, wires, and switch work together. We can reason about the connections before trying a safe low-voltage model.',
    explanation:
        'A working simple circuit has a continuous conducting path from one cell terminal, through the bulb, and back to the other terminal. Electrical energy from the cell is transferred to the bulb, where light and heat are produced. A closed switch joins the path. An open switch makes a gap, so the bulb goes out. The bulb must be connected at its two different contacts; attaching both wires to the same contact does not make the intended path through it. A circuit drawing shows connections, not the actual spacing of objects.',
    application:
        'Metals such as copper conduct electricity and are useful inside wires. Plastic around a wire insulates, helping keep the conducting path separate from surrounding objects. With an adult, use only a classroom cell and matching small bulb. Never use wall sockets. Do not join the two cell terminals directly with a bare wire: that short circuit can heat the wire and cell. To test a material, place it across a planned gap in the circuit and observe whether the bulb lights; verify the rest of the circuit works first.',
    worked:
        'A bulb is dark although the cell is fresh. Step 1: trace from one cell terminal through the first wire. Step 2: trace through the bulb and return wire. Step 3: notice an open switch on the return path. The gap breaks the circuit. Closing the switch completes the path and allows the bulb to light, assuming all other parts work.',
    guided:
        'A student puts a dry plastic strip across a gap where a copper strip previously made the bulb light. Predict the bulb result and explain what the comparison tests.',
    solution:
        'The bulb stays dark because dry plastic is an insulator in this circuit. The working copper comparison shows the other connections are intact, so the test concerns the material across the gap.',
    mistakes:
        'A cell touching a bulb somewhere is insufficient; both terminals and bulb contacts need the intended complete path. An open switch means a broken path, not a weak bulb. Current is not used up inside a bulb: energy is transferred there.',
    recap:
        'Trace an unbroken conducting loop through both cell terminals and the bulb. Closing a switch completes that path. Conductors join the path; insulators interrupt it. Use only safe classroom cells.',
    figure: primaryExpansionFigures['sci-g4-expansion']!,
    questions: [
      'What makes a simple cell-and-bulb circuit complete?|A continuous path through both terminals and bulb|One wire touching one terminal|A gap in every wire|Plastic replacing every wire|A continuous conducting path through the bulb is needed for this circuit.|Complete circuit',
      'What happens when a working circuit switch is opened?|The bulb goes out|The bulb always gets brighter|The cell grows|The plastic melts instantly|An open switch breaks the conducting path, stopping current.|Switches',
      'Which material is used as a conductor inside a wire?|Copper|Dry plastic|Dry rubber|Dry wood|Copper conducts electricity and can join the circuit path.|Materials',
      'Why is plastic used around a conducting wire?|It insulates the wire|It supplies the cell energy|It makes its own current|It is a magnetic pole|Insulating plastic helps keep the intended path separate from other objects.|Materials',
      'Which supply is appropriate for an adult-guided classroom circuit?|A low-voltage cell|A wall socket|A power line|A mains extension cable|A suitable classroom cell is the safe supply for this activity.|Safety',
      'What does a glowing bulb transfer electrical energy into?|Light and heat|Only sound|New copper|More battery material|The bulb produces light and heat using energy from the cell.|Energy transfer',
      'Why avoid a bare wire directly joining cell terminals?|It can form a heating short circuit|It makes plastic conduct|It removes all energy instantly|It creates new terminals|A short circuit may heat the cell and wire and must be avoided.|Safety',
      'A test material keeps a known working bulb dark. What may it be?|An insulator|A guaranteed energy source|A second switch always closed|A brighter lamp|With other parts working, an insulator across the gap can prevent current.|Materials',
      'One return wire comes loose. Which repair can restore the intended loop?|Reconnect it to the correct terminal|Remove the other wire|Open the switch too|Wrap the cell in paper only|Restoring the loose connection closes the conducting path again.|Complete circuit',
      'A diagram places the bulb far from the cell. What matters most?|Its connections form a complete loop|Its picture is nearby|Its drawing color is yellow|Its title uses capitals|Circuit diagrams communicate connections rather than physical spacing.|Circuit models',
      'Copper lights the bulb, dry plastic does not, with other parts fixed. What is supported?|Copper conducts better in this test|Plastic supplies more energy|Every material conducts equally|The bulb consumed the current|The controlled comparison supports copper as conductor and plastic as insulator.|Evidence',
    ],
  ),
  'g5': expansionLesson(
    grade: 'g5',
    title: 'Dissolving and Separating',
    prerequisite: 'science.g5.water-cycle',
    objectives: [
      'Distinguish dissolving from disappearing.',
      'Choose filtration or evaporation for a mixture.',
      'Explain why stirring changes dissolving speed.'
    ],
    introduction:
        'Salt seems to disappear in water, but the water now contains dissolved salt. A mixture can look clear and still contain more than one substance. We will choose separation methods using particle size and changes of state.',
    explanation:
        'When salt dissolves, its particles spread among water particles to make a solution. Water is the solvent and salt is the solute. The salt remains present even though individual dissolved particles are too small to see. Stirring brings fresh water into contact with the solid and usually speeds dissolving. It does not guarantee unlimited salt will dissolve: for a given amount of water and temperature there is a limit. After that limit, extra solid remains at the bottom. Do not taste experimental mixtures to test their contents.',
    application:
        'Filter paper traps insoluble sand particles while liquid passes through. It cannot usually trap dissolved salt particles, which pass with the water. To recover salt from salt water, let water evaporate under adult supervision; the salt remains. To collect the water as well, a more advanced method cools the water vapor into liquid in a separate container. Choose a method from what the substances do, not only from whether the mixture looks clear. Evaporation changes water to vapor; dissolving salt is not the same change.',
    worked:
        'A mixture contains sand, salt, and water. Step 1: filter it. Sand remains on the filter, while salt solution passes through. Step 2: evaporate water from the collected solution. Salt crystals remain. Step 3: name the reason for each step: large insoluble particles are trapped first; then water leaves the dissolved salt behind. Using only filtration would not recover both solids separately.',
    guided:
        'A learner filters clear sugar water and expects sugar on the paper. Predict the result. Which method could leave the sugar behind without collecting the water?',
    solution:
        'Dissolved sugar passes through with the water, so ordinary filtration does not separate it. Gentle evaporation of water can leave sugar behind; an adult handles any heating.',
    mistakes:
        'Clear does not mean pure. Dissolved salt has not vanished or turned into water. Stirring changes rate, not necessarily the final dissolving limit. Evaporating the solvent is different from filtering insoluble solid particles.',
    recap:
        'A solution contains solute dispersed in solvent. Filter insoluble solids such as sand; evaporate water to recover a dissolved solid such as salt. Explain each method using particle behavior.',
    figure: primaryExpansionFigures['sci-g5-expansion']!,
    questions: [
      'In salt water, which substance is the solvent?|Water|Salt|The glass|The spoon|Water is the solvent in which the salt solute dissolves.|Solutions',
      'What happens to salt particles as salt dissolves?|They spread among water particles|They cease to exist|They all become sand|They become the glass|Dissolving disperses salt particles without making the salt vanish.|Particle model',
      'Which method separates insoluble sand from water?|Filtration|Only naming it|Dissolving more salt|Freezing the spoon|Filter paper traps insoluble sand particles while liquid passes.|Separation',
      'Which method can recover salt from salt water?|Evaporating the water|Ordinary filtration alone|Painting the cup|Adding sand only|Water evaporates while dissolved salt remains behind as solid.|Separation',
      'Why does stirring often speed dissolving?|Fresh water reaches the solid surface|It destroys matter|It makes infinite solvent|It removes all particles|Stirring increases contact between the solvent and solid surface.|Dissolving rate',
      'Extra salt stays at the bottom after enough stirring. What may be true?|The dissolving limit was reached|Salt no longer has mass|Water is now a magnet|Stirring always dissolves everything|A fixed amount of water at a given temperature has a dissolving limit.|Saturation',
      'A clear solution is necessarily what?|Able to contain dissolved substances|Always pure water|Free of all particles|Only a gas|Clear appearance does not rule out dissolved substances.|Solutions',
      'What is the safe rule for investigating solutions?|Do not taste experimental mixtures|Taste every clear liquid|Heat without adult help|Drink the filtered mixture|A mixture that looks clear is not necessarily safe to taste.|Safety',
      'Which sequence separates sand and salt from their watery mixture?|Filter then evaporate the filtrate|Evaporate then call all solid sand|Filter and discard the liquid|Add more water forever|Filtering removes sand; evaporation then recovers salt from the filtrate.|Separation',
      'Why does ordinary filter paper fail to recover dissolved sugar?|Dissolved particles pass with water|Sugar has no mass|The paper turns to sugar|The solvent became solid|Dissolved particles are too small for ordinary filtration to retain.|Particle model',
      'A learner says dissolving means the salt is gone. Which evidence corrects this?|Salt remains after water evaporates|The cup changes color|The spoon is long|The label says water|Recovering solid salt after evaporation shows it remained in solution.|Evidence',
    ],
  ),
  'g6': expansionLesson(
    grade: 'g6',
    title: 'Digestion and Absorption',
    prerequisite: 'science.g6.solar-system',
    objectives: [
      'Trace the path of food through the digestive tract.',
      'Distinguish digestion from absorption.',
      'Explain how the small intestine supports absorption.'
    ],
    introduction:
        'Food contains nutrients, but most cannot enter our blood directly as large food pieces. Digestion makes smaller substances and absorption moves useful substances into the body. These are connected but different processes.',
    explanation:
        'In the mouth, teeth break food into smaller pieces and saliva begins chemical digestion of starch. The esophagus carries swallowed food to the stomach. Stomach muscles churn food and gastric juices help digest proteins. Most chemical digestion is completed in the small intestine, where most nutrient absorption occurs. Enzymes help break large food molecules into smaller substances. Mechanical digestion changes pieces and surface area; chemical digestion changes molecules. Chewing does not alone turn every nutrient into an absorbable form.',
    application:
        'The wall of the small intestine has folds and many fingerlike villi. These provide a large surface for absorption. Digested nutrients cross the wall into blood or lymph for transport. The large intestine absorbs water and helps form feces from remaining material. Food does not pass through the liver or pancreas: these organs supply substances that help digestion through ducts. Bile from the liver helps disperse fat into small droplets, increasing the surface available for digestive enzymes; bile is not itself an enzyme.',
    worked:
        'Trace a bite of bread. Step 1: chewing increases surface area and saliva starts starch digestion. Step 2: the bite moves through the esophagus to the stomach. Step 3: digestion continues in the small intestine, producing small molecules such as simple sugars. Step 4: these nutrients are absorbed across the intestinal wall and transported. Naming the stomach alone misses the main absorption site.',
    guided:
        'A learner says villi chew food. Explain the actual role of villi and identify which earlier structure performs chewing. Then explain what the large intestine mainly absorbs.',
    solution:
        'Villi increase the small intestine surface for absorption; teeth chew food in the mouth. The large intestine absorbs water from remaining material, helping form feces.',
    mistakes:
        'Digestion is not the same as absorption: breaking molecules down differs from moving them across a wall. The stomach is not the main nutrient absorption site. Food moves through the tract, not through every organ that assists digestion.',
    recap:
        'Trace mouth → esophagus → stomach → small intestine → large intestine. Digestion breaks food down; absorption moves substances into the body. Villi provide a large absorbing surface.',
    figure: primaryExpansionFigures['sci-g6-expansion']!,
    questions: [
      'What is chewing an example of?|Mechanical digestion|Nutrient absorption|Blood circulation|Gas exchange|Chewing breaks food into pieces without itself changing every molecule.|Digestion',
      'Which tube carries swallowed food to the stomach?|Esophagus|Trachea|Artery|Ureter|The esophagus joins the mouth region to the stomach along the food path.|Food path',
      'Where does most nutrient absorption occur?|Small intestine|Esophagus|Mouth|Large intestine only|The small intestine has a large surface specialized for nutrient absorption.|Absorption',
      'What do villi mainly increase?|Absorbing surface area|Tooth number|Stomach acid volume|Food color|Villi increase the surface available for absorbing digested nutrients.|Absorption',
      'What is chemical digestion?|Breaking large food molecules into smaller ones|Only moving food down a tube|Only cutting food with teeth|Transporting blood through lungs|Chemical digestion changes molecules into smaller substances.|Digestion',
      'Which material does the large intestine mainly absorb?|Water|Whole bread slices|All oxygen from air|Solid teeth|Water absorption helps form feces from remaining intestinal material.|Large intestine',
      'Does food normally pass through the liver?|No; it supplies digestive substances through ducts|Yes; before reaching the mouth|Yes; instead of the small intestine|Only when it is bread|The liver assists digestion but is not a section of the food passage.|Accessory organs',
      'Why can breaking fat into droplets help digestion?|It exposes more surface to enzymes|It makes bile an enzyme|It removes all fat molecules|It bypasses the intestine|Smaller droplets offer more surface for enzymes to act on fat.|Digestion',
      'A small sugar crosses the intestinal wall into blood. What is this?|Absorption|Chewing|Swallowing|Mechanical digestion|Movement across the intestinal wall into transport fluids is absorption.|Absorption',
      'Which is the correct food path after the stomach?|Small intestine then large intestine|Liver then lungs|Kidney then mouth|Large intestine then esophagus|Food proceeds from stomach to small intestine and then large intestine.|Food path',
      'A learner claims the stomach absorbs most nutrients. Which correction is best?|Most absorption occurs across the small intestine wall|All absorption occurs in teeth|Digestion never produces small molecules|The liver stores whole food pieces|The small intestine wall and villi support most nutrient absorption.|Absorption',
    ],
  ),
};
