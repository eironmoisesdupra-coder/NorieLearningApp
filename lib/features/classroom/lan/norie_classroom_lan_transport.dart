import 'norie_classroom_lan_models.dart';
import 'norie_classroom_lan_protocol.dart';

abstract class NorieLanTransport {
  bool get supported;
  Future<NorieLanSessionInfo> start();
  Future<void> serve(NorieLanProtocolHandler handler);
  Future<void> refresh();
  Future<void> stop();
  Future<NorieLanResponse> request(
      {required String endpoint,
      required String joinCode,
      required String? sessionId,
      required String method,
      required String path,
      required String body});
}
