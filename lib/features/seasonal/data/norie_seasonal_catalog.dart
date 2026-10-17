import '../domain/norie_seasonal_models.dart';

abstract final class NorieSeasonalCatalog {
  static final seasons = List<NorieSeason>.unmodifiable([
    NorieSeason(
        id: 'discovery-season-2026',
        title: 'Discovery 2026: Observe and sort',
        description:
            'An optional Grade 1 journey: distinguish living things, then classify shapes and discover repeating patterns. Complete both lessons, then claim a keepsake during the season. Lessons remain available all year.',
        startsAt: DateTime.utc(2026, 10, 1),
        endsAt: DateTime.utc(2026, 12, 1),
        rewardId: 'season:discovery-2026',
        rewardLabel: 'Discovery 2026 keepsake',
        missions: const [
          NorieSeasonMission(
              id: 'observe-g1',
              title: 'Observe living and nonliving things',
              subject: 'Science',
              gradeId: 'g1',
              topicIds: ['science.g1.living-nonliving-things']),
          NorieSeasonMission(
              id: 'sort-g1',
              title: 'Sort shapes and continue patterns',
              subject: 'Mathematics',
              gradeId: 'g1',
              topicIds: ['mathematics.g1.shapes-patterns']),
        ]),
  ]);
  static String? rewardLabel(String id) {
    for (final s in seasons) {
      if (s.rewardId == id) return s.rewardLabel;
    }
    return null;
  }
}
