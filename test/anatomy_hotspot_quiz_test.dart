import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_hotspot_models.dart';
import 'package:norie_learning/features/learning/domain/anatomy_hotspot_quiz_policy.dart';

void main() {
  test('skeletal structures resolve to calibrated quiz hotspots', () {
    final hotspot = AnatomyHotspotQuizPolicy.hotspotForStructureId('femur');

    expect(hotspot, isNotNull);
    expect(hotspot!.structureId, 'femur');
  });

  test('unknown structures do not produce quiz hotspots', () {
    expect(
      AnatomyHotspotQuizPolicy.hotspotForStructureId('heart'),
      isNull,
    );
    expect(
      AnatomyHotspotQuizPolicy.hotspotForStructureId('not-a-structure'),
      isNull,
    );
  });

  test('quiz hotspot mode emits one selected marker only', () {
    final hotspot =
        AnatomyHotspotQuizPolicy.hotspotForStructureId('skull')!;

    final markers = AnatomyHotspotQuizPolicy.quizHotspotsFor(hotspot);

    expect(markers, hasLength(1));
    expect(markers.single.id, hotspot.id);
    expect(AnatomyHotspotMode.quiz, isNot(AnatomyHotspotMode.clean));
  });
}
