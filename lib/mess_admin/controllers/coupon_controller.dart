import 'package:get/get.dart';
import '../../core/models/coupon_model.dart';
import '../../core/services/coupon_service.dart';
import '../../core/sockets/socket_manager.dart';
import '../../utils/app_snackbar.dart';

class CouponController extends GetxController {
  // Common state
  RxBool get isLive => SocketManager().isLive;

  final int _pageSize = 20;

  // --- Pending Coupons State ---
  final isPendingLoading = false.obs;
  final isPendingLoadingMore = false.obs;
  final pendingCoupons = <CouponModel>[].obs;
  var pendingCurrentPage = 1;
  var pendingTotalPages = 1;

  // --- Approved Coupons State ---
  final isApprovedLoading = false.obs;
  final isApprovedLoadingMore = false.obs;
  final approvedCoupons = <CouponModel>[].obs;
  var approvedCurrentPage = 1;
  var approvedTotalPages = 1;
  final hasAttemptedInitialFetchApproved = false.obs; // New flag

  // --- Rejected Coupons State ---
  final isRejectedLoading = false.obs;
  final isRejectedLoadingMore = false.obs;
  final rejectedCoupons = <CouponModel>[].obs;
  var rejectedCurrentPage = 1;
  var rejectedTotalPages = 1;
  final hasAttemptedInitialFetchRejected = false.obs; // New flag

  List<CouponModel> get latestCoupons {
    final sorted = List<CouponModel>.from(pendingCoupons);
    return sorted.take(10).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchPendingCoupons();
    final socketManager = SocketManager();
    if (socketManager.isConnected) {
      socketManager.subscribe('newCoupon', _onNewCoupon);
    }
  }

  Future<void> fetchPendingCoupons({int page = 1}) async {
    // Prevent fetching if already loading
    if (isPendingLoading.value) return;

    isPendingLoading.value = true;
    final response =
        await CouponService().getCoupons(page: page, limit: _pageSize);

    if (response.isSuccess) {
      final data = response.data['data'];
      final List<dynamic> list = data['coupons'] ?? [];
      pendingCoupons.value = list.map((e) => CouponModel.fromJson(e)).toList();
      pendingCurrentPage = data['page'] ?? page;
      pendingTotalPages = data['pages'] ?? 1;
    } else {
      AppSnackbar.error(response.message ?? 'Failed to fetch pending coupons');
    }
    isPendingLoading.value = false;
  }

  /// Fetches approved coupons. Replaces the list for a new page.
  Future<void> fetchApprovedCoupons({int page = 1}) async {
    if (isApprovedLoading.value) return;

    isApprovedLoading.value = true;
    final response =
        await CouponService().getApprovedCoupons(page: page, limit: _pageSize);

    if (response.isSuccess) {
      final data = response.data['data'];
      final List<dynamic> list = data['coupons'] ?? [];
      approvedCoupons.value = list.map((e) => CouponModel.fromJson(e)).toList();
      approvedCurrentPage = data['page'] ?? page;
      approvedTotalPages = data['pages'] ?? 1;
    } else {
      AppSnackbar.error(response.message ?? 'Failed to fetch approved coupons');
    }
    isApprovedLoading.value = false;
  }

  /// Fetches rejected coupons. Replaces the list for a new page.
  Future<void> fetchRejectedCoupons({int page = 1}) async {
    if (isRejectedLoading.value) return;

    isRejectedLoading.value = true;
    final response =
        await CouponService().getRejectedCoupons(page: page, limit: _pageSize);

    if (response.isSuccess) {
      final data = response.data['data'];
      final List<dynamic> list = data['coupons'] ?? [];
      rejectedCoupons.value = list.map((e) => CouponModel.fromJson(e)).toList();
      rejectedCurrentPage = data['page'] ?? page;
      rejectedTotalPages = data['pages'] ?? 1;
    } else {
      AppSnackbar.error(response.message ?? 'Failed to fetch rejected coupons');
    }
    isRejectedLoading.value = false;
  }

  /// Approves a coupon and updates the local lists.
  Future<void> approveCoupon(String couponId) async {
    final response = await CouponService().approveCoupon(couponId);
    if (response.isSuccess) {
      AppSnackbar.success('Coupon approved');
      pendingCoupons.removeWhere((c) => c.id == couponId);
      // Invalidate approved list to refetch with new data on next view
      approvedCoupons.clear();
      hasAttemptedInitialFetchApproved.value = false;
    } else {
      AppSnackbar.error(response.message ?? 'Failed to approve coupon');
    }
  }

  /// Rejects a coupon and updates the local lists.
  Future<void> rejectCoupon(String couponId) async {
    final response = await CouponService().rejectCoupon(couponId);
    if (response.isSuccess) {
      AppSnackbar.success('Coupon rejected');
      pendingCoupons.removeWhere((c) => c.id == couponId);
      // Invalidate rejected list to refetch with new data on next view
      rejectedCoupons.clear();
      hasAttemptedInitialFetchRejected.value = false;
    } else {
      AppSnackbar.error(response.message ?? 'Failed to reject coupon');
    }
  }

  /// Handles new coupons from the socket connection.
  void _onNewCoupon(dynamic data) {
    try {
      final cpn = CouponModel.fromJson(data);
      if (!pendingCoupons.any((c) => c.id == cpn.id)) {
        pendingCoupons.insert(0, cpn);
      }
    } catch (e) {
      print('Error parsing newCoupons: $e');
    }
  }
}
