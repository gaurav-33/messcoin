import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import '../utils/app_snackbar.dart';

class AppErrorHandler {
  static void handle(DioException error) {
    final msg = error.response?.data['message'] ?? error.message;

    // AppSnackbar.error(
    //   msg,
    //   title: 'Error ${error.response?.statusCode ?? ''}',
    // );
    debugPrint(msg);
  }
}
