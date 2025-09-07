import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/models/transaction_model.dart';
import 'package:messcoin/mess_admin/controllers/dashboard_controller.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../mess_admin/controllers/transaction_controller.dart';
import '../../utils/extensions.dart';
import '../../utils/responsive.dart';
import '../../core/widgets/receipt_clipper.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.find<TransactionController>();
    final bool isDesktop = Responsive.isDesktop(context);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              if (!isDesktop)
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: NeuButton(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      width: 45,
                      child: Icon(Icons.menu, size: 24, color: theme.iconTheme.color)),
                ),
              if (!isDesktop) const SizedBox(width: 16),
              Text('Transactions',
                  style: theme.textTheme.headlineMedium),
              const SizedBox(width: 12),
              // ⭐️ UPDATE LIVE STATUS DISPLAY
              Obx(() {
                return Row(
                  children: [
                    Icon(Icons.circle,
                        color:
                            controller.isLive.value ? Colors.green : Colors.red,
                        size: 12),
                    const SizedBox(width: 4),
                    Text(
                      controller.liveStatusText, // Use new getter
                      style: theme.textTheme.bodySmall?.copyWith(
                            color: controller.isLive.value
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          // Date Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => NeuButton(
                  width: Responsive.isMobile(context)
                      ? Responsive.contentWidth(context) * 0.4
                      : Responsive.contentWidth(context) * 0.35,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  onTap: () async {
                    await controller.pickDate(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 20, color: theme.colorScheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        controller.selectedDate,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              NeuButton(
                width: 40,
                height: 40,
                shape: BoxShape.circle,
                onTap: () => controller.fetchTransactions(),
                child: Icon(Icons.refresh, color: theme.colorScheme.secondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCounterFilter(context, controller),
          const SizedBox(height: 8),

          // ⭐️ ADD MEAL FILTER WIDGET
          _buildMealFilter(context, controller),

          const SizedBox(height: 8),

          // ⭐️ UPDATE TRANSACTION LIST LOGIC
          Expanded(
            child: Obx(() {
              // Show loader only on initial load when list is empty
              if (controller.isLoading.value) {
                return const Center(child: NeuLoader());
              }
              // Use displayTransactions for checking emptiness and rendering
              if (controller.displayTransactions.isEmpty) {
                return Center(
                  child: Text(
                    // Show helpful message
                    controller.isLoading.value
                        ? 'Loading...'
                        : 'No transactions found for this ${controller.selectedMealType.value.name.toCamelCase()}.',
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: ListView.builder(
                        // Use the filtered list's length
                        itemCount: controller.displayTransactions.length,
                        itemBuilder: (context, index) {
                          // Get item from the filtered list
                          final txn = controller.displayTransactions[index];
                          return GestureDetector(
                            onTap: () => _showTransactionBill(context, txn),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: _buildTransactionTile(context, txn),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Pagination controls
                  if (controller.totalPages > 1)
                    _buildPaginationControls(context, controller),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterFilter(
      BuildContext context, TransactionController controller) {
    final theme = Theme.of(context);
    return Obx(() {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: List.generate(controller.counters, (index) {
          final counter = index + 1;
          final isSelected = controller.selectedCounterNo.value == counter;
          return NeuButton(
            onTap: () => controller.changeCounterNo(counter),
            invert: isSelected,
            shape: BoxShape.circle,
            height: 40,
            width: 40,
            child: Text(
              '$counter',
              style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected ? theme.colorScheme.onSecondary : theme.colorScheme.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
            ),
          );
        }),
      );
    });
  }

  // ⭐️ ADD THIS NEW WIDGET FOR MEAL FILTERS
  Widget _buildMealFilter(
      BuildContext context, TransactionController controller) {
    final theme = Theme.of(context);
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: Responsive.isMobile(context)
              ? null
              : Responsive.contentWidth(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: MealType.values.map((meal) {
              final isSelected = controller.selectedMealType.value == meal;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
                child: NeuButton(
                  onTap: () => controller.changeMealType(meal),
                  invert: isSelected,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      // Capitalize the first letter of the enum name
                      meal.name.toCamelCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? theme.colorScheme.onSecondary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // A more advanced tile for displaying transaction info to the admin.
  Widget _buildTransactionTile(BuildContext context, TransactionModel txn) {
    final theme = Theme.of(context);
    return NeuContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹ ${txn.amount.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'FiraCode',
                    ),
              ),
              Text(
                txn.createdAt.toString().toKolkataTime(),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          Divider(
            color: theme.dividerColor,
          ),

          /// Student Info
          Text(
            txn.studentData?.fullName.toCamelCase() ?? 'Unknown Student',
            style: theme.textTheme.titleMedium,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            'Roll: ${txn.studentData?.rollNo ?? 'N/A'}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text('Txn ID: ', style: theme.textTheme.bodySmall),
              Expanded(
                child: SelectableText(
                  txn.transactionId,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontFamily: 'FiraCode'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Shows a detailed bill/receipt for a single transaction.
  void _showTransactionBill(BuildContext context, TransactionModel item) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: ClipPath(
            clipper: ReceiptClipper(),
            child: Container(
              width: Responsive.contentWidth(context),
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long,
                        color: theme.colorScheme.secondary, size: 60),
                    const SizedBox(height: 16),
                    Text('Transaction Receipt', style: textTheme.headlineSmall),
                    const SizedBox(height: 24),

                    // Item Details Section
                    _buildItemRow(context, item),
                    const SizedBox(height: 16),
                    const DashedLine(),
                    const SizedBox(height: 16),

                    // Total Amount
                    _buildDetailRow(context, 'Total Paid',
                        '₹${item.amount.toStringAsFixed(2)}',
                        isAmount: true),
                    const SizedBox(height: 16),
                    const DashedLine(),
                    const SizedBox(height: 16),

                    // Transaction Info
                    _buildDetailRow(context, 'Billed To:',
                        item.studentData?.fullName.toCamelCase() ?? 'N/A'),
                    _buildDetailRow(
                        context, 'Roll No:', item.studentData?.rollNo ?? 'N/A'),
                    _buildDetailRow(
                        context,
                        'Billed By:',
                        Get.find<DashboardController>()
                                .messDetail
                                .value
                                ?.name
                                .toCamelCase() ??
                            'Unkonwn'),
                    _buildDetailRow(context, 'Time:',
                        item.createdAt.toString().toKolkataTime()),
                    _buildDetailRow(context, 'Txn. ID:', item.transactionId,
                        isSelectable: true),
                    const SizedBox(height: 32),

                    NeuButton(
                      shape: BoxShape.circle,
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close_rounded,
                          color: theme.iconTheme.color),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper to show a row in the receipt (e.g., "Billed To:", "John Doe").
  Widget _buildDetailRow(BuildContext context, String title, String value,
      {bool isAmount = false, bool isSelectable = false}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.bodyMedium),
          const SizedBox(width: 16),
          Expanded(
            child: isSelectable
                ? SelectableText(
                    value,
                    textAlign: TextAlign.end,
                    style: textTheme.bodyLarge
                        ?.copyWith(fontFamily: 'FiraCode', letterSpacing: 0.8),
                  )
                : Text(
                    value,
                    textAlign: TextAlign.end,
                    style: isAmount
                        ? textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold)
                        : textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500),
                  ),
          ),
        ],
      ),
    );
  }

  /// Helper to show the purchased item row in the receipt.
  Widget _buildItemRow(BuildContext context, TransactionModel txn) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
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
                child: Text('Price',
                    textAlign: TextAlign.end,
                    style: textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold))),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 3,
                child: Text(txn.item?.toCamelCase() ?? 'Others',
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

  /// Builds the pagination buttons at the bottom.
  Widget _buildPaginationControls(
      BuildContext context, TransactionController controller) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeuButton(
            width: 50,
            height: 50,
            shape: BoxShape.circle,
            onTap: controller.currentPage > 1
                ? () => controller.fetchTransactions(
                    page: controller.currentPage - 1)
                : null,
            child: const Icon(Icons.keyboard_arrow_left_rounded),
          ),
          const SizedBox(width: 16),
          Text(
            'Page ${controller.currentPage} of ${controller.totalPages}',
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold, fontFamily: 'FiraCode'),
          ),
          const SizedBox(width: 16),
          NeuButton(
            width: 50,
            height: 50,
            shape: BoxShape.circle,
            onTap: controller.currentPage < controller.totalPages
                ? () => controller.fetchTransactions(
                    page: controller.currentPage + 1)
                : null,
            child: const Icon(Icons.keyboard_arrow_right_rounded),
          ),
        ],
      ),
    );
  }
}

// Helper painter for the dashed line in the receipt.
class DashedLine extends StatelessWidget {
  const DashedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedLinePainter(),
      child: const SizedBox(height: 1, width: double.infinity),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final theme = Theme.of(Get.context!);
    double dashWidth = 5, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = theme.dividerColor
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}