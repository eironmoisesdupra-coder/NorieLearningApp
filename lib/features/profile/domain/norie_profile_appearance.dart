import 'package:flutter/material.dart';

/// Cosmetic choices only. No learning history is included in this display value.
@immutable
class NorieProfileAppearance {
  const NorieProfileAppearance(
      {this.avatarId = 'norie',
      this.frameId = 'explorer',
      this.paletteId = 'explorer',
      this.poseId = 'welcome',
      this.accentIndex = 0,
      this.showcase = const []});
  final String avatarId, frameId, paletteId, poseId;
  final int accentIndex;
  final List<String> showcase;
  NorieProfileAppearance copyWith(
          {String? avatarId,
          String? frameId,
          String? paletteId,
          String? poseId,
          int? accentIndex,
          List<String>? showcase}) =>
      NorieProfileAppearance(
          avatarId: avatarId ?? this.avatarId,
          frameId: frameId ?? this.frameId,
          paletteId: paletteId ?? this.paletteId,
          poseId: poseId ?? this.poseId,
          accentIndex: accentIndex ?? this.accentIndex,
          showcase: List.unmodifiable(showcase ?? this.showcase));
  Map<String, dynamic> toJson() => {
        'avatar': avatarId,
        'frame': frameId,
        'palette': paletteId,
        'pose': poseId,
        'accent': accentIndex,
        'showcase': List<String>.of(showcase)
      };
  static NorieProfileAppearance fromJson(Object? raw) {
    if (raw is! Map) {
      throw const FormatException('Appearance must be an object.');
    }
    const fields = {'avatar', 'frame', 'palette', 'pose', 'accent', 'showcase'};
    if (raw.keys.any((key) => key is! String || !fields.contains(key))) {
      throw const FormatException('Unknown appearance fields.');
    }
    String choice(String key, String fallback, Iterable<String> choices) {
      final value = raw[key] ?? fallback;
      if (value is! String || !choices.contains(value)) {
        throw FormatException('Unknown appearance $key.');
      }
      return value;
    }

    final palette =
        choice('palette', 'explorer', NorieAppearanceCatalog.bundleIds);
    final accent = raw['accent'] ?? 0;
    final showcase = raw['showcase'] ?? <String>[];
    if (accent is! int ||
        accent < 0 ||
        accent > 2 ||
        showcase is! List ||
        showcase.length > 5 ||
        showcase.any((e) => e is! String || e.length > 180) ||
        showcase.toSet().length != showcase.length) {
      throw const FormatException('Invalid appearance accent or showcase.');
    }
    return NorieProfileAppearance(
        avatarId:
            choice('avatar', 'norie', NorieAppearanceCatalog.avatars.keys),
        frameId: choice('frame', 'explorer', NorieAppearanceCatalog.bundleIds),
        paletteId: palette,
        poseId: choice('pose', 'welcome', NorieAppearanceCatalog.poses.keys),
        accentIndex: accent,
        showcase: List<String>.unmodifiable(showcase));
  }
}

class NorieRankBundle {
  const NorieRankBundle(this.id, this.title, this.level, this.avatar, this.pose,
      this.colors, this.showcaseCapacity, this.presetCapacity);
  final String id, title, avatar, pose;
  final int level, showcaseCapacity, presetCapacity;
  final List<Color> colors;
}

abstract final class NorieAppearanceCatalog {
  static const bundles = [
    NorieRankBundle('explorer', 'Explorer', 1, 'norie', 'welcome',
        [Color(0xFF65DBEF), Color(0xFF82E8C7), Color(0xFFA6BCFF)], 1, 1),
    NorieRankBundle('curious', 'Curious Mind', 5, 'comet', 'study',
        [Color(0xFFBAA0FF), Color(0xFFFFB2DB), Color(0xFF9CCCFF)], 2, 2),
    NorieRankBundle('scholar', 'Scholar', 15, 'leaf', 'celebrate',
        [Color(0xFF96E7B5), Color(0xFF8AE3DD), Color(0xFFD3E991)], 3, 3),
    NorieRankBundle('specialist', 'Specialist', 30, 'orbit', 'study',
        [Color(0xFFFFCA84), Color(0xFFFFABA8), Color(0xFFF5DC93)], 4, 4),
    NorieRankBundle('master', 'Master', 50, 'prism', 'celebrate',
        [Color(0xFFFFE39E), Color(0xFFD7BEFF), Color(0xFFFFBAD6)], 5, 5),
  ];
  static Iterable<String> get bundleIds => bundles.map((b) => b.id);
  static const avatars = {
    'norie': 'Norie',
    'comet': 'Comet',
    'leaf': 'Leaf',
    'orbit': 'Orbit',
    'prism': 'Prism'
  };
  static const poses = {
    'welcome': 'Welcome',
    'study': 'Study',
    'celebrate': 'Celebrate'
  };
  static NorieRankBundle bundle(String id) =>
      bundles.firstWhere((b) => b.id == id);
  static NorieRankBundle bundleForLevel(int level) =>
      bundles.lastWhere((b) => b.level <= level, orElse: () => bundles.first);
  static int avatarLevel(String id) =>
      bundles.firstWhere((b) => b.avatar == id).level;
  static int poseLevel(String id) => id == 'welcome'
      ? 1
      : id == 'study'
          ? 5
          : 15;
  static Color accent(NorieProfileAppearance value) =>
      bundle(value.paletteId).colors[value.accentIndex.clamp(0, 2)];
  static bool canEquip(
          NorieProfileAppearance value, int level, Set<String> trophies) =>
      avatarLevel(value.avatarId) <= level &&
      bundle(value.frameId).level <= level &&
      bundle(value.paletteId).level <= level &&
      poseLevel(value.poseId) <= level &&
      value.accentIndex >= 0 &&
      value.accentIndex < 3 &&
      value.showcase.length <= bundleForLevel(level).showcaseCapacity &&
      value.showcase.toSet().length == value.showcase.length &&
      value.showcase.every(trophies.contains);
}
