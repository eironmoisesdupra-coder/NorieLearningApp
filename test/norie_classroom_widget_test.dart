import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/classroom/data/norie_classroom_store.dart';
import 'package:norie_learning/features/classroom/presentation/norie_classroom_hub_screen.dart';
import 'package:norie_learning/features/classroom/presentation/norie_classroom_builder_screen.dart';
import 'package:norie_learning/features/classroom/presentation/norie_classroom_runner_screen.dart';
import 'package:norie_learning/features/classroom/domain/norie_classroom_models.dart';
import 'package:norie_learning/features/classroom/domain/norie_classroom_resolver.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'norie_classroom_store_test.dart' show assignment;

void main() {
  Future<void> narrow(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: child));
    await tester.pumpAndSettle();
  }

  testWidgets('hub and builder fit 320px at 160 percent text', (tester) async {
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    await narrow(tester, NorieClassroomHubScreen(store: store));
    await tester.scrollUntilVisible(find.text('Build assignment'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Build assignment'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Build assignment'));
    await tester.pumpAndSettle();
    expect(find.byType(NorieClassroomBuilderScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField).first, 'Living things');
    await tester.scrollUntilVisible(find.text('Save assignment'), 500,
        scrollable: find.byType(Scrollable).first);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
      'builder saves teacher title note selected question and hint policy',
      (tester) async {
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    await narrow(tester, NorieClassroomBuilderScreen(store: store));
    await tester.enterText(find.byType(TextField).first, 'Teacher practice');
    await tester.enterText(find.byType(TextField).at(1), 'Observe carefully.');
    await tester.scrollUntilVisible(find.byType(SwitchListTile), 300,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    final topic = NorieClassroomResolver.topicsFor('Science', 'g1').first;
    await tester.scrollUntilVisible(find.text(topic.title), 250,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text(topic.title));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.byType(CheckboxListTile).first, 250,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pumpAndSettle();
    // Collapse the source topic to keep the save button close on small phones.
    await tester.scrollUntilVisible(find.text(topic.title), -300,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(find.text(topic.title));
    await tester.pumpAndSettle();
    await tester.tap(find.text(topic.title));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Save assignment'), 300,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Save assignment'));
    await tester.pumpAndSettle();
    expect(store.assignments.single.title, 'Teacher practice');
    expect(store.assignments.single.teacherNote, 'Observe carefully.');
    expect(store.assignments.single.questionIds, hasLength(1));
    expect(store.assignments.single.allowHints, isTrue);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
      'hint reveals authored explanation and ownership switch hides prior work',
      (tester) async {
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    final a = NorieClassroomAssignment.fromJson(
        {...assignment().toJson(), 'allow_hints': true});
    await store.importAssignment(a);
    await narrow(
        tester, NorieClassroomRunnerScreen(assignment: a, store: store));
    await tester.scrollUntilVisible(find.text('Show explanation hint'), 250,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Show explanation hint'));
    await tester.pumpAndSettle();
    expect(find.text(NorieClassroomResolver.questionsFor(a).first.explanation),
        findsOneWidget);
    NorieAdventureProgress.instance
        .applyValidatedState(NorieAdventureProgress.emptyState, persist: false);
    await tester.pumpAndSettle();
    expect(find.text('Learner changed. Reopen Classroom.'), findsOneWidget);
    expect(find.text('Show explanation hint'), findsNothing);
  });
  testWidgets(
      'learner completes and persists real authored answers without hints',
      (tester) async {
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    final a = assignment();
    await store.importAssignment(a);
    await narrow(
        tester, NorieClassroomRunnerScreen(assignment: a, store: store));
    expect(find.text('Show explanation hint'), findsNothing);
    await tester.enterText(find.byType(TextField), 'Mina');
    await tester.scrollUntilVisible(
        find.text('Reference passage and diagrams'), 100,
        scrollable: find.byType(Scrollable).first);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Finish assignment'), 250,
        scrollable: find.byType(Scrollable).first);
    final options = find.byType(OutlinedButton);
    await tester.tap(options.first);
    await tester.pump();
    await tester.tap(find.text('Finish assignment'));
    await tester.pumpAndSettle();
    expect(find.text('Export submission'), findsOneWidget);
    expect(store.submissions.single.learnerAlias, 'Mina');
    expect(tester.takeException(), isNull);
  });
}
