import 'package:get/get.dart';
import '../../core/models/feedback_model.dart';
import '../../utils/app_snackbar.dart';

import '../../../../core/services/feedback_service.dart';

class ViewFeedbackController extends GetxController {
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  final int pageSize = 10;
  RxList<FeedbackModel> feedbackList = <FeedbackModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    fetchFeedbackList(page: 1);
    super.onInit();
  }

  Future<void> fetchFeedbackList({int page = 1}) async {
    isLoading.value = true;
    try {
      final response = await FeedbackService().getStudentFeedback(page: page, limit: pageSize);
      if (response.isSuccess) {
        final List data = response.data['data']['feedbacks'];
        feedbackList.value = data.map((e) => FeedbackModel.fromJson(e)).toList();
        currentPage.value = response.data['data']['page'] ?? page;
        totalPages.value = response.data['data']['pages'] ?? 1;
      } else {
        AppSnackbar.error(response.message ?? 'Failed to load feedback list');
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
