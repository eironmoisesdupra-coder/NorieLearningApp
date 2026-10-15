import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_educational_collectible.dart';
import 'package:norie_learning/features/content/presentation/norie_collectibles_screen.dart';
import 'package:norie_learning/features/content/presentation/norie_lesson_screen.dart';
import 'package:norie_learning/features/content/presentation/norie_boss_missions_screen.dart';
import 'package:norie_learning/features/profile/presentation/norie_appearance_studio.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NorieAdventureProgress.instance.reset();
  });
  test('catalogue teaches real available chapters with source lesson concepts',
      () {
    final cards = NorieEducationalCollectible.catalogue;
    expect(cards.length, greaterThanOrEqualTo(41));
    expect(cards.map((card) => card.id).toSet().length, cards.length);
    for (final card in cards) {
      expect(
          NorieFoundationCurriculum.availableGradeLevels(card.subject)
              .any((grade) => grade.id == card.gradeId),
          isTrue);
      expect(card.sources.length, inInclusiveRange(1, 5));
      expect(card.title, isNotEmpty);
      for (final source in card.sources) {
        expect(source.available, isTrue);
        expect(card.studyText, contains(source.lesson.keyConceptBody));
        expect(NorieEducationalCollectible.conceptBody(source).length,
            greaterThan(25));
      }
      expect(card.requirement, contains('80%'));
    }
    expect(
        cards
            .where((card) => card.subject == 'Filipino')
            .every((card) => card.gradeId == 'g1'),
        isTrue);
  });
  test(
      'ownership follows persisted account replacement without another inventory',
      () async {
    final card = NorieEducationalCollectible.catalogue.first;
    final progress = NorieAdventureProgress.instance;
    final owned = {
      ...NorieAdventureProgress.emptyState,
      'trophies': {card.id: '2026-10-15T00:00:00.000Z'}
    };
    await progress.replaceState(owned);
    expect(card.isEarned(progress.trophyIds), isTrue);
    final restored = NorieAdventureProgress();
    await restored.load();
    expect(card.isEarned(restored.trophyIds), isTrue);
    await progress.replaceState(NorieAdventureProgress.emptyState);
    expect(card.isEarned(progress.trophyIds), isFalse);
    await progress.replaceState(owned);
    expect(card.isEarned(progress.trophyIds), isTrue);
    restored.dispose();
  });
  test('boss showcase label identifies grade, subject and chapter', () {
    expect(trophyLabel('boss:araling panlipunan.g1:chapter-2:abcdef'),
        'Grade 1 Araling Panlipunan · Chapter 2 knowledge card');
  });
  testWidgets(
      'small phone gallery filters, opens readable detail and updates ownership',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: const NorieCollectiblesScreen()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Earned only'), 250);
    await tester.ensureVisible(find.text('Earned only'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Earned only'));
    await tester.pumpAndSettle();
    expect(find.text('No earned cards in this selection yet.'), findsOneWidget);
    final card = NorieEducationalCollectible.catalogue.first;
    await tester.runAsync(() => NorieAdventureProgress.instance.replaceState({
          ...NorieAdventureProgress.emptyState,
          'trophies': {card.id: '2026-10-15T00:00:00.000Z'}
        }));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text(card.title));
    await tester.tap(find.text(card.title));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
        find.text(NorieEducationalCollectible.conceptBody(card.sources.first)),
        250);
    await tester.ensureVisible(
        find.text(NorieEducationalCollectible.conceptBody(card.sources.first)));
    expect(
        find.text(NorieEducationalCollectible.conceptBody(card.sources.first)),
        findsOneWidget);
    expect(tester.takeException(), isNull);
    final lessonLink = find.text('Study lesson: ${card.sources.first.title}');
    await tester.scrollUntilVisible(lessonLink, 250);
    await tester.ensureVisible(lessonLink);
    await tester.tap(lessonLink);
    await tester.pumpAndSettle();
    expect(find.byType(NorieLessonScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.runAsync(() => NorieAdventureProgress.instance
        .replaceState(NorieAdventureProgress.emptyState));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Locked preview'), -250);
    expect(find.text('Locked preview'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Prepare Boss Mission'), 200);
    await tester.ensureVisible(find.text('Prepare Boss Mission'));
    await tester.tap(find.text('Prepare Boss Mission'));
    await tester.pumpAndSettle();
    expect(find.byType(NorieBossMissionsScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
