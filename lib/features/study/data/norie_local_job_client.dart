import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class NorieLocalJobClient {
  NorieLocalJobClient({
    required this.base,
    http.Client? client,
    this.pollInterval = const Duration(seconds: 2),
    this.requestTimeout = const Duration(seconds: 15),
    this.totalTimeout = const Duration(minutes: 55),
  }) : _client = client ?? http.Client();

  final Uri base;
  final http.Client _client;
  final Duration pollInterval;
  final Duration requestTimeout;
  final Duration totalTimeout;
  final _pending = <String, Future<Map<String, dynamic>>>{};

  Future<Map<String, dynamic>> run(String kind, Map<String, dynamic> input,
      {void Function(Map<String, dynamic>)? onProgress}) {
    if (base.scheme != 'http' ||
        !const ['localhost', '127.0.0.1'].contains(base.host) ||
        base.userInfo.isNotEmpty) {
      throw StateError('Local AI must use a loopback HTTP address.');
    }
    final fingerprint = const Uuid()
        .v5(Namespace.url.value, jsonEncode([base.toString(), kind, input]));
    final storageKey = 'norie.local-job.$fingerprint';
    return _pending.putIfAbsent(
        storageKey,
        () => _run(kind, input, storageKey, onProgress).whenComplete(() {
              _pending.remove(storageKey);
            }));
  }

  Future<Map<String, dynamic>> _run(
      String kind,
      Map<String, dynamic> input,
      String storageKey,
      void Function(Map<String, dynamic>)? onProgress) async {
    final preferences = await SharedPreferences.getInstance();
    final key = preferences.getString(storageKey) ?? const Uuid().v4();
    if (!await preferences.setString(storageKey, key)) {
      throw StateError('Could not save the local job retry key.');
    }
    final headers = {
      'Content-Type': 'application/json',
      'X-Norie-Job-Key': key,
    };
    Future<Map<String, dynamic>> decode(Future<http.Response> pending) async {
      final response = await pending.timeout(requestTimeout);
      final value = jsonDecode(response.body);
      if (value is! Map) throw StateError('Invalid response from local AI.');
      if (response.statusCode != 200 && response.statusCode != 202) {
        if (response.statusCode >= 400 && response.statusCode < 500) {
          await preferences.remove(storageKey);
        }
        throw StateError(value['error']?.toString() ?? 'Local request failed.');
      }
      return Map<String, dynamic>.from(value);
    }

    try {
      final elapsed = Stopwatch()..start();
      var job = await decode(_client.post(base.resolve('/api/jobs'),
          headers: headers, body: jsonEncode({'kind': kind, 'input': input})));
      while (true) {
        onProgress?.call(job);
        if (job['status'] == 'succeeded') {
          final result = Map<String, dynamic>.from(job['result'] as Map);
          await preferences.remove(storageKey);
          return result;
        }
        if (const ['failed', 'cancelled', 'expired'].contains(job['status'])) {
          await preferences.remove(storageKey);
          throw StateError(
              job['error']?.toString() ?? 'Local job did not finish.');
        }
        if (!const ['queued', 'running'].contains(job['status']) ||
            job['id'] is! String) {
          throw StateError('Invalid job status from local AI.');
        }
        if (elapsed.elapsed >= totalTimeout) {
          throw StateError(
              'Still waiting for local AI. Retry with the same input to reconnect to this job.');
        }
        await Future<void>.delayed(pollInterval);
        job = await decode(_client.get(
            base.resolve(
                '/api/jobs/${Uri.encodeComponent(job['id'] as String)}'),
            headers: headers));
      }
    } on http.ClientException {
      throw StateError(
          'Local AI connection interrupted. Start the local server and retry with the same input to reconnect.');
    } on TimeoutException {
      throw StateError(
          'Local AI is not responding. Retry with the same input to reconnect to this job.');
    }
  }

  void close() => _client.close();
}
