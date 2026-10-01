import 'package:flutter/material.dart';

import '../../../core/account/norie_account_service.dart';
import '../../navigation/presentation/main_shell.dart';
import 'reset_password_screen.dart';

/// Cloud authentication is optional for bundled and locally saved learning.
/// Password recovery still takes precedence when opened from an email link.
class NorieLearningEntry extends StatelessWidget {
  const NorieLearningEntry({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: NorieAccountService.instance,
        builder: (context, _) => NorieAccountService.instance.isPasswordRecovery
            ? const ResetPasswordScreen()
            : const MainShell(),
      );
}
