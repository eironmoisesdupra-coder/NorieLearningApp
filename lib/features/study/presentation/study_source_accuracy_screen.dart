import 'package:flutter/material.dart';

import '../domain/norie_study_models.dart';
import '../domain/study_source_review.dart';
import '../data/norie_study_service.dart';
import '../../curriculum/presentation/curriculum_session_guard.dart';

/// Human source inspection, not an AI or scientific correctness certification.
/// Decisions persist by learner and content revision, never as expert approval.
class StudySourceAccuracyScreen extends StatefulWidget {
  const StudySourceAccuracyScreen(
      {required this.studySet, this.continueToPractice = false, super.key});
  final NorieStudySet studySet;
  final bool continueToPractice;

  @override
  State<StudySourceAccuracyScreen> createState() =>
      _StudySourceAccuracyScreenState();
}

class _StudySourceAccuracyScreenState extends State<StudySourceAccuracyScreen>
    with CurriculumSessionGuard<StudySourceAccuracyScreen> {
  StudySourceReview? _review;
  bool _loading = true, _saving = false;
  String? _error;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  bool get _current =>
      curriculumSessionCurrent &&
      NorieStudyService.instance.canAccessStudySet(widget.studySet);

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final review =
          await NorieStudyService.instance.loadSourceReview(widget.studySet);
      if (!mounted || !_current) return;
      setState(() => _review = review);
    } catch (_) {
      if (_current) {
        setState(() => _error =
            'Saved source comparison could not be read. Its data has been kept.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _decide(SourceReviewDecision decision) async {
    if (_saving || !_current || _review == null) return;
    final question = widget.studySet.questions[_index];
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final review = await NorieStudyService.instance
          .saveSourceReview(widget.studySet, question.id, decision);
      if (!mounted || !_current) return;
      setState(() => _review = review);
    } catch (_) {
      if (mounted && _current) {
        setState(() => _error =
            'Could not save this comparison. Your previous decision has been kept. Retry when storage is available.');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_error!)));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_current) return changedCurriculumSession;
    final questions = widget.studySet.questions;
    if (_loading || _review == null || questions.isEmpty) {
      return Scaffold(
          appBar: AppBar(title: const Text('Source Accuracy Review')),
          body: SafeArea(
              child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: _loading
                          ? const CircularProgressIndicator()
                          : Column(mainAxisSize: MainAxisSize.min, children: [
                              Text(_error ?? 'No cards to compare.'),
                              if (_error != null)
                                TextButton(
                                    onPressed: _load,
                                    child: const Text('Retry')),
                            ])))));
    }
    final question = questions[_index];
    final excerpt = question.sourceExcerpt.trim();
    final status = _review!.statusFor(widget.studySet, question);
    final checked = questions
        .where((q) =>
            _review!.statusFor(widget.studySet, q) ==
            SourceReviewStatus.compared)
        .length;
    final complete = _review!.completeFor(widget.studySet);
    return Scaffold(
      appBar: AppBar(title: const Text('Source Accuracy Review')),
      body: SafeArea(
          child: Center(
              child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Text('Card ${_index + 1} of ${questions.length}',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text(
              'Compare each generated answer and explanation with your original material. A matching excerpt is evidence, not proof of scientific correctness.'),
          const SizedBox(height: 16),
          LinearProgressIndicator(
              value: checked / questions.length,
              semanticsLabel:
                  'Source comparisons: $checked of ${questions.length}'),
          if (_error != null) Semantics(liveRegion: true, child: Text(_error!)),
          const SizedBox(height: 16),
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('GENERATED QUESTION',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(question.prompt),
                        const SizedBox(height: 12),
                        const Text('GENERATED ANSWER',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(question.kind == NorieStudyQuestionKind.ordering
                            ? question.orderedItems.join(' → ')
                            : question.correctValues.join(' / ')),
                        const SizedBox(height: 12),
                        const Text('EXPLANATION',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(question.explanation),
                      ]))),
          const SizedBox(height: 12),
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('SOURCE EXCERPT',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            'Source: ${widget.studySet.sourceName ?? 'Original study material'}'),
                        const SizedBox(height: 8),
                        if (excerpt.isEmpty)
                          const Text(
                              'No source excerpt was retained. This card needs source checking; do not treat it as verified.')
                        else
                          Text(excerpt),
                      ]))),
          const SizedBox(height: 12),
          if (status == SourceReviewStatus.flagged)
            const Text(
                'Flagged: return to the study set and edit or remove this card before graded practice.'),
          CheckboxListTile(
            value: status == SourceReviewStatus.compared,
            onChanged: _saving ||
                    excerpt.isEmpty ||
                    !StudySourceReview.hasAnswerContent(question)
                ? null
                : (checked) => _decide(checked == true
                    ? SourceReviewDecision.compared
                    : SourceReviewDecision.unchecked),
            title: const Text(
                'I checked the answer and explanation against my source'),
            subtitle: const Text(
                'This confirms a manual comparison only, not expert approval.'),
          ),
          OutlinedButton.icon(
            onPressed: _saving
                ? null
                : () => _decide(status == SourceReviewStatus.flagged
                    ? SourceReviewDecision.unchecked
                    : SourceReviewDecision.flagged),
            icon: const Icon(Icons.flag_outlined),
            label: Text(status == SourceReviewStatus.flagged
                ? 'Clear flag'
                : 'Flag for correction'),
          ),
          const SizedBox(height: 12),
          Wrap(spacing: 10, runSpacing: 8, children: [
            OutlinedButton(
              onPressed: _saving || _index == 0
                  ? null
                  : () => setState(() => _index--),
              child: const Text('Previous'),
            ),
            OutlinedButton(
              onPressed: _saving || _index == questions.length - 1
                  ? null
                  : () => setState(() => _index++),
              child: const Text('Next'),
            ),
          ]),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: !_saving && complete && _current
                ? () => Navigator.pop(context, true)
                : null,
            icon: const Icon(Icons.fact_check),
            label: Text(complete
                ? (widget.continueToPractice ? 'Continue to practice' : 'Done')
                : 'Review all cards ($checked/${questions.length})'),
          ),
          const SizedBox(height: 8),
          const Text(
              'Flagged or unchecked cards block graded practice. You can still leave and edit the deck.'),
        ]),
      ))),
    );
  }
}
