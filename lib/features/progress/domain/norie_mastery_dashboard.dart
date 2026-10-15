import '../../../core/progression/norie_adventure_progress.dart';
import '../../../core/progression/norie_progression.dart';
import '../../content/data/norie_foundation_curriculum.dart';
import '../../content/domain/norie_content_models.dart';

class NorieSubjectMasterySnapshot {
  const NorieSubjectMasterySnapshot(
      {required this.subject,
      required this.completed,
      required this.total,
      required this.mastered,
      required this.reviewDue,
      required this.priorityTopics,
      this.independent = 0,
      this.historicalRetained = 0,
      this.priorityCount = 0});
  final String subject;
  final int completed,
      total,
      mastered,
      reviewDue,
      independent,
      historicalRetained,
      priorityCount;
  final List<String> priorityTopics;
  double get completion => total == 0 ? 0 : completed / total;
}

class NorieMasteryDashboardSnapshot {
  const NorieMasteryDashboardSnapshot(
      {required this.subjects,
      required this.strongTopics,
      required this.priorityTopics,
      required this.retentionDue,
      required this.completedLessons,
      this.priorityLessons = const [],
      this.dueLessons = const [],
      this.strongLessons = const [],
      this.improvedLessons = const [],
      this.historicalRetainedLessons = const [],
      this.totalLessons = 0,
      this.availablePaths = 0});
  final List<NorieSubjectMasterySnapshot> subjects;
  final List<String> strongTopics, priorityTopics;
  final int retentionDue, completedLessons, totalLessons, availablePaths;
  final List<NorieTopicContent> priorityLessons,
      dueLessons,
      strongLessons,
      improvedLessons,
      historicalRetainedLessons;
}

/// A read-only view of published lesson evidence, never legacy XP counters.
abstract final class NorieMasteryDashboardPolicy {
  static const subjects = [
    'Science',
    'Mathematics',
    'English',
    'Filipino',
    'Araling Panlipunan'
  ];
  static NorieMasteryDashboardSnapshot derive(
      {NorieProgression? progression,
      NorieAdventureProgress? adventure,
      DateTime? at}) {
    final learning = progression ?? NorieProgression.instance;
    final evidence = adventure ?? NorieAdventureProgress.instance;
    final now = at ?? DateTime.now();
    final subjectSnapshots = <NorieSubjectMasterySnapshot>[];
    final priority = <NorieTopicContent>[],
        due = <NorieTopicContent>[],
        strong = <NorieTopicContent>[],
        improved = <NorieTopicContent>[],
        historical = <NorieTopicContent>[];
    var completedTotal = 0, total = 0, paths = 0;
    bool currentStrong(NorieLessonEvidence item) =>
        item.lastAttemptAt != null &&
        item.lastPercent >= NorieAdventureProgress.independentThreshold &&
        item.priorityConcepts.isEmpty;
    void newestFirst(List<NorieTopicContent> topics) => topics.sort((a, b) {
          final comparison = evidence
              .evidenceFor(b.id)!
              .lastAttemptAt!
              .compareTo(evidence.evidenceFor(a.id)!.lastAttemptAt!);
          return comparison == 0 ? a.id.compareTo(b.id) : comparison;
        });
    for (final subject in subjects) {
      final topics = <NorieTopicContent>[];
      for (final grade
          in NorieFoundationCurriculum.availableGradeLevels(subject)) {
        final available = NorieFoundationCurriculum.topicsFor(subject, grade.id)
            .where(
                (t) => t.available && NorieFoundationCurriculum.isAuthored(t))
            .toList();
        if (available.isNotEmpty) paths++;
        topics.addAll(available);
      }
      var completed = 0,
          retained = 0,
          independent = 0,
          reviewDue = 0,
          historicalCount = 0;
      final localPriority = <NorieTopicContent>[];
      for (final topic in topics) {
        if (learning.isTopicCompleted(topic.id)) completed++;
        final item = evidence.evidenceFor(topic.id);
        if (item == null ||
            item.lastAttemptAt == null ||
            item.lastAttemptAt!.isAfter(now) ||
            item.firstPassedAt?.isAfter(now) == true ||
            item.retainedAt?.isAfter(now) == true) {
          continue;
        }
        if (item.retainedAt != null) {
          historical.add(topic);
          historicalCount++;
        }
        final current = currentStrong(item);
        if (current && item.firstPassedAt != null) independent++;
        if (current && item.retainedAt != null) {
          retained++;
          strong.add(topic);
        }
        if (item.lastPercent < NorieAdventureProgress.independentThreshold ||
            item.priorityConcepts.isNotEmpty) {
          priority.add(topic);
          localPriority.add(topic);
        }
        if (evidence.isReviewDue(topic.id, at: now)) {
          due.add(topic);
          reviewDue++;
        }
        if (current && evidence.trophyIds.contains('improvement:${topic.id}')) {
          improved.add(topic);
        }
      }
      newestFirst(localPriority);
      subjectSnapshots.add(NorieSubjectMasterySnapshot(
          subject: subject,
          completed: completed,
          total: topics.length,
          mastered: retained,
          independent: independent,
          historicalRetained: historicalCount,
          priorityCount: localPriority.length,
          reviewDue: reviewDue,
          priorityTopics:
              List.unmodifiable(localPriority.take(2).map((t) => t.title))));
      completedTotal += completed;
      total += topics.length;
    }
    for (final topics in [priority, due, strong, improved, historical]) {
      newestFirst(topics);
    }
    return NorieMasteryDashboardSnapshot(
        subjects: List.unmodifiable(subjectSnapshots),
        strongTopics: List.unmodifiable(strong.take(2).map((t) => t.title)),
        priorityTopics: List.unmodifiable(priority.take(2).map((t) => t.title)),
        retentionDue: due.length,
        completedLessons: completedTotal,
        totalLessons: total,
        availablePaths: paths,
        priorityLessons: List.unmodifiable(priority.take(2)),
        dueLessons: List.unmodifiable(due.take(2)),
        strongLessons: List.unmodifiable(strong.take(2)),
        improvedLessons: List.unmodifiable(improved.take(2)),
        historicalRetainedLessons: List.unmodifiable(historical));
  }
}
