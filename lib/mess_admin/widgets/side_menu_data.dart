import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/routes/admin_routes.dart';
import '../../mess_admin/controllers/dashboard_controller.dart';
import '../../../../config/app_colors.dart';

class SideMenuModel {
  final String iconPath;
  final String title;
  final Color? color;
  final VoidCallback onTap;
  const SideMenuModel({
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.color,
  });
}

class SideMenuData {
  final List<SideMenuModel> menu = <SideMenuModel>[
    SideMenuModel(
      iconPath: 'assets/svgs/dashboard.svg',
      title: 'Dashboard',
      onTap: () => Get.toNamed(AdminRoutes.dashboardContent, id: 1),
    ),
    SideMenuModel(
      iconPath: 'assets/svgs/transfer.svg',
      title: 'Transaction',
      onTap: () => Get.toNamed(AdminRoutes.transaction, id: 1),
    ),
    SideMenuModel(
      iconPath: 'assets/svgs/coupon.svg',
      title: 'Coupon',
      onTap: () => Get.toNamed(AdminRoutes.coupon, id: 1),
    ),
    SideMenuModel(
      iconPath: 'assets/svgs/bar_chart.svg',
      title: 'Report',
      onTap: () => Get.toNamed(AdminRoutes.report, id: 1),
    ),
    SideMenuModel(
      iconPath: 'assets/svgs/search.svg',
      title: 'Student',
      onTap: () => Get.toNamed(AdminRoutes.student, id: 1),
    ),
    SideMenuModel(
      iconPath: 'assets/svgs/calender.svg',
      title: 'Leave',
      onTap: () => Get.toNamed(AdminRoutes.leave, id: 1),
    ),
    SideMenuModel(
      iconPath: 'assets/svgs/mess-menu.svg',
      title: 'Mess Menu',
      onTap: () => Get.toNamed(AdminRoutes.menu, id: 1),
    ),
    SideMenuModel(
      iconPath: 'assets/svgs/extra-menu.svg',
      title: 'Extra Menu',
      onTap: () => Get.toNamed(AdminRoutes.extraMenu, id: 1),
    ),
    SideMenuModel(
      iconPath: 'assets/svgs/profile.svg',
      title: 'Profile',
      onTap: () => Get.toNamed(AdminRoutes.profile, id: 1),
    ),
    SideMenuModel(
      iconPath: 'assets/svgs/logout.svg',
      title: 'Logout',
      onTap: () => Get.find<DashboardController>().logout(),
      color: AppColors.primaryColor,
    ),
  ];
}