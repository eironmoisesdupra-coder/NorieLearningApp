import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../application/norie_activity_engine.dart';
import '../domain/norie_content_models.dart';
import 'norie_challenge_screen.dart';
import 'norie_content_theme.dart';

class NorieActivityScreen extends StatefulWidget {
  const NorieActivityScreen({
    required this.topic,
    required this.requestedMode,
    super.key,
  });

  final NorieTopicContent topic;
  final NorieActivityMode requestedMode;

  @override
  State<NorieActivityScreen> createState() => _NorieActivityScreenState();
}

class _NorieActivityScreenState extends State<NorieActivityScreen> {
  final _random = Random.secure();
  final _controller = TextEditingController();
  late final List<NorieRandomizedQuestion> _items;
  late List<String> _ordered;

  int _current = 0;
  int _score = 0;
  int? _selected;
  bool _checked = false;
  bool _revealed = false;
  bool? _truth;
  String? _dropped;

  NorieRandomizedQuestion get item => _items[_current];
  NorieQuestionContent get question => item.source;
  String get expected => question.resolvedAcceptedAnswers.isNotEmpty
      ? question.resolvedAcceptedAnswers.first
      : '';
  NorieActivityMode get mode => widget.requestedMode == NorieActivityMode.mixed
      ? NorieItemRandomizer.randomMode(question: question, random: _random)
      : widget.requestedMode;

