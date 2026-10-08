import 'package:flutter/material.dart';
import '../data/authored/authored_lesson_visual.dart';

/// Native, selectable text diagrams stay readable offline and at large scale.
class AuthoredLessonVisualView extends StatelessWidget {
  const AuthoredLessonVisualView(
      {required this.visual, required this.accent, super.key});
  final AuthoredLessonVisual visual;
  final Color accent;
  @override
  Widget build(BuildContext context) {
    visual.validate();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Semantics(
          header: true,
          child: Text(visual.title,
              style: const TextStyle(fontWeight: FontWeight.w800))),
      const SizedBox(height: 12),
      for (var i = 0; i < visual.labels.length; i++) ...[
        Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: accent.withValues(alpha: .08),
                border: Border.all(color: accent.withValues(alpha: .35)),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SelectableText(visual.labels[i],
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  SelectableText(visual.details[i]),
                ])),
        if (i < visual.labels.length - 1)
          visual.ordered
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Icon(Icons.arrow_downward_rounded,
                      color: accent,
                      semanticLabel:
                          '${visual.labels[i]} leads to ${visual.labels[i + 1]}'))
              : const SizedBox(height: 10),
      ],
    ]);
  }
}
