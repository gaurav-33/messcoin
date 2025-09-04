class MessModel {
  final String id;
  final String name;
  final String email;
  final String hostel;
  final int counters;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessModel({
    required this.id,
    required this.name,
    required this.email,
    required this.hostel,
    required this.counters,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessModel.fromJson(Map<String, dynamic> json) {
    return MessModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      hostel: json['hostel'] ?? '',
      counters: json['counters'] as int? ?? 1,
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'hostel': hostel,
      'counters': counters,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

