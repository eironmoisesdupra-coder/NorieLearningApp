import 'package:flutter/material.dart';

import '../core/mascot/help/norie_help_models.dart';
import '../core/mascot/norie_mascot_host.dart';
import '../core/theme/norie_theme.dart';
import '../features/learning/presentation/anatomy_lab_placeholder_screen.dart';
import '../features/navigation/presentation/main_shell.dart';
import '../features/onboarding/presentation/onboarding_flow.dart';
import '../features/study/presentation/study_generator_screen.dart';

class NorieApp extends StatefulWidget {
  const NorieApp({super.key});

  @override
  State<NorieApp> createState() => _NorieAppState();
}

class _NorieAppState extends State<NorieApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _navigateFromHelp(NorieHelpDestination destination) {
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;

    switch (destination) {
      case NorieHelpDestination.aiStudy:
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => const StudyGeneratorScreen(),
          ),
        );
      case NorieHelpDestination.anatomy:
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => const AnatomyLabPlaceholderScreen(),
          ),
        );
      case NorieHelpDestination.challenges:
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => const MainShell(initialIndex: 2),
          ),
        );
      case NorieHelpDestination.learn:
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => const MainShell(initialIndex: 1),
          ),
        );
      case NorieHelpDestination.home:
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => const MainShell(),
          ),
        );
      case NorieHelpDestination.replayTutorial:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Norie Learning',
      debugShowCheckedModeBanner: false,
      theme: NorieTheme.dark,
      builder: (context, child) => NorieMascotHost(
        onNavigate: _navigateFromHelp,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const SplashScreen(),
    );
  }
}
