import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/coupon_model.dart';
import '../../../core/models/transaction_model.dart';
import '../../config/app_colors.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../student/controllers/history_controller.dart';
import '../../utils/extensions.dart';
import '../../../../utils/responsive.dart';
import '../../core/widgets/receipt_clipper.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoryController controller = Get.put(HistoryController());
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const NeuAppBar(toBack: true),
              const SizedBox(height: 24),
              Text('History', style: textTheme.headlineMedium),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.historyItems.isEmpty) {
                    return const Center(child: NeuLoader());
                  }
                  if (controller.historyItems.isEmpty) {
                    return const Center(child: Text('No history found.'));
                  }

                  return Center(
                    child: SizedBox(
                      width: Responsive.contentWidth(context),
                      child: ListView.builder(
                        itemCount: controller.historyItems.length,
                        itemBuilder: (context, index) {
                          final item = controller.historyItems[index];
                          return _buildHistoryTile(context, item, controller);
                        },
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTile(
      BuildContext context, dynamic item, HistoryController controller) {
    final bool isTransaction = item is TransactionModel;

    final String title = isTransaction
        ? '${item.item?.toCamelCase()}'
        : item.status == 'approved'
            ? 'Coupon Received'
            : 'Coupon Requested';
    final num amount = item.amount;
    final Color color = isTransaction
        ? AppColors.error
        : item.status == 'approved'
            ? AppColors.success
            : AppColors.neutralDark;
    final String prefix = isTransaction
        ? '-'
        : item.status == 'approved'
            ? '+'
            : '';
    final IconData icon = isTransaction
        ? Icons.arrow_upward
        : item.status == 'approved'
            ? Icons.arrow_downward
            : Icons.circle;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: GestureDetector(
        onTap: () => _showDetailsDialog(context, item, controller),
        child: NeuContainer(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: AppColors.neutralDark)),
                    const SizedBox(height: 4),
                    Text(
                      item.updatedAt.toString().toKolkataTime(),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.lightDark),
                    ),
                  ],
                ),
              ),
              Text(
                '$prefix ₹$amount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // UPDATED: This dialog now shows a detailed receipt.
  void _showDetailsDialog(
      BuildContext context, dynamic item, HistoryController controller) {
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isTransaction = item is TransactionModel;

    showDialog(
      context: context,
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
                      // Header Icon and Title
                      Icon(
                        isTransaction
                            ? Icons.receipt_long
                            : Icons.confirmation_number_outlined,
                        color: AppColors.primaryColor,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isTransaction
                            ? 'Transaction Receipt'
                            : 'Coupon Details',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 24),

                      // Body of the receipt
                      if (isTransaction)
                        _buildTransactionReceipt(context, item,
                            controller.studentName, controller.messName)
                      else
                        _buildCouponReceipt(context, item, controller.messName),

                      const SizedBox(height: 32),

                      // Close Button
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

  // NEW: Widget to build the transaction receipt body.
  Widget _buildTransactionReceipt(BuildContext context, TransactionModel item,
      String? studentName, String? messName) {
    return Column(
      children: [
        // Item Details
        _buildItemRow(context, item),
        const SizedBox(height: 16),
        CustomPaint(
            painter: DashedLinePainter(),
            child: const SizedBox(height: 1, width: double.infinity)),
        const SizedBox(height: 16),
        // Total Amount
        _buildDetailRow(
          context,
          'Total Paid',
          '₹${item.amount}',
          isAmount: true,
          color: AppColors.error,
        ),
        const SizedBox(height: 16),
        CustomPaint(
            painter: DashedLinePainter(),
            child: const SizedBox(height: 1, width: double.infinity)),
        const SizedBox(height: 16),
        // Transaction Info
        _buildDetailRow(context, 'From:', studentName?.toCamelCase() ?? 'N/A'),
        _buildDetailRow(context, 'To:', messName?.toCamelCase() ?? 'N/A'),
        _buildDetailRow(
            context, 'Time:', item.createdAt.toString().toKolkataTime()),
        _buildDetailRow(context, 'Txn. ID:', item.transactionId,
            isSelectable: true),
      ],
    );
  }

  // NEW: Widget to build the coupon receipt body.
  Widget _buildCouponReceipt(
      BuildContext context, CouponModel item, String? messName) {
    String symbol = item.status == 'approved' ? '+' : '';
    return Column(
      children: [
        _buildDetailRow(
          context,
          'Amount:',
          '$symbol ₹${item.amount}',
          isAmount: true,
          color: item.status == 'approved'
              ? AppColors.success
              : AppColors.primaryColor,
        ),
        const SizedBox(height: 16),
        CustomPaint(
            painter: DashedLinePainter(),
            child: const SizedBox(height: 1, width: double.infinity)),
        const SizedBox(height: 16),
        _buildDetailRow(context, 'Status:', item.status.capitalizeFirst!,
            color: item.status == 'approved'
                ? AppColors.success
                : AppColors.primaryColor),
        _buildDetailRow(context, 'From:', messName?.toCamelCase() ?? 'N/A'),
        if (item.status == 'approved')
          _buildDetailRow(context, '${item.status.toCamelCase()} At:',
              item.updatedAt.toString().toKolkataTime()),
        _buildDetailRow(context, 'Requested At:',
            item.createdAt.toString().toKolkataTime()),
        _buildDetailRow(context, 'Cpn. ID:', item.couponId, isSelectable: true),
      ],
    );
  }


  Widget _buildItemRow(BuildContext context, TransactionModel txn) {
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
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 1,
              child: Text('Qty',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Text('Total',
                  textAlign: TextAlign.end,
                  style: textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const Divider(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 3,
                child: Text(txn.item?.toCamelCase() ?? 'others',
                    style: textTheme.bodyMedium)),
            Expanded(
                flex: 1,
                child: Text('${txn.quantity}',
                    textAlign: TextAlign.center, style: textTheme.bodyMedium)),
            Expanded(
              flex: 2,
              child: Text(
                '₹${txn.amount.toStringAsFixed(2)}',
                textAlign: TextAlign.end,
                style: textTheme.bodyMedium?.copyWith(fontFamily: 'FiraCode'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  
  Widget _buildDetailRow(BuildContext context, String title, String value,
      {bool isAmount = false, Color? color, bool isSelectable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontFamily: 'FiraCode'),
                  )
                : Text(
                    value,
                    textAlign: TextAlign.end,
                    style: isAmount
                        ? Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: color, fontWeight: FontWeight.bold)
                        : Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: color),
                  ),
          ),
        ],
      ),
    );
  }
}

// A helper painter for the dashed line in the receipt.
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = AppColors.lightDark.withOpacity(0.5)
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
