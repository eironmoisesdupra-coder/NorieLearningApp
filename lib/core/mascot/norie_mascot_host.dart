import 'dart:async';

import 'package:flutter/material.dart';

import '../assets/norie_assets.dart';
import 'help/norie_help_models.dart';
import 'help/norie_help_sheet.dart';
import 'norie_app_context.dart';
import 'norie_mascot_controller.dart';
import 'norie_mascot_scope.dart';
import 'norie_mascot_state.dart';
import 'norie_mascot_view.dart';
import 'tutorial/norie_tutorial_coordinator.dart';
import 'tutorial/norie_tutorial_overlay.dart';
import 'tutorial/norie_tutorial_models.dart';
import 'tutorial/norie_tutorial_store.dart';
import 'voice/norie_voice_controller.dart';

class NorieMascotHost extends StatefulWidget {
  const NorieMascotHost({
    required this.child,
    this.onNavigate,
    this.onTutorialStep,
    super.key,
  });

  final Widget child;
  final ValueChanged<NorieHelpDestination>? onNavigate;
  final ValueChanged<NorieTutorialStep?>? onTutorialStep;

  @override
  State<NorieMascotHost> createState() => _NorieMascotHostState();
}

class _NorieMascotHostState extends State<NorieMascotHost>
    with WidgetsBindingObserver {
  late final NorieMascotController _controller = NorieMascotController()
    ..addListener(_handleMascotChanged);
  late final NorieVoiceController _voiceController = NorieVoiceController();
  late final NorieTutorialCoordinator _tutorialCoordinator =
      NorieTutorialCoordinator(
    controller: _controller,
    store: NorieTutorialStore(),
    voiceController: _voiceController,
  )..addListener(_handleTutorialChanged);

  NorieContextSnapshot _contextSnapshot = const NorieContextSnapshot.home();
  bool _assistantVisible = false;
  bool _appActive = true;
  bool _precacheStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_voiceController.loadEnabled());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precacheStarted) return;
    _precacheStarted = true;
    unawaited(NorieAssets.precacheMascotAssets(context));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final active = state == AppLifecycleState.resumed;
    if (_appActive == active || !mounted) return;
    setState(() => _appActive = active);
  }

  void _handleMascotChanged() {
    if (mounted) setState(() {});
  }

  void _handleTutorialChanged() {
    if (!_tutorialCoordinator.showingContents ||
        !_tutorialCoordinator.isActive) {
      widget.onTutorialStep?.call(_tutorialCoordinator.currentStep);
    }
    if (mounted) setState(() {});
  }

  void _setContext(NorieContextSnapshot snapshot) {
    if (_contextSnapshot == snapshot || !mounted) return;
    setState(() => _contextSnapshot = snapshot);
  }

  void _showAssistant() {
    if (_assistantVisible || !mounted) return;
    setState(() => _assistantVisible = true);
  }

  void _hideAssistant() {
    if (!_assistantVisible || !mounted) return;
    setState(() => _assistantVisible = false);
    _controller.stopSpeaking();
    unawaited(_voiceController.stop());
  }

  Future<void> _handleHelpAction(NorieHelpDestination destination) async {
    if (destination == NorieHelpDestination.replayTutorial) {
      _hideAssistant();
      await _tutorialCoordinator.replay(NorieTutorialCatalog.complete);
      return;
    }

    _hideAssistant();
    widget.onNavigate?.call(destination);
  }

  bool get _showMascot {
    return _assistantVisible ||
        (_controller.state != NorieMascotState.idle &&
            _controller.state != NorieMascotState.hidden);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tutorialCoordinator
      ..removeListener(_handleTutorialChanged)
      ..dispose();
    _controller
      ..removeListener(_handleMascotChanged)
      ..dispose();
    _voiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NorieMascotScope(
      controller: _controller,
      contextSnapshot: _contextSnapshot,
      assistantVisible: _assistantVisible,
      tutorialCoordinator: _tutorialCoordinator,
      setContext: _setContext,
      showAssistant: _showAssistant,
      hideAssistant: _hideAssistant,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          if (_showMascot)
            Positioned(
              right: 12,
              bottom: _tutorialCoordinator.isActive ? 172 : 18,
              child: SafeArea(
                minimum: const EdgeInsets.all(4),
                child: IgnorePointer(
                  child: TickerMode(
                    key: const ValueKey('norie-mascot-ticker-mode'),
                    enabled: _appActive,
                    child: NorieMascotView(
                      controller: _controller,
                      size: 132,
                    ),
                  ),
                ),
              ),
            ),
          if (_tutorialCoordinator.isActive)
            FocusScope(
                child: Overlay(initialEntries: [
              OverlayEntry(
                  builder: (_) => NorieTutorialOverlay(
                        coordinator: _tutorialCoordinator,
                      )),
            ])),
          if (_assistantVisible)
            Positioned.fill(
              child: NorieHelpSheet(
                contextSnapshot: _contextSnapshot,
                controller: _controller,
                voiceController: _voiceController,
                onClose: _hideAssistant,
                onAction: _handleHelpAction,
              ),
            ),
        ],
      ),
    );
  }
}
