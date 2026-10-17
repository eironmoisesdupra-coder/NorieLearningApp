import 'norie_classroom_connection_copy.dart';
import 'norie_classroom_lan_messages.dart';
import 'norie_classroom_identity_guard.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/norie_classroom_file_bridge.dart';
import '../data/norie_classroom_store.dart';
import '../domain/norie_classroom_models.dart';
import '../domain/norie_classroom_resolver.dart';
import 'norie_classroom_question_context.dart';

class NorieClassroomRunnerScreen extends StatefulWidget {
  const NorieClassroomRunnerScreen(
      {required this.assignment, this.store, this.returnSubmission, super.key});
  final NorieClassroomAssignment assignment;
  final NorieClassroomStore? store;
  final Future<void> Function(NorieClassroomSubmission)? returnSubmission;
  @override
  State<NorieClassroomRunnerScreen> createState() => _RunnerState();
}

class _RunnerState extends State<NorieClassroomRunnerScreen>
    with NorieClassroomIdentityGuard<NorieClassroomRunnerScreen> {
  late final store = widget.store ?? NorieClassroomStore.instance;
  late final questions = NorieClassroomResolver.questionsFor(widget.assignment);
  final alias = TextEditingController();
  final responses = <String, int>{};
  final revealed = <String>{};
  int index = 0;
  bool busy = false;
  String? error;
  NorieClassroomSubmission? done;
  String? returnNotice;

  Future<void> returnToTeacher() async {
    if (busy || !current || done == null || widget.returnSubmission == null) {
      return;
    }
    setState(() {
      busy = true;
      returnNotice = null;
    });
    try {
      await widget.returnSubmission!(done!);
      if (mounted && current) {
        setState(() => returnNotice = 'Received by teacher');
      }
    } catch (e) {
      if (mounted && current) {
        setState(() => returnNotice =
            '${NorieClassroomConnectionCopy.message(NorieClassroomConnectionIssue.submissionPending)} ${norieClassroomLanMessage(e)}');
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    alias.dispose();
    super.dispose();
  }

  Future<void> finish() async {
    if (busy || !current) return;
    setState(() => busy = true);
    try {
      final name = classroomString(alias.text, 80);
      final attempt = store.attemptsFor(widget.assignment.id, name) + 1;
      if (attempt > widget.assignment.maxAttempts) {
        throw StateError('No classroom attempts remain for this alias.');
      }
      final s = NorieClassroomResolver.score(
          widget.assignment,
          NorieClassroomSubmission(
              id: 'submission-${const Uuid().v4()}',
              assignmentId: widget.assignment.id,
              learnerAlias: name,
              correct: 0,
              total: questions.length,
              responses: Map.unmodifiable(responses),
              completedAt: DateTime.now().toUtc(),
              attemptNumber: attempt));
      await store.recordSubmission(s, stillCurrent: () => current);
      if (mounted && current) setState(() => done = s);
    } catch (e) {
      if (mounted && current) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> export() async {
    if (!current || done == null) return;
    try {
      await NorieClassroomFileBridge.exportSubmission(done!);
    } catch (e) {
      if (mounted && current) setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!current) {
      return const Scaffold(
          body: Center(child: Text('Learner changed. Reopen Classroom.')));
    }
    if (done != null) {
      return Scaffold(
          appBar: AppBar(title: const Text('Classroom result')),
          body: ListView(padding: const EdgeInsets.all(16), children: [
            Text('${done!.correct}/${done!.total}',
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Text(
                'Practice results stay separate from XP, credits, ranks and league points.'),
            if (widget.returnSubmission != null) ...[
              FilledButton.icon(
                  onPressed: busy ? null : returnToTeacher,
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Return to teacher')),
              if (returnNotice != null)
                Semantics(liveRegion: true, child: Text(returnNotice!)),
            ],
            FilledButton.icon(
                onPressed: busy ? null : export,
                icon: const Icon(Icons.save_alt),
                label: const Text('Export submission')),
            for (final q in questions)
              ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(q.prompt),
                  subtitle:
                      Text('${q.options[responses[q.id]!]}\n${q.explanation}')),
            if (error != null) Text(error!)
          ]));
    }
    final q = questions[index];
    final topic =
        NorieClassroomResolver.topicForQuestion(widget.assignment, q.id);
    return Scaffold(
        appBar: AppBar(title: Text(widget.assignment.title)),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          if (widget.assignment.teacherNote.isNotEmpty)
            Text(widget.assignment.teacherNote),
          TextField(
              controller: alias,
              onChanged: (_) => setState(() {}),
              maxLength: 80,
              enabled: !busy && index == 0,
              decoration: const InputDecoration(
                  labelText: 'Classroom alias',
                  helperText:
                      'Use the same teacher-agreed alias for each attempt.')),
          Text(
              'Attempt limit: ${widget.assignment.maxAttempts} per alias. Practice files are not secure exams.'),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: (index + 1) / questions.length),
          Text('Question ${index + 1} of ${questions.length}'),
          NorieClassroomQuestionContext(key: ValueKey(topic.id), topic: topic),
          const SizedBox(height: 12),
          SelectableText(q.prompt,
              style:
                  const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          for (var i = 0; i < q.options.length; i++)
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Semantics(
                    selected: responses[q.id] == i,
                    child: OutlinedButton(
                        onPressed: busy
                            ? null
                            : () => setState(() => responses[q.id] = i),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${responses[q.id] == i ? '[Selected] ' : ''}${q.options[i]}'))))),
          if (widget.assignment.allowHints) ...[
            TextButton(
                onPressed: () => setState(() => revealed.add(q.id)),
                child: const Text('Show explanation hint')),
            if (revealed.contains(q.id)) Text(q.explanation)
          ],
          if (error != null)
            Text(error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 12),
          if (index > 0)
            OutlinedButton(
                onPressed: busy ? null : () => setState(() => index--),
                child: const Text('Previous')),
          FilledButton(
              onPressed:
                  busy || responses[q.id] == null || alias.text.trim().isEmpty
                      ? null
                      : index == questions.length - 1
                          ? finish
                          : () => setState(() => index++),
              child: Text(busy
                  ? 'Saving...'
                  : index == questions.length - 1
                      ? 'Finish assignment'
                      : 'Next')),
        ]));
  }
}
