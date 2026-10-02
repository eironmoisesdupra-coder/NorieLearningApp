import 'dart:convert';
import '../account/norie_account_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_result_summary.dart';

class QuizHistoryComparison {
  const QuizHistoryComparison(
      {this.previousPercentage,
      required this.percentage,
      required this.isNew,
      required this.specialPerfect});
  final double? previousPercentage;
  final double percentage;
  final bool isNew, specialPerfect;
  double? get improvement =>
      previousPercentage == null ? null : percentage - previousPercentage!;
}

/// Local result evidence only; progression remains with existing reward owners.
/// Retains the latest 200 attempts. Special perfection is once per comparable
/// quiz per local calendar day, never replayed when an attempt is reopened.
class QuizResultHistory {
  QuizResultHistory({String? learnerId}) : _learnerId = learnerId;
  final String? _learnerId;
  static const storageKey = 'norie.quiz.result_history.v2:local';
  static String storageKeyFor(String? learnerId) => learnerId == null
      ? storageKey
      : 'norie.quiz.result_history.v2:account:${jsonEncode(learnerId)}';
  static Future<void>? _queue;
  Future<QuizHistoryComparison> record(QuizResultSummary summary,
      {DateTime? now}) {
    // Capture identity before queued work to avoid account-switch races.
    final key =
        storageKeyFor(_learnerId ?? NorieAccountService.instance.user?.id);
    final pending = _queue;
    final result = pending == null
        ? _record(summary, now ?? DateTime.now(), key)
        : pending.then((_) => _record(summary, now ?? DateTime.now(), key));
    final completion =
        result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    _queue = completion;
    completion.then((_) {
      if (identical(_queue, completion)) _queue = null;
    });
    return result;
  }

  Future<QuizHistoryComparison> _record(
      QuizResultSummary s, DateTime now, String key) async {
    if (!s.isComplete || s.totalCount == 0) {
      return QuizHistoryComparison(
          percentage: s.percentage, isNew: false, specialPerfect: false);
    }
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> rows = [];
    try {
      final decoded = jsonDecode(prefs.getString(key) ?? '[]');
      if (decoded is List) {
        rows = decoded
            .whereType<Map>()
            .map((r) => Map<String, dynamic>.from(r))
            .where((r) =>
                r['id'] is String &&
                r['key'] is String &&
                r['percentage'] is num)
            .toList();
      }
    } on FormatException {/* A damaged cache must not block learning. */}
    final existing = rows
        .where((r) => r['id'] == s.attemptId && r['key'] == s.historyKey)
        .firstOrNull;
    if (existing != null) {
      return QuizHistoryComparison(
          percentage: s.percentage,
          previousPercentage: existing['previous'] is num
              ? (existing['previous'] as num).toDouble()
              : null,
          isNew: false,
          specialPerfect: false);
    }
    final comparable = rows.where((r) => r['key'] == s.historyKey).toList();
    final previous = comparable.isEmpty
        ? null
        : (comparable.last['percentage'] as num).toDouble();
    final day = '${now.year}-${now.month}-${now.day}';
    final special = s.isPerfect &&
        !comparable.any((r) => r['day'] == day && r['perfect'] == true);
    rows.add({
      'id': s.attemptId,
      'key': s.historyKey,
      'percentage': s.percentage,
      'previous': previous,
      'perfect': s.isPerfect,
      'day': day
    });
    if (rows.length > 200) rows = rows.sublist(rows.length - 200);
    await prefs.setString(key, jsonEncode(rows));
    return QuizHistoryComparison(
        previousPercentage: previous,
        percentage: s.percentage,
        isNew: true,
        specialPerfect: special);
  }
}
