import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../challenge/domain/challenge_question.dart';

class WeakTopicsScreen extends StatelessWidget {
  const WeakTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mastery & Weak Topics'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: NorieProgression.instance,
          builder: (context, _) {
            final progression = NorieProgression.instance;
            final allTopics = progression.topicMastery;
            final weakTopics = progression.weakTopics;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                  children: [
                    _MasteryHero(progression: progression),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Weak Topics',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          '${weakTopics.length}',
                          style: const TextStyle(
                            color: NorieColors.magenta,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'A topic enters this list after at least two attempts when accuracy is below 70%.',
                      style: TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (weakTopics.isEmpty)
                      const _EmptyWeakTopics()
                    else
                      for (final topic in weakTopics)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 11),
                          child: _TopicCard(
                            mastery: topic,
                            emphasizeWeakness: true,
                          ),
                        ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'All Tracked Topics',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          '${allTopics.length}',
                          style: const TextStyle(
                            color: NorieColors.cyan,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (allTopics.isEmpty)
                      const _NoMasteryData()
                    else
                      for (final topic in allTopics)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 11),
                          child: _TopicCard(mastery: topic),
                        ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MasteryHero extends StatelessWidget {
  const _MasteryHero({required this.progression});

  final NorieProgression progression;

  @override
  Widget build(BuildContext context) {
    final attempted = progression.topicMastery.length;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF102A4A),
            Color(0xFF25205F),
            Color(0xFF431C54),
          ],
        ),
        border: Border.all(
          color: NorieColors.violet.withValues(alpha: .55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.psychology_alt_rounded,
                color: NorieColors.cyan,
                size: 30,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Knowledge Mastery',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Mastery combines accuracy with repeated evidence. One lucky answer cannot instantly mark a topic as mastered.',
            style: TextStyle(
              color: NorieColors.textSecondary,
              height: 1.4,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MasteryStat(
                  value: '$attempted',
                  label: 'Tracked',
                  color: NorieColors.cyan,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _MasteryStat(
                  value: '${progression.masteredTopicCount}',
                  label: 'Mastered',
                  color: NorieColors.green,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _MasteryStat(
                  value: '${progression.weakTopics.length}',
                  label: 'Weak',
                  color: NorieColors.magenta,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MasteryStat extends StatelessWidget {
  const _MasteryStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: .28)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.mastery,
    this.emphasizeWeakness = false,
  });

  final NorieTopicMastery mastery;
  final bool emphasizeWeakness;

  @override
  Widget build(BuildContext context) {
    final color = _masteryColor(mastery.level);
    final accuracy = (mastery.accuracy * 100).round();
    final masteryPercent = (mastery.score * 100).round();
    final availableQuestions = NorieChallengeBank.questions
        .where(
          (question) =>
              question.topic == mastery.topic &&
              question.category == mastery.category,
        )
        .length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: emphasizeWeakness
              ? NorieColors.magenta.withValues(alpha: .6)
              : color.withValues(alpha: .32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mastery.topic,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      mastery.category,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .11),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  mastery.levelLabel,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          LinearProgressIndicator(
            value: mastery.score,
            minHeight: 7,
            borderRadius: BorderRadius.circular(99),
            color: color,
            backgroundColor: NorieColors.surfaceElevated,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Mastery $masteryPercent% · Accuracy $accuracy%',
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                '${mastery.correct}/${mastery.attempts} correct',
                style: const TextStyle(
                  color: NorieColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (availableQuestions > 0) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => TopicReviewScreen(
                        category: mastery.category,
                        topic: mastery.topic,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text(
                  emphasizeWeakness ? 'Review Weak Topic' : 'Practice Topic',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyWeakTopics extends StatelessWidget {
  const _EmptyWeakTopics();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NorieColors.green.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: NorieColors.green.withValues(alpha: .28),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle_rounded, color: NorieColors.green),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'No weak topics detected yet. Keep answering questions so Norie can build a stronger evidence base.',
              style: TextStyle(
                color: NorieColors.textSecondary,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoMasteryData extends StatelessWidget {
  const _NoMasteryData();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NorieColors.border),
      ),
      child: const Text(
        'Complete lessons or Challenge Mode questions to start building topic mastery.',
        style: TextStyle(
          color: NorieColors.textSecondary,
          fontSize: 11,
        ),
      ),
    );
  }
}

class TopicReviewScreen extends StatefulWidget {
  const TopicReviewScreen({
    required this.category,
    required this.topic,
    super.key,
  });

  final String category;
  final String topic;

  @override
  State<TopicReviewScreen> createState() => _TopicReviewScreenState();
}

class _TopicReviewScreenState extends State<TopicReviewScreen> {
  late final List<ChallengeQuestion> _questions;

  int _current = 0;
  int _score = 0;
  int? _selected;
  bool _checked = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _questions = NorieChallengeBank.questions
        .where(
          (question) =>
              question.topic == widget.topic &&
              question.category == widget.category,
        )
        .toList(growable: false);
  }

  void _check() {
    if (_selected == null || _checked || _finished) return;

    final question = _questions[_current];
    final correct = _selected == question.correctIndex;

    NorieProgression.instance.recordTopicAnswer(
      category: question.category,
      topic: question.topic,
      correct: correct,
    );

    setState(() {
      _checked = true;
      if (correct) _score++;
    });
  }

  void _next() {
    if (!_checked) return;

    if (_current == _questions.length - 1) {
      NorieProgression.instance.recordStudySession();
      setState(() => _finished = true);
      return;
    }

    setState(() {
      _current++;
      _selected = null;
      _checked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.topic),
          backgroundColor: Colors.transparent,
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'No targeted review questions are available for this topic yet.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (_finished) {
      return _ReviewComplete(
        category: widget.category,
        topic: widget.topic,
        score: _score,
        total: _questions.length,
      );
    }

    final question = _questions[_current];
    final correct = _selected == question.correctIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review · ${widget.topic}'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
              children: [
                LinearProgressIndicator(
                  value: (_current + 1) / _questions.length,
                  minHeight: 7,
                  borderRadius: BorderRadius.circular(99),
                  color: NorieColors.violet,
                  backgroundColor: NorieColors.surfaceElevated,
                ),
                const SizedBox(height: 24),
                Text(
                  question.prompt,
                  style: const TextStyle(
                    fontSize: 27,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 22),
                for (var index = 0;
                    index < question.options.length;
                    index++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ReviewAnswer(
                      label: question.options[index],
                      selected: _selected == index,
                      checked: _checked,
                      correct: index == question.correctIndex,
                      onTap: () {
                        if (_checked) return;
                        setState(() => _selected = index);
                      },
                    ),
                  ),
                if (_checked) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: correct
                          ? NorieColors.green.withValues(alpha: .09)
                          : NorieColors.magenta.withValues(alpha: .09),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                        color: correct
                            ? NorieColors.green
                            : NorieColors.magenta,
                      ),
                    ),
                    child: Text(
                      question.explanation,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                FilledButton(
                  onPressed: _selected == null
                      ? null
                      : (_checked ? _next : _check),
                  style: FilledButton.styleFrom(
                    backgroundColor: NorieColors.violet,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _checked
                        ? (_current == _questions.length - 1
                            ? 'Finish review'
                            : 'Next question')
                        : 'Check answer',
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Topic reviews improve mastery but do not award XP.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewAnswer extends StatelessWidget {
  const _ReviewAnswer({
    required this.label,
    required this.selected,
    required this.checked,
    required this.correct,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool checked;
  final bool correct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var border = selected ? NorieColors.violet : NorieColors.border;
    var fill = NorieColors.surface;

    if (checked && correct) {
      border = NorieColors.green;
      fill = NorieColors.green.withValues(alpha: .08);
    } else if (checked && selected && !correct) {
      border = NorieColors.magenta;
      fill = NorieColors.magenta.withValues(alpha: .08);
    }

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: checked ? null : onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              if (checked && correct)
                const Icon(
                  Icons.check_circle_rounded,
                  color: NorieColors.green,
                )
              else if (checked && selected)
                const Icon(
                  Icons.cancel_rounded,
                  color: NorieColors.magenta,
                )
              else
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected
                      ? NorieColors.violet
                      : NorieColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewComplete extends StatelessWidget {
  const _ReviewComplete({
    required this.category,
    required this.topic,
    required this.score,
    required this.total,
  });

  final String category;
  final String topic;
  final int score;
  final int total;

  @override
  Widget build(BuildContext context) {
    final mastery = NorieProgression.instance.masteryFor(
      category: category,
      topic: topic,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Complete'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 34, 24, 36),
              children: [
                const Icon(
                  Icons.psychology_alt_rounded,
                  size: 72,
                  color: NorieColors.violet,
                ),
                const SizedBox(height: 18),
                Text(
                  '$topic reviewed',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$score / $total correct',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                  ),
                ),
                if (mastery != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(19),
                    decoration: BoxDecoration(
                      color: NorieColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: NorieColors.border),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Updated mastery',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Text(
                              mastery.levelLabel,
                              style: TextStyle(
                                color: _masteryColor(mastery.level),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: mastery.score,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(99),
                          color: _masteryColor(mastery.level),
                          backgroundColor: NorieColors.surfaceElevated,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Accuracy ${(mastery.accuracy * 100).round()}% · ${mastery.attempts} total attempts',
                          style: const TextStyle(
                            color: NorieColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back to Mastery'),
                  style: FilledButton.styleFrom(
                    backgroundColor: NorieColors.cyan,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _masteryColor(NorieMasteryLevel level) => switch (level) {
      NorieMasteryLevel.learning => NorieColors.magenta,
      NorieMasteryLevel.practicing => NorieColors.orange,
      NorieMasteryLevel.proficient => NorieColors.cyan,
      NorieMasteryLevel.mastered => NorieColors.green,
    };
