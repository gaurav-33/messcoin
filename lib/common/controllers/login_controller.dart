import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/admin_routes.dart';
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
        await AuthBoxManager.saveToken(response.data['data']['accessToken']);
        await RoleBoxManager.clearRole();
        await RoleBoxManager.saveRole(response.data['data']['student']?['role'] ?? response.data['data']['admin']?['role']);
        if ((response.data['data']['admin']?['role']).toString().contains('admin')) {
          Get.offAllNamed(AdminRoutes.getDashboard());
        } else {
          Get.offAllNamed(StudentRoutes.getDashboard());
        }
      } else {
        if (response.message == 'Please verify your email first') {
          Get.toNamed(AppRoutes.getOtp(), arguments: {
            'email': email,
          });
          await Future.delayed(Duration(microseconds: 500));
        }
        AppSnackbar.error(response.message ?? 'Login failed');
        print('Login failed: ${response.message}');
      }
    } catch (e) {
      AppSnackbar.error('An error occurred while logging in: $e');
      print('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
