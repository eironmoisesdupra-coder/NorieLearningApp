import 'package:flutter/material.dart';

/// Cosmetic choices only. No learning history is included in this display value.
@immutable
class NorieProfileAppearance {
  const NorieProfileAppearance(
      {this.avatarId = 'norie',
      this.frameId = 'explorer',
      this.paletteId = 'explorer',
      this.poseId = 'welcome',
      this.backgroundId = 'plain',
      this.nameplateId = 'explorer',
      this.frameEffectId = 'none',
      this.accentIndex = 0,
      this.showcase = const []});
  final String avatarId, frameId, paletteId, poseId;
  final String backgroundId, nameplateId, frameEffectId;
  final int accentIndex;
  final List<String> showcase;
  NorieProfileAppearance copyWith(
          {String? avatarId,
          String? frameId,
          String? paletteId,
          String? poseId,
          String? backgroundId,
          String? nameplateId,
          String? frameEffectId,
          int? accentIndex,
          List<String>? showcase}) =>
      NorieProfileAppearance(
          avatarId: avatarId ?? this.avatarId,
          frameId: frameId ?? this.frameId,
          paletteId: paletteId ?? this.paletteId,
          poseId: poseId ?? this.poseId,
          backgroundId: backgroundId ?? this.backgroundId,
          nameplateId: nameplateId ?? this.nameplateId,
          frameEffectId: frameEffectId ?? this.frameEffectId,
          accentIndex: accentIndex ?? this.accentIndex,
          showcase: List.unmodifiable(showcase ?? this.showcase));
  Map<String, dynamic> toJson() => {
        'avatar': avatarId,
        'frame': frameId,
        'palette': paletteId,
        'pose': poseId,
        'background': backgroundId,
        'nameplate': nameplateId,
        'frame_effect': frameEffectId,
        'accent': accentIndex,
        'showcase': List<String>.of(showcase)
      };
  static NorieProfileAppearance fromJson(Object? raw) {
    if (raw is! Map) {
      throw const FormatException('Appearance must be an object.');
    }
    const fields = {
      'avatar',
      'frame',
      'palette',
      'pose',
      'background',
      'nameplate',
      'frame_effect',
      'accent',
      'showcase'
    };
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
        backgroundId: choice(
            'background', 'plain', NorieAppearanceCatalog.backgrounds.keys),
        nameplateId: choice(
            'nameplate', 'explorer', NorieAppearanceCatalog.nameplates.keys),
        frameEffectId: choice(
            'frame_effect', 'none', NorieAppearanceCatalog.frameEffects.keys),
        accentIndex: accent,
        showcase: List<String>.unmodifiable(showcase));
  }
}

class NorieRankBundle {
  const NorieRankBundle(
      this.id,
      this.title,
      this.level,
      this.avatar,
      this.pose,
      this.colors,
      this.showcaseCapacity,
      this.presetCapacity,
      this.mapTrailStyle,
      this.celebrationStyle,
      this.nameplateStyle,
      this.profileEffect);
  final String id, title, avatar, pose;
  final String mapTrailStyle, celebrationStyle, nameplateStyle, profileEffect;
  final int level, showcaseCapacity, presetCapacity;
  final List<Color> colors;
}

abstract final class NorieAppearanceCatalog {
  static const bundles = [
    NorieRankBundle(
        'explorer',
        'Explorer',
        1,
        'norie',
        'welcome',
        [Color(0xFF65DBEF), Color(0xFF82E8C7), Color(0xFFA6BCFF)],
        1,
        1,
        'Classic stepping stones',
        'Simple star burst',
        'Explorer tab',
        'Soft cyan edge'),
    NorieRankBundle(
        'curious',
        'Curious Mind',
        5,
        'comet',
        'study',
        [Color(0xFFBAA0FF), Color(0xFFFFB2DB), Color(0xFF9CCCFF)],
        2,
        2,
        'Comet trail',
        'Curiosity spark',
        'Curious ribbon',
        'Violet shimmer'),
    NorieRankBundle(
        'scholar',
        'Scholar',
        15,
        'leaf',
        'celebrate',
        [Color(0xFF96E7B5), Color(0xFF8AE3DD), Color(0xFFD3E991)],
        3,
        3,
        'Scholar lantern trail',
        'Laurel celebration',
        'Scholar plaque',
        'Emerald glow'),
    NorieRankBundle(
        'specialist',
        'Specialist',
        30,
        'orbit',
        'study',
        [Color(0xFFFFCA84), Color(0xFFFFABA8), Color(0xFFF5DC93)],
        4,
        4,
        'Orbit trail',
        'Orbit ring celebration',
        'Specialist crest',
        'Orbit halo'),
    NorieRankBundle(
        'master',
        'Master',
        50,
        'prism',
        'celebrate',
        [Color(0xFFFFE39E), Color(0xFFD7BEFF), Color(0xFFFFBAD6)],
        5,
        5,
        'Prismatic trail',
        'Prism finale',
        'Master crest',
        'Prismatic profile aura'),
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
  static const backgrounds = {
    'plain': 'Classic navy',
    'stars': 'Star field',
    'aurora': 'Aurora',
    'constellation': 'Constellation'
  };
  static const nameplates = {
    'explorer': 'Explorer tab',
    'curious': 'Curious ribbon',
    'scholar': 'Scholar plaque',
    'specialist': 'Specialist crest',
    'master': 'Master crest'
  };
  static const frameEffects = {
    'none': 'None',
    'glow': 'Glow',
    'orbit': 'Orbit halo',
    'prism': 'Prismatic aura'
  };
  static const _backgroundLevels = {
    'plain': 1,
    'stars': 5,
    'aurora': 15,
    'constellation': 30
  };
  static const _nameplateLevels = {
    'explorer': 1,
    'curious': 5,
    'scholar': 15,
    'specialist': 30,
    'master': 50
  };
  static const _frameEffectLevels = {
    'none': 1,
    'glow': 5,
    'orbit': 30,
    'prism': 50
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
      _backgroundLevels.containsKey(value.backgroundId) &&
      _backgroundLevels[value.backgroundId]! <= level &&
      _nameplateLevels.containsKey(value.nameplateId) &&
      _nameplateLevels[value.nameplateId]! <= level &&
      _frameEffectLevels.containsKey(value.frameEffectId) &&
      _frameEffectLevels[value.frameEffectId]! <= level &&
      value.accentIndex >= 0 &&
      value.accentIndex < 3 &&
      value.showcase.length <= bundleForLevel(level).showcaseCapacity &&
      value.showcase.toSet().length == value.showcase.length &&
      value.showcase.every(trophies.contains);
}
