import 'norie_content_models.dart';

class NorieSkillNode {
  NorieSkillNode({
    required this.id,
    required this.label,
    required this.subject,
    required this.gradeLevel,
    required Set<String> topicIds,
    required Set<String> prerequisiteSkillIds,
  })  : topicIds = Set.unmodifiable(topicIds),
        prerequisiteSkillIds = Set.unmodifiable(prerequisiteSkillIds);

  final String id;
  final String label;
  final String subject;
  final String? gradeLevel;
  final Set<String> topicIds;
  final Set<String> prerequisiteSkillIds;
}

/// A local-first knowledge graph derived from authored assessment concepts.
///
/// Existing content already stores `conceptId` / `conceptLabel` on assessment
/// items. The graph promotes those concepts to reusable skills and carries
/// lesson prerequisites across the concept boundary. Older lessons without
/// concept metadata still receive one stable fallback skill so no content is
/// lost during migration.
class NorieSkillGraph {
  NorieSkillGraph._({
    required Map<String, NorieSkillNode> nodes,
    required Map<String, Set<String>> topicSkills,
  })  : nodes = Map.unmodifiable(nodes),
        topicSkills = Map.unmodifiable(
          topicSkills.map(
            (key, value) => MapEntry(key, Set<String>.unmodifiable(value)),
          ),
        );

  final Map<String, NorieSkillNode> nodes;
  final Map<String, Set<String>> topicSkills;

  factory NorieSkillGraph.fromTopics(Iterable<NorieTopicContent> source) {
    final topics = source.toList()
      ..sort((a, b) {
        final order = a.order.compareTo(b.order);
        return order == 0 ? a.id.compareTo(b.id) : order;
      });
    final nodes = <String, NorieSkillNode>{};
    final topicSkills = <String, Set<String>>{};
    final topicById = {for (final topic in topics) topic.id: topic};

    for (final topic in topics) {
      final conceptLabels = <String, String>{};
      final questions = [...topic.quiz.questions, ...topic.challenge.rounds];
      for (final question in questions) {
        final conceptId = question.conceptId?.trim();
        if (conceptId == null || conceptId.isEmpty) continue;
        conceptLabels.putIfAbsent(
          conceptId,
          () => question.conceptLabel?.trim().isNotEmpty == true
              ? question.conceptLabel!.trim()
              : topic.title,
        );
      }

      if (conceptLabels.isEmpty) {
        conceptLabels['${topic.id}.core'] = topic.title;
      }
      topicSkills[topic.id] = conceptLabels.keys.toSet();
    }

    for (final topic in topics) {
      final prerequisiteSkills = <String>{};
      final prerequisiteId = topic.prerequisiteTopicId;
      if (prerequisiteId != null && topicById.containsKey(prerequisiteId)) {
        prerequisiteSkills.addAll(topicSkills[prerequisiteId] ?? const {});
      }

      final questions = [...topic.quiz.questions, ...topic.challenge.rounds];
      final labels = <String, String>{};
      for (final question in questions) {
        final id = question.conceptId?.trim();
        if (id == null || id.isEmpty) continue;
        labels[id] = question.conceptLabel?.trim().isNotEmpty == true
            ? question.conceptLabel!.trim()
            : topic.title;
      }

      for (final skillId in topicSkills[topic.id]!) {
        nodes.update(
          skillId,
          (old) => NorieSkillNode(
            id: old.id,
            label: old.label,
            subject: old.subject,
            gradeLevel: old.gradeLevel,
            topicIds: {...old.topicIds, topic.id},
            prerequisiteSkillIds: {
              ...old.prerequisiteSkillIds,
              ...prerequisiteSkills,
            }..remove(skillId),
          ),
          ifAbsent: () => NorieSkillNode(
            id: skillId,
            label: labels[skillId] ?? topic.title,
            subject: topic.subject,
            gradeLevel: topic.gradeLevel,
            topicIds: {topic.id},
            prerequisiteSkillIds: {...prerequisiteSkills}..remove(skillId),
          ),
        );
      }
    }

    return NorieSkillGraph._(nodes: nodes, topicSkills: topicSkills);
  }

  Set<String> skillsForTopic(String topicId) =>
      topicSkills[topicId] ?? const <String>{};

  /// Completion-derived coverage for advisory readiness. This does not certify
  /// independently demonstrated or retained mastery and never awards XP.
  Set<String> masteredSkillsFromCompletedTopics(Set<String> completedTopicIds) {
    return {
      for (final topicId in completedTopicIds) ...skillsForTopic(topicId),
    };
  }

  Set<String> unmetPrerequisitesForTopic(
    String topicId,
    Set<String> masteredSkillIds,
  ) {
    final required = <String>{};
    for (final skillId in skillsForTopic(topicId)) {
      required.addAll(nodes[skillId]?.prerequisiteSkillIds ?? const {});
    }
    return required.difference(masteredSkillIds);
  }

  /// Readiness is a suggestion for review, never an access lock.
  bool isTopicReady(String topicId, Set<String> masteredSkillIds) =>
      topicSkills.containsKey(topicId) &&
      unmetPrerequisitesForTopic(topicId, masteredSkillIds).isEmpty;
}
