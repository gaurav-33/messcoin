import 'package:get/get.dart';
import '../../mess_admin/bindings/coupon_binding.dart';
import '../../mess_admin/bindings/dashboard_binding.dart';
import '../../mess_admin/bindings/extra_menu_binding.dart';
import '../../mess_admin/bindings/leave_binding.dart';
import '../../mess_admin/bindings/menu_binding.dart';
import '../../mess_admin/bindings/profile_binding.dart';
import '../../mess_admin/bindings/report_binding.dart';
import '../../mess_admin/bindings/student_binding.dart';
import '../../mess_admin/bindings/transaction_binding.dart';
import '../../mess_admin/views/coupon_view.dart';
import '../../mess_admin/views/dashboard_view.dart';
import '../../mess_admin/views/extra_menu_view.dart';
import '../../mess_admin/views/leave_view.dart';
import '../../mess_admin/views/menu_view.dart';
import '../../mess_admin/views/profile_view.dart';
import '../../mess_admin/views/report_view.dart';
import '../../mess_admin/views/student_view.dart';
import '../../mess_admin/views/transaction_view.dart';
import '../../mess_admin/widgets/dashboard_widget.dart';

class AdminRoutes {
  static const String dashboard = '/admin/dashboard';
  static const String dashboardContent = '/admin/dashboard/content';
  static const String transaction = '/admin/transaction';
  static const String coupon = '/admin/coupon';
  static const String report = '/admin/report';
  static const String student = '/admin/student';
  static const String leave = '/admin/leave';
  static const String menu = '/admin/menu';
  static const String extraMenu = '/admin/extra-menu';
  static const String profile = '/admin/profile';

  static String getDashboard() => dashboard;
  static String getDashboardContent() => dashboardContent;
  static String getTransaction() => transaction;
  static String getCoupon() => coupon;
  static String getReport() => report;
  static String getStudent() => student;
  static String getLeave() => leave;
  static String getMenu() => menu;
  static String getExtraMenu() => extraMenu;
  static String getProfile() => profile;

  static List<GetPage> routes = [
    GetPage(
      name: dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
  ];

  static List<GetPage> nestedRoutes = [
    GetPage(name: dashboardContent, page: () => DashboardWidget()),
    GetPage(
      name: transaction,
      page: () => TransactionView(),
      binding: TransactionBinding(),
    ),
    GetPage(
      name: coupon,
      page: () => CouponView(),
      binding: CouponBinding(),
    ),
    GetPage(
      name: report,
      page: () => ReportView(),
      binding: ReportBinding(),
    ),
    GetPage(
      name: student,
      page: () => StudentView(),
      binding: StudentBinding(),
    ),
    GetPage(
      name: leave,
      page: () => LeaveView(),
      binding: LeaveBinding(),
    ),
    GetPage(
      name: menu,
      page: () => MenuView(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: extraMenu,
      page: () => ExtraMenuView(),
      binding: ExtraMenuBinding(),
    ),
    GetPage(
      name: profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}