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

  // Historical PNG constants remain available to old callers. The visible
  // badge is drawn in Flutter; resolve legacy art by level, never a saved title.
  static const rankRookie = 'assets/ranking/norie_rookie.png';
  static const rankNovice = 'assets/ranking/norie_novice.png';
  static const rankVeteran = 'assets/ranking/norie_veteran.png';
  static const rankScholar = 'assets/ranking/norie_scholar.png';
  static const rankMaster = 'assets/ranking/norie_master.png';
  // This constant predates the visible Explorer rank at level 5. Preserve it
  // for callers of the former level-1 Explorer alias; use rankForLevel now.
  static const rankExplorer = rankRookie;
  static const rankCuriousMind = rankNovice;
  static const rankSpecialist = rankScholar;
  static const rankExpert = rankScholar;
  static const rankProfessor = rankMaster;

  static String rankForLevel(int level) {
    if (level >= 50) return rankMaster;
    if (level >= 30) return rankScholar;
    if (level >= 15) return rankVeteran;
    if (level >= 5) return rankNovice;
    return rankRookie;
  }

  // Scholar now means level 15. Historical level-30 Scholar art remains
  // accessible through rankScholar, rankForLevel(30), or Specialist.
  static String rankForTitle(String title) => switch (title) {
        'Explorer' || 'Novice' || 'Curious Mind' => rankNovice,
        'Scholar' || 'Veteran' => rankVeteran,
        'Expert' || 'Specialist' => rankScholar,
        'Professor' || 'Master' => rankMaster,
        _ => rankRookie,
      };
}
