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
      expect(NorieLevelSystem.titleForLevel(5), 'Explorer');
      expect(NorieLevelSystem.titleForLevel(14), 'Explorer');
      expect(NorieLevelSystem.titleForLevel(15), 'Scholar');
      expect(NorieLevelSystem.titleForLevel(29), 'Scholar');
      expect(NorieLevelSystem.titleForLevel(30), 'Expert');
      expect(NorieLevelSystem.titleForLevel(49), 'Expert');
      expect(NorieLevelSystem.titleForLevel(50), 'Professor');
    });

    test('1250 total XP is Level 8 Explorer', () {
      final snapshot = NorieLevelSystem.snapshotForXp(1250);

      expect(snapshot.level, 8);
      expect(snapshot.title, 'Explorer');
      expect(snapshot.xpIntoLevel, 25);
      expect(snapshot.xpRequiredForNextLevel, 275);
      expect(snapshot.nextRankTitle, 'Scholar');
      expect(snapshot.nextRankLevel, 15);
      expect(
          NorieLevelSystem.snapshotForXp(
                  NorieLevelSystem.totalXpRequiredForLevel(15))
              .nextRankTitle,
          'Expert');
    });

    test('Level 50 is capped as Professor', () {
      final xpForLevel50 = NorieLevelSystem.totalXpRequiredForLevel(50);
      final snapshot = NorieLevelSystem.snapshotForXp(xpForLevel50 + 5000);

      expect(snapshot.level, 50);
      expect(snapshot.title, 'Professor');
      expect(snapshot.isMaxLevel, isTrue);
      expect(snapshot.progress, 1);
    });
  });
}
