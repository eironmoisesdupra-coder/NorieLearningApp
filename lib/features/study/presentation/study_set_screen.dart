import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../core/theme/norie_theme.dart';
import '../data/norie_study_service.dart';
import '../domain/norie_study_models.dart';
import 'study_qa_screen.dart';
import 'study_quiz_screen.dart';
import 'study_review_screen.dart';

class StudySetScreen extends StatefulWidget {
  const StudySetScreen({
    required this.studySet,
    super.key,
  });

  final NorieStudySet studySet;

  @override
  State<StudySetScreen> createState() => _StudySetScreenState();
}

class _StudySetScreenState extends State<StudySetScreen> {
  bool _deleting = false;
  late NorieStudySet _set = widget.studySet;
  late Future<int> _due = _dueCount();
  String _search = '';
  bool _saving = false;

  Future<int> _dueCount() async {
    final cards = await NorieStudyService.instance.reviewCards(_set);
    final now = DateTime.now().toUtc();
    return _set.questions
        .where((question) =>
            cards[question.id] == null || !cards[question.id]!.due.isAfter(now))
        .length;
  }

  Future<void> _review({bool dueOnly = false}) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => StudyReviewScreen(studySet: _set, dueOnly: dueOnly)));
    if (mounted) setState(() => _due = _dueCount());
  }

  Future<void> _edit([NorieStudyQuestion? question]) async {
    final position = _set.questions.fold<int>(
            -1,
            (maximum, item) =>
                item.position > maximum ? item.position : maximum) +
        1;
    final edited = await showDialog<NorieStudyQuestion>(
      context: context,
      builder: (_) => _CardEditor(question: question, position: position),
    );
    if (edited != null && mounted) await _save(edited);
  }

  Future<void> _save(NorieStudyQuestion question,
      {bool deleted = false}) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final updated = await NorieStudyService.instance
          .editCard(_set, question, deleted: deleted);
      if (!mounted) return;
      setState(() {
        _set = updated;
        _due = _dueCount();
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Could not save this change. Keep at least one card in the deck.')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _remove(NorieStudyQuestion question) async {
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
              title: const Text('Delete this card?'),
              content: Text(question.prompt),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: const Text('Delete')),
              ],
            ));
    if (confirmed == true && mounted) await _save(question, deleted: true);
  }

  Future<void> _delete() async {
    if (_deleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete study set?'),
        content: const Text(
          'This will remove the generated questions and its uploaded source from Norie. An internet connection is required.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await NorieStudyService.instance.deleteStudySet(_set);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _deleting = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Could not delete this study set. Connect to the internet and try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final set = _set;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Set'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _deleting ? null : _delete,
            tooltip: 'Delete study set',
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF172554),
                        Color(0xFF312E81),
                        Color(0xFF581C87),
                      ],
                    ),
                    border: Border.all(
                      color: NorieColors.violet.withValues(alpha: .55),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: NorieColors.cyan,
                        size: 34,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        set.title,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '${set.itemCount} items · ${set.mode.label}',
                        style: const TextStyle(
                          color: NorieColors.textSecondary,
                        ),
                      ),
                      if (set.topicTag?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        _Tag(label: set.topicTag!),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.source_rounded,
                        label: 'Source',
                        value: set.sourceName ?? set.sourceType,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: _InfoCard(
                        icon: Icons.fact_check_outlined,
                        label: 'Reference',
                        value: 'Source excerpts',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: set.questions.isEmpty
                      ? null
                      : () => _review(dueOnly: true),
                  icon: const Icon(Icons.event_available_rounded),
                  label: FutureBuilder<int>(
                      future: _due,
                      builder: (_, snapshot) => Text(snapshot.hasData
                          ? 'Review due cards (${snapshot.data})'
                          : 'Review due cards')),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: set.questions.isEmpty ? null : _review,
                  icon: const Icon(Icons.style_rounded),
                  label: const Text('Browse flashcards'),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: set.questions.every((question) =>
                          question.kind == NorieStudyQuestionKind.flashcard)
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => StudyQuizScreen(
                                studySet: set,
                              ),
                            ),
                          );
                        },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start Practice'),
                  style: FilledButton.styleFrom(
                    backgroundColor: NorieColors.cyan,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => StudyQaScreen(studySet: set),
                      ),
                    );
                  },
                  icon: const Icon(Icons.question_answer_rounded),
                  label: const Text('Ask Norie About This Source'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 24),
                Row(children: [
                  const Expanded(
                      child: Text('Cards',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900))),
                  IconButton(
                      onPressed: _saving ? null : () => _edit(),
                      tooltip: 'Add flashcard',
                      icon: const Icon(Icons.add_rounded)),
                ]),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Search cards',
                      prefixIcon: Icon(Icons.search_rounded)),
                  onChanged: (value) =>
                      setState(() => _search = value.trim().toLowerCase()),
                ),
                const SizedBox(height: 10),
                for (final question in set.questions.where((question) =>
                    '${question.prompt} ${question.correctValues.join(' ')}'
                        .toLowerCase()
                        .contains(_search)))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: NorieColors.surface,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: NorieColors.border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${question.position + 1}.',
                            style: const TextStyle(
                              color: NorieColors.cyan,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              question.prompt,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            enabled: !_saving,
                            tooltip: 'Card actions',
                            onSelected: (action) => action == 'edit'
                                ? _edit(question)
                                : _remove(question),
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                  value: 'delete', child: Text('Delete')),
                            ],
                          ),
                        ],
                      ),
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

