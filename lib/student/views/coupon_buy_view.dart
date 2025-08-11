import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/utils/extensions.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/input_field.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../student/controllers/coupon_buy_controller.dart';
import '../../../../utils/responsive.dart';

class CouponBuyView extends StatelessWidget {
  const CouponBuyView({super.key});

  @override
  Widget build(BuildContext context) {
    final CouponBuyController controller = Get.put(CouponBuyController());
    final screenHeight = MediaQuery.of(context).size.height;
    final textTheme = Theme.of(context).textTheme;

    final double formWidth = Responsive.contentWidth(context);

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
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Requesting Coupon From',
                  style: textTheme.bodyMedium?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.studentModel?.mess.name.toCamelCase() ?? 'mess coin',
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.05),
                GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: NeuContainer(
                    width: formWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 32.0,
                      ),
                      child: Column(
                        children: [
                          Text("Request Coupon", style: textTheme.headlineMedium),
                          const SizedBox(height: 12),
                          Obx(
                            () => Text(
                              "Available Coupons: ₹ ${(controller.studentModel?.wallet.totalCredit ?? 0) - (controller.studentModel?.wallet.loadedCredit ?? 0)}",
                              style: textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                          InputField(
                            width: formWidth * 0.8,
                            label: 'Amount',
                            hintText: 'Enter Amount',
                            prefixText: '₹ ',
                            controller: controller.amountController,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 24),
                          Obx(
                            () => NeuButton(
                              width: formWidth * 0.5,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                controller.request(context);
                              },
                              child: controller.isLoading.value
                                  ? const NeuLoader()
                                  : const Text('Request',
                                      style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
