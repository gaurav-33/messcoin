import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';

class AuthCheckService {
  final dio = DioClient().dio;
// NOT USED
  Future<ApiResponse> getCurrentUser() async {
    try {
      final response = await dio.get('/auth/currentUser');
      if (response.statusCode! < 299) {
        return ApiResponse.success(
            response.data['message'], response.data, response.statusCode!);
      } else {
        return ApiResponse.error(
            response.data['message'], response.statusCode!);
      }
    } catch (e) {
      return ApiResponse.error(e.toString(), 500);
    }
  }
}
