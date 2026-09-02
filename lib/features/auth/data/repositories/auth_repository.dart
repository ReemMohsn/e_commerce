import 'package:e_commeric/core/constants/api_end_points.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/API/request_handler.dart';
import 'package:e_commeric/core/services/shared_preferences_service.dart';
import 'package:e_commeric/features/auth/data/models/sign_in_response.dart';

class AuthRepository {
  const AuthRepository({
    required ApiService apiService,
    required SharedPreferencesService preferencesService,
  }) : _apiService = apiService,
       _preferencesService = preferencesService;

  final ApiService _apiService;
  final SharedPreferencesService _preferencesService;

  Future<ApiResponse<SignInResponse>> signIn({
    required String email,
    required String password,
  }) async {
    final response = await RequestHandler<SignInResponse>(
      () => _apiService.post(
        ApiEndPoints.signIn,
        data: {'email': email.trim(), 'password': password},
      ),
      fromJson: SignInResponse.fromJson,
    );

    final session = response.data;
    await _preferencesService.saveSession(
      token: session?.token,
      profile: session?.user,
    );
    return response;
  }

  Future<ApiResponse<Object?>> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return RequestHandler<Object?>(
      () => _apiService.post(
        ApiEndPoints.signUp,
        data: {
          'name': name.trim(),
          'phone': phone.trim(),
          'email': email.trim(),
          'password': password,
          'confirmPassword': confirmPassword,
        },
      ),
    );
  }

  Future<ApiResponse<Object?>> requestPasswordResetCode(String email) async {
    return RequestHandler<Object?>(
      () => _apiService.post(
        ApiEndPoints.requestResetCode,
        data: {'email': email.trim()},
      ),
    );
  }

  Future<ApiResponse<Object?>> activatePasswordReset({
    required String email,
    required String code,
  }) {
    return RequestHandler<Object?>(
      () => _apiService.post(
        ApiEndPoints.activatePasswordReset,
        data: {'email': email.trim(), 'code': code},
      ),
    );
  }

  Future<ApiResponse<Object?>> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return RequestHandler<Object?>(
      () => _apiService.post(
        ApiEndPoints.resetPassword,
        data: {
          'email': email.trim(),
          'password': password,
          'confirmPassword': confirmPassword,
        },
      ),
    );
  }

  Future<void> signOut() => _preferencesService.clearSession();
}
