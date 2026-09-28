import 'package:flutter/material.dart';

import '../../../core/account/norie_account_service.dart';
import '../../../core/account/norie_demo_access_service.dart';
import '../../../core/cloud/norie_cloud_sync.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_logo_mark.dart';
import '../../account/presentation/account_screen.dart';
import '../../navigation/presentation/main_shell.dart';
import 'reset_password_screen.dart';

class PrivateDemoGate extends StatelessWidget {
  const PrivateDemoGate({super.key});

  @override
  Widget build(BuildContext context) {
    final account = NorieAccountService.instance;
    final access = NorieDemoAccessService.instance;

    return AnimatedBuilder(
      animation: account,
      builder: (context, _) {
        return AnimatedBuilder(
          animation: access,
          builder: (context, _) {
            return AnimatedBuilder(
              animation: NorieCloudSync.instance,
              builder: (context, _) {
                if (account.isPasswordRecovery) {
                  return const ResetPasswordScreen();
                }

                if (!account.isSignedIn) {
                  return const AccountScreen();
                }

                switch (access.status) {
                  case NorieDemoAccessStatus.allowed:
                    if (NorieCloudSync.instance.isSyncing) {
                      return const _RestoringProgress();
                    }
                    return const MainShell();
                  case NorieDemoAccessStatus.checking:
                    return const _CheckingAccess();
                  case NorieDemoAccessStatus.denied:
                    return _AccessDenied(
                      message: access.message ??
                          'This account is not approved for the private Norie demo.',
                    );
                  case NorieDemoAccessStatus.error:
                    return _AccessDenied(
                      message: access.message ??
                          'Private demo access could not be verified.',
                      canRetry: true,
                    );
                  case NorieDemoAccessStatus.signedOut:
                    return const AccountScreen();
                }
              },
            );
          },
        );
      },
    );
  }
}

class _RestoringProgress extends StatelessWidget {
  const _RestoringProgress();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NorieLogoMark(size: 92),
                SizedBox(height: 24),
                CircularProgressIndicator(),
                SizedBox(height: 18),
                Text(
                  'Restoring your Norie progress…',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'XP, challenges, streaks, mastery, and weak topics are syncing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckingAccess extends StatelessWidget {
  const _CheckingAccess();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NorieLogoMark(size: 92),
                SizedBox(height: 24),
                CircularProgressIndicator(),
                SizedBox(height: 18),
                Text(
                  'Verifying private demo access…',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccessDenied extends StatelessWidget {
  const _AccessDenied({
    required this.message,
    this.canRetry = false,
  });

  final String message;
  final bool canRetry;

  @override
  Widget build(BuildContext context) {
    final account = NorieAccountService.instance;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const NorieLogoMark(size: 96),
                  const SizedBox(height: 22),
                  const Icon(
                    Icons.lock_rounded,
                    size: 48,
                    color: NorieColors.violet,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Private Demo',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: NorieColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    account.email ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: NorieColors.cyan,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (canRetry) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () =>
                            NorieDemoAccessService.instance.refresh(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Check Access Again'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => account.signOut(),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Use Another Account'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
