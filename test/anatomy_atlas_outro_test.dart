import 'atlas_quiz_test_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_quiz_screen.dart';

void main() {
  setUp(prepareAtlasWidgetTest);
  testWidgets('atlas completion reviews mistakes and awards earned XP once',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.runAsync(NorieProgression.instance.load);
    final before = NorieProgression.instance.totalXp;
    final catalog = AnatomyAtlasCatalog.fromJson({
      'schemaVersion': 1,
      'references': [
        {'id': 'male', 'label': 'male', 'description': ''}
      ],
      'structures': [
        for (var i = 0; i < 4; i++)
          {
            'id': 's$i',
            'name': 'Structure $i',
            'reference': 'male',
            'systems': ['skeletal'],
            'asset': 'bones',
            'source': 'test'
          }
      ],
    });
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: child!,
      ),
      home: Builder(
          builder: (context) => Scaffold(
                  body: TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (_) => AnatomyAtlasQuizScreen(
                            catalog: catalog,
                            reference: 'male',
                            systems: const {'skeletal'}))),
                child: const Text('Open atlas quiz'),
              ))),
    ));
    await tester.tap(find.text('Open atlas quiz'));
    await tester.pump();
    await waitForAtlasIo(tester);
    await tester.pump(const Duration(milliseconds: 400));
    await waitForAtlasIo(tester);
    expect(find.byKey(const ValueKey('atlas-quiz-hint')), findsNothing);
    await tester.tap(find.byTooltip('Need a hint?'));
    await tester.pump();
    await waitForAtlasIo(tester);
    expect(find.byKey(const ValueKey('atlas-quiz-hint')), findsOneWidget);
    expect(find.textContaining('overall proportions'), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      final viewer = tester
          .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
      viewer.onLoaded!(true);
      await tester.pump();
      await waitForAtlasIo(tester);
      final target =
          catalog.structures.firstWhere((s) => s.id == viewer.target);
      final answer = i == 0
          ? catalog.structures.firstWhere((s) => s.id != target.id).name
          : target.name;
      await tester.ensureVisible(find.text(answer));
      await tester.tap(find.text(answer));
      await tester.pump();
      await waitForAtlasIo(tester);
      await tester.ensureVisible(find.text('Check answer'));
      await tester.tap(find.text('Check answer'));
      await tester.pump();
      await waitForAtlasIo(tester);
      final next = find.text(i == 3 ? 'Finish quiz' : 'Next structure');
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pump();
      await waitForAtlasIo(tester);
      await tester.pump(const Duration(milliseconds: 400));
      await waitForAtlasIo(tester);
      expect(find.byKey(const ValueKey('atlas-quiz-hint')), findsNothing);
    }
    expect(find.byKey(const ValueKey('quiz-outro')), findsOneWidget);
    expect(NorieProgression.instance.totalXp, before + 30);
    await tester.ensureVisible(find.text('Review Mistakes'));
    await tester.tap(find.text('Review Mistakes'));
    await tester.pump();
    await waitForAtlasIo(tester);
    await tester.pump(const Duration(milliseconds: 400));
    await waitForAtlasIo(tester);
    expect(find.text('Which anatomical structure is shown?'), findsOneWidget);
    expect(find.textContaining('Your answer:'), findsOneWidget);
    final back = find.text('Back to results');
    await tester.scrollUntilVisible(back, 200,
        scrollable: find
            .descendant(
                of: find.byType(DraggableScrollableSheet),
                matching: find.byType(Scrollable))
            .first);
    await tester.drag(
        find.byType(DraggableScrollableSheet), const Offset(0, -200));
    await tester.pump(const Duration(milliseconds: 400));
    await waitForAtlasIo(tester);
    await tester.tap(back);
    await tester.pump();
    await waitForAtlasIo(tester);
    await tester.pump(const Duration(milliseconds: 400));
    await waitForAtlasIo(tester);
    await tester.ensureVisible(find.text('Continue'));
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await waitForAtlasIo(tester);
    await tester.pump(const Duration(milliseconds: 400));
    await waitForAtlasIo(tester);
    await tester.pump(const Duration(milliseconds: 400));
    await waitForAtlasIo(tester);
    expect(find.text('Open atlas quiz'), findsOneWidget);
    expect(NorieProgression.instance.totalXp, before + 30);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
