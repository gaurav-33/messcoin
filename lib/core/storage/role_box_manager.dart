import 'package:hive/hive.dart';
import '../../core/storage/hive_boxes.dart';

class RoleBoxManager {
  static Future<String?> getRole() async {
    if (!Hive.isBoxOpen(HiveBoxes.roleBox)) {
      await Hive.openBox<String>(HiveBoxes.roleBox);
    }
    final box = Hive.box<String>(HiveBoxes.roleBox);
    final role = box.get('role');
    if (role == null) return null;
    return role;
  }

  static Future<void> saveRole(String role) async {
    if (!Hive.isBoxOpen(HiveBoxes.roleBox)) {
      await Hive.openBox<String>(HiveBoxes.roleBox);
    }
    final box = Hive.box<String>(HiveBoxes.roleBox);
    await box.put('role', role);
  }

  static Future<void> clearRole() async {
    if (!Hive.isBoxOpen(HiveBoxes.roleBox)) {
      await Hive.openBox<String>(HiveBoxes.roleBox);
    }
    final box = Hive.box<String>(HiveBoxes.roleBox);
    await box.delete('role');
  }
}
