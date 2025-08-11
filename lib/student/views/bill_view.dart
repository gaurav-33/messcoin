import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messcoin/core/widgets/app_bar.dart';
import 'package:messcoin/core/widgets/neu_container.dart';
import 'package:messcoin/core/widgets/neu_loader.dart';
import 'package:messcoin/student/controllers/bill_controller.dart';
import 'package:messcoin/utils/responsive.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class BillView extends StatelessWidget {
  const BillView({super.key});

  @override
  Widget build(BuildContext context) {
    final BillController controller = Get.put(BillController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: NeuAppBar(
          toBack: true,
        ),
      ),
      body: Center(
        child: SizedBox(
          width: Responsive.contentWidth(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final picked = await showMonthPicker(
                      context: context,
                      initialDate: controller.selectedMonth.value,
                      firstDate: DateTime(2025, 1, 1),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      controller.changeMonth(picked);
                    }
                  },
                  child: NeuContainer(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const SizedBox(width: 16),
                        Obx(() => Text(
                              DateFormat('MMMM, yyyy')
                                  .format(controller.selectedMonth.value),
                              style: Theme.of(context).textTheme.titleLarge,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: NeuLoader());
                    }
                    if (controller.error.isNotEmpty) {
                      return Center(
                        child: Text(controller.error.value,
                            style: const TextStyle(color: Colors.red)),
                      );
                    }
                    if (controller.bill.value == null) {
                      return const Center(child: Text('No bill found for this month.'));
                    }
                    final bill = controller.bill.value!;
                    return NeuContainer(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildBillRow('Total Days', '${bill.totalDays}'),
                          _buildBillRow('Leave Days', '${bill.leaveDays}'),
                          _buildBillRow('Attended Days', '${bill.attendedDays}'),
                          _buildBillRow(
                              'Per Day Meal Price', '₹${bill.perDayMealPrice}'),
                          _buildBillRow('Meal Cost', '₹${bill.mealCost}'),
                          _buildBillRow('Coupon Amount', '₹${bill.couponAmount}'),
                          const Divider(height: 32),
                          _buildBillRow('Final Amount', '₹${bill.finalAmount}',
                              isTotal: true),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBillRow(String title, String value, {bool isTotal = false, Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
