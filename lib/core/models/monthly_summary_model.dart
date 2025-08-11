class MonthlySummaryModel {
  final String mess; // mess ObjectId as String
  final DateTime startOfMonth;
  final int transactionCount;
  final double transactionTotalAmount;
  final int couponCount;
  final double couponTotalAmount;
  final int feedbackCount;
  final double feedbackAvgRating;

  MonthlySummaryModel({
    required this.mess,
    required this.startOfMonth,
    required this.transactionCount,
    required this.transactionTotalAmount,
    required this.couponCount,
    required this.couponTotalAmount,
    required this.feedbackCount,
    required this.feedbackAvgRating,
  });

  factory MonthlySummaryModel.fromJson(Map<String, dynamic> json) =>
      MonthlySummaryModel(
        mess: json['mess'],
        startOfMonth: DateTime.parse(json['startOfMonth']),
        transactionCount: json['transaction']?['count'] ?? 0,
        transactionTotalAmount:
            (json['transaction']?['totalAmount'] ?? 0).toDouble(),
        couponCount: json['coupon']?['count'] ?? 0,
        couponTotalAmount: (json['coupon']?['totalAmount'] ?? 0).toDouble(),
        feedbackCount: json['feedback']?['count'] ?? 0,
        feedbackAvgRating: (json['feedback']?['avgRating'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'mess': mess,
        'startOfMonth': startOfMonth.toIso8601String(),
        'transaction': {
          'count': transactionCount,
          'totalAmount': transactionTotalAmount,
        },
        'coupon': {
          'count': couponCount,
          'totalAmount': couponTotalAmount,
        },
        'feedback': {
          'count': feedbackCount,
          'avgRating': feedbackAvgRating,
        },
      };

  Map<String, num> toMap() {
    return {
      'transactionCount': transactionCount,
      'transactionTotalAmount': transactionTotalAmount,
      'couponCount': couponCount,
      'couponTotalAmount': couponTotalAmount,
      'feedbackCount': feedbackCount,
      'feedbackAvgRating': feedbackAvgRating
    };
  }
}
