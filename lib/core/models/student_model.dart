import 'package:hive/hive.dart';

part 'student_model.g.dart';

@HiveType(typeId: 1)
class StudentModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String rollNo;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final int semester;
  @HiveField(5)
  final bool isVerified;
  @HiveField(6)
  final bool isActive;
  @HiveField(7)
  final Wallet wallet;
  @HiveField(8)
  final String roomNo;
  @HiveField(9)
  final DateTime createdAt;
  @HiveField(10)
  final DateTime updatedAt;
  @HiveField(11)
  final Mess mess;
  @HiveField(12)
  final String imageUrl;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.rollNo,
    required this.email,
    required this.semester,
    required this.isVerified,
    required this.isActive,
    required this.wallet,
    required this.roomNo,
    required this.createdAt,
    required this.updatedAt,
    required this.mess,
    required this.imageUrl,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
        id: json['_id'] ?? '',
        fullName: json['fullName'] ?? '',
        rollNo: json['rollNo'] ?? '',
        email: json['email'] ?? '',
        semester: json['semester'] ?? 1,
        isVerified: json['isVerified'] ?? false,
        isActive: json['isActive'] ?? false,
        wallet: Wallet.fromJson(json['wallet'] ?? {}),
        roomNo: json['roomNo'] ?? '',
        createdAt: DateTime.parse(
            json['createdAt'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json['updatedAt'] ?? DateTime.now().toIso8601String()),
        mess: Mess.fromJson(json['mess'] ?? {}),
        imageUrl: json['image_url'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'rollNo': rollNo,
      'email': email,
      'semester': semester,
      'isVerified': isVerified,
      'isActive': isActive,
      'wallet': wallet.toJson(),
      'roomNo': roomNo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'mess': mess.toJson(),
      'image_url': imageUrl
    };
  }
}

@HiveType(typeId: 2)
class Wallet {
  @HiveField(0)
  final num totalCredit;
  @HiveField(1)
  final num loadedCredit;
  @HiveField(2)
  final num balance;
  @HiveField(3)
  final num leftOverCredit;

  Wallet({
    required this.totalCredit,
    required this.loadedCredit,
    required this.balance,
    required this.leftOverCredit,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      totalCredit: json['totalCredit'] ?? 6000,
      loadedCredit: json['loadedCredit'] ?? 0,
      balance: json['balance'] ?? 0,
      leftOverCredit: json['leftOverCredit'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCredit': totalCredit,
      'loadedCredit': loadedCredit,
      'balance': balance,
      'leftOverCredit': leftOverCredit,
    };
  }
}

@HiveType(typeId: 3)
class Mess {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String hostel;
  @HiveField(2)
  final int? counters;

  Mess({
    required this.name,
    required this.hostel,
    this.counters = 1,
  });

  factory Mess.fromJson(Map<String, dynamic> json) {
    return Mess(
      name: json['name'] ?? '',
      hostel: json['hostel'] ?? '',
      counters: (json['counters'] ?? 1) is int
          ? json['counters']
          : int.parse(json['counters']?.toString() ?? '1'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hostel': hostel,
      'counters': counters,
    };
  }
}