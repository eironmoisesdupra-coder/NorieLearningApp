import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/account/norie_account_service.dart';
import '../../../core/audio/norie_audio_manager.dart';
import '../../../core/quiz/quiz_result_summary.dart';
import '../../../core/quiz/norie_quiz_outro.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../domain/anatomy_atlas_catalog.dart';
import '../domain/anatomy_atlas_quiz_policy.dart';
import '../domain/anatomy_models.dart';
import 'anatomy_atlas_controller.dart';
import 'anatomy_atlas_model_view.dart';

class AnatomyAtlasQuizScreen extends StatefulWidget {
  const AnatomyAtlasQuizScreen(
      {required this.catalog,
      required this.reference,
      required this.systems,
      this.requestedCount = AtlasQuizSession.questionCount,
      this.difficulty = AtlasQuizDifficulty.standard,
      this.kinds = const {AtlasQuestionKind.identify},
      super.key});
  final AnatomyAtlasCatalog catalog;
  final String reference;
  final Set<String> systems;
  final int requestedCount;
  final AtlasQuizDifficulty difficulty;
  final Set<AtlasQuestionKind> kinds;
  @override
  State<AnatomyAtlasQuizScreen> createState() => _AnatomyAtlasQuizScreenState();
}

class _AnatomyAtlasQuizScreenState extends State<AnatomyAtlasQuizScreen> {
  final _controller = AnatomyAtlasController();
  final _questionScroll = ScrollController();
  late final AtlasQuizSession _quiz;
  late final bool Function() _stillCurrent;
  String? _choice;
  bool _modelReady = false;
  bool _hintVisible = false;
  static const _hintCost = 5;
  final _revealedHints = <int>{};
  bool get _paidHintMode => widget.requestedCount == 20;

  String? _safeHint(AtlasQuizQuestion question) {
    final hint = question.hint.trim();
    if (hint.isEmpty) return null;
    final lower = hint.toLowerCase();
    // Do not charge for text that directly reveals the answer.
    if (lower.contains(question.answer.toLowerCase())) return null;
    if (question.kind == AtlasQuestionKind.identify &&
        lower.contains(question.target.name.toLowerCase())) return null;
    return hint;
  }

