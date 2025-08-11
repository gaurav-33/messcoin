import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';

class CouponService {
  final dio = DioClient().dio;

  Future<ApiResponse> createCoupon(double amount) async {
    try {
      final response = await dio.post(
        '/coupon/create',
        data: {
          'amount': amount,
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

  Future<ApiResponse> getCoupons({int page = 1, int limit = 10}) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
      };
      final response =
          await dio.get('/coupon/get', queryParameters: queryParams);
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

  Future<ApiResponse> getRejectedCoupons({int page = 1, int limit = 10}) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
      };
      final response =
          await dio.get('/coupon/get-rejected', queryParameters: queryParams);
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

  Future<ApiResponse> getApprovedCoupons({int page = 1, int limit = 10}) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
      };
      final response =
          await dio.get('/coupon/get-approved', queryParameters: queryParams);
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

  Future<ApiResponse> createAndApproveCoupon(
      {required String studentId, required double amount, required String date}) async {
    try {
      final response = await dio.patch('/coupon/create-approve',
          data: {'amount': amount, 'studentId': studentId, 'date':date});
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

  Future<ApiResponse> approveCoupon(String couponId) async {
    try {
      final response = await dio.patch('/coupon/approve/$couponId');
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

  Future<ApiResponse> rejectCoupon(String couponId) async {
    try {
      final response = await dio.patch('/coupon/reject/$couponId');
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

  Future<ApiResponse> getStudentCoupons() async {
    try {
      final response = await dio.get('/coupon/student');
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
  Future<ApiResponse> dailyCoupons() async {
    try {
      final response = await dio.get('/coupon/daily');
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

  Future<ApiResponse> monthlyCoupons() async {
    try {
      final response = await dio.get('/coupon/monthly');
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
