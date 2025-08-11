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

class CouponModel {
  final String id;
  final String student; // always the id
  final StudentModel? studentData; // populated data, nullable
  final num amount;
  final String mess; // Mess id as String
  final String status;
  final String couponId;
  final String? approvedBy; // Admin id as String
  final DateTime createdAt;
  final DateTime updatedAt;

  CouponModel({
    required this.id,
    required this.student,
    this.studentData,
    required this.amount,
    required this.mess,
    required this.status,
    required this.couponId,
    this.approvedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
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
    return CouponModel(
      id: json['_id'] ?? '',
      student: studentId,
      studentData: studentData,
      amount: json['amount'] ?? 0,
      mess:
          json['mess'] is String ? json['mess'] : (json['mess']?['_id'] ?? ''),
      status: json['status'] ?? 'pending',
      couponId: json['coupon_id'] ?? '',
      approvedBy: json['approvedBy'] is String
          ? json['approvedBy']
          : (json['approvedBy']?['_id'] ?? null),
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
      'amount': amount,
      'mess': mess,
      'status': status,
      'coupon_id': couponId,
      'approvedBy': approvedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
