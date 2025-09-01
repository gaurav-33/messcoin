import 'package:get/get.dart';
import '../../hmc/bindings/dashboard_binding.dart';
import 'package:messcoin/hmc/bindings/bill_verification_binding.dart';
import 'package:messcoin/hmc/bindings/mess_menu_binding.dart';
import 'package:messcoin/hmc/bindings/live_feedback_binding.dart';
import 'package:messcoin/hmc/bindings/mess_ratings_binding.dart';
import 'package:messcoin/hmc/bindings/profile_binding.dart';
import 'package:messcoin/hmc/bindings/student_search_binding.dart';
import 'package:messcoin/hmc/views/bill_export_view.dart';
import 'package:messcoin/hmc/views/hmc_dashboard_view.dart';
import 'package:messcoin/hmc/views/live_feedback_view.dart';
import 'package:messcoin/hmc/views/mess_ratings_view.dart';
import 'package:messcoin/hmc/views/student_search_view.dart';
import '../../hmc/views/hmc_profile_view.dart';
import '../../hmc/views/mess_menu_view.dart';

class HmcRoutes {
  static const String dashboard = '/hmc/dashboard';
  static const String profile = '/hmc/profile';
  static const String feedbackView = '/hmc/feedback';
  static const String bill = '/hmc/bill';
  static const String studentSearch = '/hmc/student/search';
  static const String messRatings = '/hmc/mess/ratings';
  static const String messMenu = '/hmc/mess/menu';

  static String getDashboard() => dashboard;
  static String getProfile() => profile;
  static String getFeedbackView() => feedbackView;
  static String getBill() => bill;
  static String getStudentSearch() => studentSearch;
  static String getMessRatings() => messRatings;
  static String getMessMenu() => messMenu;

  static List<GetPage> routes = [
    GetPage(name: dashboard, page: () => HmcDashboardView(), binding: HmcDashboardBinding()),
    GetPage(name: profile, page: () => HmcProfileView(), binding: ProfileBinding()),
    GetPage(name: feedbackView, page: () => LiveFeedbackView(), binding: LiveFeedbackBinding()),
    GetPage(name: bill, page: () => BillExportView(), binding: BillVerificationBinding()),
    GetPage(name: studentSearch, page: () => StudentSearchView(), binding: StudentSearchBinding()),
    GetPage(name: messRatings, page: () => MessRatingsView(), binding: MessRatingsBinding()),
    GetPage(name: messMenu, page: () => MessMenuView(), binding: MessMenuBinding()),
  ];
}
