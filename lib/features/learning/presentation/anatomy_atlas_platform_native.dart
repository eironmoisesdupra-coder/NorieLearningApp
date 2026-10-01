import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
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
  HttpServer? _server;
  WebViewController? _web;
  String? _error;
  bool _closed = false;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_send);
    _start();
  }

  Future<void> _start() async {
    try {
      final catalog = jsonDecode(
              await rootBundle.loadString('assets/anatomy/atlas-catalog.json'))
          as Map<String, dynamic>;
      final allowed = {
        'atlas-viewer.html',
        'atlas-viewer.js',
        'atlas-catalog.json',
        ...(catalog['assets'] as List).map((a) => (a as Map)['file'] as String)
      };
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      if (_closed) {
        await server.close(force: true);
        return;
      }
      _server = server;
      final prefix = '/${widget.controller.session}/';
      server.listen((request) async {
        try {
          final path = request.uri.path;
          final file =
              path.startsWith(prefix) ? path.substring(prefix.length) : '';
          if (request.method != 'GET' || !allowed.contains(file)) {
            request.response.statusCode = HttpStatus.notFound;
          } else {
            final data = await rootBundle.load('assets/anatomy/$file');
            request.response.headers.set('X-Content-Type-Options', 'nosniff');
            request.response.headers.contentType =
                ContentType.parse(file.endsWith('.html')
                    ? 'text/html'
                    : file.endsWith('.js')
                        ? 'text/javascript'
                        : file.endsWith('.json')
                            ? 'application/json'
                            : 'model/gltf-binary');
            request.response.add(data.buffer
                .asUint8List(data.offsetInBytes, data.lengthInBytes));
          }
        } on Object catch (_) {
          request.response.statusCode = HttpStatus.internalServerError;
        } finally {
          await request.response.close();
        }
      });
      final base = 'http://127.0.0.1:${server.port}';
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFF0B1629))
        ..addJavaScriptChannel('NorieAtlas', onMessageReceived: (message) {
          try {
            final value = jsonDecode(message.message) as Map<String, dynamic>;
            if (!_closed && widget.controller.accepts(value)) {
              widget.onMessage(value);
            }
          } on Object catch (_) {/* Reject malformed renderer events. */}
        })
        ..setNavigationDelegate(NavigationDelegate(
            onNavigationRequest: (request) =>
                request.url.startsWith('$base$prefix')
                    ? NavigationDecision.navigate
                    : NavigationDecision.prevent));
      _web = controller;
      await controller.loadRequest(Uri.parse('$base${prefix}atlas-viewer.html')
          .replace(queryParameters: {'session': widget.controller.session}));
      if (mounted) setState(() {});
    } on Object catch (_) {
      if (mounted) {
        setState(() => _error =
            'The local atlas could not start. Reopen this view to retry.');
      }
    }
  }

  void _send() {
    final command = widget.controller.lastCommand;
    if (command != null) {
      _web?.runJavaScript('window.norieAtlasCommand(${jsonEncode(command)});');
    }
  }

  @override
  void dispose() {
    _closed = true;
    widget.controller.removeListener(_send);
    _server?.close(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return Center(child: Text(_error!));
    if (_web == null) return const Center(child: CircularProgressIndicator());
    return WebViewWidget(controller: _web!);
  }
}
