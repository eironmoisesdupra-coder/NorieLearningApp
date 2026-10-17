import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DiagnosticSource { flutter, platform, startup, application }

enum DiagnosticCategory { state, format, argument, assertion, timeout, other }

/// Contains only fixed vocabulary and timestamps. Raw errors never enter storage.
class NorieDiagnosticEntry {
  const NorieDiagnosticEntry(this.at, this.category, this.source, this.route);
  final DateTime at;
  final DiagnosticCategory category;
  final DiagnosticSource source;
  final String route;
  String get message => switch (category) {
        DiagnosticCategory.state => 'An operation could not finish.',
        DiagnosticCategory.format => 'Some data could not be read.',
        DiagnosticCategory.argument =>
          'An operation received unsupported data.',
        DiagnosticCategory.assertion =>
          'A display or application check failed.',
        DiagnosticCategory.timeout => 'An operation took too long.',
        DiagnosticCategory.other => 'An unexpected application error occurred.',
      };
  Map<String, Object> toJson() => {
        'at': at.toIso8601String(),
        'category': category.name,
        'source': source.name,
        'route': route
      };
}

class NorieDiagnosticsStore extends ChangeNotifier {
  NorieDiagnosticsStore(
      {Future<String?> Function()? read,
      Future<void> Function(String)? write,
      DateTime Function()? clock})
      : _read = read ?? _readLocal,
        _write = write ?? _writeLocal,
        _clock = clock ?? DateTime.now;
  static final instance = NorieDiagnosticsStore();
  static const storageKey = 'norie.localDiagnostics.v1';
  static const routes = {
    'home',
    'learn',
    'profile',
    'settings',
    'diagnostics',
    'other'
  };
  static const retentionOptions = [7, 14, 30];
  static Future<String?> _readLocal() async =>
      (await SharedPreferences.getInstance()).getString(storageKey);
  static Future<void> _writeLocal(String value) async {
    if (!await (await SharedPreferences.getInstance())
        .setString(storageKey, value)) {
      throw StateError('Local storage unavailable');
    }
  }

  final Future<String?> Function() _read;
  final Future<void> Function(String) _write;
  final DateTime Function() _clock;
  final List<NorieDiagnosticEntry> _entries = [];
  List<NorieDiagnosticEntry> get entries => List.unmodifiable(_entries);
  bool _enabled = true;
  bool get enabled => _enabled;
  int _retentionDays = 14;
  int get retentionDays => _retentionDays;
  String? _storageProblem;
  String? get storageProblem => _storageProblem;
  bool _quarantined = false, _loaded = false, _dirty = false;
  bool _capturing = false, _notificationPending = false, _disposed = false;
  String _route = 'other';
  Future<void>? _loading;
  Future<void> _queue = Future.value();
  static const _storageMessage =
      'Local diagnostics could not be saved. Retry or clear this history.';

  Future<void> load() => _loading ??= _load();
  Future<void> _load() async {
    try {
      final raw = await _read();
      if (raw != null) {
        if (raw.length > 65536) throw const FormatException();
        final data = jsonDecode(raw);
        if (data is! Map ||
            !_keys(data, {'schema', 'enabled', 'retentionDays', 'entries'}) ||
            data['schema'] != 1 ||
            data['enabled'] is! bool ||
            !retentionOptions.contains(data['retentionDays']) ||
            data['entries'] is! List ||
            (data['entries'] as List).length > 100) {
          throw const FormatException();
        }
        final restored = <NorieDiagnosticEntry>[];
        final now = _clock().toUtc();
        for (final item in data['entries'] as List) {
          if (item is! Map ||
              !_keys(item, {'at', 'category', 'source', 'route'}) ||
              item['at'] is! String ||
              (item['at'] as String).length > 32 ||
              !DiagnosticCategory.values
                  .any((v) => v.name == item['category']) ||
              !DiagnosticSource.values.any((v) => v.name == item['source']) ||
              !routes.contains(item['route'])) {
            throw const FormatException();
          }
          final at = DateTime.tryParse(item['at'] as String);
          if (at == null ||
              !at.isUtc ||
              at.toIso8601String() != item['at'] ||
              at.isAfter(now.add(const Duration(minutes: 5))) ||
              at.isBefore(DateTime.utc(2020))) {
            throw const FormatException();
          }
          restored.add(NorieDiagnosticEntry(
              at,
              DiagnosticCategory.values.byName(item['category'] as String),
              DiagnosticSource.values.byName(item['source'] as String),
              item['route'] as String));
        }
        _enabled = data['enabled'] as bool;
        _retentionDays = data['retentionDays'] as int;
        _entries.insertAll(0, restored);
        if (!_enabled) _entries.removeWhere((e) => !restored.contains(e));
      }
      _prune();
    } catch (_) {
      // Do not silently overwrite unreadable or untrusted previous history.
      _quarantined = true;
      _storageProblem =
          'Stored diagnostics could not be read. Clear local history to start fresh.';
    }
    _loaded = true;
    _changed();
    if (_dirty && !_quarantined) await flush();
  }

  static bool _keys(Map value, Set<String> expected) =>
      value.length == expected.length && value.keys.every(expected.contains);
  void setRoute(String? name) {
    final label = name?.startsWith('/') == true ? name!.substring(1) : name;
    _route = routes.contains(label) ? label! : 'other';
  }

