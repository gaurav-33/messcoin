import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messcoin/mess_admin/controllers/dashboard_controller.dart';
import 'package:messcoin/utils/extensions.dart';
import '../../core/models/student_model.dart';
import '../../core/services/student_service.dart';
import '../../core/services/leave_service.dart';
import '../../utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import '../../../../core/models/leave_model.dart';
import '../../../../utils/validators.dart';
import '../../../../config/app_colors.dart';
import '../../../../core/widgets/neu_button.dart';
import '../../utils/responsive.dart';

class LeaveController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isCreatingLeave = false.obs;
  Rx<StudentModel?> student = Rx<StudentModel?>(null);
  TextEditingController rollController = TextEditingController();

  // For leave form fields
  TextEditingController reasonController = TextEditingController();
  Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  Rx<DateTime?> toDate = Rx<DateTime?>(null);

  // For paginated ongoing leaves (all students)
  RxBool isOngoingLoading = false.obs;
  RxBool isOngoingFetched = false.obs;
  RxList<LeaveModel> ongoingLeaves = <LeaveModel>[].obs;
  int ongoingCurrentPage = 1;
  int ongoingTotalPages = 1;
  int ongoingPageSize = 20;

  // For paginated student-specific leaves
  RxList<LeaveModel> studentLeaves = <LeaveModel>[].obs;
  int studentLeaveCurrentPage = 1;
  int studentLeaveTotalPages = 1;
  int studentLeavePageSize = 20;

  @override
  void onInit() {
    super.onInit();
    // Fetch ongoing leaves when the controller is initialized for the first time
    fetchOngoingLeaves();
  }

  Future<void> fetchOngoingLeaves({int page = 1, int limit = 20}) async {
    isOngoingLoading.value = true;
    try {
      final response = await LeaveService()
          .getAllLeaveByStatus(status: 'ongoing', page: page, limit: limit);
      if (response.isSuccess) {
        final List<dynamic> data = response.data['data']['leaves'] ?? [];
        ongoingLeaves.value = data.map((e) => LeaveModel.fromJson(e)).toList();
        ongoingCurrentPage = response.data['data']['page'] ?? page;
        ongoingTotalPages = response.data['data']['pages'] ?? 1;
        ongoingPageSize = limit;
      } else {
        ongoingLeaves.clear();
      }
    } finally {
      isOngoingLoading.value = false;
    }
  }

  Future<void> searchByRoll() async {
    final rollNo = rollController.text.trim();
    final rollNoError = Validators.validateRollNo(rollNo);

    if (rollNoError != null) {
      AppSnackbar.error(rollNoError);
      return;
    }
    isLoading.value = true;
    final response = await StudentService().getStudentByRoll(rollNo: rollNo);
    isLoading.value = false;
    if (response.isSuccess) {
      student.value = StudentModel.fromJson(response.data['data']['student']);
      fetchStudentLeaves(studentId: student.value!.id);
    } else {
      student.value = null;
      AppSnackbar.error(response.message ?? 'Student not found');
    }
  }

  Future<void> createLeave() async {
    if (student.value == null ||
        fromDate.value == null ||
        toDate.value == null) {
      AppSnackbar.error('Please select a student and both leave dates.');
      return;
    }
    isCreatingLeave.value = true;
    final leaveData = {
      'student': student.value!.id,
      'startDate': DateFormat('yyyy-MM-dd').format(fromDate.value!),
      'endDate': DateFormat('yyyy-MM-dd').format(toDate.value!),
      'reason': reasonController.text
    };

    final response = await LeaveService().createLeave(leaveData);

    if (response.isSuccess) {
      AppSnackbar.success('Leave granted successfully.');
      // Clear form and refresh lists
      reasonController.clear();
      fromDate.value = null;
      toDate.value = null;
      fetchStudentLeaves(studentId: student.value!.id);
      fetchOngoingLeaves(); 
      await Get.find<DashboardController>().fetchActiveStudents();
    } else {
      AppSnackbar.error(response.message ?? 'Failed to create leave');
    }
    isCreatingLeave.value = false;
  }

  Future<void> fetchStudentLeaves(
      {required String studentId, int page = 1, int limit = 20}) async {
    isLoading.value = true;
    try {
      final response = await LeaveService()
          .getLeave(studentId: studentId, page: page, limit: limit);
      if (response.isSuccess) {
        final List<dynamic> data = response.data['data']['leaves'] ?? [];
        studentLeaves.value = data.map((e) => LeaveModel.fromJson(e)).toList();
        studentLeaveCurrentPage = response.data['data']['page'] ?? page;
        studentLeaveTotalPages = response.data['data']['pages'] ?? 1;
        studentLeavePageSize = limit;
      } else {
        studentLeaves.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // --- NEW: UPDATE AND DELETE LOGIC ---

  /// Updates the start and end dates of an existing leave.
  Future<void> updateLeave(
      String leaveId, DateTime newStartDate, DateTime newEndDate) async {
    isLoading.value = true;
    final response = await LeaveService().updateLeave(
      leaveId,
      DateFormat('yyyy-MM-dd').format(newStartDate),
      DateFormat('yyyy-MM-dd').format(newEndDate),
    );
    isLoading.value = false;

    if (response.isSuccess) {
      AppSnackbar.success('Leave updated successfully.');
      // Refresh both lists to ensure UI is consistent
      if (student.value != null) {
        fetchStudentLeaves(studentId: student.value!.id);
      }
      fetchOngoingLeaves();
    } else {
      AppSnackbar.error(response.message ?? 'Failed to update leave.');
    }
  }

  /// Deletes a leave record.
  Future<void> deleteLeave(String leaveId) async {
    isLoading.value = true;
    final response = await LeaveService().deleteLeave(leaveId);
    isLoading.value = false;

    if (response.isSuccess) {
      AppSnackbar.success('Leave deleted successfully.');
      // Refresh both lists
      if (student.value != null) {
        fetchStudentLeaves(studentId: student.value!.id);
      }
      fetchOngoingLeaves();
    } else {
      AppSnackbar.error(response.message ?? 'Failed to delete leave.');
    }
  }

  /// Shows a dialog to modify the dates of a leave.
  void showUpdateLeaveDialog(BuildContext context, LeaveModel leave) {
    final Rx<DateTime> newStartDate = leave.startDate.obs;
    final Rx<DateTime> newEndDate = leave.endDate.obs;

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.bgColor,
        title: const Text('Modify Leave Dates'),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  "Editing leave for ${leave.studentData?.fullName.toCamelCase() ?? 'a student'}."),
              const SizedBox(height: 24),
              _buildDatePickerButton(
                context,
                label: 'From: ${DateFormat('dd MMM yyyy').format(newStartDate.value)}',
                onDatePicked: (date) => newStartDate.value = date,
              ),
              const SizedBox(height: 16),
              _buildDatePickerButton(
                context,
                label: 'To: ${DateFormat('dd MMM yyyy').format(newEndDate.value)}',
                onDatePicked: (date) => newEndDate.value = date,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          NeuButton(
            width: Responsive.contentWidth(context) * 0.3,
            onTap: () {
              Get.back(); // Close the dialog first
              updateLeave(leave.id, newStartDate.value, newEndDate.value);
            },
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Flexible(child: const Text('Save Changes', maxLines: 1, overflow: TextOverflow.ellipsis,)),
          ),
        ],
      ),
    );
  }

  // Helper for the dialog's date picker buttons
  Widget _buildDatePickerButton(BuildContext context,
      {required String label, required Function(DateTime) onDatePicked}) {
    return NeuButton(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          onDatePicked(picked);
        }
      },
      child: Row(
        children: [
          const Icon(Icons.calendar_today,
              size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
  }


  void clearAll() {
    rollController.clear();
    student.value = null;
    studentLeaves.clear();
  }
}