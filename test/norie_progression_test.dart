import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';

void main() {
  group('NorieLevelSystem', () {
    test('XP requirement increases by 25 each level', () {
      expect(NorieLevelSystem.xpRequiredToAdvanceFrom(1), 100);
      expect(NorieLevelSystem.xpRequiredToAdvanceFrom(2), 125);
      expect(NorieLevelSystem.xpRequiredToAdvanceFrom(8), 275);
      expect(NorieLevelSystem.xpRequiredToAdvanceFrom(49), 1300);
    });

    test('rank titles change at requested levels', () {
      expect(NorieLevelSystem.titleForLevel(1), 'Rookie');
      expect(NorieLevelSystem.titleForLevel(4), 'Rookie');
      expect(NorieLevelSystem.titleForLevel(5), 'Novice');
      expect(NorieLevelSystem.titleForLevel(14), 'Novice');
      expect(NorieLevelSystem.titleForLevel(15), 'Veteran');
      expect(NorieLevelSystem.titleForLevel(29), 'Veteran');
      expect(NorieLevelSystem.titleForLevel(30), 'Scholar');
      expect(NorieLevelSystem.titleForLevel(49), 'Scholar');
      expect(NorieLevelSystem.titleForLevel(50), 'Master');
    });

    test('1250 total XP is Level 8 Novice', () {
      final snapshot = NorieLevelSystem.snapshotForXp(1250);

      expect(snapshot.level, 8);
      expect(snapshot.title, 'Novice');
      expect(snapshot.xpIntoLevel, 25);
      expect(snapshot.xpRequiredForNextLevel, 275);
      expect(snapshot.nextRankTitle, 'Veteran');
      expect(snapshot.nextRankLevel, 15);
      expect(
          NorieLevelSystem.snapshotForXp(
                  NorieLevelSystem.totalXpRequiredForLevel(15))
              .nextRankTitle,
          'Scholar');
    });

    test('Level 50 is capped as Master', () {
      final xpForLevel50 = NorieLevelSystem.totalXpRequiredForLevel(50);
      final snapshot = NorieLevelSystem.snapshotForXp(xpForLevel50 + 5000);

      expect(snapshot.level, 50);
      expect(snapshot.title, 'Master');
      expect(snapshot.isMaxLevel, isTrue);
      expect(snapshot.progress, 1);
    });
  });
}
