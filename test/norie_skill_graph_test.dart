import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';
import 'package:norie_learning/features/content/data/additional_subjects/norie_additional_subject_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_skill_graph.dart';

NorieTopicContent changed(
    NorieTopicContent source, String id, String? prerequisite) {
  final json = source.toJson();
  json['id'] = id;
  json['prerequisite_topic_id'] = prerequisite;
  return NorieTopicContent.fromJson(json);
}

void main() {
  test('conceptless lessons receive stable fallback skills across source order',
      () {
    final source =
        NorieAdditionalSubjectCurriculum.topicsFor('Filipino', 'g1').first;
    final json = source.toJson();
    for (final question in [
      ...(json['quiz'] as Map)['questions'] as List,
      ...(json['challenge'] as Map)['rounds'] as List
    ]) {
      (question as Map).remove('concept_id');
      question.remove('concept_label');
    }
    final fallback = NorieTopicContent.fromJson(json);
    final graph = NorieSkillGraph.fromTopics([fallback]);
    expect(graph.skillsForTopic(fallback.id), {'${fallback.id}.core'});
    expect(graph.nodes['${fallback.id}.core']!.label, fallback.title);
    expect(() => graph.topicSkills[fallback.id]!.add('bad'),
        throwsUnsupportedError);
  });

  test('unknown topics are not reported ready and have no invented skills', () {
    final empty = NorieSkillGraph.fromTopics(const []);
    expect(empty.skillsForTopic('unknown'), isEmpty);
    expect(empty.isTopicReady('unknown', const {}), isFalse);
  });
  test('repeated concepts never introduce a self prerequisite', () {
    final source =
        NorieAdditionalSubjectCurriculum.topicsFor('Filipino', 'g1').first;
    final graph = NorieSkillGraph.fromTopics(
        [changed(source, 'a', null), changed(source, 'b', 'a')]);
    for (final node in graph.nodes.values) {
      expect(node.prerequisiteSkillIds, isNot(contains(node.id)));
      expect(() => node.topicIds.add('bad'), throwsUnsupportedError);
      expect(
          () => node.prerequisiteSkillIds.add('bad'), throwsUnsupportedError);
    }
  });
  test('cycles and missing prerequisites terminate with bounded known skills',
      () {
    final source = NorieAdditionalSubjectCurriculum.topicsFor('Filipino', 'g1');
    final graph = NorieSkillGraph.fromTopics([
      changed(source[0], 'a', 'b'),
      changed(source[1], 'b', 'a'),
      changed(source[2], 'c', 'missing')
    ]);
    expect(graph.unmetPrerequisitesForTopic('a', const {}).length,
        lessThanOrEqualTo(graph.nodes.length));
    expect(graph.isTopicReady('c', const {}), isTrue);
    expect(graph.masteredSkillsFromCompletedTopics({'missing'}), isEmpty);
    expect(
        graph.isTopicReady(
            'a', graph.masteredSkillsFromCompletedTopics({'a', 'b'})),
        isTrue);
  });

  final topics = NorieAdditionalSubjectCurriculum.topicsFor('Filipino', 'g1');
  final graph = NorieSkillGraph.fromTopics(topics);

  test('skill graph derives authored concept nodes', () {
    expect(graph.nodes, isNotEmpty);
    expect(graph.nodes.containsKey('filipino.g1.titik-tunog'), isTrue);
    expect(graph.skillsForTopic(topics.first.id),
        contains('filipino.g1.titik-tunog'));
  });

  test('next lesson skill depends on prerequisite lesson skill', () {
    final firstSkills = graph.skillsForTopic(topics[0].id);
    final secondSkills = graph.skillsForTopic(topics[1].id);
    expect(secondSkills, isNotEmpty);
    for (final skillId in secondSkills) {
      expect(
          graph.nodes[skillId]!.prerequisiteSkillIds, containsAll(firstSkills));
    }
  });

  test(
      'completed topics convert into mastered skills and unlock the next topic',
      () {
    final mastered = graph.masteredSkillsFromCompletedTopics({topics.first.id});
    expect(graph.isTopicReady(topics[1].id, mastered), isTrue);
    expect(graph.isTopicReady(topics[2].id, mastered), isFalse);
  });
}
