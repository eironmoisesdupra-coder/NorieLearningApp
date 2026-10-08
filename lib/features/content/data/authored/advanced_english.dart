import '../../domain/norie_content_models.dart';
import 'authored_lesson_visual.dart';
import 'subject_lesson_builder.dart';

const advancedEnglishVisuals = <String, AuthoredLessonVisual>{
  'english-g11-authored': AuthoredLessonVisual(
      title: 'Move from technique to audience effect',
      labels: [
        'Text: “Will we leave the doors closed?”',
        'Technique: rhetorical question',
        'Audience: school council considering a library budget',
        'Possible effect: makes inaction feel like a choice requiring defense'
      ],
      details: [
        'The question invites reflection rather than a factual one-word answer.',
        'Name the technique from actual language.',
        'Identify who is being addressed in the invented speech.',
        'Explain the likely effect in this context rather than simply listing devices.'
      ],
      note:
          'An intended persuasive effect is not proof that every listener was persuaded.',
      ordered: true),
  'english-g12-authored': AuthoredLessonVisual(
      title: 'Compare claims before synthesizing',
      labels: [
        'Source A: 60% of 20 volunteers favor the change',
        'Source B: 40% of 200 randomly selected pupils favor it',
        'Synthesis: findings differ, and sampling affects what each can establish'
      ],
      details: [
        'Volunteer participation may select unusually interested respondents.',
        'Random selection can improve representativeness, subject to response and method limits.',
        'Report both findings and assess their scope instead of averaging percentages blindly.'
      ],
      note:
          'Both sources are invented for the lesson. Raw percentages do not establish causation or interchangeable samples.'),
  'english-college-authored': AuthoredLessonVisual(
      title: 'Valid and invalid conditional patterns',
      labels: [
        'Modus ponens: P → Q; P; therefore Q',
        'Modus tollens: P → Q; not Q; therefore not P',
        'Affirming the consequent: P → Q; Q; therefore P'
      ],
      details: [
        'If the premises hold, the conclusion must hold.',
        'The missing consequence rules out the sufficient condition.',
        'This is invalid: Q may have another sufficient cause.'
      ],
      note:
          'Validity concerns the logical link; soundness also requires true premises.'),
};

