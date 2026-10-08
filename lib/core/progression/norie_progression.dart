import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/commerce/domain/norie_shop_models.dart';
import 'norie_lesson_journey.dart';
import 'norie_progress_backup.dart';
import 'norie_adventure_progress.dart';
import '../../features/profile/data/norie_profile_appearance_store.dart';
import '../../features/profile/domain/norie_profile_appearance.dart';
import '../../features/content/data/norie_foundation_curriculum.dart';

class NorieLevelSnapshot {
  const NorieLevelSnapshot({
    required this.totalXp,
    required this.level,
    required this.title,
    required this.xpIntoLevel,
    required this.xpRequiredForNextLevel,
    required this.progress,
    required this.nextRankTitle,
    required this.nextRankLevel,
    required this.isMaxLevel,
  });

  final int totalXp;
  final int level;
  final String title;
  final int xpIntoLevel;
  final int xpRequiredForNextLevel;
  final double progress;
  final String? nextRankTitle;
  final int? nextRankLevel;
  final bool isMaxLevel;
}

class NorieXpAward {
  const NorieXpAward({
    required this.amount,
    required this.before,
    required this.after,
  });

  final int amount;
  final NorieLevelSnapshot before;
  final NorieLevelSnapshot after;

  bool get leveledUp => after.level > before.level;
  bool get rankChanged => after.title != before.title;
  int get levelsGained => after.level - before.level;
}

enum NorieAchievementId {
  sevenDayStreak,
  lessonMaster,
  subjectExplorer,
  consistentLearner,
}

class NorieAchievement {
  const NorieAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.unlocked,
    required this.progress,
    required this.progressLabel,
  });

  final NorieAchievementId id;
  final String title;
  final String description;
  final bool unlocked;
  final double progress;
  final String progressLabel;
}

enum NorieChallengeMode { daily, speed }

class NorieChallengeCompletion {
  const NorieChallengeCompletion({
    required this.mode,
    required this.correct,
    required this.total,
    required this.baseXp,
    required this.bonusXp,
    required this.dailyRewardAwarded,
    required this.weeklyRewardAwarded,
    required this.bestScoreImproved,
    required this.creditsAwarded,
    required this.before,
    required this.after,
  });

  final NorieChallengeMode mode;
  final int correct;
  final int total;
  final int baseXp;
  final int bonusXp;
  final bool dailyRewardAwarded;
  final bool weeklyRewardAwarded;
  final bool bestScoreImproved;
  final int creditsAwarded;
  final NorieLevelSnapshot before;
  final NorieLevelSnapshot after;

  int get totalXpAwarded => baseXp + bonusXp;
  bool get leveledUp => after.level > before.level;
  bool get rankChanged => after.title != before.title;
}

enum NorieMasteryLevel {
  learning,
  practicing,
  proficient,
  mastered,
}

class NorieTopicMastery {
  const NorieTopicMastery({
    required this.category,
    required this.topic,
    required this.correct,
    required this.attempts,
  });

  final String category;
  final String topic;
  final int correct;
  final int attempts;

  double get accuracy => attempts == 0 ? 0 : correct / attempts;

  double get confidence => (attempts / 5).clamp(0.0, 1.0).toDouble();

  double get score => (accuracy * confidence).clamp(0.0, 1.0).toDouble();

  NorieMasteryLevel get level {
    if (score < .40) return NorieMasteryLevel.learning;
    if (score < .65) return NorieMasteryLevel.practicing;
    if (score < .85) return NorieMasteryLevel.proficient;
    return NorieMasteryLevel.mastered;
  }

  String get levelLabel => switch (level) {
        NorieMasteryLevel.learning => 'Learning',
        NorieMasteryLevel.practicing => 'Practicing',
        NorieMasteryLevel.proficient => 'Proficient',
        NorieMasteryLevel.mastered => 'Mastered',
      };

  bool get isWeak => attempts >= 2 && accuracy < .70;

  NorieTopicMastery add({
    required int correctAnswers,
    required int totalAttempts,
  }) {
    return NorieTopicMastery(
      category: category,
      topic: topic,
      correct: correct + correctAnswers,
      attempts: attempts + totalAttempts,
    );
  }

  Map<String, Object> toJson() => {
        'category': category,
        'topic': topic,
        'correct': correct,
        'attempts': attempts,
      };

  static NorieTopicMastery fromJson(Map<String, dynamic> json) {
    return NorieTopicMastery(
      category: json['category'] as String? ?? 'General',
      topic: json['topic'] as String? ?? 'Unknown Topic',
      correct: json['correct'] as int? ?? 0,
      attempts: json['attempts'] as int? ?? 0,
    );
  }
}

abstract final class NorieLevelSystem {
  static const int maxLevel = 50;
  static const int baseXpRequirement = 100;
  static const int xpIncreasePerLevel = 25;

  static String titleForLevel(int level) {
    if (level >= 50) return 'Master';
    if (level >= 30) return 'Specialist';
    if (level >= 15) return 'Scholar';
    if (level >= 5) return 'Curious Mind';
    return 'Explorer';
  }

  static int xpRequiredToAdvanceFrom(int level) {
    if (level >= maxLevel) return 0;
    final safeLevel = level.clamp(1, maxLevel);
    return baseXpRequirement + ((safeLevel - 1) * xpIncreasePerLevel);
  }

  static int totalXpRequiredForLevel(int level) {
    final targetLevel = level.clamp(1, maxLevel);
    if (targetLevel <= 1) return 0;

    final transitions = targetLevel - 1;
    return (transitions *
            ((2 * baseXpRequirement) +
                ((transitions - 1) * xpIncreasePerLevel))) ~/
        2;
  }

