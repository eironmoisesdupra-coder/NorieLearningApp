import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/curriculum_registry.dart';
import '../data/curriculum_studio_store.dart';
import '../domain/curriculum_path.dart';
import '../domain/curriculum_revision.dart';
import 'curriculum_session_guard.dart';
import 'norie_guided_learning_screen.dart';

class NorieCurriculumPathScreen extends StatefulWidget {
  const NorieCurriculumPathScreen({required this.store, super.key});
  final CurriculumStudioStore store;
  @override
  State<NorieCurriculumPathScreen> createState() =>
      _NorieCurriculumPathScreenState();
}

class _NorieCurriculumPathScreenState extends State<NorieCurriculumPathScreen>
    with CurriculumSessionGuard<NorieCurriculumPathScreen> {
  final _title = TextEditingController();
  final _registry = CurriculumRegistry.bundled();
  String _id = const Uuid().v4();
  String _query = '';
  String? _notice;
  bool _busy = false;
  List<CurriculumPath> _saved = [];
  final List<CurriculumPathNode> _nodes = [];
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final paths = await widget.store.paths();
      if (curriculumSessionCurrent) setState(() => _saved = paths);
    } catch (error) {
      if (curriculumSessionCurrent) setState(() => _notice = '$error');
    }
  }

  Future<void> _save() async {
    if (_busy || !curriculumSessionCurrent) return;
    setState(() => _busy = true);
    try {
      final path =
          CurriculumPath(id: _id, title: _title.text.trim(), nodes: _nodes);
      await widget.store.savePath(path, _registry);
      if (!curriculumSessionCurrent) return;
      setState(() => _notice =
          'Local path saved with exact lesson fingerprints. Learner maps are unchanged.');
      await _load();
    } catch (error) {
      if (curriculumSessionCurrent) setState(() => _notice = '$error');
    } finally {
      if (curriculumSessionCurrent) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!curriculumSessionCurrent) return changedCurriculumSession;
    final candidates = _registry.search(_query).take(12).toList();
    return Scaffold(
        appBar: AppBar(title: const Text('Path builder')),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child:
                        ListView(padding: const EdgeInsets.all(16), children: [
                      const Text('Local path design',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const Text(
                          'Reference immutable existing lessons. Prerequisites must appear earlier. Draft lessons cannot be placed on a learner path.'),
                      if (_saved.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        const Text('Saved paths'),
                        for (final path in _saved)
                          ListTile(
                              title: Text(path.title),
                              subtitle: Text('${path.nodes.length} nodes'),
                              onTap: () => setState(() {
                                    _id = path.id;
                                    _title.text = path.title;
                                    _nodes.clear();
                                    _nodes.addAll(path.nodes);
                                  }))
                      ],
                      const SizedBox(height: 12),
                      TextField(
                          controller: _title,
                          decoration:
                              const InputDecoration(labelText: 'Path title')),
                      const SizedBox(height: 12),
                      for (var i = 0; i < _nodes.length; i++) _node(i),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        FilledButton(
                            onPressed: _busy ? null : _save,
                            child: const Text('Validate and save path')),
                        TextButton(
                            onPressed: () => setState(() {
                                  _id = const Uuid().v4();
                                  _nodes.clear();
                                  _title.clear();
                                  _notice = null;
                                }),
                            child: const Text('New path'))
                      ]),
                      if (_notice != null)
                        Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(_notice!)),
                      const Divider(),
                      TextField(
                          decoration: const InputDecoration(
                              labelText: 'Find an existing lesson to add',
                              prefixIcon: Icon(Icons.search)),
                          onChanged: (value) => setState(() => _query = value)),
                      for (final revision in candidates)
                        ListTile(
                            title: Text(revision.topic.title),
                            subtitle: Text(
                                '${revision.topic.subject} - ${revision.topic.gradeLevel ?? revision.topic.category}'),
                            trailing: IconButton(
                                tooltip: 'Add lesson revision',
                                icon: const Icon(Icons.add),
                                onPressed: () => _add(revision))),
                    ])))));
  }

  void _add(CurriculumRevision revision) =>
      setState(() => _nodes.add(CurriculumPathNode(
          id: const Uuid().v4(),
          kind: CurriculumPathNodeKind.lesson,
          reference: revision.reference)));
  Widget _node(int index) {
    final node = _nodes[index];
    final revision =
        node.reference == null ? null : _registry.resolve(node.reference!);
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('${index + 1}. ${revision?.topic.title ?? node.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (node.reference != null)
                    SelectableText(
                        'r${node.reference!.revision} ${node.reference!.fingerprint.substring(0, 12)}'),
                  Wrap(spacing: 4, children: [
                    DropdownButton<CurriculumPathNodeKind>(
                        value: node.kind,
                        items: [
                          for (final kind in CurriculumPathNodeKind.values)
                            DropdownMenuItem(
                                value: kind, child: Text(kind.name))
                        ],
                        onChanged: (kind) {
                          if (kind != null) {
                            setState(() => _nodes[index] = CurriculumPathNode(
                                id: node.id,
                                kind: kind,
                                reference: node.reference,
                                prerequisites: node.prerequisites));
                          }
                        }),
                    IconButton(
                        tooltip: 'Move node up',
                        onPressed:
                            index == 0 ? null : () => _move(index, index - 1),
                        icon: const Icon(Icons.arrow_upward)),
                    IconButton(
                        tooltip: 'Move node down',
                        onPressed: index == _nodes.length - 1
                            ? null
                            : () => _move(index, index + 1),
                        icon: const Icon(Icons.arrow_downward)),
                    IconButton(
                        tooltip: 'Remove node',
                        onPressed: () => setState(() => _nodes.removeAt(index)),
                        icon: const Icon(Icons.delete_outline)),
                    if (revision != null)
                      IconButton(
                          tooltip: 'Preview lesson',
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                  builder: (_) => NorieGuidedLearningScreen(
                                      topic: revision.topic))),
                          icon: const Icon(Icons.visibility_outlined)),
                  ]),
                ])));
  }

  void _move(int from, int to) => setState(() {
        final node = _nodes.removeAt(from);
        _nodes.insert(to, node);
      });
}
