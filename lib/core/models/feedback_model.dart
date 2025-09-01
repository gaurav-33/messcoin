import 'package:messcoin/core/models/mess_model.dart';

class FeedbackModel {
  final String id;
  final String student; // Student id as String
  final StudentModel? studentData; // populated data, nullable
  final String mess; // Mess id as String
  final MessModel? messData; // populated data, nullable
  final String feedback;
  final int rating;
  final String? imageUrl;
  final String? reply;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeedbackModel({
    required this.id,
    required this.student,
    this.studentData,
    required this.mess,
    this.messData,
    required this.feedback,
    required this.rating,
    this.imageUrl,
    this.reply,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    final studentField = json['student'];
    StudentModel? studentData;
    String studentId = '';
    if (studentField is String) {
      studentId = studentField;
    } else if (studentField is Map) {
      studentId = studentField['_id'] ?? '';
      studentData =
          StudentModel.fromJson(Map<String, dynamic>.from(studentField));
    }

    return FeedbackModel(
      id: json['_id'] ?? '',
      student: studentId,
      studentData: studentData,
      mess:
          json['mess'] is String ? json['mess'] : (json['mess']?['_id'] ?? ''),
      messData: json['mess'] is Map<String, dynamic>
          ? MessModel.fromJson(json['mess'])
          : null,
      feedback: json['feedback'] ?? '',
      rating: json['rating'] ?? 1,
      imageUrl: json['image_url'] ?? '',
      reply: json['reply'] ?? '',
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
      'messData': messData?.toJson(),
      'feedback': feedback,
      'rating': rating,
      'image_url': imageUrl,
      'reply': reply,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class StudentModel {
  final String id;
  final String fullName;
  final String email;
  final String rollNo;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.rollNo,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      rollNo: json['rollNo'] ?? '',
    );
  }
}
