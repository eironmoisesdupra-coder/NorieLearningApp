import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../data/norie_study_service.dart';
import '../domain/norie_study_models.dart';
import 'study_qa_screen.dart';
import 'study_quiz_screen.dart';

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
      await NorieStudyService.instance.deleteStudySet(widget.studySet);
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
    final set = widget.studySet;

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
                        label: 'Grounding',
                        value: 'Source-backed',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: set.questions.isEmpty
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
                const Text(
                  'Generated material',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                for (final question in set.questions.take(5))
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
                        ],
                      ),
                    ),
                  ),
                if (set.questions.length > 5)
                  Text(
                    '+ ${set.questions.length - 5} more items',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: NorieColors.textSecondary,
                      fontSize: 11,
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
