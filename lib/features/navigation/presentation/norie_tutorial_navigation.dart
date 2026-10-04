import 'package:flutter/material.dart';
import '../../../core/audio/norie_audio_settings_screen.dart';
import '../../../core/mascot/tutorial/norie_tutorial_models.dart';
import '../../../core/mascot/tutorial/norie_tutorial_overlay.dart';
import '../../account/presentation/account_screen.dart';
import '../../commerce/presentation/norie_shop_placeholder_screen.dart';
import '../../learning/domain/anatomy_models.dart';
import '../../learning/presentation/anatomy_atlas_screen.dart';
import '../../learning/presentation/atomic_structure_lesson_screen.dart';
import '../../study/presentation/study_generator_screen.dart';
import '../../study/presentation/study_hub_screen.dart';
import 'main_shell.dart';

class NorieTutorialNavigation {
  NorieTutorialNavigation(this.navigatorKey);
  final GlobalKey<NavigatorState> navigatorKey;
  Route<void>? _route;
  NorieTutorialDestination? _destination;
  int _generation = 0;

  void showStep(NorieTutorialStep? step) {
    final destination = step?.destination;
    if (destination == _destination &&
        (_route?.isActive ?? destination == null)) {
      return;
    }
    _destination = destination;
    final generation = ++_generation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (generation != _generation) return;
      final navigator = navigatorKey.currentState;
      if (navigator == null) return;
      final previous = _route;
      if (destination == null) {
        _route = null;
        if (previous?.isActive ?? false) navigator.removeRoute(previous!);
        return;
      }
      final route = MaterialPageRoute<void>(
        settings: RouteSettings(name: 'tutorial/${destination.name}'),
        builder: (_) => PopScope(
          canPop: false,
          child: NorieTutorialTarget(
            id: 'tour.${destination.name}',
            child: switch (destination) {
              NorieTutorialDestination.home => const MainShell(),
              NorieTutorialDestination.learn =>
                const MainShell(initialIndex: 1),
              NorieTutorialDestination.challenge =>
                const MainShell(initialIndex: 2),
              NorieTutorialDestination.progress =>
                const MainShell(initialIndex: 3),
              NorieTutorialDestination.profile =>
                const MainShell(initialIndex: 4),
              NorieTutorialDestination.lesson =>
                const AtomicStructureLessonScreen(),
              NorieTutorialDestination.aiStudy => const StudyGeneratorScreen(),
              NorieTutorialDestination.library => const StudyHubScreen(),
              NorieTutorialDestination.anatomy => const AnatomyAtlasScreen(
                  initialSystems: {AnatomySystemId.skeletal}),
              NorieTutorialDestination.account => const AccountScreen(),
              NorieTutorialDestination.shop =>
                const NorieShopPlaceholderScreen(),
              NorieTutorialDestination.settings =>
                const NorieAudioSettingsScreen(),
            },
          ),
        ),
      );
      _route = route;
      if (previous?.isActive ?? false) {
        navigator.replace(oldRoute: previous!, newRoute: route);
      } else {
        navigator.push(route);
      }
    });
    WidgetsBinding.instance.scheduleFrame();
  }
}
