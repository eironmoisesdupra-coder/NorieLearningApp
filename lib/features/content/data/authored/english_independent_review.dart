import '../../domain/norie_content_models.dart';

/// Original self-check tasks for existing lessons; no assessment or reward IDs.
final englishIndependentReview = <String, List<NorieLessonSection>>{
  'g1.3': _review(
    'Read: The dog chases a ball. Point to or say the two naming words. '
        'What does each name? Which word tells what the dog does? '
        'You may draw your answer or ask a helper to read the sentence aloud.',
    'The naming words are dog and ball. Dog names an animal; ball names a thing. '
        'Chases tells the action in this sentence. A complete answer finds both '
        'nouns and tells what each names. If you chose chases, ask yourself: '
        'does this word name something, or tell what it does?',
    'Close the lesson. Tomorrow, read: The girl carries a bag. Find the two '
        'naming words and tell what each names. Then reopen the noun examples '
        'to check. If you are unsure, point to the person and the thing first.',
  ),
  'g7.1': _review(
    'The path was muddy. We continued walking. Combine these ideas to show '
        'contrast, first as a complex sentence and then as a compound sentence. '
        'Underline the independent clauses. Explain why a comma alone cannot '
        'join the two original sentences. Try before opening the reasoning.',
    'One complex answer is: Although the path was muddy, we continued walking. '
        'Although makes the first clause dependent; we continued walking can '
        'stand alone. One compound answer is: The path was muddy, but we '
        'continued walking. But coordinates two independent clauses and shows '
        'contrast. A comma alone would make a comma splice. Other grammatical '
        'combinations are acceptable if they keep both ideas and the contrast. '
        'Using because instead would assert a cause that the task does not give.',
    'Tomorrow, without notes, combine: The gate was locked. We used another '
        'entrance. Show cause with one complex sentence, then choose a separate '
        'short sentence for emphasis. Check the worked example and explain '
        'which clause can stand alone; length alone does not determine type.',
  ),
  'g11.3': _review(
    'Invented Source C is a dated library log: 40 visits in one week and 60 '
        'in the next, counted by the same method. Invented Source D is an '
        'advertisement claiming every pupil learns more, with no learning '
        'measure or sampling method. Which source supports a visit-count '
        'comparison? Can either prove the learning claim? Propose one useful '
        'check and name a limitation before revealing the rubric.',
    'C can support the limited recorded visit-count comparison after checking '
        'the dates and counting method. The increase is 20 recorded visits; '
        'visits are not necessarily distinct pupils. C cannot establish that '
        'every pupil learns more: it measures visits, not learning. D supplies '
        'no method or outcome evidence. Inspect the underlying log and seek '
        'independent corroboration appropriate to the claim. Several sites '
        'copying D are still one originating claim. A complete response names '
        'the supported claim, rejects the unsupported inference and proposes '
        'a relevant check without inventing results.',
    'Return tomorrow without notes. An invented club record shows attendance '
        'rose after a reading trial. List what that record can support and what '
        'it cannot show about comprehension or causation. Propose an appropriate '
        'learning measure and a comparison, then use the source-evaluation '
        'checklist to review your reasoning. No real study is reported here.',
  ),
};

List<NorieLessonSection> _review(
        String transfer, String reasoning, String retrieval) =>
    List.unmodifiable([
      NorieLessonSection(
        title: 'Independent transfer — try first',
        symbol: '',
        accent: 'orange',
        points: const [],
        body: transfer,
      ),
      NorieLessonSection(
        title: 'Reveal: check your reasoning',
        symbol: '',
        accent: 'orange',
        points: const [],
        body: reasoning,
        reveal: true,
      ),
      NorieLessonSection(
        title: 'Return tomorrow — recall without notes',
        symbol: '',
        accent: 'orange',
        points: const [],
        body: retrieval,
      ),
    ]);
