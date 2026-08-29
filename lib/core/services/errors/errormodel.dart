class ErrorModel {
  const ErrorModel({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  factory ErrorModel.fromResponse(Object? response, {int? statusCode}) {
    final data = response is Map
        ? Map<String, dynamic>.from(response)
        : const <String, dynamic>{};
    final rawError = data['error'];
    final rawMessage =
        data['message'] ??
        data['msg'] ??
        data['errorMessage'] ??
        (rawError is String ? rawError : null);

    return ErrorModel(
      statusCode: statusCode ?? _asInt(data['statusCode']) ?? 0,
      message: rawMessage is String && rawMessage.trim().isNotEmpty
          ? rawMessage
          : _firstValidationMessage(data['errors']) ??
                'Something went wrong. Please try again.',
    );
  }

  static int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static String? _firstValidationMessage(Object? errors) {
    if (errors is List && errors.isNotEmpty) {
      return errors.first.toString();
    }
    if (errors is Map) {
      for (final value in errors.values) {
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value is String && value.isNotEmpty) return value;
      }
    }
    return null;
  }
}
