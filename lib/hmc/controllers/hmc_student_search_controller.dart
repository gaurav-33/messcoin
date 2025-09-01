import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/models/student_model.dart';
import '../../core/services/student_service.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/validators.dart';

class StudentSearchController extends GetxController {
   RxBool isLoading = false.obs;
  final rollController = TextEditingController();
  Rx<StudentModel?> student = Rx<StudentModel?>(null);


  Future<void> searchByRoll() async {
    final rollNo = rollController.text.trim().toString();
    final rollNoError = Validators.validateRollNo(rollNo);

    if (rollNoError != null) {
      AppSnackbar.error(rollNoError);
      return;
    }

    isLoading.value = true;
    try {
      final response = await StudentService().getStudentByRoll(rollNo: rollNo);
      isLoading.value = false;
      if (response.isSuccess) {
        student.value = StudentModel.fromJson(response.data['data']['student']);
      } else {
        student.value = null;
        AppSnackbar.error(response.message ?? 'Student not found');
      }
    } catch (err) {
      AppSnackbar.error(err.toString());
    }
  }

}