import '../norie_app_context.dart';

enum NorieHelpResponseKind { validation, appHelp, learningRedirect, unavailable }

enum NorieHelpDestination { aiStudy, replayTutorial, anatomy, challenges, learn, home }

class NorieHelpRequest {
  const NorieHelpRequest({required this.text, required this.context});
  final String text;
  final NorieContextSnapshot context;
}

class NorieHelpQuickAction {
  const NorieHelpQuickAction({required this.label, required this.destination});
  final String label;
  final NorieHelpDestination destination;
}

class NorieHelpResponse {
  const NorieHelpResponse({
    required this.kind,
    required this.text,
    this.quickActions = const <NorieHelpQuickAction>[],
  });
  final NorieHelpResponseKind kind;
  final String text;
  final List<NorieHelpQuickAction> quickActions;
}