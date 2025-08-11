
class MealSummaryModel {
  final String mealType; // 'breakfast', 'lunch', 'dinner'
  final int transactionCount;
  final double transactionTotalAmount;

  MealSummaryModel({
    required this.mealType,
    required this.transactionCount,
    required this.transactionTotalAmount,
  });

  factory MealSummaryModel.fromJson(Map<String, dynamic> json) =>
      MealSummaryModel(
        mealType: json['mealType'],
        transactionCount: json['transaction']?['count'] ?? 0,
        transactionTotalAmount:
            (json['transaction']?['totalAmount'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'mealType': mealType,
        'transaction': {
          'count': transactionCount,
          'totalAmount': transactionTotalAmount,
        },
      };
}

class DailySummaryModel {
  final String mess; // mess ObjectId as String
  final DateTime date;
  final int transactionCount;
  final double transactionTotalAmount;
  final int couponCount;
  final double couponTotalAmount;
  final int feedbackCount;
  final double feedbackAvgRating;
  final List<MealSummaryModel> mealWiseSummary;

  DailySummaryModel({
    required this.mess,
    required this.date,
    required this.transactionCount,
    required this.transactionTotalAmount,
    required this.couponCount,
    required this.couponTotalAmount,
    required this.feedbackCount,
    required this.feedbackAvgRating,
    required this.mealWiseSummary,
  });

  factory DailySummaryModel.fromJson(Map<String, dynamic> json) =>
      DailySummaryModel(
        mess: json['mess'],
        date: DateTime.parse(json['date']),
        transactionCount: json['transaction']?['count'] ?? 0,
        transactionTotalAmount:
            (json['transaction']?['totalAmount'] ?? 0).toDouble(),
        couponCount: json['coupon']?['count'] ?? 0,
        couponTotalAmount: (json['coupon']?['totalAmount'] ?? 0).toDouble(),
        feedbackCount: json['feedback']?['count'] ?? 0,
        feedbackAvgRating: (json['feedback']?['avgRating'] ?? 0).toDouble(),
        mealWiseSummary: (json['mealWiseSummary'] as List<dynamic>? ?? [])
            .map((e) => MealSummaryModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'mess': mess,
        'date': date.toIso8601String(),
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
        'mealWiseSummary': mealWiseSummary.map((e) => e.toJson()).toList(),
      };

  Map<String, num> toMap() {
    // Helper to safely find a meal or return a default empty model
    MealSummaryModel getMeal(String mealType) {
      return mealWiseSummary.firstWhere((meal) => meal.mealType == mealType,
          orElse: () => MealSummaryModel(
              mealType: mealType,
              transactionCount: 0,
              transactionTotalAmount: 0.0));
    }

    return {
      'transactionCount': transactionCount,
      'transactionTotalAmount': transactionTotalAmount,
      'couponCount': couponCount,
      'couponTotalAmount': couponTotalAmount,
      'feedbackCount': feedbackCount,
      'feedbackAvgRating': feedbackAvgRating,
      'breakfastCount': getMeal('breakfast').transactionCount,
      'breakfastTransaction': getMeal('breakfast').transactionTotalAmount,
      'lunchCount': getMeal('lunch').transactionCount,
      'lunchTransaction': getMeal('lunch').transactionTotalAmount,
      'dinnerCount': getMeal('dinner').transactionCount,
      'dinnerTransaction': getMeal('dinner').transactionTotalAmount,
    };
  }
}