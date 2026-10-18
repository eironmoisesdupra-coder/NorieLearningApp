import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/sync/norie_economy_store.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/commerce/domain/norie_shop_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    NorieProgression.instance.resetAsyncQueuesForTesting();
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.resetForNewAccount();
  });

  tearDown(() => NorieProgression.instance.flushPendingSaves());

  test('revised account pricing cannot spend before server catalog rollout',
      () async {
    final progression = NorieProgression.instance;
    final store = NorieEconomyStore.instance;
    final now = DateTime.now().toUtc();
    await progression.reconcileEconomyResult({
      'version': 1,
      'checkpoint': {
        'id': 'shop-pricing-checkpoint',
        'epoch': 'shop-pricing-epoch',
        'through_seq': 1,
        'total_xp': 0,
        'credits': 650,
        'owned_shop_items': <String>[],
        'streak_shields': 0,
        'claim_keys': <String>[],
        'device_sequences': <String, int>{},
      },
      'reservation': {
        'id': 'shop-pricing-budget',
        'device_id': store.deviceId,
        'limit': 650,
        'spent': 0,
        'shield_limit': 0,
        'shields_spent': 0,
        'expires_at': now.add(const Duration(days: 1)).toIso8601String(),
      },
      'accepted': <String>[],
      'rejected': <Map<String, dynamic>>[],
      'device_seq': 0,
      'must_recover': false,
    }, stillCurrent: () => true);
    expect(progression.credits, 650);
    expect(progression.purchaseShopItem(NorieShopCatalog.cyanFrame), isFalse);
    expect(progression.credits, 650);
    expect(store.pendingPurchases, isEmpty);
    expect(progression.creditTransactions, isEmpty);
  });

  test('purchase rejects insufficient balance', () {
    final progression = NorieProgression.instance;

    expect(
      progression.purchaseShopItem(NorieShopCatalog.auroraTheme),
      isFalse,
    );
    expect(progression.ownsShopItem(NorieShopCatalog.auroraTheme.id), isFalse);
  });

  test('cosmetic purchase deducts credits and can be equipped', () {
    final progression = NorieProgression.instance;
    progression.addCredits(500);

    expect(
      progression.purchaseShopItem(NorieShopCatalog.cyanFrame),
      isTrue,
    );
    expect(progression.credits, 300);
    expect(progression.ownsShopItem(NorieShopCatalog.cyanFrame.id), isTrue);
    expect(progression.equipShopItem(NorieShopCatalog.cyanFrame), isTrue);
    expect(progression.equippedFrameId, NorieShopCatalog.cyanFrame.id);
  });

  test('non-consumable cannot be purchased twice', () {
    final progression = NorieProgression.instance;
    progression.addCredits(1000);

    expect(progression.purchaseShopItem(NorieShopCatalog.atomBadge), isTrue);
    expect(progression.purchaseShopItem(NorieShopCatalog.atomBadge), isFalse);
    expect(progression.credits, 700);
  });

  test('streak shields stack and are consumed one at a time', () {
    final progression = NorieProgression.instance;
    progression.addCredits(700);

    expect(
      progression.purchaseShopItem(NorieShopCatalog.streakShield),
      isTrue,
    );
    expect(
      progression.purchaseShopItem(NorieShopCatalog.streakShield),
      isTrue,
    );
    expect(progression.streakShields, 2);

    expect(progression.useStreakShield(), isTrue);
    expect(progression.streakShields, 1);
  });

  test('unequip preserves ownership and balance and survives restore',
      () async {
    final progression = NorieProgression.instance;
    progression.addCredits(200);
    expect(progression.purchaseShopItem(NorieShopCatalog.cyanFrame), isTrue);
    expect(progression.credits, 0);
    expect(progression.equipShopItem(NorieShopCatalog.cyanFrame), isTrue);
    expect(progression.unequipShopItem(NorieShopCatalog.cyanFrame), isTrue);
    expect(progression.equippedFrameId, isNull);
    expect(progression.ownsShopItem(NorieShopCatalog.cyanFrame.id), isTrue);
    expect(progression.credits, 0);
    await progression.flushPendingSaves();
    await progression.load();
    expect(progression.equippedFrameId, isNull);
    expect(progression.ownsShopItem(NorieShopCatalog.cyanFrame.id), isTrue);
    expect(progression.unequipShopItem(NorieShopCatalog.cyanFrame), isFalse);
  });

  test('shop state is included in cloud export', () {
    final progression = NorieProgression.instance;
    progression.addCredits(500);
    progression.purchaseShopItem(NorieShopCatalog.cyanFrame);
    progression.equipShopItem(NorieShopCatalog.cyanFrame);

    final cloud = progression.exportCloudState();

    expect(
      cloud['owned_shop_items'],
      contains(NorieShopCatalog.cyanFrame.id),
    );
    expect(cloud['equipped_frame_id'], NorieShopCatalog.cyanFrame.id);
    expect(cloud['credit_transactions'], isA<List>());
  });
}
