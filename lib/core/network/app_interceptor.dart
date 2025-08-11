import 'package:dio/dio.dart';
import '../../core/error/app_error_handler.dart';
import '../../core/storage/auth_box_manager.dart';

class AppInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppErrorHandler.handle(err);
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Get token from local storage
    final token = await AuthBoxManager.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
