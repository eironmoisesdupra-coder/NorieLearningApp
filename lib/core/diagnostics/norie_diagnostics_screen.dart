import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../release/norie_app_info.dart';
import 'norie_diagnostics.dart';

class NorieDiagnosticsScreen extends StatefulWidget {
  const NorieDiagnosticsScreen({super.key, this.store});
  final NorieDiagnosticsStore? store;
  @override
  State<NorieDiagnosticsScreen> createState() => _NorieDiagnosticsScreenState();
}

class _NorieDiagnosticsScreenState extends State<NorieDiagnosticsScreen> {
  late final store = widget.store ?? NorieDiagnosticsStore.instance;
  bool _busy = false;
  String? _notice;
  @override
  void initState() {
    super.initState();
    store.load();
  }

  Future<void> _perform(Future<void> Function() action) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _notice = null;
    });
    try {
      await action();
    } catch (_) {
      _notice = 'Could not finish. Please retry.';
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export() => _perform(() async {
        final document = jsonDecode(store.exportJson()) as Map<String, dynamic>;
        // Build metadata is restricted too; build environment values are not trusted text.
        document['appVersion'] = RegExp(r'^\d{1,4}\.\d{1,4}\.\d{1,4}$')
                .hasMatch(NorieAppInfo.version)
            ? NorieAppInfo.version
            : 'unknown';
        document['appBuild'] = RegExp(r'^\d{1,8}$').hasMatch(NorieAppInfo.build)
            ? NorieAppInfo.build
            : 'unknown';
        final result = await FilePicker.saveFile(
            dialogTitle: 'Save local diagnostics',
            fileName: 'NorieLearning-diagnostics.json',
            type: FileType.custom,
            allowedExtensions: ['json'],
            bytes: Uint8List.fromList(utf8
                .encode(const JsonEncoder.withIndent('  ').convert(document))));
        _notice = result == null
            ? 'Save dialog closed. Check Downloads if your browser started a download.'
            : 'Diagnostics saved. Share this file only if you choose.';
      });
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Local diagnostics')),
        body: ListenableBuilder(
            listenable: store,
            builder: (context, _) =>
                ListView(padding: const EdgeInsets.all(16), children: [
                  const Text('Private, on this device',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                      'Norie keeps a small local error history to help investigate problems. '
                      'Nothing is uploaded automatically. Errors contain only a time, a general category, '
                      'an error source and a fixed screen label. Error text, stack traces, accounts, '
                      'notes, answers and credentials are excluded.'),
                  const SizedBox(height: 12),
                  SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Keep local error history'),
                      subtitle: const Text(
                          'Turning this off stops new records. Use Clear history to remove existing records.'),
                      value: store.enabled,
                      onChanged: _busy
                          ? null
                          : (value) => _perform(() => store.setEnabled(value))),
                  const SizedBox(height: 12),
                  const Text('History retention'),
                  DropdownButtonFormField<int>(
                      initialValue: store.retentionDays,
                      isExpanded: true,
                      items: [
                        for (final days
                            in NorieDiagnosticsStore.retentionOptions)
                          DropdownMenuItem(
                              value: days, child: Text('$days days'))
                      ],
                      onChanged: _busy
                          ? null
                          : (value) {
                              if (value != null) {
                                _perform(() => store.setRetentionDays(value));
                              }
                            }),
                  const SizedBox(height: 8),
                  const Text(
                      'At most 100 records are kept. Repeated errors are limited. Expired records are removed when diagnostics are used.'),
                  if (store.storageProblem != null) ...[
                    const SizedBox(height: 12),
                    Text(store.storageProblem!),
                    const Text(
                        'Unreadable history is left untouched until you choose Clear history.'),
                    TextButton(
                        onPressed: _busy ? null : () => _perform(store.flush),
                        child: const Text('Retry saving')),
                  ],
                  const SizedBox(height: 16),
                  FilledButton.icon(
                      onPressed: _busy ? null : _export,
                      icon: const Icon(Icons.save_alt),
                      label: const Text('Save diagnostics file')),
                  const Text(
                      'The saved file contains only the facts described above and the app version. Review it before sharing.'),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                      onPressed: _busy ? null : () => _perform(store.clear),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Clear history')),
                  if (_notice != null) ...[
                    const SizedBox(height: 8),
                    Text(_notice!, semanticsLabel: _notice)
                  ],
                  const SizedBox(height: 20),
                  Text('${store.entries.length} local records',
                      style: Theme.of(context).textTheme.titleMedium),
                  if (store.entries.isEmpty)
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('No local errors recorded.')),
                  for (final entry in store.entries.reversed)
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.message),
                              Text(
                                  '${entry.at.toLocal().toString().split('.').first}\n${entry.source.name} / ${entry.route}'),
                            ])),
                ])),
      );
}
