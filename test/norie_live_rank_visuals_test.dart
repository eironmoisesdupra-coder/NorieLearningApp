import 'dart:convert';
import 'dart:ui' as ui;
import 'package:norie_learning/core/widgets/norie_rank_motif.dart';
import 'package:norie_learning/features/profile/domain/norie_profile_appearance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/widgets/norie_reward_feedback.dart';
import 'package:norie_learning/core/theme/norie_theme.dart';
import 'package:norie_learning/features/profile/data/norie_profile_appearance_store.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/presentation/norie_science_adventure_map.dart';

void main() {
  testWidgets('five owned ranks draw distinct shapes even without rank colors',
      (tester) async {
    final images = <String>{};
    for (final id in [
      'explorer',
      'curious',
      'scholar',
      'specialist',
      'master'
    ]) {
      final art = NorieRankMotifPainter(
          bundle: NorieRankBundle(
        id,
        id,
        1,
        'norie',
        'welcome',
        const [Colors.white],
        1,
        1,
        '',
        '',
        '',
        '',
      ));
      final recorder = ui.PictureRecorder();
      art.paint(Canvas(recorder), const Size(132, 132));
      final picture = recorder.endRecording();
      await tester.runAsync(() async {
        final image = await picture.toImage(132, 132);
        final bytes =
            await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        final rgba = bytes!.buffer.asUint8List();
        expect(rgba.any((value) => value > 0), isTrue,
            reason: '$id has visible art');
        images.add(base64Encode(rgba));
        image.dispose();
      });
      picture.dispose();
    }
    expect(images.length, 5,
        reason: 'Rank shapes must vary, not just labels or colors');
  });
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    NorieProfileAppearanceStore.instance.applyValidatedState({});
  });
  tearDown(() => NorieProfileAppearanceStore.instance.applyValidatedState({}));

  testWidgets('live map trail follows permanent rank even with default avatar',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: NorieTheme.dark,
        home: Scaffold(
            body: NorieScienceAdventureMap(
          grade: NorieFoundationCurriculum.gradeLevels.first,
          accent: NorieColors.green,
        ))));
    await tester.pump();
    expect(find.byKey(const ValueKey('rank-trail-explorer')), findsOneWidget);
    for (final rank in {
      5: 'curious',
      15: 'scholar',
      30: 'specialist',
      50: 'master'
    }.entries) {
      NorieProfileAppearanceStore.instance.applyValidatedState(
          {'appearance': <String, dynamic>{}, 'rankLevel': rank.key});
      await tester.pump();
      expect(find.byKey(ValueKey('rank-trail-${rank.value}')), findsOneWidget);
      expect(NorieProfileAppearanceStore.instance.value.avatarId, 'norie');
    }
    await tester.pumpWidget(const SizedBox());
  });

  for (final rank in {
    1: 'explorer',
    5: 'curious',
    15: 'scholar',
    30: 'specialist',
    50: 'master'
  }.entries) {
    testWidgets(
        '${rank.value} reward uses owned celebration with reduced motion',
        (tester) async {
      NorieProfileAppearanceStore.instance.applyValidatedState(
          {'appearance': <String, dynamic>{}, 'rankLevel': rank.key});
      await tester.pumpWidget(MaterialApp(
          theme: NorieTheme.dark,
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Builder(
                builder: (context) => Scaffold(
                        body: TextButton(
                      onPressed: () =>
                          NorieRewardPopup.show(context, credits: 0, xp: 25),
                      child: const Text('Claim'),
                    ))),
          )));
      await tester.tap(find.text('Claim'));
      await tester.pump();
      expect(find.byKey(ValueKey('rank-celebration-${rank.value}')),
          findsOneWidget);
      expect(find.text('+25 XP'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(milliseconds: 2200));
      await tester.pumpWidget(const SizedBox());
    });
  }
}
