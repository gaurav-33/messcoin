import 'package:get/get.dart';
import 'package:messcoin/mess_staff/bindings/mess_staff_dashboard_bindings.dart';
import 'package:messcoin/mess_staff/views/employee_login_view.dart';
import 'package:messcoin/mess_staff/views/mess_staff_dashboard_view.dart';
import 'package:messcoin/mess_staff/views/mess_staff_transactions_view.dart';

class MessStaffRoutes {
  static const String employeeLogin = '/employee-login';
  static const String messStaffDashboard = '/mess-staff-dashboard';
  static const String messStaffTransactions = '/mess-staff-transactions';

  static String getEmployeeLogin() => employeeLogin;
  static String getMessStaffDashboard() => messStaffDashboard;
  static String getMessStaffTransactions() => messStaffTransactions;

  static List<GetPage> routes = [
    GetPage(name: employeeLogin, page: () => const EmployeeLoginView()),
    GetPage(
        name: messStaffDashboard,
        page: () => const MessStaffDashboardView(),
        binding: MessStaffDashboardBindings()),
    GetPage(
        name: messStaffTransactions,
        page: () => const MessStaffTransactionsView()),
  ];
}
