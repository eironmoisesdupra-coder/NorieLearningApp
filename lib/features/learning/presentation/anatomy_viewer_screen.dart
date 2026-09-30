import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../domain/anatomy_hotspot_models.dart';
import '../domain/anatomy_hotspot_viewer_policy.dart';
import '../domain/anatomy_models.dart';
import '../domain/anatomy_render_policy.dart';
import 'anatomy_animated_backdrop.dart';
import 'anatomy_body_model.dart';
import 'anatomy_quiz_screen.dart';
import 'anatomy_real_3d_model.dart';

enum _ViewerGestureMode { rotate, pan }

class AnatomyViewerScreen extends StatefulWidget {
  const AnatomyViewerScreen({
    super.key,
    this.initialSystems = const {
      AnatomySystemId.skeletal,
      AnatomySystemId.muscular,
    },
  });

  final Set<AnatomySystemId> initialSystems;

  @override
  State<AnatomyViewerScreen> createState() => _AnatomyViewerScreenState();
}

class _AnatomyViewerScreenState extends State<AnatomyViewerScreen>
    with SingleTickerProviderStateMixin {
  final TransformationController _transform = TransformationController();
  late final AnimationController _autoRotateController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat();

  late Set<AnatomySystemId> _selectedSystems;
  AnatomyStructure? _selectedStructure;
  _ViewerGestureMode _gestureMode = _ViewerGestureMode.rotate;
  AnatomyHotspotMode _hotspotMode = AnatomyHotspotMode.explore;

  double _rotationY = 0;
  double _rotationX = 0;
  double _rotationSensitivity = 1;
  double _markerSize = 28;
  double _layerOpacity = .88;
  double _minZoom = .75;
  double _maxZoom = 4.2;
  double _realTheta = 0;
  double _realPhi = 75;
  double _realRadius = 4.5;
  double _realTargetX = 0;
  double _realTargetY = 0;

  bool _showLabels = false;
  bool _showMarkers = true;
  bool _particles = true;
  bool _autoRotate = false;

  bool get _useRealSkeleton =>
      AnatomyRenderPolicy.useRealSkeleton(_selectedSystems);

  String get _realCameraOrbit =>
      '${_realTheta.toStringAsFixed(1)}deg '
      '${_realPhi.toStringAsFixed(1)}deg '
      '${_realRadius.toStringAsFixed(2)}m';

  String get _realCameraTarget =>
      '${_realTargetX.toStringAsFixed(2)}m '
      '${_realTargetY.toStringAsFixed(2)}m 0m';

  @override
  void initState() {
    super.initState();
    _selectedSystems = Set<AnatomySystemId>.from(widget.initialSystems);
    _autoRotateController.addListener(_tickAutoRotate);
  }

  @override
  void dispose() {
    _autoRotateController
      ..removeListener(_tickAutoRotate)
      ..dispose();
    _transform.dispose();
    super.dispose();
  }

  void _tickAutoRotate() {
    if (!_autoRotate || !mounted || _useRealSkeleton) return;
    setState(() {
      _rotationY = (_autoRotateController.value * math.pi * 2) - math.pi;
    });
  }

  void _setAutoRotate(bool value) {
    setState(() => _autoRotate = value);
  }

  void _resetView() {
    if (_useRealSkeleton) {
      setState(() {
        _realTheta = 0;
        _realPhi = 75;
        _realRadius = 4.5;
        _realTargetX = 0;
        _realTargetY = 0;
        _selectedStructure = null;
      });
      return;
    }

    _transform.value = Matrix4.identity();
    setState(() {
      _rotationY = 0;
      _rotationX = 0;
      _selectedStructure = null;
    });
  }

  void _presetView(String view) {
    if (_useRealSkeleton) {
      setState(() {
        switch (view) {
          case 'front':
            _realTheta = 0;
            _realPhi = 75;
          case 'back':
            _realTheta = 180;
            _realPhi = 75;
          case 'left':
            _realTheta = -90;
            _realPhi = 75;
          case 'right':
            _realTheta = 90;
            _realPhi = 75;
          case 'top':
            _realTheta = 0;
            _realPhi = 18;
        }
      });
      return;
    }

    setState(() {
      switch (view) {
        case 'front':
          _rotationY = 0;
          _rotationX = 0;
        case 'back':
          _rotationY = math.pi;
          _rotationX = 0;
        case 'left':
          _rotationY = -math.pi / 2;
          _rotationX = 0;
        case 'right':
          _rotationY = math.pi / 2;
          _rotationX = 0;
        case 'top':
          _rotationX = -.72;
          _rotationY = 0;
      }
    });
  }

  void _adjustZoom(double factor) {
    if (_useRealSkeleton) {
      setState(() {
        _realRadius = (_realRadius / factor).clamp(2.0, 8.0);
      });
      return;
    }

    final current = _transform.value.getMaxScaleOnAxis();
    final next = (current * factor).clamp(_minZoom, _maxZoom);
    final ratio = next / current;
    final scale = Matrix4.diagonal3Values(ratio, ratio, 1);
    _transform.value = scale * _transform.value;
  }

  void _panRealSkeleton(DragUpdateDetails details) {
    setState(() {
      _realTargetX =
          (_realTargetX - details.delta.dx * .004).clamp(-1.4, 1.4);
      _realTargetY =
          (_realTargetY + details.delta.dy * .004).clamp(-1.8, 1.8);
    });
  }

  void _toggleSystem(AnatomySystemId id) {
    setState(() {
      if (_selectedSystems.contains(id)) {
        if (_selectedSystems.length > 1) _selectedSystems.remove(id);
      } else {
        _selectedSystems.add(id);
      }
      final selected = _selectedStructure;
      if (selected != null && !_selectedSystems.contains(selected.system)) {
        _selectedStructure = null;
      }
    });
  }

  void _selectRealHotspot(String hotspotId) {
    final structure =
        AnatomyHotspotViewerPolicy.structureForHotspotId(hotspotId);
    if (structure == null) return;

    setState(() {
      _selectedStructure = structure;
      _autoRotate = false;
    });
  }

  Future<void> _openStructureList() async {
    final structures = AnatomyHotspotViewerPolicy.fallbackStructures(
      selectedSystems: _selectedSystems,
      realSkeleton: _useRealSkeleton,
    );

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0C1730),
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          itemCount: structures.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final structure = structures[index];
            return ListTile(
              title: Text(
                structure.name,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: Text(
                structure.function,
                style: const TextStyle(
                  color: NorieColors.textSecondary,
                  fontSize: 10,
                ),
              ),
              onTap: () {
                setState(() => _selectedStructure = structure);
                Navigator.of(sheetContext).pop();
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final structures = AnatomyCatalog.structuresFor(_selectedSystems);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnatomyAnimatedBackdrop(
              particlesEnabled: _particles,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  onBack: () => Navigator.of(context).maybePop(),
                  onSettings: _openSettings,
                  onQuiz: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AnatomyQuizScreen(
                        selectedSystems:
                            Set<AnatomySystemId>.from(_selectedSystems),
                      ),
                    ),
                  ),
                ),
                _SystemLayerStrip(
                  selected: _selectedSystems,
                  onToggle: _toggleSystem,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(child: _buildViewer(structures)),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: _ViewerToolbar(
                          gestureMode: _gestureMode,
                          onRotate: () => setState(
                            () => _gestureMode = _ViewerGestureMode.rotate,
                          ),
                          onPan: () => setState(
                            () => _gestureMode = _ViewerGestureMode.pan,
                          ),
                          onZoomIn: () => _adjustZoom(1.18),
                          onZoomOut: () => _adjustZoom(.84),
                          onReset: _resetView,
                          onFront: () => _presetView('front'),
                          onBack: () => _presetView('back'),
                          onStructures: _openStructureList,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: _OrientationPad(onView: _presetView),
                      ),
                      if (_useRealSkeleton)
                        Positioned(
                          left: 86,
                          right: 86,
                          top: 12,
                          child: Center(
                            child: _HotspotModeSelector(
                              mode: _hotspotMode,
                              onChanged: (mode) => setState(() {
                                _hotspotMode = mode;
                                if (mode == AnatomyHotspotMode.clean) {
                                  _selectedStructure = null;
                                }
                              }),
                            ),
                          ),
                        ),
                      if (_selectedStructure != null)
                        Positioned(
                          left: 10,
                          right: 10,
                          bottom: 10,
                          child: _StructureInfoCard(
                            structure: _selectedStructure!,
                            onClose: () => setState(
                              () => _selectedStructure = null,
                            ),
                          ),
                        )
                      else
                        Positioned(
                          left: 18,
                          right: 18,
                          bottom: 16,
                          child: _ViewerHint(real3D: _useRealSkeleton),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewer(List<AnatomyStructure> structures) {
    if (_useRealSkeleton) {
      return _buildRealSkeletonViewer();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bodyWidth = math.min(constraints.maxWidth * .82, 430.0);
        final bodyHeight = math.min(constraints.maxHeight * .90, 690.0);

        final body = SizedBox(
          width: bodyWidth,
          height: bodyHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: AnatomyBodyModel(
                  selectedSystems: _selectedSystems,
                  opacity: _layerOpacity,
                ),
              ),
              if (_showMarkers)
                for (var i = 0; i < structures.length; i++)
                  _MarkerPoint(
                    number: i + 1,
                    structure: structures[i],
                    bodyWidth: bodyWidth,
                    bodyHeight: bodyHeight,
                    markerSize: _markerSize,
                    showLabel: _showLabels,
                    selected: _selectedStructure?.id == structures[i].id,
                    onTap: () => setState(
                      () => _selectedStructure = structures[i],
                    ),
                  ),
            ],
          ),
        );

        return Center(
          child: InteractiveViewer(
            transformationController: _transform,
            panEnabled: _gestureMode == _ViewerGestureMode.pan,
            scaleEnabled: true,
            minScale: _minZoom,
            maxScale: _maxZoom,
            boundaryMargin: const EdgeInsets.all(250),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: _gestureMode == _ViewerGestureMode.rotate
                  ? (details) {
                      setState(() {
                        _rotationY +=
                            details.delta.dx * .012 * _rotationSensitivity;
                        _rotationX = (_rotationX -
                                details.delta.dy * .006 * _rotationSensitivity)
                            .clamp(-.75, .75);
                      });
                    }
                  : null,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, .0013)
                  ..rotateX(_rotationX)
                  ..rotateY(_rotationY),
                child: body,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRealSkeletonViewer() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnatomyReal3DModel(
                cameraOrbit: _realCameraOrbit,
                cameraTarget: _realCameraTarget,
                autoRotate: _autoRotate,
                enableTouch: _gestureMode == _ViewerGestureMode.rotate,
                hotspots: AnatomyHotspotCatalog.skeletal,
                hotspotMode: _hotspotMode,
                selectedHotspotId: _selectedStructure == null
                    ? null
                    : AnatomyHotspotCatalog
                        .hotspotForStructureId(_selectedStructure!.id)
                        ?.id,
                onHotspotSelected: _selectRealHotspot,
              ),
            ),
            if (_gestureMode == _ViewerGestureMode.pan)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanUpdate: _panRealSkeleton,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSettings() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0C1730),
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void update(VoidCallback action) {
              setState(action);
              setSheetState(() {});
            }

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Anatomy Viewer Settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _SettingSlider(
                      label: 'Rotation sensitivity',
                      value: _rotationSensitivity,
                      min: .45,
                      max: 2,
                      onChanged: (value) => update(
                        () => _rotationSensitivity = value,
                      ),
                    ),
                    _SettingSlider(
                      label: 'Marker size',
                      value: _markerSize,
                      min: 20,
                      max: 42,
                      onChanged: (value) => update(() => _markerSize = value),
                    ),
                    _SettingSlider(
                      label: 'Layer opacity',
                      value: _layerOpacity,
                      min: .25,
                      max: 1,
                      onChanged: (value) => update(() => _layerOpacity = value),
                    ),
                    _SettingSlider(
                      label: 'Minimum zoom',
                      value: _minZoom,
                      min: .5,
                      max: 1,
                      onChanged: (value) => update(() => _minZoom = value),
                    ),
                    _SettingSlider(
                      label: 'Maximum zoom',
                      value: _maxZoom,
                      min: 2,
                      max: 7,
                      onChanged: (value) => update(() => _maxZoom = value),
                    ),
                    _SettingSwitch(
                      label: 'Numbered markers',
                      value: _showMarkers,
                      onChanged: (value) => update(() => _showMarkers = value),
                    ),
                    _SettingSwitch(
                      label: 'Always show marker labels',
                      value: _showLabels,
                      onChanged: (value) => update(() => _showLabels = value),
                    ),
                    _SettingSwitch(
                      label: 'Animated Norie particles',
                      value: _particles,
                      onChanged: (value) => update(() => _particles = value),
                    ),
                    _SettingSwitch(
                      label: 'Auto rotate model',
                      value: _autoRotate,
                      onChanged: (value) {
                        _setAutoRotate(value);
                        setSheetState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _resetView();
                          Navigator.of(sheetContext).pop();
                        },
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: const Text('Reset camera'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onBack,
    required this.onSettings,
    required this.onQuiz,
  });

  final VoidCallback onBack;
  final VoidCallback onSettings;
  final VoidCallback onQuiz;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Norie Anatomy Lab',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                ),
                Text(
                  'Interactive layered viewer',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: onQuiz,
            tooltip: 'Start anatomy quiz',
            icon: const Icon(Icons.quiz_rounded),
          ),
          const SizedBox(width: 5),
          IconButton.filledTonal(
            onPressed: onSettings,
            tooltip: 'Viewer settings',
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
    );
  }
}

