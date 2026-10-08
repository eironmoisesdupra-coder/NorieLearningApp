import 'package:uuid/uuid.dart';
import '../../../core/audio/norie_audio_manager.dart';
import '../../../core/quiz/quiz_result_summary.dart';
import '../application/norie_quiz_adapter.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../application/norie_activity_engine.dart';
import '../domain/norie_content_models.dart';
import 'norie_content_theme.dart';
import 'norie_learning_results_screen.dart';

class NorieChallengeScreen extends StatefulWidget {
  const NorieChallengeScreen({
    required this.topic,
    required this.quizScore,
    this.quizAnswers = const [],
    this.attemptId,
    this.practiceMode = NorieActivityMode.multipleChoice,
    this.practiceHistoryKey,
    this.evidenceOwnershipRevision,
    this.learnerGuard,
    super.key,
  });

  final NorieTopicContent topic;
  final int quizScore;
  final List<QuizAnswerRecord> quizAnswers;
  final String? attemptId;
  final NorieActivityMode practiceMode;
  final String? practiceHistoryKey;
  final int? evidenceOwnershipRevision;
  final bool Function()? learnerGuard;

  @override
  State<NorieChallengeScreen> createState() => _NorieChallengeScreenState();
}

class _NorieChallengeScreenState extends State<NorieChallengeScreen> {
  late final List<NorieRandomizedQuestion> _rounds;

  late final _attemptId = widget.attemptId ?? const Uuid().v4();
  final List<QuizAnswerRecord> _answers = [];
  late final Object _audioToken;
  bool _finishing = false;
  int _round = 0;
  int _challengeScore = 0;
  int? _selectedIndex;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _audioToken =
        NorieAudioManager.instance.enterContext(NorieAudioContext.quiz);
    NorieAudioManager.instance.playChallengeStart();
    _rounds = NorieItemRandomizer.randomize(widget.topic.challenge.rounds);
    if (_rounds.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) norieEmptyContentQuiz(context, widget.topic, 'challenge');
      });
    }
  }

  @override
  void dispose() {
    NorieAudioManager.instance.leaveContext(_audioToken);
    super.dispose();
  }

  void _choose(int index) {
    if (_locked || _finishing) return;
    final current = _rounds[_round];
    NorieAudioManager.instance.playQuizSelect();
    final correct = index == current.correctIndex;
    _answers.add(norieContentAnswer(current.source,
        response: current.options[index], correct: correct));
    if (correct) {
      NorieAudioManager.instance.playCorrect();
    } else {
      NorieAudioManager.instance.playWrong();
    }

    setState(() {
      _selectedIndex = index;
      _locked = true;
      if (index == current.correctIndex) {
        _challengeScore++;
      }
    });
  }

  void _next() {
    if (!_locked || _finishing) return;

    if (_round == _rounds.length - 1) {
      setState(() => _finishing = true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => NorieLearningResultsScreen(
            topic: widget.topic,
            quizScore: widget.quizScore,
            challengeScore: _challengeScore,
            answers: List.unmodifiable([...widget.quizAnswers, ..._answers]),
            attemptId: _attemptId,
            evidenceOwnershipRevision: widget.evidenceOwnershipRevision,
            learnerGuard: widget.learnerGuard,
            practiceMode: widget.practiceMode,
            practiceHistoryKey: widget.practiceHistoryKey,
          ),
        ),
      );
      return;
    }

    setState(() {
      _round++;
      _selectedIndex = null;
      _locked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_rounds.isEmpty) {
      return const Scaffold(
          body: Center(child: Text('No questions available.')));
    }
    final rounds = _rounds;
    final current = rounds[_round];
    final accent = norieContentAccent(widget.topic.accent);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic.challenge.title),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: [
                        accent.withValues(alpha: .34),
                        const Color(0xFF1B2862),
                        const Color(0xFF0E1732),
                      ],
                    ),
                    border: Border.all(
                      color: accent.withValues(alpha: .5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.extension_rounded,
                        size: 58,
                        color: accent,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.topic.challenge.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: NorieColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'ROUND ${_round + 1} OF ${rounds.length}',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.4,
                    color: accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  current.source.prompt,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 22),
                for (var index = 0; index < current.options.length; index++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: _ChallengeChoice(
                      label: current.options[index],
                      selected: _selectedIndex == index,
                      locked: _locked,
                      correct: current.correctIndex == index,
                      accent: accent,
                      onTap: () => _choose(index),
                    ),
                  ),
                if (_locked) ...[
                  const SizedBox(height: 8),
                  Text(
                    _selectedIndex == current.correctIndex
                        ? 'Correct! +${widget.topic.challenge.xpPerCorrect} challenge XP'
                        : current.source.explanation,
                    style: TextStyle(
                      color: _selectedIndex == current.correctIndex
                          ? NorieColors.green
                          : NorieColors.magenta,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _locked ? _next : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _round == rounds.length - 1 ? 'View results' : 'Next round',
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

class _ChallengeChoice extends StatelessWidget {
  const _ChallengeChoice({
    required this.label,
    required this.selected,
    required this.locked,
    required this.correct,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool locked;
  final bool correct;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var border = selected ? accent : NorieColors.border;
    var fill = NorieColors.surface;

    if (locked && correct) {
      border = NorieColors.green;
      fill = NorieColors.green.withValues(alpha: .10);
    } else if (locked && selected && !correct) {
      border = NorieColors.magenta;
      fill = NorieColors.magenta.withValues(alpha: .10);
    }

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: locked ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (locked && correct)
                const Icon(
                  Icons.check_circle_rounded,
                  color: NorieColors.green,
                )
              else if (selected)
                Icon(
                  locked ? Icons.cancel_rounded : Icons.radio_button_checked,
                  color: locked ? NorieColors.magenta : accent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
