import 'package:flutter/material.dart';
import 'anatomy_atlas_controller.dart';
import 'anatomy_atlas_platform.dart';

class AnatomyAtlasModelView extends StatefulWidget {
  const AnatomyAtlasModelView(
      {required this.controller,
      required this.reference,
      required this.systems,
      this.target,
      this.quiz = false,
      this.onSelected,
      this.onLoaded,
      super.key});
  final AnatomyAtlasController controller;
  final String reference;
  final Set<String> systems;
  final String? target;
  final bool quiz;
  final ValueChanged<String>? onSelected;
  final ValueChanged<bool>? onLoaded;
  @override
  State<AnatomyAtlasModelView> createState() => _AnatomyAtlasModelViewState();
}

class _AnatomyAtlasModelViewState extends State<AnatomyAtlasModelView> {
  bool _ready = false;
  int _retry = 0;
  int _requestId = 0;
  String? _error;
  void _configure() {
    if (!_ready) return;
    widget.controller.send('configure', {
      'requestId': ++_requestId,
      'reference': widget.reference,
      'systems': widget.systems.toList(),
      'target': widget.target,
      'quiz': widget.quiz
    });
  }

  @override
  void didUpdateWidget(covariant AnatomyAtlasModelView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reference != widget.reference ||
        oldWidget.target != widget.target ||
        oldWidget.quiz != widget.quiz ||
        !setEquals(oldWidget.systems, widget.systems)) {
      _configure();
    }
  }

  bool setEquals(Set<String> a, Set<String> b) =>
      a.length == b.length && a.containsAll(b);
  void _message(Map<String, dynamic> message) {
    if (!mounted) return;
    final payload = message['payload'] as Map<String, dynamic>? ?? {};
    if (payload['requestId'] != null && payload['requestId'] != _requestId) {
      return;
    }
    if (message['type'] == 'loading' || message['type'] == 'error') {
      widget.onLoaded?.call(false);
    }
    if (message['type'] == 'loaded') widget.onLoaded?.call(true);
    if (message['type'] == 'ready') {
      _ready = true;
      _configure();
    }
    if (message['type'] == 'selected' &&
        !widget.quiz &&
        payload['id'] is String) {
      widget.onSelected?.call(payload['id'] as String);
    }
    if (message['type'] == 'error') {
      setState(() =>
          _error = payload['message'] as String? ?? 'Unable to load anatomy.');
    }
    if (message['type'] == 'loaded' && _error != null) {
      setState(() => _error = null);
    }
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        Positioned.fill(
            child: AnatomyAtlasPlatform(
                key: ValueKey(_retry),
                controller: widget.controller,
                onMessage: _message)),
        if (_error != null)
          Positioned.fill(
              child: ColoredBox(
                  color: const Color(0xEE0B1629),
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(24),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Text(_error!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            FilledButton(
                                onPressed: () => setState(() {
                                      _ready = false;
                                      _error = null;
                                      _retry++;
                                    }),
                                child: const Text('Retry atlas')),
                          ]))))),
      ]);
}
