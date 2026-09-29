enum NorieAppArea {
  home,
  learn,
  challenge,
  progress,
  profile,
  lesson,
  anatomy,
  study,
  quiz,
  results,
  unknown,
}

class NorieContextSnapshot {
  const NorieContextSnapshot({
    required this.area,
    this.title,
    this.topic,
    this.sourceId,
  });

  const NorieContextSnapshot.home()
      : area = NorieAppArea.home,
        title = 'Home',
        topic = null,
        sourceId = null;

  final NorieAppArea area;
  final String? title;
  final String? topic;
  final String? sourceId;

  NorieContextSnapshot copyWith({
    NorieAppArea? area,
    String? title,
    String? topic,
    String? sourceId,
  }) {
    return NorieContextSnapshot(
      area: area ?? this.area,
      title: title ?? this.title,
      topic: topic ?? this.topic,
      sourceId: sourceId ?? this.sourceId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NorieContextSnapshot &&
        other.area == area &&
        other.title == title &&
        other.topic == topic &&
        other.sourceId == sourceId;
  }

  @override
  int get hashCode => Object.hash(area, title, topic, sourceId);
}
