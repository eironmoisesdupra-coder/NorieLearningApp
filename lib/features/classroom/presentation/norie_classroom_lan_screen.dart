import 'package:flutter/material.dart';
import '../data/norie_classroom_store.dart';
import '../lan/norie_classroom_lan.dart';
import 'norie_classroom_lan_join_screen.dart';
import 'norie_classroom_lan_teacher_screen.dart';

class NorieClassroomLanScreen extends StatefulWidget {
  const NorieClassroomLanScreen({this.store, super.key});
  final NorieClassroomStore? store;
  @override
  State<NorieClassroomLanScreen> createState() => _LanScreenState();
}

class _LanScreenState extends State<NorieClassroomLanScreen> {
  final probe = NorieClassroomLanClient();
  @override
  void dispose() {
    probe.dispose();
    super.dispose();
  }

  void open(bool teacher) => Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => teacher
          ? NorieClassroomLanTeacherScreen(store: widget.store)
          : NorieClassroomLanJoinScreen(store: widget.store)));

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Local Wi-Fi Classroom')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Icon(Icons.wifi_tethering_rounded, size: 56),
        const SizedBox(height: 16),
        Text('Learn together. Internet optional.',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const Text(
            'Connect the teacher and learners to the same trusted Wi-Fi or hotspot. Share selected assignments and return saved practice results directly.'),
        const SizedBox(height: 12),
        const Text(
            'The teacher starts and stops each session. Only share the temporary code with your class. Local Wi-Fi practice is not an encrypted exam service. Classroom practice awards no XP, credits or league points.'),
        const SizedBox(height: 20),
        if (!probe.supported) ...[
          const Card(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      'Use the installed Windows or Android app for local Wi-Fi Classroom. The web app still supports assignment and submission files.'))),
          TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Use assignment files')),
        ],
        FilledButton.icon(
            onPressed: probe.supported ? () => open(true) : null,
            icon: const Icon(Icons.cast_for_education),
            label: const Text('Host a classroom')),
        const SizedBox(height: 12),
        OutlinedButton.icon(
            onPressed: probe.supported ? () => open(false) : null,
            icon: const Icon(Icons.group_add_outlined),
            label: const Text('Join a classroom')),
      ]));
}
