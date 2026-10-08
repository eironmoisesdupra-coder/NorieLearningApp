import '../../domain/norie_content_models.dart';
import 'authored_lesson_visual.dart';
import 'subject_lesson_builder.dart';

const secondaryEnglishVisuals = <String, AuthoredLessonVisual>{
  'english-g7-authored': AuthoredLessonVisual(
      title: 'Trace a character decision',
      labels: [
        'Goal: Lea wants her friend to succeed.',
        'Obstacle: Her friend is embarrassed to ask for help.',
        'Action: Lea offers to rehearse privately.',
        'Inference: Loyalty motivates a considerate choice.'
      ],
      details: [
        'The passage states the goal.',
        'The obstacle shapes how support can be offered.',
        'The action addresses the obstacle without public attention.',
        'The interpretation explains the connection among goal, obstacle, and action.'
      ],
      note:
          'The scene is invented for this lesson; another action or later evidence could complicate the interpretation.',
      ordered: true),
  'english-g8-authored': AuthoredLessonVisual(
      title: 'A claim with a fair counterclaim',
      labels: [
        'Claim: Extend library hours.',
        'Evidence: Recorded demand after closing.',
        'Counterclaim: Staffing costs may rise.',
        'Response: Trial one evening and measure cost and use.'
      ],
      details: [
        'The claim proposes an action.',
        'Relevant attendance data can support need.',
        'A reasonable objection concerns feasibility.',
        'The response addresses the objection rather than insulting opponents.'
      ],
      note:
          'This is an invented policy example; evidence must be collected before treating the claim as established.'),
  'english-g9-authored': AuthoredLessonVisual(
      title: 'Integrate a short quotation',
      labels: [
        'Claim: The narrator feels uncertain.',
        'Context + quotation: At the doorway, the narrator calls the room “unfamiliar.”',
        'Analysis: That adjective marks distance rather than comfort.'
      ],
      details: [
        'Make a specific interpretive point.',
        'Introduce the situation and preserve the source wording.',
        'Explain how the chosen language supports the point.'
      ],
      note:
          'The passage is invented; use the required citation style for real sources and never fabricate a locator.',
      ordered: true),
  'english-g10-authored': AuthoredLessonVisual(
      title: 'Evaluate a source and its claim',
      labels: [
        'Authorship and expertise',
        'Evidence and method',
        'Date and relevance',
        'Independent corroboration'
      ],
      details: [
        'Identify who created it and relevant qualifications.',
        'Find traceable support rather than only an assertion.',
        'Ask whether currency matters for this question.',
        'Compare independent reporting or primary records.'
      ],
      note:
          'A polished page or a familiar domain alone does not establish that a specific claim is accurate.'),
};

