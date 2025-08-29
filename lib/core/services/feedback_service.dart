import 'package:dio/dio.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';

class FeedbackService {
  final dio = DioClient().dio;

  Future<ApiResponse> createFeedback(
      {required String feedback,
      required int rating,
      String? imageFile}) async {
    try {
      final response = await dio.post('/feedback/create',
          data: FormData.fromMap(
            {
              'image': imageFile != null
                  ? await MultipartFile.fromFile(imageFile,
                      filename: imageFile.split('/').last)
                  : null,
              'rating': rating,
              'feedback': feedback,
              // 'image': imageFile,
            },
          ));
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

  Future<ApiResponse> getFeedback(String messId) async {
    try {
      final response = await dio.get('/feedback/get/$messId');
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

  Future<ApiResponse> getStudentFeedback({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get(
        '/feedback/get-student',
        queryParameters: {
          'page': page,
          'limit': limit,
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

// NOT USED
  Future<ApiResponse> getAverageRating(String messId) async {
    try {
      final response = await dio.get('/feedback/average-rating/$messId');
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

  Future<ApiResponse> getWeeklyAverageRating(String messId) async {
    try {
      final response = await dio.get('/feedback/weekly-average-rating/$messId');
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

  Future<ApiResponse> getMonthlyAverageRating(String messId) async {
    try {
      final response =
          await dio.get('/feedback/monthly-average-rating/$messId');
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