  void _toggleHint() {
    if (!_stillCurrent() || _quiz.finished) return;
    if (_hintVisible) {
      setState(() => _hintVisible = false);
      return;
    }
    if (_safeHint(_quiz.current) == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No non-spoiler hint available for this question.')));
      return;
    }
    if (_paidHintMode && !_quiz.checked &&
        !_revealedHints.contains(_quiz.index)) {
      if (!NorieProgression.instance.spendCredits(_hintCost)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('5 Norie Credits are required for this hint.')));
        return;
      }
      _revealedHints.add(_quiz.index);
    }
    setState(() => _hintVisible = true);
  }
  bool _outroShown = false;
  final _attemptId = const Uuid().v4();
  final _answers = <QuizAnswerRecord>[];
  late final Object _audioContext;
  @override
  void initState() {
    super.initState();
    _stillCurrent = NorieAccountService.instance.captureLearnerGuard();
    _quiz = AtlasQuizSession.generate(
        widget.catalog, widget.reference, widget.systems,
        requestedCount: widget.requestedCount,
        difficulty: widget.difficulty,
        kinds: widget.kinds,
        stillCurrent: _stillCurrent);
    _hintVisible = !_paidHintMode && widget.difficulty == AtlasQuizDifficulty.guided;
    NorieAccountService.instance.addListener(_learnerChanged);
    _audioContext =
        NorieAudioManager.instance.enterContext(NorieAudioContext.quiz);
  }

  @override
  void dispose() {
    NorieAccountService.instance.removeListener(_learnerChanged);
    NorieAudioManager.instance.leaveContext(_audioContext);
    _controller.dispose();
    _questionScroll.dispose();
    super.dispose();
  }

  void _learnerChanged() {
    if (mounted && !_stillCurrent()) setState(() {});
  }

  void _check() {
    if (!_stillCurrent() || _choice == null || !_modelReady) return;
    final correct = _quiz.answer(_choice!);
    if (correct == null) return;
    final target = _quiz.current.target;
    final system = AnatomyCatalog.systems
        .where((s) => target.systems.contains(s.id.name))
        .firstOrNull;
    final topic = system?.label ?? 'Atlas structures';
    _answers.add(QuizAnswerRecord(
        questionId: target.id,
        prompt: _quiz.current.prompt,
        response: _choice!,
        correctAnswer: _quiz.current.answer,
        explanation: _quiz.current.explanation,
        correct: correct,
        conceptId: system?.id.name ?? target.systems.first,
        conceptLabel: topic));
    if (correct) {
      NorieAudioManager.instance.playCorrect();
    } else {
      NorieAudioManager.instance.playWrong();
    }
    NorieProgression.instance
        .recordTopicAnswer(category: 'Anatomy', topic: topic, correct: correct);
    setState(() {});
  }

  Future<void> _next() async {
    if (!_stillCurrent()) return;
    if (!_quiz.next()) return;
    final reward = _quiz.takeReward();
    if (reward != null) {
      NorieProgression.instance
          .addXp(reward, claimKey: 'anatomy-atlas:$_attemptId');
    }
    setState(() {
      _choice = null;
      _modelReady = false;
      _hintVisible = !_paidHintMode && widget.difficulty == AtlasQuizDifficulty.guided;
    });
    if (_questionScroll.hasClients) _questionScroll.jumpTo(0);
    if (_quiz.finished && !_outroShown) {
      _outroShown = true;
      final legacyMode = widget.difficulty == AtlasQuizDifficulty.standard &&
          widget.kinds.length == 1 &&
          widget.kinds.contains(AtlasQuestionKind.identify);
      final action = await NorieQuizOutro.show(context,
          stillCurrent: _stillCurrent,
          summary: QuizResultSummary(
              attemptId: _attemptId,
              historyKey: quizHistoryKey(
                  legacyMode
                      ? 'atlas:${widget.reference}'
                      : 'atlas:${widget.reference}:${widget.difficulty.name}:'
                          '${(widget.kinds.map((kind) => kind.name).toList()..sort()).join(",")}',
                  _quiz.questions.map((q) => q.target.id)),
              title: 'Anatomy Atlas',
              correctCount: _quiz.score,
              totalCount: _quiz.questions.length,
              xpEarned: reward ?? 0,
              answers: _answers), reviewVisualBuilder: (_, answer) {
        final target = widget.catalog.structures
            .firstWhere((structure) => structure.id == answer.questionId);
        return _AtlasReviewModel(target: target, reference: target.reference);
      });
      if (!mounted || !_stillCurrent()) return;
      if (action == QuizOutroAction.retry) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
                builder: (_) => AnatomyAtlasQuizScreen(
                    catalog: widget.catalog,
                    reference: widget.reference,
                    systems: widget.systems,
                    requestedCount: widget.requestedCount,
                    difficulty: widget.difficulty,
                    kinds: widget.kinds)));
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_stillCurrent()) {
      return Scaffold(
        appBar: AppBar(title: const Text('Atlas quiz')),
        body: ListView(padding: const EdgeInsets.all(24), children: [
          const Text(
              'The learner changed during this quiz. Start a new quiz for the current learner.'),
          const SizedBox(height: 16),
          FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Anatomy Lab')),
        ]),
      );
    }
    if (_quiz.finished) {
      return Scaffold(
          appBar: AppBar(title: const Text('Atlas quiz complete')),
          body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.workspace_premium,
                color: NorieColors.cyan, size: 64),
            Text('${_quiz.score} / ${_quiz.questions.length}',
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text('+${_quiz.score * 10} XP'),
            const SizedBox(height: 20),
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Anatomy Lab')),
          ])));
    }
    final question = _quiz.current;
    final audio = NorieAudioManager.instance;
    return Scaffold(
        appBar: AppBar(
            title: Text(
                '${question.kind == AtlasQuestionKind.identify ? 'Identify' : 'System'} · ${_quiz.index + 1}/${_quiz.questions.length}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            actions: [
              IconButton(
                  tooltip: _hintVisible ? 'Hide hint' : (_paidHintMode && !_revealedHints.contains(_quiz.index) && !_quiz.checked ? 'Reveal hint (5 Credits)' : 'Show hint'),
                  icon: Icon(_hintVisible ? Icons.search_off : Icons.search),
                  onPressed: _toggleHint),
              IconButton(
                  tooltip: 'Recenter structure',
                  icon: const Icon(Icons.center_focus_strong),
                  onPressed: !_modelReady
                      ? null
                      : () => _controller
                          .send('focus', {'id': question.target.id})),
              ListenableBuilder(
                  listenable: audio,
                  builder: (context, _) => IconButton(
                      tooltip: audio.musicEnabled ? 'Mute music' : 'Play music',
                      icon: Icon(audio.musicEnabled
                          ? Icons.music_note
                          : Icons.music_off),
                      onPressed: () async {
                        await audio.unlock();
                        await audio.setMusicEnabled(!audio.musicEnabled);
                      })),
            ]),
        body: SafeArea(
            child: Column(children: [
          Expanded(
              flex: 4,
              child: AnatomyAtlasModelView(
                  controller: _controller,
                  reference: question.target.reference,
                  systems: question.target.systems,
                  target: question.target.id,
                  onLoaded: (ready) {
                    if (mounted && _modelReady != ready) {
                      setState(() => _modelReady = ready);
                    }
                  },
                  quiz: true)),
          Expanded(
              flex: 6,
              child: SingleChildScrollView(
                  controller: _questionScroll,
                  padding: const EdgeInsets.all(12),
                  child: Column(children: [
                    Text(question.prompt),
                    const SizedBox(height: 12),
                    if (_hintVisible)
                      Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(_safeHint(question) ?? 'Hint unavailable.',
                              key: const ValueKey('atlas-quiz-hint'),
                              style: const TextStyle(
                                  color: NorieColors.textSecondary))),
                    for (final option in question.options)
                      Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: _quiz.checked &&
                                              option == question.answer
                                          ? NorieColors.green
                                              .withValues(alpha: .22)
                                          : _choice == option
                                              ? NorieColors.primary
                                                  .withValues(alpha: .3)
                                              : null,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12)),
                                  onPressed: _quiz.checked || !_modelReady
                                      ? null
                                      : () {
                                          NorieAudioManager.instance
                                              .playQuizSelect();
                                          setState(() => _choice = option);
                                        },
                                  child: Text(option,
                                      textAlign: TextAlign.center)))),
                    if (_quiz.checked)
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                              _choice == question.answer
                                  ? 'Correct: ${question.answer}'
                                  : 'Answer: ${question.answer}',
                              style: const TextStyle(color: NorieColors.cyan))),
                    if (_quiz.checked)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(question.explanation),
                      ),
                    SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: _quiz.checked
                                ? _next
                                : _choice == null || !_modelReady
                                    ? null
                                    : _check,
                            child: Text(_quiz.checked
                                ? (_quiz.index + 1 == _quiz.questions.length
                                    ? 'Finish quiz'
                                    : 'Next structure')
                                : 'Check answer'))),
                  ]))),
        ])));
  }
}

class _AtlasReviewModel extends StatefulWidget {
  const _AtlasReviewModel({required this.target, required this.reference});
  final AtlasStructure target;
  final String reference;
  @override
  State<_AtlasReviewModel> createState() => _AtlasReviewModelState();
}

class _AtlasReviewModelState extends State<_AtlasReviewModel> {
  final _controller = AnatomyAtlasController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 220,
      child: AnatomyAtlasModelView(
          controller: _controller,
          reference: widget.reference,
          systems: widget.target.systems,
          target: widget.target.id,
          quiz: true));
}
