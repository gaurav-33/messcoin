import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/models/student_model.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/student_service.dart';
import '../../core/storage/role_box_manager.dart';
import '../../core/storage/student_box_manager.dart';
import '../../utils/app_snackbar.dart';

import '../../../../core/storage/auth_box_manager.dart';

class DashboardController extends GetxController {
  Rx<StudentModel?> student = Rx<StudentModel?>(null);
  RxBool isLoading = false.obs;

  RxBool isChangingPassword = false.obs;
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadStudent();
  }

  Future<void> loadStudent() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      await StudentBoxManager.clearStudent();
      final cached = await StudentBoxManager.getStudent();
      if (cached != null) {
        student.value = cached;
      }
      final res = await StudentService().getCurrentStudent();
      if (res.isSuccess) {
        final fresh = StudentModel.fromJson(res.data['data']['student']);
        student.value = fresh;
        await StudentBoxManager.saveStudent(fresh);
      } else if (student.value == null) {}
      isLoading.value = false;
    } catch (e) {
      student.value = null;
      AppSnackbar.error('Failed to load student data');
      debugPrint('Error loading student: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStudent() async {
    await loadStudent();
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await AuthBoxManager.clearToken();
      await StudentBoxManager.clearStudent();
      await RoleBoxManager.clearRole();
      student.value = null;
      AppSnackbar.success("Logout successfully");
      Get.offAllNamed(AppRoutes.getSplash());
    } catch (e) {
      AppSnackbar.error('Failed to logout: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      AppSnackbar.error('All fields are required');
      return;
    }
    if (newPassword != confirmPassword) {
      AppSnackbar.error('New passwords do not match');
      return;
    }
    isChangingPassword.value = true;
    try {
      final response = await StudentService()
          .changePassword(oldPassword: oldPassword, newPassword: newPassword);
      if (response.isSuccess) {
        AppSnackbar.success('Password changed successfully');
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        AppSnackbar.error(response.message ?? 'Failed to change password');
      }
    } catch (e) {
      AppSnackbar.error(e.toString(), title: 'Error changing password');
    } finally {
      isChangingPassword.value = false;
    }
  }
}
