import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../data/norie_study_service.dart';
import '../domain/norie_study_models.dart';

class StudyQaScreen extends StatefulWidget {
  const StudyQaScreen({
    required this.studySet,
    super.key,
  });

  final NorieStudySet studySet;

  @override
  State<StudyQaScreen> createState() => _StudyQaScreenState();
}

class _StudyQaScreenState extends State<StudyQaScreen> {
  final _controller = TextEditingController();
  final List<(String, String)> _messages = [];
  bool _working = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ask() async {
    final question = _controller.text.trim();
    if (question.isEmpty || _working) return;

    setState(() {
      _working = true;
      _controller.clear();
    });

    try {
      final answer = await NorieStudyService.instance.askSource(
        studySetId: widget.studySet.id,
        question: question,
      );
      if (!mounted) return;
      setState(() {
        _messages.add((question, answer));
        _working = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _working = false);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask Norie'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: NorieColors.cyan.withValues(alpha: .07),
                          borderRadius: BorderRadius.circular(17),
                          border: Border.all(
                            color: NorieColors.cyan.withValues(alpha: .25),
                          ),
                        ),
                        child: Text(
                          'Answers are restricted to the source used for “${widget.studySet.title}”. If the source does not support an answer, Norie will say so.',
                          style: const TextStyle(
                            color: NorieColors.textSecondary,
                            height: 1.4,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_messages.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.question_answer_rounded,
                                size: 46,
                                color: NorieColors.violet,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Ask about your source while connected to the internet. Your saved quiz remains available offline.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: NorieColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      for (final message in _messages) ...[
                        _Bubble(
                          text: message.$1,
                          learner: true,
                        ),
                        const SizedBox(height: 8),
                        _Bubble(
                          text: message.$2,
                          learner: false,
                        ),
                        const SizedBox(height: 14),
                      ],
                      if (_working)
                        const Padding(
                          padding: EdgeInsets.all(18),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                  decoration: const BoxDecoration(
                    color: NorieColors.surface,
                    border: Border(
                      top: BorderSide(color: NorieColors.border),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _ask(),
                          decoration: const InputDecoration(
                            hintText: 'Ask from this source...',
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      IconButton.filled(
                        onPressed: _working ? null : _ask,
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ],
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

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.text,
    required this.learner,
  });

  final String text;
  final bool learner;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: learner ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 590),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: learner
              ? NorieColors.violet.withValues(alpha: .18)
              : NorieColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: learner
                ? NorieColors.violet.withValues(alpha: .4)
                : NorieColors.border,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: learner
                ? NorieColors.textPrimary
                : NorieColors.textSecondary,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}
