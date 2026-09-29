enum NorieShopItemType {
  consumable,
  profileFrame,
  badge,
  theme,
}

class NorieShopItem {
  const NorieShopItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.iconName,
    this.consumable = false,
  });

  final String id;
  final String title;
  final String description;
  final int price;
  final NorieShopItemType type;
  final String iconName;
  final bool consumable;
}

abstract final class NorieShopCatalog {
  static const streakShield = NorieShopItem(
    id: 'streak-shield',
    title: 'Streak Shield',
    description: 'Protects one missed study day. One shield is consumed.',
    price: 300,
    type: NorieShopItemType.consumable,
    iconName: 'shield',
    consumable: true,
  );

  static const cyanFrame = NorieShopItem(
    id: 'frame-cyan-orbit',
    title: 'Cyan Orbit Frame',
    description: 'A glowing cyan profile frame.',
    price: 150,
    type: NorieShopItemType.profileFrame,
    iconName: 'frame',
  );

  static const violetFrame = NorieShopItem(
    id: 'frame-violet-scholar',
    title: 'Violet Scholar Frame',
    description: 'A violet profile frame for focused learners.',
    price: 300,
    type: NorieShopItemType.profileFrame,
    iconName: 'frame',
  );

  static const atomBadge = NorieShopItem(
    id: 'badge-atom',
    title: 'Atomic Mind Badge',
    description: 'A collectible science profile badge.',
    price: 200,
    type: NorieShopItemType.badge,
    iconName: 'badge',
  );

  static const streakBadge = NorieShopItem(
    id: 'badge-streak',
    title: 'Streak Keeper Badge',
    description: 'A collectible badge for consistent study.',
    price: 250,
    type: NorieShopItemType.badge,
    iconName: 'badge',
  );

  static const auroraTheme = NorieShopItem(
    id: 'theme-aurora',
    title: 'Aurora Theme',
    description: 'Unlock a cyan-violet cosmetic theme preset.',
    price: 500,
    type: NorieShopItemType.theme,
    iconName: 'theme',
  );

  static const emberTheme = NorieShopItem(
    id: 'theme-ember',
    title: 'Ember Theme',
    description: 'Unlock an orange-magenta cosmetic theme preset.',
    price: 650,
    type: NorieShopItemType.theme,
    iconName: 'theme',
  );

  static const items = <NorieShopItem>[
    streakShield,
    cyanFrame,
    violetFrame,
    atomBadge,
    streakBadge,
    auroraTheme,
    emberTheme,
  ];

  static NorieShopItem? byId(String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }
}

class NorieCreditTransaction {
  const NorieCreditTransaction({
    required this.id,
    required this.amount,
    required this.reason,
    required this.createdAt,
  });

  final String id;
  final int amount;
  final String reason;
  final DateTime createdAt;

  Map<String, Object> toJson() => {
        'id': id,
        'amount': amount,
        'reason': reason,
        'created_at': createdAt.toUtc().toIso8601String(),
      };

  factory NorieCreditTransaction.fromJson(Map<String, dynamic> json) {
    return NorieCreditTransaction(
      id: json['id']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      reason: json['reason']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }
}
