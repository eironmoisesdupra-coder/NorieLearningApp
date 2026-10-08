import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_grade_map.dart';

void main() {
  final topics = NorieFoundationCurriculum.topicsFor('Science', 'g6');

  test(
      'new Science grade map starts at the first real lesson without locking access',
      () {
    final map = NorieGradeMapProgress.derive(
      topics: topics,
      completedTopicIds: const {},
    );
    expect(map.nodes, hasLength(5));
    expect(map.currentIndex, 0);
    expect(map.nodes.first.state, NorieGradeMapNodeState.current);
    expect(
      map.nodes.skip(1).every(
            (node) => node.state == NorieGradeMapNodeState.available,
          ),
      isTrue,
    );
    expect(map.nodes.every((node) => node.canOpen), isTrue);
  });

  test('completion IDs derive completed and current map nodes', () {
    final completed = {topics[0].id, topics[1].id};
    final map = NorieGradeMapProgress.derive(
      topics: topics,
      completedTopicIds: completed,
    );
    expect(map.completedCount, 2);
    expect(map.nodes[0].state, NorieGradeMapNodeState.completed);
    expect(map.nodes[1].state, NorieGradeMapNodeState.completed);
    expect(map.nodes[2].state, NorieGradeMapNodeState.current);
  });

  test('saved unfinished lesson becomes the current position', () {
    final map = NorieGradeMapProgress.derive(
      topics: topics,
      completedTopicIds: {topics[0].id},
      lastTopicId: topics[3].id,
    );
    expect(map.currentIndex, 3);
    expect(map.nodes[3].state, NorieGradeMapNodeState.current);
    expect(map.nodes[1].state, NorieGradeMapNodeState.available);
  });

  test('all completed lessons produce a complete grade map', () {
    final map = NorieGradeMapProgress.derive(
      topics: topics,
      completedTopicIds: topics.map((topic) => topic.id).toSet(),
    );
    expect(map.complete, isTrue);
    expect(map.completedCount, topics.length);
    expect(
      map.nodes.every((node) => node.state == NorieGradeMapNodeState.completed),
      isTrue,
    );
  });
}
