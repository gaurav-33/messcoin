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


// The new BillModel class
class BillModel {
  final String id;
  final String student; // Always holds the student's ID
  final Student? studentData; // Holds the populated student object, can be null
  final String mess; // Always holds the mess ID
  final int month;
  final int year;
  final int totalDays;
  final int leaveDays;
  final int attendedDays;
  final double perDayMealPrice;
  final double mealCost;
  final double couponAmount;
  final double finalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  BillModel({
    required this.id,
    required this.student,
    this.studentData,
    required this.mess,
    required this.month,
    required this.year,
    required this.totalDays,
    required this.leaveDays,
    required this.attendedDays,
    required this.perDayMealPrice,
    required this.mealCost,
    required this.couponAmount,
    required this.finalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    // --- Flexible Student Handling ---
    final studentField = json['student'];
    String studentId = '';
    Student? populatedStudentData;

    if (studentField is String) {
      // Handles case where student is just an ID
      studentId = studentField;
    } else if (studentField is Map) {
      // Handles case where student is a populated object
      studentId = studentField['_id'] ?? '';
      populatedStudentData = Student.fromJson(Map<String, dynamic>.from(studentField));
    }
    // --- End of Flexible Student Handling ---

    return BillModel(
      id: json['_id'] ?? '',
      student: studentId,
      studentData: populatedStudentData,
      mess: json['mess'] is String ? json['mess'] : (json['mess']?['_id'] ?? ''),
      month: (json['month'] ?? 0).toInt(),
      year: (json['year'] ?? 0).toInt(),
      totalDays: (json['totalDays'] ?? 0).toInt(),
      leaveDays: (json['leaveDays'] ?? 0).toInt(),
      attendedDays: (json['attendedDays'] ?? 0).toInt(),
      perDayMealPrice: (json['perDayMealPrice'] ?? 0.0).toDouble(),
      mealCost: (json['mealCost'] ?? 0.0).toDouble(),
      couponAmount: (json['couponAmount'] ?? 0.0).toDouble(),
      finalAmount: (json['finalAmount'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    // This is useful for sending data TO the server
    return {
      '_id': id,
      'student': student, // Always send the ID
      'mess': mess,
      'month': month,
      'year': year,
      'totalDays': totalDays,
      'leaveDays': leaveDays,
      'attendedDays': attendedDays,
      'perDayMealPrice': perDayMealPrice,
      'mealCost': mealCost,
      'couponAmount': couponAmount,
      'finalAmount': finalAmount,
    };
  }
}
