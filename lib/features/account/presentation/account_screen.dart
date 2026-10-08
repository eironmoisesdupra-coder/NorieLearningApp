import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/account/norie_account_service.dart';
import '../../../core/cloud/norie_cloud_sync.dart';
import '../../../core/theme/norie_theme.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _createAccount = false;
  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    if (!email.contains('@')) {
      _show('Enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      _show('Password must be at least 6 characters.');
      return;
    }
    if (_createAccount && name.isEmpty) {
      _show('Enter a display name.');
      return;
    }

    setState(() => _submitting = true);

    final account = NorieAccountService.instance;
    String? result;

    if (_createAccount) {
      result = await account.signUp(
        email: email,
        password: password,
        displayName: name,
      );
    } else {
      result = await account.signIn(
        email: email,
        password: password,
      );
    }

    if (mounted) {
      setState(() => _submitting = false);
    }

    if (account.isSignedIn) {
      if (!mounted) return;
      _show(
        _createAccount
            ? 'Account connected. Learning remains available offline.'
            : 'Signed in. Learning remains available offline.',
      );
      return;
    }

    if (result != null && mounted) {
      _show(result);
    }
  }

  Future<void> _resendConfirmation() async {
    if (_submitting) return;

    final email = _emailController.text.trim().isNotEmpty
        ? _emailController.text.trim()
        : NorieAccountService.instance.pendingEmail ?? '';

    setState(() => _submitting = true);
    final result = await NorieAccountService.instance.resendConfirmation(email);
    if (!mounted) return;
    setState(() => _submitting = false);

    _show(
      result ?? 'Confirmation email resent. Check your inbox and spam folder.',
    );
  }

  Future<void> _forgotPassword() async {
    if (_submitting) return;

    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      _show('Enter your account email first.');
      return;
    }

    setState(() => _submitting = true);
    final result =
        await NorieAccountService.instance.requestPasswordReset(email);
    if (!mounted) return;
    setState(() => _submitting = false);

    _show(
      result ?? 'Password reset email sent. Open the link to return to Norie.',
    );
  }

  Future<void> _editDisplayName() async {
    final account = NorieAccountService.instance;
    final controller = TextEditingController(
      text: account.displayName ?? '',
    );

    final value = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit display name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
          decoration: const InputDecoration(
            labelText: 'Display name',
            prefixIcon: Icon(Icons.person_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();
    if (value == null || !mounted) return;

    final result = await account.updateDisplayName(value);
    if (!mounted) return;
    _show(result ?? 'Display name updated.');
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _chooseGuest(bool transferLocal) async {
    final sync = NorieCloudSync.instance;
    final stillCurrent = sync.captureSessionGuard();
    final accepted =
        await sync.resolveGuestTransfer(transferLocal: transferLocal);
    if (!mounted || !stillCurrent()) return;
    _show(accepted
        ? transferLocal
            ? 'Guest progress transferred. Your recovery backup remains on this device.'
            : 'Account progress selected. Your guest recovery backup remains on this device.'
        : sync.message ?? 'The active account changed. Please choose again.');
  }

  Future<void> _copyGuestRecovery() async {
    final backup = await NorieCloudSync.instance.readGuestRecovery();
    if (!mounted) return;
    if (backup == null) {
      _show('No guest recovery backup has been saved on this device yet.');
      return;
    }
    await Clipboard.setData(ClipboardData(text: backup));
    if (mounted) {
      _show(
          'Guest recovery backup copied. Keep it in a private file for later import.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = NorieAccountService.instance;
    final sync = NorieCloudSync.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Norie Account'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation: account,
          builder: (context, _) {
            return AnimatedBuilder(
              animation: sync,
              builder: (context, _) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 36),
                      children: [
                        if (!account.isCloudConfigured)
                          const _CloudNotConfigured()
                        else if (account.isSignedIn)
                          _SignedInAccount(
                            account: account,
                            sync: sync,
                            onSync: () => sync.syncNow(),
                            onEditName: _editDisplayName,
                            onTransferGuest: () => _chooseGuest(true),
                            onUseAccount: () => _chooseGuest(false),
                            onCopyGuestRecovery: _copyGuestRecovery,
                            onSignOut: () async {
                              await account.signOut();
                              if (mounted) {
                                _show(
                                  'Signed out. Local progress remains on this device.',
                                );
                              }
                            },
                          )
                        else ...[
                          const _AccountHero(),
                          const SizedBox(height: 22),
                          _ModeSelector(
                            createAccount: _createAccount,
                            onChanged: (value) {
                              setState(() => _createAccount = value);
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_createAccount) const _PrivateDemoInviteNote(),
                          if (_createAccount) const SizedBox(height: 12),
                          if (_createAccount) ...[
                            TextField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Display name',
                                prefixIcon: Icon(Icons.person_rounded),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.mail_outline_rounded),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                ),
                              ),
                            ),
                          ),
                          if (!_createAccount)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _submitting ? null : _forgotPassword,
                                child: const Text('Forgot password?'),
                              ),
                            ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _submitting ||
                                      account.status ==
                                          NorieAccountStatus.working
                                  ? null
                                  : _submit,
                              icon: _submitting
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(
                                      _createAccount
                                          ? Icons.person_add_rounded
                                          : Icons.login_rounded,
                                    ),
                              label: Text(
                                _createAccount
                                    ? 'Create Approved Demo Account'
                                    : 'Sign In',
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: NorieColors.cyan,
                                foregroundColor: NorieColors.background,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          if (account.emailConfirmationRequired) ...[
                            const SizedBox(height: 14),
                            _ConfirmationRequiredCard(
                              email: account.pendingEmail ??
                                  _emailController.text.trim(),
                              submitting: _submitting,
                              onResend: _resendConfirmation,
                            ),
                          ],
                          if (account.emailConfirmationRequired) ...[
                            const SizedBox(height: 14),
                            _ConfirmationRequiredCard(
                              email: account.pendingEmail ??
                                  _emailController.text.trim(),
                              submitting: _submitting,
                              onResend: _resendConfirmation,
                            ),
                          ],
                          if (account.message != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              account.message!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: NorieColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                          const _LocalFirstNote(),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AccountHero extends StatelessWidget {
  const _AccountHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF102D4A),
            Color(0xFF26205D),
            Color(0xFF441C56),
          ],
        ),
        border: Border.all(
          color: NorieColors.violet.withValues(alpha: .5),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.cloud_sync_rounded,
            color: NorieColors.cyan,
            size: 38,
          ),
          SizedBox(height: 14),
          Text(
            'Take your learning with you.',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
              letterSpacing: -.5,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'A Norie account can synchronize XP, ranks, streaks, challenges, achievements, mastery, and weak topics across supported devices.',
            style: TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 11,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  const _ModeSelector({
    required this.createAccount,
    required this.onChanged,
  });

  final bool createAccount;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(
          value: false,
          icon: Icon(Icons.login_rounded),
          label: Text('Sign In'),
        ),
        ButtonSegment(
          value: true,
          icon: Icon(Icons.person_add_rounded),
          label: Text('Create Account'),
        ),
      ],
      selected: {createAccount},
      onSelectionChanged: (selection) {
        onChanged(selection.first);
      },
    );
  }
}

class _PrivateDemoInviteNote extends StatelessWidget {
  const _PrivateDemoInviteNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: NorieColors.violet.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: NorieColors.violet.withValues(alpha: .3),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_person_rounded,
            color: NorieColors.violet,
            size: 20,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Private demo: account creation only works for email addresses approved by the Norie tester allowlist.',
              style: TextStyle(
                color: NorieColors.textSecondary,
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationRequiredCard extends StatelessWidget {
  const _ConfirmationRequiredCard({
    required this.email,
    required this.submitting,
    required this.onResend,
  });

  final String email;
  final bool submitting;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: NorieColors.orange.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: NorieColors.orange.withValues(alpha: .4),
        ),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.mark_email_unread_rounded,
                color: NorieColors.orange,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Email confirmation required',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            email.isEmpty
                ? 'Confirm the email you used to create this account.'
                : 'Confirm $email before signing in.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 10,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: submitting ? null : onResend,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Resend Confirmation Email'),
            ),
          ),
        ],
      ),
    );
  }
}

