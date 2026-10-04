import 'package:flutter/material.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

import '../../../core/audio/norie_audio_manager.dart';
import '../../../core/theme/norie_theme.dart';
import '../data/norie_study_service.dart';
import '../domain/norie_study_models.dart';

class StudyReviewScreen extends StatefulWidget {
  const StudyReviewScreen(
      {required this.studySet, this.dueOnly = false, super.key});
  final NorieStudySet studySet;
  final bool dueOnly;

  @override
  State<StudyReviewScreen> createState() => _StudyReviewScreenState();
}

class _StudyReviewScreenState extends State<StudyReviewScreen> {
  List<NorieStudyQuestion>? _cards;
  int _index = 0;
  bool _revealed = false;
  bool _saving = false;
  String? _error;
  final Set<String> _retried = {};
  late final Object _audioToken;

  @override
  void initState() {
    super.initState();
    _audioToken =
        NorieAudioManager.instance.enterContext(NorieAudioContext.lesson);
    _load();
  }

  Future<void> _load() async {
    try {
      final scheduled =
          await NorieStudyService.instance.reviewCards(widget.studySet);
      final now = DateTime.now().toUtc();
      final cards = widget.studySet.questions.where((question) {
        final due = scheduled[question.id]?.due;
        return !widget.dueOnly || due == null || !due.isAfter(now);
      }).toList();
      if (mounted) {
        setState(() {
          _cards = cards;
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not load your reviews.');
    }
  }

  Future<void> _rate(fsrs.Rating rating) async {
    if (_saving || !_revealed) return;
    final question = _cards![_index];
    setState(() => _saving = true);
    try {
      await NorieStudyService.instance
          .reviewCard(widget.studySet, question.id, rating);
      if (!mounted) return;
      NorieAudioManager.instance.playQuizSelect();
      setState(() {
        if (rating == fsrs.Rating.again && _retried.add(question.id)) {
          _cards!.add(question);
        }
        _index++;
        _revealed = false;
        _saving = false;
        _error = null;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Review not saved. Please try again.';
        });
      }
    }
  }

  @override
  void dispose() {
    NorieAudioManager.instance.leaveContext(_audioToken);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cards = _cards;
    return Scaffold(
      appBar: AppBar(title: Text(widget.studySet.title)),
      body: SafeArea(
          child: Center(
              child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: cards == null
            ? (_error == null
                ? const CircularProgressIndicator()
                : TextButton(onPressed: _load, child: Text(_error!)))
            : _index >= cards.length
                ? Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        color: NorieColors.green, size: 56),
                    const SizedBox(height: 16),
                    Text(
                        cards.isEmpty
                            ? 'No cards due right now'
                            : 'Review complete',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    const Text('Your next reviews are saved on this device.'),
                    const SizedBox(height: 24),
                    FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Back to deck')),
                  ])
                : ListView(padding: const EdgeInsets.all(24), children: [
                    Row(children: [
                      Expanded(
                          child: LinearProgressIndicator(
                              value: _index / cards.length)),
                      const SizedBox(width: 16),
                      Text('${_index + 1} / ${cards.length}'),
                    ]),
                    const SizedBox(height: 24),
                    Semantics(
                        liveRegion: true,
                        child: Text(cards[_index].prompt,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800))),
                    const SizedBox(height: 24),
                    Container(
                      constraints: const BoxConstraints(minHeight: 200),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          color: NorieColors.surface,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: _revealed
                              ? Text(cards[_index].correctValues.join(' / '),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color: NorieColors.cyan,
                                      fontWeight: FontWeight.w700))
                              : OutlinedButton.icon(
                                  onPressed: () {
                                    NorieAudioManager.instance.playQuizSelect();
                                    setState(() => _revealed = true);
                                  },
                                  icon: const Icon(Icons.visibility_rounded),
                                  label: const Text('Reveal answer'))),
                    ),
                    if (_revealed) ...[
                      const SizedBox(height: 20),
                      Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            OutlinedButton(
                                onPressed: _saving
                                    ? null
                                    : () => _rate(fsrs.Rating.again),
                                child: const Text('Again')),
                            OutlinedButton(
                                onPressed: _saving
                                    ? null
                                    : () => _rate(fsrs.Rating.hard),
                                child: const Text('Hard')),
                            FilledButton(
                                onPressed: _saving
                                    ? null
                                    : () => _rate(fsrs.Rating.good),
                                child: const Text('Got it')),
                          ]),
                      const SizedBox(height: 24),
                      Text(cards[_index].explanation),
                      const SizedBox(height: 16),
                      ExpansionTile(title: const Text('Source'), children: [
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: SelectableText(cards[_index].sourceExcerpt)),
                      ]),
                    ],
                    if (_error != null)
                      Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(_error!)),
                  ]),
      ))),
    );
  }
}
