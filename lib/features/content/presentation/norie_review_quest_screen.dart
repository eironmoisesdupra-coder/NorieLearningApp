import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/audio/norie_audio_manager.dart';
import '../../../core/audio/norie_audio_host.dart';
import '../../../core/progression/norie_adventure_progress.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/account/norie_account_service.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../../core/quiz/norie_quiz_outro.dart';
import '../../../core/quiz/quiz_result_summary.dart';
import '../../../core/theme/norie_theme.dart';
import '../application/norie_activity_engine.dart';
import '../application/norie_quiz_adapter.dart';
import '../data/norie_foundation_curriculum.dart';
import '../domain/norie_content_models.dart';
import '../domain/norie_review_quest.dart';

class NorieReviewQuestScreen extends StatefulWidget {
  const NorieReviewQuestScreen(
      {super.key,
      required this.topic,
      required this.kind,
      this.chapterTopics = const []});
  final NorieTopicContent topic;
  final NorieReviewQuestKind kind;
  final List<NorieTopicContent> chapterTopics;
  @override
  State<NorieReviewQuestScreen> createState() => _NorieReviewQuestScreenState();
}

class _NorieReviewQuestScreenState extends State<NorieReviewQuestScreen> {
  final int _owner = NorieAdventureProgress.instance.ownershipRevision;
  final _sessionCurrent = NorieAccountService.instance.captureLearnerGuard();
  final String _attempt = const Uuid().v4();
  late final _items = NorieItemRandomizer.randomize(
      widget.kind == NorieReviewQuestKind.chapter
          ? NorieReviewQuestPolicy.chapterQuestions(widget.chapterTopics)
          : NorieReviewQuestPolicy.select(widget.topic, widget.kind));
  final List<QuizAnswerRecord> _answers = [];
  int _current = 0;
  int? _selected;
  bool _checked = false, _finishing = false;
  String get _title => switch (widget.kind) {
        NorieReviewQuestKind.mistakeDrill => 'Mistake drill',
        NorieReviewQuestKind.retainedReview => 'Later review',
        NorieReviewQuestKind.chapter => 'Chapter expedition'
      };
  Future<void> _submit() async {
    if (_selected == null || _finishing) return;
    final question = _items[_current];
    if (!_checked) {
      final correct = _selected == question.correctIndex;
      _answers.add(norieContentAnswer(question.source,
          response: question.options[_selected!], correct: correct));
      correct
          ? NorieAudioManager.instance.playCorrect()
          : NorieAudioManager.instance.playWrong();
      setState(() => _checked = true);
      return;
    }
    if (_current < _items.length - 1) {
      setState(() {
        _current++;
        _selected = null;
        _checked = false;
      });
      return;
    }
    setState(() => _finishing = true);
    if (!_sessionCurrent()) {
      Navigator.pop(context);
      return;
    }
    try {
      final beforeTrophies = NorieAdventureProgress.instance.trophyIds;
      final accepted = await NorieAdventureProgress.instance.recordAttempt(
          topicId: widget.kind == NorieReviewQuestKind.chapter
              ? 'chapter:${widget.topic.subject.toLowerCase()}.${widget.topic.gradeLevel}'
              : widget.topic.id,
          attemptId: _attempt,
          answers: _answers,
          delayedReview: widget.kind == NorieReviewQuestKind.retainedReview,
          expectedRevision: _owner);
      if (!mounted) return;
      if (!accepted || !_sessionCurrent()) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'The active learner changed. This practice was not added to another profile.')));
        Navigator.pop(context);
        return;
      }
      NorieProgression.instance.refreshGradeTrophies();
      await NorieAdventureProgress.instance.flush();
      if (!mounted || !_sessionCurrent()) return;
      final rewards =
          NorieAdventureProgress.instance.trophyIds.difference(beforeTrophies);
      final action = await NorieQuizOutro.show(context,
          stillCurrent: _sessionCurrent,
          summary: QuizResultSummary(
              attemptId: _attempt,
              historyKey: norieContentHistoryKey(
                  widget.topic, _title, _items.map((q) => q.source)),
              title: _title,
              correctCount: _answers.where((a) => a.correct).length,
              totalCount: _answers.length,
              xpEarned: 0,
              gradeLevel: norieQuizGrade(widget.topic),
              answers: _answers,
              earnedRewards: [
                for (final id in rewards)
                  id.startsWith('path-mastery:')
                      ? 'Whole-path mastery trophy'
                      : id.startsWith('chapter:')
                          ? 'Chapter expedition emblem'
                          : id.startsWith('mastery:')
                              ? 'Retained understanding badge'
                              : 'Improvement badge'
              ]),
          canRetry: false,
          canViewProfile: rewards.isNotEmpty);
      if (mounted && action == QuizOutroAction.viewProfile) {
        Navigator.pushReplacement(context,
            MaterialPageRoute<void>(builder: (_) => const ProfileScreen()));
        return;
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() => _finishing = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'We could not confirm the save. Keep this screen open and try again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return Scaffold(
          appBar: AppBar(title: Text(_title)),
          body: const Center(
              child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                      'No missed concepts need a drill right now. Continue your journey or try independent practice.'))));
    }
    final question = _items[_current];
    return NorieAudioScope(
        contextType: NorieAudioContext.quiz,
        child: Scaffold(
            appBar: AppBar(title: Text(_title)),
            body: SafeArea(
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                              Text(
                                  widget.kind == NorieReviewQuestKind.chapter
                                      ? '${widget.topic.subject} • ${widget.topic.category}'
                                      : widget.topic.title,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900)),
                              const SizedBox(height: 8),
                              Text(
                                  widget.kind ==
                                          NorieReviewQuestKind.mistakeDrill
                                      ? 'A short return to the concepts you missed. No lives, timer or extra XP farming.'
                                      : widget.kind ==
                                              NorieReviewQuestKind.chapter
                                          ? 'Connect ideas across real lessons. This optional expedition earns a chapter badge at 80%; lessons stay open.'
                                          : 'Answer independently. Five distinct items at 80% earn the retained-understanding star when at least 24 hours have passed since your first independent pass.',
                                  style: const TextStyle(
                                      color: NorieColors.textSecondary,
                                      height: 1.4)),
                              const SizedBox(height: 18),
                              LinearProgressIndicator(
                                  value: (_current + 1) / _items.length),
                              const SizedBox(height: 12),
                              Text('${_current + 1} / ${_items.length}'),
                              const SizedBox(height: 18),
                              Text(question.source.prompt,
                                  style: const TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 16),
                              for (var i = 0; i < question.options.length; i++)
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: OutlinedButton(
                                        onPressed: _checked || _finishing
                                            ? null
                                            : () {
                                                NorieAudioManager.instance
                                                    .playQuizSelect();
                                                setState(() => _selected = i);
                                              },
                                        style: OutlinedButton.styleFrom(
                                            alignment: Alignment.centerLeft,
                                            side: BorderSide(
                                                color: _selected == i
                                                    ? NorieColors.cyan
                                                    : NorieColors.border),
                                            padding: const EdgeInsets.all(18)),
                                        child: Text(question.options[i]))),
                              if (_checked)
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child: Text(
                                        '${_selected == question.correctIndex ? 'Correct.' : 'Let’s review.'} ${question.source.explanation}',
                                        style: const TextStyle(height: 1.45))),
                              FilledButton(
                                  onPressed: _selected == null || _finishing
                                      ? null
                                      : _submit,
                                  child: Text(_finishing
                                      ? 'Saving…'
                                      : !_checked
                                          ? 'Check answer'
                                          : _current == _items.length - 1
                                              ? 'Finish quest'
                                              : 'Next question')),
                            ]))))));
  }
}

