import 'package:flutter/material.dart';

import '../../theme/norie_theme.dart';
import 'norie_tutorial_models.dart';

/// Bundled vector chapter stickers, with no image download or continuous ticker.
class NorieTutorialChapterArt extends StatelessWidget {
  const NorieTutorialChapterArt({required this.destination, super.key});
  final NorieTutorialDestination? destination;

  static IconData iconFor(NorieTutorialDestination? destination) =>
      switch (destination) {
        NorieTutorialDestination.learn => Icons.explore_rounded,
        NorieTutorialDestination.lesson => Icons.auto_stories_rounded,
        NorieTutorialDestination.aiStudy => Icons.auto_awesome_rounded,
        NorieTutorialDestination.library => Icons.style_rounded,
        NorieTutorialDestination.anatomy => Icons.accessibility_new_rounded,
        NorieTutorialDestination.challenge => Icons.flag_rounded,
        NorieTutorialDestination.progress => Icons.insights_rounded,
        NorieTutorialDestination.profile => Icons.face_rounded,
        NorieTutorialDestination.account => Icons.cloud_done_rounded,
        NorieTutorialDestination.shop => Icons.storefront_rounded,
        NorieTutorialDestination.settings => Icons.tune_rounded,
        _ => Icons.rocket_launch_rounded,
      };

  static String nextMove(NorieTutorialStep step) => switch (step.destination) {
        NorieTutorialDestination.library =>
          'Try the highlighted sample. Your real study sets stay unchanged.',
        NorieTutorialDestination.learn =>
          'Spot the subject or study tool you want to explore next.',
        NorieTutorialDestination.lesson =>
          'Find the lesson controls. You can try them after closing this guide.',
        NorieTutorialDestination.aiStudy =>
          'Look at the options. No upload or AI request is needed for this tour.',
        NorieTutorialDestination.anatomy =>
          'Find the viewer controls for your next anatomy investigation.',
        NorieTutorialDestination.challenge =>
          'Choose a challenge to try after the tour. There is no timer here.',
        NorieTutorialDestination.progress =>
          'Find one learning goal you would like to work toward.',
        NorieTutorialDestination.profile =>
          'Find where your learning identity and earned rewards live.',
        NorieTutorialDestination.account =>
          'Check what stays on this device and what an account can sync.',
        NorieTutorialDestination.shop =>
          'Explore the reward options. This guide never spends credits.',
        NorieTutorialDestination.settings =>
          'Find the controls that make learning comfortable for you.',
        _ => 'Follow the spotlight, or use Contents to pick your own route.',
      };

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 52,
      child: Stack(alignment: Alignment.center, children: [
        Transform.rotate(
          angle: -.1,
          child: Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: NorieColors.violet.withValues(alpha: .24),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF164E63), Color(0xFF183463)]),
            border: Border.all(color: NorieColors.cyan.withValues(alpha: .7)),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(iconFor(destination), color: NorieColors.cyan, size: 27),
        ),
        const Positioned(
            right: 0,
            top: 0,
            child:
                Icon(Icons.star_rounded, color: Color(0xFFFFD477), size: 14)),
        const Positioned(
            left: 0,
            bottom: 1,
            child: Icon(Icons.circle, color: NorieColors.violet, size: 7)),
      ]),
    );
  }
}
