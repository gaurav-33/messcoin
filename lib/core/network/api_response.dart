class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;
  final bool isSuccess;

  ApiResponse({
    this.data,
    this.message,
    this.statusCode,
    this.isSuccess = false,
  });

  factory ApiResponse.success(String message, T data, int statusCode) {
    return ApiResponse(message: message, data: data, statusCode: statusCode, isSuccess: true);
  }

  factory ApiResponse.error(String message, int statusCode) {
    return ApiResponse(message: message, statusCode: statusCode, isSuccess: false);
  }
}