import '../../domain/norie_content_models.dart';
import '../authored_topic_builder.dart';

/// Keep the original Science assembly API and assessment policy stable.
NorieTopicContent scienceTopic({
  required String grade,
  required int order,
  required String title,
  required String subtitle,
  required String minutes,
  required List<String> objectives,
  required String introduction,
  required List<NorieLessonSection> sections,
  required String keyConcept,
  required List<List<String>> questions,
  required String? prerequisiteTopicId,
  int practiceQuestionCount = 20,
}) =>
    authoredTopic(
      subject: 'Science',
      accent: 'green',
      visualType: 'science-path',
      grade: grade,
      order: order,
      title: title,
      subtitle: subtitle,
      minutes: minutes,
      objectives: objectives,
      introduction: introduction,
      sections: sections,
      keyConcept: keyConcept,
      questions: questions,
      prerequisiteTopicId: prerequisiteTopicId,
      practiceQuestionCount: practiceQuestionCount,
    );

NorieLessonSection scienceSection(String title, String body,
        {bool reveal = false}) =>
    NorieLessonSection(
        title: title,
        symbol: '',
        accent: 'green',
        points: const [],
        body: body,
        reveal: reveal);

NorieLessonSection scienceVisual(String id, String caption) =>
    NorieLessonSection(
        title: 'Diagram',
        symbol: '',
        accent: 'green',
        points: const [],
        visualType: id,
        visualCaption: caption);
