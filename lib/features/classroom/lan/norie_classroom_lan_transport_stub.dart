import 'norie_classroom_lan_models.dart';
import 'norie_classroom_lan_protocol.dart';
import 'norie_classroom_lan_transport.dart';

NorieLanTransport createTransport() => _Unsupported();

class _Unsupported implements NorieLanTransport {
  @override
  bool get supported => false;
  Never _fail() => throw UnsupportedError(
      'Install the Windows or Android app to use local Wi-Fi Classroom.');
  @override
  Future<NorieLanSessionInfo> start() async => _fail();
  @override
  Future<void> serve(NorieLanProtocolHandler handler) async => _fail();
  @override
  Future<void> refresh() async {}
  @override
  Future<void> stop() async {}
  @override
  Future<NorieLanResponse> request(
          {required String endpoint,
          required String joinCode,
          required String? sessionId,
          required String method,
          required String path,
          required String body}) async =>
      _fail();
}
