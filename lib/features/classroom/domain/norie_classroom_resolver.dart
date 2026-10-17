import 'norie_classroom_fingerprint.dart';
import '../../content/data/norie_foundation_curriculum.dart';
import '../../content/domain/norie_content_models.dart';
import 'norie_classroom_models.dart';

abstract final class NorieClassroomResolver {
  static List<NorieTopicContent> topicsFor(String subject, String grade) =>
      NorieFoundationCurriculum.topicsFor(subject, grade)
          .where((t) => t.available && NorieFoundationCurriculum.isAuthored(t))
          .toList();
  static Map<String, NorieTopicContent> topicBank(NorieClassroomAssignment a) {
    if (!NorieFoundationCurriculum.supportedSubjects.contains(a.subject) ||
        !NorieFoundationCurriculum.availableGradeLevels(a.subject)
            .any((g) => g.id == a.gradeId)) {
      throw const FormatException('Unsupported classroom subject or grade.');
    }
    final all = {for (final t in topicsFor(a.subject, a.gradeId)) t.id: t};
    if (a.topicIds.any((id) => !all.containsKey(id))) {
      throw const FormatException(
          'Classroom topic is unavailable in this app.');
    }
    return {for (final id in a.topicIds) id: all[id]!};
  }

  static List<NorieQuestionContent> questionsFor(
      NorieClassroomAssignment assignment,
      {bool checkSignature = true}) {
    final a = NorieClassroomAssignment.fromJson(assignment.toJson());
    final topics = topicBank(a);
    final bank = <String, NorieQuestionContent>{};
    for (final t in topics.values) {
      for (final q in [...t.quiz.questions, ...t.challenge.rounds]) {
        if (q.hasValidAnswer) {
          final old = bank[q.id];
          if (old != null &&
              classroomCanonical(old.toJson()) !=
                  classroomCanonical(q.toJson())) {
            throw const FormatException('Ambiguous classroom question ID.');
          }
          bank[q.id] = q;
        }
      }
    }
    if (checkSignature &&
        a.catalogSignature.isNotEmpty &&
        a.catalogSignature != signature(a)) {
      throw const FormatException(
          'Classroom content version differs. Ask the teacher for an updated assignment.');
    }
    return List.unmodifiable(a.questionIds.map((id) {
      final q = bank[id];
      if (q == null) {
        throw FormatException('Classroom question is unavailable: $id');
      }
      return q;
    }));
  }

  static String signature(NorieClassroomAssignment a) =>
      classroomChecksum(classroomCanonical({
        'questions': questionsFor(a, checkSignature: false)
            .map((q) => q.toJson())
            .toList(),
        'lessons': topicBank(a).values.map((t) => t.lesson.toJson()).toList()
      }));
  static NorieClassroomAssignment withSignature(NorieClassroomAssignment a) =>
      NorieClassroomAssignment.fromJson(
          {...a.toJson(), 'catalog_signature': signature(a)});
  static NorieTopicContent topicForQuestion(
          NorieClassroomAssignment a, String id) =>
      topicBank(a).values.firstWhere((t) =>
          [...t.quiz.questions, ...t.challenge.rounds].any((q) => q.id == id));
  static NorieClassroomSubmission score(
      NorieClassroomAssignment a, NorieClassroomSubmission source) {
    final s = NorieClassroomSubmission.fromJson(source.toJson());
    final questions = questionsFor(a);
    if (s.assignmentId != a.id ||
        s.attemptNumber > a.maxAttempts ||
        s.responses.length != questions.length ||
        s.responses.keys.any((id) => !a.questionIds.contains(id))) {
      throw const FormatException('Submission does not match assignment.');
    }
    var correct = 0;
    for (final q in questions) {
      final response = s.responses[q.id];
      if (response == null || response < 0 || response >= q.options.length) {
        throw const FormatException('Invalid answer option.');
      }
      if (response == q.correctIndex) correct++;
    }
    return NorieClassroomSubmission(
        id: s.id,
        assignmentId: s.assignmentId,
        learnerAlias: s.learnerAlias,
        correct: correct,
        total: questions.length,
        responses: s.responses,
        completedAt: s.completedAt,
        attemptNumber: s.attemptNumber);
  }
}
