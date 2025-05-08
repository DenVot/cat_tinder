import 'package:flutter/material.dart';
import '../models/cat.dart';
import '../services/like_manager.dart';

class CatState with ChangeNotifier {
  final LikeManager _likeManager;

  CatState(this._likeManager);

  List<Cat> _likedCats = [];
  String? _selectedBreed;

  List<Cat> get likedCats => List.unmodifiable(_likedCats);

  String? get selectedBreed => _selectedBreed;

  Future<void> loadInitialData() async {
    _likedCats = await _likeManager.getLikedCats();

    notifyListeners();
  }

  Future<List<Cat>> loadLikedCats() {
    return _likeManager.getLikedCats();
  }

  Future<void> addLikedCat(Cat cat) {
    return _likeManager.addLikedCat(cat).whenComplete(loadInitialData);
  }

  Future<void> removeLikedCat(Cat cat) {
    return _likeManager.removeLikedCat(cat).whenComplete(loadInitialData);
  }

  void setSelectedBreed(String? breed) {
    _selectedBreed = breed;
    notifyListeners();
  }

  List<Cat> get filteredCats {
    if (_selectedBreed == null || _selectedBreed == 'Все породы') {
      return _likedCats;
    }
    return _likedCats.where((cat) => cat.breedName == _selectedBreed).toList();
  }

  List<String> get uniqueBreeds {
    final breeds = _likedCats.map((cat) => cat.breedName).toSet().toList();
    breeds.insert(0, 'Все породы');
    return breeds;
  }
}
