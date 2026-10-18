import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/mascot/norie_mascot_host.dart';
import 'package:norie_learning/core/mascot/norie_mascot_scope.dart';
import 'package:norie_learning/features/learning/data/anatomy_study_store.dart';
import 'package:norie_learning/features/learning/domain/anatomy_guided_learning.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_guided_learning_screen.dart';

import 'anatomy_guided_learning_test.dart' show guidedCatalog;

void main() {
  testWidgets(
      'small phone supports skip, resume, assisted practice and honest review',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final catalog = guidedCatalog();
    final store = AnatomyStudyStore(
        catalog: catalog,
        ownerId: () => 'learner',
        read: (_) async => null,
        write: (_, __) async {});
    await store.initialize();
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
            child: AnatomyGuidedLearningScreen(
                catalog: catalog,
                initialStructureId: 'bp-FJ3365',
                store: store))));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Discover'), findsWidgets);
    final initialModel = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    expect(initialModel.reference, 'male');
    expect(initialModel.target, 'bp-FJ3365');
    expect(initialModel.systems, {'skeletal'});
    await tester.ensureVisible(find.text('Skip this step'));
    await tester.tap(find.text('Skip this step'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(store.current!.step.name, 'locate');
    store.goToStep(AnatomyStudyStep.understand);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('Description unavailable'), findsOneWidget);
    store.goToStep(AnatomyStudyStep.practice);
    await tester.pump(const Duration(milliseconds: 100));
    final answerFinder = find.byKey(const ValueKey('answer-bp-FJ3365'));
    expect(tester.widget<OutlinedButton>(answerFinder).onPressed, isNull);
    tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView))
        .onLoaded!(true);
    await tester.pump();
    await tester.ensureVisible(find.text('Show help'));
    await tester.tap(find.text('Show help'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.ensureVisible(find.byKey(const ValueKey('answer-bp-FJ3365')));
    await tester.tap(find.byKey(const ValueKey('answer-bp-FJ3365')));
    await tester.pump(const Duration(milliseconds: 100));
    expect(store.current!.independentAttempts, 0);
    store.goToStep(AnatomyStudyStep.review);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('Unfinished'), findsOneWidget);
    expect(find.textContaining('mastery'), findsWidgets);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    store.dispose();
  });

  testWidgets('old model selections cannot identify a new owner session',
      (tester) async {
    final owner = ValueNotifier<String?>('a');
    final catalog = guidedCatalog();
    final store = AnatomyStudyStore(
        catalog: catalog,
        ownerId: () => owner.value,
        ownerChanges: owner,
        read: (_) async => null,
        write: (_, __) async {});
    await store.initialize();
    store.select('bp-FJ3365');
    store.goToStep(AnatomyStudyStep.locate);
    await tester.pumpWidget(MaterialApp(
        home: AnatomyGuidedLearningScreen(catalog: catalog, store: store)));
    await tester.pump();
    final oldModel = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    owner.value = 'b';
    owner.value = 'a';
    await store.initialize();
    store.select('bp-FJ3365');
    store.goToStep(AnatomyStudyStep.locate);
    await tester.pump();
    oldModel.onSelected!('bp-FJ3365');
    expect(store.current!.identified, isFalse);
    tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView))
        .onSelected!('bp-FJ3365');
    expect(store.current!.identified, isTrue);
    await tester.pumpWidget(const SizedBox());
    store.dispose();
    owner.dispose();
  });

  testWidgets('chooser remount blocks checks until the new model is loaded',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final catalog = guidedCatalog();
    final store = AnatomyStudyStore(
        catalog: catalog,
        ownerId: () => 'a',
        read: (_) async => null,
        write: (_, __) async {});
    await store.initialize();
    store.select('bp-FJ3365');
    store.goToStep(AnatomyStudyStep.practice);
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
            child:
                AnatomyGuidedLearningScreen(catalog: catalog, store: store))));
    await tester.pump();
    final oldModel = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    oldModel.onLoaded!(true);
    await tester.pump();
    final answer = find.byKey(const ValueKey('answer-bp-FJ3365'));
    expect(tester.widget<OutlinedButton>(answer).onPressed, isNotNull);
    await tester.ensureVisible(find.text('Choose another guide'));
    await tester.tap(find.text('Choose another guide'));
    await tester.pump();
    expect(find.byType(AnatomyAtlasModelView), findsNothing);
    oldModel.onLoaded!(true);
    await tester.pump();
    await tester.ensureVisible(find.text('Resume current guide'));
    await tester.tap(find.text('Resume current guide'));
    await tester.pump();
    expect(tester.widget<OutlinedButton>(answer).onPressed, isNull);
    final replacement = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    oldModel.onLoaded!(true);
    await tester.pump();
    expect(tester.widget<OutlinedButton>(answer).onPressed, isNull);
    replacement.onLoaded!(false);
    await tester.pump();
    expect(tester.widget<OutlinedButton>(answer).onPressed, isNull);
    replacement.onLoaded!(true);
    await tester.pump();
    expect(tester.widget<OutlinedButton>(answer).onPressed, isNotNull);
    oldModel.onLoaded!(false);
    await tester.pump();
    expect(tester.widget<OutlinedButton>(answer).onPressed, isNotNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    store.dispose();
  });

  testWidgets(
      'explicit Explorer target overrides restored selection and retains target step',
      (tester) async {
    final memory = <String, String>{};
    final catalog = guidedCatalog();
    AnatomyStudyStore makeStore() => AnatomyStudyStore(
        catalog: catalog,
        ownerId: () => 'a',
        read: (key) async => memory[key],
        write: (key, value) async {
          memory[key] = value;
        });
    final first = makeStore();
    await first.initialize();
    first.select('bp-FJ2541');
    first.goToStep(AnatomyStudyStep.apply);
    first.select('bp-FJ3365');
    await first.flush();
    first.dispose();
    final restored = makeStore();
    await tester.pumpWidget(MaterialApp(
        home: AnatomyGuidedLearningScreen(
            catalog: catalog,
            initialStructureId: 'bp-FJ2541',
            store: restored)));
    await tester.pump(const Duration(milliseconds: 100));
    expect(restored.current?.structureId, 'bp-FJ2541');
    expect(restored.current?.step, AnatomyStudyStep.apply);
    expect(
        tester
            .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView))
            .target,
        'bp-FJ2541');
    await tester.pumpWidget(const SizedBox());
    restored.dispose();
  });

  testWidgets(
      'mascot hint stays assisted across Apply and Practice revisits at 320px',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final catalog = guidedCatalog();
    final memory = <String, String>{};
    final store = AnatomyStudyStore(
        catalog: catalog,
        ownerId: () => 'a',
        read: (key) async => memory[key],
        write: (key, value) async {
          memory[key] = value;
        });
    await store.initialize();
    store.select('bp-FJ3365');
    store.goToStep(AnatomyStudyStep.practice);
    await tester.pumpWidget(MaterialApp(
        builder: (_, child) => NorieMascotHost(child: child!),
        home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
            child:
                AnatomyGuidedLearningScreen(catalog: catalog, store: store))));
    await tester.pump(const Duration(milliseconds: 100));
    final scope = NorieMascotScope.of(
        tester.element(find.byType(AnatomyGuidedLearningScreen)));
    tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView))
        .onLoaded!(true);
    await tester.pump();
    await tester.ensureVisible(find.text('Show help'));
    await tester.tap(find.text('Show help'));
    await tester.pump();
    expect(scope.controller.speech, contains('Right femur'));
    await store.flush();
    final reloaded = AnatomyStudyStore(
        catalog: catalog,
        ownerId: () => 'a',
        read: (key) async => memory[key],
        write: (key, value) async {
          memory[key] = value;
        });
    await reloaded.initialize();
    reloaded.recordCheck(correct: true, assisted: false);
    expect(reloaded.current!.independentAttempts, 0);
    reloaded.dispose();
    store.goToStep(AnatomyStudyStep.apply);
    await tester.pump();
    expect(scope.controller.speech, isNull);
    tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView))
        .onLoaded!(true);
    await tester.pump();
    await tester.ensureVisible(find.byKey(const ValueKey('system-skeletal')));
    await tester.tap(find.byKey(const ValueKey('system-skeletal')));
    await tester.pump();
    expect(store.current!.independentAttempts, 0);
    expect(store.current!.assistedAttempts, 1);
    store.goToStep(AnatomyStudyStep.practice);
    await tester.pump();
    tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView))
        .onLoaded!(true);
    await tester.pump();
    await tester.ensureVisible(find.byKey(const ValueKey('answer-bp-FJ3365')));
    await tester.tap(find.byKey(const ValueKey('answer-bp-FJ3365')));
    await tester.pump();
    expect(store.current!.independentAttempts, 0);
    expect(store.current!.assistedAttempts, 2);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    store.dispose();
  });
}
