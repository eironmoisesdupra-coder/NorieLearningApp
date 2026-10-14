import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';
import 'package:norie_learning/core/progression/norie_lesson_journey.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/data/additional_subjects/norie_additional_subject_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';
import 'package:norie_learning/features/content/presentation/norie_science_adventure_map.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    NorieLessonJourney.instance.resetAsyncQueuesForTesting();
  });

  testWidgets(
      'mission skill review is advisory and Start stays enabled on small phones',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final topics = NorieAdditionalSubjectCurriculum.topicsFor('Filipino', 'g1')
        .take(2)
        .toList();
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        home: MediaQuery(
          data: const MediaQueryData(
              size: Size(320, 700), textScaler: TextScaler.linear(1.6)),
          child: Scaffold(
              body: NorieScienceAdventureMap(
            subject: 'Filipino',
            grade: NorieFoundationCurriculum.gradeLevels.first,
            accent: NorieColors.green,
            topics: topics,
          )),
        )));
    final mission = find.byKey(ValueKey('map-node-${topics[1].id}'));
    await tester.ensureVisible(mission);
    await tester.tap(mission);
    await tester.pumpAndSettle();
    expect(find.text('Skills in this mission'), findsOneWidget);
    expect(find.text('Pagkilala at pagbuo ng pantig'), findsOneWidget);
    expect(find.text('Suggested review first: Pag-uugnay ng titik at tunog'),
        findsOneWidget);
    expect(
        find.text(
            'Review suggestions are optional. You can start this mission now.'),
        findsOneWidget);
    final start = find.widgetWithText(FilledButton, 'Start mission');
    await tester.ensureVisible(start);
    expect(tester.widget<FilledButton>(start).onPressed, isNotNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await _drainPersistence(tester, NorieLessonJourney.instance.flush());
  });

  testWidgets('older conceptless lesson shows its title as the core skill',
      (tester) async {
    final json = NorieAdditionalSubjectCurriculum.topicsFor('Filipino', 'g1')
        .first
        .toJson();
    for (final question in [
      ...(json['quiz'] as Map)['questions'] as List,
      ...(json['challenge'] as Map)['rounds'] as List,
    ]) {
      (question as Map).remove('concept_id');
      question.remove('concept_label');
    }
    final topic = NorieTopicContent.fromJson(json);
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        home: Scaffold(
            body: NorieScienceAdventureMap(
          subject: 'Filipino',
          grade: NorieFoundationCurriculum.gradeLevels.first,
          accent: NorieColors.green,
          topics: [topic],
        ))));
    await tester.tap(find.byKey(ValueKey('map-node-${topic.id}')));
    await tester.pumpAndSettle();
    expect(find.text('Skills in this mission'), findsOneWidget);
    expect(
        find.descendant(
            of: find.byKey(const ValueKey('mission-skill-labels')),
            matching: find.text(topic.title)),
        findsOneWidget);
    expect(find.textContaining('Suggested review first:'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await _drainPersistence(tester, NorieLessonJourney.instance.flush());
  });
}

Future<void> _drainPersistence(
    WidgetTester tester, Future<void> operation) async {
  var completed = false;
  Object? error;
  operation.then((_) => completed = true, onError: (Object value) {
    error = value;
    completed = true;
  });
  for (var i = 0; i < 100 && !completed; i++) {
    await tester.pump(const Duration(milliseconds: 10));
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 1)));
  }
  expect(completed, isTrue,
      reason: 'Map persistence must drain across clock zones');
  if (error != null) throw error!;
}
