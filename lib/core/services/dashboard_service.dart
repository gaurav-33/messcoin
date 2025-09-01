import 'package:dio/dio.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';

class DashboardService {
  final dio = DioClient().dio;

  Future<ApiResponse> getLast7DaysOverview() async {
    try {
      final response = await dio.get('/dashboard/overview');
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

  Future<ApiResponse> getActiveStudents() async {
    try {
      final response = await dio.get('/dashboard/active-students');
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

  Future<ApiResponse> getDailyReport(String date) async {
    try {
      final response = await dio
          .get('/dashboard/report-daily', queryParameters: {'date': date});
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

  Future<ApiResponse> getWeeklyReport(String date) async {
    try {
      final response = await dio
          .get('/dashboard/report-weekly', queryParameters: {'date': date});
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

  Future<ApiResponse> getMonthlyReport(String date) async {
    try {
      final response = await dio
          .get('/dashboard/report-monthly', queryParameters: {'date': date});
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

  Future<ApiResponse> downloadMonthlyPdfReport(String date) async {
    try {
      final response = await dio.get(
        '/dashboard/monthly-details/pdf',
        queryParameters: {'date': date},
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // --- Get filename from headers ---
        String filename = 'monthly-report-$date'; // A sensible default
        final contentDisposition =
            response.headers.value('content-disposition');
        if (contentDisposition != null) {
          // A simple regex to parse the filename from the header
          final match =
              RegExp(r'filename="([^"]+)"').firstMatch(contentDisposition);
          if (match != null) {
            filename = match.group(1)!;
          }
        }

        String? filePath = await FileSaver.instance.saveFile(
          name: filename,
          bytes: Uint8List.fromList(response.data as List<int>),
          ext: 'pdf',
          mimeType: MimeType.pdf,
        );

        return ApiResponse.success("PDF report downloaded successfully!",
            filePath, response.statusCode!);
      } else {
        // Handle server-side errors like 400, 404, etc.
        return ApiResponse.error(
          "Server returned an error.",
          response.statusCode ?? 500,
        );
      }
    } catch (e) {
      // Handle any other unexpected errors during the process
      return ApiResponse.error(
          'An unexpected error occurred: ${e.toString()}', 500);
    }
  }

  Future<ApiResponse> downloadMonthlyExcelReport(String date) async {
    try {
      final response = await dio.get(
        '/dashboard/monthly-details/excel',
        queryParameters: {'date': date},
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // --- Get filename from headers ---
        String filename = 'monthly-report-$date.xlsx';
        final contentDisposition =
            response.headers.value('content-disposition');
        if (contentDisposition != null) {
          // A simple regex to parse the filename from the header
          final match =
              RegExp(r'filename="([^"]+)"').firstMatch(contentDisposition);
          if (match != null) {
            filename = match.group(1)!;
          }
        }

        String? filePath = await FileSaver.instance.saveFile(
          name: filename,
          bytes: Uint8List.fromList(response.data as List<int>),
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel,
        );

        return ApiResponse.success("Excel report downloaded successfully!",
            filePath, response.statusCode!);
      } else {
        // Handle server-side errors like 400, 404, etc.
        return ApiResponse.error(
          "Server returned an error.",
          response.statusCode ?? 500,
        );
      }
    } catch (e) {
      // Handle any other unexpected errors during the process
      return ApiResponse.error(
          'An unexpected error occurred: ${e.toString()}', 500);
    }
  }

// HMC DASHBOARD RELATED SERVICES
  Future<ApiResponse> getWeeklyRating(String date) async {
    try {
      final response = await dio.get('/dashboard/weekly-average-rating',
          queryParameters: {'date': date});
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
