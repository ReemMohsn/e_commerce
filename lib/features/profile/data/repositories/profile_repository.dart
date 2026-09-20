import 'package:e_commeric/core/constants/app_strings.dart';
import 'package:e_commeric/core/constants/api_end_points.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/API/request_handler.dart';
import 'package:e_commeric/core/services/errors/cache_exception.dart';
import 'package:e_commeric/core/services/shared_preferences_service.dart';
import 'package:e_commeric/features/profile/data/models/user_model.dart';
import 'package:flutter/services.dart';

class ProfileRepository {
  const ProfileRepository({
    required ApiService apiService,
    required SharedPreferencesService preferencesService,
  }) : _apiService = apiService,
       _preferencesService = preferencesService;

  final ApiService _apiService;
  final SharedPreferencesService _preferencesService;

  Future<UserModel?> getCurrentUser() async {
    try {
      final json = await _preferencesService.profile;

      if (json == null) return null;

      return UserModel.fromJson(json);
    } on FormatException {
      throw const CacheException(AppStrings.yourSavedProfileDataIsInvalid);
    } on PlatformException {
      throw const CacheException(AppStrings.unableToAccessYourSavedProfile);
    } catch (_) {
      throw const CacheException(
        AppStrings.somethingWentWrongWhileLoadingYourProfile,
      );
    }
  }

  Future<ApiResponse<Object?>> editProfile({
    required UserModel userModel,
  }) async {
    final response = await RequestHandler<Object?>(
      () =>
          _apiService.post(ApiEndPoints.editProfile, data: userModel.toJson()),
    );

    try {
      // The edit endpoint returns only a message. Update the cache before
      // returning so screens reloading on navigation see the saved values.
      final savedProfile = await _preferencesService.profile;
      await _preferencesService.saveProfile({
        ...?savedProfile,
        ...userModel.toJson(),
      });
    } catch (_) {
      throw const CacheException(
        AppStrings.yourProfileWasUpdatedButCouldNotBeSavedOnThisDevicePleaseSignInAgainToRefreshYourProfile,
      );
    }

    return response;
  }
}
