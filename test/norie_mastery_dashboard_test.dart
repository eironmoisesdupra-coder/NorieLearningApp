import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/progress/domain/norie_mastery_dashboard.dart';
import 'package:norie_learning/features/progress/presentation/norie_mastery_dashboard_screen.dart';
import 'package:norie_learning/features/content/presentation/norie_review_quest_screen.dart';
import 'package:norie_learning/features/content/domain/norie_review_quest.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NorieProgression.instance.resetForNewAccount();
  });
  test('counts only available authored lessons and never legacy totals',
      () async {
    final state = NorieProgression.instance.exportCloudState();
    state['completed_lessons'] = 500;
    await NorieProgression.instance.importCloudState(state);
    final result = NorieMasteryDashboardPolicy.derive();
    expect(result.subjects.length, 5);
    expect(result.subjects.fold<int>(0, (n, s) => n + s.total), 249);
    expect(result.completedLessons, 0);
    expect(result.availablePaths, 41);
  });
  test('latest regression is priority while retained history is preserved', () {
    final topics = NorieFoundationCurriculum.topicsFor('Science', 'g1');
    final adventure = NorieAdventureProgress();
    final first = DateTime.utc(2026, 10, 1);
    final last = DateTime.utc(2026, 10, 5);
    adventure.applyValidatedState({
      'version': 1,
      'evidence': {
        for (var i = 0; i < 3; i++)
          topics[i].id: NorieLessonEvidence(
            firstPassedAt: first,
            retainedAt: first.add(const Duration(days: 1)),
            lastAttemptAt: last.add(Duration(hours: i)),
            bestPercent: 100,
            lastPercent: 40,
            priorityConcepts: ['real concept'],
          ).toJson(),
        'boss:unknown':
            NorieLessonEvidence(lastAttemptAt: last, lastPercent: 20).toJson(),
      },
      'trophies': <String, String>{},
      'receipts': <String>[],
    }, persist: false);
    final result = NorieMasteryDashboardPolicy.derive(adventure: adventure);
    expect(result.strongTopics, isEmpty);
    expect(result.priorityTopics, [topics[2].title, topics[1].title]);
    expect(
        result.priorityLessons.map((t) => t.id), [topics[2].id, topics[1].id]);
    expect(result.historicalRetainedLessons.length, 3);
    expect(result.subjects.first.mastered, 0);
    expect(result.subjects.first.priorityCount, 3);
  });
  test(
      'completion alone does not establish current mastery, including pilot subjects',
      () async {
    final topic =
        NorieFoundationCurriculum.topicsFor('Araling Panlipunan', 'g1').first;
    final state = NorieProgression.instance.exportCloudState();
    state['completed_lessons'] = 500;
    state['completed_topic_ids'] = [
      topic.id,
      'boss:unknown',
      'unavailable.orphan'
    ];
    await NorieProgression.instance.importCloudState(state);
    final result = NorieMasteryDashboardPolicy.derive();
    expect(result.completedLessons, 1);
    expect(result.subjects.last.completed, 1);
    expect(result.subjects.last.mastered, 0);
    expect(result.priorityLessons, isEmpty);
    expect(result.strongLessons, isEmpty);
  });
  test(
      'due review uses the supplied clock and improvement uses current evidence',
      () {
    final topics = NorieFoundationCurriculum.topicsFor('Science', 'g1');
    final adventure = NorieAdventureProgress();
    final first = DateTime.utc(2026, 10, 1);
    adventure.applyValidatedState({
      'version': 1,
      'evidence': {
        topics[0].id: NorieLessonEvidence(
                firstPassedAt: first,
                lastAttemptAt: first,
                bestPercent: 100,
                lastPercent: 100)
            .toJson(),
        topics[1].id: NorieLessonEvidence(
                firstPassedAt: first,
                lastAttemptAt: first,
                bestPercent: 100,
                lastPercent: 60)
            .toJson(),
        'unknown': NorieLessonEvidence(
                firstPassedAt: first,
                lastAttemptAt: first,
                bestPercent: 100,
                lastPercent: 100)
            .toJson(),
      },
      'trophies': {
        'improvement:${topics[0].id}': first.toIso8601String(),
        'improvement:${topics[1].id}': first.toIso8601String(),
      },
      'receipts': <String>[],
    }, persist: false);
    final before = adventure.exportState();
    final early = NorieMasteryDashboardPolicy.derive(
        adventure: adventure, at: first.add(const Duration(hours: 23)));
    final due = NorieMasteryDashboardPolicy.derive(
        adventure: adventure, at: first.add(const Duration(hours: 24)));
    expect(early.retentionDue, 0);
    expect(due.retentionDue, 2);
    expect(due.improvedLessons.map((t) => t.id), [topics[0].id]);
    expect(adventure.exportState(), before);
    expect(() => due.priorityLessons.clear(), throwsUnsupportedError);
  });
  test('reset removes previous learner dashboard evidence', () async {
    final topic = NorieFoundationCurriculum.topicsFor('Filipino', 'g1').first;
    NorieAdventureProgress.instance.applyValidatedState({
      'version': 1,
      'evidence': {
        topic.id: NorieLessonEvidence(
            lastAttemptAt: DateTime.utc(2026),
            lastPercent: 20,
            missedQuestionIds: [topic.quiz.questions.first.id]).toJson()
      },
      'trophies': <String, String>{},
      'receipts': <String>[],
    }, persist: false);
    expect(NorieMasteryDashboardPolicy.derive().priorityLessons.single.id,
        topic.id);
    await NorieProgression.instance.resetForNewAccount();
    expect(NorieMasteryDashboardPolicy.derive().priorityLessons, isEmpty);
  });
  test('future evidence cannot generate lesson advice before it occurs', () {
    final topic = NorieFoundationCurriculum.topicsFor('Science', 'g1').first;
    final clock = DateTime.utc(2026, 10, 1);
    final adventure = NorieAdventureProgress();
    adventure.applyValidatedState({
      'version': 1,
      'evidence': {
        topic.id: NorieLessonEvidence(
                lastAttemptAt: clock.add(const Duration(days: 1)),
                lastPercent: 20)
            .toJson()
      },
      'trophies': <String, String>{},
      'receipts': <String>[],
    }, persist: false);
    expect(
        NorieMasteryDashboardPolicy.derive(adventure: adventure, at: clock)
            .priorityLessons,
        isEmpty);
  });
  testWidgets(
      'small phone dashboard opens the actual lesson mistake drill without writes',
      (tester) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final topic = NorieFoundationCurriculum.topicsFor('Science', 'g1').first;
    NorieAdventureProgress.instance.applyValidatedState({
      'version': 1,
      'evidence': {
        topic.id: NorieLessonEvidence(
            lastAttemptAt: DateTime.utc(2026),
            lastPercent: 20,
            missedQuestionIds: [topic.quiz.questions.first.id]).toJson()
      },
      'trophies': <String, String>{},
      'receipts': <String>[],
    }, persist: false);
    final before = NorieAdventureProgress.instance.exportState();
    final progressionBefore = NorieProgression.instance.exportCloudState();
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: const NorieMasteryDashboardScreen()));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final action = find.widgetWithText(FilledButton, 'Review mistakes');
    await tester.scrollUntilVisible(action, 250,
        scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(action);
    await tester.pumpAndSettle();
    final staleAction = tester.widget<FilledButton>(action).onPressed!;
    await tester.tap(action);
    await tester.pumpAndSettle();
    final review = tester
        .widget<NorieReviewQuestScreen>(find.byType(NorieReviewQuestScreen));
    expect(review.topic.id, topic.id);
    expect(review.kind, NorieReviewQuestKind.mistakeDrill);
    expect(
        NorieReviewQuestPolicy.select(review.topic, review.kind), isNotEmpty);
    expect(NorieAdventureProgress.instance.exportState(), before);
    expect(NorieProgression.instance.exportCloudState(), progressionBefore);
    Navigator.of(tester.element(find.byType(NorieReviewQuestScreen))).pop();
    await tester.pumpAndSettle();
    await tester.runAsync(() => NorieProgression.instance.resetForNewAccount());
    staleAction();
    await tester.pumpAndSettle();
    expect(find.byType(NorieReviewQuestScreen), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
