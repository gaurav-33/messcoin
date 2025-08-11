import 'package:get/get.dart';
import '../../core/models/leave_model.dart';
import '../../core/services/leave_service.dart';

class LeaveController extends GetxController {
  var isLoading = false.obs;
  var error = ''.obs;
  var leaves = <LeaveModel>[].obs;

  int studentLeaveCurrentPage = 1;
  int studentLeaveTotalPages = 1;
  int studentLeavePageSize = 20;

  @override
  void onInit() {
    super.onInit();
    fetchLeaves();
  }

  Future<void> fetchLeaves(
      {String studentId = '', int page = 1, int limit = 20}) async {
    isLoading.value = true;
    error.value = '';

    try {
      final response = await LeaveService()
          .getLeave(studentId: '', page: page, limit: limit);
      if (response.isSuccess) {
        final List<dynamic> data = response.data['data']['leaves'] ?? [];
        leaves.value = data.map((e) => LeaveModel.fromJson(e)).toList();
        studentLeaveCurrentPage = response.data['data']['page'] ?? page;
        studentLeaveTotalPages = response.data['data']['pages'] ?? 1;
        studentLeavePageSize = limit;
      } else {
        error.value = response.message ?? 'Failed to load leave history';
      }
    } catch (e) {
      error.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
