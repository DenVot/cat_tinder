import 'package:cat_tinder/core/shared_preferences_manager_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/cat.dart';

class SharedPreferencesManager implements SharedPreferencesManagerInterface {
  static const String _likedCatsKey = 'liked_cats';

  Future<void> saveLikedCats(List<Cat> cats) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = cats.map((cat) => cat.toJson()).toList();
    prefs.setString(_likedCatsKey, jsonEncode(jsonList));
  }

  Future<List<Cat>> getLikedCats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_likedCatsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Cat.fromJsonSharedPrefences(json)).toList();
  }
}
