import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/models/transaction_model.dart';
import '../../core/services/transaction_service.dart';
import '../../utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import '../../../../core/sockets/socket_manager.dart';

// ⭐️ ADD THIS ENUM FOR MEAL TYPES
enum MealType { all, breakfast, lunch, dinner }

class TransactionController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  int currentPage = 1;
  int totalPages = 1;
  int pageSize = 20;

  // For calendar and date selection
  Rx<DateTime> calendarDate = DateTime.now().obs;
  String get selectedDate =>
      DateFormat('yyyy-MM-dd').format(calendarDate.value);

  // ⭐️ ADD STATE FOR MEAL FILTER
  Rx<MealType> selectedMealType = MealType.all.obs;

  RxBool get isLive => SocketManager().isLive;

  // ⭐️ HELPER TO GET CURRENT MEAL NAME
  String get _currentMealName {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour <= 11) return 'Breakfast';
    if (hour > 11 && hour <= 15) return 'Lunch';
    if (hour >= 18 && hour <= 23) return 'Dinner';
    return 'No Meal Active';
  }

  // ⭐️ MODIFIED GETTER FOR LIVE STATUS TEXT
  String get liveStatusText {
    if (!isLive.value) return 'Offline';
    return 'Live ($_currentMealName)';
  }

  // ⭐️ ADD COMPUTED LIST FOR FILTERED TRANSACTIONS
  List<TransactionModel> get displayTransactions {
    if (selectedMealType.value == MealType.all) {
      return transactions;
    }
    return transactions.where((txn) {
      final hourString = DateFormat('HH')
          .format(txn.createdAt.add(Duration(hours: 5, minutes: 30)));
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
  }

  // ⭐️ ADD METHOD TO CHANGE THE FILTER
  void changeMealType(MealType meal) {
    selectedMealType.value = meal;
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

  List<TransactionModel> get latestTransactions {
    final sorted = List<TransactionModel>.from(transactions);
    return sorted.take(10).toList();
  }

  Future<void> fetchTransactions({
    int page = 1,
    int limit = 20,
    String? date,
  }) async {
    isLoading.value = true;
    final fetchDate = date ?? selectedDate;
    final response = await TransactionService().dailyTransaction(
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
