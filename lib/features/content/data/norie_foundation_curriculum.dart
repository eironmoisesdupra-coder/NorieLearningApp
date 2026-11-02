import '../domain/norie_content_models.dart';
import '../domain/norie_curriculum_depth.dart';
import 'additional_subjects/norie_additional_subject_curriculum.dart';
import 'authored/authored_subject_curriculum.dart';
import 'authored/core_english_curriculum.dart';
import 'authored/core_mathematics_curriculum.dart';
import 'norie_grade1_math_curriculum.dart';
import 'norie_grade1_science_curriculum.dart';
import 'science/science_curriculum.dart';
import 'science/science_expansion.dart';
import 'standards/ched_general_education.dart';
import 'standards/deped_english.dart';
import 'standards/deped_mathematics.dart';
import 'standards/deped_senior_high.dart';
import 'standards/deped_science.dart';

class NorieGradeLevel {
  const NorieGradeLevel(this.id, this.label, this.shortLabel);
  final String id;
  final String label;
  final String shortLabel;
}

abstract final class NorieFoundationCurriculum {
  static const gradeLevels = <NorieGradeLevel>[
    NorieGradeLevel('g1', 'Grade 1', 'G1'),
    NorieGradeLevel('g2', 'Grade 2', 'G2'),
    NorieGradeLevel('g3', 'Grade 3', 'G3'),
    NorieGradeLevel('g4', 'Grade 4', 'G4'),
    NorieGradeLevel('g5', 'Grade 5', 'G5'),
    NorieGradeLevel('g6', 'Grade 6', 'G6'),
    NorieGradeLevel('g7', 'Grade 7', 'G7'),
    NorieGradeLevel('g8', 'Grade 8', 'G8'),
    NorieGradeLevel('g9', 'Grade 9', 'G9'),
    NorieGradeLevel('g10', 'Grade 10', 'G10'),
    NorieGradeLevel('g11', 'Grade 11', 'G11'),
    NorieGradeLevel('g12', 'Grade 12', 'G12'),
    NorieGradeLevel('college', 'College', 'College'),
  ];

  static const supportedSubjects = [
    'Mathematics',
    'Science',
    'English',
    'Filipino',
    'Araling Panlipunan',
  ];

  static final Set<String> _authoredIds = {
    ...depedEnglish.values.expand((topics) => topics).map((topic) => topic.id),
    ...depedScience.values.expand((topics) => topics).map((topic) => topic.id),
    ...DepedSeniorHigh.topics.values
        .expand((grades) => grades.values)
        .expand((topics) => topics)
        .map((topic) => topic.id),
    ...depedMathematics.values
        .expand((topics) => topics)
        .map((topic) => topic.id),
    ...ChedGeneralEducation.topics.values
        .expand((topics) => topics)
        .map((topic) => topic.id),
    ...NorieGrade1ScienceCurriculum.topics.map((topic) => topic.id),
    ...ScienceCurriculum.grades.values
        .expand((topics) => topics)
        .map((topic) => topic.id),
    ...ScienceExpansion.lessons.values.map((topic) => topic.id),
    ...NorieGrade1MathCurriculum.topics.map((topic) => topic.id),
    ...AuthoredSubjectCurriculum.mathematics.values.map((topic) => topic.id),
    ...AuthoredSubjectCurriculum.english.values.map((topic) => topic.id),
    ...CoreEnglishCurriculum.grades.values
        .expand((topics) => topics)
        .map((topic) => topic.id),
    ...CoreMathematicsCurriculum.grades.values
        .expand((topics) => topics)
        .map((topic) => topic.id),
    ...NorieAdditionalSubjectCurriculum.allTopics.map((topic) => topic.id),
  };

  static bool isAuthored(NorieTopicContent topic) =>
      _authoredIds.contains(topic.id);

  static String coverageLabel(String subject, String gradeId) =>
      '${topicsFor(subject, gradeId).length} authored lessons';

  static List<NorieGradeLevel> availableGradeLevels(String subject) {
    final normalized = subject.toLowerCase();
    if (!supportedSubjects.any((item) => item.toLowerCase() == normalized)) {
      return const [];
    }
    final additionalGrades =
        NorieAdditionalSubjectCurriculum.gradeIdsFor(subject);
    return List.unmodifiable(gradeLevels.where((grade) =>
        additionalGrades.isEmpty || additionalGrades.contains(grade.id)));
  }

  static bool supportsAdventureMap(String subject) => supportedSubjects
      .any((item) => item.toLowerCase() == subject.toLowerCase());

  static List<String> lessonTitles(String subject, String gradeId) =>
      List.unmodifiable(
          topicsFor(subject, gradeId).map((topic) => topic.title));

  static List<String> sourcesFor(String subject, String gradeId) {
    if (!availableGradeLevels(subject).any((grade) => grade.id == gradeId)) {
      return const [];
    }
    if (gradeId == 'college') return ChedGeneralEducation.sources;
    if (gradeId == 'g11' || gradeId == 'g12') {
      return DepedSeniorHigh.sourcesFor(gradeId);
    }
    if (subject.toLowerCase() == 'mathematics') {
      return List.unmodifiable([
        ...?depedMathematicsSources[gradeId],
        ...?depedMathematicsCoverageNotes['all'],
        ...?depedMathematicsCoverageNotes[gradeId],
      ]);
    }
    if (subject.toLowerCase() == 'science') {
      return depedScienceSources[gradeId] ?? const [];
    }
    if (subject.toLowerCase() == 'english') {
      return depedEnglishSources[gradeId] ?? const [];
    }
    return const [];
  }

  static List<NorieTopicContent> topicsFor(String subject, String gradeId) {
    if (!availableGradeLevels(subject).any((grade) => grade.id == gradeId)) {
      return const [];
    }
    final additional =
        NorieAdditionalSubjectCurriculum.topicsFor(subject, gradeId);
    if (additional.isNotEmpty) {
      return _finalizePath(subject, gradeId, additional);
    }
    final normalized = subject.toLowerCase();
    final canonicalSubject = supportedSubjects
        .firstWhere((item) => item.toLowerCase() == normalized);
    final school = switch (normalized) {
      'mathematics' => depedMathematics,
      'science' => depedScience,
      'english' => depedEnglish,
      _ => null,
    };
    final replacement = switch (gradeId) {
      'college' => ChedGeneralEducation.topics[canonicalSubject],
      'g11' || 'g12' => DepedSeniorHigh.topics[canonicalSubject]?[gradeId],
      _ => school?[gradeId],
    };
    if (replacement == null) {
      throw StateError(
          'No authored curriculum registered for $subject/$gradeId.');
    }
    return _finalizePath(subject, gradeId, replacement);
  }

  static List<NorieTopicContent> _finalizePath(
    String subject,
    String gradeId,
    List<NorieTopicContent> topics,
  ) {
    NorieCurriculumDepth.validate(
      subject: subject,
      gradeId: gradeId,
      count: topics.length,
    );
    if (topics.any((topic) => !isAuthored(topic))) {
      throw StateError(
          '$subject/$gradeId contains unpublished lesson content.');
    }
    return List.unmodifiable(topics);
  }
}
