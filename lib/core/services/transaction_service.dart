import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';

class TransactionService {
  final dio = DioClient().dio;

  Future<ApiResponse> createTransaction(
      {required double amount, String item = 'others', int qty = 1}) async {
    try {
      final response = await dio.post(
        '/transaction/create',
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

  Future<ApiResponse> createBulkTransaction({
    required List<Map<String, dynamic>> items,
    required double amount,
  }) async {
    try {
      final response = await dio.post(
        '/transaction/create/bulk',
        data: {
          'amount': amount,
          'items': items,
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

  Future<ApiResponse> getTransactions({int page = 1, int limit = 10}) async {
    try {
      final response = await dio.get(
        '/transaction/get',
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

  Future<ApiResponse> dailyTransaction(
      {int page = 1, int limit = 10, required String date}) async {
    try {
      final queryParams = {
        'date': date,
        'page': page,
        'limit': limit,
      };
      final response = await dio.get(
        '/transaction/daily',
        queryParameters: queryParams,
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

  Future<ApiResponse> dailyTransactionSummary() async {
    try {
      final response = await dio.get('/transaction/daily-summary');
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

  Future<ApiResponse> monthlyTransactionSummary() async {
    try {
      final response = await dio.get('/transaction/monthly-summary');
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
