import 'package:flutter/material.dart';

import '../domain/norie_study_models.dart';

/// Human source inspection, not an AI or scientific correctness certification.
/// Review decisions are session-only and never count as academic mastery.
class StudySourceAccuracyScreen extends StatefulWidget {
  const StudySourceAccuracyScreen({required this.studySet, super.key});
  final NorieStudySet studySet;

  @override
  State<StudySourceAccuracyScreen> createState() => _StudySourceAccuracyScreenState();
}

class _StudySourceAccuracyScreenState extends State<StudySourceAccuracyScreen> {
  final Set<String> _checked = {};
  final Set<String> _flagged = {};
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final questions = widget.studySet.questions;
    final question = questions[_index];
    final excerpt = question.sourceExcerpt.trim();
    final complete = _checked.length == questions.length && _flagged.isEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('Source Accuracy Review')),
      body: SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Text('Card ${_index + 1} of ${questions.length}',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('Compare each generated answer and explanation with your original material. A matching excerpt is evidence, not proof of scientific correctness.'),
          const SizedBox(height: 16),
          LinearProgressIndicator(value: _checked.length / questions.length),
          const SizedBox(height: 16),
          Card(child: Padding(padding: const EdgeInsets.all(16), child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('GENERATED QUESTION', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(question.prompt),
              const SizedBox(height: 12),
              const Text('GENERATED ANSWER', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(question.correctValues.join(' / ')),
              const SizedBox(height: 12),
              const Text('EXPLANATION', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(question.explanation),
            ]))),
          const SizedBox(height: 12),
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('SOURCE EXCERPT', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (excerpt.isEmpty)
                const Text('No source excerpt was retained. This card needs source checking; do not treat it as verified.')
              else Text(excerpt),
            ]))),
          const SizedBox(height: 12),
          if (_flagged.contains(question.id))
            const Text('Flagged: return to the study set and edit or remove this card before graded practice.'),
          CheckboxListTile(
            value: _checked.contains(question.id),
            onChanged: (checked) => setState(() {
              if (checked == true) {
                _checked.add(question.id);
                _flagged.remove(question.id);
              } else {
                _checked.remove(question.id);
              }
            }),
            title: const Text('I checked the answer and explanation against my source'),
            subtitle: const Text('This confirms a manual comparison only, not expert approval.'),
          ),
          OutlinedButton.icon(
            onPressed: () => setState(() {
              _flagged.add(question.id);
              _checked.remove(question.id);
            }),
            icon: const Icon(Icons.flag_outlined),
            label: const Text('Flag for correction'),
          ),
          const SizedBox(height: 12),
          Row(children: [
            OutlinedButton(
              onPressed: _index == 0 ? null : () => setState(() => _index--),
              child: const Text('Previous'),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: _index == questions.length - 1 ? null : () => setState(() => _index++),
              child: const Text('Next'),
            ),
          ]),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: complete ? () => Navigator.pop(context, true) : null,
            icon: const Icon(Icons.fact_check),
            label: Text(complete ? 'Continue to practice' :
              'Review all cards (${_checked.length}/${questions.length})'),
          ),
          const SizedBox(height: 8),
          const Text('Flagged or unchecked cards block graded practice. You can still leave and edit the deck.'),
        ]),
      )))),
    );
  }
}
