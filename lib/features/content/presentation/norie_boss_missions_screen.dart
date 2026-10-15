import 'package:flutter/material.dart';
import '../../../core/progression/norie_adventure_progress.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../data/norie_foundation_curriculum.dart';
import '../domain/norie_boss_mission.dart';
import 'norie_lesson_screen.dart';
import 'norie_review_quest_screen.dart';

class NorieBossMissionsScreen extends StatelessWidget {
  const NorieBossMissionsScreen(
      {super.key, required this.subject, required this.gradeId});
  final String subject, gradeId;

  @override
  Widget build(BuildContext context) {
    final missions = NorieBossMission.forPath(subject, gradeId);
    final grades = NorieFoundationCurriculum.availableGradeLevels(subject)
        .where((g) => g.id == gradeId);
    final gradeLabel = grades.isEmpty ? gradeId : grades.first.label;
    return Scaffold(
      appBar: AppBar(title: const Text('Boss Missions')),
      body: SafeArea(
          child: Center(
              child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: AnimatedBuilder(
          animation: Listenable.merge(
              [NorieProgression.instance, NorieAdventureProgress.instance]),
          builder: (context, _) =>
              ListView(padding: const EdgeInsets.all(20), children: [
            Text('$subject / $gradeLabel',
                style:
                    const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            const Text(
                'Connect what you learned. Complete a chapter, then take its optional Boss Mission. '
                'Score 80% independently to earn a knowledge card. No timer or lives; retry whenever you are ready. '
                'Boss rewards do not add XP or league points, and lessons stay open.',
                style: TextStyle(height: 1.5)),
            if (missions.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(24),
                  child:
                      Text('No authored chapter is available for this path.')),
            for (final mission in missions) _BossCard(mission: mission),
          ]),
        ),
      ))),
    );
  }
}

class _BossCard extends StatelessWidget {
  const _BossCard({required this.mission});
  final NorieBossMission mission;
  @override
  Widget build(BuildContext context) {
    final complete = NorieProgression.instance.completedTopicIds;
    final ready = mission.isReady(complete);
    final earned =
        NorieAdventureProgress.instance.trophyIds.contains(mission.id);
    final done = mission.topics.where((t) => complete.contains(t.id)).length;
    return Card(
        margin: const EdgeInsets.only(top: 20),
        child: Padding(
            padding: const EdgeInsets.all(18),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(
                  earned
                      ? Icons.workspace_premium_rounded
                      : ready
                          ? Icons.flag_rounded
                          : Icons.lock_outline_rounded,
                  color: earned ? NorieColors.orange : NorieColors.cyan,
                  size: 36),
              const SizedBox(height: 10),
              Text(mission.title,
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(earned
                  ? 'Knowledge card earned. Revisit these ideas any time.'
                  : ready
                      ? 'Ready! Combine ideas from ${mission.topics.length} lessons.'
                      : '$done/${mission.topics.length} chapter lessons completed. Study these lessons to prepare.'),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: done / mission.topics.length),
              const SizedBox(height: 8),
              for (final topic in mission.topics)
                TextButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) => NorieLessonScreen(topic: topic))),
                    icon: Icon(
                        complete.contains(topic.id)
                            ? Icons.check_circle_outline
                            : Icons.menu_book_rounded,
                        size: 20),
                    label: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(topic.title))),
              const SizedBox(height: 8),
              Text(
                  '${mission.questions().length} questions / 80% to earn your card',
                  style: const TextStyle(color: NorieColors.textSecondary)),
              const SizedBox(height: 12),
              FilledButton.icon(
                  key: ValueKey('start-${mission.id}'),
                  onPressed: !ready
                      ? null
                      : () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (_) => NorieReviewQuestScreen.boss(
                                  mission: mission))),
                  icon: const Icon(Icons.flag_rounded),
                  label: Text(
                      earned ? 'Replay Boss Mission' : 'Start Boss Mission')),
            ])));
  }
}
