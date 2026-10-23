import 'package:flutter/foundation.dart';

/// Learner character choices. Independent of Norie and earned profile cosmetics.
@immutable
class NorieExplorerAppearance {
  const NorieExplorerAppearance(
      {this.skin = 'warm',
      this.hair = 'sweep',
      this.outfit = 'field',
      this.accessory = 'satchel'});
  final String skin, hair, outfit, accessory;
  static const skins = {
    'light': 'Light',
    'warm': 'Warm',
    'brown': 'Brown',
    'deep': 'Deep'
  };
  static const hairs = {'sweep': 'Side sweep', 'curls': 'Curls', 'bob': 'Bob'};
  static const outfits = {
    'field': 'Field jacket',
    'sky': 'Sky hoodie',
    'berry': 'Berry overalls'
  };
  static const accessories = {
    'none': 'No accessory',
    'satchel': 'Book satchel',
    'glasses': 'Glasses',
    'star': 'Star pin'
  };
  NorieExplorerAppearance copyWith(
          {String? skin, String? hair, String? outfit, String? accessory}) =>
      NorieExplorerAppearance(
          skin: skin ?? this.skin,
          hair: hair ?? this.hair,
          outfit: outfit ?? this.outfit,
          accessory: accessory ?? this.accessory);
  Map<String, dynamic> toJson() =>
      {'skin': skin, 'hair': hair, 'outfit': outfit, 'accessory': accessory};
  static NorieExplorerAppearance fromJson(Object? raw) {
    if (raw == null) return const NorieExplorerAppearance();
    if (raw is! Map ||
        raw.keys.any((k) =>
            !const {'skin', 'hair', 'outfit', 'accessory'}.contains(k))) {
      throw const FormatException('Invalid Explorer appearance.');
    }
    String read(String key, String fallback, Map<String, String> choices) {
      final value = raw[key] ?? fallback;
      if (value is! String || !choices.containsKey(value)) {
        throw FormatException('Unknown Explorer $key.');
      }
      return value;
    }

    return NorieExplorerAppearance(
        skin: read('skin', 'warm', skins),
        hair: read('hair', 'sweep', hairs),
        outfit: read('outfit', 'field', outfits),
        accessory: read('accessory', 'satchel', accessories));
  }
}
