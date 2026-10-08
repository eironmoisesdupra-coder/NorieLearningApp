import 'package:web/web.dart' as web;

bool checkNorieWebUpdate() {
  if (web.window.location.protocol != 'https:' &&
      web.window.location.protocol != 'http:') {
    return false;
  }
  final controllerReady = web.document.documentElement
          ?.getAttribute('data-norie-update-controller') ==
      'ready';
  if (!controllerReady) return false;
  web.window.dispatchEvent(web.Event('norie-check-update'));
  return true;
}
