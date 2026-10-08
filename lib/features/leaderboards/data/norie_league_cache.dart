import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/norie_league_models.dart';

class NorieLeagueCache {
  static String badgeKeyFor(String owner) => '${keyFor(owner)}:emblems';
  Future<NorieLeagueBadgeShelf?> readBadges(String owner) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final raw = prefs.getString(badgeKeyFor(owner));
      if (raw == null) return null;
      return NorieLeagueBadgeShelf.fromJson(
          Map<String, dynamic>.from(jsonDecode(raw) as Map));
    } catch (_) {
      return null;
    }
  }

  Future<void> writeBadges(String owner, NorieLeagueBadgeShelf shelf) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(
        badgeKeyFor(owner), jsonEncode(shelf.toJson()))) {
      await prefs
          .reload(); // Discard optimistic memory data after failed disk writes.
      throw StateError(
          'Could not save the league emblem cache on this device.');
    }
  }

  static String keyFor(String owner) =>
      'norie.private_leagues.v1:${jsonEncode(owner)}';
  Future<List<NorieLeagueSnapshot>> read(String owner) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final decoded =
          jsonDecode(prefs.getString(keyFor(owner)) ?? '[]') as List;
      return decoded
          .map((r) =>
              NorieLeagueSnapshot.fromJson(Map<String, dynamic>.from(r as Map)))
          .toList();
    } catch (_) {
      return []; // Damaged local cache must not block offline lessons.
    }
  }

  Future<void> write(String owner, List<NorieLeagueSnapshot> boards) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(
        keyFor(owner), jsonEncode(boards.map((b) => b.toJson()).toList()))) {
      await prefs.reload();
      throw StateError(
          'Could not save private league standings on this device.');
    }
  }

  Future<void> clear(String owner) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.remove(keyFor(owner))) {
      await prefs.reload();
      throw StateError(
          'Could not remove the private league cache on this device.');
    }
  }
}
