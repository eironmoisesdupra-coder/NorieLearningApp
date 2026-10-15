import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class NorieAccessibilityProfile {
  const NorieAccessibilityProfile({
    this.textScale = 1.0,
    this.reducedMotion = false,
    this.readingFocus = false,
    this.highContrast = false,
    this.boldText = false,
  });

  final double textScale;
  final bool reducedMotion;
  final bool readingFocus;
  final bool highContrast;
  final bool boldText;

  NorieAccessibilityProfile copyWith({
    double? textScale,
    bool? reducedMotion,
    bool? readingFocus,
    bool? highContrast,
    bool? boldText,
  }) =>
      NorieAccessibilityProfile(
        textScale: textScale ?? this.textScale,
        reducedMotion: reducedMotion ?? this.reducedMotion,
        readingFocus: readingFocus ?? this.readingFocus,
        highContrast: highContrast ?? this.highContrast,
        boldText: boldText ?? this.boldText,
      );

  Map<String, dynamic> toJson() => {
        'text_scale': textScale,
        'reduced_motion': reducedMotion,
        'reading_focus': readingFocus,
        'high_contrast': highContrast,
        'bold_text': boldText,
      };

  static NorieAccessibilityProfile fromJson(Object? raw) {
    if (raw is! Map) {
      throw const FormatException('Accessibility profile must be an object.');
    }
    const allowed = {
      'text_scale',
      'reduced_motion',
      'reading_focus',
      'high_contrast',
      'bold_text'
    };
    if (raw.keys.any((k) => k is! String || !allowed.contains(k))) {
      throw const FormatException('Unknown accessibility field.');
    }
    final scale = raw['text_scale'] ?? 1.0;
    if (scale is! num || !scale.isFinite || scale < .9 || scale > 1.6) {
      throw const FormatException('Invalid accessibility text scale.');
    }
    bool flag(String key) {
      final value = raw[key] ?? false;
      if (value is! bool) {
        throw FormatException('Invalid accessibility field: $key');
      }
      return value;
    }

    return NorieAccessibilityProfile(
      textScale: scale.toDouble(),
      reducedMotion: flag('reduced_motion'),
      readingFocus: flag('reading_focus'),
      highContrast: flag('high_contrast'),
      boldText: flag('bold_text'),
    );
  }
}

class NorieAccessibilitySettings extends ChangeNotifier {
  NorieAccessibilitySettings({
    Future<String?> Function()? read,
    Future<bool> Function(String)? write,
  })  : _read = read ?? _readPreferences,
        _write = write ?? _writePreferences;
  static final instance = NorieAccessibilitySettings();
  static const _key = 'norie.accessibility.v1';

  final Future<String?> Function() _read;
  final Future<bool> Function(String) _write;
  Future<void> _writes = Future.value();
  Future<void>? _loading;

  static Future<String?> _readPreferences() async =>
      (await SharedPreferences.getInstance()).getString(_key);

  static Future<bool> _writePreferences(String value) async =>
      (await SharedPreferences.getInstance()).setString(_key, value);

  NorieAccessibilityProfile _value = const NorieAccessibilityProfile();
  bool _loaded = false;
  NorieAccessibilityProfile get value => _value;

  Future<void> load() {
    if (_loaded) return Future.value();
    return _loading ??= _load();
  }

  Future<void> _load() async {
    var restored = const NorieAccessibilityProfile();
    try {
      final raw = await _read();
      if (raw != null) {
        restored = NorieAccessibilityProfile.fromJson(jsonDecode(raw));
      }
    } catch (_) {
      // Device storage may be unavailable or contain an older/corrupt value.
    }
    // A successful save takes precedence over this potentially stale read.
    // A failed save must still allow the original durable value to restore.
    await _writes;
    if (_loaded) return;
    _value = restored;
    _loaded = true;
    notifyListeners();
  }

  Future<void> save(NorieAccessibilityProfile next) async {
    final checked = NorieAccessibilityProfile.fromJson(next.toJson());
    final operation = _writes.then((_) async {
      if (!await _write(jsonEncode(checked.toJson()))) {
        throw StateError('Accessibility settings could not be saved.');
      }
      _value = checked;
      _loaded = true;
      notifyListeners();
    });
    // Keep the queue usable after a failure, while returning it to this caller.
    _writes =
        operation.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    await operation;
  }

  Future<void> reset() => save(const NorieAccessibilityProfile());
}
