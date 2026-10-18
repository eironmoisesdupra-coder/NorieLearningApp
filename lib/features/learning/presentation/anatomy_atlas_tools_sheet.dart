import 'package:flutter/material.dart';

import '../data/anatomy_atlas_bookmark_store.dart';
import '../domain/anatomy_models.dart';
import 'anatomy_atlas_tools_state.dart';

const _globalOpacityPresets = [.15, .35, .6, .8, 1.0];

/// Scrollable controls shared by phone and desktop Explorer. The host owns
/// bookmark navigation: load its reference/systems, then select after real load.
class AnatomyAtlasToolsSheet extends StatefulWidget {
  const AnatomyAtlasToolsSheet({
    super.key,
    required this.state,
    required this.bookmarks,
    required this.selectedId,
    required this.onOpenBookmark,
    required this.onExport,
    this.onShowDetails,
  });
  final AnatomyAtlasToolsState state;
  final AnatomyAtlasBookmarkStore bookmarks;
  final String? selectedId;
  final Future<void> Function(AnatomyAtlasBookmark) onOpenBookmark;
  final Future<void> Function(String json) onExport;
  final ValueChanged<String>? onShowDetails;

  @override
  State<AnatomyAtlasToolsSheet> createState() => _AnatomyAtlasToolsSheetState();
}

