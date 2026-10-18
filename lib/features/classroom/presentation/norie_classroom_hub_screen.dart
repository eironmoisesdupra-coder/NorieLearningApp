import 'norie_classroom_identity_guard.dart';
import '../../../core/release/norie_setup_screen.dart';
import 'package:flutter/material.dart';
import '../data/norie_classroom_file_bridge.dart';
import '../data/norie_classroom_store.dart';
import '../domain/norie_classroom_models.dart';
import 'norie_classroom_builder_screen.dart';
import 'norie_classroom_runner_screen.dart';
import 'norie_classroom_lan_screen.dart';

class NorieClassroomHubScreen extends StatefulWidget {
  const NorieClassroomHubScreen({this.store, super.key});
  final NorieClassroomStore? store;
  @override
  State<NorieClassroomHubScreen> createState() => _HubState();
}

class _HubState extends State<NorieClassroomHubScreen>
    with NorieClassroomIdentityGuard<NorieClassroomHubScreen> {
  late final store = widget.store ?? NorieClassroomStore.instance;
  bool busy = false;
  String? error;
  @override
  void initState() {
    super.initState();
    run(() => store.load());
  }

  Future<void> run(Future<void> Function() action) async {
    if (!current || busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted && current) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> importAssignment() async {
    final a = await NorieClassroomFileBridge.importAssignment();
    if (a != null && current) {
      await store.importAssignment(a, stillCurrent: () => current);
    }
  }

  Future<void> importSubmission() async {
    final s = await NorieClassroomFileBridge.importSubmission();
    if (s != null && current) {
      await store.recordSubmission(s, stillCurrent: () => current);
    }
  }

  Future<void> exportAssignment(NorieClassroomAssignment a) async {
    if (current) await NorieClassroomFileBridge.exportAssignment(a);
  }

  void report(NorieClassroomAssignment a) {
    Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (_) => _Report(
                assignment: a, store: store, stillCurrent: () => current)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Offline Classroom')),
      body: AnimatedBuilder(
          animation: store,
          builder: (context, _) {
            if (!current) {
              return const Center(
                  child: Text('Learner changed. Reopen Classroom.'));
            }
            return ListView(padding: const EdgeInsets.all(16), children: [
              const Text('Assignments travel as files.',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const Text(
                  'Teachers choose authored questions. Learners import assignments, practise offline, and return submission files. Reports recompute answers on this device. Aliases and attempt limits support practice, not secure exams. No XP, credits or league points are awarded.'),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                FilledButton.icon(
                    onPressed: busy
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute<bool>(
                                builder: (_) =>
                                    NorieClassroomBuilderScreen(store: store))),
                    icon: const Icon(Icons.edit_note),
                    label: const Text('Build assignment')),
                OutlinedButton.icon(
                    onPressed: busy ? null : () => run(importAssignment),
                    icon: const Icon(Icons.file_open),
                    label: const Text('Import assignment')),
                OutlinedButton.icon(
                    onPressed: busy ? null : () => run(importSubmission),
                    icon: const Icon(Icons.fact_check),
                    label: const Text('Import submission')),
                OutlinedButton.icon(
                    onPressed: busy
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (_) =>
                                    NorieClassroomLanScreen(store: store))),
                    icon: const Icon(Icons.wifi_tethering_rounded),
                    label: const Text('Local Wi-Fi Classroom')),
              ]),
              TextButton.icon(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (_) => const NorieSetupScreen())),
                icon: const Icon(Icons.cloud_off_rounded),
                label: const Text('Cloud Classroom: not configured'),
              ),
              if (busy) const LinearProgressIndicator(),
              if (error != null)
                Text(error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              if (store.assignments.isEmpty)
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('Build or import an assignment to begin.')),
              for (final a in store.assignments)
                Card(
                    child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(a.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  '${a.subject} - ${a.gradeId.toUpperCase()} - ${a.questionIds.length} questions'),
                              if (a.teacherNote.isNotEmpty) Text(a.teacherNote),
                              Wrap(spacing: 8, children: [
                                TextButton(
                                    onPressed: busy
                                        ? null
                                        : () => Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                                builder: (_) =>
                                                    NorieClassroomRunnerScreen(
                                                        assignment: a,
                                                        store: store))),
                                    child: const Text('Start practice')),
                                TextButton(
                                    onPressed: busy
                                        ? null
                                        : () => run(() => exportAssignment(a)),
                                    child: const Text('Export assignment')),
                                TextButton(
                                    onPressed: () => report(a),
                                    child: const Text('Submissions and report'))
                              ]),
                            ]))),
            ]);
          }));
}

class _Report extends StatefulWidget {
  const _Report(
      {required this.assignment,
      required this.store,
      required this.stillCurrent});
  final NorieClassroomAssignment assignment;
  final NorieClassroomStore store;
  final bool Function() stillCurrent;
  @override
  State<_Report> createState() => _ReportState();
}

class _ReportState extends State<_Report>
    with NorieClassroomIdentityGuard<_Report> {
  String? error;
  bool busy = false;
  Future<void> export(Future<Uri?> Function() action) async {
    if ((!current || !widget.stillCurrent()) || busy) return;
    setState(() => busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted && widget.stillCurrent()) {
        setState(() => error = e.toString());
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if ((!current || !widget.stillCurrent())) {
      return const Scaffold(
          body: Center(child: Text('Learner changed. Reopen Classroom.')));
    }
    final submissions = widget.store.submissions
        .where((s) => s.assignmentId == widget.assignment.id)
        .toList();
    return Scaffold(
        appBar: AppBar(title: const Text('Submissions and report')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Text(widget.assignment.title),
          const Text(
              'Scores are recomputed from authored answers. These local practice files do not verify learner identity.'),
          FilledButton(
              onPressed: busy
                  ? null
                  : () => export(() => NorieClassroomFileBridge.exportReport(
                      widget.assignment, submissions)),
              child: const Text('Export CSV report')),
          if (error != null) Text(error!),
          if (submissions.isEmpty)
            const Text(
                'No submissions yet. Import returned submission files from Classroom.'),
          for (final s in submissions)
            Card(
                child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                              '${s.learnerAlias} - attempt ${s.attemptNumber}'),
                          Text(
                              '${s.correct}/${s.total} - ${s.completedAt.toLocal()}'),
                          TextButton(
                              onPressed: busy
                                  ? null
                                  : () => export(() =>
                                      NorieClassroomFileBridge.exportSubmission(
                                          s)),
                              child: const Text('Export submission JSON'))
                        ])))
        ]));
  }
}
