import '../data/norie_foundation_curriculum.dart';
import 'norie_content_models.dart';

/// A read-only view of the authored paths that are actually shipped offline.
class NorieSubjectWorld {
  const NorieSubjectWorld({required this.subject, required this.grades});

  final String subject;
  final List<NorieWorldGrade> grades;
  int get total => grades.fold(0, (count, grade) => count + grade.total);
  int get completed =>
      grades.fold(0, (count, grade) => count + grade.completed);

  static List<NorieSubjectWorld> build({
    required bool Function(String topicId) isCompleted,
  }) =>
      [
        for (final subject in NorieFoundationCurriculum.supportedSubjects)
          NorieSubjectWorld(subject: subject, grades: [
            for (final grade
                in NorieFoundationCurriculum.availableGradeLevels(subject))
              NorieWorldGrade(
                grade: grade,
                topics: NorieFoundationCurriculum.topicsFor(subject, grade.id)
                    .where((topic) =>
                        topic.available &&
                        NorieFoundationCurriculum.isAuthored(topic))
                    .toList(growable: false),
                isCompleted: isCompleted,
              ),
          ]),
      ];
}

class NorieWorldGrade {
  NorieWorldGrade({
    required this.grade,
    required List<NorieTopicContent> topics,
    required bool Function(String topicId) isCompleted,
  })  : total = topics.length,
        completed = topics.where((topic) => isCompleted(topic.id)).length;

  final NorieGradeLevel grade;
  final int total;
  final int completed;
}