  static NorieLevelSnapshot snapshotForXp(int totalXp) {
    final safeXp = totalXp < 0 ? 0 : totalXp;
    var level = 1;
    var remaining = safeXp;

    while (level < maxLevel) {
      final requirement = xpRequiredToAdvanceFrom(level);
      if (remaining < requirement) break;
      remaining -= requirement;
      level++;
    }

    final isMaxLevel = level >= maxLevel;
    final requirement = isMaxLevel ? 0 : xpRequiredToAdvanceFrom(level);
    final progress =
        isMaxLevel ? 1.0 : (remaining / requirement).clamp(0.0, 1.0).toDouble();

    final nextRank = _nextRankAfter(level);

    return NorieLevelSnapshot(
      totalXp: safeXp,
      level: level,
      title: titleForLevel(level),
      xpIntoLevel: isMaxLevel ? 0 : remaining,
      xpRequiredForNextLevel: requirement,
      progress: progress,
      nextRankTitle: nextRank?.$1,
      nextRankLevel: nextRank?.$2,
      isMaxLevel: isMaxLevel,
    );
  }

  static (String, int)? _nextRankAfter(int level) {
    if (level < 5) return ('Curious Mind', 5);
    if (level < 15) return ('Scholar', 15);
    if (level < 30) return ('Specialist', 30);
    if (level < 50) return ('Master', 50);
    return null;
  }
}

abstract final class NorieEconomyRules {
  static const int lessonCompletionCredits = 10;
  static const int perfectLessonCredits = 20;
  static const int dailyChallengeCredits = 25;
  static const int weeklyGoalCredits = 100;
}

class NorieLessonCompletion {
  const NorieLessonCompletion({
    required this.creditsAwarded,
    required this.lessonRewardAwarded,
    required this.perfectRewardAwarded,
  });

  final int creditsAwarded;
  final bool lessonRewardAwarded;
  final bool perfectRewardAwarded;
}

abstract final class NorieChallengeRules {
  static const int dailyQuestionCount = 5;
  static const int speedQuestionCount = 10;
  static const int speedDurationSeconds = 60;
  static const int weeklyGoalDays = 5;
  static const int dailyCompletionBonus = 100;
  static const int weeklyGoalBonus = 250;
  static const int speedPerfectBonus = 50;

  static int baseXp({
    required NorieChallengeMode mode,
    required int correct,
  }) {
    final safeCorrect = correct < 0 ? 0 : correct;
    return switch (mode) {
      NorieChallengeMode.daily => safeCorrect * 12,
      NorieChallengeMode.speed => safeCorrect * 10,
    };
  }
}

class NorieProgression extends ChangeNotifier {
  NorieProgression._();

  static final NorieProgression instance = NorieProgression._();

  static const _xpKey = 'norie.totalXp';
  static const _creditsKey = 'norie.credits';
  static const _lessonsKey = 'norie.completedLessons';
  static const _sessionsKey = 'norie.studySessions';
  static const _correctKey = 'norie.correctAnswers';
  static const _questionsKey = 'norie.questionsAnswered';
  static const _subjectsKey = 'norie.exploredSubjects';
  static const _studyDatesKey = 'norie.studyDates';
  static const _onboardingKey = 'norie.onboardingComplete';
  static const _challengeSessionsKey = 'norie.challengeSessions';
  static const _dailyChallengeDatesKey = 'norie.dailyChallengeDates';
  static const _speedRewardDatesKey = 'norie.speedRewardDates';
  static const _speedBestScoreKey = 'norie.speedBestScore';
  static const _weeklyRewardedWeeksKey = 'norie.weeklyRewardedWeeks';
  static const _topicMasteryKey = 'norie.topicMastery';
  static const _completedTopicIdsKey = 'norie.completedTopicIds';
  static const _rewardedLessonTopicsKey = 'norie.rewardedLessonTopics';
  static const _rewardedPerfectLessonTopicsKey =
      'norie.rewardedPerfectLessonTopics';
  static const _lastModifiedKey = 'norie.lastModifiedAt';
  static const _ownedShopItemsKey = 'norie.ownedShopItems';
  static const _equippedFrameKey = 'norie.equippedFrame';
  static const _equippedBadgeKey = 'norie.equippedBadge';
  static const _equippedThemeKey = 'norie.equippedTheme';
  static const _streakShieldsKey = 'norie.streakShields';
  static const _creditTransactionsKey = 'norie.creditTransactions';
  static const _assessmentAttemptsKey = 'norie.rewardedAssessmentAttempts';
  Set<String> _rewardedAssessmentAttempts = {};

  int _totalXp = 0;
  int _credits = 0;
  int _completedLessons = 0;
  int _studySessions = 0;
  int _correctAnswers = 0;
  int _questionsAnswered = 0;
  int _challengeSessions = 0;
  int _speedBestScore = 0;
  int _streakShields = 0;
  Set<String> _ownedShopItems = <String>{};
  String? _equippedFrameId;
  String? _equippedBadgeId;
  String? _equippedThemeId;
  List<NorieCreditTransaction> _creditTransactions = <NorieCreditTransaction>[];
  Set<String> _exploredSubjects = <String>{};
  Set<String> _studyDates = <String>{};
  Set<String> _dailyChallengeDates = <String>{};
  Set<String> _speedRewardDates = <String>{};
  Set<String> _weeklyRewardedWeeks = <String>{};
  Set<String> _completedTopicIds = <String>{};
  Set<String> _rewardedLessonTopics = <String>{};
  Set<String> _rewardedPerfectLessonTopics = <String>{};
  Map<String, NorieTopicMastery> _topicMastery = <String, NorieTopicMastery>{};
  DateTime _lastModifiedAt =
      DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  bool _onboardingComplete = false;

  int get totalXp => _totalXp;
  int get credits => _credits;
  int get streakShields => _streakShields;
  Set<String> get ownedShopItems => Set.unmodifiable(_ownedShopItems);
  String? get equippedFrameId => _equippedFrameId;
  String? get equippedBadgeId => _equippedBadgeId;
  String? get equippedThemeId => _equippedThemeId;
  List<NorieCreditTransaction> get creditTransactions =>
      List.unmodifiable(_creditTransactions);

