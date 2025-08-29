import 'package:dio/dio.dart';

import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';

class StudentService {
  final dio = DioClient().dio;

  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/student/login',
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

  Future<ApiResponse> signup(
      {required String name,
      required String email,
      required String password,
      required String rollNo,
      required String roomNo,
      required int semester,
      required String messId,
      String? imageFile}) async {
    try {
      final response = await dio.post(
        '/student/register',
        data: FormData.fromMap({
          'fullName': name,
          'email': email,
          'password': password,
          'rollNo': rollNo,
          'roomNo': roomNo,
          'semester': semester,
          'mess': messId,
          'image': imageFile != null
              ? await MultipartFile.fromFile(imageFile,
                  filename: imageFile.split('/').last)
              : null,
        }),
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
      final response = await dio.get('/student/refreshToken');
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

  Future<ApiResponse> sendOtp(String email) async {
    try {
      final response = await dio.post(
        '/student/sendOTP',
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

  Future<ApiResponse> verifyOtp(String email, String otp) async {
    try {
      final response = await dio.post(
        '/student/verifyOTP',
        data: {'email': email, 'otp': otp},
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

  Future<ApiResponse> sendResetOtp(String email) async {
    try {
      final response = await dio.post(
        '/student/sendResetOtp',
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
      final response = await dio.patch(
        '/student/resetPassword',
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

  Future<ApiResponse> changePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      final response = await dio.patch(
        '/student/changePassword',
        data: {'currentPassword': oldPassword, 'newPassword': newPassword},
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

  Future<ApiResponse> getCurrentStudent() async {
    try {
      final response = await dio.get('/student/currentStudent');
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

  Future<ApiResponse> getStudentByRoll({required String rollNo}) async {
    try {
      final response =
          await dio.get('/student/search', queryParameters: {'rollNo': rollNo});
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
  Future<ApiResponse> updateStudent(Map<String, dynamic> updateData) async {
    try {
      final response = await dio.patch(
        '/student/updateStudent',
        data: updateData,
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

  Future<ApiResponse> logout() async {
    try {
      final response = await dio.get(
        '/student/logout',
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
