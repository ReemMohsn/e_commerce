class ApiResponse<T> {
  const ApiResponse({required this.data, required this.message});

  final T? data;
  final String message;
}
