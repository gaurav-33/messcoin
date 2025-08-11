class MessModel {
  final String id;
  final String name;
  final String email;
  final String hostel;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessModel({
    required this.id,
    required this.name,
    required this.email,
    required this.hostel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessModel.fromJson(Map<String, dynamic> json) {
    return MessModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      hostel: json['hostel'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'hostel': hostel,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
