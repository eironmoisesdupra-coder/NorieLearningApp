import 'curriculum_session_guard.dart';
import 'package:flutter/material.dart';
import '../data/curriculum_registry.dart';
import '../data/curriculum_studio_store.dart';
import '../domain/curriculum_revision.dart';
import 'norie_curriculum_draft_editor_screen.dart';
import 'norie_curriculum_path_screen.dart';

class NorieCurriculumStudioScreen extends StatefulWidget {
  const NorieCurriculumStudioScreen({required this.ownerId, super.key});
  final String ownerId;
  @override
  State<NorieCurriculumStudioScreen> createState() =>
      _NorieCurriculumStudioScreenState();
}

class _NorieCurriculumStudioScreenState
    extends State<NorieCurriculumStudioScreen>
    with CurriculumSessionGuard<NorieCurriculumStudioScreen> {
  late CurriculumStudioStore _store;
  List<CurriculumRevision> _drafts = [];
  String _query = '';
  String? _error;
  @override
  void initState() {
    super.initState();
    _store = CurriculumStudioStore(widget.ownerId,
        stillCurrent: () => curriculumSessionCurrent);
    _load();
  }

  @override
  void didUpdateWidget(covariant NorieCurriculumStudioScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ownerId != widget.ownerId) {
      _store = CurriculumStudioStore(widget.ownerId,
          stillCurrent: () => curriculumSessionCurrent);
      _drafts = [];
      _error = null;
      _load();
    }
  }

  Future<void> _load() async {
    final store = _store;
    try {
      final drafts = await store.load();
      if (curriculumSessionCurrent && identical(store, _store)) {
        setState(() {
          _drafts = drafts;
          _error = null;
        });
      }
    } catch (error) {
      if (curriculumSessionCurrent && identical(store, _store)) {
        setState(() => _error = '$error');
      }
    }
  }

  Future<void> _edit(CurriculumRevision revision) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => NorieCurriculumDraftEditorScreen(
            store: _store, initial: revision)));
    await _load();
  }

  Future<void> _copy() async {
    final revision = await showDialog<CurriculumRevision>(
        context: context, builder: (context) => const _SourcePicker());
    if (revision != null && curriculumSessionCurrent) {
      await _edit(revision.asDraft());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!curriculumSessionCurrent) return changedCurriculumSession;
    final drafts = _drafts
        .where((r) => [
              r.id,
              r.topic.title,
              r.topic.subject,
              r.topic.gradeLevel ?? ''
            ].join(' ').toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Scaffold(
        appBar: AppBar(title: const Text('Curriculum Studio')),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child:
                        ListView(padding: const EdgeInsets.all(16), children: [
                      const Text('Local drafts · not published',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text(
                          'Create and validate a draft, compare revisions and restore earlier work. Publication and reviewer authorization require a server and real editorial review.'),
                      const SizedBox(height: 12),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        FilledButton.icon(
                            onPressed: _copy,
                            icon: const Icon(Icons.copy),
                            label: const Text('Draft from existing lesson')),
                        OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                    builder: (_) => NorieCurriculumPathScreen(
                                        store: _store))),
                            icon: const Icon(Icons.route),
                            label: const Text('Path builder'))
                      ]),
                      const SizedBox(height: 12),
                      TextField(
                          decoration: const InputDecoration(
                              labelText: 'Search local drafts',
                              prefixIcon: Icon(Icons.search)),
                          onChanged: (value) => setState(() => _query = value)),
                      if (_error != null)
                        Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(_error!)),
                      if (drafts.isEmpty)
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 28),
                            child: Text(
                                'Local drafts will appear here after you save a copy or stage a content pack.')),
                      for (final revision in drafts)
                        ListTile(
                            title: Text(revision.topic.title),
                            subtitle: Text(
                                '${revision.id}\nDraft r${revision.revision} · ${revision.topic.subject}'),
                            isThreeLine: true,
                            trailing: const Icon(Icons.edit_outlined),
                            onTap: () => _edit(revision)),
                    ])))));
  }
}

class _SourcePicker extends StatefulWidget {
  const _SourcePicker();
  @override
  State<_SourcePicker> createState() => _SourcePickerState();
}

class _SourcePickerState extends State<_SourcePicker> {
  String _query = '';
  @override
  Widget build(BuildContext context) {
    final rows = CurriculumRegistry.bundled().search(_query);
    return Dialog(
        child: SizedBox(
            width: 600,
            height: 600,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  const Text('Copy an existing lesson into a local draft'),
                  TextField(
                      decoration:
                          const InputDecoration(labelText: 'Find a lesson'),
                      onChanged: (value) => setState(() => _query = value)),
                  Expanded(
                      child: ListView.builder(
                          itemCount: rows.length,
                          itemBuilder: (_, index) => ListTile(
                              title: Text(rows[index].topic.title),
                              subtitle: Text(rows[index].id),
                              onTap: () =>
                                  Navigator.of(context).pop(rows[index])))),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel')),
                ]))));
  }
}
