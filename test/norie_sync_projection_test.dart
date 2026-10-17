import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/sync/norie_economy_store.dart';
import 'norie_economy_store_test.dart'
    show legacy, checkpoint, deviceA, deviceB;

NorieEconomyStore memoryStore(String id) => NorieEconomyStore(
    read: () async => null,
    write: (_) async => true,
    deviceIdFactory: () => id);

void main() {
  test('missing legacy cloud extension is the identity for an active ledger',
      () async {
    final store = memoryStore(deviceA);
    await store.load(legacy());
    store.prepareGuestAdoption(checkpoint());
    final state = store.exportState();
    expect(NorieEconomyStore.merge(state, null), state);
    expect(NorieEconomyStore.merge(null, state), state);
    await store.flush();
  });
  test('phone and laptop independent earnings merge once over one baseline',
      () async {
    final phone = memoryStore(deviceA), laptop = memoryStore(deviceB);
    await phone.load(legacy());
    await laptop.load(legacy());
    phone.reward('assessment:phone', xp: 20, credits: 3);
    laptop.reward('assessment:laptop', xp: 30, credits: 4);
    final merged =
        NorieEconomyStore.merge(phone.exportState(), laptop.exportState());
    final reverse =
        NorieEconomyStore.merge(laptop.exportState(), phone.exportState());
    expect(merged, reverse);
    final restored = memoryStore(deviceA);
    await restored.load(legacy());
    restored.applyValidatedState(NorieEconomyStore.merge(merged, merged));
    expect(restored.totalXp, 150);
    expect(restored.credits, 87);
    await phone.flush();
    await laptop.flush();
    await restored.flush();
  });
  test('duplicate logical rewards across devices do not double project',
      () async {
    final a = memoryStore(deviceA), b = memoryStore(deviceB);
    await a.load(legacy());
    await b.load(legacy());
    a.reward('lesson:shared', xp: 20, credits: 3);
    b.reward('lesson:shared', xp: 20, credits: 3);
    final restored = memoryStore(deviceA);
    await restored.load(legacy());
    restored.applyValidatedState(
        NorieEconomyStore.merge(a.exportState(), b.exportState()));
    expect(restored.totalXp, 120);
    expect(restored.pendingOperations, hasLength(2));
    await a.flush();
    await b.flush();
    await restored.flush();
  });
  test('same operation ID with changed immutable amount is rejected', () async {
    final a = memoryStore(deviceA);
    await a.load(legacy());
    a.reward('lesson:one', xp: 10);
    final bad = a.exportState();
    bad['pending'][0]['xp'] = 99;
    expect(() => NorieEconomyStore.merge(a.exportState(), bad),
        throwsFormatException);
    await a.flush();
  });
  test('different daily scores retain both origins but project one claim',
      () async {
    final a = memoryStore(deviceA), b = memoryStore(deviceB);
    await a.load(legacy());
    await b.load(legacy());
    a.reward('daily:2026-10-17', xp: 20);
    b.reward('daily:2026-10-17', xp: 30);
    final merged = NorieEconomyStore.merge(a.exportState(), b.exportState());
    expect(merged, NorieEconomyStore.merge(b.exportState(), a.exportState()));
    final restored = memoryStore(deviceA);
    await restored.load(legacy());
    restored.applyValidatedState(merged);
    expect(restored.totalXp, 120);
    expect(restored.pendingOperations, hasLength(2));
    await a.flush();
    await b.flush();
    await restored.flush();
  });
  test('latest legacy balance and maximum XP do not add snapshot totals', () {
    Map<String, dynamic> state(int xp, int credits, String at) => {
          'version': 1,
          'baseline': {...legacy(xp: xp, credits: credits), 'modified_at': at},
          'checkpoint': null,
          'pending': []
        };
    final merged = NorieEconomyStore.merge(
        state(300, 60, '2026-10-16T00:00:00Z'),
        state(200, 20, '2026-10-17T00:00:00Z'));
    expect(merged['baseline']['total_xp'], 300);
    expect(merged['baseline']['credits'], 20);
  });
  test(
      'existing account adoption rejects guest spending without erasing reward origins',
      () async {
    final a = memoryStore(deviceA);
    await a.load(legacy());
    a.spend(20, itemId: 'guest-frame');
    a.reward('assessment:guest', xp: 10, credits: 5);
    a.prepareGuestAdoption(checkpoint(xp: 200, credits: 40));
    expect(a.totalXp, 210);
    expect(a.credits, 45);
    expect(a.ownedShopItems, isNot(contains('guest-frame')));
    expect(a.pendingOperations.map((op) => op['device_seq']), [1, 2]);
    await a.flush();
  });
  test(
      'fresh account adoption folds guest purchases and reward tombstones into baseline',
      () async {
    final a = memoryStore(deviceA);
    await a.load(legacy());
    a.spend(20, itemId: 'guest-frame');
    a.reward('lesson:guest', xp: 10, credits: 5);
    a.prepareGuestAdoption(null);
    expect(a.baseline['total_xp'], 110);
    expect(a.baseline['credits'], 65);
    expect(a.pendingOperations, isEmpty);
    expect(a.hasClaim('lesson:guest'), isTrue);
    expect(a.ownedShopItems, contains('guest-frame'));
    await a.flush();
  });
}
