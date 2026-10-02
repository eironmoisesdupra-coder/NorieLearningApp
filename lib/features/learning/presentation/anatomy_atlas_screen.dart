import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/audio/norie_audio_manager.dart';
import '../../../core/theme/norie_theme.dart';
import '../domain/anatomy_atlas_catalog.dart';
import '../domain/anatomy_models.dart';
import 'anatomy_atlas_controller.dart';
import 'anatomy_atlas_model_view.dart';
import 'anatomy_atlas_quiz_screen.dart';
import 'anatomy_viewer_screen.dart';

class AnatomyAtlasScreen extends StatefulWidget {
  const AnatomyAtlasScreen({required this.initialSystems, super.key});
  final Set<AnatomySystemId> initialSystems;
  @override
  State<AnatomyAtlasScreen> createState() => _AnatomyAtlasScreenState();
}

class _AnatomyAtlasScreenState extends State<AnatomyAtlasScreen> {
  final _controller = AnatomyAtlasController();
  late Future<AnatomyAtlasCatalog> _future = AnatomyAtlasCatalog.load();
  late Set<String> _systems = widget.initialSystems.map((s) => s.name).toSet();
  String _reference = 'male';
  AtlasStructure? _selected;
  double _opacity = 1;
  late final Object _audioContext;
  @override
  void initState() {
    super.initState();
    _audioContext =
        NorieAudioManager.instance.enterContext(NorieAudioContext.anatomy);
  }

  void _changeReference(String value) {
    NorieAudioManager.instance.playUiSelect();
    setState(() {
      _reference = value;
      _selected = null;
      _systems = switch (value) {
        'female' => {'reproductive'},
        'lymphatic' => {'lymphatic'},
        'ear' => {'sensory'},
        'joints' => {'articular', 'skeletal'},
        'glands' => {'endocrine'},
        _ => {'skeletal'},
      };
      _opacity = 1;
    });
  }

  @override
  void dispose() {
    NorieAudioManager.instance.leaveContext(_audioContext);
    _controller.dispose();
    super.dispose();
  }

  void _select(AtlasStructure structure) {
    NorieAudioManager.instance.playUiSelect();
    setState(() => _selected = structure);
    _controller.send('select', {'id': structure.id});
    _controller.send('focus', {'id': structure.id});
  }

