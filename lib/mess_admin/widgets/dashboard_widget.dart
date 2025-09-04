import 'package:flutter/material.dart';
import 'package:messcoin/mess_admin/controllers/coupon_controller.dart';
import '../../config/app_colors.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_loader.dart';
import '../../mess_admin/widgets/bar_graph_widget.dart';
import '../../mess_admin/widgets/line_chart_widget.dart';
import '../../mess_admin/widgets/stat_card_widget.dart';
import '../../mess_admin/widgets/utility_widget.dart';
import '../../utils/responsive.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/transaction_controller.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isMobile = Responsive.isMobile(context);

    final List<Widget> statList = <Widget>[
      Obx(
        () => StatCardWidget(
          title: 'Active Student',
          value:
              '${controller.activeStudents.value} / ${controller.totalStudents.value}',
          subtitle: '',
          iconPath: 'assets/svgs/profile.svg',
        ),
      ),
      Obx(
        () => StatCardWidget(
          title: 'Transactions',
          value: '₹ ${controller.totalTransactionAmount.value}',
          subtitle: 'last 7 days',
          iconPath: 'assets/svgs/transfer.svg',
        ),
      ),
      Obx(
        () => StatCardWidget(
          title: 'Coupons',
          value: '₹ ${controller.totalCouponAmount.value}',
          subtitle: 'last 7 days',
          iconPath: 'assets/svgs/coupon.svg',
        ),
      ),
      Obx(
        () => StatCardWidget(
          title: 'Avg. Feedback',
          value: controller.averageFeedbackRating.value.toStringAsFixed(2),
          subtitle: 'last 7 days',
          iconPath: 'assets/svgs/star.svg',
        ),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (!isDesktop)
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: NeuButton(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      width: 45,
                      child: Icon(
                        Icons.menu,
                        color: AppColors.dark,
                      )),
                ),
              if (!isDesktop)
                SizedBox(
                  width: 16,
                ),
              Text('Dashboard',
                  style: Theme.of(context).textTheme.headlineMedium),
              const Spacer(),
              NeuButton(
                width: 40,
                height: 40,
                shape: BoxShape.circle,
                onTap: () => controller.refreshAll(),
                child: Icon(Icons.refresh, color: AppColors.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: isMobile ? 16 : 20,
            mainAxisSpacing: 16,
            childAspectRatio: isMobile ? 4 / 3 : 5 / 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: statList,
          ),
          const SizedBox(height: 32),
          Obx(() {
            if (controller.isLoading.value) {
              return NeuLoader();
            }
            return LineChartWidget(
              title: 'Transaction Overview',
              color: AppColors.primaryColor,
              data: controller.last7Days,
              valueSelector: (d) => d.transactionTotalAmount,
            );
          }),
          const SizedBox(height: 32),
          Obx(() {
            if (controller.isLoading.value) {
              return NeuLoader();
            }
            return LineChartWidget(
              title: 'Coupon Overview',
              data: controller.last7Days,
              color: Colors.pinkAccent,
              valueSelector: (d) => d.couponTotalAmount,
            );
          }),
          const SizedBox(height: 32),
          Obx(() {
            if (controller.isLoading.value) {
              return NeuLoader();
            }
            return BarGraphWidget();
          }),
          const SizedBox(height: 32),
          if (!isDesktop)
            FutureBuilder<bool>(
              future: waitForControllersRegistered(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || !(snapshot.data ?? false)) {
                  // Still waiting for both controllers, show loader
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const NeuLoader(size: 24),
                        const SizedBox(width: 16),
                        Text("Loading services...",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  );
                }
                // Both controllers are registered, show your widget!
                return UtilityWidget();
              },
            ),
        ],
      ),
    );
  }

  Future<bool> waitForControllersRegistered() async {
    // Poll for both controllers to become registered (every 50ms, max 2 seconds)
    final endTime = DateTime.now().add(const Duration(seconds: 5));
    while (!Get.isRegistered<TransactionController>() ||
        !Get.isRegistered<CouponController>()) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (DateTime.now().isAfter(endTime)) {
        // Timeout (you can return false or throw, or keep waiting longer)
        break;
      }
    }
    return Get.isRegistered<TransactionController>() &&
        Get.isRegistered<CouponController>();
  }
}
