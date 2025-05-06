import 'package:mocktail/mocktail.dart';
import 'package:cat_tinder/models/cat.dart';
import 'package:cat_tinder/core/cat_service_interface.dart';
import 'package:cat_tinder/core/shared_preferences_manager_interface.dart';

class MockCatService extends Mock implements CatServiceInterface {}

class MockSharedPreferencesManager extends Mock
    implements SharedPreferencesManagerInterface {}

class MockCat extends Mock implements Cat {}