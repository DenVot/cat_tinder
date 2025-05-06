import '../models/cat.dart';
import '../core/shared_preferences_manager_interface.dart';

class LikeManager {
  final SharedPreferencesManagerInterface _prefs;

  LikeManager(this._prefs);

  Future<void> addLikedCat(Cat cat) async {
    final likedCat = cat.copyWith(likedAt: DateTime.now());
    final currentList = await _prefs.getLikedCats();
    final newList = [...currentList, likedCat];
    await _prefs.saveLikedCats(newList);
  }

  Future<void> removeLikedCat(Cat cat) async {
    final currentList = await _prefs.getLikedCats();
    final newList = currentList.where((c) => c.id != cat.id).toList();
    await _prefs.saveLikedCats(newList);
  }

  Future<List<Cat>> getLikedCats() async {
    return await _prefs.getLikedCats();
  }
}