import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/student_service.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/validators.dart';

class OtpVerificationController extends GetxController {
  final emailController =
      TextEditingController(text: Get.arguments['email'] ?? '');
  final otpController = TextEditingController();
  RxBool isOtpSent = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    super.onClose();
  }

  void sendOtp() async {
    final email = emailController.text.trim();
    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      AppSnackbar.error(emailError);
      return;
    }
    isLoading.value = true;
    try {
      final response = await StudentService().sendOtp(email);
      if (response.isSuccess) {
        isOtpSent.value = true;
        AppSnackbar.success('OTP sent to your email');
      }
    } catch (e) {
      AppSnackbar.error('Failed to send OTP');
    } finally {
      isLoading.value = false;
    }
  }

  void verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      AppSnackbar.error('Please enter the OTP');
      return;
    }
    isLoading.value = true;
    try {
      final response = await StudentService().verifyOtp(
        emailController.text.trim(),
        otp,
      );
      if (response.isSuccess) {
        AppSnackbar.success('OTP verified successfully');
        Get.offAllNamed(AppRoutes.getLogin());
      } else {
        AppSnackbar.error(response.message ?? 'Failed to verify OTP');
      }
    } catch (e) {
      AppSnackbar.error('Failed to verify OTP.');
    } finally {
      isLoading.value = false;
    }
  }
}
