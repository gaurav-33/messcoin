import 'package:hive/hive.dart';
import '../../core/models/auth_token.dart';
import '../../core/models/student_model.dart';

void registerCommonAdapters() {
  
  Hive.registerAdapter(AuthTokenAdapter());
}

void registerStdudentAdapters() {
  Hive.registerAdapter(StudentModelAdapter());
  Hive.registerAdapter(WalletAdapter());
  Hive.registerAdapter(MessAdapter());
}

void registerAdminAdapters() {}
