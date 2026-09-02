import 'package:dio/dio.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/errors/errormodel.dart';
import 'package:e_commeric/core/services/errors/exception.dart';

Future<ApiResponse<T>> RequestHandler<T>(
  Future<Response<dynamic>> Function() request, {
  T Function(Object? data)? fromJson,
}) async {
  try {
    final response = await request();
    final responseBody = response.data;

    if (responseBody is! Map) {
      throw ServerException(
        ErrorModel(
          message: 'The data format coming from the server is not supported.',
          statusCode: response.statusCode ?? 0,
        ),
      );
    }

    final json = Map<String, dynamic>.from(responseBody);

    final rawMessage = json['message'];

    final message = rawMessage is String && rawMessage.isNotEmpty
        ? rawMessage
        : 'The operation was completed successfully';

    final rawData = json['data'];

    final T? parsedData = fromJson != null
        ? fromJson(rawData ?? json)
        : rawData as T?;

    return ApiResponse<T>(data: parsedData, message: message);
  } on DioException catch (error) {
    handleDioExceptions(error);
  }
}
