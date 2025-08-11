import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/routes/student_routes.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/neu_button.dart';
import '../../student/controllers/dashboard_controller.dart';
import '../../student/widgets/neu_credit_card.dart';
import '../../utils/extensions.dart';
import '../../utils/responsive.dart';
import '../controllers/menu_controller.dart';

class _GridItem {
  final String image;
  final String title;
  final VoidCallback onTap;
  final bool circle;
  final bool isSpecial;
  final Color? color;

  _GridItem({
    required this.image,
    required this.title,
    required this.onTap,
    this.circle = false,
    this.isSpecial = false,
    this.color,
  });
}

class DashboradView extends StatelessWidget {
  const DashboradView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    Get.put(MessMenuController(), permanent: true);
    final screenHeight = MediaQuery.of(context).size.height;

    const double horizontalPadding = 16.0;

    final List<_GridItem> gridItems = [
      _GridItem(
          image: 'assets/images/pay.png',
          title: 'Pay',
          onTap: () => Get.toNamed(StudentRoutes.getPayment()),
          circle: true,
          isSpecial: true,
          color: AppColors.primaryColor),
      _GridItem(
          image: 'assets/images/coupon.png',
          title: 'Coupons',
          onTap: () => Get.toNamed(StudentRoutes.getCoupon())),
      _GridItem(
          image: 'assets/images/purchase-history.png',
          title: 'History',
          onTap: () => Get.toNamed(StudentRoutes.getHistory()),
          circle: true),
      _GridItem(
          image: 'assets/images/daily-menu.png',
          title: 'Menu',
          onTap: () => Get.toNamed(AppRoutes.getDailyMenu())),
      _GridItem(
          image: 'assets/images/card.png',
          title: 'ID Card',
          onTap: () => Get.toNamed(StudentRoutes.getIdCard()),
          circle: true),
      _GridItem(
          image: 'assets/images/profile.png',
          title: 'Profile',
          onTap: () => Get.toNamed(StudentRoutes.getProfile())),
      _GridItem(
          image: 'assets/images/feedback.png',
          title: 'Feedback',
          onTap: () => Get.toNamed(StudentRoutes.getFeedbackWrite()),
          circle: true),
      _GridItem(
          image: 'assets/images/leave.png',
          title: 'Leave',
          onTap: () => Get.toNamed(StudentRoutes.getLeave())),
      _GridItem(
          image: 'assets/images/bill.png',
          title: 'Bill',
          onTap: () => Get.toNamed(StudentRoutes.getBill()),
          circle:true
          ),
      _GridItem(
          image: 'assets/images/logout.png',
          title: 'Logout',
          onTap: () => controller.logout(),
          color: AppColors.primaryColor.withOpacity(0.6),),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.01),
              NeuAppBar(),
              SizedBox(height: screenHeight * 0.025),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Obx(
                  () => Text(
                    'Welcome, ${controller.student.value?.fullName.toCamelCase() ?? ''}!',
                    style: Theme.of(context).textTheme.headlineMedium,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  'Mess Coin is digital platform for seamless payment and management of mess coupons. Enjoy paperless convenience!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Center(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Obx(
                  () => NeuCreditCard(
                    fullName:
                        controller.student.value?.fullName.toCamelCase() ?? '',
                    rollNo: controller.student.value?.rollNo ?? '',
                    leftCoupon: (controller.student.value?.wallet.totalCredit ??
                            0) -
                        (controller.student.value?.wallet.loadedCredit ?? 0),
                    walletBalance:
                        controller.student.value?.wallet.balance ?? 0,
                    onTap: () => controller.refreshStudent(),
                  ),
                ),
              )),
              SizedBox(height: screenHeight * 0.03),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount;
                    double spacing;

                    if (Responsive.isDesktop(context)) {
                      crossAxisCount = 10;
                      spacing = 24;
                    } else if (Responsive.isTablet(context)) {
                      crossAxisCount = 6;
                      spacing = 20;
                    } else {
                      if (constraints.maxWidth > 480) {
                        crossAxisCount = 5;
                      } else if (constraints.maxWidth > 380) {
                        crossAxisCount = 4;
                      } else {
                        crossAxisCount = 3;
                      }
                      spacing = 16;
                    }

                    final double cellWidth = (constraints.maxWidth -
                            (spacing * (crossAxisCount - 1))) /
                        crossAxisCount;

                    final double tileSize = cellWidth - 24;

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: 1, //cellWidth / (cellWidth + 8),
                      ),
                      itemCount: gridItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = gridItems[index];
                        return NeuTileButton(
                          size: tileSize,
                          image: item.image,
                          title: item.title,
                          onTap: item.onTap,
                          circle: item.circle,
                          isSpecial: item.isSpecial,
                          color: item.color,
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

class NeuTileButton extends StatelessWidget {
  const NeuTileButton(
      {super.key,
      required this.size,
      required this.image,
      this.color,
      this.circle = false,
      this.isSpecial = false,
      this.onTap,
      this.title});

  final double size;
  final String image;
  final Color? color;
  final bool? circle;
  final bool? isSpecial;
  final VoidCallback? onTap;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          NeuButton(
            height: size,
            width: size,
            onTap: onTap,
            shape: circle == true ? BoxShape.circle : null,
            child: Image.asset(
              image,
              height: circle == true && isSpecial == true ? size : size * 0.7,
              color: color ?? AppColors.dark,
            ),
          ),
          if (title != null && title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
        ],
      ),
    );
  }
}