class _AnatomyAtlasToolsSheetState extends State<AnatomyAtlasToolsSheet> {
  bool _busy = false;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    if (!widget.bookmarks.loaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _perform(widget.bookmarks.load);
      });
    }
  }

  Future<void> _perform(Future<void> Function() action,
      {String? success}) async {
    if (_busy) return;
    final operationStore = widget.bookmarks;
    setState(() {
      _busy = true;
      _feedback = null;
    });
    try {
      if (!operationStore.isCurrent) {
        throw StateError('Learner changed. Close and reopen Explorer tools.');
      }
      await action();
      if (!mounted) return;
      setState(() => _feedback = identical(operationStore, widget.bookmarks) &&
              operationStore.isCurrent
          ? success
          : 'Learner changed. Close and reopen Explorer tools.');
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _feedback = switch (error) {
            FormatException() => error.message,
            StateError() => error.message,
            _ =>
              'Saved views could not be updated on this device. Please retry.',
          });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _mutate(Future<bool> Function() action, String success) =>
      _perform(() async {
        if (!await action()) {
          throw StateError('Learner changed. Close and reopen Explorer tools.');
        }
      }, success: success);

  String _systemLabel(String system) =>
      AnatomyCatalog.systems
          .where((s) => s.id.name == system)
          .firstOrNull
          ?.label ??
      system;
  String _viewLabel(String view) => view[0].toUpperCase() + view.substring(1);

  Future<void> _chooseComparison(String selectedId) async {
    final tools = widget.state;
    final reference = tools.reference;
    var query = '';
    final candidate = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => StatefulBuilder(builder: (context, update) {
              final visible = tools.visibleIds;
              final rows = tools.eligible
                  .where((s) =>
                      s.id != selectedId &&
                      visible.contains(s.id) &&
                      s.name.toLowerCase().contains(query))
                  .toList()
                ..sort((a, b) => a.name.compareTo(b.name));
              final keyboard = MediaQuery.viewInsetsOf(context).bottom;
              final screen = MediaQuery.sizeOf(context).height;
              return SafeArea(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: keyboard),
                      child: SizedBox(
                          height: (screen * .7 - keyboard).clamp(120.0, screen),
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(16),
                                child: TextField(
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                        labelText: 'Compare visible parts',
                                        prefixIcon: Icon(Icons.search)),
                                    onChanged: (value) => update(() => query =
                                        value.trim().toLowerCase().substring(
                                            0,
                                            value
                                                .trim()
                                                .length
                                                .clamp(0, 160))))),
                            Expanded(
                                child: rows.isEmpty
                                    ? const Center(
                                        child: Text('No other visible parts'))
                                    : ListView.builder(
                                        itemCount: rows.length,
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                                title: Text(rows[index].name),
                                                onTap: () => Navigator.pop(
                                                    context, rows[index].id)))),
                          ]))));
            }));
    if (!mounted || candidate == null || tools.reference != reference) return;
    tools.compare(selectedId, candidate);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
      child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .85,
          child: AnimatedBuilder(
              animation: Listenable.merge([widget.state, widget.bookmarks]),
              builder: (context, _) {
                final tools = widget.state;
                final store = widget.bookmarks;
                final selectedId = tools.selectedId ?? widget.selectedId;
                final selected =
                    selectedId != null && tools.visibleIds.contains(selectedId)
                        ? tools.structure(selectedId)
                        : null;
                final currentRows = store.bookmarks
                    .where((b) => b.reference == tools.reference)
                    .toList();
                final enabled = !_busy && store.isCurrent;
                return ListView(padding: const EdgeInsets.all(16), children: [
                  Text('Explorer tools',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  const Text('System layers',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text(
                      'Shared parts remain visible through any visible system.'),
                  for (final system in tools.systems)
                    ExpansionTile(
                        key: ValueKey('atlas-layer-$system'),
                        title: Text(_systemLabel(system)),
                        subtitle: Text(
                            '${tools.layerVisible(system) ? 'Visible' : 'Hidden'} · '
                            '${(tools.layerOpacity(system) * 100).round()}%'),
                        children: [
                          SwitchListTile(
                              title: Text('Show ${_systemLabel(system)}'),
                              value: tools.layerVisible(system),
                              onChanged: (value) =>
                                  tools.setLayer(system, visible: value)),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('System opacity'),
                                    Slider(
                                        value: tools.layerOpacity(system),
                                        min: 0,
                                        max: 1,
                                        divisions: 20,
                                        semanticFormatterCallback: (v) =>
                                            '${(v * 100).round()} percent',
                                        label:
                                            '${(tools.layerOpacity(system) * 100).round()}%',
                                        onChanged: (value) => tools
                                            .setLayer(system, opacity: value)),
                                  ])),
                        ]),
                  const SizedBox(height: 12),
                  Text(
                      'Global opacity · ${(tools.globalOpacity * 100).round()}%'),
                  Slider(
                      value: _globalOpacityPresets
                          .indexOf(tools.globalOpacity)
                          .clamp(0, 4)
                          .toDouble(),
                      min: 0,
                      max: 4,
                      divisions: 4,
                      label: '${(tools.globalOpacity * 100).round()}%',
                      semanticFormatterCallback: (v) =>
                          '${(_globalOpacityPresets[v.round()] * 100).round()} percent',
                      onChanged: (value) => tools.setGlobalOpacity(
                          _globalOpacityPresets[value.round().clamp(0, 4)])),
                  TextButton.icon(
                      onPressed: tools.restore,
                      icon: const Icon(Icons.restore),
                      label: const Text('Restore all layers and parts')),
                  const Divider(),
                  const Text('Compare within this reference',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (selected != null)
                    Text('Selected: ${selected.name}')
                  else
                    const Text('Select a visible part to compare.'),
                  TextButton.icon(
                      onPressed: selected == null || tools.visibleIds.length < 2
                          ? null
                          : () => _chooseComparison(selected.id),
                      icon: const Icon(Icons.compare_arrows),
                      label: const Text('Compare with another part')),
                  if (tools.compareIds.isNotEmpty) ...[
                    for (var i = 0; i < tools.compareIds.length; i++)
                      ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.circle,
                              color: i == 0 ? Colors.lightBlue : Colors.amber),
                          title: Text(
                              tools.structure(tools.compareIds[i])?.name ??
                                  'Unavailable part'),
                          subtitle: Text('Part ${i + 1} · same reference'),
                          onTap: widget.onShowDetails == null
                              ? null
                              : () =>
                                  widget.onShowDetails!(tools.compareIds[i])),
                    TextButton(
                        onPressed: tools.clearCompare,
                        child: const Text('Clear comparison')),
                  ],
                  const Divider(),
                  const Text('Saved views',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Text(
                      'Save a part and a named camera direction on this device. '
                      'Free rotation and physical measurements are not saved.'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                      key: ValueKey('atlas-camera-${tools.cameraView}'),
                      initialValue: tools.cameraView,
                      isExpanded: true,
                      decoration:
                          const InputDecoration(labelText: 'Named camera view'),
                      items: [
                        for (final view in atlasNamedViews)
                          DropdownMenuItem(
                              value: view, child: Text(_viewLabel(view)))
                      ],
                      onChanged: (view) {
                        if (view != null) tools.camera(view);
                      }),
                  TextButton.icon(
                      onPressed: !enabled || !store.loaded || selected == null
                          ? null
                          : () => _mutate(
                              () => store.save(
                                  reference: tools.reference,
                                  structureId: selected.id,
                                  view: tools.cameraView),
                              'View saved on this device.'),
                      icon: const Icon(Icons.bookmark_add_outlined),
                      label: const Text('Save current view')),
                  if (_busy) const LinearProgressIndicator(),
                  if (_feedback != null)
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(_feedback!,
                            key: const ValueKey('atlas-bookmark-feedback'))),
                  if (!store.loaded && !_busy)
                    TextButton(
                        onPressed: !enabled ? null : () => _perform(store.load),
                        child: const Text('Retry loading saved views')),
                  Text(
                      '${currentRows.length}/${AnatomyAtlasBookmarkStore.maxPerReference} saved views in this reference'),
                  for (final bookmark in store.bookmarks)
                    ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                            tools.structure(bookmark.structureId)?.name ??
                                'Unavailable part'),
                        subtitle: Text(
                            '${tools.catalog.references.where((r) => r.id == bookmark.reference).firstOrNull?.label ?? bookmark.reference} · ${_viewLabel(bookmark.view)}'),
                        onTap: !enabled
                            ? null
                            : () => _perform(
                                () => widget.onOpenBookmark(bookmark),
                                success: 'Saved view opened.'),
                        trailing: IconButton(
                            tooltip: 'Delete saved view',
                            onPressed: !enabled
                                ? null
                                : () => _mutate(() => store.delete(bookmark),
                                    'Saved view deleted.'),
                            icon: const Icon(Icons.delete_outline))),
                  Wrap(spacing: 8, runSpacing: 4, children: [
                    TextButton.icon(
                        onPressed: !enabled || !store.loaded
                            ? null
                            : () => _perform(
                                () => widget.onExport(store.exportJson()),
                                success: 'Saved views exported.'),
                        icon: const Icon(Icons.file_download_outlined),
                        label: const Text('Export saved views JSON')),
                    TextButton(
                        onPressed: !enabled
                            ? null
                            : () => _mutate(store.reset,
                                'All saved views for this learner were reset.'),
                        child: const Text('Reset this learner’s saved views')),
                  ]),
                  const SizedBox(height: 8),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close tools')),
                ]);
              })));
}
