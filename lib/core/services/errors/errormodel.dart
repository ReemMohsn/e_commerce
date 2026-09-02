class ErrorModel {
  const ErrorModel({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  factory ErrorModel.fromResponse(Object? response, {int? statusCode}) {
    final data = response is Map ? response : const <String, dynamic>{};

    final rawMessage = data['message'];

    return ErrorModel(
      statusCode: statusCode ?? 0,
      message: rawMessage is String && rawMessage.trim().isNotEmpty
          ? rawMessage
          : 'Something went wrong. Please try again.',
    );
  }
}
