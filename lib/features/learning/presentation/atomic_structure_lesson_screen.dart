import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../../content/data/norie_content_repository.dart';
import '../../content/domain/norie_content_models.dart';
import '../../content/presentation/norie_lesson_screen.dart';

class AtomicStructureLessonScreen extends StatelessWidget {
  const AtomicStructureLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NorieTopicContent?>(
      future: NorieContentRepositoryService.instance.getTopic(
        'science.chemistry.atomic-structure',
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final topic = snapshot.data;
        if (topic == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Atomic Structure'),
              backgroundColor: Colors.transparent,
            ),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Atomic Structure could not be loaded right now.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }

        return NorieLessonScreen(topic: topic);
      },
    );
  }
}
