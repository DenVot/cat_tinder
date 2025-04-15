import 'package:flutter/material.dart';
import '../models/cat.dart';

class CatState with ChangeNotifier {
  final List<Cat> _likedCats = [];
  String? _selectedBreed;

  List<Cat> get likedCats => List.unmodifiable(_likedCats);
  String? get selectedBreed => _selectedBreed;

  void addLikedCat(Cat cat) {
    final likedCat = cat.copyWith(likedAt: DateTime.now());
    _likedCats.add(likedCat);
    notifyListeners();
  }

  void removeLikedCat(Cat cat) {
    _likedCats.remove(cat);
    notifyListeners();
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
