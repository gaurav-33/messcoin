import 'package:get/get.dart';
import '../../core/models/day_menu_model.dart';
import '../../core/services/menu_service.dart';
import '../../utils/app_snackbar.dart';

class AdminMenuController extends GetxController {
  RxList<DayMenuModel> weeklyMenu = <DayMenuModel>[].obs;
  final List<String> days = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];
  final int todayIndex = DateTime.now().weekday % 7;
  late final RxInt selectedDayIndex;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  @override
  void onInit() {
    selectedDayIndex = todayIndex.obs;
    fetchMenu();
    super.onInit();
  }

  Future<void> fetchMenu() async {
    isLoading.value = true;
    error.value = '';
    final List<DayMenuModel> menuList = [];
    try {
      for (final day in days) {
        final response = await MenuService().getMessMenu(day.toLowerCase());
        if (response.isSuccess) {
          final menuData = response.data['data'];
          if (menuData != null) {
            menuList.add(DayMenuModel.fromJson(menuData));
          }
        } else {
          error.value = response.message ?? 'Failed to load menu for $day';
        }
      }
      weeklyMenu.value = menuList;
    } catch (e) {
      error.value = 'Error: $e';
      AppSnackbar.error(e.toString(), title: 'Error while loading menu');
    } finally {
      isLoading.value = false;
    }
  }

  DayMenuModel? getMenuForDay(String day) {
    try {
      return weeklyMenu.firstWhereOrNull(
          (menu) => menu.day.toLowerCase() == day.toLowerCase());
    } catch (_) {
      return null;
    }
  }
}