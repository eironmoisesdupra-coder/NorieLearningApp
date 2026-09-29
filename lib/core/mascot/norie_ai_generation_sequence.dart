import 'norie_mascot_controller.dart';

class NorieAiGenerationSequence {
  NorieAiGenerationSequence(this.controller);

  final NorieMascotController controller;

  static const captions = <String>[
    'Reading…',
    'Organizing…',
    'Building questions…',
  ];

  static String captionForStep(int step) {
    if (step < 0) return captions.first;
    return captions[step % captions.length];
  }

  void start() => controller.think();

  void success() => controller.idea();

  void failure() => controller.nervous();
}