  void capture(Object error,
      {StackTrace? stack,
      DiagnosticSource source = DiagnosticSource.application}) {
    if (_capturing || !_enabled || _disposed) return;
    _capturing = true;
    try {
      final now = _clock().toUtc();
      _prune();
      final category = switch (error) {
        StateError() => DiagnosticCategory.state,
        FormatException() => DiagnosticCategory.format,
        ArgumentError() => DiagnosticCategory.argument,
        AssertionError() => DiagnosticCategory.assertion,
        TimeoutException() => DiagnosticCategory.timeout,
        _ => DiagnosticCategory.other,
      };
      final recent = _entries
          .where((e) => now.difference(e.at) < const Duration(minutes: 1));
      if (recent.length >= 10 ||
          recent.any((e) =>
              e.category == category &&
              e.source == source &&
              e.route == _route)) {
        return;
      }
      _entries.add(NorieDiagnosticEntry(now, category, source, _route));
      _prune();
      _dirty = true;
      _changed();
      unawaited(flush());
    } catch (_) {
      // Diagnostics must never become an application error source.
    } finally {
      _capturing = false;
    }
  }

  void _prune() {
    final oldest = _clock().toUtc().subtract(Duration(days: _retentionDays));
    final before = _entries.length;
    _entries.removeWhere((e) => e.at.isBefore(oldest));
    _entries.sort((a, b) => a.at.compareTo(b.at));
    if (_entries.length > 100) _entries.removeRange(0, _entries.length - 100);
    if (before != _entries.length) _dirty = true;
  }

  Future<void> setEnabled(bool value) async {
    await load();
    _enabled = value;
    _dirty = true;
    _changed();
    await flush();
  }

  Future<void> setRetentionDays(int days) async {
    if (!retentionOptions.contains(days)) throw ArgumentError.value(days);
    await load();
    _retentionDays = days;
    _prune();
    _dirty = true;
    _changed();
    await flush();
  }

  Future<void> clear() async {
    await load();
    _entries.clear();
    _quarantined = false;
    _dirty = true;
    _changed();
    await flush();
  }

  Map<String, Object> _document() => {
        'schema': 1,
        'enabled': enabled,
        'retentionDays': retentionDays,
        'entries': _entries.map((e) => e.toJson()).toList()
      };
  String exportJson() {
    _prune();
    return const JsonEncoder.withIndent('  ').convert(_document());
  }

  Future<void> flush() {
    _queue = _queue.then((_) async {
      if (!_loaded || !_dirty || _quarantined) return;
      try {
        _prune();
        final text = jsonEncode(_document());
        _dirty = false;
        await _write(text);
        _storageProblem = null;
      } catch (_) {
        _dirty = true;
        _storageProblem = _storageMessage;
      }
      _changed();
    });
    return _queue;
  }

  void _changed() {
    if (_notificationPending || _disposed) return;
    _notificationPending = true;
    Timer.run(() {
      _notificationPending = false;
      if (!_disposed) notifyListeners();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Keeps normal Flutter presentation and the previous platform handling intact.
class NorieDiagnosticsHandlers {
  NorieDiagnosticsHandlers._(this.store);
  final NorieDiagnosticsStore store;
  bool _handling = false;
  late final FlutterExceptionHandler? _previousFlutter;
  late final bool Function(Object, StackTrace)? _previousPlatform;
  late final FlutterExceptionHandler _flutter;
  late final bool Function(Object, StackTrace) _platform;
  static NorieDiagnosticsHandlers install(NorieDiagnosticsStore store) {
    final handlers = NorieDiagnosticsHandlers._(store);
    handlers._previousFlutter = FlutterError.onError;
    handlers._previousPlatform = PlatformDispatcher.instance.onError;
    handlers._flutter = (details) {
      if (handlers._handling) return;
      handlers._handling = true;
      try {
        store.capture(details.exception,
            stack: details.stack, source: DiagnosticSource.flutter);
        (handlers._previousFlutter ?? FlutterError.presentError)(details);
      } finally {
        handlers._handling = false;
      }
    };
    handlers._platform = (error, stack) {
      if (handlers._handling) return false;
      handlers._handling = true;
      try {
        store.capture(error, stack: stack, source: DiagnosticSource.platform);
        return handlers._previousPlatform?.call(error, stack) ?? false;
      } finally {
        handlers._handling = false;
      }
    };
    FlutterError.onError = handlers._flutter;
    PlatformDispatcher.instance.onError = handlers._platform;
    return handlers;
  }

  void uninstall() {
    if (identical(FlutterError.onError, _flutter)) {
      FlutterError.onError = _previousFlutter;
    }
    if (identical(PlatformDispatcher.instance.onError, _platform)) {
      PlatformDispatcher.instance.onError = _previousPlatform;
    }
  }
}

class NorieDiagnosticsRouteObserver extends NavigatorObserver {
  NorieDiagnosticsRouteObserver(this.store);
  final NorieDiagnosticsStore store;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      store.setRoute(route.settings.name);
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      store.setRoute(previousRoute?.settings.name);
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      store.setRoute(newRoute?.settings.name);
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      store.setRoute(previousRoute?.settings.name);
}