class _SystemLayerStrip extends StatelessWidget {
  const _SystemLayerStrip({
    required this.selected,
    required this.onToggle,
  });

  final Set<AnatomySystemId> selected;
  final ValueChanged<AnatomySystemId> onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        scrollDirection: Axis.horizontal,
        itemCount: AnatomyCatalog.systems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final system = AnatomyCatalog.systems[index];
          final active = selected.contains(system.id);
          return FilterChip(
            selected: active,
            onSelected: (_) => onToggle(system.id),
            avatar: Icon(
              system.icon,
              size: 15,
              color: active ? NorieColors.background : system.color,
            ),
            label: Text(system.label),
            selectedColor: system.color,
            backgroundColor: NorieColors.surface.withValues(alpha: .82),
            labelStyle: TextStyle(
              color: active ? NorieColors.background : NorieColors.textPrimary,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          );
        },
      ),
    );
  }
}

class _ViewerToolbar extends StatelessWidget {
  const _ViewerToolbar({
    required this.gestureMode,
    required this.onRotate,
    required this.onPan,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
    required this.onFront,
    required this.onBack,
    required this.onStructures,
  });

  final _ViewerGestureMode gestureMode;
  final VoidCallback onRotate;
  final VoidCallback onPan;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;
  final VoidCallback onFront;
  final VoidCallback onBack;
  final VoidCallback onStructures;

