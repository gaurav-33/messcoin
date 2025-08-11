import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';

class MenuService {
  final dio = DioClient().dio;

  Future<ApiResponse> getMessMenu(String day) async {
    try {
      final response =
          await dio.get('/messMenu/get', queryParameters: {'day': day});
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

// NOT USED
  Future<ApiResponse> createMessMenu(Map<String, dynamic> menuData) async {
    try {
      final response = await dio.post(
        '/messMenu/create',
        data: menuData,
      );
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

  Future<ApiResponse> updateMessMenu(Map<String, dynamic> menuData) async {
    try {
      final response = await dio.patch(
        '/messMenu/update',
        data: menuData,
      );
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
