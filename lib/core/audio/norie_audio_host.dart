import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'norie_audio_manager.dart';

class NorieAudioHost extends StatefulWidget {
  const NorieAudioHost({super.key, required this.child, this.manager});
  final Widget child;
  final NorieAudioManager? manager;
  @override
  State<NorieAudioHost> createState() => _NorieAudioHostState();
}

class _NorieAudioHostState extends State<NorieAudioHost>
    with WidgetsBindingObserver {
  late final NorieAudioManager _audio =
      widget.manager ?? NorieAudioManager.instance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    HardwareKeyboard.instance.addHandler(_key);
    unawaited(_audio.load());
  }

  bool _key(KeyEvent event) {
    if (event is KeyDownEvent) unawaited(_audio.unlock());
    return false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    unawaited(_audio.setForeground(state == AppLifecycleState.resumed));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    HardwareKeyboard.instance.removeHandler(_key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Listener(
      onPointerDown: (_) => unawaited(_audio.unlock()), child: widget.child);
}

/// Attach to an active route or quiz, not every child of an IndexedStack.
/// Nested scopes restore the previous context when the top route is removed.
class NorieAudioScope extends StatefulWidget {
  const NorieAudioScope(
      {super.key,
      required this.contextType,
      required this.child,
      this.manager});
  final NorieAudioContext contextType;
  final Widget child;
  final NorieAudioManager? manager;
  @override
  State<NorieAudioScope> createState() => _NorieAudioScopeState();
}

class _NorieAudioScopeState extends State<NorieAudioScope> {
  late final NorieAudioManager _audio =
      widget.manager ?? NorieAudioManager.instance;
  late Object _token;
  @override
  void initState() {
    super.initState();
    _token = _audio.enterContext(widget.contextType);
  }

  @override
  void didUpdateWidget(NorieAudioScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contextType != widget.contextType) {
      _audio.leaveContext(_token);
      _token = _audio.enterContext(widget.contextType);
    }
  }

  @override
  void dispose() {
    _audio.leaveContext(_token);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
