import 'package:get/get.dart';
import 'package:messcoin/student/views/bill_view.dart';
import '../../student/views/coupon_buy_view.dart';
import '../../student/views/dashboard_view.dart';
import '../../student/views/history_view.dart';
import '../../student/views/id_card_view.dart';
import '../../student/views/leave_view.dart';
import '../../student/views/payment_view.dart';
import '../../student/views/profile_view.dart';
import '../../student/views/view_feedback_view.dart';
import '../../student/views/write_feedback_view.dart';

class StudentRoutes {
  static const String dashboard = '/student/dashboard';
  static const String profile = '/student/profile';
  static const String feedbackView = '/student/feedback/view';
  static const String feedbackWrite = '/student/feedback/write';
  static const String payment = '/student/payment';
  static const String coupon = '/student/coupon';
  static const String idCard = '/student/idcard';
  static const String history = '/student/history';
  static const String leave = '/student/leave';
  static const String bill = '/student/bill';

  static String getDashboard() => dashboard;
  static String getProfile() => profile;
  static String getFeedbackView() => feedbackView;
  static String getFeedbackWrite() => feedbackWrite;
  static String getPayment() => payment;
  static String getCoupon() => coupon;
  static String getIdCard() => idCard;
  static String getHistory() => history;
  static String getLeave() => leave;
  static String getBill() => bill;

  static List<GetPage> routes = [
    GetPage(name: dashboard, page: () => DashboradView()),
    GetPage(name: profile, page: () => ProfileView()),
    GetPage(name: feedbackView, page: () => ViewFeedbackView()),
    GetPage(name: feedbackWrite, page: () => WriteFeedbackView()),
    GetPage(name: payment, page: () => PaymentView()),
    GetPage(name: coupon, page: () => CouponBuyView()),
    GetPage(name: idCard, page: () => IdCardView()),
    GetPage(name: history, page: () => HistoryView()),
    GetPage(name: leave, page: () => LeaveView()),
    GetPage(name: bill, page: () => BillView()),
  ];
}
