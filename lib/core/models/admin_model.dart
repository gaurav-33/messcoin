import 'package:hive/hive.dart';
part 'admin_model.g.dart';

@HiveType(typeId: 7)
class AdminModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final Mess? mess;
  @HiveField(4)
  final String role;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime updatedAt;
  @HiveField(7)
  final String? imageUrl;



  AdminModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.mess,
    this.imageUrl,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mess: Mess.fromJson(json['mess'] ?? {}),
      role: json['role'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'mess': mess?.toJson(),
      'role': role,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}


class Mess {
  final String name;
  final String hostel;

  Mess({
    required this.name,
    required this.hostel,
  });

  factory Mess.fromJson(Map<String, dynamic> json) {
    return Mess(
      name: json['name'] ?? '',
      hostel: json['hostel'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hostel': hostel,
    };
  }
}
