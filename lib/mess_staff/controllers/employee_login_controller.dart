import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/network/api_response.dart';
import 'package:messcoin/core/services/employee_service.dart';
import 'package:messcoin/utils/app_snackbar.dart';
import '../../core/routes/mess_staff_routes.dart';
import '../../core/storage/auth_box_manager.dart';
import '../../core/storage/role_box_manager.dart';
import '../../utils/validators.dart';

class EmployeeLoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;

  void login() async {
    try {
      isLoading.value = true;
      final phone = phoneController.text.trim();
      final password = passwordController.text.trim();

      final emailError = Validators.validatePhone(phone);
      final passwordError = Validators.validatePassword(password);

      if (emailError != null) {
        AppSnackbar.error(emailError);
        return;
      }
      if (passwordError != null) {
        AppSnackbar.error(passwordError);
        return;
      }

      ApiResponse response = await EmployeeService().loginEmployee(
        phone: phone,
        password: password,
      );

      if (response.isSuccess) {
        AppSnackbar.success(response.message ?? 'Employee Login successful');
        await AuthBoxManager.clearToken();
        await AuthBoxManager.saveToken(response.data['data']['accessToken']);
        await RoleBoxManager.clearRole();
        await RoleBoxManager.saveRole(
            response.data['data']['employee']?['role']);
        Get.offAllNamed(MessStaffRoutes.getMessStaffDashboard());
      } else {
        AppSnackbar.error(response.message ?? 'Employee Login failed');
      }
    } catch (e) {
      AppSnackbar.error('Employee Login Failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
