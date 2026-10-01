import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class AnatomyAtlasController extends ChangeNotifier {
  final session = const Uuid().v4();
  Map<String, dynamic>? lastCommand;
  void send(String type, [Map<String, dynamic> payload = const {}]) {
    lastCommand = {
      'version': 1,
      'session': session,
      'type': type,
      'payload': payload
    };
    notifyListeners();
  }

  bool accepts(Map<String, dynamic> value) =>
      value['version'] == 1 && value['session'] == session;
}
