import 'package:hive/hive.dart';
import '../../core/models/auth_token.dart';
import '../../core/storage/hive_boxes.dart';

class AuthBoxManager {
 
  static Future<void> saveToken(String token) async {
    if (!Hive.isBoxOpen(HiveBoxes.authBox)) {
      await Hive.openBox<AuthToken>(HiveBoxes.authBox);
    }
    final box = Hive.box<AuthToken>(HiveBoxes.authBox);
    final authToken = AuthToken(accessToken: token);
    await box.put('accessToken', authToken);
  }

  static Future<String?> getToken() async {
    if (!Hive.isBoxOpen(HiveBoxes.authBox)) {
      await Hive.openBox<AuthToken>(HiveBoxes.authBox);
    }
    final box = Hive.box<AuthToken>(HiveBoxes.authBox);
    final authToken = box.get('accessToken');
    if (authToken == null) return null;
    return authToken.accessToken;
  }

  static Future<void> clearToken() async {
    if (!Hive.isBoxOpen(HiveBoxes.authBox)) {
      await Hive.openBox<AuthToken>(HiveBoxes.authBox);
    }
    final box = Hive.box<AuthToken>(HiveBoxes.authBox);
    await box.delete('accessToken');
  }
}
