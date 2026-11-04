import 'standards_lesson.dart';

const _notice =
    'Campus notice: The library will close at 4 p.m. on Friday for electrical maintenance. '
    'Borrowers may renew books through the portal before 4 p.m. Students without internet access '
    'may ask the service desk to renew books before closing. Normal hours resume on Saturday.';
const _study =
    'Practice report: In a survey of 80 first-year students from one class, 48 said they preferred printed notes. '
    'Participation was voluntary. The report describes preference, not test performance. '
    'The authors recommend surveying more classes before changing campus-wide services.';
const _email = 'Subject: Request to reschedule consultation on 12 August\n'
    'Dear Professor Santos,\nOur group has a required laboratory session during our 2 p.m. consultation '
    'on 12 August. May we meet at 3 p.m. instead? We can also attend during your next available office hour. '
    'Please let us know which option is suitable. Thank you.\nRespectfully,\nMika Cruz, Group 2';
const _proposal =
    'Proposal: Install labeled refill stations near two busy classrooms. A one-week audit recorded '
    '120 disposable bottles in the nearby bins. The audit covered these bins only. A four-week pilot '
    'will track refill use, maintenance costs, and bottle counts. Stations must be accessible and '
    'water quality must be checked before use.';

const chedEnglishLessons = <StandardsLesson>[
  StandardsLesson(
    title: 'Purpose, Audience, and Ethical Communication',
    objectives: [
      'Identify purpose, audience, channel, and feedback in a message.',
      'Revise communication to remove ambiguity and access barriers.',
      'Apply respect and accuracy when communicating across differences.',
    ],
    explanation:
        'Purposive communication selects language and media for a particular audience, situation, and goal. '
        'A message is not successful merely because it was sent: receivers must be able to access and interpret it. '
        'Feedback allows clarification. Noise can be physical, technical, or semantic, such as an unfamiliar term. '
        'Ethical communicators avoid deception, acknowledge sources, and represent others without stereotypes. '
        'In multilingual Philippine settings, plain language, translation where appropriate, and multiple '
        'accessible channels can support participation. Accent differences do not by themselves establish '
        'competence or credibility. Consider this original notice:\n\n$_notice',
    model: {
      'Purpose': 'Explain a temporary closure and available renewal options.',
      'Audience and access':
          'Borrowers include students with and without internet access.',
      'Action and time':
          'Renew before 4 p.m. on Friday; normal hours resume Saturday.',
    },
    worked: 'Revise "The library closes early; do it online." '
        '1. Identify missing information: date, time, action, and alternative access. '
        '2. Replace vague "it" with "renew books." '
        '3. Give Friday, 4 p.m., and the service-desk alternative. '
        '4. Ask a reader to explain the required action to check understanding.',
    guided:
        'Write a two-sentence reminder for borrowers who cannot use the portal. Include the action and deadline.',
    solution:
        'If you cannot access the portal, ask the library service desk to renew your books before 4 p.m. on Friday. Normal library hours resume on Saturday.',
    mistake:
        'Do not assume everyone has internet access, use an unspecified "soon" as a deadline, or infer ability from accent or language background.',
    recap:
        'A clear, ethical message states who should do what, when, why, and through an accessible channel.',
    questions: [
      [
        '$_notice\n\nWhat is the notice\'s main purpose?',
        'Explain a temporary closure and renewal options',
        'Advertise a permanent closure',
        'Cancel all borrowing',
        'Announce a new degree program',
        'The notice gives closure timing and practical options.'
      ],
      [
        '$_notice\n\nWhen does the library close on Friday?',
        '4 p.m.',
        '4 a.m.',
        'Midnight',
        'Saturday morning',
        'The first sentence explicitly states 4 p.m. Friday.'
      ],
      [
        '$_notice\n\nWhich option serves borrowers without internet?',
        'Ask the service desk before closing',
        'Use only the portal after closing',
        'Wait until every book is overdue',
        'Contact an unnamed seller',
        'The notice includes a non-internet alternative.'
      ],
      [
        'What is feedback in a communication process?',
        'A response that helps check understanding',
        'Only the original sender\'s message',
        'A broken microphone',
        'An unrelated poster color',
        'Feedback returns information about receipt or interpretation.'
      ],
      [
        'What is semantic noise?',
        'An unfamiliar term that obstructs understanding',
        'Only a loud engine',
        'Only a lost internet cable',
        'Only a dark room',
        'Semantic noise concerns meaning rather than physical sound alone.'
      ],
      [
        'Which deadline is clearest?',
        'Before 4 p.m. on Friday',
        'Soon',
        'Later',
        'Whenever possible without a date',
        'A specific day and time guide action.'
      ],
      [
        'Which practice supports intercultural communication?',
        'Clarify meaning respectfully instead of relying on stereotypes',
        'Assume accent determines intelligence',
        'Dismiss unfamiliar expressions without asking',
        'Use insults to demand agreement',
        'Clarification and respect reduce misunderstanding.'
      ],
      [
        'Which is ethical source use?',
        'Acknowledge borrowed information and represent it accurately',
        'Invent a supporting quotation',
        'Hide the source to appear original',
        'Change findings to suit a claim',
        'Attribution and accurate representation support trust.'
      ],
      [
        '$_notice\n\nWhen do normal hours resume?',
        'Saturday',
        'Friday at noon',
        'Monday only',
        'Never',
        'The final sentence states Saturday.'
      ],
      [
        'Which revision best replaces "Do it online soon"?',
        'Renew books through the portal before 4 p.m. Friday',
        'Deal with things sometime',
        'Click anything',
        'Ignore the message',
        'The revision specifies action, channel, and deadline.'
      ],
      [
        'What would best check whether a notice is understood?',
        'Ask readers to describe the required action in their own words',
        'Count only the printed copies',
        'Assume sending guarantees understanding',
        'Remove every contact option',
        'A comprehension check tests interpretation rather than delivery alone.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Critical Reading and Evidence-Based Listening',
    objectives: [
      'Distinguish a source\'s claim, evidence, and limitation.',
      'Separate what a report states from unsupported inference.',
      'Summarize quantitative evidence accurately for an audience.',
    ],
    explanation:
        'Critical reading and listening involve identifying a claim, asking what evidence supports it, '
        'and checking the limits of that evidence. Listen or read for qualifiers such as "in one class," '
        '"may," and "before recommending." A preference survey does not automatically measure learning '
        'performance. A faithful summary preserves the population, result, and qualification rather than '
        'selecting an impressive number in isolation. During a talk, record the speaker\'s claim separately '
        'from your response; ask focused questions rather than attributing words the speaker did not use. '
        'Use the following original report for practice:\n\n$_study',
    model: {
      'Claim actually supported':
          '48 of 80 respondents preferred printed notes.',
      'Qualification': 'One class, voluntary participation; preference only.',
      'Claim not established':
          'Printed notes improve every student\'s test score.',
    },
    worked: 'Evaluate "The survey proves paper improves grades." '
        '1. Identify the measured variable: preference. 2. Identify the sample: volunteers from one class. '
        '3. Note that grades were not measured. 4. Revise: "In this survey, 60% preferred printed notes; '
        'the result does not establish a performance effect."',
    guided:
        'Write a one-sentence summary including the result and an important limit. Then suggest one clarification question.',
    solution:
        'In a voluntary survey of 80 students from one class, 48 preferred printed notes, but the result does not establish learning performance or represent the entire campus. A useful question is: How were respondents recruited?',
    mistake:
        'Do not replace "preferred" with "performed better," omit the sample limits, or equate repetition of a claim with independent evidence.',
    recap:
        'Identify what was measured, whom it describes, and what cannot responsibly be concluded.',
    questions: [
      [
        '$_study\n\nWhat was measured?',
        'Reported preference for notes',
        'A controlled change in exam scores',
        'Every university student\'s income',
        'Printer electricity consumption',
        'The report explicitly concerns preference.'
      ],
      [
        '$_study\n\nHow many respondents preferred printed notes?',
        '48',
        '80',
        '32',
        '60',
        'The report states 48 of 80.'
      ],
      [
        '$_study\n\nWhat percentage preferred printed notes?',
        '60%',
        '48%',
        '80%',
        '32%',
        '48/80 x 100 = 60%.'
      ],
      [
        '$_study\n\nWhat limits campus-wide generalization?',
        'The survey used volunteers from one class',
        'The report has sentences',
        'The number 80 is even',
        'The title uses English',
        'The sampling process may exclude different student experiences.'
      ],
      [
        '$_study\n\nWhich claim is unsupported?',
        'Printed notes improve every student\'s grades',
        '48 respondents preferred printed notes',
        'Participation was voluntary',
        'The authors suggest surveying more classes',
        'No grade or performance effect was measured.'
      ],
      [
        'During a talk, which note-taking method supports accuracy?',
        'Separate the speaker\'s claim from your interpretation',
        'Write your opinion as a direct quotation',
        'Ignore all qualifiers',
        'Record only applause',
        'Distinguishing source content from response prevents misattribution.'
      ],
      [
        'Which is a focused clarification question for the practice report?',
        'How were survey volunteers recruited?',
        'Why is every student identical?',
        'Can you guarantee all paper is perfect?',
        'What color is your pen?',
        'Recruitment affects interpretation of the sample.'
      ],
      [
        'What is the role of a qualifier such as "in one class"?',
        'It limits the scope of the claim',
        'It proves every campus agrees',
        'It removes the need for evidence',
        'It changes preference into test scores',
        'Qualifiers define the population or conditions.'
      ],
      [
        '$_study\n\nWhich summary is most accurate?',
        'Most respondents in one class preferred print; broader research is needed',
        'All students learn only from paper',
        'The report banned digital notes',
        'Printed notes doubled exam scores',
        'The summary preserves both finding and limitation.'
      ],
      [
        'Does a claim become independently verified when the same report is reposted many times?',
        'No',
        'Yes, automatically',
        'Only after ten shares',
        'Only if a headline is capitalized',
        'Repeated distribution is not new independent evidence.'
      ],
      [
        '$_study\n\nWhat comparison would address learning performance more directly?',
        'A suitable study measuring learning outcomes under specified conditions',
        'Only another preference slogan',
        'Only counting reposts',
        'Changing preferred to proven',
        'Performance requires actual outcome measurements and an appropriate design.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Academic Summary, Paraphrase, and Attribution',
    objectives: [
      'Distinguish summary, paraphrase, and direct quotation.',
      'Integrate a source without changing its meaning.',
      'Use attribution and verifiable references to avoid plagiarism.',
    ],
    explanation:
        'A summary condenses the main ideas of a longer source. A paraphrase expresses a particular idea '
        'in substantially new wording and sentence structure while preserving meaning. A direct quotation '
        'reproduces exact words and marks them as quoted. All three require source acknowledgment when '
        'the idea or wording is borrowed. Replacing a few words with synonyms is not a sufficient paraphrase. '
        'Record the author or organization, date, title, and location needed by the required citation style. '
        'Never invent authors, page numbers, quotations, or study results. When a practice passage has no '
        'external author, label it as a classroom passage rather than fabricating a journal. '
        'Use this original classroom passage:\n\n$_study',
    model: {
      'Summary':
          'A limited class survey favored printed notes but did not measure performance.',
      'Paraphrase':
          'Of the 80 volunteers, 48 said they would rather use printed notes.',
      'Attribution':
          'Identify the practice report; do not invent a real journal citation.',
    },
    worked:
        'Paraphrase "The report describes preference, not test performance." '
        '1. Understand the distinction. 2. Set the sentence aside. '
        '3. Write: "The survey concerns which format respondents liked, not how well they scored." '
        '4. Compare meanings and attribute the practice report.',
    guided:
        'Paraphrase the recommendation to survey more classes before changing services. Keep its cautious meaning.',
    solution:
        'The practice report advises gathering responses from additional classes before making campus-wide service changes. This retains the recommendation without claiming that a change has already been justified.',
    mistake:
        'Do not remove qualifications, copy sentence structure with only synonym swaps, or assume paraphrased borrowed ideas need no attribution.',
    recap:
        'Understand first, rewrite independently, preserve the claim\'s limits, and credit the real source.',
    questions: [
      [
        'What does a summary normally do?',
        'Condenses a source\'s main ideas',
        'Copies every sentence verbatim',
        'Invents a stronger result',
        'Hides all source limitations',
        'Summary selects central ideas while preserving meaning.'
      ],
      [
        'What distinguishes a direct quotation?',
        'It reproduces exact wording and marks it as quoted',
        'It never needs attribution',
        'It always changes every word',
        'It invents page numbers',
        'Readers must be able to distinguish exact borrowed words.'
      ],
      [
        'Does a paraphrase of a borrowed idea need attribution?',
        'Yes',
        'No, never',
        'Only if printed',
        'Only if it contains numbers',
        'Borrowed ideas require acknowledgment even with new wording.'
      ],
      [
        'Which is an inadequate paraphrase technique?',
        'Changing a few words while keeping the source structure',
        'Understanding the idea first',
        'Writing from understanding',
        'Checking that meaning is preserved',
        'Synonym swapping can remain too close to the source.'
      ],
      [
        '$_study\n\nWhich paraphrase preserves the measured variable?',
        'Respondents reported which note format they liked',
        'Respondents proved paper raised grades',
        'The report measured every student\'s intelligence',
        'The study recorded printer speed',
        'Preference concerns liking, not performance or unrelated outcomes.'
      ],
      [
        'What should a student do if a source page number is unknown?',
        'Locate it when required rather than inventing one',
        'Guess a plausible number',
        'Use the current year as a page',
        'Copy a number from another source',
        'Citation details must be genuine and verifiable.'
      ],
      [
        '$_study\n\nWhich summary retains a key limit?',
        'A voluntary one-class survey favored print among its respondents',
        'All students everywhere need paper',
        'Digital notes never work',
        'Every respondent chose print',
        'It preserves both finding and scope.'
      ],
      [
        'How should this original classroom passage be identified?',
        'As the practice report provided in the lesson',
        'As a fabricated international journal article',
        'As a quotation from an invented professor',
        'As a national census without evidence',
        'A source should be described truthfully.'
      ],
      [
        'Which action is plagiarism?',
        'Presenting another person\'s work as your own without acknowledgment',
        'Quoting with proper attribution',
        'Summarizing and crediting the source',
        'Citing a real verified source',
        'Plagiarism misrepresents authorship or source use.'
      ],
      [
        'What is a useful final paraphrase check?',
        'Compare accuracy and wording with the source',
        'Remove all attribution',
        'Make the result more dramatic',
        'Delete every limitation',
        'A paraphrase must be both meaning-preserving and independently worded.'
      ],
      [
        '$_study\n\nWhich recommendation is faithful?',
        'Gather evidence from more classes before campus-wide changes',
        'Immediately prohibit all digital notes',
        'Stop all research permanently',
        'Treat the class as the entire country',
        'The report recommends broader evidence before policy changes.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Professional Correspondence and Collaborative Work',
    objectives: [
      'Write a concise message with a clear request and relevant context.',
      'Adapt tone and organization for a professional audience.',
      'Record meeting decisions with actions, owners, and deadlines.',
    ],
    explanation:
        'Professional correspondence helps people act on reliable information. A useful email has a meaningful '
        'subject, an appropriate greeting, concise context, a specific request, and a courteous closing. '
        'Respectful language need not be vague or excessively long. Include dates and times, but disclose only '
        'personal details necessary for the purpose. Collaboration also requires clear records: minutes '
        'summarize decisions and responsibilities rather than every spoken word. An action item should say '
        'what will be done, by whom, and by when. Application documents should describe genuine skills and '
        'experience; inventing a credential is not persuasive professional communication. '
        'Read this original example:\n\n$_email',
    model: {
      'Subject': 'Request to reschedule consultation on 12 August.',
      'Request and alternative':
          'Move 2 p.m. to 3 p.m., or use another available office hour.',
      'Action record':
          'Mika will confirm the agreed time with the group after the professor replies.',
    },
    worked: 'Improve "Can we move it? We are busy." '
        '1. Name the event and date. 2. Briefly explain the schedule conflict. '
        '3. Suggest a specific alternative without assuming approval. '
        '4. Ask for confirmation and close respectfully.',
    guided:
        'A group agrees that Ben will send the draft to Ana by 5 p.m. on Thursday. Write one action item for the minutes.',
    solution:
        'Ben: Send the draft to Ana by 5 p.m. Thursday. This records the owner, action, recipient, and deadline.',
    mistake:
        'Do not treat a request as approval, omit the date, bury the action under unrelated personal details, or invent qualifications in an application.',
    recap:
        'State context, action, owner, and time; use an audience-appropriate tone and accurate information.',
    questions: [
      [
        '$_email\n\nWhat is the main request?',
        'Move the consultation to 3 p.m. or another suitable office hour',
        'Cancel the degree program',
        'Request a final grade change',
        'Reserve a library book',
        'The message asks to reschedule a consultation.'
      ],
      [
        '$_email\n\nWhy does the group request a change?',
        'A required laboratory session conflicts with the original time',
        'The professor already canceled every class',
        'The library closed permanently',
        'The group has no coursework',
        'The message states a laboratory conflict.'
      ],
      [
        '$_email\n\nHas the professor approved 3 p.m. in this message?',
        'No; the group is requesting approval',
        'Yes, explicitly',
        'Yes, because the subject names a date',
        'Approval is unnecessary in every situation',
        'A request does not establish agreement.'
      ],
      [
        'Which subject line is most informative?',
        'Request to reschedule consultation on 12 August',
        'Hello',
        'Important things',
        'Read now!!!',
        'It identifies the action and event date.'
      ],
      [
        'What belongs in an actionable meeting record?',
        'Task, responsible person, and deadline',
        'Only a list of jokes',
        'Every unrelated comment',
        'Only the room color',
        'An action record supports follow-through.'
      ],
      [
        'Which is the clearest action item?',
        'Ben: Send the draft to Ana by 5 p.m. Thursday',
        'Someone should do it soon',
        'Draft stuff',
        'Things will happen',
        'It specifies owner, task, recipient, and time.'
      ],
      [
        'What should an application document claim?',
        'Genuine relevant skills and experience',
        'Invented degrees',
        'Unverified awards as facts',
        'Another person\'s work as your own',
        'Professional persuasion must remain truthful.'
      ],
      [
        'Which tone is appropriately professional?',
        'Clear, respectful, and specific',
        'Threatening without reason',
        'Deliberately ambiguous',
        'Insulting unfamiliar readers',
        'Clarity and respect support cooperation.'
      ],
      [
        '$_email\n\nWho sends the example email?',
        'Mika Cruz, Group 2',
        'Professor Santos',
        'The library vendor',
        'An unnamed dean',
        'The closing identifies the sender.'
      ],
      [
        'Why limit unrelated personal details in a work email?',
        'They can distract and disclose unnecessary private information',
        'Every detail must always be public',
        'Privacy never matters in email',
        'More unrelated detail always improves clarity',
        'Include information relevant to the professional purpose.'
      ],
      [
        'After a consultation change is approved, what is a useful next step?',
        'Confirm the agreed date and time with all affected group members',
        'Assume nobody needs the update',
        'Delete the only record immediately',
        'Announce an unapproved different time',
        'Shared confirmation prevents coordination errors.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Evidence-Based Presentations and Multimodal Messages',
    objectives: [
      'Organize a presentation around a claim, evidence, and action.',
      'Use visuals that clarify rather than distort information.',
      'Provide accessible spoken and visual explanations.',
    ],
    explanation:
        'A purposeful presentation connects a claim to evidence and a realistic action. State the problem, '
        'explain the relevant evidence and its limits, consider alternatives, then give a concrete recommendation. '
        'Multimodal communication combines words, images, sound, or movement. Each mode should help the audience '
        'understand the same message rather than compete for attention. Label graphs, show fair scales, '
        'describe important visuals aloud, provide captions for video, and avoid using color as the only '
        'signal. Rehearsal should test timing and comprehension, not only memorization. Read the proposal:\n\n$_proposal',
    model: {
      'Problem and evidence':
          '120 bottles were counted in selected bins during one week.',
      'Recommendation':
          'Test two accessible refill stations in a four-week pilot.',
      'Evaluation':
          'Track use, costs, bottle counts, and water quality rather than promise guaranteed success.',
    },
    worked: 'Build a three-part presentation from the proposal. '
        '1. Open with the local bottle-count problem. 2. Explain the limited audit and pilot plan using '
        'a labeled count chart. 3. Request approval for the pilot and a review date. '
        'Describe the chart aloud and retain the audit limitation.',
    guided:
        'Write a slide title that states the evidence without exaggeration, then give one accessibility improvement.',
    solution:
        'Title: "120 disposable bottles counted in selected bins during one week." Add a clear text description of the graph and do not rely only on red and green bars.',
    mistake:
        'Do not turn a local bin count into a campus-wide yearly claim, use an unlabeled truncated scale, or place essential information only in an image.',
    recap:
        'Unify claim, evidence, visual design, accessibility, and a feasible request.',
    questions: [
      [
        '$_proposal\n\nWhat does the audit count establish?',
        '120 bottles were recorded in the selected bins during one week',
        'Every campus bin contains exactly 120 bottles daily',
        'Refill stations already eliminated all waste',
        'All students oppose drinking water',
        'The evidence has a specific place and time scope.'
      ],
      [
        '$_proposal\n\nHow long is the proposed pilot?',
        'Four weeks',
        'One day',
        'One year',
        'Ten years',
        'The proposal explicitly specifies four weeks.'
      ],
      [
        'Which presentation structure is most coherent?',
        'Problem, evidence and limits, recommendation',
        'Unrelated images followed by a hidden request',
        'Only a conclusion with no support',
        'Only background music',
        'A logical sequence connects the reason to the proposed action.'
      ],
      [
        'Which helps a listener who cannot see a graph?',
        'Describe the important data aloud',
        'Say only "as you can see"',
        'Remove all labels',
        'Use color without text',
        'Spoken description makes visual evidence accessible.'
      ],
      [
        'What should a graph include?',
        'Labeled variables, units, and a non-misleading scale',
        'Only decorative effects',
        'No source or context',
        'A hidden axis',
        'Readers need a fair representation of the data.'
      ],
      [
        'Why are video captions useful?',
        'They support access when audio cannot be heard or understood',
        'They prove every claim is true',
        'They replace all source checking',
        'They make context unnecessary',
        'Captions improve access to spoken information.'
      ],
      [
        '$_proposal\n\nWhich condition is required before station use?',
        'Check water quality',
        'Skip maintenance planning',
        'Assume any water is safe',
        'Ignore accessibility',
        'The proposal explicitly requires water-quality checks.'
      ],
      [
        'Which slide title is most accurate?',
        '120 bottles counted in selected bins in one week',
        'Our campus wastes exactly 120 bottles every day forever',
        'Pilot already proves success',
        'All waste has ended',
        'The title retains the measured scope.'
      ],
      [
        'Why should a presenter rehearse with a listener?',
        'To check timing, clarity, and comprehension',
        'To avoid all questions permanently',
        'To replace evidence with confidence',
        'To guarantee unanimous agreement',
        'A listener can reveal confusing transitions or explanations.'
      ],
      [
        '$_proposal\n\nWhich is an appropriate final request?',
        'Approve a monitored four-week pilot and review its results',
        'Declare permanent success without testing',
        'Stop checking water quality',
        'Remove all maintenance funding',
        'The recommendation matches the proposed evidence-gathering plan.'
      ],
      [
        'What does multimodal coherence mean?',
        'Words and visuals support the same purposeful message',
        'Every slide has unrelated animation',
        'Sound contradicts every chart',
        'Decorations replace explanations',
        'Modes should work together to improve understanding.'
      ],
    ],
  ),
  StandardsLesson(
    title: 'Research Communication and Responsible Advocacy',
    objectives: [
      'Formulate a focused question and proportionate recommendation.',
      'Integrate evidence, counterarguments, and uncertainty.',
      'Plan an ethical evaluation with measurable outcomes.',
    ],
    explanation:
        'Research communication helps an audience judge a question, evidence, and recommended action. '
        'A focused question specifies the setting, issue, and outcome; a broad slogan does not. '
        'An advocacy message can support change while remaining honest about uncertainty. Distinguish '
        'a current finding from a prediction, and a proposed pilot from a proven intervention. '
        'Address strong counterarguments such as cost, access, and maintenance rather than attacking people '
        'who disagree. Collect only necessary data, obtain appropriate permission, and protect participants. '
        'An evaluation should define what success would look like before results are known. '
        'Use this original case:\n\n$_proposal',
    model: {
      'Focused question':
          'Does the four-week pilot reduce bottle counts in the same selected bins?',
      'Counterargument': 'Maintenance may cost more than expected.',
      'Evaluation response':
          'Record costs and use alongside comparable bottle counts, and report limitations.',
    },
    worked: 'Revise "Refill stations will solve all waste." '
        '1. Narrow the claim to the selected location and pilot period. '
        '2. State the current evidence and its limited scope. '
        '3. Add cost, access, and water-quality criteria. '
        '4. Recommend a monitored trial, not an unmeasured guarantee.',
    guided:
        'Write a focused evaluation question and one counterargument for the refill-station proposal.',
    solution:
        'Question: Over four weeks, how do bottle counts in the selected bins change compared with a comparable baseline? Counterargument: Maintenance and water-testing costs may be substantial. Record those costs rather than dismissing the concern.',
    mistake:
        'Do not cherry-pick only favorable data, attack critics instead of their reasoning, or claim a before-and-after change proves causation without considering other factors.',
    recap:
        'Advocate with a focused question, honest evidence, fair counterarguments, and a measurable evaluation plan.',
    questions: [
      [
        'Which is a focused research question for the case?',
        'How do bottle counts in the selected bins change during the four-week pilot?',
        'Is everything good?',
        'Why is all technology perfect?',
        'Can one station solve every environmental problem?',
        'It specifies an outcome, place, and period.'
      ],
      [
        '$_proposal\n\nWhich outcome should be measured?',
        'Refill use, costs, and comparable bottle counts',
        'Only the poster color',
        'Only the number of slogans',
        'Only the presenter\'s confidence',
        'The proposal names relevant practical outcomes.'
      ],
      [
        'Which is a fair counterargument?',
        'Maintenance costs may be higher than expected',
        'Everyone who disagrees is foolish',
        'Evidence should be banned',
        'Water quality can never matter',
        'A cost concern addresses the proposal rather than attacking people.'
      ],
      [
        'What is cherry-picking?',
        'Selecting favorable evidence while hiding relevant contrary evidence',
        'Reporting all relevant findings',
        'Stating limitations',
        'Checking a source',
        'Cherry-picking distorts the overall evidential picture.'
      ],
      [
        'Which recommendation is proportionate to the available evidence?',
        'Run and evaluate a limited pilot',
        'Declare universal success immediately',
        'Guarantee zero waste nationwide',
        'Claim the audit measured every school',
        'A small local audit supports investigation, not sweeping certainty.'
      ],
      [
        'Why define success criteria before collecting results?',
        'To reduce selective reinterpretation after seeing the data',
        'To guarantee a favorable result',
        'To avoid measuring anything',
        'To suppress unexpected findings',
        'Predefined outcomes support transparent evaluation.'
      ],
      [
        'Which practice protects research participants?',
        'Collect only necessary information with appropriate permissions',
        'Publish names without need',
        'Hide the data purpose',
        'Demand unrelated private records',
        'Ethical data use limits collection and protects privacy.'
      ],
      [
        'Does a simple before-and-after decrease prove the station alone caused it?',
        'No; other changes may contribute',
        'Yes, always',
        'Only if the chart is colorful',
        'Only if no limitations are reported',
        'Timing alone does not rule out alternative explanations.'
      ],
      [
        '$_proposal\n\nWhich evidence limitation should be disclosed?',
        'The baseline audit covered selected bins for one week',
        'The audit covered the entire country',
        'The pilot already lasted decades',
        'Every cost is known with certainty',
        'The original evidence has a limited sampling frame and duration.'
      ],
      [
        'Which response best addresses a critic asking about access?',
        'Explain the accessibility plan and invite practical feedback',
        'Insult the critic',
        'Remove the access requirement',
        'Claim criticism proves failure',
        'Evidence-based advocacy engages relevant concerns.'
      ],
      [
        'What should a final evaluation report include?',
        'Methods, results, limitations, and a justified next step',
        'Only positive slogans',
        'Only names of supporters',
        'Fabricated improvement percentages',
        'A responsible report allows readers to judge the evidence.'
      ],
    ],
  ),
];
