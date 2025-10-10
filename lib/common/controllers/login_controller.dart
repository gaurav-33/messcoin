import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/admin_routes.dart';
import '../../core/routes/hmc_routes.dart';
import '../../core/storage/role_box_manager.dart';
import '../../core/routes/app_routes.dart';
import '../../core/routes/student_routes.dart';
import '../../core/services/admin_service.dart';
import '../../core/storage/auth_box_manager.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/validators.dart';

import '../../core/services/student_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isAdmin = false.obs;

  void login() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final emailError = Validators.validateAllEmail(email);
      final passwordError = Validators.validatePassword(password);

      if (emailError != null) {
        AppSnackbar.error(emailError);
        return;
      }
      if (passwordError != null) {
        AppSnackbar.error(passwordError);
        return;
      }

      final response = isAdmin.value == true
          ? await AdminService().loginAmin(email, password)
          : await StudentService().login(email, password);
      if (response.isSuccess) {
        AppSnackbar.success(response.message ?? 'Login successful');
        await AuthBoxManager.clearToken();

        final dynamic rawData = response.data['data'];
        Map<String, dynamic> data;

        if (rawData is List) {
          if (rawData.isNotEmpty && rawData[0] is Map<String, dynamic>) {
            data = rawData[0];
          } else {
            AppSnackbar.error('Login failed: Invalid user data format.');
            isLoading.value = false;
            return;
          }
        } else if (rawData is Map<String, dynamic>) {
          data = rawData;
        } else {
          AppSnackbar.error('Login failed: Unexpected data format.');
          isLoading.value = false;
          return;
        }

        await AuthBoxManager.saveToken(data['accessToken']);
        await RoleBoxManager.clearRole();
        String? role = (data['student'] as Map<String, dynamic>?)?['role'] ??
            (data['admin'] as Map<String, dynamic>?)?['role'];

        if (role != null) {
          await RoleBoxManager.saveRole(role);
          if (role == 'hmc_admin') {
            Get.offAllNamed(HmcRoutes.getDashboard());
          } else if (role == 'mess_admin') {
            Get.offAllNamed(AdminRoutes.getDashboard());
          } else {
            Get.offAllNamed(StudentRoutes.getDashboard());
          }
        } else {
          AppSnackbar.error('Login failed: User role not found.');
          isLoading.value = false;
        }
      } else {
        if (response.message == 'Please verify your email first') {
          Get.toNamed(AppRoutes.getOtp(), arguments: {
            'email': email,
          });
          await Future.delayed(Duration(microseconds: 500));
        }
        AppSnackbar.error(response.message ?? 'Login failed');
        debugPrint('Login failed: ${response.message}');
      }
    } catch (e) {
      AppSnackbar.error('An error occurred while logging in: $e');
      debugPrint('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
