import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';

class MessService {
  final dio = DioClient().dio;

  Future<ApiResponse> getAllMess() async {
    try {
      final response = await dio.get('/mess/getAll');
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

  Future<ApiResponse> getMessById(String messId) async {
    try {
      final response = await dio.get('/mess/get/$messId');
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
  Future<ApiResponse> getMess() async {
    try {
      final response = await dio.get('/mess/get');
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