import 'package:flutter/material.dart';
import '../domain/guided_assessment.dart';
import 'curriculum_session_guard.dart';

/// Explicitly authored formats only: no prose-to-answer or unit guessing.
class NorieAuthoredPracticeScreen extends StatefulWidget {
  const NorieAuthoredPracticeScreen(
      {required this.items,
      required this.explanations,
      required this.session,
      super.key});
  final List<GuidedAssessmentItem> items;
  final Map<String, String> explanations;
  final GuidedPracticeSession session;
  @override
  State<NorieAuthoredPracticeScreen> createState() =>
      _NorieAuthoredPracticeScreenState();
}

class _NorieAuthoredPracticeScreenState
    extends State<NorieAuthoredPracticeScreen>
    with CurriculumSessionGuard<NorieAuthoredPracticeScreen> {
  final _answer = TextEditingController();
  final _unit = TextEditingController();
  final _selection = <int>{};
  List<String> _order = [];
  int _index = 0;
  bool? _correct;
  bool _help = false;
  GuidedAssessmentItem get _item => widget.items[_index];
  @override
  void initState() {
    super.initState();
    if (widget.items.isNotEmpty) _reset();
  }

  @override
  void dispose() {
    _answer.dispose();
    _unit.dispose();
    super.dispose();
  }

  void _reset() {
    _answer.clear();
    _unit.clear();
    _selection.clear();
    _order = _item.ordered.reversed.toList();
    _correct = null;
    _help = widget.session.usedHelp(_item.id);
  }

  void _showHelp() {
    widget.session.revealHelp(_item.id);
    setState(() => _help = true);
  }

  void _check() {
    requireCurrentCurriculumSession();
    final correct = switch (_item.format) {
      GuidedAssessmentFormat.choice ||
      GuidedAssessmentFormat.multiSelect =>
        _item.checkSelection(_selection),
      GuidedAssessmentFormat.numeric =>
        _item.checkNumeric(_answer.text, _unit.text),
      GuidedAssessmentFormat.text => _item.checkText(_answer.text),
      GuidedAssessmentFormat.ordering => _item.checkOrder(_order),
    };
    widget.session.record(_item.id, correct: correct);
    widget.session.revealHelp(_item.id);
    setState(() {
      _correct = correct;
      _help = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!curriculumSessionCurrent) return changedCurriculumSession;
    if (widget.items.isEmpty || widget.items.any((i) => !i.isValid)) {
      return Scaffold(
          appBar: AppBar(title: const Text('Authored rehearsal')),
          body:
              const Center(child: Text('No valid authored assessment items.')));
    }
    final item = _item;
    return Scaffold(
        appBar: AppBar(title: const Text('Authored rehearsal')),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child:
                        ListView(padding: const EdgeInsets.all(20), children: [
                      Text('Item ${_index + 1} of ${widget.items.length}'),
                      Text(widget.session.usedHelp(item.id)
                          ? 'Assistance used for this item'
                          : 'No help used for this item'),
                      const SizedBox(height: 12),
                      Text(item.prompt,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      if (item.format == GuidedAssessmentFormat.numeric) ...[
                        TextField(
                            key: const Key('numeric-answer'),
                            controller: _answer,
                            enabled: _correct == null,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true, signed: true),
                            decoration: const InputDecoration(
                                labelText: 'Numerical answer')),
                        const SizedBox(height: 12),
                        TextField(
                            key: const Key('numeric-unit'),
                            controller: _unit,
                            enabled: _correct == null,
                            decoration: const InputDecoration(
                                labelText: 'Unit',
                                helperText: 'Use the requested unit symbol.')),
                      ] else if (item.format == GuidedAssessmentFormat.text)
                        TextField(
                            controller: _answer,
                            enabled: _correct == null,
                            decoration:
                                const InputDecoration(labelText: 'Your answer'))
                      else if (item.format ==
                          GuidedAssessmentFormat.ordering) ...[
                        for (var i = 0; i < _order.length; i++)
                          Card(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text('${i + 1}. ${_order[i]}')),
                                Wrap(children: [
                                  IconButton(
                                      tooltip: 'Move step up',
                                      onPressed: _correct != null || i == 0
                                          ? null
                                          : () => _move(i, i - 1),
                                      icon: const Icon(Icons.arrow_upward)),
                                  IconButton(
                                      tooltip: 'Move step down',
                                      onPressed: _correct != null ||
                                              i == _order.length - 1
                                          ? null
                                          : () => _move(i, i + 1),
                                      icon: const Icon(Icons.arrow_downward))
                                ])
                              ])),
                      ] else ...[
                        Text(item.format == GuidedAssessmentFormat.multiSelect
                            ? 'Select every correct answer.'
                            : 'Choose one answer.'),
                        for (var i = 0; i < item.options.length; i++)
                          CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(item.options[i]),
                              value: _selection.contains(i),
                              onChanged: _correct != null
                                  ? null
                                  : (selected) => setState(() {
                                        if (item.format ==
                                            GuidedAssessmentFormat.choice) {
                                          _selection.clear();
                                        }
                                        if (selected == true) {
                                          _selection.add(i);
                                        } else {
                                          _selection.remove(i);
                                        }
                                      })),
                      ],
                      const SizedBox(height: 16),
                      if (_correct == null)
                        FilledButton(
                            onPressed: _check,
                            child: const Text('Check answer')),
                      TextButton(
                          onPressed: _showHelp,
                          child: const Text('Show explanation')),
                      if (_correct != null)
                        Text(_correct! ? 'Correct' : 'Review the explanation.',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      if (_help)
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SelectableText(widget
                                    .explanations[item.id] ??
                                'No authored explanation is available. This draft needs editorial review.')),
                      if (_correct != null)
                        FilledButton(
                            onPressed: () {
                              if (_index + 1 == widget.items.length) {
                                Navigator.of(context).pop();
                              } else {
                                setState(() {
                                  _index++;
                                  _reset();
                                });
                              }
                            },
                            child: Text(_index + 1 == widget.items.length
                                ? 'Finish rehearsal'
                                : 'Next item')),
                      const SizedBox(height: 12),
                      const Text(
                          'Local rehearsal only. Assisted answers, independent answers and later retention are separate. Regular lesson rewards are unchanged.'),
                    ])))));
  }

  void _move(int from, int to) => setState(() {
        final value = _order.removeAt(from);
        _order.insert(to, value);
      });
}
