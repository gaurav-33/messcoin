import 'package:dio/dio.dart';
import '../../core/network/api_response.dart';
import '../../core/network/dio_client.dart';
import 'package:file_saver/file_saver.dart';
import 'dart:typed_data';

class BillService {
  final dio = DioClient().dio;

  Future<ApiResponse> getStudentBill(
      {required int month, required int year}) async {
    try {
      final response = await dio.get('/bill/get', queryParameters: {
        'month': month,
        'year': year,
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

  Future<ApiResponse> createBill(
      {required int month,
      required int year,
      required int perDayMealPrice}) async {
    try {
      final response = await dio.post('/bill/generate', data: {
        'month': month,
        'year': year,
        'perDayMealPrice': perDayMealPrice,
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

  Future<ApiResponse> downloadMonthlyPdfBill(
      {required int month, required int year}) async {
    try {
      final response = await dio.get(
        '/bill/export/pdf',
        queryParameters: {
          'month': month,
          'year': year,
        },
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // --- Get filename from headers ---
        String filename = 'monthly-bill-$month-$year'; // A sensible default
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

        return ApiResponse.success("PDF bill downloaded successfully!",
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

  Future<ApiResponse> downloadMonthlyExcelBill(
      {required int month, required int year}) async {
    try {
      final response = await dio.get(
        '/bill/export/excel',
        queryParameters: {
          'month': month,
          'year': year,
        },
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // --- Get filename from headers ---
        String filename = 'monthly-bill-$month-$year.xlsx';
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

        return ApiResponse.success("Excel bill downloaded successfully!",
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
}
