import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/admin_service.dart';
import '../../core/services/student_service.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/validators.dart';

class ResetPasswordController extends GetxController {
  RxInt step = 1.obs;
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isAdmin = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }

  void sendOtp() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final emailError = isAdmin.value
          ? Validators.validateAllEmail(email)
          : Validators.validateEmail(email);
      if (emailError != null) {
        AppSnackbar.error(emailError);
        return;
      }

      final response = isAdmin.value
          ? await AdminService().sendResetOtp(email)
          : await StudentService().sendResetOtp(email);

      if (response.isSuccess) {
        AppSnackbar.success(response.message ?? 'OTP sent successfully');
        step.value = 2;
      } else {
        if (response.message == 'Please verify your email first') {
          Get.offNamed(AppRoutes.otp, arguments: {'email': email});
          await Future.delayed(Duration(microseconds: 500));
        }
        AppSnackbar.error(response.message ?? 'Failed to send OTP');
      }
    } catch (e) {
      AppSnackbar.error('An error occurred: $e');
      return;
    } finally {
      isLoading.value = false;
    }
  }

  void submit() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final otp = otpController.text.trim();
      final newPassword = newPasswordController.text.trim();

      final emailError = isAdmin.value
          ? Validators.validateAllEmail(email)
          : Validators.validateEmail(email);
      final otpError = Validators.validateOtp(otp);
      final passwordError = Validators.validatePassword(newPassword);

      if (emailError != null) {
        AppSnackbar.error(emailError);
        return;
      }
      if (otpError != null) {
        AppSnackbar.error(otpError);
        return;
      }
      if (passwordError != null) {
        AppSnackbar.error(passwordError);
        return;
      }

      final response = isAdmin.value
          ? await AdminService().resetPassword(email, otp, newPassword)
          : await StudentService().resetPassword(email, otp, newPassword);

      if (response.isSuccess) {
        AppSnackbar.success(response.message ?? 'Password reset successfully');
        Get.offAllNamed(AppRoutes.login);
      } else {
        AppSnackbar.error(response.message ?? 'Failed to reset password');
      }
    } catch (e) {
      AppSnackbar.error('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
