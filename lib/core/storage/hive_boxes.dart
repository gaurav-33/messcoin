import 'package:hive/hive.dart';
import '../../core/models/auth_token.dart';

class HiveBoxes {
  static const String roleBox = 'roleBox';
  static const String authBox = 'authBox';
  static const String studentBox = 'studentBox';
  static const String adminBox = 'adminBox';

  static Box<AuthToken> getAuthBox() => Hive.box<AuthToken>(authBox);
}