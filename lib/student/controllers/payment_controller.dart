import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../core/models/day_extra_menu_model.dart';
import '../../core/models/student_model.dart';
import '../../core/services/transaction_service.dart';
import '../../student/controllers/dashboard_controller.dart';
import '../../student/controllers/menu_controller.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/extensions.dart';
import '../../utils/responsive.dart';
import '../../utils/validators.dart';
import '../../core/widgets/receipt_clipper.dart';
import '../../core/widgets/neu_button.dart';

class PaymentController extends GetxController {
  final amountController = TextEditingController();
  final RxBool isLoading = false.obs;
  StudentModel? get studentModel =>
      Get.find<DashboardController>().student.value;

  final MessMenuController _menuController = Get.find<MessMenuController>();
  final RxList<ExtraMeal> todaysExtras = <ExtraMeal>[].obs;

  final RxMap<ExtraMeal, int> selectedItems = <ExtraMeal, int>{}.obs;

  final RxBool isCustomAmount = true.obs;
  final RxString currentMealName = "Extras".obs;

  @override
  void onInit() {
    super.onInit();
    _loadTodaysExtras();
  }

  void _loadTodaysExtras() {
    final todayName = DateFormat('EEEE').format(DateTime.now());
    final extraMenuForToday = _menuController.getExtraMenuForDay(todayName);
    final int currentHour = DateTime.now().hour;

    List<ExtraMeal> currentExtras = [];

    if (extraMenuForToday != null) {
      if (currentHour >= 6 && currentHour <= 11) {
        currentExtras.addAll(extraMenuForToday.breakfast);
        currentMealName.value = "Breakfast Extras";
      } else if (currentHour > 11 && currentHour <= 15) {
        currentExtras.addAll(extraMenuForToday.lunch);
        currentMealName.value = "Lunch Extras";
      } else if (currentHour >= 18 && currentHour <= 23) {
        currentExtras.addAll(extraMenuForToday.dinner);
        currentMealName.value = "Dinner Extras";
      } else {
        currentMealName.value = "Extras";
      }
    }
    todaysExtras.value = currentExtras;
  }

