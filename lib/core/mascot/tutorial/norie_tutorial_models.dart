import '../norie_mascot_state.dart';

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
    required this.mascotState,
    required this.message,
    required this.preferredPosition,
    this.targetId,
    this.voiceAsset,
  });

  final String id;
  final String? targetId;
  final NorieMascotState mascotState;
  final String message;
  final NorieTutorialPosition preferredPosition;
  final String? voiceAsset;
}

class NorieTutorialDefinition {
  const NorieTutorialDefinition({
    required this.id,
    required this.steps,
  });

  final String id;
  final List<NorieTutorialStep> steps;
}

abstract final class NorieTutorialCatalog {
  static const home = NorieTutorialDefinition(
    id: 'home.v1',
    steps: [
      NorieTutorialStep(
        id: 'home-menu',
        targetId: 'home.menu',
        mascotState: NorieMascotState.pointing,
        message: 'This menu keeps every major Norie area within reach.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
      NorieTutorialStep(
        id: 'home-learn',
        targetId: 'home.learn',
        mascotState: NorieMascotState.guiding,
        message: 'Start here when you want a lesson, practice set, or study path.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
    ],
  );

  static const learn = NorieTutorialDefinition(
    id: 'learn.v1',
    steps: [
      NorieTutorialStep(
        id: 'learn-ai',
        targetId: 'learn.ai',
        mascotState: NorieMascotState.pointing,
        message: 'AI Study can turn your own notes or files into practice.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
      NorieTutorialStep(
        id: 'learn-subjects',
        targetId: 'learn.subjects',
        mascotState: NorieMascotState.guiding,
        message: 'Or choose a subject and follow Norie’s built-in mastery path.',
        preferredPosition: NorieTutorialPosition.top,
      ),
      NorieTutorialStep(
        id: 'learn-search',
        targetId: 'learn.search',
        mascotState: NorieMascotState.pointing,
        message: 'Use this help button whenever you need directions or study support.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
    ],
  );

  static const challenge = NorieTutorialDefinition(
    id: 'challenge.v1',
    steps: [
      NorieTutorialStep(
        id: 'challenge-hero',
        targetId: 'challenge.hero',
        mascotState: NorieMascotState.guiding,
        message: 'Challenges turn practice into quick XP-focused sessions.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
      NorieTutorialStep(
        id: 'challenge-modes',
        targetId: 'challenge.modes',
        mascotState: NorieMascotState.pointing,
        message: 'Choose Daily Challenge for steady practice or Speed Quiz for a timed run.',
        preferredPosition: NorieTutorialPosition.top,
      ),
    ],
  );

  static const anatomy = NorieTutorialDefinition(
    id: 'anatomy.v1',
    steps: [
      NorieTutorialStep(
        id: 'anatomy-explore',
        targetId: 'anatomy.explore',
        mascotState: NorieMascotState.pointing,
        message: 'Explore opens the interactive 3D anatomy viewer.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
      NorieTutorialStep(
        id: 'anatomy-systems',
        targetId: 'anatomy.systems',
        mascotState: NorieMascotState.guiding,
        message: 'Select body systems here before you study or start a quiz.',
        preferredPosition: NorieTutorialPosition.top,
      ),
    ],
  );

  static const aiStudy = NorieTutorialDefinition(
    id: 'ai-study.v1',
    steps: [
      NorieTutorialStep(
        id: 'ai-source',
        targetId: 'ai-study.source',
        mascotState: NorieMascotState.guiding,
        message: 'Paste notes or upload a supported study file first.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
      NorieTutorialStep(
        id: 'ai-mode',
        targetId: 'ai-study.mode',
        mascotState: NorieMascotState.pointing,
        message: 'Choose the practice style and number of questions you want.',
        preferredPosition: NorieTutorialPosition.top,
      ),
      NorieTutorialStep(
        id: 'ai-generate',
        targetId: 'ai-study.generate',
        mascotState: NorieMascotState.pointing,
        message: 'Then let Norie build your study set.',
        preferredPosition: NorieTutorialPosition.top,
      ),
    ],
  );

  static const quiz = NorieTutorialDefinition(
    id: 'quiz.v1',
    steps: [
      NorieTutorialStep(
        id: 'quiz-answer',
        targetId: 'quiz.answers',
        mascotState: NorieMascotState.guiding,
        message: 'Choose an answer, check it, then review the explanation before moving on.',
        preferredPosition: NorieTutorialPosition.top,
      ),
    ],
  );
}
