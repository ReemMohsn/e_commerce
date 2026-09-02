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
      throw const CacheException('Your saved profile data is invalid.');
    } on PlatformException {
      throw const CacheException('Unable to access your saved profile.');
    } catch (_) {
      throw const CacheException(
        'Something went wrong while loading your profile.',
      );
    }
  }

  Future<ApiResponse<Object?>> editProfile({required UserModel userModel}) {
    return RequestHandler<Object?>(
      () =>
          _apiService.post(ApiEndPoints.editProfile, data: userModel.toJson()),
    );
  }
}