  void toggleItemSelection(ExtraMeal item) {
    isCustomAmount.value = false;
    amountController.clear();

    if (selectedItems.containsKey(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems[item] = 1;
    }

    if (selectedItems.isEmpty) {
      isCustomAmount.value = true;
    }
    _updateTotalAmount();
  }

  void selectCustomAmount() {
    selectedItems.clear();
    amountController.clear();
    isCustomAmount.value = true;
    _updateTotalAmount();
  }

  void incrementQuantity(ExtraMeal item) {
    if (selectedItems.containsKey(item) && selectedItems[item]! < 5) {
      selectedItems[item] = selectedItems[item]! + 1;
      _updateTotalAmount();
    }
  }

  void decrementQuantity(ExtraMeal item) {
    if (selectedItems.containsKey(item) && selectedItems[item]! > 1) {
      selectedItems[item] = selectedItems[item]! - 1;
      _updateTotalAmount();
    }
  }

  void _updateTotalAmount() {
    if (isCustomAmount.value || selectedItems.isEmpty) {
      amountController.clear();
      return;
    }
    double total = 0.0;
    selectedItems.forEach((item, quantity) {
      total += item.price * quantity;
    });
    amountController.text = total.toStringAsFixed(2);
  }

  void pay(BuildContext context) async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final amount = amountController.text.trim();
      final amountError = Validators.validateAmount(amount);

      if (amountError != null) {
        AppSnackbar.error(amountError);
        return;
      }
      if (studentModel == null) {
        AppSnackbar.error('Student data not found');
        return;
      }
      if (studentModel!.wallet.balance < double.parse(amount)) {
        AppSnackbar.error('Insufficient balance');
        return;
      }

      final Map<ExtraMeal, int> itemsToPay = Map.from(selectedItems);
      final String totalAmount = amount;

      if (isCustomAmount.value) {
        final response = await TransactionService().createTransaction(
          amount: double.parse(amount),
          item: 'others',
          qty: 1,
        );
        if (response.isSuccess) {
          showPaymentSuccessDialog(
            context: context,
            totalAmount: totalAmount,
            items: {},
            name: studentModel?.mess.name ?? "Venom Catering Service",
            transactionId: response.data['data']['transaction_id'],
          );
        } else {
          AppSnackbar.error('Payment failed: ${response.message}');
          return;
        }
      } else {
        if (selectedItems.isEmpty) {
          AppSnackbar.error('Please select an item to pay for.');
          return;
        }

        final itemsPayload = itemsToPay.entries.map((entry) {
          return {
            "item": entry.key.item,
            "qty": int.parse(entry.value.toString()),
            "price": double.parse(entry.key.price.toString()),
          };
        }).toList();
        if (itemsPayload.isEmpty) {
          AppSnackbar.error('No items selected to pay for.');
          return;
        }

        final parsedAmount = double.tryParse(totalAmount);
        if (parsedAmount == null) {
          AppSnackbar.error('Invalid total amount');
          return;
        }

        final response = await TransactionService().createBulkTransaction(
          amount: parsedAmount,
          items: itemsPayload,
        );

        if (response.isSuccess) {
          AppSnackbar.success(response.message ?? 'Payment successful');
          showPaymentSuccessDialog(
            context: context,
            totalAmount: totalAmount,
            items: itemsToPay,
            name: studentModel?.mess.name ?? "Venom Catering Service",
          );
        } else {
          AppSnackbar.error('Payment failed: ${response.message}');
          return;
        }
      }

      await Get.find<DashboardController>().refreshStudent();
      selectedItems.clear();
      amountController.clear();
      isCustomAmount.value = true;
    } catch (e) {
      AppSnackbar.error('An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Widget _buildReceiptItems(BuildContext context, Map<ExtraMeal, int> items) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 3,
                child: Text('Item',
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold))),
            Expanded(
                flex: 1,
                child: Text('Qty',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold))),
            Expanded(
                flex: 2,
                child: Text('Total',
                    textAlign: TextAlign.end,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold))),
          ],
        ),
        const Divider(height: 12),
        ...items.entries.map((entry) {
          final item = entry.key;
          final quantity = entry.value;
          final total = item.price * quantity;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 3,
                    child: Text(item.item.toCamelCase(),
                        style: textTheme.bodyMedium)),
                Expanded(
                    flex: 1,
                    child: Text('$quantity',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium)),
                Expanded(
                    flex: 2,
                    child: Text('₹${total.toStringAsFixed(2)}',
                        textAlign: TextAlign.end,
                        style: textTheme.bodyMedium
                            ?.copyWith(fontFamily: 'FiraCode'))),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  void showPaymentSuccessDialog({
    required BuildContext context,
    required String totalAmount,
    required Map<ExtraMeal, int> items,
    required String name,
    String transactionId = '',
  }) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: ClipPath(
            clipper: ReceiptClipper(),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: screenHeight * 0.8),
              child: Container(
                color: AppColors.bgColor,
                width: Responsive.contentWidth(context),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: AppColors.primaryColor, size: 70),
                      const SizedBox(height: 16),
                      Text('Payment Successful!',
                          style: textTheme.headlineMedium),
                      const SizedBox(height: 24),
                      if (items.isNotEmpty) ...[
                        _buildReceiptItems(context, items),
                        const SizedBox(height: 16),
                        CustomPaint(
                            painter: DashedLinePainter(),
                            child: const SizedBox(
                                height: 1, width: double.infinity)),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Paid", style: textTheme.titleLarge),
                          Text('₹$totalAmount',
                              style: textTheme.displaySmall?.copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'FiraCode')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomPaint(
                          painter: DashedLinePainter(),
                          child: const SizedBox(
                              height: 1, width: double.infinity)),
                      const SizedBox(height: 16),
                      _buildDetailRow(context, 'From:',
                          studentModel?.fullName.toCamelCase() ?? ""),
                      _buildDetailRow(context, 'To:', name.toCamelCase()),
                      _buildDetailRow(
                        context,
                        'Time:',
                        DateTime.now().toIso8601String().toKolkataTime(),
                      ),
                      if (transactionId.isNotEmpty)
                        _buildDetailRow(context, 'Txn. ID:', transactionId,
                            isSelectable: true),
                      const SizedBox(height: 32),
                      NeuButton(
                        shape: BoxShape.circle,
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(Icons.close_rounded,
                            color: AppColors.lightDark),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value,
      {bool isSelectable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 16),
          Expanded(
            child: isSelectable
                ? SelectableText(
                    value,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                : Text(
                    value,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
