import 'package:flutter/material.dart';
import 'package:cat_tinder/states/cat_state.dart';
import 'package:cat_tinder/models/cat.dart';
import 'package:cat_tinder/services/like_manager.dart';
import 'package:cat_tinder/core/cat_service_interface.dart';
import 'package:cat_tinder/core/shared_preferences_manager_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'mocks/mock_classes.dart';
import 'package:test/test.dart';
import 'package:flutter/material.dart';
import 'package:cat_tinder/states/cat_state.dart';
import 'package:cat_tinder/models/cat.dart';
import 'package:cat_tinder/services/like_manager.dart';
import 'mocks/mock_classes.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('CatState Interaction Tests', () {
    late MockSharedPreferencesManager mockPrefs;
    late LikeManager likeManager;
    late CatState catState;
    late Cat testCat;

    setUp(() {
      mockPrefs = MockSharedPreferencesManager();
      likeManager = LikeManager(mockPrefs);
      catState = CatState(likeManager);

      testCat = Cat(
        id: '1',
        url: 'https://example.com/cat.jpg',
        breedName: 'Сиамская',
        weight: '4.5',
        height: '25',
        lifeSpan: '15',
      );
    });

    test('должен вызвать saveLikedCats при добавлении котика', () async {
      when(() => mockPrefs.getLikedCats()).thenAnswer((_) async => []);
      when(() => mockPrefs.saveLikedCats(any()))
          .thenAnswer((_) async => {});

      await catState.addLikedCat(testCat);

      verify(() => mockPrefs.saveLikedCats(any())).called(1);
    });

    test('должен вызвать saveLikedCats без старого котика при удалении', () async {
      final catInList = Cat(
        id: '2',
        url: 'url2',
        breedName: 'Мейн-кун',
        weight: '6',
        height: '30',
        lifeSpan: '12',
      );

      when(() => mockPrefs.getLikedCats())
          .thenAnswer((_) async => [testCat, catInList]);
      when(() => mockPrefs.saveLikedCats(any()))
          .thenAnswer((_) async => {});

      await catState.removeLikedCat(testCat);

      verify(() => mockPrefs.saveLikedCats([catInList])).called(1);
    });

    test('должен загрузить котиков из getLikedCats при инициализации', () async {
      final catsFromStorage = [
        Cat(
          id: '3',
          url: 'url3',
          breedName: 'Бенгальская',
          weight: '5',
          height: '28',
          lifeSpan: '14',
        )
      ];

      when(() => mockPrefs.getLikedCats())
          .thenAnswer((_) async => catsFromStorage);

      await catState.loadInitialData();

      verify(() => mockPrefs.getLikedCats()).called(1);
    });
  });
}
