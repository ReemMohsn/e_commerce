import 'package:dio/dio.dart';
import 'package:e_commeric/core/constants/api_link.dart';
import 'package:e_commeric/core/services/API/api_interceptors.dart';
import 'package:e_commeric/core/services/shared_preferences_service.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  ApiService(SharedPreferencesService preferencesService)
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiLink.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          receiveDataWhenStatusError: true,
        ),
      ) {
    _dio.interceptors.add(AuthInterceptor(preferencesService));
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  final Dio _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> patch(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.patch(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<dynamic>> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.delete(path, data: data, queryParameters: queryParameters);
  }
}
