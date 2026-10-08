import '../../domain/norie_content_models.dart';
import 'authored_lesson_visual.dart';
import 'subject_lesson_builder.dart';

const primaryEnglishVisuals = <String, AuthoredLessonVisual>{
  'english-g1-authored': AuthoredLessonVisual(
      title: 'Change one short vowel',
      labels: ['c + a + t → cat', 'c + u + t → cut', 'h + o + p → hop'],
      details: [
        'Blend three sounds; a has the short sound in cat.',
        'Changing the middle vowel changes the word.',
        'The middle o has the short sound in hop.'
      ],
      note:
          'These are simple consonant-vowel-consonant words; each example uses its common short-vowel reading.'),
  'english-g2-authored': AuthoredLessonVisual(
      title: 'Present and past action pairs',
      labels: [
        'Today I go. → Yesterday I went.',
        'Today I see. → Yesterday I saw.',
        'Today I play. → Yesterday I played.'
      ],
      details: [
        'Go has an irregular past form.',
        'See also changes without adding -ed.',
        'Play follows the regular -ed pattern.'
      ],
      note:
          'Time words help choose the tense, but they do not create the verb form.'),
  'english-g3-authored': AuthoredLessonVisual(
      title: 'Use the clue, then check the meaning',
      labels: [
        'The glass was fragile, so Mina carried it gently.',
        'Clue: carried gently',
        'Meaning: easily broken'
      ],
      details: [
        'The sentence links fragile with careful handling.',
        'The action suggests the object could be damaged.',
        'Substitute the meaning and reread to test whether it fits.'
      ],
      note:
          'A context clue supports a likely meaning; more context or a dictionary can confirm it.',
      ordered: true),
  'english-g4-authored': AuthoredLessonVisual(
      title: 'One main idea supported by details',
      labels: [
        'Main idea: The class cared for its garden.',
        'Detail: pupils watered the beds.',
        'Detail: pupils pulled weeds.',
        'Detail: pupils checked young plants.'
      ],
      details: [
        'This statement covers the paragraph as a whole.',
        'Watering is one example of garden care.',
        'Weeding is another example.',
        'Checking plants is a third related example.'
      ],
      note:
          'A supporting detail is narrower than the main idea and relates to it.'),
  'english-g5-authored': AuthoredLessonVisual(
      title: 'Compare the same feature',
      labels: [
        'Feature: seating',
        'Bus: shared seats',
        'Bicycle: one rider seat',
        'Shared feature: both transport a person'
      ],
      details: [
        'Choose a feature common to both comparisons.',
        'The bus example names its seating arrangement.',
        'The bicycle example addresses the same feature.',
        'A similarity connects both items rather than describing only one.'
      ],
      note:
          'This model compares ordinary buses and single-rider bicycles; a precise comparison states its scope.'),
  'english-g6-authored': AuthoredLessonVisual(
      title: 'Evidence constrains an inference',
      labels: [
        'Text: Arun checked the clock and tapped his foot.',
        'Inference: He may be impatient.',
        'Limit: We do not yet know what he is waiting for.'
      ],
      details: [
        'These are directly stated actions.',
        'The actions support a likely interpretation.',
        'The text does not identify a bus, person, or exact cause.'
      ],
      note:
          'Inference adds a supported interpretation, not an unrestricted invented story.',
      ordered: true),
};

