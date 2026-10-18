import 'curriculum_session_guard.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/curriculum_registry.dart';
import '../data/curriculum_studio_store.dart';
import '../domain/curriculum_revision.dart';
import '../domain/curriculum_validation.dart';
import 'norie_guided_learning_screen.dart';

class NorieCurriculumDraftEditorScreen extends StatefulWidget {
  const NorieCurriculumDraftEditorScreen(
      {required this.store, required this.initial, super.key});
  final CurriculumStudioStore store;
  final CurriculumRevision initial;
  @override
  State<NorieCurriculumDraftEditorScreen> createState() =>
      _NorieCurriculumDraftEditorScreenState();
}

class _NorieCurriculumDraftEditorScreenState
    extends State<NorieCurriculumDraftEditorScreen>
    with CurriculumSessionGuard<NorieCurriculumDraftEditorScreen> {
  late final TextEditingController _source;
  String? _notice;
  bool _busy = false;
  List<CurriculumIssue> _issues = [];
  @override
  void initState() {
    super.initState();
    _source = TextEditingController(
        text: const JsonEncoder.withIndent('  ').convert({
      'topic': widget.initial.topicJson,
      'metadata': widget.initial.metadata
    }));
  }

  @override
  void dispose() {
    _source.dispose();
    super.dispose();
  }

  CurriculumRevision _parse() {
    if (utf8.encode(_source.text).length > 1024 * 1024) {
      throw const FormatException('Draft exceeds the 1 MiB editor budget.');
    }
    try {
      final doc = jsonDecode(_source.text) as Map<String, dynamic>;
      final draft = CurriculumRevision.draft(
          Map<String, dynamic>.from(doc['topic'] as Map),
          metadata: Map<String, dynamic>.from(doc['metadata'] as Map));
      if (draft.id != widget.initial.id) {
        throw const FormatException(
            'Keep this lesson ID stable. Import a new lesson through a content pack.');
      }
      return draft;
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException(
          'Provide a valid lesson topic and metadata JSON object.');
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
      _notice = '$error';
    } finally {
      if (curriculumSessionCurrent) setState(() => _busy = false);
    }
  }

  Future<void> _validate() => _run(() async {
        final assets = await AssetManifest.loadFromAssetBundle(
            DefaultAssetBundle.of(context));
        if (!curriculumSessionCurrent) return;
        final draft = _parse();
        final issues = CurriculumValidator.validate([draft],
            availableAssets: assets.listAssets().toSet(),
            externalPrerequisites: CurriculumRegistry.bundled()
                .revisions
                .map((r) => r.id)
                .toSet());
        if (!curriculumSessionCurrent) return;
        setState(() {
          _issues = issues;
          _notice = issues.isEmpty
              ? 'Structural checks passed. Real editorial review is still required.'
              : '${issues.length} issues to resolve before review.';
        });
      });
  Future<void> _diff() => _run(() async {
        final draft = _parse();
        final history = await widget.store.history(draft.id);
        if (!curriculumSessionCurrent) return;
        final before = history.isEmpty ? widget.initial : history.last;
        final changes = <String>[];
        void compare(String path, Object? a, Object? b) {
          if (a is Map && b is Map) {
            final keys = {...a.keys, ...b.keys};
            for (final key in keys) {
              compare('$path/$key', a[key], b[key]);
            }
          } else if (jsonEncode(a) != jsonEncode(b)) {
            changes.add(
                '$path\nBefore: ${jsonEncode(a)}\nAfter: ${jsonEncode(b)}');
          }
        }

        compare('topic', before.topicJson, draft.topicJson);
        compare('metadata', before.metadata, draft.metadata);
        if (!curriculumSessionCurrent) return;
        if (!mounted) return;
        await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
                    title: const Text('Changes from saved revision'),
                    content: SizedBox(
                        width: 650,
                        child: SingleChildScrollView(
                            child: SelectableText(changes.isEmpty
                                ? 'No content changes.'
                                : changes.join('\n\n')))),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'))
                    ]));
      });
  @override
  Widget build(BuildContext context) => !curriculumSessionCurrent
      ? changedCurriculumSession
      : Scaffold(
          appBar: AppBar(title: const Text('Edit local draft')),
          body: SafeArea(
              child: Center(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Text(widget.initial.id,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text(
                                'Edit the lesson and editorial metadata. Sources, licenses, objectives and review evidence must be real. Saving stores a local draft only.'),
                            const SizedBox(height: 12),
                            TextField(
                                controller: _source,
                                onChanged: (_) {
                                  if (_issues.isNotEmpty) {
                                    setState(() {
                                      _issues = [];
                                      _notice = null;
                                    });
                                  }
                                },
                                minLines: 12,
                                maxLines: 24,
                                keyboardType: TextInputType.multiline,
                                autocorrect: false,
                                decoration: const InputDecoration(
                                    labelText: 'Lesson and metadata JSON',
                                    border: OutlineInputBorder())),
                            const SizedBox(height: 12),
                            Wrap(spacing: 8, runSpacing: 8, children: [
                              FilledButton(
                                  onPressed: _busy
                                      ? null
                                      : () => _run(() async {
                                            await widget.store.save(_parse());
                                            _notice =
                                                'Draft saved locally. Learner lessons are unchanged.';
                                          }),
                                  child: const Text('Save draft')),
                              OutlinedButton(
                                  onPressed: _busy ? null : _validate,
                                  child: const Text('Validate')),
                              OutlinedButton(
                                  onPressed: _busy
                                      ? null
                                      : () => _run(() async {
                                            final draft = _parse();
                                            await Navigator.of(context).push(
                                                MaterialPageRoute<void>(
                                                    builder: (_) =>
                                                        NorieGuidedLearningScreen(
                                                            topic: draft.topic,
                                                            draftPreview: true,
                                                            metadata: draft
                                                                .metadata)));
                                          }),
                                  child: const Text('Preview')),
                              OutlinedButton(
                                  onPressed: _busy ? null : _diff,
                                  child: const Text('View diff')),
                              TextButton(
                                  onPressed: _busy
                                      ? null
                                      : () => _run(() async {
                                            await widget.store
                                                .rollback(widget.initial.id);
                                            final restored = (await widget.store
                                                    .load())
                                                .firstWhere((r) =>
                                                    r.id == widget.initial.id);
                                            if (!curriculumSessionCurrent) {
                                              return;
                                            }
                                            _source.text =
                                                const JsonEncoder.withIndent(
                                                        '  ')
                                                    .convert({
                                              'topic': restored.topicJson,
                                              'metadata': restored.metadata
                                            });
                                            _notice =
                                                'Earlier content restored as draft r${restored.revision}. History retained.';
                                          }),
                                  child: const Text('Rollback previous')),
                            ]),
                            if (_busy) const LinearProgressIndicator(),
                            if (_notice != null)
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(_notice!)),
                            for (final issue in _issues)
                              ListTile(
                                  dense: true,
                                  title: Text(issue.message),
                                  subtitle: Text(
                                      '${issue.code} ? ${issue.location}')),
                          ])))));
}
