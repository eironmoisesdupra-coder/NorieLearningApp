import 'package:flutter/material.dart';

import '../core/theme/norie_theme.dart';
import '../features/onboarding/presentation/onboarding_flow.dart';

class NorieApp extends StatelessWidget {
  const NorieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Norie Learning',
      debugShowCheckedModeBanner: false,
      theme: NorieTheme.dark,
      home: const SplashScreen(),
    );
  }
}
