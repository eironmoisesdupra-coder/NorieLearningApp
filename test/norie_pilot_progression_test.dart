import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
      'pilot grade trophies require every published mission while legacy five stays valid',
      () async {
    SharedPreferences.setMockInitialValues({});
    final game = NorieProgression.instance;
    await game.resetForNewAccount();
    final prefs = await SharedPreferences.getInstance();
    for (final subject in ['Filipino', 'Araling Panlipunan', 'Science']) {
      final topics = NorieFoundationCurriculum.topicsFor(subject, 'g1');
      expect(topics.length, greaterThanOrEqualTo(6));
      final trophy = 'grade:${subject.toLowerCase()}.g1';
      await prefs.setStringList(
          'norie.completedTopicIds', topics.take(5).map((t) => t.id).toList());
      await game.load();
      game.refreshGradeTrophies();
      await NorieAdventureProgress.instance.flush();
      expect(NorieAdventureProgress.instance.trophyIds.contains(trophy),
          subject == 'Science');
      await prefs.setStringList(
          'norie.completedTopicIds', topics.map((t) => t.id).toList());
      await game.load();
      game.refreshGradeTrophies();
      await NorieAdventureProgress.instance.flush();
      expect(NorieAdventureProgress.instance.trophyIds, contains(trophy));
    }
  });
}
