import 'package:dio/dio.dart';
import 'package:e_commeric/core/services/shared_preferences_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._preferencesService);

  final SharedPreferencesService _preferencesService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _preferencesService.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    handler.next(options);
  }
}
