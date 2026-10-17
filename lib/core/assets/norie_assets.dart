import 'package:flutter/widgets.dart';

abstract final class NorieAssets {
  // Mascot
  static const mascotBase = 'assets/mascot/Norie_001_base.png';
  static const mascotCelebrating =
      'assets/mascot/Norie_002_Congratulations.png';
  static const mascotStudying = 'assets/mascot/Norie_003_studying.png';

  static Future<void> precacheMascotAssets(BuildContext context) async {
    await Future.wait([
      precacheImage(const AssetImage(mascotBase), context),
      precacheImage(const AssetImage(mascotCelebrating), context),
      precacheImage(const AssetImage(mascotStudying), context),
    ]);
  }

  // Achievements
  static const achievementStreak = 'assets/achievements/Flame_badge.png';
  static const achievementLessonMaster = 'assets/achievements/star_badge.png';
  static const achievementSubjectExplorer =
      'assets/achievements/graduation_badge.png';
  static const achievementConsistentLearner =
      'assets/achievements/Diamond_badge.png';

  // Current visible ranks. Legacy title aliases preserve older callers; saved
  // cosmetic IDs are resolved by level in NorieAppearanceCatalog, never by title.
  static const rankRookie = 'assets/ranking/norie_rookie.png';
  static const rankNovice = 'assets/ranking/norie_novice.png';
  static const rankVeteran = 'assets/ranking/norie_veteran.png';
  static const rankScholar = 'assets/ranking/norie_scholar.png';
  static const rankMaster = 'assets/ranking/norie_master.png';
  static const rankExplorer = rankRookie;
  static const rankCuriousMind = rankNovice;
  static const rankSpecialist = rankScholar;

  static String rankForTitle(String title) => switch (title) {
        'Novice' || 'Curious Mind' => rankNovice,
        'Veteran' => rankVeteran,
        'Scholar' || 'Specialist' => rankScholar,
        'Master' => rankMaster,
        _ => rankRookie,
      };
}
