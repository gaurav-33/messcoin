import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../common/views/splash_view.dart';
import '../config/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/network/dio_client.dart';
import '../core/routes/app_routes.dart';
import '../core/storage/hive_manager.dart';
import '../core/storage/role_box_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? role;
  await Hive.initFlutter();
  await HiveManager.init(role ?? 'student');
  role = await RoleBoxManager.getRole();
  role ??= 'student';

  await dotenv.load(fileName: ".env");
  await DioClient().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mess Coin',
      theme: AppTheme.lightTheme,
      home: SplashView(),
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.getSplash(),
    );
  }
}
