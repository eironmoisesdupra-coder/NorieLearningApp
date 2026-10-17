import 'curriculum_quality.dart';
import '../data/norie_foundation_curriculum.dart';
import '../data/authored/authored_subject_curriculum.dart';
import '../data/science/science_curriculum.dart';
import '../domain/norie_content_models.dart';

/// Scan the same publication paths the offline learning UI exposes.
/// No Flutter dependency: runnable with the bundled Dart SDK in CI.
CurriculumQualityReport scanPublishedCurriculum(
    {bool Function(String)? assetExists}) {
  final topics = <NorieTopicContent>[];
  final publications = <CurriculumPublication>[];
  final failures = <CurriculumQualityIssue>[];
  for (final subject in NorieFoundationCurriculum.supportedSubjects) {
    for (final grade
        in NorieFoundationCurriculum.availableGradeLevels(subject)) {
      try {
        final path = NorieFoundationCurriculum.topicsFor(subject, grade.id);
        topics.addAll(path);
        publications.addAll(
            path.map((t) => CurriculumPublication(t.id, subject, grade.id)));
      } catch (error) {
        failures.add(CurriculumQualityIssue('publication_load_failure',
            '$subject/${grade.id}', error.toString()));
      }
    }
  }
  for (final visual in AuthoredSubjectCurriculum.visuals.entries) {
    try {
      visual.value.validate();
    } catch (error) {
      failures.add(CurriculumQualityIssue(
          'invalid_figure', visual.key, error.toString()));
    }
  }
  for (final figure in ScienceCurriculum.figures.entries) {
    try {
      figure.value.validate();
    } catch (error) {
      failures.add(CurriculumQualityIssue(
          'invalid_figure', figure.key, error.toString()));
    }
  }
  final report = CurriculumQualityScanner().scan(
    topics: topics,
    publications: publications,
    authoredTopicIds: topics
        .where(NorieFoundationCurriculum.isAuthored)
        .map((t) => t.id)
        .toSet(),
    visualIds: {
      ...AuthoredSubjectCurriculum.visuals.keys,
      ...ScienceCurriculum.figures.keys,
      // Topic banners and Grade 1 procedural renderers (not file assets).
      'authored-path', 'science-path', 'g1-science', 'math', 'language',
      'science', 'atom',
      for (var i = 1; i <= 3; i++) 'science-1-$i', 'science-1-sort',
      for (var i = 1; i <= 7; i++) 'science-2-$i', 'science-2-sort',
      for (var i = 1; i <= 4; i++) 'science-3-$i',
      'science-3-apple', 'science-3-jobs', 'science-3-safety',
      for (var i = 1; i <= 6; i++) 'science-4-$i',
      'science-4-clothing', 'science-4-safety', 'science-4-sort',
      for (var i = 1; i <= 8; i++) 'science-5-$i',
    },
    assetExists: assetExists,
  );
  return CurriculumQualityReport(report.topicCount,
      List.unmodifiable([...failures, ...report.errors]), report.warnings);
}
