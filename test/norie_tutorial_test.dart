import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/mascot/norie_mascot_controller.dart';
import 'package:norie_learning/core/mascot/norie_mascot_state.dart';
import 'package:norie_learning/core/mascot/tutorial/norie_tutorial_coordinator.dart';
import 'package:norie_learning/core/mascot/tutorial/norie_tutorial_models.dart';
import 'package:norie_learning/core/mascot/tutorial/norie_tutorial_overlay.dart';
import 'package:norie_learning/core/mascot/tutorial/norie_tutorial_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const definition = NorieTutorialDefinition(
    id: 'learn.v1',
    steps: [
      NorieTutorialStep(
        id: 'welcome',
        targetId: 'learn.hero',
        mascotState: NorieMascotState.guiding,
        message: 'This is your learning hub.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
      NorieTutorialStep(
        id: 'subjects',
        targetId: 'learn.subjects',
        mascotState: NorieMascotState.pointing,
        message: 'Choose a subject to begin.',
        preferredPosition: NorieTutorialPosition.bottom,
      ),
    ],
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('incomplete tutorial auto-starts once and completion persists',
      () async {
    final controller = NorieMascotController();
    final store = NorieTutorialStore();
    final coordinator = NorieTutorialCoordinator(
      controller: controller,
      store: store,
    );

    expect(await coordinator.startIfNeeded(definition), isTrue);
    expect(coordinator.isActive, isTrue);
    expect(coordinator.currentStep?.id, 'welcome');

    await coordinator.skip();

    expect(await store.isComplete(definition.id), isTrue);
    expect(coordinator.isActive, isFalse);
    expect(await coordinator.startIfNeeded(definition), isFalse);

    coordinator.dispose();
    controller.dispose();
  });

  test('replay starts a tutorial even after it was completed', () async {
    final controller = NorieMascotController();
    final store = NorieTutorialStore();
    await store.markComplete(definition.id);

    final coordinator = NorieTutorialCoordinator(
      controller: controller,
      store: store,
    );

    await coordinator.replay(definition);

    expect(coordinator.isActive, isTrue);
    expect(coordinator.currentStep?.id, 'welcome');
    expect(await store.isComplete(definition.id), isTrue);

    coordinator.dispose();
    controller.dispose();
  });

  test('next completes final step and keeps persisted completion', () async {
    final controller = NorieMascotController();
    final store = NorieTutorialStore();
    final coordinator = NorieTutorialCoordinator(
      controller: controller,
      store: store,
    );

    await coordinator.replay(definition);
    await coordinator.next();

    expect(coordinator.currentStep?.id, 'subjects');
    expect(coordinator.isActive, isTrue);

    await coordinator.next();

    expect(coordinator.isActive, isFalse);
    expect(await store.isComplete(definition.id), isTrue);

    coordinator.dispose();
    controller.dispose();
  });


  testWidgets('tutorial automatically scrolls its registered target into view',
      (tester) async {
    final controller = NorieMascotController();
    final coordinator = NorieTutorialCoordinator(
      controller: controller,
      store: NorieTutorialStore(),
    );
    final scrollController = ScrollController();
    final targetKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(height: 1200),
                SizedBox(
                  key: targetKey,
                  height: 80,
                  child: const Text('Tutorial target'),
                ),
                const SizedBox(height: 300),
              ],
            ),
          ),
        ),
      ),
    );

    coordinator.registerTarget('learn.hero', targetKey);
    await coordinator.replay(definition);
    await tester.pump();
    await tester.pumpAndSettle();

    expect(scrollController.offset, greaterThan(0));

    coordinator.dispose();
    controller.dispose();
    scrollController.dispose();
  });

  testWidgets('active tutorial locks background scrolling and input',
      (tester) async {
    final controller = NorieMascotController();
    final coordinator = NorieTutorialCoordinator(
      controller: controller,
      store: NorieTutorialStore(),
    );
    await coordinator.replay(definition);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NorieTutorialOverlay(
            coordinator: coordinator,
          ),
        ),
      ),
    );
    await tester.pump();

    final lock = tester.widget<AbsorbPointer>(
      find.byKey(const ValueKey('norie-tutorial-input-lock')),
    );
    expect(lock.absorbing, isTrue);

    coordinator.dispose();
    controller.dispose();
  });

  testWidgets('missing target falls back to a centered tutorial card',
      (tester) async {
    final controller = NorieMascotController();
    final coordinator = NorieTutorialCoordinator(
      controller: controller,
      store: NorieTutorialStore(),
    );
    const missingTarget = NorieTutorialDefinition(
      id: 'missing-target.v1',
      steps: [
        NorieTutorialStep(
          id: 'step',
          targetId: 'does.not.exist',
          mascotState: NorieMascotState.guiding,
          message: 'I can still guide you.',
          preferredPosition: NorieTutorialPosition.auto,
        ),
      ],
    );

    await coordinator.replay(missingTarget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NorieTutorialOverlay(
            coordinator: coordinator,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const ValueKey('norie-tutorial-card')),
      findsOneWidget,
    );
    expect(find.text('I can still guide you.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    coordinator.dispose();
    controller.dispose();
  });
}
