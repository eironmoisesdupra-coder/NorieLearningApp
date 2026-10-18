import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/audio/norie_audio_manager.dart';
import '../../../core/mascot/norie_mascot_scope.dart';
import '../../../core/mascot/tutorial/norie_tutorial_models.dart';
import '../../../core/mascot/tutorial/norie_tutorial_overlay.dart';
import '../../../core/theme/norie_theme.dart';
import '../domain/anatomy_atlas_catalog.dart';
import '../domain/anatomy_models.dart';
import 'anatomy_atlas_controller.dart';
import 'anatomy_atlas_details.dart';
import 'anatomy_atlas_model_view.dart';
import 'anatomy_atlas_quiz_setup_screen.dart';
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
  bool _advanced = false;
  bool _showSystems = true;
  String? _tutorialStructureId;

  void _focusTutorialModel() {
    final step =
        NorieMascotScope.maybeOf(context)?.tutorialCoordinator.currentStep;
    if (step?.id == 'anatomy-camera' && _tutorialStructureId != null) {
      _controller.send('focus', {'id': _tutorialStructureId});
    } else {
      _controller.send('camera', {'view': 'reset'});
    }
  }

  void _tutorialModelLoaded(bool loaded) {
    if (loaded &&
        _selected != null &&
        _selected!.reference == _reference &&
        _selected!.systems.intersection(_systems).isNotEmpty) {
      _controller.send('select', {'id': _selected!.id});
    }
    final coordinator = NorieMascotScope.maybeOf(context)?.tutorialCoordinator;
    if (loaded &&
        coordinator?.currentStep?.destination ==
            NorieTutorialDestination.anatomy &&
        coordinator?.showingContents == false) {
      _focusTutorialModel();
    }
  }

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

  void _details(AnatomyAtlasCatalog catalog) {
    final selected = _selected;
    if (selected == null) return;
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => SafeArea(
            child: SizedBox(
                height: MediaQuery.sizeOf(context).height * .64,
                child: Column(children: [
                  Expanded(
                      child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: AnatomyAtlasDetails(
                              structure: selected,
                              reference: catalog.references.firstWhere(
                                  (r) => r.id == selected.reference),
                              advanced: _advanced))),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close details'))
                ]))));
  }

  void _options() {
    showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) => StatefulBuilder(
            builder: (context, update) => SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text('Explorer presentation',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SwitchListTile(
                          title: const Text('Advanced identifiers'),
                          subtitle: const Text(
                              'Show source identifiers and terminology in details and search results.'),
                          value: _advanced,
                          onChanged: (value) {
                            setState(() => _advanced = value);
                            update(() {});
                          }),
                      const ListTile(
                          leading: Icon(Icons.touch_app_outlined),
                          title: Text(
                              'Drag to rotate. Pinch or scroll to zoom. Use two fingers or right-drag to pan. Tap a part to select it.')),
                      const ListTile(
                          leading: Icon(Icons.school_outlined),
                          title: Text(
                              'Beginner mode keeps the same real models and labels. Presentation settings do not affect XP or access.')),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close options')),
                    ])))));
  }

  void _compactControls(AnatomyAtlasCatalog catalog) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (sheetContext) => StatefulBuilder(
            builder: (context, update) => SafeArea(
                child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * .7,
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton.icon(
                                  icon: const Icon(Icons.unfold_more),
                                  label: const Text('Choose reference'),
                                  onPressed: () {
                                    Navigator.pop(sheetContext);
                                    _chooseReference(catalog);
                                  }),
                              const Text('Systems',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Wrap(spacing: 8, runSpacing: 8, children: [
                                for (final system in AnatomyCatalog.systems)
                                  FilterChip(
                                      label: Text(system.label),
                                      selected:
                                          _systems.contains(system.id.name),
                                      onSelected: catalog
                                              .search(_reference,
                                                  {system.id.name}, '')
                                              .isEmpty
                                          ? null
                                          : (enabled) {
                                              if (!enabled &&
                                                  _systems.length == 1) {
                                                return;
                                              }
                                              setState(() {
                                                _systems = {..._systems};
                                                enabled
                                                    ? _systems
                                                        .add(system.id.name)
                                                    : _systems
                                                        .remove(system.id.name);
                                                if (_selected != null &&
                                                    _selected!.systems
                                                        .intersection(_systems)
                                                        .isEmpty) {
                                                  _selected = null;
                                                }
                                                _opacity = 1;
                                              });
                                              update(() {});
                                            })
                              ]),
                              const SizedBox(height: 12),
                              const Text('Opacity'),
                              Slider(
                                  value: [.15, .35, .6, .8, 1.0]
                                      .indexOf(_opacity)
                                      .clamp(0, 4)
                                      .toDouble(),
                                  min: 0,
                                  max: 4,
                                  divisions: 4,
                                  label: '${(_opacity * 100).round()}%',
                                  onChanged: (value) {
                                    final opacity = [
                                      .15,
                                      .35,
                                      .6,
                                      .8,
                                      1.0
                                    ][value.round().clamp(0, 4)];
                                    setState(() => _opacity = opacity);
                                    update(() {});
                                    _controller
                                        .send('opacity', {'value': opacity});
                                  }),
                              if (_selected case final selected?) ...[
                                Text(selected.name),
                                Wrap(children: [
                                  TextButton(
                                      onPressed: () => _controller
                                          .send('focus', {'id': selected.id}),
                                      child: const Text('Focus')),
                                  TextButton(
                                      onPressed: () => _controller
                                          .send('isolate', {'id': selected.id}),
                                      child: const Text('Isolate')),
                                  TextButton(
                                      onPressed: () {
                                        _controller
                                            .send('hide', {'id': selected.id});
                                        setState(() => _selected = null);
                                        update(() {});
                                      },
                                      child: const Text('Hide')),
                                ]),
                              ],
                              TextButton.icon(
                                  icon: const Icon(Icons.restore),
                                  onPressed: () {
                                    _controller.send('restore');
                                    setState(() => _opacity = 1);
                                    update(() {});
                                  },
                                  label: const Text('Restore')),
                              TextButton(
                                  onPressed: () => Navigator.pop(sheetContext),
                                  child: const Text('Close controls')),
                            ]))))));
  }

  Future<void> _browse(AnatomyAtlasCatalog catalog) async {
    String query = '';
    final result = await showModalBottomSheet<AtlasStructure>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) => StatefulBuilder(builder: (context, update) {
              final results = catalog.search(_reference, _systems, query);
              final screen = MediaQuery.sizeOf(context).height;
              final keyboard = MediaQuery.viewInsetsOf(context).bottom;
              final available = (screen - keyboard - 64).clamp(0.0, screen);
              final height = available < screen * .7 ? available : screen * .7;
              return SafeArea(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: keyboard),
                      child: SizedBox(
                          height: height,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: results.isEmpty ? 3 : results.length + 2,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return TextField(
                                    key: const ValueKey('atlas-search-field'),
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.search),
                                        hintText:
                                            'Search anatomy or anatomical ID'),
                                    onChanged: (value) =>
                                        update(() => query = value));
                              }
                              if (index == 1) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                        '${results.length} structures in selected systems'));
                              }
                              if (results.isEmpty) {
                                return const ListTile(
                                    title: Text('No matching structures'));
                              }
                              final structure = results[index - 2];
                              return ListTile(
                                  title: Text(structure.name),
                                  subtitle: Text(_advanced
                                      ? '${_systemLabel(structure.systems.first)} ? ${structure.ontology} ? ${structure.id}'
                                      : _systemLabel(structure.systems.first)),
                                  trailing:
                                      const Icon(Icons.center_focus_strong),
                                  onTap: () =>
                                      Navigator.pop(context, structure));
                            },
                          ))));
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: const Text('Anatomy Atlas',
                maxLines: 1, overflow: TextOverflow.ellipsis),
            actions: [
              IconButton(
                  tooltip: 'Explorer options',
                  onPressed: _options,
                  icon: const Icon(Icons.tune_rounded)),
              const NorieTutorialReplayButton(
                  definition: NorieTutorialCatalog.anatomy),
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
                  final compact = MediaQuery.sizeOf(context).height < 500;
                  final count = catalog.search(_reference, _systems, '').length;
                  _tutorialStructureId = catalog
                      .search(_reference, _systems, 'femur')
                      .firstOrNull
                      ?.id;
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
                    if (!compact)
                      NorieTutorialTarget(
                          id: 'anatomy.settings',
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(children: [
                                Expanded(
                                    child: TextButton.icon(
                                        onPressed: () =>
                                            _chooseReference(catalog),
                                        icon: const Icon(Icons.unfold_more),
                                        label: Text(
                                            catalog.references
                                                .firstWhere(
                                                    (r) => r.id == _reference)
                                                .label,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis))),
                                IconButton(
                                    tooltip: _showSystems
                                        ? 'Hide systems'
                                        : 'Show systems',
                                    onPressed: () => setState(
                                        () => _showSystems = !_showSystems),
                                    icon: const Icon(Icons.category_outlined)),
                                IconButton(
                                    tooltip: 'Sources and coverage',
                                    onPressed: () => _credits(catalog),
                                    icon: const Icon(Icons.info_outline)),
                              ]))),
                    if (!compact &&
                        _reference == 'female' &&
                        MediaQuery.sizeOf(context).width >= 600)
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                              'Female organ reference · partial whole-body coverage',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: NorieColors.textSecondary))),
                    if (!compact &&
                        detailLinks.isNotEmpty &&
                        MediaQuery.sizeOf(context).width >= 600)
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
                    if (!compact &&
                        (_reference == 'joints' || _reference == 'glands') &&
                        MediaQuery.sizeOf(context).width >= 600)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                              _reference == 'joints'
                                  ? 'Toggle Skeletal for bone context. Search to focus on a small ligament.'
                                  : 'Search to focus on small glands. Gonads are in the male and female references.',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: NorieColors.textSecondary))),
                    if (_showSystems && !compact)
                      NorieTutorialTarget(
                          id: 'anatomy.systems',
                          child: SizedBox(
                              height: 49 *
                                  MediaQuery.textScalerOf(context).scale(1),
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  children: [
                                    for (final system in AnatomyCatalog.systems)
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(right: 7),
                                          child: FilterChip(
                                              label: Text(system.label),
                                              selected: _systems
                                                  .contains(system.id.name),
                                              onSelected: catalog
                                                      .search(_reference,
                                                          {system.id.name}, '')
                                                      .isEmpty
                                                  ? null
                                                  : (enabled) => setState(() {
                                                        if (!enabled &&
                                                            _systems.length ==
                                                                1) {
                                                          return;
                                                        }
                                                        NorieAudioManager
                                                            .instance
                                                            .playUiSelect();
                                                        _systems = {
                                                          ..._systems
                                                        };
                                                        enabled
                                                            ? _systems.add(
                                                                system.id.name)
                                                            : _systems.remove(
                                                                system.id.name);
                                                        if (_selected != null &&
                                                            _selected!.systems
                                                                .intersection(
                                                                    _systems)
                                                                .isEmpty) {
                                                          _selected = null;
                                                        }
                                                        _opacity = 1;
                                                      }))),
                                  ]))),
                    Expanded(
                        key: const ValueKey('atlas-model-viewport'),
                        child: NorieTutorialTarget(
                            id: 'anatomy.explore',
                            onFocus: _focusTutorialModel,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: AnatomyAtlasModelView(
                                  controller: _controller,
                                  reference: _reference,
                                  systems: _systems,
                                  onLoaded: _tutorialModelLoaded,
                                  onSelected: (id) {
                                    final values = catalog.structures
                                        .where((s) => s.id == id);
                                    if (values.isNotEmpty &&
                                        values.first.reference == _reference &&
                                        values.first.systems
                                            .intersection(_systems)
                                            .isNotEmpty) {
                                      setState(() => _selected = values.first);
                                    }
                                  },
                                )))),
                    NorieTutorialTarget(
                        key: const ValueKey('atlas-camera-toolbar'),
                        id: 'anatomy.camera',
                        onFocus: _focusTutorialModel,
                        child: SizedBox(
                            height:
                                46 * MediaQuery.textScalerOf(context).scale(1),
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                children: [
                                  NorieTutorialTarget(
                                      id: 'anatomy.atlas',
                                      child: TextButton.icon(
                                          onPressed: () => _browse(catalog),
                                          icon: const Icon(Icons.search),
                                          label: Text('Search $count parts'))),
                                  NorieTutorialTarget(
                                      id: 'anatomy.quiz',
                                      child: TextButton.icon(
                                          onPressed: count == 0
                                              ? null
                                              : () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                      builder: (_) =>
                                                          AnatomyAtlasQuizSetupScreen(
                                                              catalog: catalog,
                                                              reference:
                                                                  _reference,
                                                              systems: {
                                                                ..._systems
                                                              }))),
                                          icon: const Icon(Icons.quiz_outlined),
                                          label: const Text('Quiz'))),
                                  if (compact) ...[
                                    IconButton(
                                        tooltip: 'View controls',
                                        onPressed: () =>
                                            _compactControls(catalog),
                                        icon: const Icon(Icons.tune_rounded)),
                                    if (_selected != null)
                                      IconButton(
                                          tooltip: 'Selected details',
                                          onPressed: () => _details(catalog),
                                          icon: const Icon(Icons.info_outline)),
                                  ],
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
                                          NorieAudioManager.instance
                                              .playUiTap();
                                          _controller
                                              .send('camera', {'view': view});
                                        },
                                        child: Text(view[0].toUpperCase() +
                                            view.substring(1))),
                                ]))),
                    if (!compact && _selected != null)
                      Builder(builder: (context) {
                        final selected = _selected!;
                        return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(14, 9, 14, 4),
                            color: NorieColors.surface,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Expanded(
                                        child: Text(selected.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold))),
                                    IconButton(
                                        tooltip: 'Selected details',
                                        onPressed: () => _details(catalog),
                                        icon: const Icon(Icons.info_outline))
                                  ]),
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
                                              _controller.send('isolate',
                                                  {'id': selected.id});
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
                                ]));
                      }),
                    if (!compact)
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
