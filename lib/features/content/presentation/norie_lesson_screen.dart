import 'dart:async';

import 'package:flutter/material.dart';
import 'norie_review_quest_screen.dart';
import '../../../core/progression/norie_lesson_journey.dart';
import '../../../core/audio/norie_audio_host.dart';
import '../../../core/audio/norie_audio_manager.dart';

import '../../../core/theme/norie_theme.dart';
import '../domain/norie_content_models.dart';
import 'norie_content_theme.dart';
import 'norie_lesson_visual.dart';
import 'norie_grade1_science_visual.dart';
import '../data/science/science_curriculum.dart';
import 'science_figure_view.dart';
import '../data/authored/authored_subject_curriculum.dart';
import 'authored_lesson_visual_view.dart';
import 'norie_practice_mode_screen.dart';

class NorieLessonScreen extends StatefulWidget {
  const NorieLessonScreen({
    required this.topic,
    super.key,
  });

  final NorieTopicContent topic;

  @override
  State<NorieLessonScreen> createState() => _NorieLessonScreenState();
}

class _NorieLessonScreenState extends State<NorieLessonScreen>
    with WidgetsBindingObserver {
  final _scroll = ScrollController();
  final _journey = NorieLessonJourney.instance;
  bool _restored = false;
  NorieTopicContent get topic => widget.topic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scroll.addListener(_savePosition);
    _restorePosition();
  }

  @override
  void didUpdateWidget(covariant NorieLessonScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topic.id == topic.id) return;
    if (_restored && _scroll.hasClients) {
      _journey.recordOffset(oldWidget.topic.id, _scroll.offset);
      unawaited(_journey.flush());
    }
    _restored = false;
    _restorePosition();
  }

  void _restorePosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final saved = _journey.offsetFor(topic.id);
      _scroll.jumpTo(saved.clamp(0.0, _scroll.position.maxScrollExtent));
      _restored = true;
      _journey.openTopic(topic.id);
    });
  }

  void _savePosition() {
    if (_restored && _scroll.hasClients) {
      _journey.recordOffset(topic.id, _scroll.offset);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _savePosition();
      unawaited(_journey.flush());
    }
  }

  @override
  void dispose() {
    _savePosition();
    unawaited(_journey.flush());
    WidgetsBinding.instance.removeObserver(this);
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = norieContentAccent(topic.accent);

    return NorieAudioScope(
        contextType: NorieAudioContext.lesson,
        child: Scaffold(
          appBar: AppBar(
            title: Text(topic.title),
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
                  children: [
                    Row(
                      children: [
                        _Badge(text: topic.category, color: NorieColors.violet),
                        const SizedBox(width: 8),
                        _Badge(
                          text: 'Lesson ${topic.order}',
                          color: accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      topic.lesson.heading,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      topic.lesson.introduction,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        height: 1.55,
                        fontSize: 15,
                      ),
                    ),
                    if (topic.visualType != null &&
                        topic.visualType != 'g1-science' &&
                        topic.visualType != 'science-path' &&
                        topic.visualType != 'authored-path') ...[
                      const SizedBox(height: 20),
                      NorieLessonVisual(
                        type: topic.visualType!,
                        title: topic.title,
                        accent: accent,
                      ),
                    ],
                    const SizedBox(height: 24),
                    for (var index = 0;
                        index < topic.lesson.sections.length;
                        index++) ...[
                      _ConceptCard(section: topic.lesson.sections[index]),
                      if (index != topic.lesson.sections.length - 1)
                        const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 18),
                    if (topic.lesson.keyConceptTitle.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131A35),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: accent.withValues(alpha: .7),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KEY CONCEPT',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.4,
                                color: accent,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              topic.lesson.keyConceptTitle,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              topic.lesson.keyConceptBody,
                              style: const TextStyle(
                                color: NorieColors.textSecondary,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    NorieLessonStarCard(topic: topic),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: topic.quiz.questions.isEmpty
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      NoriePracticeModeScreen(topic: topic),
                                ),
                              );
                            },
                      icon: const Icon(Icons.extension_rounded),
                      label: Text(
                        'Choose practice mode · ${topic.quiz.questions.length} items',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: NorieColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}

class _ConceptCard extends StatelessWidget {
  const _ConceptCard({required this.section});

  final NorieLessonSection section;

  @override
  Widget build(BuildContext context) {
    final color = norieContentAccent(section.accent);

    if (section.body != null || section.visualType != null) {
      final prose = Text(section.body ?? '',
          style: const TextStyle(
              fontSize: 16, height: 1.6, color: NorieColors.textSecondary));
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            color: NorieColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: .35))),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(section.title,
              style: const TextStyle(
                  fontSize: 20, height: 1.35, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          if (section.visualType != null)
            if (AuthoredSubjectCurriculum.visuals
                .containsKey(section.visualType))
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                AuthoredLessonVisualView(
                    visual:
                        AuthoredSubjectCurriculum.visuals[section.visualType]!,
                    accent: color),
                if (section.visualCaption?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  Text(section.visualCaption!,
                      style: const TextStyle(height: 1.5)),
                ],
              ])
            else if (ScienceCurriculum.figures.containsKey(section.visualType))
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                ScienceFigureView(
                    figure: ScienceCurriculum.figures[section.visualType]!),
                if (section.visualCaption?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  Text(section.visualCaption!,
                      style: const TextStyle(height: 1.5)),
                ],
              ])
            else
              NorieGrade1ScienceVisual(
                  type: section.visualType!,
                  caption: section.visualCaption ?? ''),
          if (section.body != null)
            if (section.reveal)
              Material(
                  type: MaterialType.transparency,
                  child: _QuickCheckBody(body: section.body!))
            else
              prose,
        ]),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .16),
              shape: BoxShape.circle,
            ),
            child: Text(
              section.symbol,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                ...section.points.map(
                  (point) => Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      '• $point',
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCheckBody extends StatelessWidget {
  const _QuickCheckBody({required this.body});
  final String body;
  @override
  Widget build(BuildContext context) {
    final boundaries =
        RegExp(r'^\d+\. ', multiLine: true).allMatches(body).toList();
    final style = const TextStyle(
        fontSize: 16, height: 1.6, color: NorieColors.textSecondary);
    if (boundaries.isEmpty) {
      return ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: const Text('Reveal answer'),
        children: [
          Align(
              alignment: Alignment.centerLeft, child: Text(body, style: style))
        ],
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (boundaries.isNotEmpty && boundaries.first.start > 0)
        Text(body.substring(0, boundaries.first.start).trim(), style: style),
      for (var i = 0; i < boundaries.length; i++)
        Builder(builder: (context) {
          final block = body
              .substring(
                  boundaries[i].start,
                  i + 1 < boundaries.length
                      ? boundaries[i + 1].start
                      : body.length)
              .trim();
          final marker = RegExp(r'(Answer:|Weather:)').firstMatch(block);
          if (marker == null) return Text(block, style: style);
          return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(block.substring(0, marker.start).trim(), style: style),
                ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: const Text('Reveal answer'),
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(block.substring(marker.start).trim(),
                              style: style))
                    ]),
                const SizedBox(height: 10),
              ]);
        }),
    ]);
  }
}
