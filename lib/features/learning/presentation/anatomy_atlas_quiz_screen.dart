import 'package:flutter/material.dart';
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
      super.key});
  final AnatomyAtlasCatalog catalog;
  final String reference;
  final Set<String> systems;
  @override
  State<AnatomyAtlasQuizScreen> createState() => _AnatomyAtlasQuizScreenState();
}

class _AnatomyAtlasQuizScreenState extends State<AnatomyAtlasQuizScreen> {
  final _controller = AnatomyAtlasController();
  late final _quiz = AtlasQuizSession.generate(
      widget.catalog, widget.reference, widget.systems);
  String? _choice;
  bool _modelReady = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() {
    if (_choice == null || !_modelReady) return;
    final correct = _quiz.answer(_choice!);
    if (correct == null) return;
    final topic = AnatomyCatalog.systems
        .firstWhere((s) => s.id.name == _quiz.current.target.systems.first)
        .label;
    NorieProgression.instance
        .recordTopicAnswer(category: 'Anatomy', topic: topic, correct: correct);
    setState(() {});
  }

  void _next() {
    if (!_quiz.next()) return;
    final reward = _quiz.takeReward();
    if (reward != null) NorieProgression.instance.addXp(reward);
    setState(() {
      _choice = null;
      _modelReady = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
        appBar: AppBar(
            title: Text(
                'Identify · ${_quiz.index + 1}/${_quiz.questions.length}')),
        body: SafeArea(
            child: Column(children: [
          const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                  'Which structure is highlighted? Rotate or zoom to inspect it.')),
          Expanded(
              flex: 5,
              child: AnatomyAtlasModelView(
                  controller: _controller,
                  reference: widget.reference,
                  systems: question.target.systems,
                  target: question.target.id,
                  onLoaded: (ready) {
                    if (mounted && _modelReady != ready) {
                      setState(() => _modelReady = ready);
                    }
                  },
                  quiz: true)),
          Flexible(
              flex: 5,
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(children: [
                    for (final option in question.options)
                      Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: _quiz.checked &&
                                              option == question.target.name
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
                                      : () => setState(() => _choice = option),
                                  child: Text(option,
                                      textAlign: TextAlign.center)))),
                    if (_quiz.checked)
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                              _choice == question.target.name
                                  ? 'Correct: ${question.target.name}'
                                  : 'Answer: ${question.target.name}',
                              style: const TextStyle(color: NorieColors.cyan))),
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
