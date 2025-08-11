import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_colors.dart';

enum SnackbarType { success, error, info }

class AppSnackbar {
  static void success(String message, {String title = 'Success'}) {
    _showSnackbar(
      SnackbarType.success,
      title,
      message,
    );
  }

  static void error(String message, {String title = 'Error'}) {
    _showSnackbar(
      SnackbarType.error,
      title,
      message,
    );
  }

  static void info(String message, {String title = 'Info'}) {
    _showSnackbar(
      SnackbarType.info,
      title,
      message,
    );
  }

  static void _showSnackbar(SnackbarType type, String title, String message) {
    Color backgroundColor;
    IconData iconData;
    Duration duration = const Duration(seconds: 3);

    switch (type) {
      case SnackbarType.success:
        backgroundColor = AppColors.success.withOpacity(0.6);
        iconData = Icons.check_circle_outline;
        duration = const Duration(seconds: 2);
        break;
      case SnackbarType.error:
        backgroundColor = AppColors.error.withOpacity(0.6);
        iconData = Icons.error_outline;
        break;
      case SnackbarType.info:
        backgroundColor = AppColors.info.withOpacity(0.6);
        iconData = Icons.info_outline;
        break;
    }

    if (Get.isSnackbarOpen) {
      return;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      backgroundColor: backgroundColor.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 16,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeOut,
      barBlur: 8,
      duration: duration,
      icon: Icon(iconData, color: Colors.white, size: 28),
      titleText: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
