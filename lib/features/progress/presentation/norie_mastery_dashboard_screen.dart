import 'package:flutter/material.dart';
import '../../../core/account/norie_account_service.dart';
import '../../../core/progression/norie_adventure_progress.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_mentor_card.dart';
import '../../content/domain/norie_content_models.dart';
import '../../content/domain/norie_review_quest.dart';
import '../../content/presentation/norie_lesson_screen.dart';
import '../../content/presentation/norie_review_quest_screen.dart';
import '../domain/norie_mastery_dashboard.dart';

class NorieMasteryDashboardScreen extends StatefulWidget {
  const NorieMasteryDashboardScreen({super.key});
  @override
  State<NorieMasteryDashboardScreen> createState() =>
      _NorieMasteryDashboardScreenState();
}

class _NorieMasteryDashboardScreenState
    extends State<NorieMasteryDashboardScreen> with WidgetsBindingObserver {
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

  Future<void> _open(NorieTopicContent topic, NorieReviewQuestKind? kind,
      bool Function() learner, int owner) async {
    if (!learner() ||
        owner != NorieAdventureProgress.instance.ownershipRevision) {
      setState(() {});
      return;
    }
    if (kind == NorieReviewQuestKind.mistakeDrill &&
        NorieReviewQuestPolicy.select(topic, NorieReviewQuestKind.mistakeDrill)
            .isEmpty) {
      kind = null;
    }
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => kind == null
            ? NorieLessonScreen(topic: topic)
            : NorieReviewQuestScreen(topic: topic, kind: kind)));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Learning dashboard'), actions: [
          IconButton(
              onPressed: () => setState(() {}),
              tooltip: 'Refresh learning signals',
              icon: const Icon(Icons.refresh_rounded)),
        ]),
        body: SafeArea(
            top: false,
            child: AnimatedBuilder(
                animation: Listenable.merge([
                  NorieProgression.instance,
                  NorieAdventureProgress.instance
                ]),
                builder: (context, _) {
                  final dashboard = NorieMasteryDashboardPolicy.derive();
                  final learner =
                      NorieAccountService.instance.captureLearnerGuard();
                  final owner =
                      NorieAdventureProgress.instance.ownershipRevision;
                  Widget section(
                          String title,
                          String explanation,
                          List<NorieTopicContent> topics,
                          NorieReviewQuestKind kind,
                          String action) =>
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 22),
                            Text(title,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900)),
                            Text(explanation,
                                style: const TextStyle(
                                    color: NorieColors.textSecondary)),
                            if (topics.isEmpty)
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text('No lessons here yet.')),
                            for (final topic in topics.take(2))
                              Card(
                                  child: Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(topic.title,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w800)),
                                            Text(
                                                '${topic.subject} · ${topic.gradeLevel ?? ''}'),
                                            FilledButton(
                                                onPressed: () => _open(topic,
                                                    kind, learner, owner),
                                                child: Text(kind ==
                                                            NorieReviewQuestKind
                                                                .mistakeDrill &&
                                                        NorieReviewQuestPolicy
                                                                .select(
                                                                    topic, kind)
                                                            .isEmpty
                                                    ? 'Review lesson'
                                                    : action)),
                                            TextButton(
                                                onPressed: () => _open(topic,
                                                    null, learner, owner),
                                                child: const Text(
                                                    'Revisit lesson')),
                                          ]))),
                          ]);
                  return Center(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 820),
                          child: ListView(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 14, 16, 36),
                              children: [
                                const Text('YOUR LEARNING SIGNALS',
                                    style: TextStyle(
                                        color: NorieColors.cyan,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 8),
                                const Text(
                                    'Your next step, grounded in your work.',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 12),
                                Text(
                                    '${dashboard.completedLessons} of ${dashboard.totalLessons} published lessons completed · ${dashboard.availablePaths} grade paths · ${dashboard.subjects.length} subjects'),
                                const SizedBox(height: 14),
                                const NorieMentorCard(),
                                section(
                                    'Review priorities',
                                    'Recent results below 80% or concepts to revisit. Latest attempts appear first.',
                                    dashboard.priorityLessons,
                                    NorieReviewQuestKind.mistakeDrill,
                                    'Review mistakes'),
                                section(
                                    'Ready for later review',
                                    'At least 24 hours after an independent pass. A later review checks retention.',
                                    dashboard.dueLessons,
                                    NorieReviewQuestKind.retainedReview,
                                    'Start later review'),
                                section(
                                    'Current strengths',
                                    'Retained evidence, with a latest result of at least 80% and no priority concepts.',
                                    dashboard.strongLessons,
                                    NorieReviewQuestKind.adaptivePractice,
                                    'Practice this strength'),
                                section(
                                    'Improvement to build on',
                                    'An improvement badge and a current result of at least 80% with no priority concepts.',
                                    dashboard.improvedLessons,
                                    NorieReviewQuestKind.adaptivePractice,
                                    'Keep practicing'),
                                const SizedBox(height: 24),
                                const Text('Subject progress',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900)),
                                const Text(
                                    'Completion records finished lessons. Independent passes and retained understanding use assessment evidence.'),
                                for (final subject in dashboard.subjects)
                                  Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(subject.subject,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                                Text(
                                                    '${subject.completed}/${subject.total} lessons completed'),
                                                const SizedBox(height: 8),
                                                LinearProgressIndicator(
                                                    value: subject.completion,
                                                    semanticsLabel:
                                                        '${subject.subject} completion'),
                                                const SizedBox(height: 8),
                                                Text(
                                                    '${subject.independent} current independent passes · ${subject.mastered} current retained strengths'),
                                                Text(
                                                    '${subject.priorityCount} need attention · ${subject.reviewDue} ready for later review'),
                                                Text(
                                                    '${subject.historicalRetained} historical retained records',
                                                    style: const TextStyle(
                                                        color: NorieColors
                                                            .textSecondary)),
                                              ]))),
                              ])));
                })),
      );
}
