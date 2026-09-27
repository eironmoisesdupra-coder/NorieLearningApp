import 'package:flutter/material.dart';

import '../../content/data/norie_content_catalog.dart';
import '../../content/presentation/norie_lesson_screen.dart';

class AtomicStructureLessonScreen extends StatelessWidget {
  const AtomicStructureLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NorieLessonScreen(
      topic: NorieContentCatalog.atomicStructure,
    );
  }
}
