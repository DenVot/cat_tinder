import 'package:get_it/get_it.dart';
import 'services/cat_service.dart';
import 'states/cat_state.dart';

final GetIt deps = GetIt.instance;

void setupDeps() {
  deps.registerLazySingleton<CatService>(() => CatService());

  deps.registerFactory<CatState>(() => CatState());
}
