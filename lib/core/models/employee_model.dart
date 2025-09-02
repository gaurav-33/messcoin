import 'package:messcoin/core/models/mess_model.dart';

class EmployeeModel {
  final String id;
  final String fullName;
  final String phone;
  final String mess;
  final MessModel? messData;
  final String role;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  EmployeeModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.mess,
    this.messData,
    required this.role,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
        id: json['_id'],
        fullName: json['fullName'],
        phone: json['phone'],
        mess: json['mess'] is String
            ? json['mess']
            : (json['mess']?['_id'] ?? ''),
        messData: json['mess'] is Map<String, dynamic>
            ? MessModel.fromJson(json['mess'])
            : null,
        role: json['role'],
        createdBy: json['createdBy'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']));
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'phone': phone,
      'mess': mess,
      'messData': messData?.toJson(),
      'role': role,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String()
    };
  }
}
