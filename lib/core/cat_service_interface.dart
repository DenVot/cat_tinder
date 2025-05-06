import '../models/cat.dart';

abstract class CatServiceInterface {
  Future<Cat> getRandomCat();
}