class NorieReviewQuestsHub extends StatelessWidget {
  const NorieReviewQuestsHub({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Review quests')),
      body: AnimatedBuilder(
          animation: Listenable.merge(
              [NorieAdventureProgress.instance, NorieProgression.instance]),
          builder: (context, _) {
            final progress = NorieAdventureProgress.instance;
            final topics = [
              for (final subject in ['Science', 'Mathematics', 'English'])
                for (final grade in NorieFoundationCurriculum.gradeLevels)
                  ...NorieFoundationCurriculum.topicsFor(subject, grade.id)
            ];
            final weak = topics
                .where((t) =>
                    progress.evidenceFor(t.id)?.missedQuestionIds.isNotEmpty ==
                    true)
                .toList();
            final due =
                topics.where((t) => progress.isReviewDue(t.id)).toList();
            return Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child:
                        ListView(padding: const EdgeInsets.all(20), children: [
                      const Text('Return, improve, continue',
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      const Text(
                          'Short quests use your actual answer evidence. Review never blocks a lesson or removes earned stars.'),
                      const SizedBox(height: 18),
                      const Text('Priority concepts',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      if (weak.isEmpty)
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                                'No mistake drills yet. Complete practice to get a focused recommendation.')),
                      for (final topic in weak.take(10))
                        ListTile(
                            title: Text(topic.title),
                            subtitle: Text(progress
                                    .evidenceFor(topic.id)!
                                    .priorityConcepts
                                    .isEmpty
                                ? 'Review missed questions'
                                : progress
                                    .evidenceFor(topic.id)!
                                    .priorityConcepts
                                    .join(' • ')),
                            trailing: const Icon(Icons.refresh_rounded),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (_) => NorieReviewQuestScreen(
                                        topic: topic,
                                        kind: NorieReviewQuestKind
                                            .mistakeDrill)))),
                      const SizedBox(height: 18),
                      const Text('Ready for later review',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      if (due.isEmpty)
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                                'A later review becomes ready 24 hours after an independent practice pass.')),
                      for (final topic in due)
                        ListTile(
                            title: Text(topic.title),
                            subtitle: const Text(
                                'Demonstrate retained understanding'),
                            trailing: const Icon(Icons.star_outline_rounded),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (_) => NorieReviewQuestScreen(
                                        topic: topic,
                                        kind: NorieReviewQuestKind
                                            .retainedReview)))),
                      const SizedBox(height: 18),
                      const Text('Authored chapter expeditions',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      for (final subject in [
                        'Science',
                        'Mathematics',
                        'English'
                      ])
                        for (final grade
                            in NorieFoundationCurriculum.gradeLevels)
                          Builder(builder: (context) {
                            final lessons = NorieFoundationCurriculum.topicsFor(
                                    subject, grade.id)
                                .where(NorieFoundationCurriculum.isAuthored)
                                .toList();
                            return ListTile(
                                title: Text('$subject • ${grade.label}'),
                                subtitle: Text(
                                    '${lessons.length} authored units • starter previews excluded'),
                                leading: Icon(
                                    progress.trophyIds.contains(
                                            'chapter:${subject.toLowerCase()}.${grade.id}')
                                        ? Icons.workspace_premium_rounded
                                        : Icons.route_rounded,
                                    color: NorieColors.cyan),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (_) => NorieReviewQuestScreen(
                                            topic: lessons.first,
                                            kind: NorieReviewQuestKind.chapter,
                                            chapterTopics: lessons))));
                          }),
                    ])));
          }));
}

