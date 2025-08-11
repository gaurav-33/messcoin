import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';

class LeaveService {
  final dio = DioClient().dio;

  Future<ApiResponse> createLeave(Map<String, dynamic> leaveData) async {
    try {
      final response = await dio.post(
        '/leave/create',
        data: leaveData,
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

  Future<ApiResponse> updateLeave(
      String leaveId, String startDate, String endDate) async {
    try {
      final response = await dio.patch(
        '/leave/update/$leaveId',
        data: {'startDate': startDate, 'endDate': endDate},
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

  Future<ApiResponse> getLeave(
      {String? studentId, int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get('/leave/get', queryParameters: {
        'studentId': studentId,
        'page': page,
        'limit': limit
      });
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

// TODO: add these in admin view
  Future<ApiResponse> getAllLeaveByStatus(
      {required String status, int page = 1, int limit = 10}) async {
    try {
      final response =
          await dio.get('/leave/getAll', queryParameters: {'status': status});
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

  Future<ApiResponse> deleteLeave(String leaveId) async {
    try {
      final response = await dio.delete('/leave/delete/$leaveId');
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
