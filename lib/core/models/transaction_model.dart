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

class TransactionModel {
  final String id;
  final String student; // always the id
  final StudentModel? studentData; // populated data, nullable
  final String mess;
  final double amount;
  final String transactionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? item;
  final int quantity;
  final String status;
  final int counter;

  TransactionModel({
    required this.id,
    required this.student,
    this.studentData,
    required this.mess,
    required this.amount,
    required this.transactionId,
    required this.createdAt,
    required this.updatedAt,
    required this.item,
    required this.quantity,
    required this.status,
    required this.counter,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
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
    return TransactionModel(
      id: json['_id'] ?? '',
      student: studentId,
      studentData: studentData,
      mess:
          json['mess'] is String ? json['mess'] : (json['mess']?['_id'] ?? ''),
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] is double)
              ? json['amount']
              : double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      transactionId: json['transactionId'] ?? json['transaction_id'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      item: json['item'] ?? 'others',
      quantity: json['quantity'] ?? 1,
      status: json['status'] ?? 'pending',
      counter: (json['counter'] is int)
          ? json['counter']
          : int.tryParse(json['counter']?.toString() ?? '1') ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'student': student,
      'mess': mess,
      'amount': amount,
      'transaction_id': transactionId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'item': item,
      'quantity': quantity,
      'status': status,
      'counter': counter
    };
  }
}
