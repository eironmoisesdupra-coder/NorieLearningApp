import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/mascot/tutorial/norie_tutorial_models.dart';
import 'package:norie_learning/features/navigation/presentation/norie_tutorial_navigation.dart';
import 'package:norie_learning/features/study/presentation/study_hub_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({
        'norie.study.local.offline.v1': '{"sets":{"keep":"original"}}',
        'norie.profile.appearance.v1': 'keep my profile',
      }));

  testWidgets('all nine library tutorial steps have an offline isolated sample',
      (tester) async {
    final key = GlobalKey<NavigatorState>();
    final navigation = NorieTutorialNavigation(key);
    final preferences = await SharedPreferences.getInstance();
    final before = {
      for (final key in preferences.getKeys()) key: preferences.get(key)
    };
    await tester.pumpWidget(MaterialApp(
      navigatorKey: key,
      home: const Scaffold(body: Text('Original notes draft')),
    ));
    final steps = NorieTutorialCatalog.complete.steps
        .where((step) => step.destination == NorieTutorialDestination.library);
    expect(steps.length, 9);
    for (final step in steps) {
      navigation.showStep(step);
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey('tutorial-sample-${step.id}')), findsOneWidget,
          reason:
              '${step.id} needs a relevant sample rather than a cloud load');
      expect(find.byType(StudyHubScreen), findsNothing);
      expect(find.text('Could not load your study library.'), findsNothing);
      expect(find.text('Practice space'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    navigation.showStep(null);
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Original notes draft'), findsOneWidget);
    expect({for (final key in preferences.getKeys()) key: preferences.get(key)},
        before);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('sample review and Q&A stay local and never write learner data',
      (tester) async {
    final key = GlobalKey<NavigatorState>();
    final navigation = NorieTutorialNavigation(key);
    final preferences = await SharedPreferences.getInstance();
    final before = {
      for (final key in preferences.getKeys()) key: preferences.get(key)
    };
    await tester.pumpWidget(MaterialApp(
      navigatorKey: key,
      home: const Scaffold(body: Text('Original notes draft')),
    ));
    Future<void> show(String id) async {
      navigation.showStep(NorieTutorialCatalog.complete.steps
          .firstWhere((step) => step.id == id));
      await tester.pump();
      await tester.pumpAndSettle();
    }

    await show('review-reveal');
    await tester.tap(find.text('Reveal sample answer'));
    await tester.pump();
    expect(find.text('Water changes from liquid to water vapour.'),
        findsOneWidget);
    await show('qa-source');
    await tester.tap(find.text('Ask sample question'));
    await tester.pump();
    expect(
        find.textContaining('Warmth can speed up evaporation.'), findsWidgets);
    expect(find.text('Example response • no AI request'), findsOneWidget);
    expect({for (final key in preferences.getKeys()) key: preferences.get(key)},
        before);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