  @override
  Widget build(BuildContext context) {
    Widget action(
      IconData icon,
      String tip,
      VoidCallback onTap, {
      bool selected = false,
    }) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: IconButton(
          onPressed: onTap,
          tooltip: tip,
          style: IconButton.styleFrom(
            backgroundColor: selected
                ? NorieColors.cyan.withValues(alpha: .28)
                : NorieColors.surface.withValues(alpha: .90),
            side: BorderSide(
              color: selected ? NorieColors.cyan : NorieColors.border,
            ),
          ),
          icon: Icon(icon, size: 18),
        ),
      );
    }

    return Column(
      children: [
        action(
          Icons.threed_rotation_rounded,
          'Rotate',
          onRotate,
          selected: gestureMode == _ViewerGestureMode.rotate,
        ),
        action(
          Icons.pan_tool_alt_rounded,
          'Pan',
          onPan,
          selected: gestureMode == _ViewerGestureMode.pan,
        ),
        action(Icons.add_rounded, 'Zoom in', onZoomIn),
        action(Icons.remove_rounded, 'Zoom out', onZoomOut),
        action(Icons.restart_alt_rounded, 'Reset', onReset),
        action(Icons.face_rounded, 'Front', onFront),
        action(Icons.flip_rounded, 'Back', onBack),
        action(Icons.list_alt_rounded, 'Structure list', onStructures),
      ],
    );
  }
}

