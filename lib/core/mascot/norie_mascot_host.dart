import 'dart:async';

import 'package:flutter/material.dart';

import '../assets/norie_assets.dart';
import 'norie_app_context.dart';
import 'norie_mascot_controller.dart';
import 'norie_mascot_scope.dart';
import 'norie_mascot_state.dart';
import 'norie_mascot_view.dart';

class NorieMascotHost extends StatefulWidget {
  const NorieMascotHost({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<NorieMascotHost> createState() => _NorieMascotHostState();
}

class _NorieMascotHostState extends State<NorieMascotHost>
    with WidgetsBindingObserver {
  late final NorieMascotController _controller = NorieMascotController()
    ..addListener(_handleMascotChanged);

  NorieContextSnapshot _contextSnapshot =
      const NorieContextSnapshot.home();
  bool _assistantVisible = false;
  bool _appActive = true;
  bool _precacheStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  }

  bool get _showMascot {
    return _assistantVisible ||
        (_controller.state != NorieMascotState.idle &&
            _controller.state != NorieMascotState.hidden);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller
      ..removeListener(_handleMascotChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NorieMascotScope(
      controller: _controller,
      contextSnapshot: _contextSnapshot,
      assistantVisible: _assistantVisible,
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
              bottom: 18,
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
        ],
      ),
    );
  }
}
