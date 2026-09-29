import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/commerce/domain/norie_shop_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.resetForNewAccount();
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
    expect(progression.credits, 350);
    expect(progression.ownsShopItem(NorieShopCatalog.cyanFrame.id), isTrue);
    expect(progression.equipShopItem(NorieShopCatalog.cyanFrame), isTrue);
    expect(progression.equippedFrameId, NorieShopCatalog.cyanFrame.id);
  });

  test('non-consumable cannot be purchased twice', () {
    final progression = NorieProgression.instance;
    progression.addCredits(1000);

    expect(progression.purchaseShopItem(NorieShopCatalog.atomBadge), isTrue);
    expect(progression.purchaseShopItem(NorieShopCatalog.atomBadge), isFalse);
    expect(progression.credits, 800);
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
