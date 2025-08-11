import 'package:hive_flutter/adapters.dart';
import '../../core/models/auth_token.dart';
import '../../core/models/student_model.dart';
import '../../core/storage/hive_adapters.dart';
import '../../core/storage/hive_boxes.dart';

class HiveManager {
  static Future<void> init(String role) async {
    registerCommonAdapters();
    if (!Hive.isBoxOpen(HiveBoxes.roleBox)) {
      await Hive.openBox<String>(HiveBoxes.roleBox);
    }
    if (!Hive.isBoxOpen(HiveBoxes.authBox)) {
      await Hive.openBox<AuthToken>(HiveBoxes.authBox);
    }

    if (role == 'super_admin' ||
        role == 'mess_admin' ||
        role == 'hmc' ||
        role == 'employee') {
      registerAdminAdapters();
    }
    if (role == 'student') {
      registerStdudentAdapters();
      await Hive.openBox<StudentModel>(HiveBoxes.studentBox);
    }
  }
}
