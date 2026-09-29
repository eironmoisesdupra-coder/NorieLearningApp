import '../norie_app_context.dart';
import 'norie_help_models.dart';

class NorieHelpService {
  NorieHelpService._();

  static final NorieHelpService instance = NorieHelpService._();

  Future<NorieHelpResponse> answer(NorieHelpRequest request) async {
    final raw = request.text.trim();
    if (raw.isEmpty) {
      return const NorieHelpResponse(
        kind: NorieHelpResponseKind.validation,
        text: 'Type a question and I’ll help you find the right place.',
      );
    }

    final query = raw.toLowerCase();

    if (query.contains('credit') || RegExp(r'\\bxp\\b').hasMatch(query)) {
      return const NorieHelpResponse(
        kind: NorieHelpResponseKind.appHelp,
        text: 'XP tracks your learning progress and levels. Credits are Norie’s spendable reward currency, earned from eligible lessons, challenges, and other milestones.',
      );
    }

    if (query.contains('tutorial') || query.contains('guide me')) {
      return const NorieHelpResponse(
        kind: NorieHelpResponseKind.appHelp,
        text: 'You can replay the tutorial for the section you’re currently using.',
        quickActions: [
          NorieHelpQuickAction(
            label: 'Replay this tutorial',
            destination: NorieHelpDestination.replayTutorial,
          ),
        ],
      );
    }

    if (query.contains('anatom')) {
      return const NorieHelpResponse(
        kind: NorieHelpResponseKind.appHelp,
        text: 'The Anatomy Lab lets you explore body systems in 3D, rotate and zoom the model, and practice identification.',
        quickActions: [
          NorieHelpQuickAction(
            label: 'Open Anatomy Lab',
            destination: NorieHelpDestination.anatomy,
          ),
        ],
      );
    }

    if (query.contains('challenge') || query.contains('speed quiz')) {
      return const NorieHelpResponse(
        kind: NorieHelpResponseKind.appHelp,
        text: 'Challenges are short practice runs. Daily Challenge focuses on steady progress, while Speed Quiz adds a timer.',
        quickActions: [
          NorieHelpQuickAction(
            label: 'Go to Challenges',
            destination: NorieHelpDestination.challenges,
          ),
        ],
      );
    }

    if (query.contains('ai study') ||
        query.contains('study set') ||
        query.contains('upload notes') ||
        query.contains('generate question')) {
      return const NorieHelpResponse(
        kind: NorieHelpResponseKind.appHelp,
        text: 'AI Study can turn your notes or supported files into practice questions and flashcards grounded in your source.',
        quickActions: [
          NorieHelpQuickAction(
            label: 'Open AI Study',
            destination: NorieHelpDestination.aiStudy,
          ),
        ],
      );
    }

    if (_isContextHelp(query)) {
      return NorieHelpResponse(
        kind: NorieHelpResponseKind.appHelp,
        text: _contextHelp(request.context.area),
        quickActions: _contextActions(request.context.area),
      );
    }

    if (_looksLikeLearningQuestion(query)) {
      return const NorieHelpResponse(
        kind: NorieHelpResponseKind.learningRedirect,
        text: 'That’s a learning question. Use AI Study so I can answer from your lesson or source material instead of guessing.',
        quickActions: [
          NorieHelpQuickAction(
            label: 'Open AI Study',
            destination: NorieHelpDestination.aiStudy,
          ),
        ],
      );
    }

    return NorieHelpResponse(
      kind: NorieHelpResponseKind.appHelp,
      text: 'I can help with navigation, XP and Credits, quizzes, Anatomy Lab, AI Study, tutorials, or what to do in ${_areaLabel(request.context.area)}.',
      quickActions: _contextActions(request.context.area),
    );
  }

  static bool _isContextHelp(String query) {
    return query.contains('what can i do') ||
        query.contains('what do i do') ||
        query.contains('where am i') ||
        query.contains('help here') ||
        query.contains('how do i use this') ||
        query.contains('navigate');
  }

  static bool _looksLikeLearningQuestion(String query) {
    return query.startsWith('explain ') ||
        query.startsWith('teach me ') ||
        query.startsWith('quiz me ') ||
        query.startsWith('why ') ||
        query.startsWith('how does ') ||
        query.startsWith('how do ') ||
        query.startsWith('what is ') ||
        query.startsWith('what are ') ||
        query.startsWith('solve ');
  }

  static String _contextHelp(NorieAppArea area) {
    return switch (area) {
      NorieAppArea.home =>
        'Home shows your progress, current learning path, and shortcuts into the main Norie areas.',
      NorieAppArea.learn =>
        'Learn is where you choose subjects, open Anatomy Lab, or create practice with AI Study.',
      NorieAppArea.challenge =>
        'Challenge is for Daily Challenge and Speed Quiz sessions that build XP and mastery.',
      NorieAppArea.progress =>
        'Progress summarizes your XP, levels, mastery, streaks, and learning history.',
      NorieAppArea.profile =>
        'Profile contains your learner identity, achievements, rank, inventory, and account-related options.',
      NorieAppArea.lesson =>
        'This lesson teaches the topic before you move into active recall and quiz practice.',
      NorieAppArea.anatomy =>
        'In Anatomy Lab you can select systems, manipulate the 3D model, inspect structures, and start identification practice.',
      NorieAppArea.study =>
        'AI Study lets you create, review, and practice study sets based on your own source material.',
      NorieAppArea.quiz =>
        'Choose your answer, check it, review the explanation, then continue. Norie reacts without blocking your controls.',
      NorieAppArea.results =>
        'Results summarizes your score, XP, rewards, and review options.',
      NorieAppArea.unknown =>
        'I can help you find lessons, AI Study, Anatomy Lab, challenges, progress, or profile features.',
    };
  }

  static List<NorieHelpQuickAction> _contextActions(NorieAppArea area) {
    return switch (area) {
      NorieAppArea.learn => const [
          NorieHelpQuickAction(
            label: 'Open AI Study',
            destination: NorieHelpDestination.aiStudy,
          ),
          NorieHelpQuickAction(
            label: 'Open Anatomy Lab',
            destination: NorieHelpDestination.anatomy,
          ),
        ],
      NorieAppArea.challenge => const [
          NorieHelpQuickAction(
            label: 'Go to Challenges',
            destination: NorieHelpDestination.challenges,
          ),
        ],
      _ => const [],
    };
  }

  static String _areaLabel(NorieAppArea area) => area.name;
}
