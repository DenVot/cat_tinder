import '../models/cat.dart';

class LikeManager {
  final List<Cat> _likedCats = [];

  List<Cat> get likedCats => List.unmodifiable(_likedCats);

  void addLikedCat(Cat cat) {
    final likedCat = cat.copyWith(likedAt: DateTime.now());
    _likedCats.add(likedCat);
  }

  void removeLikedCat(Cat cat) {
    _likedCats.remove(cat);
  }
}
