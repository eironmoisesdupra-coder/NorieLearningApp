import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import '../../../core/mascot/norie_mascot_scope.dart';
import '../../../core/mascot/tutorial/norie_tutorial_coordinator.dart';
import 'anatomy_atlas_controller.dart';

class AnatomyAtlasPlatform extends StatefulWidget {
  const AnatomyAtlasPlatform(
      {required this.controller, required this.onMessage, super.key});
  final AnatomyAtlasController controller;
  final ValueChanged<Map<String, dynamic>> onMessage;
  @override
  State<AnatomyAtlasPlatform> createState() => _AnatomyAtlasPlatformState();
}

class _AnatomyAtlasPlatformState extends State<AnatomyAtlasPlatform> {
  web.HTMLIFrameElement? _frame;
  NorieTutorialCoordinator? _tutorial;
  late final JSFunction _listener;
  final _origin = web.window.location.origin;
  @override
  void initState() {
    super.initState();
    _listener = ((web.Event raw) {
      final event = raw as web.MessageEvent;
      if (event.source != _frame?.contentWindow || event.origin != _origin) {
        return;
      }
      try {
        final data = event.data.dartify();
        if (data is! String) return;
        final value = jsonDecode(data) as Map<String, dynamic>;
        if (widget.controller.accepts(value)) widget.onMessage(value);
      } on Object catch (_) {
        /* Ignore malformed messages from the embedded frame. */
      }
    }).toJS;
    web.window.addEventListener('message', _listener);
    widget.controller.addListener(_send);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tutorial = NorieMascotScope.maybeOf(context)?.tutorialCoordinator;
    if (identical(tutorial, _tutorial)) return;
    _tutorial?.removeListener(_updateInteraction);
    _tutorial = tutorial;
    _tutorial?.addListener(_updateInteraction);
    _updateInteraction();
  }

  void _updateInteraction() {
    final frame = _frame;
    if (frame == null) return;
    final blocked = _tutorial?.isActive ?? false;
    frame.style.pointerEvents = blocked ? 'none' : 'auto';
    frame.tabIndex = blocked ? -1 : 0;
    if (blocked && web.document.activeElement == frame) frame.blur();
  }

  void _send() {
    final command = widget.controller.lastCommand;
    if (command != null) {
      _frame?.contentWindow
          ?.postMessage(jsonEncode(command).toJS, _origin.toJS);
    }
  }

  @override
  void dispose() {
    _tutorial?.removeListener(_updateInteraction);
    widget.controller.removeListener(_send);
    web.window.removeEventListener('message', _listener);
    _frame?.src = 'about:blank';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HtmlElementView.fromTagName(
        tagName: 'iframe',
        onElementCreated: (element) {
          final frame = element as web.HTMLIFrameElement;
          _frame = frame;
          _updateInteraction();
          frame.title = 'NorieLearning interactive anatomy atlas';
          frame.style.border = '0';
          frame.style.width = '100%';
          frame.style.height = '100%';
          frame.src = Uri.base
              .resolve('assets/assets/anatomy/atlas-viewer.html')
              .replace(queryParameters: {
            'session': widget.controller.session,
            'parentOrigin': _origin,
          }).toString();
        },
      );
}
