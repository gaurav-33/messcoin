import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../core/models/student_model.dart';
import '../../core/services/coupon_service.dart';
import '../../core/services/student_service.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/validators.dart';

class StudentController extends GetxController {
  RxBool isLoading = false.obs;
  final rollController = TextEditingController();
  Rx<StudentModel?> student = Rx<StudentModel?>(null);

  final couponAmountController = TextEditingController();
  RxBool isAddingCoupon = false.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate:
          DateTime(DateTime.now().year - 1), // Allow selection from last year
      lastDate: DateTime.now(), // Do not allow future dates
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  AppColors.primaryColor, // header background, selected day
              onPrimary: Colors.white, // header text, selected day text
              onSurface: AppColors.dark, // default text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

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

  Future<void> addCouponTransaction() async {
    // Prevent multiple submissions
    if (isAddingCoupon.value) return;

    // Ensure a student is loaded
    if (student.value == null) {
      AppSnackbar.error('Please search for a student first.');
      return;
    }
    final amount = couponAmountController.text.trim().toString();
    final amountError = Validators.validateAmount(amount);

    if (amountError != null) {
      AppSnackbar.error(amountError);
      return;
    }

    final finalAmount =
        double.tryParse(couponAmountController.text.trim()) ?? 0;
    final leftAmount =
        student.value!.wallet.totalCredit - student.value!.wallet.loadedCredit;
    if (finalAmount > leftAmount) {
      AppSnackbar.error('Amount is higher than expected');
      return;
    }
    isAddingCoupon.value = true;
    try {
      final response = await CouponService().createAndApproveCoupon(
          studentId: student.value!.id,
          amount: finalAmount,
          date: DateFormat('yyyy-MM-dd').format(selectedDate.value));

      if (response.isSuccess) {
        AppSnackbar.success('Coupon added successfully to student wallet!');
        couponAmountController.clear();
        // Refresh student data to show updated wallet balance
        await searchByRoll();
      } else {
        AppSnackbar.error(response.message ?? 'Failed to add coupon.');
      }
    } catch (err) {
      AppSnackbar.error(err.toString());
    } finally {
      isAddingCoupon.value = false;
    }
  }

  @override
  void onClose() {
    couponAmountController.dispose();
    super.onClose();
  }
}
