class Student {
  final String id;
  final String fullName;
  final String email;
  final String rollNo;

  Student({
    required this.id,
    required this.fullName,
    required this.email,
    required this.rollNo,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      rollNo: json['rollNo'] ?? '',
    );
  }
}

class LeaveModel {
  final String id;
  final String student; // always the id
  final Student? studentData; // populated data, nullable
  final String mess; // Mess id as String
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String? reason;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeaveModel({
    required this.id,
    required this.student,
    this.studentData,
    required this.mess,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.reason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    final studentField = json['student'];
    Student? studentData;
    String studentId = '';
    if (studentField is String) {
      studentId = studentField;
    } else if (studentField is Map) {
      studentId = studentField['_id'] ?? '';
      studentData =
          Student.fromJson(Map<String, dynamic>.from(studentField));
    }
    return LeaveModel(
      id: json['_id'] ?? '',
       student: studentId,
      studentData: studentData,
      mess:
          json['mess'] is String ? json['mess'] : (json['mess']?['_id'] ?? ''),
      startDate:
          DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate:
          DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? 'pending',
      reason: json['reason'] ?? 'others',
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
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'reason': reason,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
