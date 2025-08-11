import 'package:get/get.dart';
import 'package:messcoin/student/controllers/dashboard_controller.dart';
import '../../core/models/transaction_model.dart';
import '../../core/models/coupon_model.dart';
import '../../core/services/transaction_service.dart';
import '../../core/services/coupon_service.dart';
import '../../core/network/api_response.dart';
import '../../utils/app_snackbar.dart';

class HistoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  // Private lists for raw data
  final RxList<TransactionModel> _transactions = <TransactionModel>[].obs;
  final RxList<CouponModel> _coupons = <CouponModel>[].obs;

  // Public, combined, and sorted list for the UI
  RxList<dynamic> historyItems = <dynamic>[].obs;

  String? get studentName =>
      Get.find<DashboardController>().student.value?.fullName;
  String? get messName =>
      Get.find<DashboardController>().student.value?.mess.name;
  @override
  void onInit() {
    super.onInit();
    fetchAllHistory();
  }

  // Fetches both transaction and coupon history, then combines and sorts them.
  Future<void> fetchAllHistory() async {
    isLoading.value = true;
    error.value = '';
    try {
      // Fetch both histories in parallel for better performance.
      await Future.wait([
        _fetchTransactionHistory(),
        _fetchCouponHistory(),
      ]);
      _combineAndSortHistory();
    } catch (e) {
      error.value = 'Error fetching history: $e';
      AppSnackbar.error('Failed to load history');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchTransactionHistory() async {
    try {
      final ApiResponse response = await TransactionService().getTransactions();
      if (response.isSuccess) {
        final List<dynamic> data = response.data['data']['transactions'];
        _transactions.value =
            data.map((e) => TransactionModel.fromJson(e)).toList();
      } else {
        throw Exception(
            response.message ?? 'Failed to load transaction history');
      }
    } catch (e) {
      // Propagate the error to be caught by the main fetch method.
      rethrow;
    }
  }

  Future<void> _fetchCouponHistory() async {
    try {
      final ApiResponse response = await CouponService().getStudentCoupons();
      if (response.isSuccess) {
        final List<dynamic> data = response.data['data']['coupons'];
        _coupons.value = data.map((e) => CouponModel.fromJson(e)).toList();
      } else {
        throw Exception(response.message ?? 'Failed to load coupon history');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Combines the two lists and sorts them by date.
  void _combineAndSortHistory() {
    List<dynamic> combinedList = [];
    combinedList.addAll(_transactions);
    combinedList.addAll(_coupons);

    // Sort by createdAt date, with the newest items first.
    combinedList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    historyItems.value = combinedList;
  }
}