final advancedEnglish = <String, NorieTopicContent>{
  'g11': subjectLesson(
      subject: 'English',
      grade: 'g11',
      title: 'Rhetorical Analysis in Context',
      prerequisite: 'english.g11.research-paper-structure',
      objectives: [
        'Identify purpose, audience, and context in a persuasive passage.',
        'Connect a rhetorical technique with specific wording.',
        'Explain an intended effect without claiming guaranteed persuasion.'
      ],
      introduction:
          'Rhetorical analysis explains how language works for an audience and purpose. Naming a device is only the beginning; the analysis must connect the chosen words to the situation.',
      explanation:
          'Use this invented school-council speech: Our library recorded eighty requests for evening access this term. As the librarian who logs those requests, I have seen pupils leave disappointed. Will we leave the doors closed? Let us trial one evening opening and publish the cost. The purpose is to persuade the council to approve a limited trial. The request count offers a logical appeal if the record is credible. The librarian role establishes relevant experience, an ethical appeal. Disappointed pupils and the question can invite an emotional or value-based response.',
      application:
          'Ethos concerns credibility, logos reasoning and evidence, and pathos an appeal to feelings or values. One sentence can serve more than one function. A rhetorical question often invites reflection rather than a literal answer; its effect depends on audience and context. Analyze the specific council decision, not an abstract reader everywhere. Do not claim that emotion makes an argument invalid automatically or that numbers make it sound automatically. Examine relevance, accuracy, and the link from evidence to proposal. The invented number is passage content, not a measured fact about a real school.',
      worked:
          'Analyze Will we leave the doors closed? Step 1: identify the rhetorical question. Step 2: note the inclusive we, which assigns shared responsibility to the council. Step 3: explain that closed frames continuing lack of access as a choice. Step 4: connect the effect to the requested trial. Step 5: qualify: the speech may prompt reflection, but no listener response is reported.',
      guided:
          'Analyze the phrase trial one evening opening and publish the cost. What concern does this wording address? Explain the effect of trial and publish without merely labeling them persuasive words.',
      solution:
          'Trial limits the initial commitment, addressing feasibility concerns. Publish the cost promises accountability and information for review. Both can make a cautious council more willing to consider the proposal, but success is not guaranteed.',
      mistakes:
          'A device list without explanation is not analysis. Do not invent an audience outside the passage. Credibility is relevant experience, not proof of every claim. Distinguish the speaker intended effect from a documented audience reaction.',
      recap:
          'Identify the rhetorical situation, select exact language, name a relevant technique, and explain how it may serve the purpose for this audience. Evaluate evidence and qualify claims about persuasive effects.',
      visual: advancedEnglishVisuals['english-g11-authored']!,
      questions: [
        'Invented speech to a school council: Our library recorded eighty requests for evening access this term. As the librarian who logs those requests, I have seen pupils leave disappointed. Will we leave the doors closed? Let us trial one evening opening and publish the cost. Who is the audience in the invented speech?|The school council|Every voter in the country|Only kindergarten pupils|An unnamed court|The passage explicitly frames a school-council budget decision.|Rhetorical situation',
        'Invented speech to a school council: Our library recorded eighty requests for evening access this term. As the librarian who logs those requests, I have seen pupils leave disappointed. Will we leave the doors closed? Let us trial one evening opening and publish the cost. What is the speech main purpose?|Persuade the council to trial evening opening|Prove all libraries are identical|Describe unrelated history|Ban all library use|The final proposal asks the council to approve a limited opening trial.|Purpose',
        'The librarian role most directly contributes to which appeal?|Ethos|Only rhyme|Only irony|No credibility context|Relevant firsthand experience can establish credibility for the speaker.|Appeals',
        'The recorded request count most directly supplies which kind of support?|Logos, if the record is credible|A guaranteed emotional response|A fictional listener reaction|A rhyme pattern|Numerical evidence can support reasoning, but its reliability still matters.|Appeals',
        'Will we leave the doors closed is primarily what device?|Rhetorical question|A factual report of listener votes|A direct quotation of a law|A mathematical formula|The question invites reflection about inaction rather than a simple data response.|Technique',
        'In a speech to a school council, what does the inclusive we do in Will we leave the doors closed?|Frames responsibility as shared|Proves all listeners agree|Removes the audience|Makes the budget free|We places speaker and council within a shared decision frame.|Audience effect',
        'A speaker proposes Let us trial one evening opening before deciding whether to extend library hours permanently. Why does trial matter in this proposal?|It limits initial commitment|It guarantees permanent success|It proves no costs exist|It changes a speech into a poem|A limited trial can address uncertainty and feasibility concerns.|Word choice',
        'Invented speech to a school council: Our library recorded eighty requests for evening access this term. As the librarian who logs those requests, I have seen pupils leave disappointed. Will we leave the doors closed? Let us trial one evening opening and publish the cost. Which claim about audience reaction is justified by the text alone?|The wording may encourage reflection|Every listener voted yes|Nobody objected|All listeners felt identical emotions|The passage supports an intended effect but reports no actual reaction.|Evidence limits',
        'Why is a list of ethos, logos, pathos insufficient analysis?|It lacks textual links and explained effects|Those terms are never useful|Analysis must avoid quotations|Only one device may exist|Analysis must show how particular wording functions in the specific situation.|Analysis',
        'Publish the cost mainly addresses what concern?|Accountability and review of expense|Guaranteed zero cost|Proof no staff are needed|The color of shelves|Publishing costs promises information to evaluate feasibility.|Word choice',
        'Can numerical evidence make any argument sound automatically?|No, relevance and accuracy still need examination|Yes, every number proves a claim|Only if it is large|Only if the speaker is famous|Numbers require trustworthy measurement and a valid reasoning link.|Evidence evaluation',
      ]),
  'g12': subjectLesson(
      subject: 'English',
      grade: 'g12',
      title: 'Synthesizing Sources that Differ',
      prerequisite: 'english.g12.oral-communication',
      objectives: [
        'Identify agreements and conflicts across source claims.',
        'Compare methods and scope before combining findings.',
        'Write a qualified synthesis with separate attribution.'
      ],
      introduction:
          'Synthesis puts sources into conversation around a question. When findings differ, the writer should examine what each measured and how, rather than hide the disagreement or average incompatible claims.',
      explanation:
          'Use two invented sources about a proposed school timetable. Source A reports that sixty percent of twenty volunteer respondents favor it. Source B reports that forty percent of two hundred randomly selected pupils favor it. Both concern preference, and their reported percentages differ. The samples and selection methods also differ. Volunteer responses may overrepresent strongly interested pupils. Random selection can improve representativeness but still needs response-rate and question checks. Neither source proves that changing the timetable improves learning, because stated preference is not the same outcome as learning progress.',
      application:
          'A synthesis could say: The two surveys report different levels of support, but their sampling methods limit direct comparison. A volunteer group in A shows majority support, whereas B reports less than half among its selected pupils. This preserves disagreement and attributes each claim. Do not average sixty and forty to announce fifty percent school-wide support: the sample sizes differ, and combining the samples may not be justified at all. Source agreement can also rest on shared data rather than independent evidence. Evaluate independence, dates, definitions, and scope.',
      worked:
          'Invented Source C says the pilot reduced late arrivals in one class; Source D says whole-school late arrivals stayed stable during the same month. Step 1: identify the different populations, one class and the whole school. Step 2: note both can be true if other classes offset the change. Step 3: synthesize: one class improved, while the broader total did not. Step 4: avoid declaring one source false solely because their scopes differ.',
      guided:
          'Write a two-sentence synthesis of A and B that reports their disagreement, names a method difference, and does not claim a causal learning benefit. Explain why a simple fifty-percent average is inadequate.',
      solution:
          'A reports sixty-percent support among twenty volunteers, while B reports forty percent among two hundred randomly selected pupils. Different sample sizes and selection methods limit direct comparison. An unweighted average ignores both unequal sizes and whether combining samples is valid.',
      mistakes:
          'Do not replace disagreement with a false consensus. Separate who said what and keep populations clear. Preference is not evidence of learning causation. A larger sample alone does not repair a biased question or incomplete response.',
      recap:
          'Synthesize around a question, preserve each source claim and attribution, and compare methods and scope. Explain differences where possible, qualify conclusions, and avoid combining data without justification.',
      visual: advancedEnglishVisuals['english-g12-authored']!,
      questions: [
        'Invented sources about timetable preference: A reports 60% support among 20 volunteer respondents; B reports 40% support among 200 randomly selected pupils. What do invented Sources A and B both measure?|Reported timetable preference|Proven learning improvement|Every pupil exact age|Classroom temperature|Their described surveys concern favoring a timetable proposal.|Claim scope',
        'Invented sources about timetable preference: A reports 60% support among 20 volunteer respondents; B reports 40% support among 200 randomly selected pupils. What methodological difference is stated?|Volunteers versus randomly selected pupils|Both use identical selection|Only paper color differs|Neither names any population|The sources use different respondent selection methods.|Method comparison',
        'Invented sources about timetable preference: A reports 60% support among 20 volunteer respondents; B reports 40% support among 200 randomly selected pupils. Why is a simple average of 60% and 40% inadequate?|Sample sizes and selection methods differ|Percentages can never be compared|Both numbers are equal|All surveys prove causation|Combining them needs a justified model and cannot ignore unequal samples.|Data synthesis',
        'Invented sources about timetable preference: A reports 60% support among 20 volunteer respondents; B reports 40% support among 200 randomly selected pupils. Which sentence preserves source disagreement?|A reports 60% support; B reports 40%.|Both prove unanimous support.|Neither reports a percentage.|All pupils favor the change.|Separate attribution accurately retains the distinct findings.|Attribution',
        'Do preference surveys establish that a timetable causes learning gains?|No|Yes, automatically|Only if support exceeds half|Only if a sample is large|A preference measure is not a causal measure of learning outcomes.|Causal limits',
        'One class improves while a school total stays stable. Can both be true?|Yes, other classes may offset the change|No, scope never matters|Only if one percentage is zero|No, every class must match the school|Different populations can yield compatible but different summaries.|Scope',
        'What is synthesis more than?|A sequence of unrelated source summaries|Comparing claims around a question|Explaining method differences|Preserving attribution|Synthesis connects sources through agreements, differences, and a shared question.|Organization',
        'Does a larger sample alone fix a biased question?|No|Yes, always|Only if the sample is 200|Only if the result is popular|Question wording and response bias can remain regardless of sample size.|Method limits',
        'Invented sources about timetable preference: A reports 60% support among 20 volunteer respondents; B reports 40% support among 200 randomly selected pupils. Which is a qualified synthesis of A and B?|Their support estimates differ, and selection methods limit comparison.|Both prove the timetable works.|The school support is exactly 50% without qualification.|A must be false because it has fewer responses.|The statement reports the conflict and a relevant comparison limitation.|Qualified synthesis',
        'Why can repeated reports of shared data fail as independent agreement?|They rely on one underlying evidence source|Agreement is never relevant|All summaries are false|Dates cannot be compared|Several reports can repeat the same data without providing independent confirmation.|Independence',
        'C reports one-class improvement; D reports stable school totals. Best synthesis?|A local improvement coexisted with a stable broader total.|Both describe the identical population with opposite exact results.|C proves every class improved.|D proves no class could improve.|The synthesis keeps the different scopes and allows both findings to hold.|Scope',
      ]),
  'college': subjectLesson(
      subject: 'English',
      grade: 'college',
      title: 'Testing Argument Validity',
      prerequisite: 'english.college.professional-communication',
      objectives: [
        'Distinguish deductive validity from premise truth.',
        'Recognize valid conditional forms and common invalid forms.',
        'Construct a counterexample to an invalid inference.'
      ],
      introduction:
          'Critical argument analysis asks whether a conclusion follows from its premises. A convincing tone or a true conclusion does not by itself make the reasoning valid.',
      explanation:
          'A deductive argument is valid when it is impossible for all premises to be true and the conclusion false. Soundness requires validity plus true premises. With P meaning a sufficient condition and Q its consequence, modus ponens has form P → Q; P; therefore Q. Modus tollens has form P → Q; not Q; therefore not P. Both are valid. The conditional says P is sufficient for Q, not that P is the only possible way Q can occur. Separate the logical pattern from whether a real-world premise is accurate.',
      application:
          'Affirming the consequent is invalid: P → Q; Q; therefore P. In an invented policy, scholarship recipients have library access. A person has library access, but may have it through ordinary membership, so recipient status does not follow. Denying the antecedent is also invalid: P → Q; not P; therefore not Q. Nonrecipients might still have access. A counterexample assigns premises a possible true situation with a false conclusion. This exposes the logical gap even if the conclusion happens to be true in one case.',
      worked:
          'Invented rule: every debate-team member submitted a form. Premise: Nia is a debate-team member. Conclusion: Nia submitted a form. Step 1: map membership to P and submission to Q. Step 2: recognize P → Q and P. Step 3: conclude Q by modus ponens. The form is valid. Whether the argument is sound also requires checking the rule and Nia membership are true.',
      guided:
          'Rule: if a document is approved, it has a review stamp. A document has a stamp; therefore it is approved. Identify the pattern and construct a counterexample that preserves the stated rule.',
      solution:
          'This affirms the consequent. A document might receive a stamp during review and still be rejected. Approved documents can all have stamps while some stamped documents remain unapproved, so the conclusion need not follow.',
      mistakes:
          'Validity is not the same as a conclusion being true. Do not reverse a sufficient-condition statement into a necessary-only-one statement. A counterexample must keep the premises true while making the conclusion false, rather than simply denying a premise.',
      recap:
          'Test whether true premises could coexist with a false conclusion. Modus ponens and modus tollens are valid; affirming the consequent and denying the antecedent are invalid. Soundness also requires premise truth.',
      visual: advancedEnglishVisuals['english-college-authored']!,
      questions: [
        'A deductively valid argument guarantees what?|True premises cannot lead to a false conclusion|Its premises are automatically true|Its conclusion is always popular|It contains no conditional words|Validity concerns the necessary relation between premises and conclusion.|Validity',
        'What does soundness require?|Validity and true premises|Only a confident tone|Only a true conclusion|Only many examples|A sound deductive argument has a valid form and true premises.|Soundness',
        'P → Q; P; therefore Q is which form?|Modus ponens|Affirming the consequent|Denying the antecedent|An invalid contradiction necessarily|Asserting the sufficient condition supports its stated consequence.|Conditional forms',
        'P → Q; not Q; therefore not P is which form?|Modus tollens|Affirming the consequent|Denying the antecedent|A mere repetition of P|If P would imply Q, the absence of Q rules out P.|Conditional forms',
        'P → Q; Q; therefore P commits what error?|Affirming the consequent|Modus ponens|Modus tollens|Valid elimination of all alternatives|Q may follow from another condition, so Q alone does not establish P.|Invalid forms',
        'P → Q; not P; therefore not Q commits what error?|Denying the antecedent|Modus tollens|Modus ponens|A sound conclusion necessarily|The absence of P does not rule out another way Q can hold.|Invalid forms',
        'What must a counterexample to validity preserve?|True premises with a false conclusion|A false premise only|The writer popularity|Only a different topic|A counterexample demonstrates the premises do not force the conclusion.|Counterexample',
        'Can an invalid argument happen to have a true conclusion?|Yes|No, all conclusions are false|Only if it has no premises|Only if it is sound|A conclusion can be true independently of a flawed reasoning link.|Validity and truth',
        'All team members submitted forms; Nia is a member. What follows?|Nia submitted a form|Only Nia submitted|Everyone submitting joined the team|No nonmember submitted|The membership condition is sufficient for submission under the stated premise.|Modus ponens',
        'Approved documents have stamps; this document has a stamp. What follows necessarily?|Approval is not established by those premises alone|It must be approved|All stamped documents are approved|The rule is impossible|The stamp may also occur on unapproved documents, so reversing the implication fails.|Affirming consequent',
        'How can the stamped-document inference be counterexampled?|A rejected document still carries a review stamp|Deny that approved documents have stamps|Delete the stamp premise|Assume no documents exist without explaining|The rejected stamped document keeps the premises compatible while falsifying approval.|Counterexample',
      ]),
};
