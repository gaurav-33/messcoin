class FeedbackModel {
  final String id;
  final String student; // Student id as String
  final String mess; // Mess id as String
  final String feedback;
  final int rating;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeedbackModel({
    required this.id,
    required this.student,
    required this.mess,
    required this.feedback,
    required this.rating,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['_id'] ?? '',
      student: json['student'] is String
          ? json['student']
          : (json['student']?['_id'] ?? ''),
      mess:
          json['mess'] is String ? json['mess'] : (json['mess']?['_id'] ?? ''),
      feedback: json['feedback'] ?? '',
      rating: json['rating'] ?? 1,
      imageUrl: json['image_url'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'student': student,
      'mess': mess,
      'feedback': feedback,
      'rating': rating,
      'image_url': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
