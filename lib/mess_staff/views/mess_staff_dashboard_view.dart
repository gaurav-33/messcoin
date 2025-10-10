import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/widgets/app_bar.dart';
import 'package:messcoin/core/widgets/neu_button.dart';
import 'package:messcoin/mess_staff/controllers/mess_staff_dashboard_controller.dart';
import 'package:messcoin/core/routes/mess_staff_routes.dart';
import '../../utils/logout_confirmation_dialog.dart';
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

class MessStaffDashboardView extends StatelessWidget {
  const MessStaffDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final MessStaffDashboardController controller =
        Get.find<MessStaffDashboardController>();
    final theme = Theme.of(context);
    final List<_GridItem> gridItems = [
      _GridItem(
          image: 'assets/images/purchase-history.png',
          title: 'Transactions',
          onTap: () => Get.toNamed(MessStaffRoutes.getMessStaffTransactions()),
          circle: true,
          isSpecial: true,
          color: theme.colorScheme.secondary),
      _GridItem(
          image: 'assets/images/logout.png',
          title: 'Logout',
          onTap: () => showLogoutConfirmationDialog(
              context: context, onConfirm: () => controller.logout()),
          color: theme.colorScheme.error,
          circle: true),
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const NeuAppBar(
                  showThemeSwitch: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Staff Dashboard',
                  style: theme.textTheme.headlineMedium,
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
              ],
            ),
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
    final theme = Theme.of(context);
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
              color: color ?? theme.colorScheme.onSurface,
            ),
          ),
          if (title != null && title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                title!,
                style: theme.textTheme.bodySmall,
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
