import '../norie_mascot_state.dart';

enum NorieTutorialDestination {
  home,
  learn,
  lesson,
  aiStudy,
  library,
  anatomy,
  challenge,
  progress,
  profile,
  account,
  shop,
  settings,
}

enum NorieTutorialPosition {
  auto,
  top,
  bottom,
  left,
  right,
}

class NorieTutorialStep {
  const NorieTutorialStep({
    required this.id,
    this.mascotState = NorieMascotState.guiding,
    required this.message,
    this.preferredPosition = NorieTutorialPosition.auto,
    this.targetId,
    this.voiceAsset,
    this.title = 'Norie Guide',
    this.section = '',
    this.destination,
    this.location = '',
  });

  final String id;
  final String? targetId;
  final NorieMascotState mascotState;
  final String message;
  final NorieTutorialPosition preferredPosition;
  final String? voiceAsset;
  final String title;
  final String section;
  final NorieTutorialDestination? destination;
  final String location;
}

class NorieTutorialDefinition {
  const NorieTutorialDefinition({
    required this.id,
    required this.steps,
    this.title = 'Norie Guide',
  });

  final String id;
  final List<NorieTutorialStep> steps;
  final String title;
}

abstract final class NorieTutorialCatalog {
  static const home = NorieTutorialDefinition(
    id: 'home.v1',
    title: 'Home & navigation',
    steps: [
      NorieTutorialStep(
        id: 'home-menu',
        title: 'Find your way around',
        targetId: 'home.menu',
        mascotState: NorieMascotState.pointing,
        message:
            'Use the bottom tabs for Home, Learn, Challenge, Progress, and Profile. Open the menu for your learning path, mastery review, account, shop, and settings. On a lesson or detail page, the back arrow returns to the previous screen.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
      NorieTutorialStep(
        id: 'home-learn',
        title: 'Continue or start learning',
        targetId: 'home.learn',
        mascotState: NorieMascotState.guiding,
        message:
            'Explore Learning opens the subject hub. Resume Lesson opens the featured learning path. Daily Challenge and Norie AI Study Lab are shortcuts to practice and source-based study. Check your XP, credits, and streak at the top; they are different measures, not a single score.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
    ],
  );

  static const learn = NorieTutorialDefinition(
    id: 'learn.v1',
    title: 'Subjects & learning paths',
    steps: [
      NorieTutorialStep(
        id: 'learn-ai',
        title: 'Built-in learning or your own material',
        targetId: 'learn.ai',
        mascotState: NorieMascotState.pointing,
        message:
            'Learn brings together built-in subject paths, 3D Anatomy Lab, and AI Study. Choose a subject when you want an existing lesson. Choose Create with Norie AI when you already have source material and want your own practice set. Anatomy Lab is for exploring structures and identification practice.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
      NorieTutorialStep(
        id: 'learn-subjects',
        title: 'Choose a subject and level',
        targetId: 'learn.subjects',
        mascotState: NorieMascotState.guiding,
        message:
            'Open Mathematics, Science, or English, then choose an available grade or topic. Grade pathways lead to lesson lists; topic hubs can also lead to activities such as Atomic Structure. Read the topic description before starting. A preview or coming-soon label means that area is not a finished lesson.',
        preferredPosition: NorieTutorialPosition.top,
      ),
      NorieTutorialStep(
        id: 'learn-search',
        title: 'Get help without generating a quiz',
        targetId: 'learn.search',
        mascotState: NorieMascotState.pointing,
        message:
            'Ask Norie helps with app navigation, rewards, and what to do next. Use the question mark for this searchable guide. Subject questions belong in a lesson or in Ask Norie About This Source inside a saved study set, where the answer can be checked against your material.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
    ],
  );

  static const challenge = NorieTutorialDefinition(
    id: 'challenge.v1',
    title: 'Challenges & goals',
    steps: [
      NorieTutorialStep(
        id: 'challenge-hero',
        title: 'Daily Challenge',
        targetId: 'challenge.hero',
        mascotState: NorieMascotState.guiding,
        message:
            'Open Challenge and choose Daily Challenge for a short practice session. Check the completion status before starting. Answer each question and review the result; repeating a completed activity does not guarantee the same rewards again.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
      NorieTutorialStep(
        id: 'challenge-modes',
        title: 'Speed Quiz and weekly goals',
        targetId: 'challenge.modes',
        mascotState: NorieMascotState.pointing,
        message:
            'Speed Quiz adds a timer, so watch the remaining time as well as accuracy. Weekly goal progress appears in the Challenge area. Finish the session to see the score and eligible bonuses; a displayed goal is not a reward already earned.',
        preferredPosition: NorieTutorialPosition.top,
      ),
    ],
  );

  static const anatomy = NorieTutorialDefinition(
    id: 'anatomy.v1',
    title: '3D Anatomy Lab',
    steps: [
      NorieTutorialStep(
        id: 'anatomy-explore',
        title: 'Open the lab and choose systems',
        targetId: 'anatomy.explore',
        mascotState: NorieMascotState.pointing,
        message:
            'From Learn, open 3D Anatomy Lab. Explore or Open 3D Viewer opens the model. Choose a preset or body systems to reduce clutter. The full atlas and skeleton fundamentals viewer have different tool sets; use the screen labels to identify which viewer is open.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
      NorieTutorialStep(
        id: 'anatomy-systems',
        title: 'Choose your body systems',
        targetId: 'anatomy.systems',
        mascotState: NorieMascotState.guiding,
        message:
            'These system filters narrow the model to your study area. Choose one system or combine several. The reference above determines which systems have modeled structures. Quiz opens a separate category selector before your 20-question identification round.',
        preferredPosition: NorieTutorialPosition.top,
      ),
      NorieTutorialStep(
          id: 'anatomy-camera',
          targetId: 'anatomy.camera',
          title: 'Rotate, zoom, and reset',
          message:
              'The camera now focuses on a femur in this skeleton. Focus area repeats that close-up. After the tour, drag to orbit and pinch or scroll to zoom. Front, Back, Left, Right, and Top change orientation; Reset frames the visible model again.'),
      NorieTutorialStep(
          id: 'anatomy-atlas',
          targetId: 'anatomy.atlas',
          title: 'Find and inspect a structure',
          message:
              'In the full atlas, choose a reference and system, then use Search parts to find a named structure. Focus brings it into view; Isolate removes surrounding clutter; Hide removes it from view. Restore and Restore hidden structures bring parts back. Opacity makes overlapping layers easier to inspect.'),
      NorieTutorialStep(
          id: 'anatomy-settings',
          targetId: 'anatomy.settings',
          title: 'Labels, modes, and coverage',
          message:
              'The skeleton viewer offers Explore, Identify, and Clean modes. Viewer settings control numbered markers, labels, marker size, layer opacity, animation, and auto rotation. The atlas Sources and coverage panel explains available structures and licenses. Not every reference includes every body system; an unavailable structure is not necessarily a search error.'),
      NorieTutorialStep(
          id: 'anatomy-quiz',
          targetId: 'anatomy.quiz',
          title: 'Build your 20-part challenge',
          message:
              'Open Quiz, choose a reference and one or more systems, or select Every part for the broadest pool. Select at least 20 distinct structures to start. During the quiz, the model keeps its original anatomical colors and shading. The magnifying glass reveals a short clue; the recenter and music buttons control your view and soundtrack.'),
      NorieTutorialStep(
          id: 'anatomy-loading',
          targetId: 'anatomy.explore',
          title: 'When the model does not load',
          message:
              'Give the 3D assets time to load, especially on the first visit. Use Retry if shown and check connectivity before assuming a model is missing. Supported browser/device graphics and available memory matter. Cached lessons being available offline does not prove every 3D asset is already downloaded.'),
    ],
  );

  static const aiStudy = NorieTutorialDefinition(
    id: 'ai-study.v1',
    title: 'Create an AI study set',
    steps: [
      NorieTutorialStep(
        id: 'ai-source',
        title: 'Prepare your source',
        targetId: 'ai-study.source',
        mascotState: NorieMascotState.guiding,
        message:
            'Open Create with Norie AI. Add a useful title and optional topic tag. Paste a clear paragraph or choose Upload and a supported file. Cloud uploads are limited to 10 MB. The experimental Local Study Generator accepts pasted notes only, between 80 and 16,000 characters; its runtime must be running on this computer.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
      NorieTutorialStep(
        id: 'ai-mode',
        title: 'Pick the question style and count',
        targetId: 'ai-study.mode',
        mascotState: NorieMascotState.pointing,
        message:
            'Choose an available practice mode, then an enabled item count. Multiple Choice offers answer options; Identification asks you to type; Flashcards are for reveal-and-review; Random Mix combines supported styles. True/false is unavailable in local mode. Disabled premium options cannot be selected.',
        preferredPosition: NorieTutorialPosition.top,
      ),
      NorieTutorialStep(
        id: 'ai-generate',
        title: 'Generate and handle waiting',
        targetId: 'ai-study.generate',
        mascotState: NorieMascotState.pointing,
        message:
            'Choose Generate Study Set once and wait for the saved deck. Local requests show queue position or accepted-card progress and may take several minutes. If the connection fails, retry with exactly the same notes and settings to reconnect while the job is retained. Cloud generation requires a configured service and signed-in account.',
        preferredPosition: NorieTutorialPosition.top,
      ),
      NorieTutorialStep(
          id: 'ai-quality',
          title: 'Check generated content',
          message:
              'AI can return fewer usable questions than requested and can choose ambiguous wording or wrong distractors. Read the source excerpt and explanation before relying on an answer. Edit or delete weak cards. Source preservation is not proof of educational accuracy, and generated material is not a substitute for a trusted reference.'),
      NorieTutorialStep(
          id: 'ai-privacy',
          title: 'Protect your material',
          message:
              'Use material you are allowed to upload. Avoid private student records and other sensitive information. Cloud and local storage are different: local AI saves notes and decks unencrypted on this computer and caches decks in the browser. Local mode is not a shared, authenticated classroom service.'),
    ],
  );

  static const quiz = NorieTutorialDefinition(
    id: 'quiz.v1',
    title: 'Answering quizzes',
    steps: [
      NorieTutorialStep(
        id: 'quiz-answer',
        title: 'Answer, check, and learn',
        targetId: 'quiz.answers',
        mascotState: NorieMascotState.guiding,
        message:
            'Choose an answer, check it, then review the explanation before moving on.',
        preferredPosition: NorieTutorialPosition.top,
      ),
      NorieTutorialStep(
          id: 'quiz-inputs',
          title: 'Use the right answer control',
          message:
              'Tap one option for single-choice questions and all required options for multi-select. Type the requested term for identification. For ordering questions, move the items into the requested sequence before checking. A disabled Check button usually means an answer is still missing.'),
      NorieTutorialStep(
          id: 'quiz-feedback',
          title: 'Feedback and finishing',
          message:
              'After checking, compare your response with the correct answer and read the explanation. Continue to the next item, then finish to reach results. Rewards depend on eligibility and caps; repeated taps do not create extra rewards. Leaving a quiz early may lose the current unfinished run.'),
    ],
  );

  static const gettingStarted =
      NorieTutorialDefinition(id: 'start.v2', title: 'Getting started', steps: [
    NorieTutorialStep(
        id: 'start-tour',
        title: 'Welcome to Norie Learning',
        message:
            'This guide explains the app one topic at a time. Next continues, Back revisits a step, and Contents lets you search or jump to any chapter. Close leaves the guide so you can try a control yourself. Reopen it from the question mark or Help & Support; reading the guide does not spend credits or submit answers.'),
    NorieTutorialStep(
        id: 'start-first-session',
        title: 'Your first study session',
        message:
            'Choose Learn, select a subject and grade or topic, read a lesson, then choose practice. Answer and check each question, read the explanations, and finish at results. Afterwards, open Progress to see recorded learning and find weak topics to review.'),
    NorieTutorialStep(
        id: 'start-guest',
        title: 'Local learning and accounts',
        message:
            'Built-in learning does not require a cloud account. Your device keeps local progress. Sign in through the menu when you need available cloud services, and check the sync status rather than assuming everything has uploaded. Do not clear browser/app data unless you are prepared to lose unsynced local work.'),
  ]);

  static const lessons = NorieTutorialDefinition(
      id: 'lessons.v2',
      title: 'Lessons & activities',
      steps: [
        NorieTutorialStep(
            id: 'lesson-read',
            title: 'Work through a lesson',
            message:
                'Open a lesson from its subject or grade list. Read the objectives, explanation, examples, and key concept. Scroll to reach the rest of the lesson. Where a guided question has Reveal answer, try it yourself first and then compare your reasoning.'),
        NorieTutorialStep(
            id: 'lesson-practice',
            title: 'Choose practice and mastery',
            message:
                'At the end, use Choose practice mode and pick an available activity. Practice builds recall; mastery activities check what you can answer independently. Available formats depend on the lesson and grade. A disabled practice button can mean that topic has no questions yet.'),
        NorieTutorialStep(
            id: 'lesson-atomic',
            title: 'Atomic Structure and interactive activities',
            message:
                'The Science/Chemistry path includes Atomic Structure lessons, quizzes, and the atom challenge. Read the activity prompt and use the supplied controls before submitting. Different activities ask for different actions; do not assume every illustrated scene is an interactive control. Return to the lesson when you need the underlying concept.'),
      ]);

  static const library = NorieTutorialDefinition(
      id: 'library.v2',
      title: 'Study library & card editing',
      steps: [
        NorieTutorialStep(
            id: 'library-find',
            title: 'Find a saved study set',
            message:
                'Open your study library from the AI study area. Search by the available title/topic fields and use the due-review filter to find cards needing attention. Open a deck to see its source, question count, and review/practice actions. If loading fails, use Retry; an error is not proof that your library is empty.'),
        NorieTutorialStep(
            id: 'library-edit',
            title: 'Search, add, and correct cards',
            message:
                'Inside a deck, Search cards filters its contents. The plus button adds a flashcard. Open a card action menu to edit or delete that card. Keep the prompt, answer, explanation, and source excerpt consistent. Review your edits before using the card to grade yourself.'),
        NorieTutorialStep(
            id: 'library-delete',
            title: 'Delete carefully',
            message:
                'The trash button on a study-set page deletes the deck, not just the current card. Read the confirmation before proceeding. Deletion removes the saved deck from the app; it is not an undo operation. Local AI job records can retain a generated result until their retention period expires.'),
      ]);

  static const review = NorieTutorialDefinition(
      id: 'review.v2',
      title: 'Flashcards & spaced review',
      steps: [
        NorieTutorialStep(
            id: 'review-due',
            title: 'Due review or browsing',
            message:
                'Review due cards limits the session to scheduled cards that need review now. Browse flashcards lets you inspect the deck without treating it as a scored quiz. A pure flashcard deck has Start Practice disabled; use the review or browse actions instead.'),
        NorieTutorialStep(
            id: 'review-reveal',
            title: 'Recall before revealing',
            message:
                'Read the prompt and answer from memory before choosing Reveal. Compare your answer with the saved answer and source. Self-rating is for scheduling, not proof that an answer is correct, and it does not award quiz XP.'),
        NorieTutorialStep(
            id: 'review-rate',
            title: 'Again, Hard, or Got it',
            message:
                'Choose Again if you could not recall the answer, Hard if recall took effort, or Got it if you remembered confidently. These ratings adjust future review timing. Be honest instead of choosing Got it just to finish. Review schedules saved locally should not be assumed to sync across devices.'),
      ]);

  static const sourceQa = NorieTutorialDefinition(
      id: 'qa.v2',
      title: 'Source Q&A & app help',
      steps: [
        NorieTutorialStep(
            id: 'qa-source',
            title: 'Ask about a saved source',
            message:
                'Open a deck and choose Ask Norie About This Source. Type one specific question and send it. This uses that deck\'s source, not every document in your library. Read the returned quote and check that it actually answers your question.'),
        NorieTutorialStep(
            id: 'qa-limits',
            title: 'Missing evidence or an unavailable service',
            message:
                'If the source does not support an answer, Norie may abstain. Rephrase a vague question or use a better source rather than treating an unsupported response as fact. Cloud Q&A needs connectivity and service access; local Q&A needs the local server, model, and saved source on this computer.'),
        NorieTutorialStep(
            id: 'qa-help',
            title: 'App help is different',
            message:
                'Ask Norie in the app shell handles directions and feature questions. Ask how to find a lesson, understand XP, or start this tutorial. For a factual question about study material, open the relevant saved source instead. Help & Support in the menu opens the complete guide.'),
      ]);

  static const results = NorieTutorialDefinition(
      id: 'results.v2',
      title: 'Results & rewards',
      steps: [
        NorieTutorialStep(
            id: 'results-review',
            title: 'Use results to choose the next step',
            message:
                'After a completed quiz, review the score, accuracy, and explanations or mistake review where offered. Return to the lesson for concepts you missed, retry for practice, or use the suggested next action. A score describes that attempt, not everything you know about the subject.'),
        NorieTutorialStep(
            id: 'results-xp',
            title: 'XP is not the same as credits',
            message:
                'XP contributes to learning levels and ranks. Credits are a separate earned balance used by supported shop items. Reward popups show what was actually awarded, subject to activity rules, duplicate protection, and caps. Revisiting a completed activity or self-rating a card does not guarantee new XP or credits.'),
      ]);

  static const progress = NorieTutorialDefinition(
      id: 'progress.v2',
      title: 'Progress, mastery & streaks',
      steps: [
        NorieTutorialStep(
            id: 'progress-overview',
            title: 'Read your progress',
            message:
                'Open Progress for your current rank, XP, level path, accuracy, streak, and mastery summary. Accuracy comes from recorded answers; an empty history is different from a zero score. Rank milestones and achievements are unlocked by their own requirements.'),
        NorieTutorialStep(
            id: 'progress-weak',
            title: 'Review weak topics',
            message:
                'Open Mastery & Weak Topics from the menu or the available Progress action. Compare tracked, mastered, and weak topics, then choose a topic to review. Work through the review questions and explanations to address the gap rather than only repeating your strongest subject.'),
        NorieTutorialStep(
            id: 'progress-streak',
            title: 'Streaks and unfinished pages',
            message:
                'Streaks reflect eligible learning on successive days. Check the current streak and available challenge/goal status. The separate Streaks history and Learning Preferences menu pages are currently placeholders; they do not yet provide the detailed settings described in their preview text.'),
      ]);

  static const profile = NorieTutorialDefinition(
      id: 'profile.v2',
      title: 'Profile & achievements',
      steps: [
        NorieTutorialStep(
            id: 'profile-summary',
            title: 'Your learner summary',
            message:
                'Profile combines your account summary, rank, total XP, streak, completed lessons, accuracy, and learning activity. These figures summarize recorded activity; they do not replace lesson feedback or mastery review.'),
        NorieTutorialStep(
            id: 'profile-achievements',
            title: 'Achievements and personalization',
            message:
                'Scroll through Achievements to read unlocked and locked milestones. Membership and Norie Shop open separate screens. Use the account page to edit your display name; use available shop controls to equip owned frames, badges, or themes.'),
      ]);

  static const account = NorieTutorialDefinition(
      id: 'account.v2',
      title: 'Account & cloud sync',
      steps: [
        NorieTutorialStep(
            id: 'account-signin',
            title: 'Sign in or create an account',
            message:
                'Open Sign In / Cloud Sync or Cloud Account in the menu. Choose Sign In for an existing account or Create Account for a new one. Enter your credentials only in the account form. If confirmation is required, check your email and use Resend Confirmation Email when needed.'),
        NorieTutorialStep(
            id: 'account-recovery',
            title: 'Password and name changes',
            message:
                'Forgot password? starts the email recovery flow. Follow the recovery link and password screen rather than making a second account to recover progress. When signed in, the edit icon beside your display name opens a Save/Cancel dialog.'),
        NorieTutorialStep(
            id: 'account-sync',
            title: 'Check synchronization before switching devices',
            message:
                'Read the account sync status and use Sync Now when connected. Failed or pending sync means local changes may not be in the cloud yet. Not every local feature supports cross-device sync. Sign Out changes cloud access; it does not securely erase all data stored on a shared computer.'),
      ]);

  static const shop = NorieTutorialDefinition(
      id: 'shop.v2',
      title: 'Credits, shop & membership',
      steps: [
        NorieTutorialStep(
            id: 'shop-buy',
            title: 'Spend earned credits deliberately',
            message:
                'Open Norie Shop from Profile or the menu. Compare the displayed item cost with your credit balance before choosing Buy. Supported items include consumables and profile cosmetics. A successful purchase spends credits; insufficient balance prevents it. Read item details before buying.'),
        NorieTutorialStep(
            id: 'shop-equip',
            title: 'Owned items and consumables',
            message:
                'Owned cosmetics can be equipped using the item controls; owned and equipped are different states. Consumables such as streak shields have an available count. Do not assume that buying an item unlocks an unfinished feature elsewhere in the app.'),
        NorieTutorialStep(
            id: 'shop-membership',
            title: 'Membership is a preview',
            message:
                'The Membership screen previews Free, Plus, and Pro. Subscription checkout is disabled in this build: preview prices, premium labels, and proposed benefits are not an active subscription or a purchase. Current AI allowances depend on the deployed service, not this tutorial; the local AI prototype does not enforce account-based daily plans.'),
      ]);

  static const settings = NorieTutorialDefinition(
      id: 'settings.v2',
      title: 'Settings & sound',
      steps: [
        NorieTutorialStep(
            id: 'settings-audio',
            title: 'Music and sound effects',
            message:
                'Open Settings from the menu. Background Music and Sound Effects have separate switches and volume sliders. Disabled sliders follow their switch. Quiet Music During Lessons lowers music while reading. Preferences are saved on this device.'),
        NorieTutorialStep(
            id: 'settings-silent',
            title: 'Troubleshoot missing audio',
            message:
                'Tap or press a key in the app to allow browser audio. Enable Background Music and raise its volume for the five-track soundtrack. Enable Sound Effects and choose Test Sound to check feedback audio. Also check device volume, browser tab mute, and the selected output device. Web music needs its first online asset download before offline use. Visual feedback remains usable without sound.'),
      ]);

  static const offline = NorieTutorialDefinition(
      id: 'offline.v2',
      title: 'Offline use & troubleshooting',
      steps: [
        NorieTutorialStep(
            id: 'offline-saved',
            title: 'What you can use offline',
            message:
                'Built-in lessons and saved study questions are designed for local use. On the web, first load the app and needed assets while connected and confirm they are available before relying on them offline. Cloud generation, uploads, and cloud Q&A still need their service; local AI needs its separate local runtime.'),
        NorieTutorialStep(
            id: 'offline-retry',
            title: 'A blank list or failed request',
            message:
                'Read the error, check connectivity or the local runtime, and use Retry where offered. An empty-looking study library after a loading error does not prove your decks were deleted. Avoid repeated generation submissions while a request is active. Save important original notes outside the app before troubleshooting storage.'),
        NorieTutorialStep(
            id: 'offline-storage',
            title: 'Protect unsynced work',
            message:
                'Browser profiles and devices have separate local storage. Clearing site data, reinstalling, or using private browsing can remove cached decks, progress, preferences, and retry keys. Check supported cloud sync before switching devices. Never use clearing all storage as the first fix for a temporary error.'),
        NorieTutorialStep(
            id: 'offline-next',
            title: 'You can return to this guide',
            message:
                'Open the question mark or Help & Support whenever you need a refresher. Contents searches all guide topics, including controls inside a saved deck or the anatomy viewers. Close the guide and try one workflow at a time; no tutorial step needs a purchase, upload, or quiz submission.'),
      ]);

  static const chapters = [
    gettingStarted,
    home,
    learn,
    lessons,
    quiz,
    aiStudy,
    library,
    review,
    sourceQa,
    anatomy,
    challenge,
    results,
    progress,
    profile,
    account,
    shop,
    settings,
    offline
  ];

  static final complete = NorieTutorialDefinition(
    id: 'complete.v2',
    title: 'Complete app guide',
    steps: [
      for (final chapter in chapters)
        for (final step in chapter.steps)
          NorieTutorialStep(
              id: step.id,
              title: step.title,
              section: chapter.title,
              destination: _destination(chapter),
              location: _location(chapter),
              targetId: step.targetId ?? 'tour.${_destination(chapter).name}',
              preferredPosition: step.preferredPosition,
              voiceAsset: step.voiceAsset,
              message: step.message,
              mascotState: step.mascotState)
    ],
  );

  static NorieTutorialDestination _destination(
          NorieTutorialDefinition chapter) =>
      switch (chapter.id) {
        'learn.v1' => NorieTutorialDestination.learn,
        'lessons.v2' || 'quiz.v1' => NorieTutorialDestination.lesson,
        'ai-study.v1' => NorieTutorialDestination.aiStudy,
        'library.v2' ||
        'review.v2' ||
        'qa.v2' =>
          NorieTutorialDestination.library,
        'anatomy.v1' => NorieTutorialDestination.anatomy,
        'challenge.v1' => NorieTutorialDestination.challenge,
        'progress.v2' || 'results.v2' => NorieTutorialDestination.progress,
        'profile.v2' => NorieTutorialDestination.profile,
        'account.v2' => NorieTutorialDestination.account,
        'shop.v2' => NorieTutorialDestination.shop,
        'settings.v2' => NorieTutorialDestination.settings,
        _ => NorieTutorialDestination.home,
      };

  static String _location(NorieTutorialDefinition chapter) =>
      switch (_destination(chapter)) {
        NorieTutorialDestination.home => 'Home',
        NorieTutorialDestination.learn => 'Learn > Subjects',
        NorieTutorialDestination.lesson =>
          'Learn > Science > Chemistry > Atomic Structure',
        NorieTutorialDestination.aiStudy => 'Learn > Create with Norie AI',
        NorieTutorialDestination.library =>
          'Learn > Saved Study Sets > ${chapter.title}',
        NorieTutorialDestination.anatomy =>
          'Learn > 3D Anatomy Lab > Anatomy Atlas',
        NorieTutorialDestination.challenge => 'Challenge',
        NorieTutorialDestination.progress => 'Progress > ${chapter.title}',
        NorieTutorialDestination.profile => 'Profile',
        NorieTutorialDestination.account => 'Menu > Account',
        NorieTutorialDestination.shop => 'Menu > Norie Shop',
        NorieTutorialDestination.settings => 'Menu > Settings > Sound',
      };
}
