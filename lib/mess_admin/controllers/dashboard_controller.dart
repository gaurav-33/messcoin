import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/models/mess_model.dart';
import 'package:messcoin/core/services/mess_service.dart';
import '../../core/models/daily_summary_model.dart';
import '../../core/services/dashboard_service.dart';
import '../../core/storage/admin_box_manager.dart';
import '../../utils/app_snackbar.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/storage/auth_box_manager.dart';
import '../../../../core/storage/role_box_manager.dart';

class DashboardController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxList<DailySummaryModel> last7Days = <DailySummaryModel>[].obs;
  RxDouble totalTransactionAmount = (0.0).obs;
  RxDouble totalCouponAmount = (0.0).obs;
  RxDouble averageFeedbackRating = (0.0).obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  RxInt activeStudents = 0.obs;
  RxInt totalStudents = 0.obs;
  Rx<MessModel?> messDetail = Rx<MessModel?>(null);
  final RxInt _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int value) {
    _selectedIndex.value = value;
  }

  Future<void> fetchLast7DaysOverview() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await DashboardService().getLast7DaysOverview();
      if (response.isSuccess) {
        final List<dynamic> data = response.data['data']['summaries'];

        last7Days.value =
            data.map((e) => DailySummaryModel.fromJson(e)).toList();
        fetchTotalCouponAmount();
        fetchTotalTransactionAmount();
        fetchAverageFeedbackRating();
      } else {
        error.value = response.message ?? 'Failed to load dashboard data';
        AppSnackbar.error(error.value);
      }
    } catch (e) {
      error.value = e.toString();

      AppSnackbar.error(error.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchActiveStudents() async {
    final response = await DashboardService().getActiveStudents();
    if (response.isSuccess) {
      activeStudents.value = response.data['data']['active'];
      totalStudents.value = response.data['data']['total'];
    } else {
      AppSnackbar.error('Failed to fetch active students');
    }
  }

  Future<void> fetchMessDetails() async {
    final response = await MessService().getMess();
    if (response.isSuccess) {
      messDetail.value = MessModel.fromJson(response.data['data']);
    } else {
      AppSnackbar.error('Failed to fetch mess details');
    }
  }

  fetchTotalTransactionAmount() {
    totalTransactionAmount.value =
        last7Days.fold(0, (sum, d) => sum + (d.transactionTotalAmount));
  }

  fetchTotalCouponAmount() {
    totalCouponAmount.value =
        last7Days.fold(0, (sum, d) => sum + (d.couponTotalAmount));
  }

  fetchAverageFeedbackRating() {
    final ratings = last7Days
        .where((d) => d.feedbackAvgRating > 0)
        .map((d) => d.feedbackAvgRating)
        .toList();
    if (ratings.isEmpty) return 0;
    averageFeedbackRating.value =
        ratings.reduce((a, b) => a + b) / ratings.length;
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await AuthBoxManager.clearToken();
      await AdminBoxManager.clearAdmin();
      await RoleBoxManager.clearRole();
      AppSnackbar.success("Logout successfully");
      Get.offAllNamed(AppRoutes.getSplash());
    } catch (e) {
      AppSnackbar.error('Failed to logout: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchLast7DaysOverview();
    fetchActiveStudents();
    fetchMessDetails();
  }
}