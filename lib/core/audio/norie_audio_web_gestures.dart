import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// Flutter accessibility buttons can dispatch semantic actions without passing
/// through a widget Listener. Capture real DOM activation before that dispatch.
void Function() listenForBrowserAudioGestures(void Function() unlock) {
  final listener = ((web.Event event) {
    if (event.isTrusted) unlock();
  }).toJS;
  const events = ['pointerdown', 'keydown', 'click'];
  for (final event in events) {
    web.document.addEventListener(event, listener, true.toJS);
  }
  return () {
    for (final event in events) {
      web.document.removeEventListener(event, listener, true.toJS);
    }
  };
}
