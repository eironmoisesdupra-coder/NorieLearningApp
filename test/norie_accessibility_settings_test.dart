import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/accessibility/data/norie_accessibility_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('device preference key persists across independent store instances',
      () async {
    SharedPreferences.setMockInitialValues({});
    final first = NorieAccessibilitySettings();
    await first.save(const NorieAccessibilityProfile(
        textScale: 1.3,
        boldText: true,
        highContrast: true,
        readingFocus: true,
        reducedMotion: true));
    final second = NorieAccessibilitySettings();
    await second.load();
    expect(second.value.textScale, 1.3);
    expect(second.value.boldText, isTrue);
    expect(second.value.highContrast, isTrue);
    expect(second.value.readingFocus, isTrue);
    expect(second.value.reducedMotion, isTrue);
    expect(
        (await SharedPreferences.getInstance())
            .containsKey('norie.accessibility.v1'),
        isTrue);
  });

  test('invalid save rejects before storage and keeps active preferences',
      () async {
    var writes = 0;
    final store = NorieAccessibilitySettings(
        read: () async => null,
        write: (_) async {
          writes++;
          return true;
        });
    await expectLater(
        store.save(const NorieAccessibilityProfile(textScale: double.nan)),
        throwsFormatException);
    expect(writes, 0);
    expect(store.value.textScale, 1);
  });

  test('thrown storage failure leaves active preferences unchanged', () async {
    final store = NorieAccessibilitySettings(
        read: () async => '{"text_scale":1.2}',
        write: (_) async => throw StateError('disk full'));
    await store.load();
    await expectLater(
        store.save(const NorieAccessibilityProfile(textScale: 1.6)),
        throwsStateError);
    expect(store.value.textScale, 1.2);
  });
  test('non-finite and out of range scales are rejected', () {
    for (final scale in [double.nan, double.infinity, .8, 1.7]) {
      expect(() => NorieAccessibilityProfile.fromJson({'text_scale': scale}),
          throwsFormatException);
    }
  });

  test('failed durable writes leave active settings unchanged', () async {
    final store = NorieAccessibilitySettings(
      read: () async => null,
      write: (_) async => false,
    );
    await expectLater(
        store.save(const NorieAccessibilityProfile(boldText: true)),
        throwsStateError);
    expect(store.value.boldText, isFalse);
  });

  test('writes serialize and a failed write does not block later saves',
      () async {
    final first = Completer<bool>();
    final written = <String>[];
    final store = NorieAccessibilitySettings(
      read: () async => null,
      write: (raw) {
        written.add(raw);
        return written.length == 1 ? first.future : Future.value(true);
      },
    );
    final a = store.save(const NorieAccessibilityProfile(boldText: true));
    final failure = expectLater(a, throwsStateError);
    final b = store.save(const NorieAccessibilityProfile(textScale: 1.6));
    await Future<void>.delayed(Duration.zero);
    expect(written, hasLength(1));
    expect(store.value.textScale, 1);
    first.complete(false);
    await failure;
    await b;
    expect(written, hasLength(2));
    expect(store.value.textScale, 1.6);
    expect(store.value.boldText, isFalse);
  });

  test('late load cannot overwrite a newer successful save', () async {
    final read = Completer<String?>();
    final store = NorieAccessibilitySettings(
      read: () => read.future,
      write: (_) async => true,
    );
    final loading = store.load();
    await store.save(const NorieAccessibilityProfile(readingFocus: true));
    read.complete(jsonEncode({'text_scale': 1.5}));
    await loading;
    expect(store.value.readingFocus, isTrue);
    expect(store.value.textScale, 1);
  });

  test('late load restores durable preferences when newer save fails',
      () async {
    final read = Completer<String?>();
    final write = Completer<bool>();
    final store = NorieAccessibilitySettings(
        read: () => read.future, write: (_) => write.future);
    final loading = store.load();
    final save =
        store.save(const NorieAccessibilityProfile(readingFocus: true));
    final failure = expectLater(save, throwsStateError);
    read.complete('{"text_scale":1.2,"bold_text":true}');
    await Future<void>.delayed(Duration.zero);
    write.complete(false);
    await failure;
    await loading;
    expect(store.value.textScale, 1.2);
    expect(store.value.boldText, isTrue);
    expect(store.value.readingFocus, isFalse);
  });

  test('missing corrupt and unavailable storage safely default', () async {
    for (final raw in [null, 'bad json', '{"bold_text":"yes"}']) {
      final store = NorieAccessibilitySettings(
        read: () async => raw,
        write: (_) async => true,
      );
      await store.load();
      expect(store.value.textScale, 1);
      expect(store.value.boldText, isFalse);
    }
    final store = NorieAccessibilitySettings(
      read: () async => throw StateError('unavailable'),
      write: (_) async => true,
    );
    await store.load();
    expect(store.value.textScale, 1);
  });

  test('stored settings restore and reset durably', () async {
    String? raw = jsonEncode(
        const NorieAccessibilityProfile(textScale: 1.4, highContrast: true)
            .toJson());
    final store = NorieAccessibilitySettings(
      read: () async => raw,
      write: (value) async {
        raw = value;
        return true;
      },
    );
    await store.load();
    expect(store.value.highContrast, isTrue);
    await store.reset();
    expect(jsonDecode(raw!)['text_scale'], 1);
    expect(store.value.highContrast, isFalse);
  });
}