  bool ownsShopItem(String id) => _ownedShopItems.contains(id);
  int get completedLessons => _completedLessons;
  int get studySessions => _studySessions;
  int get correctAnswers => _correctAnswers;
  int get questionsAnswered => _questionsAnswered;
  int get challengeSessions => _challengeSessions;
  int get speedBestScore => _speedBestScore;
  Set<String> get exploredSubjects => Set.unmodifiable(_exploredSubjects);
  Set<String> get completedTopicIds => Set.unmodifiable(_completedTopicIds);
  bool isTopicCompleted(String topicId) => _completedTopicIds.contains(topicId);
  bool get onboardingComplete => _onboardingComplete;
  DateTime get lastModifiedAt => _lastModifiedAt;

  List<NorieTopicMastery> get topicMastery {
    final items = _topicMastery.values.toList()
      ..sort((a, b) {
        final categoryCompare = a.category.compareTo(b.category);
        if (categoryCompare != 0) return categoryCompare;
        return a.topic.compareTo(b.topic);
      });
    return List.unmodifiable(items);
  }

  List<NorieTopicMastery> get weakTopics {
    final items = _topicMastery.values.where((topic) => topic.isWeak).toList()
      ..sort((a, b) => a.score.compareTo(b.score));
    return List.unmodifiable(items);
  }

  int get masteredTopicCount => _topicMastery.values
      .where((topic) => topic.level == NorieMasteryLevel.mastered)
      .length;

  NorieTopicMastery? masteryFor({
    required String category,
    required String topic,
  }) =>
      _topicMastery[_topicKey(category, topic)];

  NorieLevelSnapshot get snapshot => NorieLevelSystem.snapshotForXp(_totalXp);

  double get quizAccuracy {
    if (_questionsAnswered == 0) return 0;
    return _correctAnswers / _questionsAnswered;
  }

