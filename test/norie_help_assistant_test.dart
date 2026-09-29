import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/mascot/help/norie_help_models.dart';
import 'package:norie_learning/core/mascot/help/norie_help_service.dart';
import 'package:norie_learning/core/mascot/norie_app_context.dart';

void main() {
  group('NorieHelpService', () {
    const learnContext = NorieContextSnapshot(
      area: NorieAppArea.learn,
      title: 'Learn',
    );

    test('rejects empty input locally', () async {
      final response = await NorieHelpService.instance.answer(
        const NorieHelpRequest(
          text: '   ',
          context: learnContext,
        ),
      );

      expect(response.kind, NorieHelpResponseKind.validation);
      expect(response.text, isNotEmpty);
    });

    test('answers credits and XP app-help deterministically', () async {
      final response = await NorieHelpService.instance.answer(
        const NorieHelpRequest(
          text: 'How do credits and XP work?',
          context: learnContext,
        ),
      );

      expect(response.kind, NorieHelpResponseKind.appHelp);
      expect(response.text.toLowerCase(), contains('credits'));
      expect(response.text.toLowerCase(), contains('xp'));
    });

    test('uses current context for navigation help', () async {
      final response = await NorieHelpService.instance.answer(
        const NorieHelpRequest(
          text: 'What can I do here?',
          context: learnContext,
        ),
      );

      expect(response.kind, NorieHelpResponseKind.appHelp);
      expect(response.text.toLowerCase(), contains('learn'));
    });

    test('learning questions expose an AI Study action', () async {
      final response = await NorieHelpService.instance.answer(
        const NorieHelpRequest(
          text: 'Explain photosynthesis to me',
          context: learnContext,
        ),
      );

      expect(response.kind, NorieHelpResponseKind.learningRedirect);
      expect(
        response.quickActions.map((action) => action.destination),
        contains(NorieHelpDestination.aiStudy),
      );
    });

    test('tutorial help exposes replay action', () async {
      final response = await NorieHelpService.instance.answer(
        const NorieHelpRequest(
          text: 'Can I replay the tutorial?',
          context: learnContext,
        ),
      );

      expect(
        response.quickActions.map((action) => action.destination),
        contains(NorieHelpDestination.replayTutorial),
      );
    });
  });
}
