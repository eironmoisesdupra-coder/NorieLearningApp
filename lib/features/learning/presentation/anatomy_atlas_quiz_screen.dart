import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/account/norie_account_service.dart';
import '../../../core/audio/norie_audio_manager.dart';
import '../../../core/quiz/quiz_result_summary.dart';
import '../../../core/quiz/norie_quiz_outro.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../domain/anatomy_atlas_catalog.dart';
import '../domain/anatomy_atlas_quiz_policy.dart';
import '../domain/anatomy_models.dart';
import '../domain/anatomy_hint_library.dart';
import '../domain/anatomy_atlas_quiz_snapshot.dart';
import '../data/anatomy_atlas_quiz_store.dart';
import 'anatomy_atlas_hint_panel.dart';
import 'anatomy_atlas_controller.dart';
import 'anatomy_atlas_model_view.dart';

class AnatomyAtlasQuizScreen extends StatefulWidget {
  const AnatomyAtlasQuizScreen(
      {required this.catalog,
      required this.reference,
      required this.systems,
      this.hints,
      this.requestedCount = AtlasQuizSession.questionCount,
      this.difficulty = AtlasQuizDifficulty.standard,
      this.kinds = const {AtlasQuestionKind.identify},
      super.key});
  final AnatomyAtlasCatalog catalog;
  // Only trusted application configuration may provide this library.
  // No authored drafts or approval registry are loaded in this release.
  final AnatomyHintLibrary? hints;
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
  AtlasQuizSession? _activeQuiz;
  AtlasQuizSession get _quiz => _activeQuiz!;
  AtlasSavedRound? _round;
  late final AtlasQuizStore _store;
  late final String? _ownerId;
  int _modelSession = 0;
  bool _loading = true, _busy = false, _conflict = false;
  String? _saveError;
  Future<void> Function()? _retryOperation;
  AtlasQuizRequest get _request => AtlasQuizRequest(
      reference: widget.reference,
      systems: widget.systems,
      requestedCount: widget.requestedCount,
      difficulty: widget.difficulty,
      kinds: widget.kinds);
  late final bool Function() _stillCurrent;
  String? _choice;
  bool _modelReady = false;
  bool _hintVisible = false;
  AnatomyHintResult? _assistance(AtlasQuizQuestion question) {
    if (!_modelReady || question.kind != AtlasQuestionKind.identify) {
      return null;
    }
    final library = widget.hints;
    final part = widget.catalog.hintGeometry?.parts[question.target.id];
    if (library == null ||
        part == null ||
        part.identity.reference != question.target.reference ||
        part.identity.assetId != question.target.asset ||
        part.canonicalName != question.answer ||
        !part.systems.containsAll(question.target.systems) ||
        !question.target.systems.containsAll(part.systems)) {
      return null;
    }
    return library.lookupQuestion(
      displayed: part.identity,
      selectedPartId: question.target.id,
      questionStructureId: question.target.id,
      correctAnswer: question.answer,
    );
  }

  void _toggleHint() {
    if (!_stillCurrent() || _busy || _quiz.finished) return;
    setState(() => _hintVisible = !_hintVisible);
  }

  bool _outroShown = false;
  String get _attemptId => _round!.attemptId;
  final _answers = <QuizAnswerRecord>[];
  late final Object _audioContext;
  @override
  void initState() {
    super.initState();
    final learner = NorieAccountService.instance.captureLearnerGuard();
    final revision = NorieProgression.instance.stateRevision;
    _stillCurrent = () =>
        mounted &&
        learner() &&
        NorieProgression.instance.stateRevision == revision;
    _ownerId = NorieAccountService.instance.user?.id;
    _store = AtlasQuizStore(owner: _ownerId, stillCurrent: _stillCurrent);
    _hintVisible = widget.difficulty == AtlasQuizDifficulty.guided;
    NorieAccountService.instance.addListener(_learnerChanged);
    NorieProgression.instance.addListener(_learnerChanged);
    _audioContext =
        NorieAudioManager.instance.enterContext(NorieAudioContext.quiz);
    unawaited(_load());
  }

