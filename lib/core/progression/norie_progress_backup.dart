import 'dart:convert';
import 'norie_lesson_journey.dart';
import 'norie_adventure_progress.dart';
import '../../features/profile/data/norie_profile_appearance_store.dart';

/// Portable learning state only. Authentication/session preferences never enter
/// this format. Decode validates the entire snapshot before the caller imports.
abstract final class NorieProgressBackup {
  static const maxBytes = 5 * 1024 * 1024;
  static const _numbers = [
    'total_xp',
    'credits',
    'streak_shields',
    'completed_lessons',
    'study_sessions',
    'correct_answers',
    'questions_answered',
    'challenge_sessions',
    'speed_best_score',
  ];
  static const _lists = [
    'owned_shop_items',
    'explored_subjects',
    'study_dates',
    'daily_challenge_dates',
    'speed_reward_dates',
    'weekly_rewarded_weeks',
    'completed_topic_ids',
    'rewarded_lesson_topics',
    'rewarded_perfect_lesson_topics',
  ];
  static const _equipment = [
    'equipped_frame_id',
    'equipped_badge_id',
    'equipped_theme_id'
  ];

  static String encode(Map<String, dynamic> state, {String? owner}) {
    validateState(state);
    final encoded = const JsonEncoder.withIndent('  ').convert({
      'format': 'norie-learning-progress',
      'version': 1,
      'owner': owner,
      'exported_at': DateTime.now().toUtc().toIso8601String(),
      'state': state,
    });
    if (utf8.encode(encoded).length > maxBytes) {
      throw const FormatException('Progress backup is too large.');
    }
    return encoded;
  }

  static Map<String, dynamic> decode(String text, {String? currentOwner}) {
    if (utf8.encode(text).length > maxBytes) {
      throw const FormatException('Progress backup is too large.');
    }
    final doc = jsonDecode(text);
    if (doc is! Map<String, dynamic> ||
        doc['format'] != 'norie-learning-progress' ||
        doc['version'] != 1) {
      throw const FormatException('Choose a supported Norie progress backup.');
    }
    final owner = doc['owner'];
    if (owner != null && (owner is! String || owner != currentOwner)) {
      throw const FormatException(
          'Sign in to the account that owns this backup.');
    }
    final state = doc['state'];
    if (state is! Map<String, dynamic>) {
      throw const FormatException('Missing progress.');
    }
    validateState(state);
    return state;
  }

  static void validateState(Map<String, dynamic> state) {
    const remaining = [
      'schema_version',
      'credit_transactions',
      'topic_mastery',
      'onboarding_complete',
      'modified_at',
      'lesson_journey',
      'adventure_progress',
      'profile_appearance',
      'rewarded_assessment_attempts'
    ];
    final allowed = {..._numbers, ..._lists, ..._equipment, ...remaining};
    if (state.keys.any((key) => !allowed.contains(key)) ||
        state['schema_version'] != 1 ||
        state['onboarding_complete'] is! bool ||
        DateTime.tryParse(state['modified_at']?.toString() ?? '') == null) {
      throw const FormatException('Invalid progress snapshot.');
    }
    for (final key in _numbers) {
      final value = state[key];
      if (value is! int || value < 0 || value > 1000000000) {
        throw FormatException('Invalid $key in backup.');
      }
    }
    for (final key in _lists) {
      final value = state[key];
      if (value is! List ||
          value.length > 100000 ||
          value.any((item) => item is! String || item.length > 512)) {
        throw FormatException('Invalid $key in backup.');
      }
    }
    for (final key in _equipment) {
      if (!state.containsKey(key) ||
          (state[key] != null && state[key] is! String)) {
        throw const FormatException('Invalid equipped item.');
      }
    }
    final transactions = state['credit_transactions'];
    if (transactions is! List || transactions.length > 100000) {
      throw const FormatException('Invalid reward history.');
    }
    const transactionKeys = {'id', 'amount', 'reason', 'created_at'};
    for (final item in transactions) {
      if (item is! Map ||
          item.keys.any((key) => !transactionKeys.contains(key)) ||
          item['id'] is! String ||
          (item['id'] as String).isEmpty ||
          (item['id'] as String).length > 512 ||
          item['reason'] is! String ||
          (item['reason'] as String).length > 1024 ||
          item['amount'] is! int ||
          (item['amount'] as int).abs() > 1000000000 ||
          DateTime.tryParse(item['created_at']?.toString() ?? '') == null) {
        throw const FormatException('Invalid reward receipt.');
      }
    }
    final mastery = state['topic_mastery'];
    if (mastery is! Map || mastery.length > 100000) {
      throw const FormatException('Invalid mastery history.');
    }
    const masteryKeys = {'category', 'topic', 'correct', 'attempts'};
    for (final entry in mastery.entries) {
      final key = entry.key;
      final item = entry.value;
      if (key is! String ||
          key.isEmpty ||
          key.length > 512 ||
          item is! Map ||
          item.keys.any((key) => !masteryKeys.contains(key)) ||
          item['category'] is! String ||
          (item['category'] as String).isEmpty ||
          (item['category'] as String).length > 512 ||
          item['topic'] is! String ||
          (item['topic'] as String).isEmpty ||
          (item['topic'] as String).length > 512 ||
          item['correct'] is! int ||
          item['attempts'] is! int ||
          (item['correct'] as int) < 0 ||
          (item['attempts'] as int) < (item['correct'] as int) ||
          (item['attempts'] as int) > 1000000000) {
        throw const FormatException('Invalid mastery result.');
      }
    }
    if (state.containsKey('lesson_journey')) {
      NorieLessonJourney.validateState(state['lesson_journey']);
    }
    if (state.containsKey('adventure_progress')) {
      NorieAdventureProgress.validateState(state['adventure_progress']);
    }
    if (state.containsKey('profile_appearance')) {
      NorieProfileAppearanceStore.validateState(state['profile_appearance']);
    }
    final attempts = state['rewarded_assessment_attempts'];
    if (attempts != null &&
        (attempts is! List ||
            attempts.length > 100000 ||
            attempts.any((a) => a is! String || a.isEmpty || a.length > 512))) {
      throw const FormatException('Invalid assessment reward receipts.');
    }
  }
}
