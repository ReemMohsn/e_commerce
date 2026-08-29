import 'package:dio/dio.dart';
import 'package:e_commeric/core/services/API/api_response.dart';
import 'package:e_commeric/core/services/errors/errormodel.dart';
import 'package:e_commeric/core/services/errors/exception.dart';

Future<ApiResponse<T>> repositoryRequestHandler<T>(
  Future<Response<dynamic>> Function() request, {
  T Function(Object? data)? fromJson,
}) async {
  try {
    final response = await request();
    final responseBody = response.data;

    if (responseBody is! Map) {
      throw ServerException(
        ErrorModel(
          message: 'صيغة البيانات القادمة من الخادم غير مدعومة',
          statusCode: response.statusCode ?? 0,
        ),
      );
    }

    final json = Map<String, dynamic>.from(responseBody);

    final rawMessage = json['message'];

    final message = rawMessage is String && rawMessage.isNotEmpty
        ? rawMessage
        : 'تمت العملية بنجاح';

    final rawData = json['data'];

    final T? parsedData = fromJson != null
        ? fromJson(rawData ?? json)
        : rawData as T?;

    return ApiResponse<T>(data: parsedData, message: message);
  } on DioException catch (error) {
    handleDioExceptions(error);
  }
}
