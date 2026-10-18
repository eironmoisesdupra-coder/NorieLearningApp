import 'curriculum_session_guard.dart';
import 'package:flutter/material.dart';
import '../../content/domain/norie_content_models.dart';
import '../../content/data/authored/authored_subject_curriculum.dart';
import '../../content/data/science/science_curriculum.dart';
import '../../content/presentation/authored_lesson_visual_view.dart';
import '../../content/presentation/science_figure_view.dart';
import '../../content/presentation/norie_grade1_science_visual.dart';
import '../../content/presentation/norie_content_theme.dart';
import '../domain/guided_assessment.dart';
import 'norie_guided_practice_screen.dart';
import 'norie_authored_practice_screen.dart';
import '../../content/presentation/norie_lesson_visual.dart';

/// Actual authored explanations and diagrams, with separate rehearsal evidence.
class NorieGuidedLearningScreen extends StatefulWidget {
  const NorieGuidedLearningScreen(
      {required this.topic,
      this.draftPreview = false,
      this.metadata = const {},
      super.key});
  final NorieTopicContent topic;
  final bool draftPreview;
  final Map<String, dynamic> metadata;
  @override
  State<NorieGuidedLearningScreen> createState() =>
      _NorieGuidedLearningScreenState();
}

class _NorieGuidedLearningScreenState extends State<NorieGuidedLearningScreen>
    with CurriculumSessionGuard<NorieGuidedLearningScreen> {
  final _session = GuidedPracticeSession();
  @override
  Widget build(BuildContext context) {
    if (!curriculumSessionCurrent) return changedCurriculumSession;
    final topic = widget.topic;
    final early = const {'g1', 'g2', 'g3'}.contains(topic.gradeLevel);
    final accent = norieContentAccent(topic.accent);
    final flow = widget.metadata['flow'];
    final rawAssessments = widget.metadata['assessments'];
    final authored = <GuidedAssessmentItem>[];
    final explanations = <String, String>{};
    String? authoredIssue;
    if (rawAssessments is List) {
      try {
        for (final raw in rawAssessments) {
          final json = Map<String, dynamic>.from(raw as Map);
          final item = GuidedAssessmentItem.fromJson(json);
          authored.add(item);
          explanations[item.id] = json['explanation'] as String? ?? '';
        }
      } catch (error) {
        authoredIssue = '$error';
        authored.clear();
      }
    }
    return Scaffold(
        appBar: AppBar(
            title: Text(
                widget.draftPreview ? 'Draft preview' : 'Guided learning')),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child:
                        ListView(padding: const EdgeInsets.all(20), children: [
                      if (widget.draftPreview)
                        const Card(
                            child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Text(
                                    'Local draft · not published to learners'))),
                      Text(topic.title,
                          style: const TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(topic.lesson.heading,
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      SelectableText(topic.lesson.introduction,
                          style: TextStyle(
                              fontSize: early ? 20 : 17, height: 1.6)),
                      if (topic.visualType != null &&
                          !const {'g1-science', 'science-path', 'authored-path'}
                              .contains(topic.visualType)) ...[
                        const SizedBox(height: 16),
                        NorieLessonVisual(
                            type: topic.visualType!,
                            title: topic.title,
                            accent: accent),
                      ],
                      const SizedBox(height: 16),
                      for (final section in topic.lesson.sections)
                        Card(
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(section.title,
                                          style: TextStyle(
                                              fontSize: early ? 22 : 20,
                                              fontWeight: FontWeight.bold)),
                                      if (section.body != null) ...[
                                        const SizedBox(height: 10),
                                        if (section.reveal)
                                          ExpansionTile(
                                              title: const Text(
                                                  'Show worked explanation'),
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: SelectableText(
                                                        section.body!,
                                                        style: TextStyle(
                                                            fontSize:
                                                                early ? 20 : 17,
                                                            height: 1.6)))
                                              ])
                                        else
                                          SelectableText(section.body!,
                                              style: TextStyle(
                                                  fontSize: early ? 20 : 17,
                                                  height: 1.6))
                                      ],
                                      for (final point in section.points)
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: SelectableText('- $point',
                                                style: TextStyle(
                                                    fontSize: early ? 20 : 17,
                                                    height: 1.6))),
                                      if (section.visualType != null) ...[
                                        const SizedBox(height: 16),
                                        _visual(section.visualType!, accent)
                                      ],
                                      if (section.visualCaption != null)
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: SelectableText(
                                                section.visualCaption!)),
                                    ]))),
                      const SizedBox(height: 12),
                      Text(topic.lesson.keyConceptTitle,
                          style: const TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      SelectableText(topic.lesson.keyConceptBody,
                          style: TextStyle(
                              fontSize: early ? 20 : 17, height: 1.6)),
                      if (flow is Map) ...[
                        const SizedBox(height: 16),
                        for (final stage in {
                          'discover': 'Discover',
                          'understand': 'Understand',
                          'worked_example': 'Worked example',
                          'guided_try': 'Guided try',
                          'independent_try': 'Independent try',
                          'apply': 'Apply',
                          'review': 'Review'
                        }.entries)
                          if (flow[stage.key] is String &&
                              (flow[stage.key] as String).trim().isNotEmpty)
                            Card(
                                child: ExpansionTile(
                                    title: Text(stage.value),
                                    initiallyExpanded: stage.key == 'discover',
                                    children: [
                                  Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: SelectableText(
                                          flow[stage.key] as String,
                                          style: TextStyle(
                                              fontSize: early ? 20 : 17,
                                              height: 1.6)))
                                ])),
                      ],
                      if (authoredIssue != null)
                        Text(
                            'Authored assessment needs correction: $authoredIssue'),
                      if (authored.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        FilledButton.icon(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                    builder: (_) => NorieAuthoredPracticeScreen(
                                        items: authored,
                                        explanations: explanations,
                                        session: _session))),
                            icon: const Icon(Icons.calculate_outlined),
                            label:
                                const Text('Try authored assessment formats')),
                      ],
                      const SizedBox(height: 20),
                      FilledButton.icon(
                          onPressed: topic.quiz.questions.isEmpty
                              ? null
                              : () => _practice(true),
                          icon: const Icon(Icons.lightbulb_outline),
                          label: const Text(
                              'Guided try · explanations available')),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                          onPressed: topic.quiz.questions.isEmpty
                              ? null
                              : () => _practice(false),
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Independent rehearsal')),
                      const SizedBox(height: 12),
                      const Text(
                          'Rehearsal records help separately from independent answers. Your normal lesson and practice rewards stay the same. Use regular lesson practice for XP and progression.'),
                    ])))));
  }

  Widget _visual(String id, Color accent) {
    final authored = AuthoredSubjectCurriculum.visuals[id];
    if (authored != null) {
      return AuthoredLessonVisualView(visual: authored, accent: accent);
    }
    final science = ScienceCurriculum.figures[id];
    if (science != null) return ScienceFigureView(figure: science);
    if (widget.topic.gradeLevel == 'g1' && widget.topic.subject == 'Science') {
      return NorieGrade1ScienceVisual(type: id);
    }
    return const SizedBox.shrink();
  }

  Future<void> _practice(bool guided) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => NorieGuidedPracticeScreen(
            topic: widget.topic, guided: guided, session: _session)));
    if (curriculumSessionCurrent) setState(() {});
  }
}
