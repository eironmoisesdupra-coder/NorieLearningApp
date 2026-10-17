import 'dart:async';
import '../../../core/account/norie_account_service.dart';
import 'package:flutter/material.dart';
import '../../content/domain/norie_content_models.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../content/data/norie_foundation_curriculum.dart';
import '../../content/presentation/norie_lesson_screen.dart';
import '../data/norie_seasonal_catalog.dart';
import '../data/norie_seasonal_store.dart';
import '../domain/norie_seasonal_models.dart';

class NorieSeasonalHubScreen extends StatefulWidget {
  const NorieSeasonalHubScreen(
      {super.key,
      this.store,
      this.clock,
      this.completedTopics,
      this.onOpenTopic});
  final NorieSeasonalStore? store;
  final DateTime Function()? clock;
  final Set<String> Function()? completedTopics;
  final ValueChanged<NorieTopicContent>? onOpenTopic;
  @override
  State<NorieSeasonalHubScreen> createState() => _NorieSeasonalHubScreenState();
}

class _NorieSeasonalHubScreenState extends State<NorieSeasonalHubScreen> {
  NorieSeasonalStore get store => widget.store ?? NorieSeasonalStore.instance;
  String? _error;
  bool _busy = false;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _load() async {
    try {
      await store.load();
    } catch (_) {
      if (mounted) {
        setState(() =>
            _error = 'Could not load keepsakes. Try again before claiming.');
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _claim(NorieSeason season, Set<String> completed) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final stillCurrent = NorieAccountService.instance.captureLearnerGuard();
      await store.claim(season, completed, stillCurrent: stillCurrent);
    } catch (_) {
      if (mounted) {
        setState(() =>
            _error = 'Your keepsake could not be saved. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Seasonal learning')),
        body: AnimatedBuilder(
            animation: Listenable.merge([store, NorieProgression.instance]),
            builder: (context, _) =>
                ListView(padding: const EdgeInsets.all(16), children: [
                  const Text('OPTIONAL SEASONS',
                      style: TextStyle(
                          color: NorieColors.violet,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('A little discovery, at your own pace',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text(
                      'Skipping a season never removes lessons or progress. Earned keepsakes remain in your collection after the season ends.'),
                  if (_error != null) ...[
                    Text(_error!,
                        style:
                            const TextStyle(color: NorieColors.textSecondary)),
                    TextButton(
                        onPressed: _load, child: const Text('Retry loading'))
                  ],
                  const SizedBox(height: 16),
                  for (final s in NorieSeasonalCatalog.seasons)
                    _card(context, s),
                ])),
      );
  Widget _card(BuildContext context, NorieSeason season) {
    final status = season.statusAt((widget.clock ?? DateTime.now)());
    final completed = widget.completedTopics?.call() ??
        NorieProgression.instance.completedTopicIds;
    final done = store.complete(season, completed),
        earned = store.isEarned(season.rewardId);
    return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: NorieColors.violet.withValues(alpha: .45))),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(colors: [
                            NorieColors.violet.withValues(alpha: .22),
                            NorieColors.cyan.withValues(alpha: .10),
                          ])),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.travel_explore_rounded,
                                size: 32, color: NorieColors.cyan),
                            const SizedBox(height: 8),
                            Text(season.title,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            const Text('Optional lessons / Cosmetic keepsake',
                                style: TextStyle(
                                    color: NorieColors.textSecondary)),
                          ])),
                  const SizedBox(height: 10),
                  Text(
                      switch (status) {
                        NorieSeasonStatus.active => 'Active',
                        NorieSeasonStatus.upcoming => 'Coming soon',
                        NorieSeasonStatus.archived => 'Archived'
                      },
                      style: const TextStyle(
                          color: NorieColors.cyan,
                          fontWeight: FontWeight.bold)),
                  Text(
                      '${_date(season.startsAt)} to ${_date(season.endsAt)} (UTC; end exclusive)'),
                  const SizedBox(height: 8),
                  Text(season.description),
                  const SizedBox(height: 8),
                  for (final mission in season.missions) ...[
                    Text(mission.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('${mission.subject} / ${_grade(mission.gradeId)}'),
                    for (final id in mission.topicIds)
                      _lesson(context, mission, id, completed.contains(id)),
                    const SizedBox(height: 12),
                  ],
                  Text(earned
                      ? 'Keepsake earned: ${season.rewardLabel}'
                      : 'Keepsake: ${season.rewardLabel}'),
                  if (!earned)
                    Text(done
                        ? 'All ${season.missions.length} missions completed.'
                        : 'Complete each lesson mastery check to finish the missions.'),
                  if (status == NorieSeasonStatus.active && !earned)
                    FilledButton(
                        onPressed: done && store.loaded && !_busy
                            ? () => _claim(season, completed)
                            : null,
                        child: Text(_busy ? 'Saving…' : 'Claim keepsake')),
                  if (status == NorieSeasonStatus.archived)
                    const Text(
                        'Claims have closed. You can still open every lesson below.'),
                  if (status == NorieSeasonStatus.upcoming)
                    const Text(
                        'Keepsake claims open when the season starts. You can explore lessons now.'),
                ])));
  }

  String _date(DateTime date) =>
      date.toUtc().toIso8601String().substring(0, 10);

  String _grade(String gradeId) =>
      NorieFoundationCurriculum.gradeLevels
          .where((grade) => grade.id == gradeId)
          .firstOrNull
          ?.label ??
      gradeId;

  Widget _lesson(BuildContext context, NorieSeasonMission mission, String id,
      bool complete) {
    final topics =
        NorieFoundationCurriculum.topicsFor(mission.subject, mission.gradeId)
            .where((t) => t.id == id);
    if (topics.length != 1) return const Text('Lesson unavailable');
    final topic = topics.single;
    return TextButton.icon(
      key: ValueKey(id),
      icon: Icon(complete ? Icons.check_circle : Icons.menu_book),
      label:
          Text('${complete ? 'Completed: ' : 'Open lesson: '}${topic.title}'),
      style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 12)),
      onPressed: () {
        if (widget.onOpenTopic != null) {
          widget.onOpenTopic!(topic);
          return;
        }
        Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => NorieLessonScreen(topic: topic)));
      },
    );
  }
}
