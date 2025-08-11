class Meal {
  final List<String> items;

  Meal({required this.items});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      items: (json['items'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items,
    };
  }
}

class DayMenuModel {
  final String day;
  final Meal? breakfast;
  final Meal? lunch;
  final Meal? snacks;
  final Meal? dinner;
  final DateTime createdAt;
  final DateTime updatedAt;

  DayMenuModel({
    required this.day,
    this.breakfast,
    this.lunch,
    this.snacks,
    this.dinner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DayMenuModel.fromJson(Map<String, dynamic> json) {
    return DayMenuModel(
      day: json['day'] ?? '',
      breakfast: json['breakfast'] != null ? Meal.fromJson(json['breakfast']) : null,
      lunch: json['lunch'] != null ? Meal.fromJson(json['lunch']) : null,
      snacks: json['snacks'] != null ? Meal.fromJson(json['snacks']) : null,
      dinner: json['dinner'] != null ? Meal.fromJson(json['dinner']) : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'breakfast': breakfast?.toJson(),
      'lunch': lunch?.toJson(),
      'snacks': snacks?.toJson(),
      'dinner': dinner?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