class NorieLessonStarCard extends StatelessWidget {
  const NorieLessonStarCard({super.key, required this.topic});
  final NorieTopicContent topic;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: Listenable.merge(
          [NorieAdventureProgress.instance, NorieProgression.instance]),
      builder: (context, _) {
        final progress = NorieAdventureProgress.instance,
            evidence = progress.evidenceFor(topic.id);
        final completed = NorieProgression.instance.isTopicCompleted(topic.id);
        return Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your learning stars',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Text(
                          '${completed ? '★' : '☆'} Completed  •  ${evidence?.firstPassedAt != null ? '★' : '☆'} Independent  •  ${evidence?.retainedAt != null ? '★' : '☆'} Retained'),
                      const SizedBox(height: 8),
                      const Text(
                          'Discover in the lesson → practice → apply independently → connect in a chapter → master through later review.',
                          style: TextStyle(
                              height: 1.4, color: NorieColors.textSecondary)),
                      Text(
                          !NorieFoundationCurriculum.isAuthored(topic)
                              ? 'Starter preview: completion is saved. Subject mastery stars need fully authored assessment content.'
                              : const ['g1', 'g2'].contains(topic.gradeLevel)
                                  ? 'Read, try on your own, then come back tomorrow. Stars never lock a lesson.'
                                  : 'Independent: at least five different questions and 80%. Retained: a new independent review after 24 hours. Stars never lock existing lessons.',
                          style: const TextStyle(
                              height: 1.4, color: NorieColors.textSecondary)),
                      if (evidence?.missedQuestionIds.isNotEmpty == true)
                        TextButton.icon(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (_) => NorieReviewQuestScreen(
                                        topic: topic,
                                        kind: NorieReviewQuestKind
                                            .mistakeDrill))),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try a short mistake drill')),
                      if (evidence?.firstPassedAt != null)
                        TextButton.icon(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (_) => NorieReviewQuestScreen(
                                        topic: topic,
                                        kind: NorieReviewQuestKind
                                            .retainedReview))),
                            icon: const Icon(Icons.star_outline),
                            label: Text(progress.isReviewDue(topic.id)
                                ? 'Later review is ready'
                                : 'Practice a later review')),
                    ])));
      });
}
