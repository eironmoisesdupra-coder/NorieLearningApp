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
    expect(html, contains('data-x="'));
    expect(html, contains('data-y="'));
    expect(html, contains('data-z="'));
    expect(html, contains('data-structure-id="skull"'));
    expect(html, contains('aria-label="Skull"'));
    expect(html, contains('hotspot-card'));
    expect(html, contains('Frontal bone'));
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

  test('hotspot JavaScript uses stable pre-calibrated model positions', () {
    final js = Anatomy3DHotspotHtml.javascript(
      selectedHotspotId: 'skeletal-skull',
    );

    expect(js, contains('dataset.x'));
    expect(js, contains('dataset.y'));
    expect(js, contains('dataset.z'));
    expect(js, contains('data-position'));
    expect(js, contains('AnatomyHotspot.postMessage'));
  });

  test('hotspot CSS keeps a large tap target and focus detail fallback', () {
    final css = Anatomy3DHotspotHtml.css;

    expect(css, contains('width:54px'));
    expect(css, contains('height:54px'));
    expect(css, contains(':focus'));
    expect(css, contains('.hotspot-card'));
  });
}
