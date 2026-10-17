import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/classroom/lan/norie_classroom_lan.dart';

void main() {
  test('private literal endpoints and bounded join QR only', () {
    expect(
        NorieLanJoinInfo.parse(
                'norie-classroom://join?endpoint=http%3A%2F%2F192.168.1.2%3A1234&code=123456&session=abc')
            .endpoint,
        'http://192.168.1.2:1234');
    for (final value in [
      'https://192.168.1.2:80',
      'http://example.com:80',
      'http://8.8.8.8:80',
      'http://127.0.0.1:80/a',
      'http://2130706433:80',
      'http://user@192.168.1.2:80'
    ]) {
      expect(() => NorieLanJoinInfo(endpoint: value, joinCode: '123456'),
          throwsFormatException);
    }
  });
  test('envelope rejects duplicate fields version type and cross session', () {
    expect(
        () => NorieLanEnvelope.decode(
            '{"protocol":"norie-classroom-lan","protocol":"norie-classroom-lan"}'),
        throwsFormatException);
    final raw =
        const NorieLanEnvelope(type: 'hello', sessionId: 'abc', payload: {})
            .encode();
    expect(
        NorieLanEnvelope.decode(raw,
                expectedSessionId: 'abc', expectedType: 'hello')
            .sessionId,
        'abc');
    expect(() => NorieLanEnvelope.decode(raw, expectedSessionId: 'other'),
        throwsFormatException);
    expect(
        () => NorieLanEnvelope.decode(
            raw.replaceFirst('"version":1', '"version":2')),
        throwsFormatException);
  });
  test('QR rejects repeated fields and envelope bounds hostile nesting', () {
    for (final raw in [
      'norie-classroom://join?endpoint=http%3A%2F%2F192.168.1.2%3A1234&code=123456&session=a&session=b',
      'norie-classroom://join?endpoint=http%3A%2F%2F192.168.1.2%3A1234&code=123456',
      'norie-classroom://join?endpoint=http%3A%2F%2F192.168.1.2%3A1234&code=123456&session=a&extra=b',
    ]) {
      expect(() => NorieLanJoinInfo.parse(raw), throwsFormatException);
    }
    expect(() => NorieLanEnvelope.decode('${'[' * 22}0${']' * 22}'),
        throwsFormatException);
    expect(() => NorieLanEnvelope.decode(' ' * (norieLanMaxBytes + 1)),
        throwsFormatException);
  });
}
