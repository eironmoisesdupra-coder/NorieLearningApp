enum NorieStudyGenerationMode {
  multipleChoice('multiple_choice', 'Multiple Choice'),
  trueFalse('true_false', 'True / False'),
  identification('identification', 'Identification'),
  matching('matching', 'Matching'),
  dragAndDrop('drag_drop', 'Drag & Drop'),
  ordering('ordering', 'Ordering'),
  fillInBlank('fill_blank', 'Fill in the Blank'),
  flashcards('flashcards', 'Flashcards'),
  mixed('mixed', 'Random Mix');

  const NorieStudyGenerationMode(this.wireValue, this.label);
  final String wireValue;
  final String label;

  static NorieStudyGenerationMode fromWire(String value) {
    return values.firstWhere(
      (item) => item.wireValue == value,
      orElse: () => mixed,
    );
  }
}

enum NorieStudyQuestionKind {
  singleSelect('single_select'),
  trueFalse('true_false'),
  identification('identification'),
  matching('matching'),
  dragAndDrop('drag_drop'),
  ordering('ordering'),
  fillInBlank('fill_blank'),
  flashcard('flashcard');

  const NorieStudyQuestionKind(this.wireValue);
  final String wireValue;

  static NorieStudyQuestionKind fromWire(String value) {
    return values.firstWhere(
      (item) => item.wireValue == value,
      orElse: () => singleSelect,
    );
  }
}

class NorieStudyQuestion {
  const NorieStudyQuestion({
    required this.id,
    required this.position,
    required this.kind,
    required this.prompt,
    required this.options,
    required this.correctValues,
    required this.explanation,
    required this.sourceExcerpt,
    required this.difficulty,
    this.topicTag,
    this.orderedItems = const <String>[],
  });

  final String id;
  final int position;
  final NorieStudyQuestionKind kind;
  final String prompt;
  final List<String> options;
  final List<String> correctValues;
  final String explanation;
  final String sourceExcerpt;
  final String difficulty;
  final String? topicTag;
  final List<String> orderedItems;

  Map<String, dynamic> toMap() => {
        'id': id,
        'position': position,
        'kind': kind.wireValue,
        'prompt': prompt,
        'options': options,
        'correct_values': correctValues,
        'explanation': explanation,
        'source_excerpt': sourceExcerpt,
        'difficulty': difficulty,
        'topic_tag': topicTag,
        'ordered_items': orderedItems,
      };

  factory NorieStudyQuestion.fromMap(Map<String, dynamic> map) {
    return NorieStudyQuestion(
      id: map['id'].toString(),
      position: (map['position'] as num?)?.toInt() ?? 0,
      kind: NorieStudyQuestionKind.fromWire(
        map['kind']?.toString() ?? 'single_select',
      ),
      prompt: map['prompt']?.toString() ?? '',
      options: List<String>.from(map['options'] as List? ?? const []),
      correctValues:
          List<String>.from(map['correct_values'] as List? ?? const []),
      explanation: map['explanation']?.toString() ?? '',
      sourceExcerpt: map['source_excerpt']?.toString() ?? '',
      topicTag: map['topic_tag']?.toString(),
      difficulty: map['difficulty']?.toString() ?? 'foundation',
      orderedItems:
          List<String>.from(map['ordered_items'] as List? ?? const []),
    );
  }
}

class NorieStudySet {
  const NorieStudySet({
    required this.id,
    required this.title,
    required this.sourceType,
    required this.sourceName,
    required this.mode,
    required this.requestedCount,
    required this.status,
    required this.createdAt,
    required this.questions,
    this.topicTag,
    this.aiModel,
    this.ownerId,
  });

  final String id;
  final String title;
  final String sourceType;
  final String? sourceName;
  final NorieStudyGenerationMode mode;
  final int requestedCount;
  final String status;
  final String? topicTag;
  final String? aiModel;
  final String? ownerId;
  final DateTime createdAt;
  final List<NorieStudyQuestion> questions;

  int get itemCount => questions.length;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'source_type': sourceType,
        'source_name': sourceName,
        'generation_mode': mode.wireValue,
        'requested_count': requestedCount,
        'status': status,
        'topic_tag': topicTag,
        'ai_model': aiModel,
        'user_id': ownerId,
        'created_at': createdAt.toIso8601String(),
        'questions': questions.map((question) => question.toMap()).toList(),
      };

  factory NorieStudySet.fromMap(
    Map<String, dynamic> map, {
    List<NorieStudyQuestion> questions = const [],
  }) {
    return NorieStudySet(
      id: map['id'].toString(),
      title: map['title']?.toString() ?? 'Study Set',
      sourceType: map['source_type']?.toString() ?? 'notes',
      sourceName: map['source_name']?.toString(),
      mode: NorieStudyGenerationMode.fromWire(
        map['generation_mode']?.toString() ?? 'mixed',
      ),
      requestedCount: (map['requested_count'] as num?)?.toInt() ?? 0,
      status: map['status']?.toString() ?? 'draft',
      topicTag: map['topic_tag']?.toString(),
      aiModel: map['ai_model']?.toString(),
      ownerId: map['user_id']?.toString(),
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      questions: questions,
    );
  }
}

class NorieStudyAttemptResult {
  const NorieStudyAttemptResult({
    required this.correct,
    required this.total,
    required this.xpAwarded,
    required this.firstRewardedCompletion,
  });

  final int correct;
  final int total;
  final int xpAwarded;
  final bool firstRewardedCompletion;

  double get accuracy => total == 0 ? 0 : correct / total;
}

class NorieStudyAnswer {
  const NorieStudyAnswer({
    required this.question,
    required this.response,
    required this.correct,
  });

  final NorieStudyQuestion question;
  final String response;
  final bool correct;
}

class NorieAiQuota {
  const NorieAiQuota({
    required this.plan,
    required this.usageDate,
    required this.generationUsed,
    required this.generationLimit,
    required this.generationRemaining,
    required this.qaUsed,
    required this.qaLimit,
    required this.qaRemaining,
  });

  final String plan;
  final DateTime? usageDate;
  final int generationUsed;
  final int generationLimit;
  final int generationRemaining;
  final int qaUsed;
  final int qaLimit;
  final int qaRemaining;

  bool get canGenerate => generationRemaining > 0;
  bool get canAskNorie => qaRemaining > 0;

  factory NorieAiQuota.fromMap(Map<String, dynamic> map) {
    int readInt(String key) =>
        (map[key] as num?)?.toInt() ??
        int.tryParse(map[key]?.toString() ?? '') ??
        0;

    return NorieAiQuota(
      plan: map['plan']?.toString() ?? 'free',
      usageDate: DateTime.tryParse(map['usage_date']?.toString() ?? ''),
      generationUsed: readInt('generation_used'),
      generationLimit: readInt('generation_limit'),
      generationRemaining: readInt('generation_remaining'),
      qaUsed: readInt('qa_used'),
      qaLimit: readInt('qa_limit'),
      qaRemaining: readInt('qa_remaining'),
    );
  }
}
