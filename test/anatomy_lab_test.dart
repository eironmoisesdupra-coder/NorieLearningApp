import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_models.dart';

void main() {
  test('Anatomy Lab covers all core body systems', () {
    final ids = AnatomyCatalog.systems.map((system) => system.id).toSet();

    expect(ids, contains(AnatomySystemId.skeletal));
    expect(ids, contains(AnatomySystemId.articular));
    expect(ids, contains(AnatomySystemId.muscular));
    expect(ids, contains(AnatomySystemId.cardiovascular));
    expect(ids, contains(AnatomySystemId.arterial));
    expect(ids, contains(AnatomySystemId.venous));
    expect(ids, contains(AnatomySystemId.nervous));
    expect(ids, contains(AnatomySystemId.lymphatic));
    expect(ids, contains(AnatomySystemId.respiratory));
    expect(ids, contains(AnatomySystemId.digestive));
    expect(ids, contains(AnatomySystemId.urinary));
    expect(ids, contains(AnatomySystemId.reproductive));
    expect(ids, contains(AnatomySystemId.endocrine));
    expect(ids, contains(AnatomySystemId.integumentary));
    expect(ids, contains(AnatomySystemId.sensory));
  });

  test('each anatomy system has enough structures for quiz distractors', () {
    for (final system in AnatomyCatalog.systems) {
      expect(
        system.structures.length,
        greaterThanOrEqualTo(4),
        reason: system.label,
      );
    }
  });

  test('anatomy structure ids are unique and marker positions are normalized', () {
    final ids = <String>{};

    for (final system in AnatomyCatalog.systems) {
      for (final structure in system.structures) {
        expect(ids.add(structure.id), isTrue, reason: structure.id);
        expect(structure.x, inInclusiveRange(0.0, 1.0));
        expect(structure.y, inInclusiveRange(0.0, 1.0));
        expect(structure.name, isNotEmpty);
        expect(structure.function, isNotEmpty);
        expect(structure.description, isNotEmpty);
      }
    }
  });

  test('multi-layer structure lookup combines selected systems', () {
    final selected = AnatomyCatalog.structuresFor({
      AnatomySystemId.skeletal,
      AnatomySystemId.muscular,
      AnatomySystemId.endocrine,
    });

    expect(selected, hasLength(12));
    expect(
      selected.map((item) => item.system).toSet(),
      {
        AnatomySystemId.skeletal,
        AnatomySystemId.muscular,
        AnatomySystemId.endocrine,
      },
    );
  });
}
