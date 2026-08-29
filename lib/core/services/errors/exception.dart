import 'package:dio/dio.dart';
import 'package:e_commeric/core/services/errors/errormodel.dart';

class ServerException implements Exception {
  const ServerException(this.error);

  final ErrorModel error;

  String get message => error.message;

  @override
  String toString() => message;
}

Never handleDioExceptions(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.connectionError:
      throw const ServerException(
        ErrorModel(
          statusCode: 0,
          message: 'Unable to connect. Please check your internet connection.',
        ),
      );
    case DioExceptionType.cancel:
      throw const ServerException(
        ErrorModel(statusCode: 0, message: 'The request was cancelled.'),
      );
    case DioExceptionType.badResponse:
      throw ServerException(
        ErrorModel.fromResponse(
          error.response?.data,
          statusCode: error.response?.statusCode,
        ),
      );
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      throw const ServerException(
        ErrorModel(
          statusCode: 0,
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
  }
}
