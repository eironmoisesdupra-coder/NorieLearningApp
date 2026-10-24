import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/curriculum_pack_codec.dart';
import '../data/curriculum_registry.dart';
import '../data/curriculum_studio_store.dart';
import '../domain/curriculum_revision.dart';
import 'curriculum_session_guard.dart';

class NorieCurriculumPacksScreen extends StatefulWidget {
  const NorieCurriculumPacksScreen({required this.ownerId, super.key});
  final String ownerId;
  @override
  State<NorieCurriculumPacksScreen> createState() =>
      _NorieCurriculumPacksScreenState();
}

class _NorieCurriculumPacksScreenState extends State<NorieCurriculumPacksScreen>
    with CurriculumSessionGuard<NorieCurriculumPacksScreen> {
  late final CurriculumStudioStore _store;
  final _source = TextEditingController();
  final _title = TextEditingController(text: 'Local curriculum drafts');
  final _selected = <String>{};
  List<CurriculumRevision> _drafts = [];
  StagedCurriculumPack? _pack;
  bool _busy = false;
  String? _notice;
  @override
  void initState() {
    super.initState();
    _store = CurriculumStudioStore(widget.ownerId,
        stillCurrent: () => curriculumSessionCurrent);
    _load();
  }

  @override
  void dispose() {
    _source.dispose();
    _title.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final drafts = await _store.load();
      if (curriculumSessionCurrent) setState(() => _drafts = drafts);
    } catch (error) {
      if (curriculumSessionCurrent) setState(() => _notice = '$error');
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy || !curriculumSessionCurrent) return;
    setState(() {
      _busy = true;
      _notice = null;
    });
    try {
      await action();
    } catch (error) {
      if (curriculumSessionCurrent) _notice = '$error';
    } finally {
      if (curriculumSessionCurrent) setState(() => _busy = false);
    }
  }

  Future<void> _inspect(String source) async {
    requireCurrentCurriculumSession();
    final assets =
        await AssetManifest.loadFromAssetBundle(DefaultAssetBundle.of(context));
    if (!curriculumSessionCurrent) return;
    final pack = CurriculumPackCodec.decode(source,
        availableAssets: assets.listAssets().toSet(),
        externalPrerequisites:
            CurriculumRegistry.bundled().revisions.map((r) => r.id).toSet());
    if (curriculumSessionCurrent) {
      setState(() {
        _pack = pack;
        _notice = 'Pack checked. Review the staged draft list before saving.';
      });
    }
  }

  Future<void> _pick() => _run(() async {
        final file = await FilePicker.pickFile(
            type: FileType.custom, allowedExtensions: ['json']);
        if (file == null || !curriculumSessionCurrent) return;
        final size = file.lengthSync() ?? await file.length();
        if (!curriculumSessionCurrent) return;
        if (size == null || size > CurriculumPackCodec.maxBytes) {
          throw const FormatException('Choose a curriculum pack under 2 MiB.');
        }
        final bytes = await file.readAsBytes();
        if (!curriculumSessionCurrent) return;
        if (bytes.length > CurriculumPackCodec.maxBytes) {
          throw const FormatException('Content pack exceeds the size budget.');
        }
        await _inspect(utf8.decode(bytes));
      });
  Future<void> _export() => _run(() async {
        final revisions =
            _drafts.where((r) => _selected.contains(r.id)).toList();
        final text = CurriculumPackCodec.encode(revisions, title: _title.text);
        requireCurrentCurriculumSession();
        final saved = await FilePicker.saveFile(
            dialogTitle: 'Export local curriculum drafts',
            fileName: 'NorieLearning-curriculum-drafts.json',
            bytes: Uint8List.fromList(utf8.encode(text)));
        if (curriculumSessionCurrent) {
          _notice = saved == null
              ? 'Save dialog closed. Check Downloads if your browser started a download.'
              : 'Draft pack exported. It carries no publication authorization.';
        }
      });
  Future<void> _stage() => _run(() async {
        final pack = _pack;
        if (pack == null) return;
        requireCurrentCurriculumSession();
        await _store.saveAll(pack.revisions);
        if (!curriculumSessionCurrent) return;
        setState(() {
          _notice =
              '${pack.revisions.length} drafts saved locally. Prior history retained. Learner lessons unchanged.';
          _pack = null;
        });
        await _load();
      });
  @override
  Widget build(BuildContext context) {
    if (!curriculumSessionCurrent) return changedCurriculumSession;
    final pack = _pack;
    return Scaffold(
        appBar: AppBar(title: const Text('Content packs')),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child:
                        ListView(padding: const EdgeInsets.all(16), children: [
                      const Text('Import into local staging',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const Text(
                          'Versioned JSON packs up to 2 MiB. Fingerprints detect changes; they do not authorize publication. Imported revisions remain drafts.'),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                          onPressed: _busy ? null : _pick,
                          icon: const Icon(Icons.file_open_outlined),
                          label: const Text('Choose pack JSON file')),
                      const SizedBox(height: 8),
                      TextField(
                          controller: _source,
                          minLines: 3,
                          maxLines: 6,
                          onChanged: (_) => setState(() => _pack = null),
                          decoration: const InputDecoration(
                              labelText: 'Or paste pack JSON',
                              border: OutlineInputBorder())),
                      const SizedBox(height: 8),
                      OutlinedButton(
                          onPressed: _busy
                              ? null
                              : () => _run(() => _inspect(_source.text)),
                          child: const Text('Check pasted pack')),
                      if (_busy) const LinearProgressIndicator(),
                      if (_notice != null)
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(_notice!)),
                      if (pack != null)
                        Card(
                            child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(pack.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      Text(
                                          '${pack.locale} - ${pack.revisions.length} draft revisions'),
                                      SelectableText(
                                          'SHA-256 ${pack.fingerprint}'),
                                      for (final revision in pack.revisions)
                                        ListTile(
                                            title: Text(revision.topic.title),
                                            subtitle:
                                                Text('${revision.id} - draft')),
                                      Text(
                                          '${pack.issues.length} editorial issues remain. Structural checks do not establish subject accuracy or human approval.'),
                                      for (final issue in pack.issues.take(12))
                                        Text('- ${issue.message}'),
                                      FilledButton(
                                          onPressed: _busy ? null : _stage,
                                          child: const Text(
                                              'Stage drafts locally')),
                                    ]))),
                      const Divider(height: 32),
                      const Text('Export local drafts',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      TextField(
                          controller: _title,
                          decoration:
                              const InputDecoration(labelText: 'Pack title')),
                      const SizedBox(height: 8),
                      if (_drafts.isEmpty)
                        const Text(
                            'Save a draft in Curriculum Studio before exporting.'),
                      for (final draft in _drafts)
                        CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(draft.topic.title),
                            subtitle:
                                Text('Draft r${draft.revision} - ${draft.id}'),
                            value: _selected.contains(draft.id),
                            onChanged: _busy
                                ? null
                                : (selected) => setState(() {
                                      if (selected == true) {
                                        _selected.add(draft.id);
                                      } else {
                                        _selected.remove(draft.id);
                                      }
                                    })),
                      FilledButton.icon(
                          onPressed:
                              _busy || _selected.isEmpty ? null : _export,
                          icon: const Icon(Icons.file_download_outlined),
                          label: Text(
                              'Export ${_selected.length} selected drafts')),
                    ])))));
  }
}
