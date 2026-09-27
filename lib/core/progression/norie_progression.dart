import 'package:flutter/foundation.dart';

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

class NorieProgression extends ChangeNotifier {
  NorieProgression._();

  static final NorieProgression instance = NorieProgression._();

  int _totalXp = 1250;

  int get totalXp => _totalXp;
  NorieLevelSnapshot get snapshot => NorieLevelSystem.snapshotForXp(_totalXp);

  NorieXpAward addXp(int amount) {
    final safeAmount = amount < 0 ? 0 : amount;
    final before = snapshot;
    _totalXp += safeAmount;
    final after = snapshot;

    if (safeAmount > 0) {
      notifyListeners();
    }

    return NorieXpAward(
      amount: safeAmount,
      before: before,
      after: after,
    );
  }

  @visibleForTesting
  void setTotalXpForTesting(int value) {
    _totalXp = value < 0 ? 0 : value;
    notifyListeners();
  }
}