  int get currentStreak {
    if (_studyDates.isEmpty) return 0;

    final dates = _studyDates
        .map(DateTime.parse)
        .map((date) => DateTime(date.year, date.month, date.day))
        .toSet();
    var cursor = _dateOnly(DateTime.now());

    if (!dates.contains(cursor)) {
      final yesterday = cursor.subtract(const Duration(days: 1));
      if (!dates.contains(yesterday)) return 0;
      cursor = yesterday;
    }

    var streak = 0;
    while (dates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  bool get dailyChallengeCompletedToday =>
      _dailyChallengeDates.contains(_dateKey(DateTime.now()));

  bool get speedRewardEarnedToday =>
      _speedRewardDates.contains(_dateKey(DateTime.now()));

  int get weeklyChallengeDays => _weeklyChallengeDaysAt(DateTime.now());

  double get weeklyChallengeProgress =>
      (weeklyChallengeDays / NorieChallengeRules.weeklyGoalDays)
          .clamp(0.0, 1.0)
          .toDouble();

  bool get weeklyGoalComplete =>
      weeklyChallengeDays >= NorieChallengeRules.weeklyGoalDays;

  bool get weeklyRewardClaimed =>
      _weeklyRewardedWeeks.contains(_weekKey(DateTime.now()));

  List<NorieAchievement> get achievements => [
        NorieAchievement(
          id: NorieAchievementId.sevenDayStreak,
          title: '7-Day Streak',
          description: 'Study on seven consecutive days.',
          unlocked: currentStreak >= 7,
          progress: (currentStreak / 7).clamp(0.0, 1.0).toDouble(),
          progressLabel: '${currentStreak.clamp(0, 7)} / 7 days',
        ),
        NorieAchievement(
          id: NorieAchievementId.lessonMaster,
          title: 'Lesson Master',
          description: 'Complete your first full lesson, quiz, and challenge.',
          unlocked: _completedLessons >= 1,
          progress: (_completedLessons / 1).clamp(0.0, 1.0).toDouble(),
          progressLabel: '${_completedLessons.clamp(0, 1)} / 1 lesson',
        ),
        NorieAchievement(
          id: NorieAchievementId.subjectExplorer,
          title: 'Subject Explorer',
          description: 'Explore two different subject areas.',
          unlocked: _exploredSubjects.length >= 2,
          progress: (_exploredSubjects.length / 2).clamp(0.0, 1.0).toDouble(),
          progressLabel: '${_exploredSubjects.length.clamp(0, 2)} / 2 subjects',
        ),
        NorieAchievement(
          id: NorieAchievementId.consistentLearner,
          title: 'Consistent Learner',
          description: 'Complete five focused learning sessions.',
          unlocked: _studySessions >= 5,
          progress: (_studySessions / 5).clamp(0.0, 1.0).toDouble(),
          progressLabel: '${_studySessions.clamp(0, 5)} / 5 sessions',
        ),
      ];

  int get unlockedAchievementCount =>
      achievements.where((achievement) => achievement.unlocked).length;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _rewardedAssessmentAttempts =
        (prefs.getStringList(_assessmentAttemptsKey) ?? const <String>[])
            .toSet();
    _totalXp = prefs.getInt(_xpKey) ?? _totalXp;
    _credits = prefs.getInt(_creditsKey) ?? _credits;
    _completedLessons = prefs.getInt(_lessonsKey) ?? 0;
    _studySessions = prefs.getInt(_sessionsKey) ?? 0;
    _correctAnswers = prefs.getInt(_correctKey) ?? 0;
    _questionsAnswered = prefs.getInt(_questionsKey) ?? 0;
    _challengeSessions = prefs.getInt(_challengeSessionsKey) ?? 0;
    _speedBestScore = prefs.getInt(_speedBestScoreKey) ?? 0;
    _streakShields = prefs.getInt(_streakShieldsKey) ?? 0;
    _ownedShopItems =
        (prefs.getStringList(_ownedShopItemsKey) ?? const <String>[]).toSet();
    _equippedFrameId = prefs.getString(_equippedFrameKey);
    _equippedBadgeId = prefs.getString(_equippedBadgeKey);
    _equippedThemeId = prefs.getString(_equippedThemeKey);
    final rawTransactions = prefs.getString(_creditTransactionsKey);
    if (rawTransactions != null && rawTransactions.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawTransactions) as List<dynamic>;
        _creditTransactions = decoded
            .whereType<Map>()
            .map((item) => NorieCreditTransaction.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList();
      } on FormatException {
        _creditTransactions = <NorieCreditTransaction>[];
      }
    }
    _exploredSubjects =
        (prefs.getStringList(_subjectsKey) ?? const <String>[]).toSet();
    _studyDates =
        (prefs.getStringList(_studyDatesKey) ?? const <String>[]).toSet();
    _dailyChallengeDates =
        (prefs.getStringList(_dailyChallengeDatesKey) ?? const <String>[])
            .toSet();
    _speedRewardDates =
        (prefs.getStringList(_speedRewardDatesKey) ?? const <String>[]).toSet();
    _weeklyRewardedWeeks =
        (prefs.getStringList(_weeklyRewardedWeeksKey) ?? const <String>[])
            .toSet();
    _completedTopicIds =
        (prefs.getStringList(_completedTopicIdsKey) ?? const <String>[])
            .toSet();
    _rewardedLessonTopics =
        (prefs.getStringList(_rewardedLessonTopicsKey) ?? const <String>[])
            .toSet();
    _rewardedPerfectLessonTopics =
        (prefs.getStringList(_rewardedPerfectLessonTopicsKey) ??
                const <String>[])
            .toSet();

    final rawMastery = prefs.getString(_topicMasteryKey);
    if (rawMastery != null && rawMastery.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawMastery) as Map<String, dynamic>;
        _topicMastery = decoded.map(
          (key, value) => MapEntry(
            key,
            NorieTopicMastery.fromJson(
              Map<String, dynamic>.from(value as Map),
            ),
          ),
        );
      } on FormatException {
        _topicMastery = <String, NorieTopicMastery>{};
      }
    }

    final rawModified = prefs.getString(_lastModifiedKey);
    _lastModifiedAt = DateTime.tryParse(rawModified ?? '')?.toUtc() ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    _onboardingComplete = prefs.getBool(_onboardingKey) ?? false;
    final migratedLegacyTopic = _migrateLegacyTopicCompletion();
    notifyListeners();
    if (migratedLegacyTopic) {
      await _save();
    }
  }

  NorieXpAward addXp(int amount) {
    final safeAmount = amount < 0 ? 0 : amount;
    final before = snapshot;
    _totalXp += safeAmount;
    final after = snapshot;

    if (safeAmount > 0) {
      _changed();
    }

    return NorieXpAward(
      amount: safeAmount,
      before: before,
      after: after,
    );
  }

  void addCredits(int amount) {
    final safeAmount = amount < 0 ? 0 : amount;
    if (safeAmount == 0) return;
    _credits += safeAmount;
    _recordCreditTransaction(safeAmount, 'Credits earned');
    _changed();
  }

  bool spendCredits(int amount) {
    final safeAmount = amount < 0 ? 0 : amount;
    if (safeAmount == 0) return true;
    if (_credits < safeAmount) return false;
    _credits -= safeAmount;
    _changed();
    return true;
  }

  bool purchaseShopItem(NorieShopItem item) {
    if (!item.consumable && _ownedShopItems.contains(item.id)) return false;
    if (_credits < item.price) return false;

    _credits -= item.price;
    _recordCreditTransaction(-item.price, 'Purchased ${item.title}');

    if (item.id == NorieShopCatalog.streakShield.id) {
      _streakShields++;
    } else {
      _ownedShopItems.add(item.id);
    }

    _changed();
    return true;
  }

  bool equipShopItem(NorieShopItem item) {
    if (!_ownedShopItems.contains(item.id)) return false;

    switch (item.type) {
      case NorieShopItemType.profileFrame:
        _equippedFrameId = item.id;
      case NorieShopItemType.badge:
        _equippedBadgeId = item.id;
      case NorieShopItemType.theme:
        _equippedThemeId = item.id;
      case NorieShopItemType.consumable:
        return false;
    }
    _changed();
    return true;
  }

  bool useStreakShield() {
    if (_streakShields < 1) return false;
    _streakShields--;
    _changed();
    return true;
  }

  void _recordCreditTransaction(int amount, String reason) {
    _creditTransactions.insert(
      0,
      NorieCreditTransaction(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amount: amount,
        reason: reason,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    if (_creditTransactions.length > 100) {
      _creditTransactions =
          _creditTransactions.take(100).toList(growable: true);
    }
  }

  void markOnboardingComplete() {
    if (_onboardingComplete) return;
    _onboardingComplete = true;
    _changed();
  }

  void recordSubjectExplored(String subject) {
    final normalized = subject.trim();
    if (normalized.isEmpty || _exploredSubjects.contains(normalized)) return;
    _exploredSubjects.add(normalized);
    _changed();
  }

  NorieLessonCompletion recordLessonCompletion({
    required int quizScore,
    required int challengeScore,
    String category = 'Science',
    String topic = 'Atomic Structure',
    String? topicId,
    int quizAttempts = 5,
    int challengeAttempts = 3,
  }) {
    final safeQuizAttempts = quizAttempts < 0 ? 0 : quizAttempts;
    final safeChallengeAttempts = challengeAttempts < 0 ? 0 : challengeAttempts;
    final totalAttempts = safeQuizAttempts + safeChallengeAttempts;
    final totalCorrect =
        (quizScore + challengeScore).clamp(0, totalAttempts).toInt();

    _completedLessons++;
    _studySessions++;
    _correctAnswers += totalCorrect;
    _questionsAnswered += totalAttempts;
    _recordStudyDay(DateTime.now());

    var creditsAwarded = 0;
    var lessonRewardAwarded = false;
    var perfectRewardAwarded = false;
    final normalizedTopicId = topicId?.trim() ?? '';

    if (normalizedTopicId.isNotEmpty) {
      _completedTopicIds.add(normalizedTopicId);

      if (_rewardedLessonTopics.add(normalizedTopicId)) {
        creditsAwarded += NorieEconomyRules.lessonCompletionCredits;
        lessonRewardAwarded = true;
      }

      if (totalAttempts > 0 &&
          totalCorrect == totalAttempts &&
          _rewardedPerfectLessonTopics.add(normalizedTopicId)) {
        creditsAwarded += NorieEconomyRules.perfectLessonCredits;
        perfectRewardAwarded = true;
      }
    }

    _credits += creditsAwarded;
    _recordTopicBatch(
      category: category,
      topic: topic,
      correctAnswers: totalCorrect,
      totalAttempts: totalAttempts,
    );
    _changed();

    return NorieLessonCompletion(
      creditsAwarded: creditsAwarded,
      lessonRewardAwarded: lessonRewardAwarded,
      perfectRewardAwarded: perfectRewardAwarded,
    );
  }

  void recordStudySession() {
    _studySessions++;
    _recordStudyDay(DateTime.now());
    _changed();
  }

  void recordGeneratedStudyAttempt({
    required int correct,
    required int total,
    required int xpAwarded,
    required String topic,
  }) {
    final safeTotal = total < 0 ? 0 : total;
    final safeCorrect = correct.clamp(0, safeTotal).toInt();
    final safeXp = xpAwarded < 0 ? 0 : xpAwarded;
    final normalizedTopic =
        topic.trim().isEmpty ? 'Generated Study Set' : topic.trim();

    _studySessions++;
    _correctAnswers += safeCorrect;
    _questionsAnswered += safeTotal;
    _totalXp += safeXp;
    _recordStudyDay(DateTime.now());

    if (safeTotal > 0) {
      _recordTopicBatch(
        category: 'AI Study',
        topic: normalizedTopic,
        correctAnswers: safeCorrect,
        totalAttempts: safeTotal,
      );
    }

    _changed();
  }

  void recordTopicAnswer({
    required String category,
    required String topic,
    required bool correct,
  }) {
    _recordTopicBatch(
      category: category,
      topic: topic,
      correctAnswers: correct ? 1 : 0,
      totalAttempts: 1,
    );
    _changed();
  }

  void _recordTopicBatch({
    required String category,
    required String topic,
    required int correctAnswers,
    required int totalAttempts,
  }) {
    if (totalAttempts <= 0) return;

    final safeAttempts = totalAttempts < 0 ? 0 : totalAttempts;
    final safeCorrect = correctAnswers.clamp(0, safeAttempts).toInt();
    final key = _topicKey(category, topic);
    final existing = _topicMastery[key] ??
        NorieTopicMastery(
          category: category,
          topic: topic,
          correct: 0,
          attempts: 0,
        );

    _topicMastery[key] = existing.add(
      correctAnswers: safeCorrect,
      totalAttempts: safeAttempts,
    );
  }

  NorieChallengeCompletion recordChallengeCompletion({
    required NorieChallengeMode mode,
    required int correct,
    required int total,
    DateTime? completedAt,
  }) {
    final now = completedAt ?? DateTime.now();
    final safeTotal = total < 1 ? 1 : total;
    final safeCorrect = correct.clamp(0, safeTotal).toInt();
    final before = snapshot;
    final dateKey = _dateKey(now);

    var baseXp = 0;
    var bonusXp = 0;
    var dailyRewardAwarded = false;
    var weeklyRewardAwarded = false;
    var bestScoreImproved = false;
    var creditsAwarded = 0;

    _challengeSessions++;
    _studySessions++;
    _correctAnswers += safeCorrect;
    _questionsAnswered += safeTotal;
    _recordStudyDay(now);

    if (mode == NorieChallengeMode.daily) {
      final wasCompleted = _dailyChallengeDates.contains(dateKey);
      if (!wasCompleted) {
        final weeklyDaysBefore = _weeklyChallengeDaysAt(now);
        _dailyChallengeDates.add(dateKey);
        baseXp = NorieChallengeRules.baseXp(
          mode: mode,
          correct: safeCorrect,
        );
        bonusXp += NorieChallengeRules.dailyCompletionBonus;
        dailyRewardAwarded = true;
        creditsAwarded += NorieEconomyRules.dailyChallengeCredits;

        final weeklyDaysAfter = _weeklyChallengeDaysAt(now);
        final weekKey = _weekKey(now);
        if (weeklyDaysBefore < NorieChallengeRules.weeklyGoalDays &&
            weeklyDaysAfter >= NorieChallengeRules.weeklyGoalDays &&
            !_weeklyRewardedWeeks.contains(weekKey)) {
          _weeklyRewardedWeeks.add(weekKey);
          bonusXp += NorieChallengeRules.weeklyGoalBonus;
          weeklyRewardAwarded = true;
          creditsAwarded += NorieEconomyRules.weeklyGoalCredits;
        }
      }
    } else {
      if (safeCorrect > _speedBestScore) {
        _speedBestScore = safeCorrect;
        bestScoreImproved = true;
      }

      if (!_speedRewardDates.contains(dateKey)) {
        _speedRewardDates.add(dateKey);
        baseXp = NorieChallengeRules.baseXp(
          mode: mode,
          correct: safeCorrect,
        );
        if (safeCorrect == safeTotal) {
          bonusXp += NorieChallengeRules.speedPerfectBonus;
        }
      }
    }

    _totalXp += baseXp + bonusXp;
    _credits += creditsAwarded;
    final after = snapshot;
    _changed();

    return NorieChallengeCompletion(
      mode: mode,
      correct: safeCorrect,
      total: safeTotal,
      baseXp: baseXp,
      bonusXp: bonusXp,
      dailyRewardAwarded: dailyRewardAwarded,
      weeklyRewardAwarded: weeklyRewardAwarded,
      bestScoreImproved: bestScoreImproved,
      creditsAwarded: creditsAwarded,
      before: before,
      after: after,
    );
  }

  int _weeklyChallengeDaysAt(DateTime date) {
    final start = _weekStart(date);
    final end = start.add(const Duration(days: 7));

    return _dailyChallengeDates.where((value) {
      final challengeDate = DateTime.parse(value);
      return !challengeDate.isBefore(start) && challengeDate.isBefore(end);
    }).length;
  }

  void _recordStudyDay(DateTime date) {
    _studyDates.add(_dateKey(date));
  }

  int _journeyRestores = 0;

  void recordJourneyChange() {
    if (_journeyRestores == 0) _changed();
  }

  /// A replayed completed route cannot award its quiz XP a second time.
  bool claimAssessmentAttempt(String receipt) {
    if (receipt.isEmpty || receipt.length > 512) return false;
    return _rewardedAssessmentAttempts.add(receipt);
  }

  void refreshGradeTrophies() {
    for (final subject in ['Science', 'Mathematics', 'English']) {
      for (final grade in NorieFoundationCurriculum.gradeLevels) {
        final topics = NorieFoundationCurriculum.topicsFor(subject, grade.id);
        NorieAdventureProgress.instance.registerGradeCompletions(
            subject: subject,
            gradeId: grade.id,
            originalTopicIds: topics.take(5).map((t) => t.id).toList(),
            currentTopicIds: topics.map((t) => t.id).toList(),
            completedTopicIds: _completedTopicIds);
      }
    }
  }

  void _changed({bool touchModified = true}) {
    if (touchModified) {
      _lastModifiedAt = DateTime.now().toUtc();
    }
    notifyListeners();
    unawaited(NorieProfileAppearanceStore.instance
        .unlockRank(snapshot.level)
        .catchError((Object _) {}));
    unawaited(_save());
  }

  Future<void> flushPendingSaves({bool retry = false}) async {
    if (retry) {
      await _save();
    } else {
      await _saves;
    }
    await Future.wait([
      NorieAdventureProgress.instance.flush(retry: retry),
      NorieProfileAppearanceStore.instance.flush()
    ]);
  }

  Future<void> _saves = Future<void>.value();

  /// Call only after the previous test has drained its pending persistence.
  @visibleForTesting
  void resetAsyncQueuesForTesting() {
    _saves = Future<void>.value();
    // This annotated test-only wrapper coordinates the other stores' fixtures.
    // ignore: invalid_use_of_visible_for_testing_member
    NorieAdventureProgress.instance.resetAsyncQueuesForTesting();
    // ignore: invalid_use_of_visible_for_testing_member
    NorieProfileAppearanceStore.instance.resetAsyncQueuesForTesting();
  }

  Future<void> _save() {
    final operation = _saves.catchError((Object _) {}).then((_) => _persist());
    _saves = operation;
    // Automatic writes may fail, but explicit flush still reports that failure.
    // Handle the background listener so failure cannot crash the active lesson.
    unawaited(operation.catchError((Object _) {}));
    return operation;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await Future.wait<bool>([
      prefs.setStringList(
          _assessmentAttemptsKey, _rewardedAssessmentAttempts.toList()..sort()),
      prefs.setInt(_xpKey, _totalXp),
      prefs.setInt(_creditsKey, _credits),
      prefs.setInt(_lessonsKey, _completedLessons),
      prefs.setInt(_sessionsKey, _studySessions),
      prefs.setInt(_correctKey, _correctAnswers),
      prefs.setInt(_questionsKey, _questionsAnswered),
      prefs.setInt(_challengeSessionsKey, _challengeSessions),
      prefs.setInt(_speedBestScoreKey, _speedBestScore),
      prefs.setInt(_streakShieldsKey, _streakShields),
      prefs.setStringList(_ownedShopItemsKey, _ownedShopItems.toList()..sort()),
      if (_equippedFrameId == null)
        prefs.remove(_equippedFrameKey)
      else
        prefs.setString(_equippedFrameKey, _equippedFrameId!),
      if (_equippedBadgeId == null)
        prefs.remove(_equippedBadgeKey)
      else
        prefs.setString(_equippedBadgeKey, _equippedBadgeId!),
      if (_equippedThemeId == null)
        prefs.remove(_equippedThemeKey)
      else
        prefs.setString(_equippedThemeKey, _equippedThemeId!),
      prefs.setString(
        _creditTransactionsKey,
        jsonEncode(_creditTransactions.map((item) => item.toJson()).toList()),
      ),
      prefs.setStringList(_subjectsKey, _exploredSubjects.toList()..sort()),
      prefs.setStringList(_studyDatesKey, _studyDates.toList()..sort()),
      prefs.setStringList(
        _dailyChallengeDatesKey,
        _dailyChallengeDates.toList()..sort(),
      ),
      prefs.setStringList(
        _speedRewardDatesKey,
        _speedRewardDates.toList()..sort(),
      ),
      prefs.setStringList(
        _weeklyRewardedWeeksKey,
        _weeklyRewardedWeeks.toList()..sort(),
      ),
      prefs.setStringList(
        _completedTopicIdsKey,
        _completedTopicIds.toList()..sort(),
      ),
      prefs.setStringList(
        _rewardedLessonTopicsKey,
        _rewardedLessonTopics.toList()..sort(),
      ),
      prefs.setStringList(
        _rewardedPerfectLessonTopicsKey,
        _rewardedPerfectLessonTopics.toList()..sort(),
      ),
      prefs.setString(
        _topicMasteryKey,
        jsonEncode(
          _topicMastery.map(
            (key, value) => MapEntry(key, value.toJson()),
          ),
        ),
      ),
      prefs.setBool(_onboardingKey, _onboardingComplete),
      prefs.setString(_lastModifiedKey, _lastModifiedAt.toIso8601String()),
    ]);
    if (saved.any((success) => !success)) {
      throw StateError('Learning progress could not be saved on this device.');
    }
  }

  Future<bool> resetForNewAccount({bool Function()? stillCurrent}) async {
    _journeyRestores++;
    try {
      final applied = await NorieLessonJourney.instance.reset(
        stillCurrent: stillCurrent,
        onApply: () {
          _rewardedAssessmentAttempts = {};
          NorieAdventureProgress.instance
              .applyValidatedState(NorieAdventureProgress.emptyState);
          NorieProfileAppearanceStore.instance.applyValidatedState(
              {'appearance': const NorieProfileAppearance().toJson()});
          _totalXp = 0;
          _credits = 0;
          _completedLessons = 0;
          _studySessions = 0;
          _correctAnswers = 0;
          _questionsAnswered = 0;
          _challengeSessions = 0;
          _speedBestScore = 0;
          _streakShields = 0;
          _ownedShopItems = <String>{};
          _equippedFrameId = null;
          _equippedBadgeId = null;
          _equippedThemeId = null;
          _creditTransactions = <NorieCreditTransaction>[];
          _exploredSubjects = <String>{};
          _studyDates = <String>{};
          _dailyChallengeDates = <String>{};
          _speedRewardDates = <String>{};
          _weeklyRewardedWeeks = <String>{};
          _completedTopicIds = <String>{};
          _rewardedLessonTopics = <String>{};
          _rewardedPerfectLessonTopics = <String>{};
          _topicMastery = <String, NorieTopicMastery>{};
          _onboardingComplete = true;
          _lastModifiedAt = DateTime.now().toUtc();

          notifyListeners();
          unawaited(_save());
        },
      );
      await _saves;
      if (applied) {
        await Future.wait([
          NorieAdventureProgress.instance.flush(),
          NorieProfileAppearanceStore.instance.flush()
        ]);
      }
      return applied;
    } finally {
      _journeyRestores--;
    }
  }

  Map<String, dynamic> exportCloudState() => {
        'adventure_progress': NorieAdventureProgress.instance.exportState(),
        'profile_appearance':
            NorieProfileAppearanceStore.instance.exportState(),
        'rewarded_assessment_attempts': _rewardedAssessmentAttempts.toList()
          ..sort(),
        'lesson_journey': NorieLessonJourney.instance.exportState(),
        'schema_version': 1,
        'total_xp': _totalXp,
        'credits': _credits,
        'streak_shields': _streakShields,
        'owned_shop_items': _ownedShopItems.toList()..sort(),
        'equipped_frame_id': _equippedFrameId,
        'equipped_badge_id': _equippedBadgeId,
        'equipped_theme_id': _equippedThemeId,
        'credit_transactions':
            _creditTransactions.map((item) => item.toJson()).toList(),
        'completed_lessons': _completedLessons,
        'study_sessions': _studySessions,
        'correct_answers': _correctAnswers,
        'questions_answered': _questionsAnswered,
        'challenge_sessions': _challengeSessions,
        'speed_best_score': _speedBestScore,
        'explored_subjects': _exploredSubjects.toList()..sort(),
        'study_dates': _studyDates.toList()..sort(),
        'daily_challenge_dates': _dailyChallengeDates.toList()..sort(),
        'speed_reward_dates': _speedRewardDates.toList()..sort(),
        'weekly_rewarded_weeks': _weeklyRewardedWeeks.toList()..sort(),
        'completed_topic_ids': _completedTopicIds.toList()..sort(),
        'rewarded_lesson_topics': _rewardedLessonTopics.toList()..sort(),
        'rewarded_perfect_lesson_topics': _rewardedPerfectLessonTopics.toList()
          ..sort(),
        'topic_mastery': _topicMastery.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
        'onboarding_complete': _onboardingComplete,
        'modified_at': _lastModifiedAt.toIso8601String(),
      };

  /// Used only for the same authenticated owner, never guest/account transfers.
  /// XP remains a snapshot maximum; independent offline XP is not summed.
  static Map<String, dynamic> mergePermanentCollections(
      Map<String, dynamic> primary, Map<String, dynamic> secondary) {
    NorieProgressBackup.validateState(primary);
    NorieProgressBackup.validateState(secondary);
    final result = Map<String, dynamic>.from(primary);
    for (final key in [
      'completed_topic_ids',
      'rewarded_lesson_topics',
      'rewarded_perfect_lesson_topics',
      'owned_shop_items',
      'rewarded_assessment_attempts'
    ]) {
      result[key] = {
        ..._readStringSet(primary[key]),
        ..._readStringSet(secondary[key])
      }.toList()
        ..sort();
    }
    for (final key in ['total_xp', 'completed_lessons']) {
      if ((secondary[key] as int) > (primary[key] as int)) {
        result[key] = secondary[key];
      }
    }
    result['adventure_progress'] = NorieAdventureProgress.mergePermanent(
        Map<String, dynamic>.from(
            primary['adventure_progress'] ?? NorieAdventureProgress.emptyState),
        Map<String, dynamic>.from(secondary['adventure_progress'] ??
            NorieAdventureProgress.emptyState));
    final defaults = {'appearance': const NorieProfileAppearance().toJson()};
    final appearance = NorieProfileAppearanceStore.validateState(
        primary['profile_appearance'] ?? defaults);
    final other = NorieProfileAppearanceStore.validateState(
        secondary['profile_appearance'] ?? defaults);
    if ((other['rankLevel'] as int) > (appearance['rankLevel'] as int)) {
      appearance['rankLevel'] = other['rankLevel'];
    }
    result['profile_appearance'] = appearance;
    NorieProgressBackup.validateState(result);
    return result;
  }

  Future<bool> importCloudState(
    Map<String, dynamic> state, {
    DateTime? remoteModifiedAt,
    bool Function()? stillCurrent,
  }) async {
    if (stillCurrent != null && !stillCurrent()) return false;
    NorieProgressBackup.validateState(state);
    final journey = NorieLessonJourney.validateState(
        state['lesson_journey'] ?? NorieLessonJourney.emptyState);
    final adventure = NorieAdventureProgress.validateState(
        state['adventure_progress'] ?? NorieAdventureProgress.emptyState);
    final appearance = NorieProfileAppearanceStore.validateState(
        state['profile_appearance'] ??
            {'appearance': const NorieProfileAppearance().toJson()});
    _journeyRestores++;
    try {
      final applied = await NorieLessonJourney.instance.replaceState(
        journey,
        stillCurrent: stillCurrent,
        onApply: () {
          _rewardedAssessmentAttempts =
              _readStringSet(state['rewarded_assessment_attempts']);
          NorieAdventureProgress.instance.applyValidatedState(adventure);
          NorieProfileAppearanceStore.instance.applyValidatedState(appearance);
          _totalXp = _readInt(state['total_xp'], fallback: _totalXp);
          _credits = _readInt(state['credits'], fallback: _credits);
          _streakShields =
              _readInt(state['streak_shields'], fallback: _streakShields);
          _ownedShopItems = _readStringSet(state['owned_shop_items']);
          _equippedFrameId = state['equipped_frame_id']?.toString();
          _equippedBadgeId = state['equipped_badge_id']?.toString();
          _equippedThemeId = state['equipped_theme_id']?.toString();
          final rawTransactions = state['credit_transactions'];
          if (rawTransactions is List) {
            _creditTransactions = rawTransactions
                .whereType<Map>()
                .map((item) => NorieCreditTransaction.fromJson(
                      Map<String, dynamic>.from(item),
                    ))
                .toList();
          }
          _completedLessons =
              _readInt(state['completed_lessons'], fallback: _completedLessons);
          _studySessions =
              _readInt(state['study_sessions'], fallback: _studySessions);
          _correctAnswers =
              _readInt(state['correct_answers'], fallback: _correctAnswers);
          _questionsAnswered = _readInt(state['questions_answered'],
              fallback: _questionsAnswered);
          _challengeSessions = _readInt(state['challenge_sessions'],
              fallback: _challengeSessions);
          _speedBestScore =
              _readInt(state['speed_best_score'], fallback: _speedBestScore);

          _exploredSubjects = _readStringSet(state['explored_subjects']);
          _studyDates = _readStringSet(state['study_dates']);
          _dailyChallengeDates = _readStringSet(state['daily_challenge_dates']);
          _speedRewardDates = _readStringSet(state['speed_reward_dates']);
          _weeklyRewardedWeeks = _readStringSet(state['weekly_rewarded_weeks']);
          _completedTopicIds = _readStringSet(state['completed_topic_ids']);
          _rewardedLessonTopics =
              _readStringSet(state['rewarded_lesson_topics']);
          _rewardedPerfectLessonTopics =
              _readStringSet(state['rewarded_perfect_lesson_topics']);

          final rawMastery = state['topic_mastery'];
          if (rawMastery is Map) {
            _topicMastery = rawMastery.map(
              (key, value) => MapEntry(
                key.toString(),
                NorieTopicMastery.fromJson(
                  Map<String, dynamic>.from(value as Map),
                ),
              ),
            );
          }

          final cloudOnboarding = state['onboarding_complete'];
          if (cloudOnboarding is bool) {
            _onboardingComplete = cloudOnboarding;
          }

          final stateModified = DateTime.tryParse(
            state['modified_at']?.toString() ?? '',
          );
          _lastModifiedAt =
              (remoteModifiedAt ?? stateModified ?? DateTime.now()).toUtc();
          _migrateLegacyTopicCompletion();
          refreshGradeTrophies();

          _changed(touchModified: false);
        },
      );
      await _saves;
      if (applied) {
        await Future.wait([
          NorieAdventureProgress.instance.flush(),
          NorieProfileAppearanceStore.instance.flush()
        ]);
      }
      return applied;
    } finally {
      _journeyRestores--;
    }
  }

  bool _migrateLegacyTopicCompletion() {
    if (_completedTopicIds.isNotEmpty || _completedLessons < 1) {
      return false;
    }

    _completedTopicIds.add('science.chemistry.atomic-structure');
    return true;
  }

  static int _readInt(Object? value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static Set<String> _readStringSet(Object? value) {
    if (value is! List) return <String>{};
    return value.map((item) => item.toString()).toSet();
  }

  static String _topicKey(String category, String topic) =>
      '${category.trim()}::${topic.trim()}';

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime _weekStart(DateTime date) {
    final day = _dateOnly(date);
    return day.subtract(Duration(days: day.weekday - DateTime.monday));
  }

  static String _weekKey(DateTime date) => _dateKey(_weekStart(date));

  static String _dateKey(DateTime date) {
    final day = _dateOnly(date);
    final month = day.month.toString().padLeft(2, '0');
    final dateOfMonth = day.day.toString().padLeft(2, '0');
    return '${day.year}-$month-$dateOfMonth';
  }

  @visibleForTesting
  void setTotalXpForTesting(int value) {
    _totalXp = value < 0 ? 0 : value;
    notifyListeners();
  }
}
