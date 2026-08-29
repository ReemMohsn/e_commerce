import 'package:e_commeric/core/constants/api_link.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/API/repository_request_handler.dart';
import 'package:e_commeric/core/services/shared_preferences_service.dart';
import 'package:e_commeric/features/auth/data/models/auth_session.dart';

class AuthRepository {
  const AuthRepository({
    required ApiService apiService,
    required SharedPreferencesService preferencesService,
  }) : _apiService = apiService,
       _preferencesService = preferencesService;

  final ApiService _apiService;
  final SharedPreferencesService _preferencesService;

  Future<ApiResponse<AuthSession>> signIn({
    required String email,
    required String password,
  }) async {
    final response = await repositoryRequestHandler<AuthSession>(
      () => _apiService.post(
        ApiLink.signIn,
        data: {'email': email.trim(), 'password': password},
      ),
      fromJson: AuthSession.fromJson,
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
    return repositoryRequestHandler<Object?>(
      () => _apiService.post(
        ApiLink.signUp,
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
    _preferencesService.setResetEmail(email);
    return repositoryRequestHandler<Object?>(
      () => _apiService.post(
        ApiLink.requestResetCode,
        data: {'email': email.trim()},
      ),
    );
  }

  Future<ApiResponse<Object?>> activatePasswordReset({
    required String email,
    required String code,
  }) {
    return repositoryRequestHandler<Object?>(
      () => _apiService.post(
        ApiLink.activatePasswordReset,
        data: {'email': email.trim(), 'code': code},
      ),
    );
  }

  Future<ApiResponse<Object?>> resetPassword({
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return repositoryRequestHandler<Object?>(
      () => _apiService.post(
        ApiLink.resetPassword,
        data: {
          'email': email.trim(),
          'password': password,
          'confirmPassword': confirmPassword,
        },
      ),
    );
  }

  Future<void> clearResetData() => _preferencesService.removeResetData();

  Future<void> signOut() => _preferencesService.clearSession();
}
