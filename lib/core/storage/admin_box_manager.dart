import 'package:hive/hive.dart';
import '../../core/models/admin_model.dart';
import '../../core/storage/hive_boxes.dart';

class AdminBoxManager {
  

  static Future<void> saveAdmin(AdminModel admin) async {
    if (!Hive.isBoxOpen(HiveBoxes.adminBox)) {
      await Hive.openBox<AdminModel>(HiveBoxes.adminBox);
    }
    final box = Hive.box<AdminModel>(HiveBoxes.adminBox);
    await box.put('admin', admin);
  }

  static Future<AdminModel?> getAdmin() async {
    if (!Hive.isBoxOpen(HiveBoxes.adminBox)) {
      await Hive.openBox<AdminModel>(HiveBoxes.adminBox);
    }
    final box = Hive.box<AdminModel>(HiveBoxes.adminBox);
    return box.get('admin');
  }

  static Future<void> clearAdmin() async {
    if (!Hive.isBoxOpen(HiveBoxes.adminBox)) {
      await Hive.openBox<AdminModel>(HiveBoxes.adminBox);
    }
    final box = Hive.box<AdminModel>(HiveBoxes.adminBox);
    await box.delete('admin');
  }
}