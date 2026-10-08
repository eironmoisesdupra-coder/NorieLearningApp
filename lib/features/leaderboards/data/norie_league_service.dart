import '../../../core/cloud/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/norie_league_models.dart';

class NorieLeagueException implements Exception {
  const NorieLeagueException(this.code);
  final String code;
  bool get terminalAttempt => const [
        'expired_attempt',
        'season_closed',
        'invalid_attempt',
        'invalid_nonce',
        'source_version_changed',
        'not_eligible',
        'approved_membership_required',
        'administrator_approval_required',
        'invalid_answers',
        'unexpected_question',
        'invalid_answer_index'
      ].contains(code);
}

class NorieLeagueService {
  Future<NorieLeagueBadgeShelf> badges() async {
    final response = await call('badges');
    return NorieLeagueBadgeShelf(
        fetchedAt: DateTime.now().toUtc(),
        badges: (response['badges'] as List)
            .map((r) =>
                NorieLeagueBadge.fromJson(Map<String, dynamic>.from(r as Map)))
            .toList());
  }

  bool get configured => NorieSupabase.isInitialized;
  Future<Map<String, dynamic>> call(String action,
      [Map<String, dynamic> fields = const {}]) async {
    final client = NorieSupabase.client;
    if (client == null || client.auth.currentUser == null) {
      throw StateError(
          'Sign in to an approved account to use private leagues.');
    }
    try {
      final response = await client.functions
          .invoke('verified-leagues', body: {'action': action, ...fields});
      final data = Map<String, dynamic>.from(response.data as Map);
      if (data['error'] != null) {
        throw NorieLeagueException(data['error'] as String);
      }
      return data;
    } on FunctionException catch (error) {
      final details = error.details;
      if (details is Map && details['error'] is String) {
        throw NorieLeagueException(details['error'] as String);
      }
      rethrow;
    }
  }

  Future<List<NorieLeagueSnapshot>> boards() async {
    final response = await call('boards');
    return (response['boards'] as List)
        .map((row) =>
            NorieLeagueSnapshot.fromJson(Map<String, dynamic>.from(row as Map)))
        .toList();
  }
}
