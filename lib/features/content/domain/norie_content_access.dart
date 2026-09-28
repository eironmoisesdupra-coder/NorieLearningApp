import '../domain/norie_content_models.dart';

abstract final class NorieContentAccess {
  static bool isUnlocked(
    NorieTopicContent topic,
    Set<String> completedTopicIds,
  ) {
    final prerequisite = topic.prerequisiteTopicId;
    return prerequisite == null ||
        prerequisite.isEmpty ||
        completedTopicIds.contains(prerequisite);
  }
}
