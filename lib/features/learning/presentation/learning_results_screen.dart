import 'package:flutter/material.dart';

import '../../content/data/norie_content_catalog.dart';
import '../../content/presentation/norie_learning_results_screen.dart';

class LearningResultsScreen extends StatelessWidget {
  const LearningResultsScreen({
    required this.quizScore,
    required this.challengeScore,
    super.key,
  });

  final int quizScore;
  final int challengeScore;

  @override
  Widget build(BuildContext context) {
    return NorieLearningResultsScreen(
      topic: NorieContentCatalog.atomicStructure,
      quizScore: quizScore,
      challengeScore: challengeScore,
    );
  }
}
