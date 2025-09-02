import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/models/feedback_model.dart';
import '../../core/services/feedback_service.dart';
import '../../core/sockets/socket_manager.dart';
import '../../utils/app_snackbar.dart';

class LiveFeedbackController extends GetxController {
  Rx<DateTime> calendarDate = DateTime.now().obs;
  String get selectedDate =>
      DateFormat('yyyy-MM-dd').format(calendarDate.value);

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  final int pageSize = 20;
  RxList<FeedbackModel> feedbackList = <FeedbackModel>[].obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  final TextEditingController replyController = TextEditingController();
  Rx<String?> replyToFeedbackId = Rx(null);

  RxBool get isLive => SocketManager().isLive;
  String get liveStatusText {
    if (!isLive.value) return 'Offline';
    return 'Live';
  }

  @override
  void onInit() {
    fetchFeedbackList();
    final socketManager = SocketManager();
    socketManager.subscribe('newFeedback', _onNewFeedback);
    super.onInit();
  }

  void _onNewFeedback(dynamic data) {
    try {
      final fdb = FeedbackModel.fromJson(data);
      if (feedbackList.isEmpty || feedbackList.first.id != fdb.id) {
        feedbackList.insert(0, fdb);
        if (feedbackList.length > 100) feedbackList.removeLast();
      }
    } catch (e) {
      debugPrint(e.toString());
      AppSnackbar.error('Error parsing newTransaction: $e');
    }
  }

  Future<void> fetchFeedbackList({int page = 1, String? date}) async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await FeedbackService().getHMCFeedback(
        date: date ?? selectedDate,
        page: page,
        limit: pageSize,
      );
      if (response.isSuccess) {
        final List data = response.data['data']['feedbacks'];
        feedbackList.value =
            data.map((e) => FeedbackModel.fromJson(e)).toList();
        currentPage.value = response.data['data']['page'] ?? page;
        totalPages.value = response.data['data']['pages'] ?? 1;
      } else {
        AppSnackbar.error(response.message ?? 'Failed to load feedback list');
        error.value = response.message ?? 'Failed to load feedback list';
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void setReplyTo(String? feedbackId) {
    replyToFeedbackId.value = feedbackId;
    if (feedbackId == null) {
      replyController.clear();
    }
  }

  Future<void> createReply() async {
    if (replyToFeedbackId.value == null) return;
    try {
      final response = await FeedbackService().replyToFeedback(
          feedbackId: replyToFeedbackId.value!,
          reply: replyController.text.toString().trim());
      if (response.isSuccess) {
        AppSnackbar.success('Replied successfully');
        setReplyTo(null);
        fetchFeedbackList(date: selectedDate, page: currentPage.value);
      } else {
        AppSnackbar.error(response.message ?? 'Failed to reply');
        error.value = response.message ?? 'Failed to reply';
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
      error.value = e.toString();
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: calendarDate.value,
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      calendarDate.value = picked;
      fetchFeedbackList(date: DateFormat('yyyy-MM-dd').format(picked));
    }
  }
}
