import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../data/norie_content_repository.dart';
import '../domain/norie_content_access.dart';
import 'norie_lesson_screen.dart';

abstract final class NorieTopicRoute {
  static Future<void> open(
    BuildContext context,
    String topicId,
  ) async {
    final topic =
        await NorieContentRepositoryService.instance.getTopic(topicId);

    if (!context.mounted) return;

    if (topic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This topic could not be loaded. Try again later.'),
        ),
      );
      return;
    }

    final unlocked = NorieContentAccess.isUnlocked(
      topic,
      NorieProgression.instance.completedTopicIds,
    );

    if (!unlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Complete the previous Chemistry topic to unlock this lesson.',
          ),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NorieLessonScreen(topic: topic),
      ),
    );
  }
}
