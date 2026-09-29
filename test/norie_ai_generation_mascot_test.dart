import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/mascot/norie_ai_generation_sequence.dart';
import 'package:norie_learning/core/mascot/norie_mascot_controller.dart';
import 'package:norie_learning/core/mascot/norie_mascot_state.dart';

void main() {
  group('NorieAiGenerationSequence', () {
    test('uses honest deterministic generation captions', () {
      expect(
        NorieAiGenerationSequence.captionForStep(0),
        'Reading…',
      );
      expect(
        NorieAiGenerationSequence.captionForStep(1),
        'Organizing…',
      );
      expect(
        NorieAiGenerationSequence.captionForStep(2),
        'Building questions…',
      );
      expect(
        NorieAiGenerationSequence.captionForStep(3),
        'Reading…',
      );
    });

    test('start places Norie in thinking state', () {
      final controller = NorieMascotController();
      addTearDown(controller.dispose);
      final sequence = NorieAiGenerationSequence(controller);

      sequence.start();

      expect(controller.state, NorieMascotState.thinking);
    });

    test('success uses idea state', () {
      final controller = NorieMascotController();
      addTearDown(controller.dispose);
      final sequence = NorieAiGenerationSequence(controller);

      sequence.start();
      sequence.success();

      expect(controller.state, NorieMascotState.idea);
    });

    test('failure uses a concerned reaction', () {
      final controller = NorieMascotController();
      addTearDown(controller.dispose);
      final sequence = NorieAiGenerationSequence(controller);

      sequence.start();
      sequence.failure();

      expect(controller.state, NorieMascotState.nervous);
    });
  });
}
