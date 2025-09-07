import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messcoin/core/models/transaction_model.dart';
import 'package:messcoin/core/services/transaction_service.dart';
import 'package:messcoin/mess_staff/controllers/mess_staff_dashboard_controller.dart';
import 'package:messcoin/utils/app_snackbar.dart';
import '../../core/sockets/socket_manager.dart';

enum MealType { all, breakfast, lunch, dinner }

class MessStaffTransactionsController extends GetxController {
  RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  RxBool isLoading = false.obs;
  Rx<DateTime> calendarDate = DateTime.now().obs;
  String get selectedDate =>
      DateFormat('yyyy-MM-dd').format(calendarDate.value);

  Rx<MealType> selectedMealType = MealType.all.obs;
  int currentPage = 1;
  int totalPages = 1;
  int pageSize = 20;
  RxBool get isLive => SocketManager().isLive;

  RxInt selectedCounterNo = 1.obs; // 0 for all counters

  int get counters {
    final messDetail = Get.find<MessStaffDashboardController>().messDetail.value;
    return messDetail?.counters ?? 1;
  }

  // ⭐️ ADD COMPUTED LIST FOR FILTERED TRANSACTIONS
  List<TransactionModel> get displayTransactions {
    // First, filter by meal type
    List<TransactionModel> filteredByMeal = transactions.where((txn) {
      if (selectedMealType.value == MealType.all) {
        return true;
      }
      final hourString = DateFormat('HH')
          .format(txn.createdAt.add(const Duration(hours: 5, minutes: 30)));
      final hour = int.tryParse(hourString) ?? 0;
      switch (selectedMealType.value) {
        case MealType.breakfast:
          return hour >= 6 && hour <= 11; // 6 AM to 11:59 AM
        case MealType.lunch:
          return hour > 11 && hour <= 15; // 12 PM to 2:59 PM
        case MealType.dinner:
          return hour >= 18 && hour <= 23; // 6 PM to 10:59 PM
        case MealType.all:
          return true;
      }
    }).toList();

    // Then, filter by counter number
    if (selectedCounterNo.value == 1) {
      return filteredByMeal; // No counter filter applied
    } else {
      return filteredByMeal
          .where((txn) => txn.counter == selectedCounterNo.value)
          .toList();
    }
  }

  String get liveStatusText {
    if (!isLive.value) {
      return 'Offline';
    }
    return 'Live ($_currentMealName)';
  }

  // ⭐️ HELPER TO GET CURRENT MEAL NAME
  String get _currentMealName {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour <= 11) return 'Breakfast';
    if (hour > 11 && hour <= 15) return 'Lunch';
    if (hour >= 18 && hour <= 23) return 'Dinner';
    return '_';
  }

  Future<void> fetchTransactions({
    int page = 1,
    int limit = 20,
    String? date,
  }) async {
    isLoading.value = true;
    currentPage = page;
    final fetchDate = date ?? selectedDate;
    final response = await TransactionService().dailyEmployeeTransaction(
      page: page,
      limit: limit,
      date: fetchDate,
    );
    isLoading.value = false;
    if (response.isSuccess) {
      final List<dynamic> data = response.data['data']['transactions'] ?? [];
      final txns = data.map((e) => TransactionModel.fromJson(e)).toList();
      transactions.value = txns;
      currentPage = response.data['data']['page'] ?? page;
      pageSize = limit;
      totalPages = response.data['data']['pages'] ?? 1;
      calendarDate.value = DateFormat('yyyy-MM-dd').parse(fetchDate);
    } else {
      AppSnackbar.error(response.message ?? 'Failed to fetch transactions');
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
      fetchTransactions(date: DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  void changeMealType(MealType meal) {
    selectedMealType.value = meal;
    fetchTransactions();
  }

  void changeCounterNo(int counter) {
    selectedCounterNo.value = counter;
  }

  void _onNewTransaction(dynamic data) {
    try {
      final txn = TransactionModel.fromJson(data);
      if (transactions.isEmpty ||
          transactions.first.transactionId != txn.transactionId) {
        transactions.insert(0, txn);
        if (transactions.length > 100) transactions.removeLast();
      }
    } catch (e) {
      AppSnackbar.error('Error parsing newTransaction: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTransactions(date: selectedDate);
    final socketManager = SocketManager();
    socketManager.subscribe('newTransaction', _onNewTransaction);
  }

  @override
  void onClose() {
    final socketManager = SocketManager();
    socketManager.unsubscribe('newTransaction');
    super.onClose();
  }
}