class _HotspotModeSelector extends StatelessWidget {
  const _HotspotModeSelector({
    required this.mode,
    required this.onChanged,
  });

  final AnatomyHotspotMode mode;
  final ValueChanged<AnatomyHotspotMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AnatomyHotspotMode>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
          value: AnatomyHotspotMode.explore,
          icon: Icon(Icons.label_rounded, size: 14),
          label: Text('Explore'),
        ),
        ButtonSegment(
          value: AnatomyHotspotMode.identification,
          icon: Icon(Icons.pin_rounded, size: 14),
          label: Text('Identify'),
        ),
        ButtonSegment(
          value: AnatomyHotspotMode.clean,
          icon: Icon(Icons.visibility_off_rounded, size: 14),
          label: Text('Clean'),
        ),
      ],
      selected: {mode},
      onSelectionChanged: (selection) {
        if (selection.isNotEmpty) onChanged(selection.first);
      },
      style: const ButtonStyle(
        visualDensity: VisualDensity.compact,
        textStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: 8, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _OrientationPad extends StatelessWidget {
  const _OrientationPad({required this.onView});

  final ValueChanged<String> onView;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: NorieColors.surface.withValues(alpha: .86),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: NorieColors.border),
      ),
      child: Column(
        children: [
          IconButton(
            onPressed: () => onView('top'),
            tooltip: 'Top',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.keyboard_arrow_up_rounded),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => onView('left'),
                tooltip: 'Left',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              const Icon(
                Icons.accessibility_new_rounded,
                size: 18,
                color: NorieColors.cyan,
              ),
              IconButton(
                onPressed: () => onView('right'),
                tooltip: 'Right',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MarkerPoint extends StatelessWidget {
  const _MarkerPoint({
    required this.number,
    required this.structure,
    required this.bodyWidth,
    required this.bodyHeight,
    required this.markerSize,
    required this.showLabel,
    required this.selected,
    required this.onTap,
  });

  final int number;
  final AnatomyStructure structure;
  final double bodyWidth;
  final double bodyHeight;
  final double markerSize;
  final bool showLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final system = AnatomyCatalog.byId(structure.system);
    return Positioned(
      left: bodyWidth * structure.x - markerSize / 2,
      top: bodyHeight * structure.y - markerSize / 2,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? markerSize * 1.18 : markerSize,
              height: selected ? markerSize * 1.18 : markerSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.white : system.color,
                border: Border.all(
                  color: selected ? system.color : Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: system.color.withValues(alpha: .55),
                    blurRadius: selected ? 16 : 8,
                  ),
                ],
              ),
              child: Text(
                '$number',
                style: TextStyle(
                  color: selected ? NorieColors.background : Colors.black87,
                  fontSize: markerSize * .36,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (showLabel) ...[
              const SizedBox(width: 5),
              Container(
                constraints: const BoxConstraints(maxWidth: 125),
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: NorieColors.background.withValues(alpha: .90),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: system.color.withValues(alpha: .45),
                  ),
                ),
                child: Text(
                  structure.name,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StructureInfoCard extends StatelessWidget {
  const _StructureInfoCard({
    required this.structure,
    required this.onClose,
  });

  final AnatomyStructure structure;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final system = AnatomyCatalog.byId(structure.system);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xF20D1934), Color(0xF21A1747)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: system.color.withValues(alpha: .55)),
        boxShadow: [
          BoxShadow(
            color: system.color.withValues(alpha: .12),
            blurRadius: 28,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(system.icon, color: system.color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  structure.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  system.label.toUpperCase(),
                  style: TextStyle(
                    color: system.color,
                    fontSize: 8,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  structure.description,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 10,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Function: ${structure.function}',
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close_rounded, size: 18),
          ),
        ],
      ),
    );
  }
}

class _ViewerHint extends StatelessWidget {
  const _ViewerHint({required this.real3D});

  final bool real3D;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: NorieColors.background.withValues(alpha: .76),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: NorieColors.border),
        ),
        child: Text(
          real3D
              ? 'Real 3D skeleton · drag to orbit · pinch to zoom · Pan mode shifts the camera target'
              : 'Drag to rotate · pinch to zoom · Pan mode moves the model · tap numbered markers to inspect',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: NorieColors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SettingSlider extends StatelessWidget {
  const _SettingSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              value.toStringAsFixed(value >= 10 ? 0 : 2),
              style: const TextStyle(
                color: NorieColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  const _SettingSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
