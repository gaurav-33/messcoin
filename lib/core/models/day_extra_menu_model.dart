class ExtraMeal {
  final String item;
  final int price;

  ExtraMeal({required this.item, required this.price});

  factory ExtraMeal.fromJson(Map<String, dynamic> json) {
    return ExtraMeal(
      item: json['item'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'price': price,
    };
  }
}

class DayExtraMenuModel {
  final String id;
  final String day;
  final String mess; // Mess id as String
  final List<ExtraMeal> breakfast;
  final List<ExtraMeal> lunch;
  final List<ExtraMeal> dinner;
  final DateTime createdAt;
  final DateTime updatedAt;

  DayExtraMenuModel({
    required this.id,
    required this.day,
    required this.mess,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DayExtraMenuModel.fromJson(Map<String, dynamic> json) {
    return DayExtraMenuModel(
      id: json['_id'] ?? '',
      day: json['day'] ?? '',
      mess: json['mess'] is String ? json['mess'] : (json['mess']?['_id'] ?? ''),
      breakfast: (json['breakfast'] as List<dynamic>? ?? []).map((e) => ExtraMeal.fromJson(e)).toList(),
      lunch: (json['lunch'] as List<dynamic>? ?? []).map((e) => ExtraMeal.fromJson(e)).toList(),
      dinner: (json['dinner'] as List<dynamic>? ?? []).map((e) => ExtraMeal.fromJson(e)).toList(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'day': day,
      'mess': mess,
      'breakfast': breakfast.map((e) => e.toJson()).toList(),
      'lunch': lunch.map((e) => e.toJson()).toList(),
      'dinner': dinner.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
