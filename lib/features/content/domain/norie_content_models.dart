class NorieSubjectContent {
  const NorieSubjectContent({
    required this.id,
    required this.title,
    required this.description,
    required this.categories,
  });

  final String id;
  final String title;
  final String description;
  final List<NorieCategoryContent> categories;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'categories': categories.map((item) => item.toJson()).toList(),
      };

  factory NorieSubjectContent.fromJson(Map<String, dynamic> json) {
    return NorieSubjectContent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      categories: (json['categories'] as List? ?? const [])
          .map(
            (item) => NorieCategoryContent.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}

class NorieCategoryContent {
  const NorieCategoryContent({
    required this.id,
    required this.title,
    required this.description,
    required this.topics,
  });

  final String id;
  final String title;
  final String description;
  final List<NorieTopicContent> topics;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'topics': topics.map((item) => item.toJson()).toList(),
      };

  factory NorieCategoryContent.fromJson(Map<String, dynamic> json) {
    return NorieCategoryContent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      topics: (json['topics'] as List? ?? const [])
          .map(
            (item) => NorieTopicContent.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}

class NorieTopicContent {
  const NorieTopicContent({
    required this.id,
    required this.subject,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.order,
    required this.accent,
    required this.lesson,
    required this.quiz,
    required this.challenge,
    this.available = true,
    this.prerequisiteTopicId,
    this.gradeLevel,
    this.visualType,
  });

  final String id;
  final String subject;
  final String category;
  final String title;
  final String subtitle;
  final int order;
  final String accent;
  final NorieLessonContent lesson;
  final NorieQuizContent quiz;
  final NorieChallengeContent challenge;
  final bool available;
  final String? prerequisiteTopicId;
  final String? gradeLevel;
  final String? visualType;

  int get totalAssessmentAttempts =>
      quiz.questions.length + challenge.rounds.length;

  Map<String, dynamic> toJson() => {
        'schema_version': 1,
        'id': id,
        'subject': subject,
        'category': category,
        'title': title,
        'subtitle': subtitle,
        'order': order,
        'accent': accent,
        'available': available,
        'prerequisite_topic_id': prerequisiteTopicId,
        'grade_level': gradeLevel,
        'visual_type': visualType,
        'lesson': lesson.toJson(),
        'quiz': quiz.toJson(),
        'challenge': challenge.toJson(),
      };

  factory NorieTopicContent.fromJson(Map<String, dynamic> json) {
    return NorieTopicContent(
      id: json['id'] as String,
      subject: json['subject'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      accent: json['accent'] as String? ?? 'cyan',
      available: json['available'] as bool? ?? true,
      prerequisiteTopicId: json['prerequisite_topic_id'] as String?,
      gradeLevel: json['grade_level'] as String?,
      visualType: json['visual_type'] as String?,
      lesson: NorieLessonContent.fromJson(
        Map<String, dynamic>.from(json['lesson'] as Map),
      ),
      quiz: NorieQuizContent.fromJson(
        Map<String, dynamic>.from(json['quiz'] as Map),
      ),
      challenge: NorieChallengeContent.fromJson(
        Map<String, dynamic>.from(json['challenge'] as Map),
      ),
    );
  }
}

class NorieLessonContent {
  const NorieLessonContent({
    required this.heading,
    required this.introduction,
    required this.sections,
    required this.keyConceptTitle,
    required this.keyConceptBody,
    this.completionXp = 50,
  });

  final String heading;
  final String introduction;
  final List<NorieLessonSection> sections;
  final String keyConceptTitle;
  final String keyConceptBody;
  final int completionXp;

  Map<String, dynamic> toJson() => {
        'heading': heading,
        'introduction': introduction,
        'sections': sections.map((item) => item.toJson()).toList(),
        'key_concept_title': keyConceptTitle,
        'key_concept_body': keyConceptBody,
        'completion_xp': completionXp,
      };

  factory NorieLessonContent.fromJson(Map<String, dynamic> json) {
    return NorieLessonContent(
      heading: json['heading'] as String,
      introduction: json['introduction'] as String? ?? '',
      sections: (json['sections'] as List? ?? const [])
          .map(
            (item) => NorieLessonSection.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      keyConceptTitle: json['key_concept_title'] as String? ?? '',
      keyConceptBody: json['key_concept_body'] as String? ?? '',
      completionXp: (json['completion_xp'] as num?)?.toInt() ?? 50,
    );
  }
}

class NorieLessonSection {
  const NorieLessonSection({
    required this.title,
    required this.symbol,
    required this.points,
    this.accent = 'cyan',
    this.body,
    this.visualType,
    this.visualCaption,
    this.reveal = false,
  });

  final String title;
  final String symbol;
  final List<String> points;
  final String accent;
  final String? body;
  final String? visualType;
  final String? visualCaption;
  final bool reveal;

  Map<String, dynamic> toJson() => {
        'title': title,
        'symbol': symbol,
        'points': points,
        'accent': accent,
        if (body != null) 'body': body,
        if (visualType != null) 'visual_type': visualType,
        if (visualCaption != null) 'visual_caption': visualCaption,
        'reveal': reveal,
      };

  factory NorieLessonSection.fromJson(Map<String, dynamic> json) {
    return NorieLessonSection(
      title: json['title'] as String,
      symbol: json['symbol'] as String? ?? '',
      points: List<String>.from(json['points'] as List? ?? const []),
      accent: json['accent'] as String? ?? 'cyan',
      body: json['body'] as String?,
      visualType: json['visual_type'] as String?,
      visualCaption: json['visual_caption'] as String?,
      reveal: json['reveal'] as bool? ?? false,
    );
  }
}

class NorieQuizContent {
  const NorieQuizContent({
    required this.questions,
    this.xpPerCorrect = 20,
  });

  final List<NorieQuestionContent> questions;
  final int xpPerCorrect;

  Map<String, dynamic> toJson() => {
        'xp_per_correct': xpPerCorrect,
        'questions': questions.map((item) => item.toJson()).toList(),
      };

  factory NorieQuizContent.fromJson(Map<String, dynamic> json) {
    return NorieQuizContent(
      xpPerCorrect: (json['xp_per_correct'] as num?)?.toInt() ?? 20,
      questions: (json['questions'] as List? ?? const [])
          .map(
            (item) => NorieQuestionContent.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}

class NorieQuestionContent {
  const NorieQuestionContent({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.difficulty = 'foundation',
    this.acceptedAnswers = const <String>[],
    this.orderedItems = const <String>[],
    this.conceptId,
    this.conceptLabel,
  });

  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String difficulty;
  final List<String> acceptedAnswers;
  final List<String> orderedItems;
  final String? conceptId;
  final String? conceptLabel;

  List<String> get resolvedAcceptedAnswers {
    if (acceptedAnswers.isNotEmpty) return acceptedAnswers;
    if (!hasValidAnswer) return const <String>[];
    return <String>[options[correctIndex]];
  }

  bool get hasValidAnswer =>
      options.isNotEmpty && correctIndex >= 0 && correctIndex < options.length;

  Map<String, dynamic> toJson() => {
        'id': id,
        'prompt': prompt,
        'options': options,
        'correct_index': correctIndex,
        'explanation': explanation,
        'difficulty': difficulty,
        'accepted_answers': acceptedAnswers,
        'ordered_items': orderedItems,
        if (conceptId != null) 'concept_id': conceptId,
        if (conceptLabel != null) 'concept_label': conceptLabel,
      };

  factory NorieQuestionContent.fromJson(Map<String, dynamic> json) {
    return NorieQuestionContent(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      options: List<String>.from(json['options'] as List? ?? const []),
      correctIndex: (json['correct_index'] as num?)?.toInt() ?? 0,
      explanation: json['explanation'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? 'foundation',
      acceptedAnswers:
          List<String>.from(json['accepted_answers'] as List? ?? const []),
      orderedItems:
          List<String>.from(json['ordered_items'] as List? ?? const []),
      conceptId: json['concept_id'] as String?,
      conceptLabel: json['concept_label'] as String?,
    );
  }
}

class NorieChallengeContent {
  const NorieChallengeContent({
    required this.title,
    required this.description,
    required this.rounds,
    this.xpPerCorrect = 25,
  });

  final String title;
  final String description;
  final List<NorieQuestionContent> rounds;
  final int xpPerCorrect;

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'xp_per_correct': xpPerCorrect,
        'rounds': rounds.map((item) => item.toJson()).toList(),
      };

  factory NorieChallengeContent.fromJson(Map<String, dynamic> json) {
    return NorieChallengeContent(
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      xpPerCorrect: (json['xp_per_correct'] as num?)?.toInt() ?? 25,
      rounds: (json['rounds'] as List? ?? const [])
          .map(
            (item) => NorieQuestionContent.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }
}
