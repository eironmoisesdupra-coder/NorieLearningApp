import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/mascot/norie_mascot_controller.dart';
import 'package:norie_learning/core/mascot/norie_mascot_host.dart';
import 'package:norie_learning/core/mascot/norie_mascot_scope.dart';
import 'package:norie_learning/core/audio/norie_audio_settings_screen.dart';
import 'package:norie_learning/features/navigation/presentation/norie_tutorial_navigation.dart';
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

  test('complete guide covers every chapter with unique actionable steps', () {
    final guide = NorieTutorialCatalog.complete;
    expect(NorieTutorialCatalog.chapters.length, 18);
    expect(guide.steps.length, greaterThanOrEqualTo(50));
    expect(
        guide.steps.map((step) => step.id).toSet().length, guide.steps.length);
    for (final chapter in NorieTutorialCatalog.chapters) {
      expect(chapter.steps.length, greaterThanOrEqualTo(2));
      expect(guide.steps.where((step) => step.section == chapter.title).length,
          chapter.steps.length);
    }
    for (final step in guide.steps) {
      expect(step.title, isNot('Norie Guide'));
      expect(step.message.length, greaterThan(60));
      expect(step.targetId, isNotNull);
      expect(step.destination, isNotNull);
      expect(step.location, isNotEmpty);
    }
  });

  testWidgets(
      'guided routes highlight their location and preserve underlying work',
      (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final navigation = NorieTutorialNavigation(navigatorKey);
    final draft = TextEditingController(text: 'Keep my notes');
    late NorieTutorialCoordinator coordinator;
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navigatorKey,
      builder: (context, child) =>
          NorieMascotHost(onTutorialStep: navigation.showStep, child: child!),
      home: Builder(builder: (context) {
        coordinator = NorieMascotScope.maybeOf(context)!.tutorialCoordinator;
        return Scaffold(body: TextField(controller: draft));
      }),
    ));
    final guide = NorieTutorialCatalog.complete;
    final index = guide.steps.indexWhere((step) => step.id == 'settings-audio');
    coordinator.browse(section: NorieTutorialCatalog.settings);
    await tester.pump();
    coordinator.goTo(index);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    expect(
        coordinator.targetRect(coordinator.currentStep?.targetId), isNotNull);
    expect(find.byType(NorieAudioSettingsScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('norie-tutorial-target-highlight')),
        findsOneWidget);
    expect(find.text('Menu > Settings > Sound'), findsOneWidget);
    expect(find.byTooltip('Focus area'), findsOneWidget);
    final semantics = tester.ensureSemantics();
    await tester.tap(find.widgetWithText(TextButton, 'Close'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    expect(find.byType(NorieAudioSettingsScreen), findsNothing);
    expect(find.text('Keep my notes'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
    draft.dispose();
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

  test('guide supports back and topic jumps without completing it', () async {
    final controller = NorieMascotController();
    final store = NorieTutorialStore();
    final coordinator =
        NorieTutorialCoordinator(controller: controller, store: store);
    await coordinator.replay(definition);
    coordinator.previous();
    expect(coordinator.currentIndex, 0);
    coordinator.goTo(1);
    expect(coordinator.currentStep?.id, 'subjects');
    coordinator.goTo(99);
    expect(coordinator.currentIndex, 1);
    coordinator.previous();
    expect(coordinator.currentStep?.id, 'welcome');
    expect(await store.isComplete(definition.id), isFalse);
    expect(await coordinator.startIfNeeded(NorieTutorialCatalog.home), isFalse);
    expect(coordinator.activeDefinition, definition);
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

  testWidgets('tutorial spotlight tracks its target while content scrolls',
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
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    const SizedBox(height: 500),
                    SizedBox(
                      key: targetKey,
                      height: 100,
                      child: const Text('Tracked target'),
                    ),
                    const SizedBox(height: 900),
                  ],
                ),
              ),
              NorieTutorialOverlay(
                coordinator: coordinator,
              ),
            ],
          ),
        ),
      ),
    );

    coordinator.registerTarget('learn.hero', targetKey);
    await coordinator.replay(definition);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 420));

    final highlight =
        find.byKey(const ValueKey('norie-tutorial-target-highlight'));
    expect(highlight, findsOneWidget);
    final before = tester.getTopLeft(highlight);

    scrollController.jumpTo(
      (scrollController.offset + 80)
          .clamp(
            0.0,
            scrollController.position.maxScrollExtent,
          )
          .toDouble(),
    );
    await tester.pump(const Duration(milliseconds: 32));

    final after = tester.getTopLeft(highlight);
    expect(after.dy, isNot(equals(before.dy)));
    expect(
      find.byKey(const ValueKey('norie-tutorial-live-spotlight')),
      findsOneWidget,
    );

    coordinator.dispose();
    controller.dispose();
    scrollController.dispose();
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

  testWidgets('guide contents search jumps to a topic and supports back',
      (tester) async {
    final controller = NorieMascotController();
    final coordinator = NorieTutorialCoordinator(
        controller: controller, store: NorieTutorialStore());
    coordinator.browse(section: NorieTutorialCatalog.anatomy);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: NorieTutorialOverlay(coordinator: coordinator))));
    await tester.enterText(find.byType(TextField), 'Again, Hard');
    await tester.pump();
    await tester.tap(find.text('Again, Hard, or Got it'));
    await tester.pump();
    expect(coordinator.currentStep?.id, 'review-rate');
    expect(find.text('Contents'), findsOneWidget);
    await tester.tap(find.byTooltip('Previous step'));
    await tester.pump();
    expect(coordinator.currentStep?.id, 'review-reveal');
    await tester.tap(find.text('Contents'));
    await tester.pump();
    expect(find.text('App guide'), findsOneWidget);
    await tester.tap(find.text('Start tutorial'));
    await tester.pump();
    expect(coordinator.currentStep?.id, 'start-tour');
    await tester.tap(find.text('Close'));
    await tester.pump();
    expect(coordinator.isActive, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
    coordinator.dispose();
    controller.dispose();
  });

  testWidgets('registered top target fits a short landscape viewport',
      (tester) async {
    tester.view.physicalSize = const Size(640, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = NorieMascotController();
    final coordinator = NorieTutorialCoordinator(
        controller: controller, store: NorieTutorialStore());
    final targetKey = GlobalKey();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: Stack(children: [
        Positioned(top: 18, left: 20,
            child: SizedBox(key: targetKey, width: 48, height: 48)),
        NorieTutorialOverlay(coordinator: coordinator),
      ])),
    ));
    coordinator.registerTarget('home.menu', targetKey);
    await coordinator.replay(NorieTutorialCatalog.home);
    await tester.pump();
    expect(coordinator.targetRect('home.menu'), isNotNull);
    expect(tester.takeException(), isNull);
    expect(find.text('Next'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(coordinator.currentIndex, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    coordinator.dispose();
    controller.dispose();
  });

  testWidgets('long guide steps fit a small screen with large text',
      (tester) async {
    tester.view.reset();
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = NorieMascotController();
    final coordinator = NorieTutorialCoordinator(
        controller: controller, store: NorieTutorialStore());
    await coordinator.replay(NorieTutorialCatalog.complete);
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(2)),
            child: child!),
        home: Scaffold(body: NorieTutorialOverlay(coordinator: coordinator))));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('Next'), findsOneWidget);
    await tester.tap(find.text('Contents'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    coordinator.dispose();
    controller.dispose();
  });

  testWidgets(
      'first run starts the full guide and question mark opens section help',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => NorieMascotHost(child: child!),
      home: Scaffold(
          body: NorieTutorialEntry(
        definition: NorieTutorialCatalog.complete,
        child: const NorieTutorialReplayButton(
            definition: NorieTutorialCatalog.profile),
      )),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Welcome to Norie Learning'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byTooltip('Tutorial & help'));
    await tester.pump();
    expect(find.text('App guide'), findsOneWidget);
    await tester.tap(find.text('Continue guide'));
    await tester.pump();
    expect(find.text('Your learner summary'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pump();
    expect(
        await NorieTutorialStore().isComplete(NorieTutorialCatalog.complete.id),
        isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
