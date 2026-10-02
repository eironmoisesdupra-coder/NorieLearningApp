import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../application/norie_activity_engine.dart';
import '../domain/norie_content_models.dart';
import 'norie_activity_screen.dart';
import 'norie_content_theme.dart';

class NoriePracticeModeScreen extends StatelessWidget {
  const NoriePracticeModeScreen({
    required this.topic,
    super.key,
  });

  final NorieTopicContent topic;

  @override
  Widget build(BuildContext context) {
    final accent = norieContentAccent(topic.accent);
    final modes = topic.gradeLevel == 'g1'
        ? const [NorieActivityMode.multipleChoice]
        : NorieActivityMode.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Practice Mode'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
              children: [
                Text(
                  topic.title,
                  style: const TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Every new run randomizes item order. Choice-based modes also shuffle the answer positions.',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                for (final mode in modes) ...[
                  _ModeCard(
                    mode: mode,
                    accent: accent,
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => NorieActivityScreen(
                          topic: topic,
                          requestedMode: mode,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.accent,
    required this.onTap,
  });

  final NorieActivityMode mode;
  final Color accent;
  final VoidCallback onTap;

  IconData get _icon => switch (mode) {
        NorieActivityMode.mixed => Icons.casino_rounded,
        NorieActivityMode.multipleChoice => Icons.checklist_rounded,
        NorieActivityMode.identification => Icons.edit_rounded,
        NorieActivityMode.matching => Icons.compare_arrows_rounded,
        NorieActivityMode.dragAndDrop => Icons.drag_indicator_rounded,
        NorieActivityMode.trueFalse => Icons.rule_rounded,
        NorieActivityMode.ordering => Icons.format_list_numbered_rounded,
        NorieActivityMode.flashcards => Icons.style_rounded,
        NorieActivityMode.fillInBlank => Icons.space_bar_rounded,
      };

  String get _subtitle => switch (mode) {
        NorieActivityMode.mixed =>
          'A different activity style can appear on every item.',
        NorieActivityMode.multipleChoice =>
          'Choose from shuffled answer choices.',
        NorieActivityMode.identification =>
          'Recall and type the answer without choices.',
        NorieActivityMode.matching =>
          'Pair prompts with the correct shuffled answers.',
        NorieActivityMode.dragAndDrop =>
          'Drag the correct answer into the target.',
        NorieActivityMode.trueFalse => 'Judge a randomized statement quickly.',
        NorieActivityMode.ordering =>
          'Arrange shuffled concepts into the expected order.',
        NorieActivityMode.flashcards =>
          'Recall first, reveal, then grade yourself.',
        NorieActivityMode.fillInBlank =>
          'Complete the prompt using active recall.',
      };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NorieColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: NorieColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(_icon, color: accent),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mode.label,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _subtitle,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: NorieColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
