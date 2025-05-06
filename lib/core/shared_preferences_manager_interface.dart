import '../models/cat.dart';

abstract class SharedPreferencesManagerInterface {
  Future<void> saveLikedCats(List<Cat> cats);
  Future<List<Cat>> getLikedCats();
}
