import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../audio/norie_audio_manager.dart';
import '../mascot/norie_mascot_controller.dart';
import '../mascot/norie_mascot_state.dart';
import '../mascot/norie_mascot_view.dart';
import 'quiz_result_history.dart';
import 'quiz_result_summary.dart';

enum QuizOutroAction { continueLearning, retry, reviewLesson, viewDetails }

typedef QuizReviewVisualBuilder = Widget Function(
    BuildContext, QuizAnswerRecord);

class NorieQuizOutro {
  static Future<QuizOutroAction> show(BuildContext context,
      {required QuizResultSummary summary,
      bool canRetry = true,
      bool canViewDetails = false,
      bool canReviewLesson = false,
      QuizReviewVisualBuilder? reviewVisualBuilder}) async {
    final media = MediaQuery.of(context);
    QuizHistoryComparison comparison;
    try {
      comparison = await QuizResultHistory().record(summary);
    } catch (_) {
      comparison = QuizHistoryComparison(
          percentage: summary.percentage, isNew: false, specialPerfect: false);
    }
    if (!context.mounted) return QuizOutroAction.continueLearning;
    return await showDialog<QuizOutroAction>(
            context: context,
            barrierDismissible: false,
            barrierLabel: 'Quiz results',
            builder: (context) => MediaQuery(
                data: media,
                child: _ResultDialog(
                    summary: summary,
                    comparison: comparison,
                    canRetry: canRetry,
                    canViewDetails: canViewDetails,
                    canReviewLesson: canReviewLesson,
                    reviewVisualBuilder: reviewVisualBuilder))) ??
        QuizOutroAction.continueLearning;
  }
}

