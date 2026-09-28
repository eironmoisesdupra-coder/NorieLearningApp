import 'package:flutter/material.dart';

import '../../content/data/norie_content_catalog.dart';
import '../../content/presentation/norie_challenge_screen.dart';

class AtomChallengeScreen extends StatelessWidget {
  const AtomChallengeScreen({
    required this.quizScore,
    super.key,
  });

  final int quizScore;

  @override
  Widget build(BuildContext context) {
    return NorieChallengeScreen(
      topic: NorieContentCatalog.atomicStructure,
      quizScore: quizScore,
    );
  }
}
