import 'package:messcoin/core/models/mess_model.dart';

class WeeklyRatingModel {
  final MessModel mess;
  final DateTime startOfWeek;
  final DateTime endOfWeek;
  final int feedbackCount;
  final double feedbackAvgRating;
  final DateTime createdAt;
  final DateTime updatedAt;

  WeeklyRatingModel({
    required this.mess,
    required this.startOfWeek,
    required this.endOfWeek,
    required this.feedbackCount,
    required this.feedbackAvgRating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WeeklyRatingModel.fromJson(Map<String, dynamic> json) {
    final feedback = json['feedback'] as Map<String, dynamic>?;
    final avgRating = feedback?['avgRating'];
    return WeeklyRatingModel(
      mess: MessModel.fromJson(json['mess']),
      startOfWeek: DateTime.parse(json['startOfWeek']),
      endOfWeek: DateTime.parse(json['endOfWeek']),
      feedbackCount: feedback?['count'] as int? ?? 0,
      feedbackAvgRating:
          avgRating is int ? avgRating.toDouble() : avgRating as double? ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'mess': mess.toJson(),
        'startOfWeek': startOfWeek.toIso8601String(),
        'endOfWeek': endOfWeek.toIso8601String(),
        'feedback': {
          'count': feedbackCount,
          'avgRating': feedbackAvgRating,
        },
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  Map<String, num> toMap() {
    return {
      'feedbackCount': feedbackCount,
      'feedbackAvgRating': feedbackAvgRating
    };
  }
}
