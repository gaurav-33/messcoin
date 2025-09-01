import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/config/app_colors.dart';
import 'package:messcoin/core/routes/hmc_routes.dart';
import 'package:messcoin/hmc/controllers/dashboard_controller.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/neu_button.dart';
import '../../utils/responsive.dart';

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

class HmcDashboardView extends StatelessWidget {
  const HmcDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HmcDashboardController controller =
        Get.find<HmcDashboardController>();
    final List<_GridItem> gridItems = [
      _GridItem(
          image: 'assets/images/rating-meter.png',
          title: 'Ratings',
          onTap: () => Get.toNamed(HmcRoutes.getMessRatings()),
          circle: true,
          isSpecial: true,
          color: AppColors.primaryColor),
      _GridItem(
        image: 'assets/images/feedback.png',
        title: 'Feedback',
        onTap: () => Get.toNamed(HmcRoutes.getFeedbackView()),
      ),
      _GridItem(
          image: 'assets/images/profile-search.png',
          title: 'Students',
          onTap: () => Get.toNamed(HmcRoutes.getStudentSearch()),
          circle: true),
      _GridItem(
        image: 'assets/images/daily-menu.png',
        title: 'Menu',
        onTap: () => Get.toNamed(HmcRoutes.getMessMenu()),
      ),
      _GridItem(
          image: 'assets/images/bill.png',
          title: 'Bill',
          onTap: () => Get.toNamed(HmcRoutes.getBill()),
          circle: true),
      _GridItem(
          image: 'assets/images/profile.png',
          title: 'Profile',
          onTap: () => Get.toNamed(HmcRoutes.getProfile())),
      _GridItem(
          image: 'assets/images/logout.png',
          title: 'Logout',
          onTap: () => controller.logout(),
          color: AppColors.primaryColor.withOpacity(0.6),
          circle: true),
    ];
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const NeuAppBar(),
            const SizedBox(height: 24),
            Text(
              'HMC Dashboard',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
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

                final double cellWidth =
                    (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
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
          ],
        ),
      ),
    )));
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