String _lastSyncLabel(DateTime? value) {
  if (value == null) return 'Not synced in this session yet';

  final difference = DateTime.now().toUtc().difference(value);
  if (difference.inSeconds < 60) return 'Last synced just now';
  if (difference.inMinutes < 60) {
    return 'Last synced ${difference.inMinutes} min ago';
  }
  if (difference.inHours < 24) {
    return 'Last synced ${difference.inHours} h ago';
  }
  return 'Last synced ${difference.inDays} d ago';
}

class _SignedInAccount extends StatelessWidget {
  const _SignedInAccount({
    required this.account,
    required this.sync,
    required this.onSync,
    required this.onEditName,
    required this.onSignOut,
    required this.onTransferGuest,
    required this.onUseAccount,
    required this.onCopyGuestRecovery,
  });

  final NorieAccountService account;
  final NorieCloudSync sync;
  final VoidCallback onSync;
  final VoidCallback onEditName;
  final VoidCallback onSignOut;
  final VoidCallback onTransferGuest, onUseAccount, onCopyGuestRecovery;

  @override
  Widget build(BuildContext context) {
    final syncInfo = _syncLabel(sync.status);

    return Column(
      children: [
        if (sync.guestTransferPending) ...[
          Card(
              child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Choose where your guest progress belongs',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        const Text(
                            'This device has learning progress saved before sign-in. Nothing will upload until you choose. Both choices keep a private guest recovery backup on this device.'),
                        const SizedBox(height: 10),
                        const Text(
                            'Transfer combines completed lessons and permanent rewards with this account. Lifetime XP uses the higher saved total rather than adding overlapping rewards.'),
                        const SizedBox(height: 12),
                        FilledButton(
                            onPressed: sync.guestTransferInProgress
                                ? null
                                : onTransferGuest,
                            child: const Text(
                                'Transfer guest progress to this account')),
                        const SizedBox(height: 8),
                        OutlinedButton(
                            onPressed: sync.guestTransferInProgress
                                ? null
                                : onUseAccount,
                            child: const Text(
                                'Use account progress without guest data')),
                        if (sync.guestTransferInProgress)
                          const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                  'Preserving guest progress and applying your choice…')),
                      ]))),
          const SizedBox(height: 14),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF102E43),
                Color(0xFF23285D),
                Color(0xFF3A1E55),
              ],
            ),
            border: Border.all(
              color: NorieColors.cyan.withValues(alpha: .45),
            ),
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 34,
                backgroundColor: NorieColors.surfaceElevated,
                child: Icon(
                  Icons.person_rounded,
                  color: NorieColors.cyan,
                  size: 34,
                ),
              ),
              const SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      account.displayName?.isNotEmpty == true
                          ? account.displayName!
                          : 'Norie Learner',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: onEditName,
                    tooltip: 'Edit display name',
                    icon: const Icon(
                      Icons.edit_rounded,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                account.email ?? '',
                style: const TextStyle(
                  color: NorieColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 16),
              _SyncStatus(
                icon: syncInfo.$1,
                label: syncInfo.$2,
                color: syncInfo.$3,
              ),
              const SizedBox(height: 7),
              Text(
                _lastSyncLabel(sync.lastSyncedAt),
                style: const TextStyle(
                  color: NorieColors.textSecondary,
                  fontSize: 9,
                ),
              ),
              if (sync.message != null) ...[
                const SizedBox(height: 10),
                Text(
                  sync.message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed:
                sync.isSyncing || sync.guestTransferPending ? null : onSync,
            icon: sync.isSyncing
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync_rounded),
            label: const Text('Sync Now'),
            style: FilledButton.styleFrom(
              backgroundColor: NorieColors.cyan,
              foregroundColor: NorieColors.background,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onSignOut,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign Out'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        const SizedBox(height: 18),
        TextButton.icon(
            onPressed: onCopyGuestRecovery,
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Copy guest recovery backup')),
        const SizedBox(height: 10),
        const _LocalFirstNote(),
      ],
    );
  }

  static (IconData, String, Color) _syncLabel(
    NorieCloudSyncStatus status,
  ) =>
      switch (status) {
        NorieCloudSyncStatus.localOnly => (
            Icons.phone_android_rounded,
            'Local only',
            NorieColors.textSecondary,
          ),
        NorieCloudSyncStatus.signedOut => (
            Icons.cloud_off_rounded,
            'Signed out',
            NorieColors.textSecondary,
          ),
        NorieCloudSyncStatus.syncing => (
            Icons.sync_rounded,
            'Synchronizing…',
            NorieColors.orange,
          ),
        NorieCloudSyncStatus.pending => (
            Icons.cloud_upload_outlined,
            'Waiting to synchronize',
            NorieColors.orange,
          ),
        NorieCloudSyncStatus.synced => (
            Icons.cloud_done_rounded,
            'Cloud synchronized',
            NorieColors.green,
          ),
        NorieCloudSyncStatus.error => (
            Icons.cloud_off_rounded,
            'Sync needs attention',
            NorieColors.magenta,
          ),
      };
}

class _SyncStatus extends StatelessWidget {
  const _SyncStatus({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocalFirstNote extends StatelessWidget {
  const _LocalFirstNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: NorieColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.offline_bolt_rounded,
            color: NorieColors.orange,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Norie is local-first. Learning continues when cloud sync is unavailable, and local progress remains stored on this device.',
              style: TextStyle(
                color: NorieColors.textSecondary,
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CloudNotConfigured extends StatelessWidget {
  const _CloudNotConfigured();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _AccountHero(),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: NorieColors.orange.withValues(alpha: .07),
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: NorieColors.orange.withValues(alpha: .35),
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                color: NorieColors.orange,
              ),
              SizedBox(width: 11),
              Expanded(
                child: Text(
                  'Cloud accounts are not enabled in this build yet. Your local progress remains fully usable and safe. The app owner must configure the Supabase URL and anon key during deployment.',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    height: 1.45,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _LocalFirstNote(),
      ],
    );
  }
}