final secondaryEnglish = <String, NorieTopicContent>{
  'g7': subjectLesson(
      subject: 'English',
      grade: 'g7',
      title: 'Character Motivation and Choices',
      prerequisite: 'english.g7.expository-writing',
      objectives: [
        'Distinguish a character action from its possible motivation.',
        'Connect goals and obstacles to decisions.',
        'Use later evidence to revise a character interpretation.'
      ],
      introduction:
          'Characters do things for reasons. A motivation is the goal, need, or feeling behind an action. Literary analysis explains how the text supports that reason instead of simply naming a personality trait.',
      explanation:
          'Read this invented scene: Lea wanted her friend Omar to feel ready for the recital. Omar refused to rehearse in front of the class because he feared mistakes. Lea stayed after school and offered to practice with him alone. The action is her offer of private practice. A supported motivation is helping her friend succeed while respecting his embarrassment. The stated goal, Omar obstacle, and Lea response fit together. Calling Lea loud or selfish would need different evidence. Motivation can be stated directly or inferred from dialogue, actions, and circumstances.',
      application:
          'One action can have more than one possible reason. A character who stays late may be helping someone, avoiding home, or finishing personal work; the surrounding text decides which interpretation fits. Distinguish motivation from result: Lea hopes to help, but the passage does not yet say Omar performs well. Characters can have mixed motives. Later information that Lea also wants to earn a leadership award may add another reason without erasing her supportive actions. Avoid treating an early interpretation as permanent certainty.',
      worked:
          'An invented character returns a lost notebook without reading its private pages. Step 1: identify the action, returning it unopened. Step 2: locate dialogue: The owner should get it back, and those pages are not mine to read. Step 3: infer respect for ownership and privacy. Step 4: explain both the return and the decision not to read. Merely saying the character walked does not analyze motivation.',
      guided:
          'In an invented scene, Tessa declines a race because she promised to help her younger brother study. What is her action, what motivates it, and what claim about her running ability is unsupported?',
      solution:
          'Her action is declining the race. Keeping a promise and helping her brother motivate it. The passage does not establish that she is a slow runner or afraid of racing.',
      mistakes:
          'A trait label alone is not evidence. Do not confuse a hoped-for outcome with an achieved result. Use the actual scene, consider competing explanations, and revise when later text supplies another motive.',
      recap:
          'Explain motivation by linking textual goals, obstacles, dialogue, and actions. Separate reason from result and keep interpretations open to additional evidence.',
      visual: secondaryEnglishVisuals['english-g7-authored']!,
      questions: [
        'Original scene: Lea wanted her friend Omar to feel ready for the recital. Omar refused to rehearse before the class because he feared mistakes. Lea stayed after school and offered to practice with him alone. In Lea scene, which is the action?|Offering private rehearsal|Omar performing successfully|Winning a leadership award|Refusing to help at all|The passage states Lea offered to rehearse with Omar alone.|Action and motivation',
        'Original scene: Lea wanted her friend Omar to feel ready for the recital. Omar refused to rehearse before the class because he feared mistakes. Lea stayed after school and offered to practice with him alone. What best supports Lea motivation to help considerately?|She offers private practice after Omar fears public mistakes|She never speaks in the scene|The recital date is unstated|Her shirt is unspecified|Her choice directly addresses her friend embarrassment and readiness.|Text evidence',
        'Original scene: Lea wanted her friend Omar to feel ready for the recital. Omar refused to rehearse before the class because he feared mistakes. Lea stayed after school and offered to practice with him alone. Which is not established by the Lea scene?|Omar performed well at the recital|Omar feared mistakes|Lea wanted him ready|Lea offered help|The scene gives preparation and intent, not the later performance result.|Reason and result',
        'A motivation is best described as what?|A reason or goal behind an action|Only the action location|Every final outcome|A character name|Motivation explains why a character chooses an action.|Literary concept',
        'A notebook is returned unread with privacy dialogue. What motive fits?|Respect for ownership and privacy|Desire to publish its secrets|Proof of inability to read|Certain dislike of the owner|The return and refusal to read fit the stated respect for privacy.|Interpretation',
        'Tessa skips a race to keep a helping promise. What is unsupported?|She must be a slow runner|She made a promise|She chose to help|She declined the race|Her choice explains a priority, not her running ability.|Evidence limits',
        'Original scene: Lea wanted her friend Omar to feel ready for the recital. Omar refused to rehearse before the class because he feared mistakes. Lea stayed after school and offered to practice with him alone. Later text adds that Lea wants a leadership award. What may change?|Her motives may be mixed|All previous actions disappear|Her help becomes impossible|Omar never feared mistakes|New evidence can add a self-interested motive alongside the supportive one.|Revision',
        'Why is generous alone a weak full analysis?|It needs scene evidence and a reasoning link|It is never a real word|Every trait is directly stated|A label proves every possible motive|A trait label must be supported by relevant actions or dialogue.|Analysis',
        'A character stays late, but no other clue is given. Which response is best?|Several motives remain possible|Helping is proven uniquely|Avoiding home is certain|The character cannot have a motive|One action without context can fit multiple reasonable explanations.|Evidence limits',
        'Which statement separates motive from result?|Lea hopes to help; success is not yet shown.|Lea hopes to help, so success is guaranteed.|Private rehearsal proves a prize was won.|Every intention equals its outcome.|An intention describes purpose, while the outcome requires later evidence.|Reason and result',
        'What should an interpretation do with contradictory later dialogue?|Reassess the proposed motivation|Ignore it automatically|Repeat the first label unchanged|Assume every dialogue line is irrelevant|Interpretations should respond to new evidence that changes the scene meaning.|Revision',
      ]),
  'g8': subjectLesson(
      subject: 'English',
      grade: 'g8',
      title: 'Claims and Fair Counterclaims',
      prerequisite: 'english.g8.argument-writing',
      objectives: [
        'Identify a claim and its supporting evidence.',
        'Represent a reasonable counterclaim accurately.',
        'Write a response that addresses the actual objection.'
      ],
      introduction:
          'An argument proposes a position and supports it. A fair counterclaim states a real alternative or objection. Addressing it can strengthen an argument without treating disagreement as a personal attack.',
      explanation:
          'Consider an invented school proposal: The library should open one evening each week because some pupils cannot visit before closing. The claim is the proposed evening opening. Attendance records or a well-designed survey could support the need. The sentence itself has not supplied those records, so do not treat them as already measured facts. A reasonable counterclaim is that extra staffing could cost more. It challenges feasibility, not the value of reading. A response should acknowledge and address that cost rather than accuse opponents of hating books.',
      application:
          'A rebuttal offers reasons or evidence against an objection. A concession accepts a valid part: Extra hours could increase costs. The writer can then qualify the proposal: Try one evening for a month, record attendance and staffing expense, and review the result. This addresses the objection without pretending costs vanish. Avoid a straw man, which weakens another view into an easier target. Asking whether one evening is affordable differs from claiming no student should ever read. Strong arguments distinguish what is known from what needs evidence.',
      worked:
          'Invented claim: add a bicycle rack because existing spaces fill. Step 1: identify the claim and needed evidence, counts of occupied spaces. Step 2: state a counterclaim fairly: a rack could reduce walkway space. Step 3: respond with a measured layout preserving a safe walkway. Step 4: explain why calling opponents lazy would not answer their space concern.',
      guided:
          'A class proposes planting trees in a courtyard. A counterclaim says roots may affect a nearby path. Write one fair response and identify the evidence needed before promising no damage.',
      solution:
          'A fair response proposes assessing suitable species and planting distances, then checking the layout with relevant expertise. Evidence about root growth and site conditions is needed; a blanket guarantee is unsupported.',
      mistakes:
          'Evidence is not just repetition of the claim. A counterclaim can raise a practical condition rather than reject the goal entirely. Conceding a genuine issue does not automatically abandon a proposal. Insults do not rebut cost or space concerns.',
      recap:
          'State the claim, support it with relevant evidence, represent the actual counterclaim, and answer it with reasons, data, or a qualified revision. Keep unmeasured assumptions explicit.',
      visual: secondaryEnglishVisuals['english-g8-authored']!,
      questions: [
        'Invented proposal: The library should open one evening each week because some pupils cannot visit before closing. Which is its claim?|Open one evening each week|All costs have been measured|Everyone hates current hours|Staffing never costs money|The proposed action is the position the writer argues for.|Claim',
        'Which evidence would most directly support demand for extra hours?|Records of pupils unable to visit before closing|Only wall paint color|A count of unrelated sports goals|A list of staff favorite songs|Evidence about access before closing addresses the stated need.|Evidence',
        'Invented proposal: The library should open one evening each week because some pupils cannot visit before closing. Which is a fair counterclaim?|Extra staffing could increase cost|Opponents hate all books|No pupil should ever read|The library has no purpose|A cost concern is a reasonable objection to the specific proposal.|Counterclaim',
        'A proposal would extend library hours. An objection says extra staffing could increase cost. What response addresses this objection?|Trial one evening and measure cost and use|Insult the objectors|Repeat reading is good only|Claim all costs are zero without evidence|A monitored trial examines the actual feasibility concern.|Response',
        'What is a concession?|Acknowledging a valid part of an objection|Inventing a weaker opposing view|Calling every claim proven|Removing all evidence|A concession accepts a reasonable issue before qualifying or defending the argument.|Concession',
        'Which is a straw-man response to a walkway concern?|You want nobody to ride bicycles.|A rack could take walkway space.|We should measure the remaining width.|The layout needs review.|The response distorts a space concern into opposition to all cycling.|Fair representation',
        'A class proposes planting courtyard trees beside a path. It has supplied no root-growth or site evidence. Why is planting will never damage the path unsupported?|Root and site evidence has not been established|Trees cannot have roots|Arguments cannot use facts|Counterclaims always win|A guarantee requires relevant evidence about species, distance, and site conditions.|Evidence limits',
        'Which response answers a bicycle-rack space concern?|Use a measured layout that preserves walkway space|Say opponents are lazy|Repeat that bicycles exist|Change the subject to library hours|The response addresses the specific issue of available walkway space.|Response',
        'If extra hours increase costs, what can the writer reasonably do?|Qualify the proposal with a limited monitored trial|Pretend the evidence says no cost|Accuse all staff of dishonesty|Claim reading has no value|A revision can acknowledge cost while testing a narrower proposal.|Qualification',
        'Which sentence distinguishes a proposed fact from evidence already available?|Attendance records are needed to test demand.|The records prove demand although none were collected.|Any proposal is its own proof.|A repeated claim becomes measured evidence.|The sentence marks the current evidence gap rather than fabricating support.|Evidence limits',
        'Why do insults fail to rebut a cost counterclaim?|They do not address the cost reasoning|They supply budget data|They measure staffing hours|They concede the exact amount|Personal attacks do not answer the practical argument being made.|Fair representation',
      ]),
  'g9': subjectLesson(
      subject: 'English',
      grade: 'g9',
      title: 'Integrating Quotations into Analysis',
      prerequisite: 'english.g9.analytical-essays',
      objectives: [
        'Select short source wording relevant to a claim.',
        'Introduce and explain a quotation in a sentence.',
        'Preserve source meaning and provide truthful attribution.'
      ],
      introduction:
          'A quotation supplies exact source language. Analysis explains why that language matters. A paragraph needs both; a quotation alone does not make the reader understand the argument.',
      explanation:
          'Use this invented passage: At the doorway, I paused. The room felt unfamiliar, and I held the invitation tightly. To argue that the narrator feels uncertain, choose the word unfamiliar and the pause as evidence. Introduce the wording: At the doorway, the narrator describes the room as “unfamiliar.” Then explain the word choice: unfamiliar marks a lack of ease with the setting. Quotation marks identify exact copied wording and a citation identifies the source. Our practice passage is invented and has no external author or page to fabricate.',
      application:
          'A useful pattern is claim, context, quoted evidence, and analysis. Select only the wording needed. A long copied passage can obscure the point. Blend a short phrase grammatically into your own sentence, keeping the meaning intact. If you omit words in a real quotation, follow the assigned style for ellipses and ensure the omission does not reverse the meaning. Distinguish quotation from paraphrase: a paraphrase uses your own wording but still requires source attribution in research writing. Do not invent a page number when the source lacks one.',
      worked:
          'Claim: the narrator hesitates before entering. Step 1: introduce the moment at the doorway. Step 2: write an integrated quotation: At the doorway, the narrator states, “I paused.” Step 3: explain that pausing delays entry and supports hesitation. Step 4: add qualification: the scene does not establish an extreme fear. This sequence ties evidence to the interpretation rather than merely dropping a sentence into the paragraph.',
      guided:
          'Invented passage: I called the narrow bridge manageable after testing the first board. Which short word would support a claim that the narrator sees the task as possible? Explain why quoting narrow alone would not support the same point.',
      solution:
          'Manageable directly supports the idea that the task seems possible. Narrow describes size, not the narrator judgment about whether it can be handled.',
      mistakes:
          'Do not leave a quotation unexplained. Quotation marks require exact wording, not an altered paraphrase. Never use an omission to hide a not or reverse the author position. A citation locator must exist in the source.',
      recap:
          'Choose exact, relevant wording; introduce its context; explain its connection to the claim; and attribute it accurately. Paraphrase and quotation are different methods, but both can need citation.',
      visual: secondaryEnglishVisuals['english-g9-authored']!,
      questions: [
        'Original passage: At the doorway, I paused. The room felt unfamiliar, and I held the invitation tightly. Which word in the invented room passage best supports lack of familiarity?|Unfamiliar|Invitation|Doorway|Room|Unfamiliar directly describes the narrator relation to the setting.|Evidence selection',
        'What must follow a quotation in analytical writing?|An explanation of how it supports the claim|Only another unrelated quotation|A guessed page number|A personal insult|Analysis connects source wording to the writer interpretive point.|Analysis',
        'Original passage: At the doorway, I paused. The room felt unfamiliar, and I held the invitation tightly. Which action in the passage supports hesitation?|I paused.|I ran confidently.|I welcomed everyone.|I crossed without stopping.|The stated pause delays entry and can support hesitation.|Evidence selection',
        'What distinguishes quotation from paraphrase?|Quotation preserves exact source wording|Paraphrase always needs quotation marks|Quotation invents a new author|Paraphrase removes all attribution duties|A quotation uses exact wording, while paraphrase restates ideas in new words.|Source use',
        'The invented passage has no external page number. What should a learner avoid?|Inventing a page locator|Naming it as the lesson passage|Explaining its wording|Selecting a short phrase|A locator must correspond to the source rather than be fabricated.|Attribution',
        'Original passage: I called the narrow bridge manageable after testing the first board. Why can quoting only narrow fail to show the bridge seems possible?|It describes size, not manageability|It is never an adjective|It means impossible in every context|It proves the narrator crossed|The selected word must support the specific claim about perceived possibility.|Relevance',
        'What is wrong with omitting not to reverse a source position?|It misrepresents the meaning|It improves accuracy|It is always required|It removes the need for analysis|An omission must not distort the source claim or position.|Integrity',
        'Which pattern integrates evidence coherently?|Claim, context, quotation, analysis|Quote, unrelated joke, guessed citation|Only long copied passages|Claim repeated without evidence|Context and analysis explain the selected quotation relevance.|Organization',
        'Original passage: I called the narrow bridge manageable after testing the first board. Which word supports the bridge task being possible?|Manageable|Narrow only|Board only|First only|Manageable expresses the narrator judgment that the task can be handled.|Evidence selection',
        'Can I paused alone establish extreme fear with certainty?|No, it supports hesitation but not that exact intensity|Yes, every pause proves extreme fear|Yes, the invitation proves panic|No, words never support interpretations|The action allows a cautious inference but not an unsupported emotional extreme.|Qualification',
        'A writer changes unfamiliar to terrifying inside quotation marks. What is wrong?|The quoted wording is no longer exact|Every adjective is interchangeable|The citation becomes unnecessary|The source automatically approves the change|Quotation marks present source wording, so replacing a key word misquotes it.|Integrity',
      ]),
  'g10': subjectLesson(
      subject: 'English',
      grade: 'g10',
      title: 'Evaluating Sources and Specific Claims',
      prerequisite: 'english.g10.research-writing',
      objectives: [
        'Examine authorship, evidence, date, and relevance.',
        'Trace a claim to supporting primary information.',
        'Distinguish source reputation from proof of one claim.'
      ],
      introduction:
          'A polished page can contain a weak claim, while a simple-looking page can provide careful evidence. Source evaluation asks specific questions about how an assertion is supported.',
      explanation:
          'Begin with the research question. For a claim about a school attendance change, look for who collected the data, how attendance was measured, and which dates and groups were included. An author relevant experience can help but does not replace evidence. A chart needs a clear source, units, and method. Distinguish a firsthand record or original study from a later report that summarizes it. Summaries can be useful, but tracing them to their source helps reveal whether the headline overstates the findings.',
      application:
          'Currency depends on the question. A current bus schedule needs an updated official source; an old diary can still be valuable evidence of its historical author experience. Compare independent sources rather than several pages copying the same report. A domain suffix, logo, or popularity does not alone verify a claim. Ask whether the page aims to inform, persuade, sell, or entertain, and whether it discloses limitations or interests. This lesson uses invented source descriptions, not live pages; verify actual changing facts when researching them.',
      worked:
          'Invented headline: New club doubles attendance. The linked school record lists forty visits this month and twenty last month, but the club opened twice as many days. Step 1: confirm total visits doubled. Step 2: calculate visits per open day. Step 3: note that the headline alone does not establish stronger daily attendance or prove the club caused the change. Step 4: report the supported total and the limitation.',
      guided:
          'Three blogs repeat one unnamed survey, while a school publishes its dated attendance register with a method note. Which provides a more traceable starting point? What must still be checked in the register?',
      solution:
          'The register offers traceable primary data. Check dates, completeness, definitions, and relevance to the question. Three repeated blog accounts do not become three independent confirmations.',
      mistakes:
          'Do not judge accuracy by design alone. Recent is not automatically more relevant for every historical question. Multiple copies of one claim are not independent evidence. A reliable institution can still make an error in a particular statement.',
      recap:
          'Evaluate the specific claim using relevant authorship, traceable evidence, appropriate dates, and independent checks. Identify method limits and distinguish what the evidence establishes from what a headline implies.',
      visual: secondaryEnglishVisuals['english-g10-authored']!,
      questions: [
        'Which most directly helps evaluate an attendance claim?|Traceable records with dates and definitions|Only an attractive logo|Only page popularity|Only large headline text|Records with clear methods let the reader check what was measured.|Evidence',
        'Does a familiar domain suffix alone prove a claim?|No|Yes, always|Only if the page is colorful|Only if many readers agree|A domain can provide context but is not proof of a specific assertion.|Source judgment',
        'Which needs current verification most clearly?|A current bus schedule|A dated historical diary as a historical source|The spelling of a fixed quotation|The original year on an archived letter|Schedules can change, so current decisions need current official information.|Currency',
        'Three blogs copy one survey. How many independent survey sources are shown?|One|Three|Six|None necessarily|Copied accounts share the same underlying evidence rather than independently confirming it.|Corroboration',
        'A historical diary can be useful even when old because what?|Its date may fit the historical question|Older always means accurate|It proves all modern events|It removes the need for interpretation|Relevance and source purpose matter, not recency alone.|Relevance',
        'Visits doubled while opening days doubled. What is not established by totals alone?|Visits per open day increased|Total recorded visits increased|There were more opening days|The two totals differed|More total visits can result from more days without higher daily attendance.|Claim scope',
        'What question helps identify source purpose?|Is it informing, selling, persuading, or entertaining?|Which font is largest only?|How many colors appear only?|Is the page title short only?|Purpose and possible interests help frame how claims are presented.|Source purpose',
        'What should be checked in a primary attendance register?|Definitions, dates, completeness, and relevance|Only cover color|Only the author favorite club|Nothing because primary means perfect|Primary evidence still needs scrutiny of its method and scope.|Evidence',
        'An unnamed survey supports a headline. Best next step?|Locate the original survey and its method|Repeat the headline as proven|Count copies as independent studies|Assume all respondents agree|Tracing the claim to original evidence permits meaningful evaluation.|Traceability',
        'A respected organization publishes an unsupported specific claim. What follows?|The claim still needs evidence|Its reputation proves every detail|The claim is false automatically|Evidence no longer matters|Reputation can inform judgment but cannot replace support for each assertion.|Source judgment',
        'Why compare source methods rather than just conclusions?|Different measures can explain apparent disagreement|Methods never affect findings|All sources use identical definitions|Only the headline matters|Differences in sampling, definitions, or dates can change what conclusions mean.|Evidence reasoning',
      ]),
};
