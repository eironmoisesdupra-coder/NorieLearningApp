import '../progression/norie_adventure_progress.dart';
import '../progression/norie_progression.dart';
import '../../features/content/domain/norie_content_models.dart';
import '../../features/progress/domain/norie_mastery_dashboard.dart';

class NorieMentorMessage {
  const NorieMentorMessage(
      {required this.title,
      required this.body,
      required this.actionLabel,
      required this.kind,
      this.topic});
  final String title, body, actionLabel, kind;
  final NorieTopicContent? topic;
}

/// Offline coaching derived only from the current learner's saved evidence.
abstract final class NorieMentorFeedback {
  static NorieMentorMessage current(
      {NorieProgression? progression,
      NorieAdventureProgress? adventure,
      DateTime? at,
      NorieMasteryDashboardSnapshot? snapshot}) {
    final evidence = adventure ?? NorieAdventureProgress.instance;
    final signals = snapshot ??
        NorieMasteryDashboardPolicy.derive(
            progression: progression, adventure: evidence, at: at);
    bool early(NorieTopicContent t) =>
        t.gradeLevel == 'g1' || t.gradeLevel == 'g2';
    if (signals.priorityLessons.isNotEmpty) {
      final topic = signals.priorityLessons.first;
      final concepts = evidence
              .evidenceFor(topic.id)
              ?.priorityConcepts
              .take(2)
              .join(' and ') ??
          '';
      return NorieMentorMessage(
          title: 'One idea at a time',
          body: early(topic)
              ? 'Let us try ${topic.title} again.${concepts.isEmpty ? '' : ' Focus on $concepts.'}'
              : 'Your last practice on ${topic.title} suggests another look.${concepts.isEmpty ? '' : ' Focus on $concepts.'} Review this lesson before trying a short practice.',
          actionLabel: 'Review this lesson',
          kind: 'priority',
          topic: topic);
    }
    if (signals.dueLessons.isNotEmpty) {
      final topic = signals.dueLessons.first;
      return NorieMentorMessage(
          title: 'See what you remember',
          body: early(topic)
              ? 'Ready to revisit ${topic.title}? Try a short review.'
              : 'You passed an independent check on ${topic.title}. Enough time has passed for a later review. Try it without help to see what you remember.',
          actionLabel: 'Start later review',
          kind: 'retention',
          topic: topic);
    }
    if (signals.improvedLessons.isNotEmpty) {
      final topic = signals.improvedLessons.first;
      return NorieMentorMessage(
          title: 'Your progress matters',
          body:
              'You earned an improvement badge in ${topic.title}. Build on it with a little optional practice.',
          actionLabel: 'Build on this progress',
          kind: 'improvement',
          topic: topic);
    }
    if (signals.strongLessons.isNotEmpty) {
      final topic = signals.strongLessons.first;
      return NorieMentorMessage(
          title: 'Build from a strength',
          body: early(topic)
              ? 'You remembered ${topic.title} in a later review. Well done!'
              : 'You demonstrated ${topic.title} in a later review, and your latest practice is still strong. Try connecting it with a new example.',
          actionLabel: 'Practice this strength',
          kind: 'strength',
          topic: topic);
    }
    return NorieMentorMessage(
        title: signals.completedLessons > 0
            ? 'Ready for your next check'
            : 'Start a small discovery',
        body: signals.completedLessons > 0
            ? 'Your completed lessons are saved. A lesson assessment can help show what you understand independently.'
            : 'Complete a lesson and try its practice. Your own results will help Norie suggest what to learn or review next.',
        actionLabel: 'Open Learn',
        kind: 'start');
  }
}
