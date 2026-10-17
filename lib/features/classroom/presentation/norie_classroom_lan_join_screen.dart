import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/norie_classroom_store.dart';
import '../domain/norie_classroom_models.dart';
import '../lan/norie_classroom_lan.dart';
import 'norie_classroom_identity_guard.dart';
import 'norie_classroom_lan_messages.dart';
import 'norie_classroom_connection_copy.dart';
import 'norie_classroom_lan_scan_screen.dart';
import 'norie_classroom_runner_screen.dart';

class NorieClassroomLanJoinScreen extends StatefulWidget {
  const NorieClassroomLanJoinScreen({this.store, this.client, super.key});
  final NorieClassroomStore? store;
  final NorieClassroomLanClient? client;
  @override
  State<NorieClassroomLanJoinScreen> createState() => _JoinState();
}

class _JoinState extends State<NorieClassroomLanJoinScreen>
    with NorieClassroomIdentityGuard<NorieClassroomLanJoinScreen> {
  late final store = widget.store ?? NorieClassroomStore.instance;
  late final client = widget.client ?? NorieClassroomLanClient();
  final address = TextEditingController(),
      code = TextEditingController(),
      qrLink = TextEditingController();
  final sent = <String>{};
  List<NorieLanAssignmentSummary> assignments = const [];
  String? expectedSession, error, notice;
  bool busy = false;
  Future<void> Function()? retryAction;

  @override
  void initState() {
    super.initState();
    unawaited(run(() => store.load()));
  }

  Future<void> run(Future<void> Function() action) async {
    if (!current || busy) return;
    setState(() {
      busy = true;
      error = null;
      notice = null;
      retryAction = action;
    });
    try {
      await action();
    } catch (e) {
      if (mounted && current) {
        setState(() => error = norieClassroomLanMessage(e));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> join() async {
    assignments = const [];
    sent.clear();
    await client.connect(address.text.trim(), code.text.trim(),
        expectedSessionId: expectedSession);
    final list = await client.fetchAssignments();
    if (mounted && current) {
      setState(() {
        assignments = list;
        notice = 'Connected. Choose an assignment to download.';
      });
    }
  }

  Future<void> refresh() async {
    final list = await client.fetchAssignments();
    if (mounted && current) setState(() => assignments = list);
  }

  Future<void> useLink(String value) async {
    final info = NorieLanJoinInfo.parse(value.trim());
    if (!mounted || !current) return;
    setState(() {
      client.disconnect();
      assignments = const [];
      address.text = info.endpoint;
      code.text = info.joinCode;
      expectedSession = info.sessionId;
      notice = 'QR details loaded. Tap Join classroom to connect.';
    });
  }

  Future<void> scan() async {
    final result = await Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => const NorieClassroomLanScanScreen()));
    if (result != null && mounted && current) await useLink(result);
  }

  Future<void> download(NorieLanAssignmentSummary summary) async {
    final assignment = await client.downloadAssignment(summary.id);
    if (!current || !mounted) return;
    await store.importAssignment(assignment, stillCurrent: () => current);
    if (!current || !mounted) return;
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => NorieClassroomRunnerScreen(
            assignment: assignment, store: store, returnSubmission: send)));
  }

  Future<void> send(NorieClassroomSubmission submission) async {
    if (!current) throw StateError('Learner changed. Reopen Classroom.');
    final acknowledgement = await client.submit(submission);
    if (mounted && current) {
      setState(() {
        sent.add(submission.id);
        notice = acknowledgement.accepted
            ? 'Received by teacher'
            : NorieClassroomConnectionCopy.message(
                NorieClassroomConnectionIssue.alreadySubmitted);
      });
    }
  }

  void detailsChanged() {
    client.disconnect();
    setState(() {
      expectedSession = null;
      assignments = const [];
      sent.clear();
    });
  }

  @override
  void dispose() {
    client.dispose();
    address.dispose();
    code.dispose();
    qrLink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!current) {
      client.disconnect();
      return const Scaffold(
          body: Center(child: Text('Learner changed. Reopen Classroom.')));
    }
    final ids = assignments.map((a) => a.id).toSet();
    final saved = store.submissions.where((s) => ids.contains(s.assignmentId));
    return Scaffold(
        appBar: AppBar(title: const Text('Join a classroom')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Text('Your teacher brings the lesson',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text(
              'Scan your teacher QR or load a copied join link. Both devices must use the same trusted Wi-Fi or hotspot; internet is not required.'),
          const SizedBox(height: 12),
          if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
            FilledButton.tonalIcon(
                onPressed: busy ? null : () => run(scan),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan teacher QR')),
          ExpansionTile(title: const Text('Use a copied QR link'), children: [
            TextField(
                controller: qrLink,
                enabled: !busy,
                maxLength: 1024,
                autocorrect: false,
                decoration:
                    const InputDecoration(labelText: 'Classroom QR link')),
            TextButton(
                onPressed: busy ? null : () => run(() => useLink(qrLink.text)),
                child: const Text('Load join details')),
          ]),
          ExpansionTile(
              title: const Text('Enter address and code manually'),
              children: [
                TextField(
                    controller: address,
                    enabled: !busy,
                    autocorrect: false,
                    keyboardType: TextInputType.url,
                    onChanged: (_) => detailsChanged(),
                    decoration: const InputDecoration(
                        labelText: 'Teacher address',
                        hintText: 'http://192.168.1.20:12345')),
                const SizedBox(height: 12),
                TextField(
                    controller: code,
                    enabled: !busy,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => detailsChanged(),
                    decoration: const InputDecoration(labelText: 'Join code')),
              ]),
          if (expectedSession != null)
            Text('QR details ready. Join code: ${code.text}'),
          FilledButton.icon(
              onPressed: busy ||
                      !client.supported ||
                      address.text.isEmpty ||
                      code.text.length != 6
                  ? null
                  : () => run(join),
              icon: const Icon(Icons.login),
              label: const Text('Join classroom')),
          Text(client.session == null
              ? 'Not connected to a classroom'
              : error != null
                  ? 'Connection needs attention'
                  : 'Connected to teacher: ${assignments.length} shared assignment(s)'),
          if (client.session != null) ...[
            Wrap(spacing: 8, children: [
              TextButton.icon(
                  onPressed: busy ? null : () => run(refresh),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh assignments')),
              TextButton(
                  onPressed: busy
                      ? null
                      : () => setState(() {
                            client.disconnect();
                            assignments = const [];
                            sent.clear();
                            notice =
                                'Disconnected. Downloaded assignments and results remain on this device.';
                          }),
                  child: const Text('Disconnect')),
            ]),
            if (assignments.isEmpty)
              const Text('Your teacher has not shared any assignments.'),
          ],
          if (busy) const LinearProgressIndicator(),
          if (notice != null) Semantics(liveRegion: true, child: Text(notice!)),
          if (error != null) ...[
            Text(error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            if (retryAction != null)
              TextButton.icon(
                  onPressed: busy ? null : () => run(retryAction!),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry last action')),
            ExpansionTile(title: const Text('Connection help'), children: [
              Text(NorieClassroomConnectionCopy.message(
                  NorieClassroomConnectionIssue.differentNetwork)),
              Text(NorieClassroomConnectionCopy.message(
                  NorieClassroomConnectionIssue.firewallBlocked)),
              const Text(
                  'If the teacher restarted, load the new QR or address and code. Saved results also remain in Offline Classroom.'),
            ]),
          ],
          for (final a in assignments)
            Card(
                child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(a.title,
                              style: Theme.of(context).textTheme.titleMedium),
                          Text(
                              '${a.subject} · ${a.gradeId.toUpperCase()} · ${a.questionCount} questions'),
                          FilledButton.tonalIcon(
                              onPressed:
                                  busy ? null : () => run(() => download(a)),
                              icon: const Icon(Icons.download),
                              label: const Text('Download and practise')),
                        ]))),
          if (saved.isNotEmpty) ...[
            const Divider(height: 28),
            Text('Return saved results',
                style: Theme.of(context).textTheme.titleLarge),
            const Text(
                'Retrying the same saved result does not create another attempt or extra rewards. You can rejoin after restarting the app and return these results again.'),
            for (final s in saved)
              Card(
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                                '${s.learnerAlias} · Attempt ${s.attemptNumber} · ${s.correct}/${s.total}'),
                            if (sent.contains(s.id))
                              const Text('Received by teacher')
                            else
                              OutlinedButton.icon(
                                  onPressed:
                                      busy ? null : () => run(() => send(s)),
                                  icon: const Icon(Icons.send_outlined),
                                  label: const Text('Return saved result')),
                          ]))),
          ],
          const SizedBox(height: 16),
          const Text(
              'Your assignments and completed results also remain available in Offline Classroom for file export. Classroom practice does not award XP, credits or league points.'),
        ]));
  }
}