final primaryEnglish = <String, NorieTopicContent>{
  'g1': subjectLesson(
      subject: 'English',
      grade: 'g1',
      title: 'Short Vowels in CVC Words',
      prerequisite: 'english.g1.simple-sentences',
      objectives: [
        'Find the middle vowel in a short word.',
        'Blend a simple consonant-vowel-consonant word.',
        'Notice how changing a vowel changes a word.'
      ],
      introduction:
          'Cat, hen, pig, hop, and sun have a vowel between two consonants. Say each word slowly with a helper. Listen to the middle sound and look at its letter.',
      explanation:
          'The vowel letters are a, e, i, o, and u. In these short words, one vowel sits in the middle: c-a-t, h-e-n, p-i-g, h-o-p, and s-u-n. Say the separate sounds, then blend them into the word. For cat, begin with the c sound, add the short a sound, and finish with t. The sounds join smoothly to make cat. Do not add a long extra vowel to each consonant. Letter names and word sounds can differ: the a in cat does not say the letter name heard in cake.',
      application:
          'Look at cat and cut. Both begin with c and end with t. The middle vowel changes from a to u, so the word and its meaning change. A cat is an animal; to cut means to divide something with a suitable tool. Look at pin and pan in the same way. This lesson uses simple words with common short-vowel readings; not every English word follows this pattern. Ask a helper to say the examples clearly if a sound is unfamiliar.',
      worked:
          'Read hen. Step 1: point to h and say its sound. Step 2: point to e and say the short sound heard in hen. Step 3: point to n and finish the word. Step 4: blend the sounds and say hen, a female chicken. The middle vowel is e.',
      guided:
          'Look at pig. Which letter is in the middle? Say the word slowly, then blend it. Change i to e: what new word do p-e-g make?',
      solution:
          'The middle letter in pig is i. Changing it to e makes peg. The beginning and ending consonants stay p and g, while the middle vowel changes.',
      mistakes:
          'Use the word sound, not always the vowel letter name. Do not skip the middle letter. Changing one letter may make a different real word, and some letter combinations do not make a familiar word.',
      recap:
          'In these CVC words, find the middle vowel and blend all three sounds. A, e, i, o, and u can have short sounds. Changing the middle vowel can change the word.',
      visual: primaryEnglishVisuals['english-g1-authored']!,
      questions: [
        'Which letter is the middle vowel in cat?|a|c|t|h|Cat is c-a-t, so its middle vowel is a.|Middle vowel',
        'Which word has e in the middle?|hen|cat|pig|sun|Hen is h-e-n and has the middle vowel e.|Middle vowel',
        'Blend p-i-g. Which word is made?|pig|pan|peg|pot|The three letters p, i, and g blend into pig.|Blending',
        'Change a in cat to u. What word is made?|cut|cot|cat|cap|Keeping c and t while changing the vowel to u makes cut.|Changing vowel',
        'Which letter is the middle vowel in hop?|o|h|p|a|Hop is h-o-p, with o between its consonants.|Middle vowel',
        'Which word has the short u sound in this lesson?|sun|hen|pig|cat|Sun uses the common short u sound in s-u-n.|Short vowels',
        'Which pair keeps the consonants but changes the vowel?|pin and pan|cat and cap|hen and pen|sun and fun|Pin and pan share p and n but have different middle vowels.|Changing vowel',
        'In cat, should a be read like its name in cake?|No, it has the short sound in cat|Yes, always|The a is skipped|Only the t is read|This CVC example uses short a, unlike the long a in cake.|Short vowels',
        'Which vowel belongs in p_g to make pig?|i|a|u|o|The word pig is spelled p-i-g with i in the middle.|Blending',
        'Change i in pig to e. What word is made?|peg|pig|pen|pet|The beginning p and ending g stay fixed, giving p-e-g.|Changing vowel',
        'Which set names all five vowel letters taught here?|a, e, i, o, u|b, c, d, f, g|a, b, c, d, e|h, j, k, l, m|A, e, i, o, and u are the vowel letters used in these examples.|Vowel letters',
      ]),
  'g2': subjectLesson(
      subject: 'English',
      grade: 'g2',
      title: 'Irregular Past-Tense Verbs',
      prerequisite: 'english.g2.story-sequence',
      objectives: [
        'Use common irregular verbs for past actions.',
        'Distinguish an irregular form from an -ed form.',
        'Choose tense using the sentence time clue.'
      ],
      introduction:
          'A sentence can tell what happens today or what happened yesterday. Many past verbs add -ed, but some common verbs change in another way.',
      explanation:
          'For a regular verb, play becomes played and jump becomes jumped. For an irregular verb, go becomes went, see becomes saw, and eat becomes ate. These forms do not follow a simple rule of adding -ed. Read the time words and the whole sentence. Today I go to the park uses go. Yesterday I went to the park uses went. A form such as goed is not the standard past tense. Practice each pair in a short sentence so the form connects with its meaning.',
      application:
          'Other useful pairs are come/came, take/took, and make/made. The past form of these action verbs stays the same for different subjects: I went, she went, and they went. The verb be has forms was and were: I was and she was, but we were and they were. This is an additional pattern to notice. In this lesson, we write simple positive past sentences. Questions and negatives can use did with a base verb, but that is a different construction from the examples here.',
      worked:
          'Change Today Ana sees a bird to a yesterday sentence. Step 1: change the time clue to Yesterday. Step 2: use the past form of see, which is saw. Step 3: write Yesterday Ana saw a bird. The subject Ana does not make the past form sawed correct for the action of seeing.',
      guided:
          'Complete these sentences: Yesterday we ___ lunch, using eat. Last night they ___ at home, using be. Explain why the two past forms differ.',
      solution:
          'Yesterday we ate lunch. Last night they were at home. Eat changes to ate; be uses were with they in these past sentences.',
      mistakes:
          'Do not add -ed to every verb. Saw is the past of see, while sawed can describe cutting with a saw and has a different meaning. Time clues matter, and be requires attention to the subject.',
      recap:
          'Common irregular pairs include go/went, see/saw, eat/ate, come/came, take/took, and make/made. Use time clues and read the full sentence. For past be, match was or were with the subject.',
      visual: primaryEnglishVisuals['english-g2-authored']!,
      questions: [
        'Yesterday I ___ to the park. Use go.|went|goed|goes|going|The standard past form of go is went, not goed.|Irregular past',
        'Last week Ana ___ a bird. Use see.|saw|seed|sees|seeing|See changes to saw for this past action.|Irregular past',
        'Yesterday we ___ rice. Use eat.|ate|eated|eats|eating|The irregular past of eat is ate.|Irregular past',
        'Which past verb follows the regular -ed pattern?|played|went|ate|took|Play forms its past by adding -ed, unlike the other verbs.|Regular and irregular',
        'Yesterday Ben ___ a pencil. Use take.|took|taked|takes|taking|Take has the irregular past form took.|Irregular past',
        'Last night they ___ at home. Use be.|were|was|is|be|Use were with they in this simple past sentence.|Past be',
        'Yesterday she ___ happy. Use be.|was|were|are|being|She takes was in this simple past sentence.|Past be',
        'Which time clue most clearly fits a simple past sentence?|Yesterday|Tomorrow|Next week|Soon|Yesterday places the action before the present.|Time clues',
        'Yesterday we ___ a paper boat. Use make.|made|maked|makes|making|Make changes to made for a finished action in the past.|Irregular past',
        'Last Monday she ___ to our house. Use come.|came|comed|comes|coming|Come changes to came for a completed past action.|Irregular past',
        'Correct the seeing sentence: Yesterday I seed a duck.|Yesterday I saw a duck.|Yesterday I goed a duck.|Yesterday I seeing a duck.|Yesterday I sees a duck.|The intended action is seeing, whose standard past form is saw.|Revision',
      ]),
  'g3': subjectLesson(
      subject: 'English',
      grade: 'g3',
      title: 'Word Meanings from Context',
      prerequisite: 'english.g3.paragraph-basics',
      objectives: [
        'Find a nearby clue to an unfamiliar word.',
        'Test a possible meaning by substitution.',
        'Recognize when a clue gives too little information.'
      ],
      introduction:
          'An unfamiliar word does not always stop a reader. The surrounding sentence can offer clues about what it means. We will use brief invented passages and explain the evidence for our choices.',
      explanation:
          'Read the whole sentence before guessing. In The glass was fragile, so Mina carried it gently, the careful action suggests fragile means easy to break. Replace the word with that meaning: The glass was easy to break, so Mina carried it gently. The idea still fits. Some sentences give a direct explanation: The path was narrow, only wide enough for one person. Others use contrast: Unlike the noisy room, the hallway was tranquil. Noisy and tranquil point toward opposite conditions.',
      application:
          'Clues can include examples, explanations, actions, or contrasts. In Water was scarce; the family had only one small bottle left, the small remaining amount suggests scarce means limited or not plentiful. A sentence such as Mina saw a fragile item gives much less help. Do not invent an exact definition from a weak clue. Use more text or a dictionary to confirm when needed. A word can have more than one meaning, so a familiar definition still needs to fit this particular sentence.',
      worked:
          'Read Leo was reluctant to enter; he paused at the doorway and said he was unsure. Step 1: notice paused and unsure. Step 2: infer reluctant means hesitant or unwilling. Step 3: substitute hesitant. Step 4: reread; the meaning fits Leo not entering immediately. The clue does not say he can never enter.',
      guided:
          'The puppy was energetic: it ran, jumped, and chased its ball. Choose a likely meaning of energetic and name two clues. Does the sentence tell the puppy breed?',
      solution:
          'Energetic means active or full of energy. Ran and jumped support the meaning. The breed is not stated, so context cannot establish it.',
      mistakes:
          'Do not choose a definition only because it sounds familiar. Point to a clue in this text and reread with the meaning. A likely meaning does not justify adding facts, such as a character exact age, that the passage never gives.',
      recap:
          'Read around the word, identify an explanation or behavior clue, substitute a likely meaning, and check the sentence. When context is weak, seek more information rather than guess with certainty.',
      visual: primaryEnglishVisuals['english-g3-authored']!,
      questions: [
        'The glass was fragile, so Mina carried it gently. Fragile likely means what?|Easily broken|Very loud|Always expensive|Made of paper only|Gentle handling supports a meaning related to possible breakage.|Context clues',
        'Original sentence: The glass was fragile, so Mina carried it gently. Which words give the clue to fragile?|Carried it gently|Mina only|The only|Was only|The careful action is evidence for the glass being easily damaged.|Evidence',
        'The path was narrow, only wide enough for one person. Narrow means what?|Not wide|Very deep|Very noisy|Perfectly round|The explanation only wide enough for one person supports not wide.|Explanation clue',
        'Unlike the noisy room, the hallway was tranquil. Tranquil likely means what?|Calm and quiet|Crowded and loud|Broken and wet|Bright red|The contrast with noisy points to a quiet or calm hallway.|Contrast clue',
        'Water was scarce; only one small bottle remained. Scarce means what?|In short supply|Unlimited|Extremely hot|Always dirty|Only a small amount remaining supports a limited supply.|Context clues',
        'Leo paused and said he was unsure, so he was reluctant. What fits?|Hesitant|Certain and eager|Asleep|Very tall|Pausing and expressing uncertainty support hesitation.|Action clue',
        'What is a useful check after choosing a meaning?|Substitute it and reread|Ignore the surrounding sentence|Choose the longest definition|Add a new story ending|Substitution tests whether the proposed meaning fits the text.|Meaning check',
        'Mina saw a fragile item gives little explanation. What is best?|Use more context or a dictionary|Claim it must be blue|Claim it must be cheap|Ignore all meanings forever|A weak clue needs additional information rather than an unsupported precise guess.|Limits of context',
        'The puppy ran and jumped; it was energetic. Energetic means what?|Active and full of energy|Silent and motionless|Very old necessarily|Lost and injured|Running and jumping provide evidence for active behavior.|Action clue',
        'The door was ajar, leaving a small opening. Ajar means what?|Partly open|Locked tightly|Painted green|Missing entirely|A small opening explains the door was not completely closed.|Explanation clue',
        'The energetic puppy passage never states its breed. Which response is justified?|Its breed is not established|It must be a beagle|It must be a poodle|It has no breed|The action clues explain energetic but do not identify the breed.|Limits of context',
      ]),
  'g4': subjectLesson(
      subject: 'English',
      grade: 'g4',
      title: 'Main Ideas and Supporting Details',
      prerequisite: 'english.g4.paragraph-organization',
      objectives: [
        'State a main idea that covers a short paragraph.',
        'Select details that support that idea.',
        'Recognize an unrelated or overly broad statement.'
      ],
      introduction:
          'A main idea tells what a paragraph says about its topic. Supporting details explain or illustrate that idea. We will read invented classroom paragraphs and separate the two.',
      explanation:
          'Read this paragraph: The class cared for its garden. Pupils watered the beds each morning. They pulled weeds on Friday. They checked young plants for damaged leaves. The topic is the class garden. The main idea is that the class cared for it. Watering, weeding, and checking plants are supporting details. The topic alone, garden, does not say what the paragraph explains. One detail, pupils watered, is too narrow to cover all its information.',
      application:
          'Sometimes a main idea is stated in a topic sentence; sometimes the reader combines related details. Consider: The library opened an hour earlier. It added a quiet reading corner. It also put signs near each shelf. A suitable main idea is that the library made changes to help visitors use it. Libraries are perfect everywhere is too broad and unsupported. A detail about a class football match would be unrelated unless the paragraph connected it to the library changes. Main ideas should fit the evidence rather than add praise or claims not present.',
      worked:
          'Use the garden paragraph. Step 1: find the repeated topic, the garden. Step 2: ask what the actions have in common; each is care for the garden. Step 3: state the main idea in a complete sentence. Step 4: check that all three action details support it. A sentence about only Friday would leave the morning watering unexplained.',
      guided:
          'Read: The school saved paper. Pupils used both sides of sheets. Teachers reused clean scrap pages for notes. Name the main idea and two supporting details. Would a sentence about a new basketball fit without another explanation?',
      solution:
          'The main idea is that the school saved paper. Using both sides and reusing clean scraps support it. A basketball sentence does not support this paper-saving idea by itself.',
      mistakes:
          'A topic is not a full main idea. The first sentence is not automatically the main idea in every paragraph. Do not select a broad claim such as everyone always succeeds when the text gives only one small example.',
      recap:
          'Find the topic, identify what the paragraph says about it, and check the candidate main idea against all important details. Supporting details are narrower and relevant; unrelated statements need another place.',
      visual: primaryEnglishVisuals['english-g4-authored']!,
      questions: [
        'The class watered, weeded, and checked its garden. What main idea covers all three?|The class cared for its garden|The class only watered on Friday|Every garden is perfect|The pupils never worked|All three actions are examples of caring for the garden.|Main idea',
        'Which is a supporting detail for garden care?|Pupils pulled weeds|The moon is bright|A bus arrived late|A player scored a goal|Pulling weeds directly illustrates care for the garden.|Supporting detail',
        'Why is garden alone not a complete main idea?|It names the topic but says nothing about it|It is too many words|It proves every detail false|It must be a verb|A main idea states what the paragraph explains about its topic.|Topic and idea',
        'A paragraph describes earlier opening, signs, and a reading corner. Best main idea?|The library made helpful changes|Only the signs changed|All libraries are always quiet|Visitors never read|The three related changes fit a broader statement about library improvements.|Main idea',
        'Original paragraph: One library made three changes: earlier opening, new signs, and a reading corner. Which claim is too broad for this paragraph?|All libraries are perfect everywhere|This library added signs|This library opened earlier|This library added a reading corner|The paragraph concerns one library, not every library or perfection.|Scope',
        'Which sentence is unrelated to a paragraph about saving paper without more explanation?|The team bought a basketball|Pupils used both sheet sides|Teachers reused scraps|The school reduced paper use|A basketball purchase does not by itself support paper conservation.|Relevance',
        'Which question helps find the main idea?|What do the important details have in common?|Which sentence has the most letters?|Which word is longest?|Which detail sounds funniest?|A shared point among relevant details suggests the paragraph main idea.|Main idea reasoning',
        'Is the first sentence automatically the main idea of every paragraph?|No, check the whole paragraph|Yes, always|Only if it has a comma|Only if it is short|Some paragraphs imply their main idea across several details.|Main idea reasoning',
        'Using both paper sides and reusing scraps support which main idea?|The school saved paper|The school closed its library|Pupils stopped writing|All books became digital|Both actions reduce the need for fresh sheets.|Supporting detail',
        'Why is pupils watered too narrow for watering, weeding, and checking?|It covers only one of the related actions|It is not a sentence topic|It is impossible to water|It covers all three actions equally|A suitable main idea should include the important shared point of all details.|Scope',
        'How can a reader check a proposed main idea?|See whether all key details support it|Ignore details after sentence one|Add unsupported praise|Count punctuation only|Matching the candidate with key evidence tests its coverage and accuracy.|Main idea reasoning',
      ]),
  'g5': subjectLesson(
      subject: 'English',
      grade: 'g5',
      title: 'Writing Compare-and-Contrast Paragraphs',
      prerequisite: 'english.g5.opinion-writing',
      objectives: [
        'Compare two items using shared features.',
        'Distinguish similarities from differences.',
        'Organize a paragraph with specific linked evidence.'
      ],
      introduction:
          'A useful comparison examines the same features of two things. It does more than write one unrelated list about each. We will compare a fictional bus journey and bicycle journey to school.',
      explanation:
          'A similarity tells how both items share a feature; a difference tells how that feature varies. In our example, both journeys take learners to school. The bus has shared seats, while the single-rider bicycle has one rider seat. Those two details compare seating. Saying the bus has seats while the bicycle is blue compares different features and does not explain a clear difference. Begin with a topic sentence naming the two items and the comparison focus. Choose features that matter to that focus.',
      application:
          'A point-by-point paragraph addresses one shared feature at a time. For example: Both the bus and bicycle provide transport to school. The bus carries several passengers, whereas this bicycle carries one rider. The bus follows a set route; the rider can choose among permitted routes. Words such as both and similarly mark similarities, while whereas and unlike mark contrasts. These links must match the facts. A conclusion can explain the significance without claiming one choice is best for everyone. Our example does not describe every kind of bus or bicycle.',
      worked:
          'Compare a printed story and an audio version of the same story. Step 1: choose the shared feature, delivery of words. Step 2: write the similarity: both tell the same story. Step 3: state the contrast: print presents written words, whereas audio presents spoken words. Step 4: connect the difference to use: print permits visual rereading, while audio conveys a narrator voice. Avoid unrelated color or price claims not supplied.',
      guided:
          'Two fictional school clubs both meet on Friday. Art club makes drawings, while music club practices songs. Write one similarity sentence and one contrast sentence using both and whereas.',
      solution:
          'Both clubs meet on Friday. Art club makes drawings, whereas music club practices songs. The first compares meeting time; the second compares the main activity.',
      mistakes:
          'Do not contrast one item color with another item size. Transition words cannot make unrelated details comparable. Avoid always and everyone unless the evidence supports them. A comparison can explain differences without declaring a universal winner.',
      recap:
          'Name two items, select shared features, and support similarities and differences with matching details. Organize point by point and choose transitions that express the actual relationship.',
      visual: primaryEnglishVisuals['english-g5-authored']!,
      questions: [
        'Which sentence states a similarity?|Both clubs meet on Friday.|Art club draws, whereas music club sings.|The bus carries more passengers.|Print uses written words, unlike audio.|Both introduces a feature shared by the two clubs.|Similarity',
        'Which sentence compares the same feature?|The bus has shared seats; this bicycle has one rider seat.|The bus has seats; the bicycle is blue.|The bus is large; the bicycle bell is loud.|The bus route is fixed; the bicycle paint is red.|The first comparison addresses seating for both items.|Shared features',
        'Which transition clearly signals contrast?|Whereas|Both|Similarly|Also|Whereas links differing features, while the others usually add or compare similarities.|Transitions',
        'What should a comparison topic sentence identify?|The two items and comparison focus|Only one unrelated detail|A universal winner without evidence|Only the writer name|Naming both items and focus guides the paragraph comparison.|Organization',
        'Point-by-point organization groups information how?|By a shared feature across both items|By random facts|Only by word length|By punctuation marks|Each point discusses corresponding features of both items.|Organization',
        'Print and audio tell the same story. Which is a difference in delivery?|Written words versus spoken words|Both contain the same story|Both have a beginning|Both concern the same characters|Written versus spoken presentation compares a differing delivery feature.|Contrast',
        'A comparison says print and audio tell the same story, using written and spoken words respectively. Why avoid claiming one choice is best for everyone from these facts alone?|The given evidence does not establish every user need|Comparisons cannot draw any conclusion|The word best is always illegal|Both items must be identical|A universal claim goes beyond the limited supplied facts.|Scope',
        'Which revision fixes mismatched bus seats and bicycle color?|Compare bus seats with bicycle seating|Add similarly before the mismatch|Delete all item names|Claim both are always red|Using the same feature creates a meaningful comparison.|Revision',
        'Art club draws and music club practices songs. Best contrast sentence?|Art club draws, whereas music club practices songs.|Both clubs always draw.|Similarly, only art club meets.|Music club has color, whereas Friday is long.|The sentence matches two different activities with an appropriate contrast link.|Contrast',
        'Both clubs meet Friday. Which sentence keeps that shared fact?|Both art and music clubs meet on Friday.|Only art club meets on Friday.|Neither club meets on Friday.|Art club meets, whereas music never meets.|The sentence accurately applies the shared meeting time to both clubs.|Similarity',
        'Why can a transition not fix unrelated comparison features?|The facts still address different questions|Transitions erase evidence|All differences are impossible|Every paragraph must list only similarities|Words can signal a relationship but cannot supply missing matching evidence.|Shared features',
      ]),
  'g6': subjectLesson(
      subject: 'English',
      grade: 'g6',
      title: 'Inference Supported by Text',
      prerequisite: 'english.g6.essay-foundations',
      objectives: [
        'Distinguish a stated detail from an inference.',
        'Link an interpretation to specific text evidence.',
        'Limit an inference when more than one explanation fits.'
      ],
      introduction:
          'Readers combine text clues with reasonable knowledge to infer unstated meanings. A strong inference explains its evidence and stays within what that evidence supports.',
      explanation:
          'Read this invented scene: Arun checked the clock three times. He tapped his foot and looked toward the door. He may be waiting impatiently. The clock checks and foot tapping are stated details; impatience is an inference. The scene does not say exactly what he is waiting for. A bus, a visitor, or another event could fit, so naming one as certain goes too far. A useful response says what is likely, identifies clues, and marks uncertainty when appropriate.',
      application:
          'Consider another scene: Jo wrapped a scarf tightly around her neck and rubbed her hands before stepping outside. The actions support an inference that she expects cold conditions. They do not prove a specific temperature or city. Evidence can also challenge an initial interpretation. If the next sentence says Jo was practicing a winter scene on a warm stage, the reader must revise. Inference is responsive to new text. Do not treat a character single action as proof of a permanent personality trait.',
      worked:
          'In an invented scene, Mei moved the broken cup behind a book and avoided her father gaze. Step 1: identify the observable actions. Step 2: infer she may be trying to hide the damage or feels uneasy. Step 3: explain how hiding the cup supports that interpretation. Step 4: avoid claiming she broke it deliberately, because the text gives no cause of the break.',
      guided:
          'A character reads a note, smiles, and starts packing a bag. Give one supported inference and one claim the scene does not establish. What later detail could change the inference?',
      solution:
          'The note may contain welcome news or prompt a pleasant trip. The scene does not establish the destination or exact message. A later line saying the smile was forced could change the emotional interpretation.',
      mistakes:
          'An inference is not just copied wording, and it is not a free invention. Quote or paraphrase a relevant clue. Distinguish likely from certain, avoid exact unsupported facts, and revise when later text contradicts your first reading.',
      recap:
          'Separate stated actions from interpretations. Explain the connection between evidence and inference, acknowledge reasonable alternatives, and update the interpretation when the passage supplies new information.',
      visual: primaryEnglishVisuals['english-g6-authored']!,
      questions: [
        'Arun checked the clock three times. Which is directly stated?|He checked the clock three times|He waited for a bus|He was late for a flight|He lived in a cold city|Only the clock-checking action appears explicitly in the scene.|Stated detail',
        'Clock checking and foot tapping most support which cautious inference?|He may be impatient|He certainly hates every visitor|He is exactly ten years old|He must be waiting for a bus|The actions suggest impatience but do not establish its exact cause.|Inference',
        'Original scene: Arun checked the clock three times. He tapped his foot and looked toward the door. Which claim goes beyond this scene?|He is certainly waiting for a bus|He looked toward the door|He tapped his foot|He checked the clock|The text does not identify the event he awaits.|Evidence limits',
        'Jo wraps a scarf and rubs her hands before going out. What is supported?|She may expect cold conditions|The temperature is exactly 2°C|She lives in a named city|She has never felt warm|The clothing and hand action support a general cold-weather inference.|Inference',
        'Original scene: Jo wraps a scarf and rubs her hands before going out. A later line says Jo is acting a winter scene on a warm stage. What should a reader do with an initial inference of real cold?|Revise the earlier inference|Ignore the new text|Insist the scene proves real cold|Delete all evidence|New information can change the explanation of earlier actions.|Revision',
        'What strengthens an inference response?|Relevant text clues and explained reasoning|Only a confident tone|An unrelated personal story|An exact guess without clues|Evidence and a reasoning link let readers assess the interpretation.|Evidence reasoning',
        'Original scene: Mei moved the broken cup behind a book and avoided her father’s gaze. Which claim is not established?|She broke it deliberately|The cup is broken|She moved the cup behind a book|She avoided her father gaze|The scene shows hiding but does not state how or why the cup broke.|Evidence limits',
        'Why use may when several explanations fit?|To mark uncertainty supported by limited evidence|To make every claim meaningless|To avoid reading the passage|To say the text is false|Cautious wording matches evidence that permits more than one explanation.|Qualification',
        'A note makes a character smile and pack. Which inference is cautious?|The note may prompt welcome travel news|The note certainly names Paris|The character is always happy|The bag is definitely red|The actions support a possible positive response, not an exact destination.|Inference',
        'Original scene: A character reads a note, smiles, and starts packing a bag. A later line says the smile was forced. What follows for the initial interpretation of happiness?|Reconsider the earlier happy interpretation|Prove every smile means joy|Ignore the line as irrelevant|Claim the note text is known|Forced smiling can contradict the assumption of a sincerely happy response.|Revision',
        'Which response distinguishes fact and inference?|She hid the cup; this suggests uneasiness.|She hid the cup, so every detail I invent is true.|She must be guilty because I say so.|She certainly planned the break yesterday.|The first clause reports action; the second marks a supported interpretation.|Evidence reasoning',
      ]),
};
