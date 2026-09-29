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
      final displayLabel = mode == AnatomyHotspotMode.explore
          ? '<span class="hotspot-label">$label</span>'
          : '';
      final ariaLabel =
          mode == AnatomyHotspotMode.quiz ? 'Anatomy marker $number' : label;
      final detailCard = mode == AnatomyHotspotMode.quiz
          ? ''
          : '<span class="hotspot-card"><strong>$label</strong>'
              '<small>$description<br><b>Function:</b> $functionText</small></span>';
      buffer.writeln(
        '<button class="anatomy-hotspot" '
        'slot="hotspot-$id" '
        'data-hotspot-id="$id" '
        'data-structure-id="$structureId" '
        'data-nx="\${hotspot.x}" '
        'data-ny="\${hotspot.y}" '
        'data-nz="\${hotspot.z}" '
        'data-priority="\${hotspot.priority}" '
        'aria-label="$label">'
        '<span class="hotspot-dot">$number</span>'
        '$displayLabel'
        '<span class="hotspot-card"><strong>$label</strong>'
        '<small>Tap to inspect this skeletal structure.</small></span>'
        '</button>',
      );
      number++;
    }
    return buffer.toString();
  }

  static const css = r'''
.anatomy-hotspot{
  width:44px;height:44px;border:0;background:transparent;padding:0;
  display:flex;align-items:center;gap:6px;position:absolute;
  transform:translate(-22px,-22px);overflow:visible;cursor:pointer;
  outline:none;-webkit-tap-highlight-color:transparent;
}
.hotspot-dot{
  width:28px;height:28px;min-width:28px;border-radius:999px;
  display:flex;align-items:center;justify-content:center;
  background:#73f1ff;color:#071227;border:2px solid #fff;
  font:900 11px system-ui,sans-serif;
  box-shadow:0 0 0 2px rgba(7,18,39,.7),0 0 14px rgba(115,241,255,.55);
}
.hotspot-label{
  background:rgba(7,18,39,.92);color:#fff;border:1px solid rgba(115,241,255,.45);
  border-radius:9px;padding:4px 7px;font:800 10px system-ui,sans-serif;
  white-space:nowrap;pointer-events:none;
}
.hotspot-card{
  display:none;position:absolute;left:34px;top:30px;width:180px;
  background:rgba(7,18,39,.96);color:#fff;border:1px solid rgba(115,241,255,.55);
  border-radius:12px;padding:10px;z-index:20;
  box-shadow:0 10px 30px rgba(0,0,0,.35);text-align:left;
}
.hotspot-card strong{display:block;font:900 12px system-ui,sans-serif;margin-bottom:4px}
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

  const calibrate = () => {
    try {
      const center = viewer.getBoundingBoxCenter();
      const dims = viewer.getDimensions();
      viewer.querySelectorAll('.anatomy-hotspot').forEach((el) => {
        const nx = Number(el.dataset.nx || 0);
        const ny = Number(el.dataset.ny || 0);
        const nz = Number(el.dataset.nz || 0);
        const x = center.x + (nx * dims.x);
        const y = center.y + (ny * dims.y);
        const z = center.z + (nz * dims.z);
        el.setAttribute('data-position', x + 'm ' + y + 'm ' + z + 'm');
        el.setAttribute('data-normal', '0 0 1');
        if (el.dataset.hotspotId === selectedId) el.classList.add('selected');
      });
    } catch (_) {}
  };

  const select = (el) => {
    viewer.querySelectorAll('.anatomy-hotspot.selected')
      .forEach((item) => item.classList.remove('selected'));
    el.classList.add('selected');
    const id = el.dataset.hotspotId || '';
    try {
      if (typeof AnatomyHotspot !== 'undefined' && AnatomyHotspot.postMessage) {
        AnatomyHotspot.postMessage(id);
      }
    } catch (_) {}
  };

  viewer.querySelectorAll('.anatomy-hotspot').forEach((el) => {
    el.addEventListener('click', (event) => {
      event.stopPropagation();
      select(el);
    });
  });

  if (viewer.loaded) calibrate();
  viewer.addEventListener('load', calibrate, { once: true });
})();
''';
  }
}
