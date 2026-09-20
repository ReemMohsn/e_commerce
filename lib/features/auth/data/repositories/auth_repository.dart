import 'package:e_commeric/core/constants/api_end_points.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/API/api_service.dart';
import 'package:e_commeric/core/services/API/request_handler.dart';
import 'package:e_commeric/core/services/shared_preferences_service.dart';
import 'package:e_commeric/features/auth/data/models/reset_password_request_model.dart';
import 'package:e_commeric/features/auth/data/models/sign_in_request_model.dart';
import 'package:e_commeric/features/auth/data/models/sign_in_response.dart';
import 'package:e_commeric/features/auth/data/models/sign_up_request_model.dart';
import 'package:e_commeric/features/auth/data/models/verify_code_request_model.dart';

class AuthRepository {
  const AuthRepository({
    required ApiService apiService,
    required SharedPreferencesService preferencesService,
  }) : _apiService = apiService,
       _preferencesService = preferencesService;

  final ApiService _apiService;
  final SharedPreferencesService _preferencesService;

  Future<ApiResponse<SignInResponse>> signIn(SignInRequestModel request) async {
    final response = await RequestHandler<SignInResponse>(
      () => _apiService.post(
        ApiEndPoints.signIn,
        data: request.toJson(),
      ),
      fromJson: SignInResponse.fromJson,
    );

    final session = response.data;
    await _preferencesService.saveSession(
      token: session?.token,
      profile: session?.user.toJson(),
    );
    return response;
  }

  Future<ApiResponse<Object?>> signUp(SignUpRequestModel request) {
    return RequestHandler<Object?>(
      () => _apiService.post(
        ApiEndPoints.signUp,
        data: request.toJson(),
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

  Future<ApiResponse<Object?>> activatePasswordReset(
    VerifyCodeRequestModel request,
  ) {
    return RequestHandler<Object?>(
      () => _apiService.post(
        ApiEndPoints.activatePasswordReset,
        data: request.toJson(),
      ),
    );
  }

  Future<ApiResponse<Object?>> resetPassword(ResetPasswordRequestModel request) {
    return RequestHandler<Object?>(
      () => _apiService.post(
        ApiEndPoints.resetPassword,
        data: request.toJson(),
      ),
    );
  }

  Future<void> signOut() => _preferencesService.clearSession();
}
