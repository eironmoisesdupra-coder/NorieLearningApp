import 'package:flutter/material.dart';

import '../data/norie_content_catalog.dart';
import 'norie_lesson_screen.dart';

abstract final class NorieTopicRoute {
  static void open(BuildContext context, String topicId) {
    final topic = NorieContentCatalog.topicById(topicId);

    if (topic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This topic could not be found.')),
      );
      return;
    }

    if (!topic.available) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${topic.title} is not available in this demo yet.'),
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
