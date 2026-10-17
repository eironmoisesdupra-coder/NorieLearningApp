import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/profile/data/norie_profile_appearance_store.dart';
import 'package:norie_learning/features/profile/domain/norie_profile_appearance.dart';

void main() {
  test('new rank labels keep legacy cosmetic IDs, thresholds and saved presets',
      () {
    final expected = {
      1: ('explorer', 'Rookie'),
      5: ('curious', 'Novice'),
      15: ('scholar', 'Veteran'),
      30: ('specialist', 'Scholar'),
      50: ('master', 'Master')
    };
    for (final entry in expected.entries) {
      final bundle = NorieAppearanceCatalog.bundleForLevel(entry.key);
      expect(bundle.id, entry.value.$1);
      expect(bundle.title, entry.value.$2);
      final raw = {
        'version': 1,
        'rankLevel': entry.key,
        'appearance': {
          'frame': bundle.id,
          'palette': bundle.id,
          'nameplate': bundle.id
        },
        'presets': [
          {'frame': bundle.id, 'palette': bundle.id, 'nameplate': bundle.id}
        ]
      };
      final normalized = NorieProfileAppearanceStore.validateState(raw);
      expect(normalized['appearance']['frame'], bundle.id);
      expect(normalized['presets'][0]['nameplate'], bundle.id);
      expect(
          NorieAppearanceCatalog.canEquip(
              NorieProfileAppearance.fromJson(normalized['appearance']),
              entry.key, const {}),
          isTrue);
      if (entry.key > 1) {
        expect(
            NorieAppearanceCatalog.canEquip(
                NorieProfileAppearance.fromJson(normalized['appearance']),
                entry.key - 1, const {}),
            isFalse);
      }
    }
  });

  test('rank experience benefits become richer without academic advantages',
      () {
    final explorer = NorieAppearanceCatalog.bundleForLevel(1);
    final master = NorieAppearanceCatalog.bundleForLevel(50);
    expect(explorer.mapTrailStyle, isNotEmpty);
    expect(master.mapTrailStyle, isNot(explorer.mapTrailStyle));
    expect(master.celebrationStyle, isNotEmpty);
    expect(master.nameplateStyle, isNotEmpty);
    expect(master.profileEffect, isNotEmpty);
  });

  test('expanded appearance fields round trip safely', () {
    const value = NorieProfileAppearance(
      backgroundId: 'aurora',
      nameplateId: 'scholar',
      frameEffectId: 'glow',
    );
    final restored = NorieProfileAppearance.fromJson(value.toJson());
    expect(restored.backgroundId, 'aurora');
    expect(restored.nameplateId, 'scholar');
    expect(restored.frameEffectId, 'glow');
  });

  test('rank gating applies to background, nameplate and frame effect', () {
    const locked = NorieProfileAppearance(
      backgroundId: 'constellation',
      nameplateId: 'master',
      frameEffectId: 'prism',
    );
    expect(NorieAppearanceCatalog.canEquip(locked, 1, const {}), isFalse);
    expect(NorieAppearanceCatalog.canEquip(locked, 50, const {}), isTrue);
  });

  test('old appearance snapshots and presets use compatible surface defaults',
      () {
    final normalized = NorieProfileAppearanceStore.validateState({
      'version': 1,
      'rankLevel': 5,
      'appearance': {'avatar': 'comet'},
      'presets': [
        {'palette': 'curious'}
      ],
    });
    for (final raw in [normalized['appearance'], ...normalized['presets']]) {
      final value = NorieProfileAppearance.fromJson(raw);
      expect(value.backgroundId, 'plain');
      expect(value.nameplateId, 'explorer');
      expect(value.frameEffectId, 'none');
    }
    expect(
        NorieProfileAppearanceStore.validateState(
            {'avatar': 'norie'})['appearance']['background'],
        'plain');
  });

  test('unknown surface identifiers and snapshot fields are rejected', () {
    for (final key in ['background', 'nameplate', 'frame_effect']) {
      expect(() => NorieProfileAppearance.fromJson({key: 'unknown'}),
          throwsFormatException);
      expect(() => NorieProfileAppearanceStore.validateState({key: 'unknown'}),
          throwsFormatException);
    }
    expect(() => NorieProfileAppearance.fromJson({'future': 'unknown'}),
        throwsFormatException);
    expect(
        () => NorieProfileAppearanceStore.validateState({
              'appearance': {},
              'presets': [
                {'frame_effect': 'unknown'}
              ],
            }),
        throwsFormatException);
    expect(
        NorieAppearanceCatalog.canEquip(
            const NorieProfileAppearance(backgroundId: 'unknown'),
            100, const {}),
        isFalse);
  });

  test('each new surface respects its precise rank boundary', () {
    for (final entry
        in {'stars': 5, 'aurora': 15, 'constellation': 30}.entries) {
      final value =
          const NorieProfileAppearance().copyWith(backgroundId: entry.key);
      expect(NorieAppearanceCatalog.canEquip(value, entry.value - 1, const {}),
          false);
      expect(
          NorieAppearanceCatalog.canEquip(value, entry.value, const {}), true);
    }
    for (final bundle in NorieAppearanceCatalog.bundles.skip(1)) {
      final value =
          const NorieProfileAppearance().copyWith(nameplateId: bundle.id);
      expect(NorieAppearanceCatalog.canEquip(value, bundle.level - 1, const {}),
          false);
      expect(
          NorieAppearanceCatalog.canEquip(value, bundle.level, const {}), true);
    }
    for (final entry in {'glow': 5, 'orbit': 30, 'prism': 50}.entries) {
      final value =
          const NorieProfileAppearance().copyWith(frameEffectId: entry.key);
      expect(NorieAppearanceCatalog.canEquip(value, entry.value - 1, const {}),
          false);
      expect(
          NorieAppearanceCatalog.canEquip(value, entry.value, const {}), true);
    }
  });

  test(
      'new surfaces persist in active appearance and presets; locked presets fail',
      () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final store = NorieProfileAppearanceStore();
    final restored = NorieProfileAppearanceStore();
    addTearDown(store.dispose);
    addTearDown(restored.dispose);
    await store.load();
    const value = NorieProfileAppearance(
        backgroundId: 'constellation',
        nameplateId: 'master',
        frameEffectId: 'prism');
    final revision = store.revision;
    expect(
        await store.save(store.value,
            expectedRevision: revision, level: 1, presets: [value]),
        false);
    expect(store.revision, revision);
    expect(store.presets, isEmpty);
    expect(
        await store.save(value,
            expectedRevision: revision, level: 50, presets: [value]),
        true);
    await restored.load();
    expect(restored.value.toJson(), value.toJson());
    expect(restored.presets.single.toJson(), value.toJson());
    expect(
        await restored.save(value,
            expectedRevision: restored.revision, level: 1),
        true);
  });
}
