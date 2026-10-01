import 'dart:convert';

import '../domain/anatomy_hotspot_models.dart';

abstract final class Anatomy3DHotspotHtml {
  static const _escape = HtmlEscape(HtmlEscapeMode.attribute);

  static String innerHtml({
    required Iterable<AnatomyHotspot> hotspots,
    required AnatomyHotspotMode mode,
  }) {
    final visible = AnatomyHotspotCatalog.renderable(hotspots, mode: mode);
    if (visible.isEmpty) return '';

    final buffer = StringBuffer();
    var number = 1;
    for (final hotspot in visible) {
      final id = _escape.convert(hotspot.id);
      final structureId = _escape.convert(hotspot.structureId);
      final label = _escape.convert(hotspot.label);
      final structure =
          AnatomyHotspotCatalog.resolveStructure(hotspot.structureId);
      final description =
          _escape.convert(structure?.description ?? 'Skeletal structure');
      final functionText =
          _escape.convert(structure?.function ?? 'See the anatomy lesson.');
      final sourceNode = _escape.convert(
        AnatomyHotspotCatalog.displaySourceNode(hotspot.sourceNode),
      );
      final modelX =
          AnatomyHotspotCatalog.modelX(hotspot).toStringAsFixed(6);
      final modelY =
          AnatomyHotspotCatalog.modelY(hotspot).toStringAsFixed(6);
      final modelZ =
          AnatomyHotspotCatalog.modelZ(hotspot).toStringAsFixed(6);
      final ariaLabel =
          mode == AnatomyHotspotMode.quiz ? 'Anatomy marker $number' : label;
      final detailCard = mode == AnatomyHotspotMode.quiz
          ? ''
          : '<span class="hotspot-card"><strong>$label</strong>'
              '<em>$sourceNode</em>'
              '<small>$description<br><b>Function:</b> $functionText</small></span>';
      buffer.writeln(
        '<button class="anatomy-hotspot" '
        'slot="hotspot-$id" '
        'data-hotspot-id="$id" '
        'data-structure-id="$structureId" '
        'data-x="$modelX" '
        'data-y="$modelY" '
        'data-z="$modelZ" '
        'data-priority="${hotspot.priority}" '
        'aria-label="$ariaLabel">'
        '<span class="hotspot-dot">$number</span>'
        '$detailCard'
        '</button>',
      );
      number++;
    }
    return buffer.toString();
  }

  static const css = r'''
.anatomy-hotspot{
  width:54px;height:54px;border:0;background:transparent;padding:0;
  display:flex;align-items:center;gap:6px;position:absolute;
  transform:translate(-27px,-27px);overflow:visible;cursor:pointer;
  outline:none;-webkit-tap-highlight-color:transparent;
}
.hotspot-dot{
  width:30px;height:30px;min-width:30px;border-radius:999px;
  display:flex;align-items:center;justify-content:center;
  background:#73f1ff;color:#071227;border:2px solid #fff;
  font:900 11px system-ui,sans-serif;
  box-shadow:0 0 0 2px rgba(7,18,39,.7),0 0 14px rgba(115,241,255,.55);
}
.hotspot-card{
  display:none;position:absolute;left:34px;top:30px;width:180px;
  background:rgba(7,18,39,.96);color:#fff;border:1px solid rgba(115,241,255,.55);
  border-radius:12px;padding:10px;z-index:20;
  box-shadow:0 10px 30px rgba(0,0,0,.35);text-align:left;
}
.hotspot-card strong{display:block;font:900 12px system-ui,sans-serif;margin-bottom:2px}
.hotspot-card em{display:block;color:#73f1ff;font:700 9px system-ui,sans-serif;font-style:normal;margin-bottom:5px}
.hotspot-card small{display:block;color:#b8c6dc;font:500 9px/1.35 system-ui,sans-serif}
.anatomy-hotspot:focus .hotspot-card,
.anatomy-hotspot.selected .hotspot-card{display:block}
.anatomy-hotspot.selected .hotspot-dot{background:#fff;color:#071227;transform:scale(1.14)}
''';

  static String javascript({String? selectedHotspotId}) {
    final selected = jsonEncode(selectedHotspotId ?? '');
    return '''
(() => {
  const viewer = document.querySelector('model-viewer');
  if (!viewer) return;
  const selectedId = $selected;

  const positionHotspots = () => {
    viewer.querySelectorAll('.anatomy-hotspot').forEach((el) => {
      const x = Number(el.dataset.x || 0);
      const y = Number(el.dataset.y || 0);
      const z = Number(el.dataset.z || 0);
      el.setAttribute(
        'data-position',
        x.toFixed(6) + 'm ' + y.toFixed(6) + 'm ' + z.toFixed(6) + 'm'
      );
      el.setAttribute('data-normal', '0 0 1');
      if (el.dataset.hotspotId === selectedId) {
        el.classList.add('selected');
      }
    });
  };

  const select = (el) => {
    viewer.querySelectorAll('.anatomy-hotspot.selected')
      .forEach((item) => item.classList.remove('selected'));
    el.classList.add('selected');
    el.focus({ preventScroll: true });

    const id = el.dataset.hotspotId || '';
    try {
      if (typeof AnatomyHotspot !== 'undefined' && AnatomyHotspot.postMessage) {
        AnatomyHotspot.postMessage(id);
      }
    } catch (_) {}
  };

  viewer.querySelectorAll('.anatomy-hotspot').forEach((el) => {
    el.addEventListener('click', (event) => {
      event.preventDefault();
      event.stopPropagation();
      select(el);
    });
  });

  positionHotspots();
  viewer.addEventListener('load', positionHotspots, { once: true });
})();
''';
  }
}
