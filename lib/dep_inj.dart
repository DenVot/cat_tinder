import 'package:get_it/get_it.dart';
import 'services/cat_service.dart';
import 'states/cat_state.dart';
import 'core/cat_service_interface.dart';
import 'core/shared_preferences_manager_interface.dart';
import 'utils/shared_prefs_manager.dart';
import 'services/like_manager.dart';

final GetIt deps = GetIt.instance;

void setupDeps() {
  deps.registerLazySingleton<CatServiceInterface>(() => CatService());
  deps.registerFactory<SharedPreferencesManagerInterface>(
      () => SharedPreferencesManager());
  deps.registerFactory<CatState>(() {
    final likeManager = LikeManager(deps<SharedPreferencesManagerInterface>());
    return CatState(likeManager);
  });
}
