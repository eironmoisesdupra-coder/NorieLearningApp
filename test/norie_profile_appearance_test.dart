import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/profile/domain/norie_profile_appearance.dart';
import 'package:norie_learning/features/profile/data/norie_profile_appearance_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late NorieProfileAppearanceStore store;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = NorieProfileAppearanceStore();
    await store.load();
  });
  tearDown(() => store.dispose());
  test('rank ownership denies locked cosmetics without mutating appearance',
      () async {
    final locked = store.value.copyWith(frameId: 'master');
    expect(await store.save(locked, expectedRevision: store.revision, level: 1),
        false);
    expect(store.value.frameId, 'explorer');
    expect(
        await store.save(locked, expectedRevision: store.revision, level: 50),
        true);
    expect(store.value.frameId, 'master');
  });
  test('draft is isolated; save persists and reset retains owned rank access',
      () async {
    final draft = store.value
        .copyWith(avatarId: 'comet', paletteId: 'curious', accentIndex: 1);
    expect(store.value.avatarId, 'norie');
    expect(await store.save(draft, expectedRevision: store.revision, level: 5),
        true);
    final restored = NorieProfileAppearanceStore();
    await restored.load();
    expect(restored.value.avatarId, 'comet');
    await store.reset();
    expect(store.value.avatarId, 'norie');
    expect(store.rankLevel, 5);
    expect(
        await store.save(store.value.copyWith(frameId: 'curious'),
            expectedRevision: store.revision, level: 1),
        true);
    expect(NorieAppearanceCatalog.bundleForLevel(5).showcaseCapacity, 2);
    restored.dispose();
  });
  test('account replacement invalidates stale drafts synchronously', () async {
    final revision = store.revision;
    final replacement =
        store.replaceState(const NorieProfileAppearance().toJson());
    expect(
        await store.save(store.value.copyWith(avatarId: 'leaf'),
            expectedRevision: revision, level: 50),
        false);
    await replacement;
    expect(store.value.avatarId, 'norie');
  });
  test('replacement wins over an in-flight save on disk and in memory',
      () async {
    final save = store.save(store.value.copyWith(avatarId: 'comet'),
        expectedRevision: store.revision, level: 5);
    final replace = store
        .replaceState({'appearance': const NorieProfileAppearance().toJson()});
    expect(await save, false);
    await replace;
    expect(store.value.avatarId, 'norie');
    final restored = NorieProfileAppearanceStore();
    await restored.load();
    expect(restored.value.avatarId, 'norie');
    expect(restored.rankLevel, 1);
    restored.dispose();
  });
  test('unowned showcases, invalid palettes and excess presets are rejected',
      () async {
    expect(
        await store.save(store.value.copyWith(showcase: ['science:g1']),
            expectedRevision: store.revision, level: 1),
        false);
    expect(
        await store.save(store.value.copyWith(accentIndex: 99),
            expectedRevision: store.revision, level: 1),
        false);
    expect(
        await store.save(store.value.copyWith(showcase: ['science:g1']),
            expectedRevision: store.revision,
            level: 1,
            trophyIds: {'science:g1'}),
        true);
  });
  test('malformed import fails before mutation', () async {
    final revision = store.revision;
    expect(() => store.replaceState({'avatar': 5}), throwsFormatException);
    expect(store.revision, revision);
  });
  test('promotion owns bundles permanently even when current XP is lower',
      () async {
    await store.unlockRank(30);
    expect(
        await store.save(store.value.copyWith(frameId: 'specialist'),
            expectedRevision: store.revision, level: 1),
        true);
    await store.unlockRank(5);
    expect(store.rankLevel, 30);
    final restored = NorieProfileAppearanceStore();
    await restored.load();
    expect(restored.rankLevel, 30);
    restored.dispose();
  });
  test('presets honor rank capacity and reject credential fields in imports',
      () async {
    expect(
        await store.save(store.value,
            expectedRevision: store.revision,
            level: 1,
            presets: [store.value, store.value]),
        false);
    expect(
        await store.save(store.value,
            expectedRevision: store.revision,
            level: 5,
            presets: [store.value, store.value]),
        true);
    expect(store.presets.length, 2);
    expect(
        () => NorieProfileAppearanceStore.validateState(
            {...store.exportState(), 'accessToken': 'forbidden'}),
        throwsFormatException);
  });
}
