import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/widgets/app_bar.dart';
import 'package:messcoin/core/widgets/neu_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messcoin/utils/responsive.dart';
import '../../mess_admin/controllers/dashboard_controller.dart';
import '../../mess_admin/widgets/side_menu_data.dart';

class SideMenuWidget extends StatelessWidget {
  const SideMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final menuData = SideMenuData().menu;
    final theme = Theme.of(context);

    final DashboardController controller = Get.find<DashboardController>();

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SafeArea(
            child: Column(
              children: [
                NeuAppBar(showThemeSwitch: true),
                const SizedBox(
                  height: 50,
                ),
                Obx(
                  () => Column(
                    children: [
                      ...List.generate(menuData.length, (index) {
                        final menu = menuData[index];
                        final bool isSelected =
                            index == controller.selectedIndex;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NeuButton(
                            invert: isSelected,
                            invertColor:
                                isSelected ? theme.colorScheme.secondary : null,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            onTap: () {
                              controller.selectedIndex = index;
                              menu.onTap(context);
                              if (index != menuData.length - 1 && !Responsive.isDesktop(context)) {
                                Get.back();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  menu.iconPath,
                                  color: isSelected
                                      ? theme.colorScheme.onSecondary
                                      : menu.color ?? theme.iconTheme.color,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  menu.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: isSelected
                                            ? theme.colorScheme.surface
                                            : theme.colorScheme.onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        letterSpacing: 1,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}