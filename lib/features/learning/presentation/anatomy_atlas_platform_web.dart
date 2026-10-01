import 'dart:convert';
import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
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

  void _send() {
    final command = widget.controller.lastCommand;
    if (command != null) {
      _frame?.contentWindow
          ?.postMessage(jsonEncode(command).toJS, _origin.toJS);
    }
  }

  @override
  void dispose() {
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
