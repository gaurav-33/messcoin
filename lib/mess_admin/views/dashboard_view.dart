import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/routes/admin_routes.dart';
import '../../core/widgets/neu_loader.dart';
import '../../mess_admin/controllers/dashboard_controller.dart';
import '../../mess_admin/widgets/side_menu_widget.dart';
import '../../mess_admin/widgets/utility_widget.dart';
import '../../../../utils/responsive.dart';
import '../controllers/coupon_controller.dart';
import '../controllers/transaction_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      key: controller.scaffoldKey,
      drawer: !isDesktop
          ? const SizedBox(
              width: 300,
              child: SideMenuWidget(),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              const Expanded(
                flex: 2,
                child: SizedBox(
                  child: SideMenuWidget(),
                ),
              ),
            Expanded(
              flex: 7,
              child: Navigator(
                key: Get.nestedKey(1),
                initialRoute: AdminRoutes.dashboardContent,
                onGenerateRoute: (settings) {
                  final page = AdminRoutes.nestedRoutes.firstWhere(
                    (page) => page.name == settings.name,
                    orElse: () => GetPage(
                      name: '/not_found',
                      page: () => const Scaffold(
                        body: Center(
                          child: Text('Page not found'),
                        ),
                      ),
                    ),
                  );
                  return GetPageRoute(
                    settings: settings,
                    page: page.page,
                    binding: page.binding,
                  );
                },
              ),
            ),
            if (isDesktop)
              Expanded(
                flex: 3,
                child: SizedBox(
                    child: FutureBuilder<bool>(
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
                )),
              ),
          ],
        ),
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
