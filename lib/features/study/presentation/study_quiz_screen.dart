import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../data/norie_study_service.dart';
import '../domain/norie_study_models.dart';
import 'study_results_screen.dart';

class StudyQuizScreen extends StatefulWidget {
  const StudyQuizScreen({
    required this.studySet,
    super.key,
  });

  final NorieStudySet studySet;

  @override
  State<StudyQuizScreen> createState() => _StudyQuizScreenState();
}

class _StudyQuizScreenState extends State<StudyQuizScreen> {
  final _textController = TextEditingController();
  final List<NorieStudyAnswer> _answers = [];
  final _random = Random.secure();
  late final List<NorieStudyQuestion> _questions;

  int _index = 0;
  String? _selected;
  bool _checked = false;
  bool _correct = false;
  bool _flashcardRevealed = false;
  bool _finishing = false;

  NorieStudyQuestion get _question => _questions[_index];

  @override
  void initState() {
    super.initState();
    _questions = widget.studySet.questions.map(_randomizeQuestion).toList()
      ..shuffle(_random);
  }

  NorieStudyQuestion _randomizeQuestion(NorieStudyQuestion source) {
    if (source.options.length < 2) return source;
    final options = List<String>.from(source.options)..shuffle(_random);
    return NorieStudyQuestion(
      id: source.id,
      position: source.position,
      kind: source.kind,
      prompt: source.prompt,
      options: options,
      correctValues: List<String>.from(source.correctValues),
      explanation: source.explanation,
      sourceExcerpt: source.sourceExcerpt,
      difficulty: source.difficulty,
      topicTag: source.topicTag,
      orderedItems: List<String>.from(source.orderedItems),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  static String _normalize(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  bool _isCorrect(String response) {
    final normalized = _normalize(response);
    return _question.correctValues.any(
      (answer) => _normalize(answer) == normalized,
    );
  }

  void _check() {
    if (_checked) return;

    String response;
    switch (_question.kind) {
      case NorieStudyQuestionKind.singleSelect:
      case NorieStudyQuestionKind.trueFalse:
      case NorieStudyQuestionKind.matching:
      case NorieStudyQuestionKind.dragAndDrop:
        response = _selected ?? '';
      case NorieStudyQuestionKind.identification:
      case NorieStudyQuestionKind.fillInBlank:
        response = _textController.text.trim();
      case NorieStudyQuestionKind.ordering:
        response = _selected ?? '';
      case NorieStudyQuestionKind.flashcard:
        return;
    }

    if (response.isEmpty) return;

    final correct = _isCorrect(response);
    setState(() {
      _checked = true;
      _correct = correct;
    });

    _answers.add(
      NorieStudyAnswer(
        question: _question,
        response: response,
        correct: correct,
      ),
    );
  }

  void _rateFlashcard(bool knewIt) {
    if (_checked) return;
    setState(() {
      _checked = true;
      _correct = knewIt;
    });

    _answers.add(
      NorieStudyAnswer(
        question: _question,
        response: knewIt ? 'Knew it' : 'Review again',
        correct: knewIt,
      ),
    );
  }

  Future<void> _next() async {
    if (!_checked || _finishing) return;

    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _selected = null;
        _checked = false;
        _correct = false;
        _flashcardRevealed = false;
        _textController.clear();
      });
      return;
    }

    setState(() => _finishing = true);
    try {
      final result = await NorieStudyService.instance.recordAttempt(
        studySet: widget.studySet,
        answers: _answers,
      );
      if (!mounted) return;

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => StudyResultsScreen(
            studySet: widget.studySet,
            answers: List.unmodifiable(_answers),
            result: result,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _finishing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString().replaceFirst('Bad state: ', ''),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _questions.length;
    final progress = total == 0 ? 0.0 : (_index + 1) / total;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studySet.title),
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
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 7,
                        borderRadius: BorderRadius.circular(99),
                        color: NorieColors.cyan,
                        backgroundColor: NorieColors.surfaceElevated,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_index + 1}/$total',
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const _RandomizedSessionBanner(),
                const SizedBox(height: 14),
                _KindPill(kind: _question.kind),
                const SizedBox(height: 10),
                Text(
                  _question.prompt,
                  style: const TextStyle(
                    fontSize: 26,
                    height: 1.18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 22),
                if (_question.kind ==
                        NorieStudyQuestionKind.singleSelect ||
                    _question.kind == NorieStudyQuestionKind.trueFalse ||
                    _question.kind == NorieStudyQuestionKind.matching ||
                    _question.kind == NorieStudyQuestionKind.dragAndDrop)
                  for (final option in _question.options)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _Choice(
                        label: option,
                        selected: _selected == option,
                        checked: _checked,
                        correct: _question.correctValues.any(
                          (answer) => _normalize(answer) == _normalize(option),
                        ),
                        onTap: _checked
                            ? null
                            : () => setState(() => _selected = option),
                      ),
                    )
                else if (_question.kind ==
                        NorieStudyQuestionKind.identification ||
                    _question.kind == NorieStudyQuestionKind.fillInBlank)
                  TextField(
                    controller: _textController,
                    enabled: !_checked,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _check(),
                    decoration: const InputDecoration(
                      labelText: 'Your answer',
                      prefixIcon: Icon(Icons.edit_rounded),
                    ),
                  )
                else if (_question.kind == NorieStudyQuestionKind.ordering)
                  _OrderingRecall(
                    items: _question.orderedItems,
                    selected: _selected,
                    checked: _checked,
                    onSelected: (value) => setState(() => _selected = value),
                  )
                else
                  _Flashcard(
                    answer: _question.correctValues.isEmpty
                        ? ''
                        : _question.correctValues.first,
                    revealed: _flashcardRevealed,
                    checked: _checked,
                    onReveal: () =>
                        setState(() => _flashcardRevealed = true),
                    onRate: _rateFlashcard,
                  ),
                if (_checked) ...[
                  const SizedBox(height: 18),
                  _FeedbackCard(
                    correct: _correct,
                    question: _question,
                  ),
                ],
                const SizedBox(height: 24),
                if (_question.kind != NorieStudyQuestionKind.flashcard)
                  FilledButton(
                    onPressed: _checked
                        ? (_finishing ? null : _next)
                        : ((_selected != null ||
                                _textController.text.trim().isNotEmpty)
                            ? _check
                            : null),
                    style: FilledButton.styleFrom(
                      backgroundColor: NorieColors.cyan,
                      foregroundColor: NorieColors.background,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      _finishing
                          ? 'Saving…'
                          : _checked
                              ? (_index == total - 1
                                  ? 'View Results'
                                  : 'Next')
                              : 'Check Answer',
                    ),
                  )
                else if (_checked)
                  FilledButton(
                    onPressed: _finishing ? null : _next,
                    child: Text(
                      _index == total - 1 ? 'View Results' : 'Next',
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

class _RandomizedSessionBanner extends StatelessWidget {
  const _RandomizedSessionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: NorieColors.violet.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: NorieColors.violet.withValues(alpha: .35)),
      ),
      child: const Row(
        children: [
          Icon(Icons.casino_rounded, size: 17, color: NorieColors.violet),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Randomized run · item order and answer positions change each attempt',
              style: TextStyle(
                color: NorieColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KindPill extends StatelessWidget {
  const _KindPill({required this.kind});

  final NorieStudyQuestionKind kind;

  @override
  Widget build(BuildContext context) {
    final label = switch (kind) {
      NorieStudyQuestionKind.singleSelect => 'MULTIPLE CHOICE',
      NorieStudyQuestionKind.trueFalse => 'TRUE / FALSE',
      NorieStudyQuestionKind.identification => 'IDENTIFICATION',
      NorieStudyQuestionKind.matching => 'MATCHING',
      NorieStudyQuestionKind.dragAndDrop => 'DRAG & DROP',
      NorieStudyQuestionKind.ordering => 'ORDERING',
      NorieStudyQuestionKind.fillInBlank => 'FILL IN THE BLANK',
      NorieStudyQuestionKind.flashcard => 'FLASHCARD',
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: NorieColors.violet.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: NorieColors.violet,
            fontSize: 9,
            letterSpacing: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
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
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var border = selected ? NorieColors.cyan : NorieColors.border;
    var fill = NorieColors.surface;

    if (checked && correct) {
      border = NorieColors.green;
      fill = NorieColors.green.withValues(alpha: .10);
    } else if (checked && selected && !correct) {
      border = NorieColors.magenta;
      fill = NorieColors.magenta.withValues(alpha: .10);
    }

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    fontWeight: FontWeight.w700,
                  ),
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
              else if (selected)
                const Icon(
                  Icons.radio_button_checked_rounded,
                  color: NorieColors.cyan,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderingRecall extends StatelessWidget {
  const _OrderingRecall({
    required this.items,
    required this.selected,
    required this.checked,
    required this.onSelected,
  });

  final List<String> items;
  final String? selected;
  final bool checked;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Text(
        'This generated ordering item has no sequence data.',
        style: TextStyle(color: NorieColors.textSecondary),
      );
    }

    final expected = items.join(' → ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Recall the correct sequence, then reveal it.',
          style: TextStyle(color: NorieColors.textSecondary),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: checked ? null : () => onSelected(expected),
          child: Text(selected == null ? 'Reveal sequence' : expected),
        ),
      ],
    );
  }
}

class _Flashcard extends StatelessWidget {
  const _Flashcard({
    required this.answer,
    required this.revealed,
    required this.checked,
    required this.onReveal,
    required this.onRate,
  });

  final String answer;
  final bool revealed;
  final bool checked;
  final VoidCallback onReveal;
  final ValueChanged<bool> onRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: NorieColors.border),
      ),
      child: Column(
        children: [
          if (!revealed)
            OutlinedButton.icon(
              onPressed: onReveal,
              icon: const Icon(Icons.visibility_rounded),
              label: const Text('Reveal Answer'),
            )
          else ...[
            Text(
              answer,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: NorieColors.cyan,
              ),
            ),
            if (!checked) ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => onRate(false),
                      child: const Text('Review Again'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => onRate(true),
                      child: const Text('I Knew It'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({
    required this.correct,
    required this.question,
  });

  final bool correct;
  final NorieStudyQuestion question;

  @override
  Widget build(BuildContext context) {
    final color = correct ? NorieColors.green : NorieColors.magenta;
    final correctAnswer = question.correctValues.join(' / ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: .55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            correct ? 'Correct' : 'Review this one',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (!correct && correctAnswer.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Answer: $correctAnswer',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (question.explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              question.explanation,
              style: const TextStyle(
                color: NorieColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
          if (question.sourceExcerpt.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'FROM YOUR SOURCE',
              style: TextStyle(
                color: NorieColors.cyan,
                fontSize: 9,
                letterSpacing: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '“${question.sourceExcerpt}”',
              style: const TextStyle(
                color: NorieColors.textSecondary,
                fontSize: 11,
                fontStyle: FontStyle.italic,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