  @override
  void initState() {
    super.initState();
    _items = NorieItemRandomizer.randomize(
      widget.topic.quiz.questions,
      random: _random,
    );
    _prepareOrder();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _prepareOrder() {
    _ordered = List<String>.from(question.orderedItems)..shuffle(_random);
  }

  bool _typedCorrect() => question.resolvedAcceptedAnswers.any(
        (answer) => norieAnswerMatches(_controller.text, answer),
      );

  bool _choiceCorrect() => _selected == item.correctIndex;

  bool _truthCorrect() {
    final statement = item.options[_selected ?? 0];
    return _truth == norieAnswerMatches(statement, expected);
  }

  bool _orderCorrect() {
    if (question.orderedItems.isEmpty) return _choiceCorrect();
    for (var i = 0; i < question.orderedItems.length; i++) {
      if (!norieAnswerMatches(_ordered[i], question.orderedItems[i])) {
        return false;
      }
    }
    return true;
  }

  void _submit(bool correct) {
    if (_checked) return;
    setState(() {
      _checked = true;
      if (correct) _score++;
    });
  }

  void _next() {
    if (!_checked) return;
    if (_current == _items.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => NorieChallengeScreen(
            topic: widget.topic,
            quizScore: _score,
          ),
        ),
      );
      return;
    }
    setState(() {
      _current++;
      _selected = null;
      _checked = false;
      _revealed = false;
      _truth = null;
      _dropped = null;
      _controller.clear();
      _prepareOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = norieContentAccent(widget.topic.accent);
    final activeMode = mode;
    return Scaffold(
      appBar: AppBar(
        title: Text(activeMode.label),
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
                  value: (_current + 1) / _items.length,
                  minHeight: 7,
                  borderRadius: BorderRadius.circular(99),
                  color: accent,
                  backgroundColor: NorieColors.surfaceElevated,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 7,
                  children: [
                    _Badge(activeMode.label, accent),
                    const _Badge('ITEMS SHUFFLED', NorieColors.violet),
                    const _Badge('CHOICES SHUFFLED', NorieColors.orange),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  question.prompt,
                  style: const TextStyle(
                    fontSize: 26,
                    height: 1.16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 22),
                _body(activeMode, accent),
                if (_checked && activeMode != NorieActivityMode.flashcards) ...[
                  const SizedBox(height: 14),
                  _feedback(_correctFor(activeMode)),
                ],
                if (_checked) ...[
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _next,
                    child: Text(
                      _current == _items.length - 1
                          ? 'Continue to challenge'
                          : 'Next randomized item',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _correctFor(NorieActivityMode activeMode) => switch (activeMode) {
        NorieActivityMode.multipleChoice ||
        NorieActivityMode.matching =>
          _choiceCorrect(),
        NorieActivityMode.identification ||
        NorieActivityMode.fillInBlank =>
          _typedCorrect(),
        NorieActivityMode.trueFalse => _truthCorrect(),
        NorieActivityMode.dragAndDrop =>
          _dropped != null && norieAnswerMatches(_dropped!, expected),
        NorieActivityMode.ordering => _orderCorrect(),
        NorieActivityMode.flashcards => true,
        NorieActivityMode.mixed => false,
      };

  Widget _body(NorieActivityMode activeMode, Color accent) {
    return switch (activeMode) {
      NorieActivityMode.multipleChoice =>
        _choices(accent, 'Choose the best answer.'),
      NorieActivityMode.matching =>
        _choices(accent, 'Match the prompt with its answer.'),
      NorieActivityMode.identification =>
        _typed(accent, 'Type the answer from memory.'),
      NorieActivityMode.fillInBlank =>
        _typed(accent, 'Fill in the missing answer.'),
      NorieActivityMode.trueFalse => _trueFalse(accent),
      NorieActivityMode.flashcards => _flashcard(accent),
      NorieActivityMode.dragAndDrop => _dragDrop(accent),
      NorieActivityMode.ordering => _ordering(accent),
      NorieActivityMode.mixed => const SizedBox.shrink(),
    };
  }

  Widget _choices(Color accent, String instruction) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(instruction,
              style: const TextStyle(color: NorieColors.textSecondary)),
          const SizedBox(height: 10),
          for (var i = 0; i < item.options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: OutlinedButton(
                onPressed:
                    _checked ? null : () => setState(() => _selected = i),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: _selected == i ? accent : NorieColors.border,
                  ),
                  padding: const EdgeInsets.all(16),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(item.options[i]),
                ),
              ),
            ),
          if (!_checked)
            FilledButton(
              onPressed:
                  _selected == null ? null : () => _submit(_choiceCorrect()),
              child: const Text('Check answer'),
            ),
        ],
      );

  Widget _typed(Color accent, String hint) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            enabled: !_checked,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(Icons.edit_rounded, color: accent),
            ),
          ),
          const SizedBox(height: 12),
          if (!_checked)
            FilledButton(
              onPressed: _controller.text.trim().isEmpty
                  ? null
                  : () => _submit(_typedCorrect()),
              child: const Text('Check answer'),
            ),
        ],
      );

  Widget _trueFalse(Color accent) {
    _selected ??= _random.nextInt(item.options.length);
    final statement = item.options[_selected!];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _panel(statement),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed:
                    _checked ? null : () => setState(() => _truth = true),
                child: const Text('TRUE'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed:
                    _checked ? null : () => setState(() => _truth = false),
                child: const Text('FALSE'),
              ),
            ),
          ],
        ),
        if (!_checked) ...[
          const SizedBox(height: 10),
          FilledButton(
            onPressed: _truth == null ? null : () => _submit(_truthCorrect()),
            child: const Text('Lock answer'),
          ),
        ],
      ],
    );
  }

  Widget _flashcard(Color accent) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: _checked
                ? null
                : () => setState(() => _revealed = !_revealed),
            child: Container(
              constraints: const BoxConstraints(minHeight: 180),
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: NorieColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: accent),
              ),
              child: Text(
                _revealed ? expected : 'Tap to reveal answer',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          if (_revealed && !_checked) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _submit(false),
                    child: const Text('Review again'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _submit(true),
                    child: const Text('I knew it'),
                  ),
                ),
              ],
            ),
          ],
        ],
      );

  Widget _dragDrop(Color accent) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DragTarget<String>(
            onAcceptWithDetails: _checked
                ? null
                : (details) => setState(() => _dropped = details.data),
            builder: (context, candidates, rejected) => Container(
              height: 86,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: NorieColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: candidates.isNotEmpty ? accent : NorieColors.border,
                  width: candidates.isNotEmpty ? 2 : 1,
                ),
              ),
              child: Text(
                _dropped ?? 'DROP THE CORRECT ANSWER HERE',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.options
                .map(
                  (answer) => Draggable<String>(
                    data: answer,
                    feedback: Material(
                      color: Colors.transparent,
                      child: _DragChip(answer, accent),
                    ),
                    child: _DragChip(answer, accent),
                  ),
                )
                .toList(),
          ),
          if (!_checked) ...[
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _dropped == null
                  ? null
                  : () => _submit(norieAnswerMatches(_dropped!, expected)),
              child: const Text('Check drop'),
            ),
          ],
        ],
      );

  Widget _ordering(Color accent) {
    if (question.orderedItems.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'No sequence is authored for this item yet. Using shuffled answer recall instead.',
            style:
                TextStyle(color: NorieColors.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: 10),
          _choices(accent, 'Choose the best answer.'),
        ],
      );
    }
    return Column(
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _ordered.length,
          onReorderItem: _checked
              ? (_, __) {}
              : (oldIndex, newIndex) {
                  setState(() {
                    final value = _ordered.removeAt(oldIndex);
                    _ordered.insert(newIndex, value);
                  });
                },
          itemBuilder: (_, index) => ListTile(
            key: ValueKey(_ordered[index]),
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(_ordered[index]),
            trailing: const Icon(Icons.drag_handle_rounded),
          ),
        ),
        if (!_checked)
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _submit(_orderCorrect()),
              child: const Text('Check order'),
            ),
          ),
      ],
    );
  }

  Widget _panel(String text) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: NorieColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: NorieColors.border),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      );

  Widget _feedback(bool correct) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: (correct ? NorieColors.green : NorieColors.magenta)
              .withValues(alpha: .10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: correct ? NorieColors.green : NorieColors.magenta,
          ),
        ),
        child: Text(
          correct
              ? 'Correct. ${question.explanation}'
              : 'Answer: $expected\n${question.explanation}',
          style: const TextStyle(height: 1.4),
        ),
      );
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: color.withValues(alpha: .45)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 8,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
}

class _DragChip extends StatelessWidget {
  const _DragChip(this.label, this.color);
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: NorieColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: .45)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      );
}
