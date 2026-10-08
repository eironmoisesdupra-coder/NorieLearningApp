/// Board points are exclusively server verified. Local quiz history is never
/// converted to this model; it is displayed separately as private practice.
class NorieLeagueRow {
  const NorieLeagueRow(
      {required this.memberId,
      required this.nickname,
      required this.points,
      this.isMe = false,
      this.badgeTitle});
  final String memberId;
  final String nickname;
  final int points;
  final bool isMe;
  final String? badgeTitle;
  factory NorieLeagueRow.fromJson(Map<String, dynamic> row) => NorieLeagueRow(
      memberId: row['member_id'] as String,
      nickname: row['nickname'] as String,
      points: (row['points'] as num).toInt(),
      isMe: row['is_me'] == true,
      badgeTitle: row['badge_title'] as String?);
  Map<String, dynamic> toJson() => {
        'member_id': memberId,
        'nickname': nickname,
        'points': points,
        'is_me': isMe,
        'badge_title': badgeTitle,
      };
}

class NorieLeagueTier {
  const NorieLeagueTier(this.title, this.floor, this.nextFloor);
  final String title;
  final int floor;
  final int? nextFloor;
  static NorieLeagueTier forPoints(int points) => switch (points) {
        >= 60 => const NorieLeagueTier('Master', 60, null),
        >= 40 => const NorieLeagueTier('Specialist', 40, 60),
        >= 30 => const NorieLeagueTier('Scholar', 30, 40),
        >= 20 => const NorieLeagueTier('Pathfinder', 20, 30),
        _ => const NorieLeagueTier('Explorer', 0, 20),
      };
}

class NorieLeagueBadge {
  const NorieLeagueBadge(
      {required this.id,
      required this.cohortId,
      required this.seasonId,
      required this.tier,
      required this.title,
      required this.earnedAt});
  final String id, cohortId, seasonId, tier, title;
  final DateTime earnedAt;
  factory NorieLeagueBadge.fromJson(Map<String, dynamic> row) =>
      NorieLeagueBadge(
          id: row['id'] as String,
          cohortId: row['cohort_id'] as String,
          seasonId: row['season_id'] as String,
          tier: row['tier'] as String,
          title: row['title'] as String,
          earnedAt: DateTime.parse(row['earned_at'] as String));
  Map<String, dynamic> toJson() => {
        'id': id,
        'cohort_id': cohortId,
        'season_id': seasonId,
        'tier': tier,
        'title': title,
        'earned_at': earnedAt.toIso8601String()
      };
}

class NorieLeagueBadgeShelf {
  const NorieLeagueBadgeShelf({required this.fetchedAt, required this.badges});
  final DateTime fetchedAt;
  final List<NorieLeagueBadge> badges;
  factory NorieLeagueBadgeShelf.fromJson(Map<String, dynamic> row) =>
      NorieLeagueBadgeShelf(
          fetchedAt: DateTime.parse(row['fetched_at'] as String),
          badges: (row['badges'] as List)
              .map((r) => NorieLeagueBadge.fromJson(
                  Map<String, dynamic>.from(r as Map)))
              .toList());
  Map<String, dynamic> toJson() => {
        'fetched_at': fetchedAt.toIso8601String(),
        'badges': badges.map((r) => r.toJson()).toList()
      };
}

/// Competition ranks: equal points share a rank (1, 1, 3). A stable display
/// order does not break ties or create a speed incentive.
int leagueRank(List<NorieLeagueRow> rows, NorieLeagueRow row) =>
    1 + rows.where((other) => other.points > row.points).length;

List<NorieLeagueRow> nearbyLeagueRows(List<NorieLeagueRow> rows,
    {int radius = 2}) {
  final sorted = [...rows]..sort((a, b) {
      final points = b.points.compareTo(a.points);
      return points == 0 ? a.memberId.compareTo(b.memberId) : points;
    });
  final me = sorted.indexWhere((row) => row.isMe);
  if (me < 0) return sorted.take(5).toList();
  final start = (me - radius).clamp(0, sorted.length);
  final end = (me + radius + 1).clamp(0, sorted.length);
  return sorted.sublist(start, end);
}

class NorieLeagueSnapshot {
  const NorieLeagueSnapshot(
      {required this.cohortId,
      required this.title,
      required this.subject,
      required this.grade,
      required this.seasonEnd,
      required this.fetchedAt,
      required this.rows,
      this.optedIn = false});
  final String cohortId, title, subject, grade;
  final DateTime seasonEnd, fetchedAt;
  final List<NorieLeagueRow> rows;
  final bool optedIn;
  factory NorieLeagueSnapshot.fromJson(Map<String, dynamic> json) =>
      NorieLeagueSnapshot(
          cohortId: json['cohort_id'] as String,
          title: json['title'] as String,
          subject: json['subject'] as String,
          grade: json['grade'] as String,
          seasonEnd: DateTime.parse(json['season_end'] as String),
          fetchedAt: DateTime.parse(json['fetched_at'] as String),
          optedIn: json['opted_in'] == true,
          rows: (json['rows'] as List)
              .map((r) =>
                  NorieLeagueRow.fromJson(Map<String, dynamic>.from(r as Map)))
              .toList());
  Map<String, dynamic> toJson() => {
        'cohort_id': cohortId,
        'title': title,
        'subject': subject,
        'grade': grade,
        'season_end': seasonEnd.toIso8601String(),
        'fetched_at': fetchedAt.toIso8601String(),
        'opted_in': optedIn,
        'rows': rows.map((r) => r.toJson()).toList()
      };
}
