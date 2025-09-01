import 'package:messcoin/core/models/mess_model.dart';

class WeeklyRatingModel {
  final MessModel mess;
  final DateTime startOfWeek;
  final DateTime endOfWeek;
  final int feedbackCount;
  final double feedbackAvgRating;

  WeeklyRatingModel({
    required this.mess,
    required this.startOfWeek,
    required this.endOfWeek,
    required this.feedbackCount,
    required this.feedbackAvgRating,
  });

  factory WeeklyRatingModel.fromJson(Map<String, dynamic> json) =>
      WeeklyRatingModel(
        mess: MessModel.fromJson(json['mess']),
        startOfWeek: DateTime.parse(json['startOfWeek']),
        endOfWeek: DateTime.parse(json['endOfWeek']),
        feedbackCount: json['feedback']?['count'] ?? 0,
        feedbackAvgRating: (json['feedback']?['avgRating'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'mess': mess.toJson(),
        'startOfWeek': startOfWeek.toIso8601String(),
        'endOfWeek': endOfWeek.toIso8601String(),
        'feedback': {
          'count': feedbackCount,
          'avgRating': feedbackAvgRating,
        },
      };

  Map<String, num> toMap() {
    return {
      'feedbackCount': feedbackCount,
      'feedbackAvgRating': feedbackAvgRating
    };
  }
}
