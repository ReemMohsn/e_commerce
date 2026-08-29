import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/shared_preferences_service.dart';
import 'package:e_commeric/features/auth/data/repositories/auth_repository.dart';
import 'package:e_commeric/features/home/data/repositories/home_repository.dart';
import 'package:e_commeric/features/search/data/repositories/search_repository.dart';

class AppServices {
  AppServices._();

  static final SharedPreferencesService preferences =
      SharedPreferencesService();

  static final ApiService api = ApiService(preferences);

  static final AuthRepository authRepository = AuthRepository(
    apiService: api,
    preferencesService: preferences,
  );

  static final HomeRepository homeRepository = HomeRepository(apiService: api);

  static final SearchRepository searchRepository = SearchRepository(
    apiService: api,
  );
}