class _CardEditor extends StatefulWidget {
  const _CardEditor({required this.question, required this.position});
  final NorieStudyQuestion? question;
  final int position;

  @override
  State<_CardEditor> createState() => _CardEditorState();
}

class _CardEditorState extends State<_CardEditor> {
  final _form = GlobalKey<FormState>();
  late final _prompt = TextEditingController(text: widget.question?.prompt);
  late final _answers =
      TextEditingController(text: widget.question?.correctValues.join('\n'));
  late final _options =
      TextEditingController(text: widget.question?.options.join('\n'));
  late final _explanation =
      TextEditingController(text: widget.question?.explanation);
  NorieStudyQuestionKind get _kind =>
      widget.question?.kind ?? NorieStudyQuestionKind.flashcard;
  bool get _choice => const [
        NorieStudyQuestionKind.singleSelect,
        NorieStudyQuestionKind.trueFalse,
        NorieStudyQuestionKind.matching,
        NorieStudyQuestionKind.dragAndDrop
      ].contains(_kind);
  List<String> _lines(String text) => text
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  @override
  void dispose() {
    _prompt.dispose();
    _answers.dispose();
    _options.dispose();
    _explanation.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    final answers = _lines(_answers.text);
    final original = widget.question;
    Navigator.pop(
        context,
        NorieStudyQuestion(
          id: original?.id ?? const Uuid().v4(),
          position: original?.position ?? widget.position,
          kind: _kind,
          prompt: _prompt.text.trim(),
          options: _choice ? _lines(_options.text) : const [],
          correctValues: answers,
          orderedItems:
              _kind == NorieStudyQuestionKind.ordering ? answers : const [],
          explanation: _explanation.text.trim(),
          sourceExcerpt: original?.sourceExcerpt ?? '',
          topicTag: original?.topicTag,
          difficulty: original?.difficulty ?? 'foundation',
        ));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.question == null ? 'Add flashcard' : 'Edit card'),
        content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
                child: Form(
              key: _form,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                    controller: _prompt,
                    minLines: 2,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: 'Question'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter a question.'
                        : null),
                if (_choice)
                  TextFormField(
                      controller: _options,
                      minLines: 2,
                      maxLines: 6,
                      decoration: const InputDecoration(
                          labelText: 'Options (one per line)'),
                      validator: (value) {
                        final options = _lines(value ?? '');
                        final requiredCount =
                            _kind == NorieStudyQuestionKind.trueFalse ? 2 : 4;
                        if (options.length != requiredCount ||
                            options
                                    .map((option) => option.toLowerCase())
                                    .toSet()
                                    .length !=
                                requiredCount) {
                          return 'Enter $requiredCount different options.';
                        }
                        if (_kind == NorieStudyQuestionKind.trueFalse &&
                            !(options.contains('True') &&
                                options.contains('False'))) {
                          return 'Options must be True and False.';
                        }
                        return null;
                      }),
                TextFormField(
                    controller: _answers,
                    minLines: 2,
                    maxLines: 6,
                    decoration: InputDecoration(
                        labelText: _kind == NorieStudyQuestionKind.ordering
                            ? 'Correct sequence (one step per line)'
                            : 'Accepted answers (one per line)'),
                    validator: (value) {
                      final answers = _lines(value ?? '');
                      if (answers.isEmpty) return 'Enter an answer.';
                      if (_choice &&
                          (answers.length != 1 ||
                              !_lines(_options.text)
                                  .contains(answers.single))) {
                        return 'Enter exactly one answer from the options.';
                      }
                      if (_kind == NorieStudyQuestionKind.ordering &&
                          (answers.length < 3 ||
                              answers.length > 6 ||
                              answers.toSet().length != answers.length)) {
                        return 'Enter 3 to 6 different steps.';
                      }
                      return null;
                    }),
                TextFormField(
                    controller: _explanation,
                    minLines: 2,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: 'Explanation'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter an explanation.'
                        : null),
                if (widget.question?.sourceExcerpt.isNotEmpty == true)
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(widget.question!.sourceExcerpt)),
              ]),
            ))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save')),
        ],
      );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NorieColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: NorieColors.violet, size: 21),
          const SizedBox(height: 9),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: NorieColors.cyan.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: NorieColors.cyan,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
