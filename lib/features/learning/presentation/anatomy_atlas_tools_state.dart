import 'package:flutter/foundation.dart';

import '../domain/anatomy_atlas_catalog.dart';
import 'anatomy_atlas_controller.dart';

/// Flutter's view of the renderer controls. Configure is owned by ModelView;
/// this object mirrors its reference/systems and sends interaction commands.
class AnatomyAtlasToolsState extends ChangeNotifier {
  AnatomyAtlasToolsState(this.catalog, this.controller)
      : _entries = {for (final s in catalog.structures) s.id: s};

  final AnatomyAtlasCatalog catalog;
  final AnatomyAtlasController controller;
  final Map<String, AtlasStructure> _entries;
  String _reference = '';
  Set<String> _systems = {};
  final _hidden = <String>{};
  final _visibility = <String, bool>{};
  final _opacity = <String, double>{};
  Set<String>? _loadedIds;
  String? _isolated, _selectedId;
  List<String> _compareIds = [];
  double _globalOpacity = 1;
  String _cameraView = 'reset';

  String get reference => _reference;
  Set<String> get systems => Set.unmodifiable(_systems);
  String? get selectedId => _selectedId;
  String? get isolatedId => _isolated;
  List<String> get compareIds => List.unmodifiable(_compareIds);
  double get globalOpacity => _globalOpacity;
  String get cameraView => _cameraView;
  bool layerVisible(String system) => _visibility[system] ?? true;
  double layerOpacity(String system) => _opacity[system] ?? 1;

  AtlasStructure? structure(String id) => _entries[id];

  Iterable<AtlasStructure> get eligible => catalog.structures.where((s) =>
      s.reference == reference && s.systems.intersection(_systems).isNotEmpty);

  Set<String> get visibleIds => {
        for (final s in eligible)
          if (!_hidden.contains(s.id) &&
              (_isolated == null || _isolated == s.id) &&
              (_loadedIds == null || _loadedIds!.contains(s.id)) &&
              effectiveOpacity(s.id) > 0)
            s.id,
      };

  double effectiveOpacity(String id) {
    final s = structure(id);
    if (s == null || s.reference != reference) return 0;
    var opacity = 0.0;
    for (final system in s.systems.intersection(_systems)) {
      if (layerVisible(system) && layerOpacity(system) > opacity) {
        opacity = layerOpacity(system);
      }
    }
    return opacity * _globalOpacity;
  }

  /// Does not send configure: ModelView manages request IDs and real loads.
  void configure(String reference, Set<String> systems) {
    if (!catalog.references.any((r) => r.id == reference)) return;
    if (_reference == reference && setEquals(_systems, systems)) return;
    _reference = reference;
    _systems = Set.of(systems);
    _loadedIds = null;
    _selectedId = null;
    _resetOverrides();
    notifyListeners();
  }

  /// Optional actual-successful-mesh boundary; stale loads are filtered by the
  /// model request ID before the host calls this method.
  void setLoadedIds(Set<String> ids) {
    _loadedIds = Set.of(ids);
    _reconcile();
    notifyListeners();
  }

  bool setLayer(String system, {bool? visible, double? opacity}) {
    if ((visible == null && opacity == null) ||
        !_systems.contains(system) ||
        !eligible.any((s) => s.systems.contains(system)) ||
        (opacity != null &&
            (!opacity.isFinite || opacity < 0 || opacity > 1))) {
      return false;
    }
    if (visible != null) _visibility[system] = visible;
    if (opacity != null) _opacity[system] = opacity;
    _reconcile();
    controller.send('systemLayer', {
      'system': system,
      if (visible != null) 'visible': visible,
      if (opacity != null) 'opacity': opacity,
    });
    notifyListeners();
    return true;
  }

  bool setGlobalOpacity(double opacity) {
    if (!opacity.isFinite || opacity < .15 || opacity > 1) return false;
    _globalOpacity = opacity;
    controller.send('opacity', {'value': opacity});
    notifyListeners();
    return true;
  }

  bool compare(String first, String second) {
    final visible = visibleIds;
    if (first == second ||
        !visible.contains(first) ||
        !visible.contains(second)) {
      return false;
    }
    _compareIds = [first, second];
    controller.send('compare', {'ids': _compareIds});
    notifyListeners();
    return true;
  }

