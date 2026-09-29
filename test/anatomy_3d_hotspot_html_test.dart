import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_hotspot_models.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_3d_hotspot_html.dart';

void main() {
  final sample = AnatomyHotspotCatalog.skeletal.take(2).toList();

  test('explore mode emits native model-viewer hotspot slots', () {
    final html = Anatomy3DHotspotHtml.innerHtml(
      hotspots: sample,
      mode: AnatomyHotspotMode.explore,
    );

    expect(html, contains('slot="hotspot-skeletal-skull"'));
    expect(html, contains('data-nx="0.0"'));
    expect(html, contains('data-structure-id="skull"'));
    expect(html, contains('aria-label="Skull"'));
    expect(html, contains('hotspot-card'));
  });

  test('identification mode keeps names out of visible marker labels', () {
    final html = Anatomy3DHotspotHtml.innerHtml(
      hotspots: sample,
      mode: AnatomyHotspotMode.identification,
    );

    expect(html, contains('>1<'));
    expect(html, isNot(contains('hotspot-label">Skull')));
  });

  test('clean mode emits no hotspot buttons', () {
    final html = Anatomy3DHotspotHtml.innerHtml(
      hotspots: sample,
      mode: AnatomyHotspotMode.clean,
    );

    expect(html.trim(), isEmpty);
  });

  test('hotspot JavaScript converts normalized coordinates to model space', () {
    final js = Anatomy3DHotspotHtml.javascript(
      selectedHotspotId: 'skeletal-skull',
    );

    expect(js, contains('getBoundingBoxCenter()'));
    expect(js, contains('getDimensions()'));
    expect(js, contains('data-position'));
    expect(js, contains('AnatomyHotspot.postMessage'));
  });

  test('hotspot CSS keeps a 44px hit target and focus detail fallback', () {
    final css = Anatomy3DHotspotHtml.css;

    expect(css, contains('width:44px'));
    expect(css, contains('height:44px'));
    expect(css, contains(':focus'));
    expect(css, contains('.hotspot-card'));
  });
}
