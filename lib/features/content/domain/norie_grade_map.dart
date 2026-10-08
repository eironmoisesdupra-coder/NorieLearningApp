import 'norie_content_models.dart';

enum NorieGradeMapNodeState { completed, current, available, locked }

class NorieGradeMapNode {
  const NorieGradeMapNode({
    required this.topic,
    required this.state,
    required this.index,
  });

  final NorieTopicContent topic;
  final NorieGradeMapNodeState state;
  final int index;

  bool get canOpen => topic.available;
  bool get completed => state == NorieGradeMapNodeState.completed;
}

class NorieGradeMapProgress {
  const NorieGradeMapProgress({
    required this.nodes,
    required this.completedCount,
    required this.currentIndex,
  });

  final List<NorieGradeMapNode> nodes;
  final int completedCount;
  final int currentIndex;

  bool get complete => nodes.isNotEmpty && completedCount == nodes.length;

  /// Chapters organize real lessons, without adding locks or synthetic tests.
  List<NorieGradeMapChapter> get chapters => [
        for (var start = 0; start < nodes.length; start += 5)
          NorieGradeMapChapter(
            number: start ~/ 5 + 1,
            nodes: List.unmodifiable(nodes.skip(start).take(5)),
          ),
      ];

  static NorieGradeMapProgress derive({
    required List<NorieTopicContent> topics,
    required Set<String> completedTopicIds,
    String? lastTopicId,
  }) {
    var currentIndex = -1;
    final lastIndex = topics.indexWhere((topic) => topic.id == lastTopicId);
    if (lastIndex >= 0 &&
        topics[lastIndex].available &&
        !completedTopicIds.contains(topics[lastIndex].id)) {
      currentIndex = lastIndex;
    }
    if (currentIndex < 0) {
      currentIndex = topics.indexWhere(
        (topic) => topic.available && !completedTopicIds.contains(topic.id),
      );
    }
    if (currentIndex < 0 && topics.isNotEmpty) {
      currentIndex = topics.lastIndexWhere((topic) => topic.available);
    }

    final nodes = <NorieGradeMapNode>[
      for (var i = 0; i < topics.length; i++)
        NorieGradeMapNode(
          topic: topics[i],
          index: i,
          state: !topics[i].available
              ? NorieGradeMapNodeState.locked
              : completedTopicIds.contains(topics[i].id)
                  ? NorieGradeMapNodeState.completed
                  : i == currentIndex
                      ? NorieGradeMapNodeState.current
                      : NorieGradeMapNodeState.available,
        ),
    ];

    return NorieGradeMapProgress(
      nodes: List.unmodifiable(nodes),
      completedCount: nodes.where((node) => node.completed).length,
      currentIndex: currentIndex,
    );
  }
}

class NorieGradeMapChapter {
  const NorieGradeMapChapter({required this.number, required this.nodes});

  final int number;
  final List<NorieGradeMapNode> nodes;
  int get completedCount => nodes.where((node) => node.completed).length;
  String get description =>
      'Missions ${nodes.first.index + 1}–${nodes.last.index + 1}: '
      '${nodes.map((node) => node.topic.title).join('; ')}. '
      'Practice within each lesson, then use its authored mastery questions. '
      'This checkpoint is a progress summary.';
}
