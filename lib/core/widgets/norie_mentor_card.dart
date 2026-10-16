import 'package:flutter/material.dart';
import '../account/norie_account_service.dart';
import '../assets/norie_assets.dart';
import '../mascot/norie_mentor_feedback.dart';
import '../progression/norie_adventure_progress.dart';
import '../progression/norie_progression.dart';
import '../theme/norie_theme.dart';
import '../../features/content/domain/norie_review_quest.dart';
import '../../features/content/presentation/norie_lesson_screen.dart';
import '../../features/content/presentation/norie_review_quest_screen.dart';
import '../../features/content/presentation/norie_subject_world_map.dart';

class NorieMentorCard extends StatefulWidget {
  const NorieMentorCard({super.key});
  @override
  State<NorieMentorCard> createState() => _NorieMentorCardState();
}

class _NorieMentorCardState extends State<NorieMentorCard>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) setState(() {});
  }

  void _open(NorieMentorMessage message, int owner, bool Function() guard,
      {bool mistakesOnly = false}) {
    if (!guard() ||
        owner != NorieAdventureProgress.instance.ownershipRevision) {
      return;
    }
    final topic = message.topic;
    final Widget destination;
    if (topic == null) {
      destination = const NorieSubjectWorldMap();
    } else if (mistakesOnly ||
        message.kind == 'retention' ||
        message.kind == 'strength' ||
        message.kind == 'improvement') {
      destination = NorieReviewQuestScreen(
          topic: topic,
          kind: mistakesOnly
              ? NorieReviewQuestKind.mistakeDrill
              : message.kind == 'retention'
                  ? NorieReviewQuestKind.retainedReview
                  : NorieReviewQuestKind.adaptivePractice);
    } else {
      destination = NorieLessonScreen(topic: topic);
    }
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => destination));
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: Listenable.merge([
        NorieProgression.instance,
        NorieAdventureProgress.instance,
        NorieAccountService.instance
      ]),
      builder: (context, _) {
        final message = NorieMentorFeedback.current();
        final owner = NorieAdventureProgress.instance.ownershipRevision;
        final guard = NorieAccountService.instance.captureLearnerGuard();
        final canDrill = message.kind == 'priority' &&
            message.topic != null &&
            NorieReviewQuestPolicy.select(
                    message.topic!, NorieReviewQuestKind.mistakeDrill)
                .isNotEmpty;
        return Card(
            child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Image.asset(
                            message.kind == 'strength' ||
                                    message.kind == 'improvement'
                                ? NorieAssets.mascotCelebrating
                                : NorieAssets.mascotStudying,
                            width: 54,
                            height: 64,
                            fit: BoxFit.contain,
                            excludeFromSemantics: true),
                        const SizedBox(width: 12),
                        const Expanded(
                            child: Text('Norie mentor',
                                style: TextStyle(
                                    color: NorieColors.cyan,
                                    fontWeight: FontWeight.w900))),
                        IconButton(
                            tooltip: 'Refresh mentor advice',
                            onPressed: () => setState(() {}),
                            icon: const Icon(Icons.refresh_rounded)),
                      ]),
                      const SizedBox(height: 10),
                      Text(message.title,
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w900)),
                      if (message.topic != null)
                        Text(
                            '${message.topic!.subject} / ${message.topic!.gradeLevel == 'college' ? 'College' : message.topic!.gradeLevel?.replaceFirst(RegExp(r'^g'), 'Grade ') ?? 'Lesson'}',
                            style: const TextStyle(
                                color: NorieColors.textSecondary)),
                      const SizedBox(height: 8),
                      Text(message.body, style: const TextStyle(height: 1.5)),
                      const SizedBox(height: 16),
                      Wrap(spacing: 10, runSpacing: 8, children: [
                        FilledButton(
                            key: const ValueKey('mentor-primary'),
                            onPressed: () => _open(message, owner, guard),
                            child: Text(message.actionLabel)),
                        if (canDrill)
                          OutlinedButton(
                              onPressed: () => _open(message, owner, guard,
                                  mistakesOnly: true),
                              child: const Text('Practice missed concepts')),
                      ]),
                    ])));
      });
}
