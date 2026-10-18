import 'curriculum_session_guard.dart';
import 'package:flutter/material.dart';
import '../../content/domain/norie_content_models.dart';
import '../domain/guided_assessment.dart';

class NorieGuidedPracticeScreen extends StatefulWidget {
  const NorieGuidedPracticeScreen(
      {required this.topic,
      required this.guided,
      required this.session,
      super.key});
  final NorieTopicContent topic;
  final bool guided;
  final GuidedPracticeSession session;
  @override
  State<NorieGuidedPracticeScreen> createState() =>
      _NorieGuidedPracticeScreenState();
}

class _NorieGuidedPracticeScreenState extends State<NorieGuidedPracticeScreen>
    with CurriculumSessionGuard<NorieGuidedPracticeScreen> {
  int _index = 0;
  GuidedAssessmentFormat _format = GuidedAssessmentFormat.choice;
  final _typed = TextEditingController();
  final _selected = <int>{};
  List<String> _ordered = [];
  bool? _correct;
  bool _showHelp = false;
  NorieQuestionContent get _question => widget.topic.quiz.questions[_index];
  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  void _reset() {
    _correct = null;
    _typed.clear();
    _selected.clear();
    _ordered = _question.orderedItems.reversed.toList();
    _showHelp = widget.guided || widget.session.usedHelp(_question.id);
    if (_showHelp) widget.session.revealHelp(_question.id);
  }

  GuidedAssessmentItem get _item => switch (_format) {
        GuidedAssessmentFormat.text => GuidedAssessmentItem.text(
            id: _question.id,
            prompt: _question.prompt,
            accepted: _question.acceptedAnswers),
        GuidedAssessmentFormat.ordering => GuidedAssessmentItem.ordering(
            id: _question.id,
            prompt: _question.prompt,
            items: _question.orderedItems),
        _ => GuidedAssessmentItem.selection(
            id: _question.id,
            prompt: _question.prompt,
            options: _question.options,
            answers: {_question.correctIndex}),
      };
  void _check() {
    final correct = switch (_format) {
      GuidedAssessmentFormat.text => _item.checkText(_typed.text),
      GuidedAssessmentFormat.ordering => _item.checkOrder(_ordered),
      _ => _item.checkSelection(_selected),
    };
    widget.session.record(_question.id, correct: correct);
    // Feedback is assistance on any later attempt at this item.
    widget.session.revealHelp(_question.id);
    setState(() {
      _correct = correct;
      _showHelp = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!curriculumSessionCurrent) return changedCurriculumSession;
    final question = _question;
    final formats = [
      GuidedAssessmentFormat.choice,
      if (question.acceptedAnswers.isNotEmpty) GuidedAssessmentFormat.text,
      if (question.orderedItems.length >= 2) GuidedAssessmentFormat.ordering
    ];
    return Scaffold(
        appBar: AppBar(
            title:
                Text(widget.guided ? 'Guided try' : 'Independent rehearsal')),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child:
                        ListView(padding: const EdgeInsets.all(20), children: [
                      Text(
                          'Item ${_index + 1} of ${widget.topic.quiz.questions.length}'),
                      const SizedBox(height: 10),
                      Text(widget.session.usedHelp(question.id)
                          ? 'Assisted rehearsal · help has been used'
                          : 'Independent rehearsal · no help used yet'),
                      const SizedBox(height: 14),
                      Text(question.prompt,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      if (formats.length > 1)
                        Wrap(spacing: 8, children: [
                          for (final format in formats)
                            ChoiceChip(
                                label: Text(switch (format) {
                                  GuidedAssessmentFormat.text => 'Type answer',
                                  GuidedAssessmentFormat.ordering =>
                                    'Order steps',
                                  _ => 'Choose answer'
                                }),
                                selected: _format == format,
                                onSelected: (_) => setState(() {
                                      _format = format;
                                      _reset();
                                    }))
                        ]),
                      const SizedBox(height: 16),
                      if (_format == GuidedAssessmentFormat.choice) ...[
                        for (var i = 0; i < question.options.length; i++)
                          Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: OutlinedButton(
                                  onPressed: _correct == null
                                      ? () => setState(() {
                                            _selected.clear();
                                            _selected.add(i);
                                          })
                                      : null,
                                  style: OutlinedButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      backgroundColor: _selected.contains(i)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                          : null,
                                      padding: const EdgeInsets.all(16)),
                                  child: Text(question.options[i]))),
                      ] else if (_format == GuidedAssessmentFormat.text)
                        TextField(
                            controller: _typed,
                            enabled: _correct == null,
                            decoration:
                                const InputDecoration(labelText: 'Your answer'))
                      else ...[
                        const Text(
                            'Arrange the authored steps using the up and down buttons.'),
                        for (var i = 0; i < _ordered.length; i++)
                          Card(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text('${i + 1}. ${_ordered[i]}')),
                                Wrap(children: [
                                  IconButton(
                                      tooltip: 'Move step up',
                                      onPressed: i == 0 || _correct != null
                                          ? null
                                          : () => _move(i, i - 1),
                                      icon: const Icon(Icons.arrow_upward)),
                                  IconButton(
                                      tooltip: 'Move step down',
                                      onPressed: i == _ordered.length - 1 ||
                                              _correct != null
                                          ? null
                                          : () => _move(i, i + 1),
                                      icon: const Icon(Icons.arrow_downward))
                                ])
                              ])),
                      ],
                      const SizedBox(height: 12),
                      if (_correct == null)
                        FilledButton(
                            onPressed: _item.isValid ? _check : null,
                            child: const Text('Check answer')),
                      TextButton.icon(
                          onPressed: () => setState(() {
                                widget.session.revealHelp(question.id);
                                _showHelp = true;
                              }),
                          icon: const Icon(Icons.lightbulb_outline),
                          label: const Text('Show explanation')),
                      if (_correct != null)
                        Text(
                            _correct!
                                ? 'Correct'
                                : 'Review the explanation and try the next item.',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      if (_showHelp)
                        Card(
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: SelectableText(question.explanation,
                                    style: const TextStyle(
                                        fontSize: 18, height: 1.5)))),
                      if (_correct != null)
                        FilledButton(
                            onPressed: () {
                              if (_index + 1 ==
                                  widget.topic.quiz.questions.length) {
                                Navigator.of(context).pop();
                                return;
                              }
                              setState(() {
                                _index++;
                                _format = GuidedAssessmentFormat.choice;
                                _reset();
                              });
                            },
                            child: Text(
                                _index + 1 == widget.topic.quiz.questions.length
                                    ? 'Finish rehearsal'
                                    : 'Next item')),
                      const SizedBox(height: 12),
                      Text(
                          '${widget.session.independentCorrect} independent correct answers in this rehearsal. Assistance is tracked across retries and formats. Rehearsal is separate from lesson mastery and later retention.'),
                    ])))));
  }

  void _move(int from, int to) => setState(() {
        final item = _ordered.removeAt(from);
        _ordered.insert(to, item);
      });
}