class _ResultDialog extends StatefulWidget {
  const _ResultDialog(
      {required this.summary,
      required this.comparison,
      required this.canRetry,
      required this.canViewDetails,
      required this.canReviewLesson,
      this.reviewVisualBuilder});
  final QuizResultSummary summary;
  final QuizHistoryComparison comparison;
  final bool canRetry, canReviewLesson, canViewDetails;
  final QuizReviewVisualBuilder? reviewVisualBuilder;
  @override
  State<_ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<_ResultDialog>
    with SingleTickerProviderStateMixin {
  final _mascot = NorieMascotController();
  late final _reveal = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1800));
  bool _started = false;
  bool get _calm =>
      MediaQuery.of(context).disableAnimations ||
      MediaQuery.of(context).accessibleNavigation;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final s = widget.summary;
    if (s.percentage < 70 || !s.isComplete || s.totalCount == 0) {
      widget.canReviewLesson ? _mascot.point('review-lesson') : _mascot.guide();
    } else if (widget.comparison.specialPerfect) {
      _mascot.celebrate(level: NorieCelebrationLevel.perfect);
    } else if (s.percentage >= 90) {
      _mascot.celebrate();
    } else {
      _mascot.correct();
    }
    if (_calm) {
      _reveal.value = 1;
    } else {
      _reveal.forward();
    }
    if (widget.comparison.isNew) {
      if (!_calm) unawaited(HapticFeedback.lightImpact());
      final audio = NorieAudioManager.instance;
      unawaited(widget.comparison.specialPerfect
          ? audio.playPerfect()
          : s.percentage >= 90
              ? audio.playAchievement()
              : audio.playComplete());
    }
  }

  @override
  void dispose() {
    _reveal.dispose();
    _mascot.dispose();
    super.dispose();
  }

  void _finish(QuizOutroAction action) => Navigator.of(context).pop(action);
  @override
  Widget build(BuildContext context) {
    final s = widget.summary;
    final special = widget.comparison.specialPerfect;
    return Semantics(
        label: 'Quiz results',
        namesRoute: true,
        child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) _finish(QuizOutroAction.continueLearning);
            },
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: AnimatedBuilder(
                      animation: _reveal,
                      builder: (context, child) {
                        final progress =
                            Curves.easeOut.transform(_reveal.value);
                        return DecoratedBox(
                            key: const ValueKey('quiz-outro'),
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xff172c50),
                                      Color(0xff10162e)
                                    ]),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(
                                    color: special
                                        ? const Color(0xffffd36b)
                                        : const Color(0xff63daf0),
                                    width: 1.5)),
                            child: DefaultTextStyle(
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamilyFallback:
                                        DefaultTextStyle.of(context)
                                            .style
                                            .fontFamilyFallback),
                                child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                              height: 136,
                                              child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    if (!_calm &&
                                                        s.percentage >= 80 &&
                                                        _reveal.value < 1)
                                                      Positioned.fill(
                                                          child: IgnorePointer(
                                                              child: CustomPaint(
                                                                  painter: _Sparkles(
                                                                      progress:
                                                                          _reveal
                                                                              .value,
                                                                      strong:
                                                                          special)))),
                                                    Transform.translate(
                                                        offset: Offset(
                                                            0,
                                                            special && !_calm
                                                                ? -18 *
                                                                    math
                                                                        .sin(_reveal.value *
                                                                            math
                                                                                .pi *
                                                                            2)
                                                                        .abs()
                                                                : 0),
                                                        child: NorieMascotView(
                                                            controller: _mascot,
                                                            size: 132,
                                                            reduceMotion:
                                                                _calm)),
                                                  ])),
                                          Text(s.title,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Color(0xffb6c8e8),
                                                  fontSize: 13)),
                                          if (s.gradeLevel != null)
                                            Text('Grade ${s.gradeLevel}',
                                                style: const TextStyle(
                                                    color: Color(0xffb6c8e8),
                                                    fontSize: 12)),
                                          const SizedBox(height: 8),
                                          Text(s.heading,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.w800)),
                                          const SizedBox(height: 10),
                                          Semantics(
                                              label:
                                                  '${s.correctCount} out of ${s.totalCount} correct, ${s.percentage.round()} percent',
                                              child: ExcludeSemantics(
                                                  child: Text(
                                                      '${(s.correctCount * progress).round()} / ${s.totalCount}',
                                                      style: const TextStyle(
                                                          fontSize: 38,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: Color(
                                                              0xff71e7ec))))),
                                          Text(
                                              '${(s.percentage * progress).round()}%',
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600)),
                                          if (s.xpEarned > 0)
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: Text(
                                                    '+${(s.xpEarned * progress).round()} XP earned',
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xffffd36b)))),
                                          const SizedBox(height: 12),
                                          Text(s.message,
                                              textAlign: TextAlign.center),
                                          if ((widget.comparison.improvement ??
                                                  0) >
                                              0)
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12),
                                                child: Text(
                                                    s.isYoung
                                                        ? 'You improved! \u2b50'
                                                        : '${widget.comparison.improvement! >= 10 ? 'Big improvement!' : 'Progress!'} ${widget.comparison.previousPercentage!.round()}% \u2192 ${s.percentage.round()}% (+${widget.comparison.improvement!.round()} percentage points)',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xff89ecc0)))),
                                          if (!s.isYoung &&
                                              s.strongConcepts.isNotEmpty)
                                            _detail(
                                                'Strong this time',
                                                s.strongConcepts
                                                    .join(' \u2022 ')),
                                          if (s.reviewConcepts.isNotEmpty)
                                            _detail(
                                                s.isYoung
                                                    ? 'Try next'
                                                    : 'Focus next',
                                                s.reviewConcepts
                                                    .join(' \u2022 ')),
                                          const SizedBox(height: 18),
                                          if (widget.canReviewLesson)
                                            _button(
                                                'Review Lesson',
                                                () => _finish(QuizOutroAction
                                                    .reviewLesson),
                                                primary: s.percentage < 70),
                                          if (s.mistakes.isNotEmpty)
                                            _button('Review Mistakes', _review),
                                          if (widget.canViewDetails)
                                            _button(
                                                s.isYoung
                                                    ? 'See more'
                                                    : 'View details',
                                                () => _finish(QuizOutroAction
                                                    .viewDetails)),
                                          if (widget.canRetry)
                                            _button(
                                                'Try Again',
                                                () => _finish(
                                                    QuizOutroAction.retry)),
                                          _button(
                                              'Continue',
                                              () => _finish(QuizOutroAction
                                                  .continueLearning),
                                              primary: s.percentage >= 70 ||
                                                  !widget.canReviewLesson),
                                        ]))));
                      })),
            )));
  }

  Widget _detail(String label, String text) => Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text('$label\n$text',
              style: const TextStyle(height: 1.4, color: Color(0xffc6daf4)))));
  Widget _button(String label, VoidCallback action, {bool primary = false}) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SizedBox(
              width: double.infinity,
              child: primary
                  ? FilledButton(
                      onPressed: action,
                      style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xff77e5ee),
                          foregroundColor: const Color(0xff10213d),
                          minimumSize: const Size(48, 48)),
                      child: Text(label, textAlign: TextAlign.center))
                  : OutlinedButton(
                      onPressed: action,
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          minimumSize: const Size(48, 48),
                          side: const BorderSide(color: Color(0xff687caa))),
                      child: Text(label, textAlign: TextAlign.center))));
  Future<void> _review() async {
    await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: const Color(0xff14233e),
        builder: (context) => SafeArea(
            child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: .8,
                minChildSize: .4,
                maxChildSize: .95,
                builder: (context, scroll) => ListView(
                        controller: scroll,
                        padding: const EdgeInsets.all(20),
                        children: [
                          const Text('Review Mistakes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          for (final a in widget.summary.mistakes)
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                child: DefaultTextStyle(
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        height: 1.5,
                                        fontFamilyFallback:
                                            DefaultTextStyle.of(context)
                                                .style
                                                .fontFamilyFallback),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(a.prompt,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          if (widget.reviewVisualBuilder !=
                                              null)
                                            widget.reviewVisualBuilder!(
                                                context, a),
                                          if (a.conceptLabel?.isNotEmpty ==
                                              true)
                                            Text(a.conceptLabel!,
                                                style: const TextStyle(
                                                    color: Color(0xff71e7ec))),
                                          Text(a.unanswered
                                              ? 'Your answer: Not answered'
                                              : 'Your answer: ${a.response}'),
                                          if (a.selfRated)
                                            const Text('Self-rated recall'),
                                          Text(
                                              'Correct answer: ${a.correctAnswer}'),
                                          if (a.explanation.isNotEmpty)
                                            Text('Why: ${a.explanation}'),
                                        ]))),
                          FilledButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Back to results')),
                        ]))));
  }
}

class _Sparkles extends CustomPainter {
  const _Sparkles({required this.progress, required this.strong});
  final double progress;
  final bool strong;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final count = strong ? 22 : 10;
    for (var i = 0; i < count; i++) {
      final angle = i * math.pi * 2 / count;
      final radius = (20 + progress * 70) * (i.isEven ? 1 : .75);
      paint.color =
          (i.isEven ? const Color(0xffffd36b) : const Color(0xff75e4ef))
              .withValues(alpha: 1 - progress);
      canvas.drawCircle(
          Offset(size.width / 2 + math.cos(angle) * radius,
              size.height / 2 + math.sin(angle) * radius),
          strong ? 3 : 2,
          paint);
    }
  }

  @override
  bool shouldRepaint(_Sparkles old) =>
      old.progress != progress || old.strong != strong;
}
