import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/models/admin_model.dart';
import '../../core/services/admin_service.dart';
import '../../utils/app_snackbar.dart';

class ProfileController extends GetxController {
  Rx<AdminModel?> admin = Rx<AdminModel?>(null);
  RxBool isLoading = false.obs;
  RxBool isChangingPassword = false.obs;
  RxString error = ''.obs;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await AdminService().getCurrentUser();
      if (response.isSuccess) {
        admin.value = AdminModel.fromJson(response.data['data']['admin']);
      } else {
        error.value = response.message ?? 'Failed to load profile';
      }
    } catch (e) {
      error.value = 'Error: $e';
      AppSnackbar.error(e.toString(), title: 'Error loading profile');
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
      final response = await AdminService().changeCurrentPassword(oldPassword: oldPassword, newPassword: newPassword);
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
