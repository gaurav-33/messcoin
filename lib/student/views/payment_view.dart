import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/utils/extensions.dart';
import '../../config/app_colors.dart';
import '../../core/models/day_extra_menu_model.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/input_field.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../../../utils/responsive.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const NeuAppBar(toBack: true),
                const SizedBox(height: 24),
                Text(
                  'Paying To',
                  style: textTheme.bodyMedium?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.studentModel?.mess.name ?? 'mess coin',
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: NeuContainer(
                    width: Responsive.contentWidth(context),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      children: [
                        Text("Pay For", style: textTheme.headlineMedium),
                        const SizedBox(height: 12),
                        Obx(
                          () => Text(
                            "Balance: ₹ ${controller.studentModel?.wallet.balance ?? 0}",
                            style: textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildCounterSelector(context, controller),
                        const SizedBox(height: 24),
                        _buildExtraMenuItems(context, controller),
                        const SizedBox(height: 24),
                        _buildAmountInputField(context, controller),
                        const SizedBox(height: 24),
                        Obx(
                          () => NeuButton(
                            width: Responsive.contentWidth(context) * 0.5,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              controller.pay(context);
                            },
                            child: controller.isLoading.value
                                ? const NeuLoader()
                                : const Text('Pay Now',
                                    style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounterSelector(
      BuildContext context, PaymentController controller) {
    return Column(
      children: [
        Text(
          'Select Counter',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Obx(
          () => Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(controller.counters, (index) {
              final counter = index + 1;
              final isSelected = controller.selectedCounter.value == counter;
              return NeuButton(
                onTap: () => controller.changeCounter(counter),
                invert: isSelected,
                shape: BoxShape.circle,
                height: 40,
                width: 40,
                child: Text(
                  '$counter',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected ? AppColors.bgColor : AppColors.dark,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // Builds the list of selectable extra menu items.
  Widget _buildExtraMenuItems(
      BuildContext context, PaymentController controller) {
    return Obx(() {
      if (controller.todaysExtras.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("No extra items available at this time."),
        );
      }
      return Column(
        children: [
          Obx(() => Text("Today's ${controller.currentMealName.value}",
              style: Theme.of(context).textTheme.bodyMedium)),
          const SizedBox(height: 16),
          // List of items
          ...controller.todaysExtras.map((extra) {
            return Obx(() {
              final isSelected = controller.selectedItems.containsKey(extra);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    // Wrap the button with Expanded to make it fill the remaining space
                    Expanded(
                      child: NeuButton(
                        onTap: () => controller.toggleItemSelection(extra),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${extra.item.toCamelCase()} (₹${extra.price})',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : null,
                                  fontWeight: isSelected
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                          ),
                        ),
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 10),
                      _buildQuantitySelector(controller, extra),
                    ]
                  ],
                ),
              );
            });
          }),
          // 'Others' button for custom amount
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Obx(() {
              final isSelected = controller.isCustomAmount.value;
              return NeuButton(
                width: Responsive.contentWidth(context),
                onTap: () => controller.selectCustomAmount(),
                // color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 12.0),
                  child: Text(
                    'Others (Custom Amount)',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected ? AppColors.primaryColor : null,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                  ),
                ),
              );
            }),
          ),
        ],
      );
    });
  }

  // Input field for total amount. Read-only when items are selected.
  Widget _buildAmountInputField(
      BuildContext context, PaymentController controller) {
    return Obx(() {
      return InputField(
        width: Responsive.contentWidth(context),
        label: 'Total Amount',
        hintText: 'Select items or enter amount',
        prefixText: '₹ ',
        controller: controller.amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        readOnly: !controller.isCustomAmount.value,
      );
    });
  }

  // Quantity selector for a specific item.
  Widget _buildQuantitySelector(PaymentController controller, ExtraMeal item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        NeuButton(
          onTap: () => controller.decrementQuantity(item),
          shape: BoxShape.circle,
          height: 36,
          width: 36,
          child: const Icon(Icons.remove, size: 20),
        ),
        SizedBox(
          width: 40,
          child: Obx(() => Text(
                '${controller.selectedItems[item] ?? 1}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold),
              )),
        ),
        NeuButton(
          onTap: () => controller.incrementQuantity(item),
          shape: BoxShape.circle,
          height: 36,
          width: 36,
          child: const Icon(Icons.add, size: 20),
        ),
      ],
    );
  }
}
