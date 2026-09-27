import 'package:flutter/material.dart';

import '../../content/data/norie_content_catalog.dart';
import '../../content/presentation/norie_quiz_screen.dart';

class AtomicStructureQuizScreen extends StatelessWidget {
  const AtomicStructureQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NorieQuizScreen(
      topic: NorieContentCatalog.atomicStructure,
    );
  }
}
