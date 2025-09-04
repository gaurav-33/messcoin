import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/services/mess_service.dart';
import 'package:messcoin/mess_admin/controllers/dashboard_controller.dart';
import 'package:messcoin/utils/app_snackbar.dart';

class CounterController extends GetxController {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final TextEditingController counterTextController = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize the text field with the current counter value
    if (dashboardController.messDetail.value != null) {
      counterTextController.text =
          dashboardController.messDetail.value!.counters.toString();
    }
  }

  Future<void> updateCounter() async {
    isLoading.value = true;
    try {
      final int newCounter = int.parse(counterTextController.text);
      final response = await MessService().updateMessCounter(newCounter);
      if (response.isSuccess) {
        AppSnackbar.success('Counter updated successfully!');
        // Update the messDetail in DashboardController
        dashboardController.fetchMessDetails();
      } else {
        AppSnackbar.error(response.message ?? 'Failed to update counter');
        print('Error from response : ${response.message}');
      }
    } catch (e) {
      AppSnackbar.error('Invalid counter value or an error occurred: $e');
      print('Error : ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    counterTextController.dispose();
    super.onClose();
  }
}
