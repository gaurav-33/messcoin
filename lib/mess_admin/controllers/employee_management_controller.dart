import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:messcoin/core/models/employee_model.dart';
import 'package:messcoin/core/services/employee_service.dart';
import 'package:messcoin/utils/app_snackbar.dart';
import 'package:messcoin/utils/validators.dart';

import '../../core/network/api_response.dart';

class EmployeeManagementController extends GetxController {
  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isGeneratingPassword = false.obs;

  // For Create/Update Employee
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Rxn<EmployeeModel> selectedEmployee = Rxn<EmployeeModel>();
  RxMap<String, String> employeePasswords = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    isLoading.value = true;
    employees.clear();
    ApiResponse response = await EmployeeService().getAllEmployee();
    isLoading.value = false;
    if (response.isSuccess && response.data != null) {
      final res = (response.data['data'] as List)
          .map((e) => EmployeeModel.fromJson(e))
          .toList();
      employees.addAll(res);
    } else {
      AppSnackbar.error(response.message ?? 'Failed to fetch employees');
      employees.clear();
    }
  }

  void clearForm() {
    nameController.clear();
    phoneController.clear();
    selectedEmployee.value = null;
  }

  Future<void> addEmployee() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    final nameError = Validators.validateName(name);
    final phoneError = Validators.validatePhone(phone);
    if (nameError != null) {
      AppSnackbar.error(nameError);
      return;
    }
    if (phoneError != null) {
      AppSnackbar.error(phoneError);
      return;
    }
    isLoading.value = true;
    ApiResponse response = await EmployeeService().registerEmployee(
      fullName: name,
      phone: phone,
    );

    if (response.isSuccess) {
      Get.back();
      isLoading.value = false;
      AppSnackbar.success(response.message ?? 'Employee created successfully');
      fetchEmployees();
    } else {
      isLoading.value = false;
      AppSnackbar.error(response.message ?? 'Failed to create employee');
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    // isLoading.value = true;
    ApiResponse response =
        await EmployeeService().deleteEmployee(employeeId: employeeId);
    // isLoading.value = false;
    if (response.isSuccess) {
      employees.removeWhere((employee) => employee.id == employeeId);
      AppSnackbar.success(response.message ?? 'Employee deleted successfully');
    } else {
      AppSnackbar.error(response.message ?? 'Failed to delete employee');
    }
  }

  Future<void> generateNewPassword(String employeeId) async {
    if (isGeneratingPassword.value) {
      return;
    }
    isGeneratingPassword.value = true;
    ApiResponse response = await EmployeeService()
        .generateNewPasswordEmployee(employeeId: employeeId);
    isGeneratingPassword.value = false;

    if (response.isSuccess) {
      AppSnackbar.success(
          response.message ?? 'New password generated and shown in console');
      employeePasswords[employeeId] = response.data['data']['password'];
    } else {
      AppSnackbar.error(response.message ?? 'Failed to generate new password');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
