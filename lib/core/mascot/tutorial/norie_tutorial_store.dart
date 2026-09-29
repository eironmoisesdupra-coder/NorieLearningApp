import 'package:shared_preferences/shared_preferences.dart';

class NorieTutorialStore {
  NorieTutorialStore({SharedPreferences? preferences})
      : _preferences = preferences;

  final SharedPreferences? _preferences;

  Future<SharedPreferences> _prefs() async {
    return _preferences ?? SharedPreferences.getInstance();
  }

  String _key(String tutorialId) => 'norie.tutorial.$tutorialId.complete';

  Future<bool> isComplete(String tutorialId) async {
    final prefs = await _prefs();
    return prefs.getBool(_key(tutorialId)) ?? false;
  }

  Future<void> markComplete(String tutorialId) async {
    final prefs = await _prefs();
    await prefs.setBool(_key(tutorialId), true);
  }
}
