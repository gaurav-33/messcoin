class WeeklySummaryModel {
  final String mess; // mess ObjectId as String
  final DateTime startOfWeek;
  final DateTime endOfWeek;
  final int transactionCount;
  final double transactionTotalAmount;
  final int couponCount;
  final double couponTotalAmount;
  final int feedbackCount;
  final double feedbackAvgRating;

  WeeklySummaryModel({
    required this.mess,
    required this.startOfWeek,
    required this.endOfWeek,
    required this.transactionCount,
    required this.transactionTotalAmount,
    required this.couponCount,
    required this.couponTotalAmount,
    required this.feedbackCount,
    required this.feedbackAvgRating,
  });

  factory WeeklySummaryModel.fromJson(Map<String, dynamic> json) =>
      WeeklySummaryModel(
        mess: json['mess'],
        startOfWeek: DateTime.parse(json['startOfWeek']),
        endOfWeek: DateTime.parse(json['endOfWeek']),
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
        'startOfWeek': startOfWeek.toIso8601String(),
        'endOfWeek': endOfWeek.toIso8601String(),
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
