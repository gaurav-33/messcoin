import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';

class AdminService {
  final dio = DioClient().dio;

  Future<ApiResponse> loginAmin(String email, String password) async {
    try {
      final response = await dio.post(
        '/admin/login',
        data: {
          'email': email,
          'password': password,
        },
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

  Future<ApiResponse> logoutAdmin() async {
    try {
      final response = await dio.get('/admin/logout');
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

  Future<ApiResponse> changeCurrentPassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      final response = await dio.patch(
        '/admin/changePassword',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
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

  Future<ApiResponse> refreshToken() async {
    try {
      final response = await dio.get('/admin/refreshToken');
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

  Future<ApiResponse> getCurrentUser() async {
    try {
      final response = await dio.get('/admin/currentAdmin');
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

  Future<ApiResponse> sendResetOtp(String email) async {
    try {
      final response = await dio.post(
        '/admin/sendResetOtp',
        data: {'email': email},
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

  Future<ApiResponse> resetPassword(
      String email, String otp, String newPassword) async {
    try {
      final response = await dio.post(
        '/admin/resetPassword',
        data: {'email': email, 'otp': otp, 'newPassword': newPassword},
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

// NOT USED
  Future<ApiResponse> deleteAdmin(String adminId) async {
    try {
      final response = await dio.delete('/admin/deleteAdmin/$adminId');
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

  Future<ApiResponse> updateAdmin(Map<String, dynamic> adminData) async {
    try {
      final response = await dio.patch(
        '/admin/updateAdmin',
        data: adminData,
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