  @override
  void dispose() {
    NorieAccountService.instance.removeListener(_learnerChanged);
    NorieProgression.instance.removeListener(_learnerChanged);
    NorieAudioManager.instance.leaveContext(_audioContext);
    _controller.dispose();
    _questionScroll.dispose();
    super.dispose();
  }

  void _learnerChanged() {
    if (mounted && !_stillCurrent()) setState(() {});
  }

  void _adopt(AtlasSavedRound round) {
    _round = round;
    _activeQuiz = round.session(widget.catalog, stillCurrent: _stillCurrent);
    _choice = _quiz.responses[_quiz.index];
    _answers.clear();
    for (var i = 0; i < _quiz.questions.length; i++) {
      final response = _quiz.responses[i];
      if (response == null) continue;
      final question = _quiz.questions[i];
      final system = AnatomyCatalog.systems
          .where((s) => question.target.systems.contains(s.id.name))
          .firstOrNull;
      _answers.add(QuizAnswerRecord(
          questionId: question.target.id,
          prompt: question.prompt,
          response: response,
          correctAnswer: question.answer,
          explanation: question.explanation,
          correct: response == question.answer,
          conceptId: system?.id.name ?? question.target.systems.first,
          conceptLabel: question.masteryTopic));
    }
  }

  Future<bool> _run(Future<void> Function() operation) async {
    if (_busy || !_stillCurrent()) return false;
    setState(() {
      _busy = true;
      _saveError = null;
    });
    var success = false;
    try {
      await operation();
      success = _stillCurrent();
    } on Object catch (error) {
      if (mounted) {
        _saveError = error is StateError
            ? error.message
            : error is FormatException
                ? error.message
                : 'Local save failed. Your saved round is preserved. Retry or reload it.';
        _retryOperation = operation;
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _loading = false;
        });
      }
    }
    return success;
  }

  Future<void> _reconcile() async {
    final pending = _round!.pending;
    if (pending != null) {
      final quiz = _round!.session(widget.catalog);
      await _store.reconcileEffect(
          widget.catalog,
          _round!,
          () => NorieProgression.instance.recordAtlasMastery(
              topic: quiz.current.masteryTopic,
              lineage: pending.lineage,
              ownerId: _ownerId,
              receipt: pending.receipt,
              correct: quiz.responses[quiz.index] == quiz.current.answer,
              stillCurrent: _stillCurrent));
      _round = await _store.save(
          widget.catalog, _round!.replace(widget.catalog, quiz));
    }
    if (_round!.finished && !_round!.rewardAck) {
      final quiz = _round!.session(widget.catalog);
      if (!_stillCurrent()) throw StateError('Learner changed while saving.');
      await _store.reconcileEffect(widget.catalog, _round!, () async {
        await NorieProgression.instance
            .ensureAtlasOwner(ownerId: _ownerId, stillCurrent: _stillCurrent);
        NorieProgression.instance.addXp(quiz.score * 10,
            claimKey: 'anatomy-atlas:${_round!.attemptId}');
        await NorieProgression.instance.flushPendingSaves(retry: true);
      });
      _round = await _store.save(widget.catalog,
          _round!.replace(widget.catalog, quiz, rewardAck: true));
    }
    _adopt(_round!);
  }

  Future<void> _load({bool resumeExisting = false}) async {
    await _run(() async {
      final saved = await _store.read(widget.catalog);
      _round = saved ?? await _store.start(widget.catalog, _request);
      _conflict = !resumeExisting &&
          !_round!.finished &&
          !_round!.request.matches(_request);
      if (_conflict) return;
      await _reconcile();
      _modelSession++;
      _modelReady = false;
      _hintVisible = _round!.request.difficulty == AtlasQuizDifficulty.guided;
    });
  }

  Future<void> _startNew({bool confirm = true}) async {
    if (_busy || !_stillCurrent()) return;
    if (confirm) {
      final accepted = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text('Start a new round?'),
                  content: const Text(
                      'The current round will stop. Its existing save will be preserved as a recovery copy. Unfinished rounds do not earn round XP.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Keep saved round')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Start new round'))
                  ]));
      if (accepted != true || !_stillCurrent()) return;
    }
    await _run(() async {
      final round = await _store.start(widget.catalog, _request, discard: true);
      _adopt(round);
      _conflict = false;
      _outroShown = false;
      _modelReady = false;
      _hintVisible = round.request.difficulty == AtlasQuizDifficulty.guided;
    });
  }

  Future<void> _check() async {
    if (_busy || !_stillCurrent() || _choice == null || !_modelReady) return;
    await _run(() async {
      if (_round!.pending != null) {
        await _reconcile();
        return;
      }
      final lineage = await NorieProgression.instance.prepareAtlasMastery(
          _quiz.current.masteryTopic,
          ownerId: _ownerId,
          stillCurrent: _stillCurrent);
      final next = _round!.session(widget.catalog, stillCurrent: _stillCurrent);
      final correct = next.answer(_choice!);
      if (correct == null) return;
      final answered = _round!.replace(widget.catalog, next);
      final pending = AtlasPendingAnswer(
          next.index, lineage, answered.answerReceipt(next.index));
      _round = await _store.save(widget.catalog,
          answered.replace(widget.catalog, next, pending: pending));
      await _reconcile();
      if (correct) {
        NorieAudioManager.instance.playCorrect();
      } else {
        NorieAudioManager.instance.playWrong();
      }
    });
  }

  Future<void> _next() async {
    if (_busy || !_stillCurrent()) return;
    final success = await _run(() async {
      if (_round!.finished || _round!.pending != null) {
        await _reconcile();
        return;
      }
      final next = _round!.session(widget.catalog, stillCurrent: _stillCurrent);
      if (!next.next()) return;
      _round = await _store.save(
          widget.catalog, _round!.replace(widget.catalog, next));
      await _reconcile();
      _modelReady = false;
      _hintVisible = _round!.request.difficulty == AtlasQuizDifficulty.guided;
      if (_questionScroll.hasClients) _questionScroll.jumpTo(0);
    });
    if (success && _quiz.finished) await _showOutro();
  }

  Future<void> _showOutro() async {
    if (!_stillCurrent() || _outroShown || !_round!.rewardAck) return;
    _outroShown = true;
    final request = _round!.request;
    final legacyMode = request.difficulty == AtlasQuizDifficulty.standard &&
        request.kinds.length == 1 &&
        request.kinds.contains(AtlasQuestionKind.identify);
    final action = await NorieQuizOutro.show(context,
        stillCurrent: _stillCurrent,
        summary: QuizResultSummary(
            attemptId: _attemptId,
            historyKey: quizHistoryKey(
                legacyMode
                    ? 'atlas:${request.reference}'
                    : 'atlas:${request.reference}:${request.difficulty.name}:'
                        '${(request.kinds.map((k) => k.name).toList()..sort()).join(",")}',
                _quiz.questions.map((q) => q.target.id)),
            title: 'Anatomy Atlas',
            correctCount: _quiz.score,
            totalCount: _quiz.questions.length,
            xpEarned: _quiz.score * 10,
            answers: _answers), reviewVisualBuilder: (_, answer) {
      final target = widget.catalog.structures
          .firstWhere((s) => s.id == answer.questionId);
      return _AtlasReviewModel(target: target, reference: target.reference);
    });
    if (!mounted || !_stillCurrent()) return;
    _outroShown = false;
    if (action == QuizOutroAction.retry) {
      await _startNew(confirm: false);
    } else {
      Navigator.pop(context);
    }
  }

  Widget _recoveryControls() =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        Text(_saveError ?? 'Saved round needs attention.',
            textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              FilledButton(
                  onPressed: _busy
                      ? null
                      : () async {
                          final operation = _retryOperation;
                          if (operation != null) await _run(operation);
                        },
                  child: const Text('Retry saving')),
              TextButton(
                  onPressed: _busy ? null : () => _load(),
                  child: const Text('Reload saved round')),
              TextButton(
                  onPressed: _busy ? null : _startNew,
                  child: const Text('Start new round')),
            ]),
      ]);

  @override
  Widget build(BuildContext context) {
    if (!_stillCurrent()) {
      return Scaffold(
        appBar: AppBar(title: const Text('Atlas quiz')),
        body: ListView(padding: const EdgeInsets.all(24), children: [
          const Text(
              'The learner changed or saved progress was replaced. Reopen the quiz for the current learner.'),
          const SizedBox(height: 16),
          FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Anatomy Lab')),
        ]),
      );
    }
    if (_loading) {
      return Scaffold(
          appBar: AppBar(title: const Text('Atlas quiz')),
          body: const Center(
              child: CircularProgressIndicator(
                  semanticsLabel: 'Opening saved quiz')));
    }
    if (_conflict && _round != null) {
      return Scaffold(
          appBar: AppBar(title: const Text('Saved Atlas round')),
          body: Center(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                        'You have a saved ${_round!.request.requestedCount}-question round with different settings.'),
                    const SizedBox(height: 16),
                    FilledButton(
                        onPressed:
                            _busy ? null : () => _load(resumeExisting: true),
                        child: const Text('Resume saved round')),
                    TextButton(
                        onPressed: _busy ? null : _startNew,
                        child: const Text('Start selected quiz')),
                    if (_saveError != null) _recoveryControls(),
                  ]))));
    }
    if (_activeQuiz == null) {
      return Scaffold(
          appBar: AppBar(title: const Text('Atlas quiz recovery')),
          body: Center(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _recoveryControls())));
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
            if (_saveError != null) _recoveryControls(),
            const SizedBox(height: 20),
            FilledButton(
                onPressed: _busy || !_round!.rewardAck ? null : _showOutro,
                child: const Text('Review round')),
            TextButton(
                onPressed: _busy || !_round!.rewardAck ? null : _startNew,
                child: const Text('Start new round')),
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Anatomy Lab')),
          ])));
    }
    final question = _quiz.current;
    final questionIndex = _quiz.index;
    final modelAttempt = _attemptId;
    final modelSession = _modelSession;
    final audio = NorieAudioManager.instance;
    return Scaffold(
        appBar: AppBar(
            title: Text(
                '${question.kind == AtlasQuestionKind.identify ? 'Identify' : 'System'} · ${_quiz.index + 1}/${_quiz.questions.length}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            actions: [
              IconButton(
                  tooltip: _hintVisible ? 'Hide hint' : 'Need a hint?',
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
                  key: ValueKey('atlas-model:$_attemptId:$_modelSession'),
                  controller: _controller,
                  reference: question.target.reference,
                  systems: question.target.systems,
                  target: question.target.id,
                  onLoaded: (ready) {
                    if (mounted &&
                        _stillCurrent() &&
                        _attemptId == modelAttempt &&
                        _modelSession == modelSession &&
                        _quiz.current.target.id == question.target.id &&
                        _quiz.index == questionIndex &&
                        _modelReady != ready) {
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
                    if (_busy)
                      const LinearProgressIndicator(
                          semanticsLabel: 'Saving quiz progress'),
                    if (_saveError != null) _recoveryControls(),
                    Text(question.prompt),
                    const SizedBox(height: 12),
                    if (_hintVisible)
                      KeyedSubtree(
                          key: const ValueKey('atlas-quiz-hint'),
                          child: AnatomyAtlasHintPanel(
                            key: ValueKey(
                                'hint:${_quiz.index}:${question.target.id}'),
                            assistance: _assistance(question),
                            showSourceAfterAnswer: _quiz.checked,
                            generalGuidance: question.hint,
                            stillCurrent: _stillCurrent,
                          )),
                    if (!_hintVisible)
                      TextButton.icon(
                        onPressed: _toggleHint,
                        icon: const Icon(Icons.lightbulb_outline),
                        label: const Text('Need a hint?'),
                      ),
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
                                  onPressed: _busy ||
                                          _saveError != null ||
                                          _quiz.checked ||
                                          !_modelReady
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
                            onPressed: _busy || _saveError != null
                                ? null
                                : _quiz.checked
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
