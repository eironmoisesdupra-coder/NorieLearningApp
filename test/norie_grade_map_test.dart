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
    expect(map.nodes, hasLength(topics.length));
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

  test('variable chapter ranges cover legacy and six-to-twenty missions once',
      () {
    final path = NorieFoundationCurriculum.gradeLevels
        .expand(
            (grade) => NorieFoundationCurriculum.topicsFor('Science', grade.id))
        .toList();
    for (final length in [5, 6, 7, 8, 10, 19, 20]) {
      final map = NorieGradeMapProgress.derive(
        topics: path.take(length).toList(),
        completedTopicIds: const {},
      );
      expect(map.chapters.expand((chapter) => chapter.nodes),
          orderedEquals(map.nodes));
      expect(map.chapters.length, (length / 5).ceil());
      final saved = NorieGradeMapProgress.derive(
        topics: path.take(length).toList(),
        completedTopicIds:
            path.take(length - 1).map((topic) => topic.id).toSet(),
        lastTopicId: path[length - 1].id,
      );
      expect(saved.completedCount, length - 1);
      expect(saved.currentIndex, length - 1);
      expect(saved.nodes.last.state, NorieGradeMapNodeState.current);
      expect(saved.chapters.last.nodes.length, (length - 1) % 5 + 1);
      expect(saved.complete, isFalse);

      expect(map.chapters.every((chapter) => chapter.description.isNotEmpty),
          isTrue);
      expect(map.nodes.every((node) => node.canOpen), isTrue);
    }
  });
}
