import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../data/norie_classroom_store.dart';
import '../lan/norie_classroom_lan.dart';
import 'norie_classroom_identity_guard.dart';
import 'norie_classroom_lan_messages.dart';

class NorieClassroomLanTeacherScreen extends StatefulWidget {
  const NorieClassroomLanTeacherScreen({this.store, super.key});
  final NorieClassroomStore? store;
  @override
  State<NorieClassroomLanTeacherScreen> createState() => _TeacherState();
}

class _TeacherState extends State<NorieClassroomLanTeacherScreen>
    with NorieClassroomIdentityGuard<NorieClassroomLanTeacherScreen> {
  late final store = widget.store ?? NorieClassroomStore.instance;
  late final host =
      NorieClassroomLanHost(store: store, stillCurrent: () => current);
  final selected = <String>{};
  String? error, address, notice;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    unawaited(run(() => store.load()));
  }

  Future<void> run(Future<void> Function() action) async {
    if (busy || !current) return;
    setState(() {
      busy = true;
      error = null;
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

  Future<void> start() async {
    final session = await host.start(
        assignments:
            store.assignments.where((a) => selected.contains(a.id)).toList());
    if (mounted && current) setState(() => address = session.endpoint);
  }

  Future<void> copyJoin() async {
    final session = host.session;
    if (session == null || !current) return;
    await Clipboard.setData(ClipboardData(
        text: session.joinUri(endpointOverride: address).toString()));
    if (mounted && current) setState(() => notice = 'Join link copied.');
  }

  @override
  void dispose() {
    host.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Host a classroom')),
      body: AnimatedBuilder(
          animation: Listenable.merge([store, host]),
          builder: (context, _) {
            if (!current) {
              return const Center(
                  child: Text('Learner changed. Reopen Classroom.'));
            }
            final session = host.session;
            return ListView(padding: const EdgeInsets.all(16), children: [
              if (session == null) ...[
                Text('Choose what your class receives',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text(
                    'Only checked assignments are shared. Leaving this screen stops the session. Save new assignments in Offline Classroom first.'),
                if (store.assignments.isEmpty)
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                          'Build or import an assignment before hosting.')),
                for (final a in store.assignments)
                  CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: selected.contains(a.id),
                      onChanged: busy
                          ? null
                          : (checked) => setState(() {
                                if (checked == true) {
                                  selected.add(a.id);
                                } else {
                                  selected.remove(a.id);
                                }
                              }),
                      title: Text(a.title),
                      subtitle: Text(
                          '${a.subject} · ${a.gradeId.toUpperCase()} · ${a.questionIds.length} questions')),
                FilledButton.icon(
                    onPressed: busy || selected.isEmpty || !host.supported
                        ? null
                        : () => run(start),
                    icon: const Icon(Icons.wifi_tethering),
                    label: const Text('Start local classroom')),
              ] else ...[
                Text('Classroom is open',
                    style: Theme.of(context).textTheme.headlineSmall),
                const Text(
                    'Students use the address and temporary code below, or scan this QR in NorieLearning. Both devices must be on the same trusted Wi-Fi.'),
                const SizedBox(height: 12),
                if (session.addresses.length > 1)
                  DropdownButtonFormField<String>(
                      key: ValueKey('${session.sessionId}:$address'),
                      initialValue: address,
                      isExpanded: true,
                      decoration:
                          const InputDecoration(labelText: 'Wi-Fi address'),
                      items: [
                        for (final hostAddress in session.addresses)
                          DropdownMenuItem(
                              value: 'http://$hostAddress:${session.port}',
                              child:
                                  Text('http://$hostAddress:${session.port}'))
                      ],
                      onChanged: (value) => setState(() => address = value)),
                SelectableText('Address: ${address ?? session.endpoint}'),
                SelectableText('Join code: ${session.joinCode}',
                    style: Theme.of(context).textTheme.headlineSmall),
                if (session.host.startsWith('127.'))
                  const Text(
                      'No Wi-Fi address found. Connect to your classroom network, then stop and start again.'),
                Center(
                    child: Semantics(
                        label: 'Classroom join QR code',
                        child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: QrImageView(
                                data: session
                                    .joinUri(endpointOverride: address)
                                    .toString(),
                                size: 220,
                                backgroundColor: Colors.white)))),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  OutlinedButton.icon(
                      onPressed: busy ? null : () => run(copyJoin),
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy join link')),
                  FilledButton.tonalIcon(
                      onPressed: busy ? null : () => run(host.stop),
                      icon: const Icon(Icons.stop_circle_outlined),
                      label: const Text('Stop classroom')),
                ]),
                const SizedBox(height: 12),
                const Text(
                    'If a learner cannot connect, check the Wi-Fi address and allow NorieLearning on Private networks in Windows Firewall. Guest Wi-Fi may block device-to-device access.'),
                const Divider(height: 32),
                Text('Received results',
                    style: Theme.of(context).textTheme.titleLarge),
                const Text(
                    'This list updates when results arrive. Names are classroom aliases; a connection alone does not verify identity or attendance.'),
                TextButton.icon(
                    onPressed: busy ? null : () => run(host.refresh),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh results')),
                if (host.peers.isEmpty)
                  const Text('Waiting for saved results from your class.'),
                for (final peer in host.peers)
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.task_alt),
                      title: Text(peer.alias),
                      subtitle: Text(
                          '${peer.submissions} saved result(s) · Last received ${peer.lastSeen.toLocal().toString().split('.').first}')),
              ],
              if (busy) const LinearProgressIndicator(),
              if (notice != null) Text(notice!),
              if (error != null)
                Text(error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
            ]);
          }));
}
