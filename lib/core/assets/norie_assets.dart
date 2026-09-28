abstract final class NorieAssets {
  // Mascot
  static const mascotBase = 'assets/mascot/Norie_001_base.png';
  static const mascotCelebrating =
      'assets/mascot/Norie_002_Congratulations.png';
  static const mascotStudying = 'assets/mascot/Norie_003_studying.png';

  // Achievements
  static const achievementStreak = 'assets/achievements/Flame_badge.png';
  static const achievementLessonMaster = 'assets/achievements/star_badge.png';
  static const achievementSubjectExplorer =
      'assets/achievements/graduation_badge.png';
  static const achievementConsistentLearner =
      'assets/achievements/Diamond_badge.png';

  // Ranks
  static const rankExplorer = 'assets/ranking/Explorer_rank.png';
  static const rankCuriousMind = 'assets/ranking/curiousmind_rank.png';
  static const rankScholar = 'assets/ranking/scholar_rank.png';
  static const rankSpecialist = 'assets/ranking/Specialist_rank.png';
  static const rankMaster = 'assets/ranking/Master_rank.png';

  static String rankForTitle(String title) {
    return switch (title) {
      'Curious Mind' => rankCuriousMind,
      'Scholar' => rankScholar,
      'Specialist' => rankSpecialist,
      'Master' => rankMaster,
      _ => rankExplorer,
    };
  }
}
