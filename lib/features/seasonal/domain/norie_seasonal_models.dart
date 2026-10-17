enum NorieSeasonStatus { upcoming, active, archived }

class NorieSeasonMission {
  const NorieSeasonMission(
      {required this.id,
      required this.title,
      required this.subject,
      required this.gradeId,
      required this.topicIds});
  final String id, title, subject, gradeId;
  final List<String> topicIds;
}

class NorieSeason {
  const NorieSeason(
      {required this.id,
      required this.title,
      required this.description,
      required this.startsAt,
      required this.endsAt,
      required this.rewardId,
      required this.rewardLabel,
      required this.missions});
  final String id, title, description, rewardId, rewardLabel;

  /// UTC, inclusive start and exclusive end. Archive never hides lessons.
  final DateTime startsAt, endsAt;
  final List<NorieSeasonMission> missions;
  NorieSeasonStatus statusAt(DateTime at) {
    final t = at.toUtc();
    if (t.isBefore(startsAt)) return NorieSeasonStatus.upcoming;
    if (!t.isBefore(endsAt)) return NorieSeasonStatus.archived;
    return NorieSeasonStatus.active;
  }
}