  void clearCompare() {
    _compareIds = [];
    controller.send('compare', {'ids': <String>[]});
    notifyListeners();
  }

  bool select(String id, {bool sendCommand = true}) {
    if (!eligible.any((s) => s.id == id) ||
        effectiveOpacity(id) <= 0 ||
        (_loadedIds != null && !_loadedIds!.contains(id))) {
      return false;
    }
    if (sendCommand) {
      _hidden.remove(id);
      _isolated = null;
    } else if (!visibleIds.contains(id)) {
      return false;
    }
    _selectedId = id;
    if (sendCommand) controller.send('select', {'id': id});
    notifyListeners();
    return true;
  }

  void clearSelection() {
    _selectedId = null;
    notifyListeners();
  }

  bool hide(String id) {
    if (!eligible.any((s) => s.id == id)) return false;
    _hidden.add(id);
    _reconcile();
    controller.send('hide', {'id': id});
    notifyListeners();
    return true;
  }

  bool isolate(String id) {
    if (!eligible.any((s) => s.id == id) || effectiveOpacity(id) <= 0) {
      return false;
    }
    _hidden.remove(id);
    _isolated = id;
    _selectedId = id;
    _reconcile();
    controller.send('isolate', {'id': id});
    notifyListeners();
    return true;
  }

  void restore() {
    _resetOverrides();
    controller.send('restore');
    notifyListeners();
  }

  bool camera(String view) {
    if (!atlasNamedViews.contains(view)) return false;
    _cameraView = view;
    controller.send('camera', {'view': view});
    notifyListeners();
    return true;
  }

  /// Rehydrates a freshly configured renderer after retry/recreation. The host
  /// calls this only after its current request really loads, never for a context
  /// restoration that retained the scene. Replaying does not edit this mirror.
  void replayToRenderer() {
    if (!catalog.references.any((r) => r.id == reference)) return;
    final entries = eligible.toList();
    final ids = entries.map((s) => s.id).toSet();
    final visible = visibleIds;
    final commands = <({String type, Map<String, dynamic> payload})>[];
    void queue(String type, Map<String, dynamic> payload) =>
        commands.add((type: type, payload: payload));

    final selected = _selectedId;
    if (selected != null && visible.contains(selected)) {
      queue('select', {'id': selected});
    }
    // Isolate must precede layers: the fresh scene can accept a target which a
    // saved layer override will hide. Later hides also preserve hidden isolation.
    final isolated = _isolated;
    if (isolated != null && ids.contains(isolated)) {
      queue('isolate', {'id': isolated});
    }
    for (final system in _systems) {
      if (!entries.any((s) => s.systems.contains(system))) continue;
      if (_visibility.containsKey(system) || _opacity.containsKey(system)) {
        queue('systemLayer', {
          'system': system,
          if (_visibility.containsKey(system)) 'visible': _visibility[system],
          if (_opacity.containsKey(system)) 'opacity': _opacity[system],
        });
      }
    }
    queue('opacity', {'value': _globalOpacity});
    for (final hidden in _hidden.where(ids.contains)) {
      queue('hide', {'id': hidden});
    }
    final comparison = List<String>.of(_compareIds);
    queue('compare', {
      'ids': comparison.length == 2 &&
              comparison[0] != comparison[1] &&
              comparison.every(visible.contains)
          ? comparison
          : <String>[],
    });
    if (atlasNamedViews.contains(_cameraView)) {
      queue('camera', {'view': _cameraView});
    }
    // Capture all payloads before sending: controller listeners may themselves
    // trigger host callbacks, and must not change the snapshot being replayed.
    for (final command in commands) {
      controller.send(command.type, command.payload);
    }
  }

  void _resetOverrides() {
    _hidden.clear();
    _visibility.clear();
    _opacity.clear();
    _isolated = null;
    _compareIds = [];
    _globalOpacity = 1;
  }

  void _reconcile() {
    final visible = visibleIds;
    if (!visible.contains(_selectedId)) _selectedId = null;
    if (!_compareIds.every(visible.contains)) _compareIds = [];
  }
}

const atlasNamedViews = ['front', 'back', 'left', 'right', 'top', 'reset'];
