import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';

class ExtraMenuService {
  final dio = DioClient().dio;

  Future<ApiResponse> getExtraMenu(String day) async {
    try {
      final response =
          await dio.get('/extraMenu/get', queryParameters: {'day': day});
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

  Future<ApiResponse> upsertExtraMenu(Map<String, dynamic> menuData) async {
    try {
      final response = await dio.patch(
        '/extraMenu/update',
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

  Future<ApiResponse> deleteExtraMenu(Map<String, dynamic> menuData) async {
    try {
      final response = await dio.delete(
        '/extraMenu/delete',
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

  Future<ApiResponse> getAllExtraMenu() async {
    try {
      final response = await dio.get('/extraMenu/getAll');
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
  Future<ApiResponse> createExtraMenu(Map<String, dynamic> menuData) async {
    try {
      final response = await dio.post(
        '/extraMenu/create',
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
