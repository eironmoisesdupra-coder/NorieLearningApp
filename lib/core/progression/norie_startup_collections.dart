import 'norie_adventure_progress.dart';
import 'norie_progression.dart';
import '../../features/profile/data/norie_profile_appearance_store.dart';

/// Prepare optional collections after loading existing local learning state.
Future<bool> prepareNorieStartupCollections() async {
  final appearance = () async {
    await NorieProfileAppearanceStore.instance
        .unlockRank(NorieProgression.instance.snapshot.level);
    // Also retry a previously failed migration whose rank is already in memory.
    await NorieProfileAppearanceStore.instance.flush();
  }();
  NorieProgression.instance.refreshGradeTrophies();
  // Optional persistence cannot prevent the offline library from opening.
  // Explicit later saves still report their failures and can retry both stores.
  final results = await Future.wait([
    for (final save in [appearance, NorieAdventureProgress.instance.flush()])
      save.then<bool>((_) => true, onError: (Object _, StackTrace __) => false),
  ]);
  return results.every((saved) => saved);
}
