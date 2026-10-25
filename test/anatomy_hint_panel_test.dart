import 'atlas_quiz_test_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/learning/domain/anatomy_hint_library.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_hint_panel.dart';
import 'anatomy_hint_library_test.dart' as fixtures;
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_quiz_screen.dart';

void main() {
  setUp(prepareAtlasWidgetTest);
  for (final changedAsset in [false, true]) {
    testWidgets(
        'quiz binds structural help to current renderer and asset (changed=$changedAsset)',
        (tester) async {
      final json = fixtures.hintCatalogFixture();
      json['references'] = [
        {'id': 'test-reference', 'label': 'Fixture', 'description': 'Test only'}
      ];
      for (final row in json['structures'] as List) {
        row['source'] = 'test-only';
      }
      if (changedAsset) {
        (json['assets'] as List)[0]['sha256'] = 'b' * 64;
      }
      final left = AnatomyHintRecord.fromJson(fixtures.hintRecordFixture());
      final rightJson = fixtures.hintRecordFixture()
        ..['canonicalName'] = 'Right test bone'
        ..['laterality'] = 'right';
      rightJson['identity'] = {
        ...rightJson['identity'] as Map<String, dynamic>,
        'structureId': 'right',
        'meshIds': ['mesh-right']
      };
      final rightHash = AnatomyHintRecord.fromJson(rightJson).computedHash;
      rightJson['contentHash'] = rightHash;
      rightJson['approvalHash'] = rightHash;
      final right = AnatomyHintRecord.fromJson(rightJson);
      final library = fixtures.hintLibraryFixture(records: [
        left,
        right,
        AnatomyHintRecord.fromJson({...left.toJson(), 'status': 'retired'}),
        AnatomyHintRecord.fromJson({...right.toJson(), 'status': 'rejected'}),
      ], approvals: [
        fixtures.hintApprovalFixture(left),
        fixtures.hintApprovalFixture(right),
      ]);
      await tester.pumpWidget(MaterialApp(
          home: AnatomyAtlasQuizScreen(
        catalog: AnatomyAtlasCatalog.fromJson(json),
        reference: 'test-reference',
        systems: const {'skeletal'},
        requestedCount: 5,
        hints: library,
      )));
      await waitForAtlasIo(tester);
      await tester.tap(find.byTooltip('Need a hint?'));
      await tester.pump();
      await waitForAtlasIo(tester);
      await tester.ensureVisible(find.text('Structure clue · Free'));
      await tester.tap(find.text('Structure clue · Free'));
      await tester.pump();
      await waitForAtlasIo(tester);
      expect(find.text(left.structuralHint), findsNothing);
      final viewer = tester
          .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
      viewer.onLoaded!(true);
      await tester.pump();
      await waitForAtlasIo(tester);
      expect(find.text(left.structuralHint),
          changedAsset ? findsNothing : findsOneWidget);
      if (!changedAsset) {
        viewer.onLoaded!(false);
        await tester.pump();
        await waitForAtlasIo(tester);
        expect(find.text(left.structuralHint), findsNothing);
      }
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  Widget host(
          {AnatomyHintResult? assistance, Key? key, bool Function()? guard}) =>
      MaterialApp(
          home: Scaffold(
              body: SingleChildScrollView(
                  child: AnatomyAtlasHintPanel(
        key: key,
        assistance: assistance,
        stillCurrent: guard,
      ))));

  testWidgets('general guidance has its own screenreader paragraph',
      (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(host());
    final guidance =
        tester.getSemantics(find.text(AnatomyHintLibrary.generalGuidance));
    expect(guidance.label, AnatomyHintLibrary.generalGuidance);
    handle.dispose();
  });

  testWidgets('general help is free and the detailed hint has no action',
      (tester) async {
    await tester.pumpWidget(host());
    expect(find.text(AnatomyHintLibrary.generalGuidance), findsOneWidget);
    final locked = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Detailed hint · Locked'));
    expect(locked.onPressed, isNull);
    await tester.tap(find.text('Structure clue · Free'));
    await tester.pump();
    expect(find.textContaining('not ready'), findsOneWidget);
    expect(find.text(AnatomyHintLibrary.generalGuidance), findsOneWidget);
    expect(find.textContaining('5 Credits'), findsOneWidget);
  });

  testWidgets('only eligible exact structural content can be revealed',
      (tester) async {
    final result =
        fixtures.hintLibraryFixture().lookup(fixtures.hintRequestFixture());
    await tester.pumpWidget(host(assistance: result));
    expect(find.text(result.record!.structuralHint), findsNothing);
    await tester.tap(find.text('Structure clue · Free'));
    await tester.pump();
    expect(find.text(result.record!.structuralHint), findsOneWidget);
    expect(find.textContaining('Synthetic test fixture'), findsNothing);
    expect(find.text(result.record!.detailedHint), findsNothing);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.text('Structure clue · Free'));
      await tester.pump();
    }
    expect(find.text(result.record!.structuralHint), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('untrusted or mismatched content falls back to the free strategy',
      (tester) async {
    final result = fixtures.hintLibraryFixture(
        approvals: []).lookup(fixtures.hintRequestFixture());
    await tester.pumpWidget(host(assistance: result));
    await tester.tap(find.text('Structure clue · Free'));
    await tester.pump();
    expect(find.text('Compare the visible surfaces with the answer options.'),
        findsNothing);
    expect(find.text(AnatomyHintLibrary.generalGuidance), findsOneWidget);
    expect(find.textContaining('untrustedApproval'), findsNothing);
  });

  testWidgets('changing the question drops the previous clue state',
      (tester) async {
    final result =
        fixtures.hintLibraryFixture().lookup(fixtures.hintRequestFixture());
    await tester
        .pumpWidget(host(key: const ValueKey('q1'), assistance: result));
    await tester.tap(find.text('Structure clue · Free'));
    await tester.pump();
    expect(find.text(result.record!.structuralHint), findsOneWidget);
    await tester.pumpWidget(host(key: const ValueKey('q2')));
    expect(find.text(result.record!.structuralHint), findsNothing);
    expect(find.textContaining('not ready'), findsNothing);
  });

  testWidgets(
      'small viewport, enlarged text and reduced motion retain accessible help',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(2),
                disableAnimations: true),
            child: child!),
        home: const Scaffold(
            body: SingleChildScrollView(child: AnatomyAtlasHintPanel()))));
    await tester.ensureVisible(find.text('Structure clue · Free'));
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(find.textContaining('not ready'), findsOneWidget);
    await tester.ensureVisible(find.text('General guidance · Free'));
    await tester.pump();
    expect(find.bySemanticsLabel('General guidance, free'), findsOneWidget);
    semantics.dispose();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'source URLs and section titles cannot disclose the answer before grading',
      (tester) async {
    final json = fixtures.hintRecordFixture();
    json['source'] = {
      'url': 'https://example.org/Left-test-bone',
      'location': 'Fixture alias: Left test bone'
    };
    final hash = AnatomyHintRecord.fromJson(json).computedHash;
    json['contentHash'] = hash;
    json['approvalHash'] = hash;
    final record = AnatomyHintRecord.fromJson(json);
    final result = fixtures.hintLibraryFixture(records: [
      record
    ], approvals: [
      fixtures.hintApprovalFixture(record)
    ]).lookup(fixtures.hintRequestFixture());
    expect(result.status, AnatomyHintAvailability.available);
    await tester.pumpWidget(host(assistance: result));
    await tester.tap(find.text('Structure clue · Free'));
    await tester.pump();
    expect(find.textContaining('https://example.org/Left-test-bone'),
        findsNothing);
    expect(find.textContaining('Fixture alias: Left test bone'), findsNothing);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: AnatomyAtlasHintPanel(
      assistance: result,
      showSourceAfterAnswer: true,
    ))));
    await tester.tap(find.text('Structure clue · Free'));
    await tester.pump();
    expect(find.textContaining('https://example.org/Left-test-bone'),
        findsOneWidget);
  });

  testWidgets('a stale learner action cannot reveal structural content',
      (tester) async {
    var current = true;
    final result =
        fixtures.hintLibraryFixture().lookup(fixtures.hintRequestFixture());
    await tester.pumpWidget(host(assistance: result, guard: () => current));
    final action = tester
        .widget<TextButton>(
            find.widgetWithText(TextButton, 'Structure clue · Free'))
        .onPressed!;
    current = false;
    action();
    await tester.pump();
    expect(find.text(result.record!.structuralHint), findsNothing);
  });
}
