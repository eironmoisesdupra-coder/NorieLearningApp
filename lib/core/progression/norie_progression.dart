import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final NorieLevelSnapshot before;
  final NorieLevelSnapshot after;

  int get totalXpAwarded => baseXp + bonusXp;
  bool get leveledUp => after.level > before.level;
  bool get rankChanged => after.title != before.title;
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
    final progress = isMaxLevel
        ? 1.0
        : (remaining / requirement).clamp(0.0, 1.0).toDouble();

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

  int _totalXp = 1250;
  int _completedLessons = 0;
  int _studySessions = 0;
  int _correctAnswers = 0;
  int _questionsAnswered = 0;
  int _challengeSessions = 0;
  int _speedBestScore = 0;
  Set<String> _exploredSubjects = <String>{};
  Set<String> _studyDates = <String>{};
  Set<String> _dailyChallengeDates = <String>{};
  Set<String> _speedRewardDates = <String>{};
  Set<String> _weeklyRewardedWeeks = <String>{};
  bool _onboardingComplete = false;

  int get totalXp => _totalXp;
  int get completedLessons => _completedLessons;
  int get studySessions => _studySessions;
  int get correctAnswers => _correctAnswers;
  int get questionsAnswered => _questionsAnswered;
  int get challengeSessions => _challengeSessions;
  int get speedBestScore => _speedBestScore;
  Set<String> get exploredSubjects => Set.unmodifiable(_exploredSubjects);
  bool get onboardingComplete => _onboardingComplete;

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

  int get weeklyChallengeDays =>
      _weeklyChallengeDaysAt(DateTime.now());

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
          progress:
              (_exploredSubjects.length / 2).clamp(0.0, 1.0).toDouble(),
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
    _totalXp = prefs.getInt(_xpKey) ?? _totalXp;
    _completedLessons = prefs.getInt(_lessonsKey) ?? 0;
    _studySessions = prefs.getInt(_sessionsKey) ?? 0;
    _correctAnswers = prefs.getInt(_correctKey) ?? 0;
    _questionsAnswered = prefs.getInt(_questionsKey) ?? 0;
    _challengeSessions = prefs.getInt(_challengeSessionsKey) ?? 0;
    _speedBestScore = prefs.getInt(_speedBestScoreKey) ?? 0;
    _exploredSubjects = (prefs.getStringList(_subjectsKey) ?? const <String>[])
        .toSet();
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
    _onboardingComplete = prefs.getBool(_onboardingKey) ?? false;
    notifyListeners();
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

  void recordLessonCompletion({
    required int quizScore,
    required int challengeScore,
  }) {
    _completedLessons++;
    _studySessions++;
    _correctAnswers += quizScore + challengeScore;
    _questionsAnswered += 8;
    _recordStudyDay(DateTime.now());
    _changed();
  }

  void recordStudySession() {
    _studySessions++;
    _recordStudyDay(DateTime.now());
    _changed();
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

        final weeklyDaysAfter = _weeklyChallengeDaysAt(now);
        final weekKey = _weekKey(now);
        if (weeklyDaysBefore < NorieChallengeRules.weeklyGoalDays &&
            weeklyDaysAfter >= NorieChallengeRules.weeklyGoalDays &&
            !_weeklyRewardedWeeks.contains(weekKey)) {
          _weeklyRewardedWeeks.add(weekKey);
          bonusXp += NorieChallengeRules.weeklyGoalBonus;
          weeklyRewardAwarded = true;
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

  void _changed() {
    notifyListeners();
    unawaited(_save());
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt(_xpKey, _totalXp),
      prefs.setInt(_lessonsKey, _completedLessons),
      prefs.setInt(_sessionsKey, _studySessions),
      prefs.setInt(_correctKey, _correctAnswers),
      prefs.setInt(_questionsKey, _questionsAnswered),
      prefs.setInt(_challengeSessionsKey, _challengeSessions),
      prefs.setInt(_speedBestScoreKey, _speedBestScore),
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
      prefs.setBool(_onboardingKey, _onboardingComplete),
    ]);
  }

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