  Future<void> _browse(AnatomyAtlasCatalog catalog) async {
    String query = '';
    final result = await showModalBottomSheet<AtlasStructure>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => StatefulBuilder(builder: (context, update) {
              final results = catalog.search(_reference, _systems, query);
              return SafeArea(
                  child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * .76,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16,
                              MediaQuery.viewInsetsOf(context).bottom),
                          child: Column(children: [
                            TextField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    hintText:
                                        'Search anatomy or anatomical ID'),
                                onChanged: (value) =>
                                    update(() => query = value)),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                    '${results.length} structures in selected systems')),
                            Expanded(
                                child: results.isEmpty
                                    ? const Center(
                                        child: Text('No matching structures'))
                                    : ListView.builder(
                                        itemCount: results.length,
                                        itemBuilder: (context, index) {
                                          final structure = results[index];
                                          return ListTile(
                                              title: Text(structure.name),
                                              subtitle: Text(_systemLabel(
                                                  structure.systems.first)),
                                              trailing: const Icon(
                                                  Icons.center_focus_strong),
                                              onTap: () => Navigator.pop(
                                                  context, structure));
                                        })),
                          ]))));
            }));
    if (mounted && result != null) _select(result);
  }

  Future<void> _chooseReference(AnatomyAtlasCatalog catalog) async {
    final result = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => SafeArea(
            child: SizedBox(
                height: MediaQuery.sizeOf(context).height * .72,
                child: Column(children: [
                  const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Choose an anatomy reference',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  Expanded(
                      child: ListView(children: [
                    for (final reference in catalog.references)
                      ListTile(
                          title: Text(reference.label),
                          subtitle: Text(reference.description),
                          trailing: reference.id == _reference
                              ? const Icon(Icons.check_circle_outline)
                              : const Icon(Icons.chevron_right),
                          onTap: () => Navigator.pop(context, reference.id)),
                  ])),
                ]))));
    if (mounted && result != null) _changeReference(result);
  }

  String _systemLabel(String id) =>
      AnatomyCatalog.systems.firstWhere((s) => s.id.name == id).label;

  void _credits(AnatomyAtlasCatalog catalog) {
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Atlas sources & coverage'),
                content: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const Text(
                          'BodyParts3D 4.0 · The Database Center for Life Science. Official archive: CC BY 4.0. Original source notices are retained in the package.'),
                      const SizedBox(height: 12),
                      const Text(
                          'Human Reference Atlas · Visible Human Female, united reference v1.10. CC BY 4.0. Source anatomy and individual organ credits are included in the package.'),
                      const SizedBox(height: 12),
                      const Text(
                          'Joint, gland and lymphatic detail: BodyParts3D - The Database Center for Life Science - CC-BY-SA 2.1 Japan; Z-Anatomy - The open source atlas of anatomy - CC-BY-SA 4.0. Export: nqwrc/3d-anatomy. Adapted models remain CC BY-SA 4.0.'),
                      const SizedBox(height: 12),
                      const Text(
                          'Inner and middle ear: Sonke Bartling, Marianna Jakab and Ron Kikinis, DKFZ / Surgical Planning Laboratory. Adapted from the SPL Inner Ear Atlas, February 2018, under the 3D Slicer license. Full terms are included in the app assets.'),
                      const SizedBox(height: 12),
                      const Text(
                          'Models are optimized for offline learning. The female reference has partial whole-body coverage. Counts describe selectable model parts, including segments and grouped structures.'),
                      const SizedBox(height: 12),
                      for (final system in AnatomyCatalog.systems)
                        Text('${system.label}: ${catalog.search(_reference, {
                              system.id.name
                            }, '').length} modeled parts'),
                    ])),
                actions: [
                  TextButton(
                      onPressed: () => _licenseTerms(),
                      child: const Text('Full license terms')),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'))
                ]));
  }

  Future<void> _licenseTerms() async {
    final texts = await Future.wait([
      'ATTRIBUTION.md',
      'SPL_EAR_LICENSE.txt',
      'Z_ANATOMY_EXPORT_LICENSE.txt',
      'Z_ANATOMY_UPSTREAM_LICENSE.txt',
      'Z_ANATOMY_NOTICE.txt',
      'ATLAS_RENDERER_LICENSES.txt',
    ].map((name) => rootBundle.loadString('assets/anatomy/$name')));
    if (!mounted) return;
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Anatomy asset licenses'),
              content: SizedBox(
                  width: 640,
                  child: SingleChildScrollView(
                      child: SelectableText(texts.join('\n\n')))),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Anatomy Atlas'), actions: [
          IconButton(
              tooltip: 'Skeleton fundamentals',
              icon: const Icon(Icons.school_outlined),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (_) => const AnatomyViewerScreen(
                          skeletonFundamentals: true,
                          initialSystems: {AnatomySystemId.skeletal})))),
        ]),
        body: SafeArea(
            child: FutureBuilder<AnatomyAtlasCatalog>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text(
                          'The bundled atlas catalog could not be opened.'),
                      FilledButton(
                          onPressed: () => setState(
                              () => _future = AnatomyAtlasCatalog.load()),
                          child: const Text('Retry')),
                    ]));
                  }
                  final catalog = snapshot.data;
                  if (catalog == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final count = catalog.search(_reference, _systems, '').length;
                  final detailLinks = [
                    ('articular', 'joints', 'Joint capsules & ligaments'),
                    ('endocrine', 'glands', 'Thyroid & other glands'),
                    ('lymphatic', 'lymphatic', 'Lymph nodes & organs'),
                    ('sensory', 'ear', 'Inner & middle ear'),
                  ]
                      .where((link) =>
                          _systems.contains(link.$1) && _reference != link.$2)
                      .toList();
                  return Column(children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(children: [
                          Expanded(
                              child: TextButton.icon(
                                  onPressed: () => _chooseReference(catalog),
                                  icon: const Icon(Icons.unfold_more),
                                  label: Text(
                                      catalog.references
                                          .firstWhere((r) => r.id == _reference)
                                          .label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis))),
                          IconButton(
                              tooltip: 'Sources and coverage',
                              onPressed: () => _credits(catalog),
                              icon: const Icon(Icons.info_outline)),
                        ])),
                    if (_reference == 'female')
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                              'Female organ reference · partial whole-body coverage',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: NorieColors.textSecondary))),
                    if (detailLinks.isNotEmpty)
                      SizedBox(
                          height: 48,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              children: [
                                for (final link in detailLinks)
                                  TextButton(
                                      onPressed: () =>
                                          _changeReference(link.$2),
                                      child: Text(link.$3)),
                              ])),
                    if (_reference == 'joints' || _reference == 'glands')
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                              _reference == 'joints'
                                  ? 'Toggle Skeletal for bone context. Search to focus on a small ligament.'
                                  : 'Search to focus on small glands. Gonads are in the male and female references.',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: NorieColors.textSecondary))),
                    SizedBox(
                        height: 49,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            children: [
                              for (final system in AnatomyCatalog.systems)
                                Padding(
                                    padding: const EdgeInsets.only(right: 7),
                                    child: FilterChip(
                                        label: Text(system.label),
                                        selected:
                                            _systems.contains(system.id.name),
                                        onSelected: catalog
                                                .search(_reference,
                                                    {system.id.name}, '')
                                                .isEmpty
                                            ? null
                                            : (enabled) => setState(() {
                                                  if (!enabled &&
                                                      _systems.length == 1) {
                                                    return;
                                                  }
                                                  NorieAudioManager.instance
                                                      .playUiSelect();
                                                  _systems = {..._systems};
                                                  enabled
                                                      ? _systems
                                                          .add(system.id.name)
                                                      : _systems.remove(
                                                          system.id.name);
                                                  _selected = null;
                                                  _opacity = 1;
                                                }))),
                            ])),
                    Expanded(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AnatomyAtlasModelView(
                              controller: _controller,
                              reference: _reference,
                              systems: _systems,
                              onSelected: (id) {
                                final values =
                                    catalog.structures.where((s) => s.id == id);
                                if (values.isNotEmpty) {
                                  setState(() => _selected = values.first);
                                }
                              },
                            ))),
                    SizedBox(
                        height: 46,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            children: [
                              TextButton.icon(
                                  onPressed: () => _browse(catalog),
                                  icon: const Icon(Icons.search),
                                  label: Text('Search $count parts')),
                              TextButton.icon(
                                  onPressed: count == 0
                                      ? null
                                      : () => Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                              builder: (_) =>
                                                  AnatomyAtlasQuizScreen(
                                                      catalog: catalog,
                                                      reference: _reference,
                                                      systems: {..._systems}))),
                                  icon: const Icon(Icons.quiz_outlined),
                                  label: const Text('Quiz')),
                              for (final view in [
                                'front',
                                'back',
                                'left',
                                'right',
                                'top',
                                'reset'
                              ])
                                TextButton(
                                    onPressed: () {
                                      NorieAudioManager.instance.playUiTap();
                                      _controller
                                          .send('camera', {'view': view});
                                    },
                                    child: Text(view[0].toUpperCase() +
                                        view.substring(1))),
                            ])),
                    if (_selected case final selected?)
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(14, 9, 14, 4),
                          color: NorieColors.surface,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(selected.name,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    selected.systems
                                        .map(_systemLabel)
                                        .join(' · '),
                                    style: const TextStyle(
                                        color: NorieColors.textSecondary)),
                                SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: [
                                      TextButton(
                                          onPressed: () {
                                            NorieAudioManager.instance
                                                .playUiTap();
                                            _controller.send(
                                                'focus', {'id': selected.id});
                                          },
                                          child: const Text('Focus')),
                                      TextButton(
                                          onPressed: () {
                                            NorieAudioManager.instance
                                                .playUiSelect();
                                            _controller.send(
                                                'isolate', {'id': selected.id});
                                          },
                                          child: const Text('Isolate')),
                                      TextButton(
                                          onPressed: () {
                                            NorieAudioManager.instance
                                                .playUiSelect();
                                            _controller.send(
                                                'hide', {'id': selected.id});
                                            setState(() => _selected = null);
                                          },
                                          child: const Text('Hide')),
                                      TextButton(
                                          onPressed: () {
                                            NorieAudioManager.instance
                                                .playUiTap();
                                            _controller.send('restore');
                                            setState(() => _opacity = 1);
                                          },
                                          child: const Text('Restore')),
                                    ])),
                              ])),
                    Row(children: [
                      const SizedBox(width: 16),
                      const Text('Opacity'),
                      Expanded(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: DropdownButton<double>(
                                  isExpanded: true,
                                  value: _opacity,
                                  items: [1.0, .8, .6, .35, .15]
                                      .map((value) => DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                                '${(value * 100).round()}%'),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    NorieAudioManager.instance.playUiSelect();
                                    setState(() => _opacity = value);
                                    _controller
                                        .send('opacity', {'value': value});
                                  }))),
                      IconButton(
                          tooltip: 'Restore hidden structures',
                          onPressed: () {
                            NorieAudioManager.instance.playUiTap();
                            _controller.send('restore');
                            setState(() => _opacity = 1);
                          },
                          icon: const Icon(Icons.layers_outlined)),
                    ]),
                  ]);
                })),
      );
}
