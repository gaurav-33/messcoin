import 'package:get/get.dart';
import '../../core/models/day_extra_menu_model.dart';
import '../../core/models/day_menu_model.dart';
import '../../core/services/menu_service.dart';
import '../../core/services/extra_menu_service.dart';
import '../../utils/app_snackbar.dart';
import '../controllers/dashboard_controller.dart';

class MessMenuController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt selectedDayIndex = 0.obs;
  
  // Cache for menus. Key is lowercase day name.
  final RxMap<String, DayMenuModel> _regularMenuCache =
      <String, DayMenuModel>{}.obs;
  final RxMap<String, DayExtraMenuModel> _extraMenuCache =
      <String, DayExtraMenuModel>{}.obs;
  // Keep track of days for which a fetch has been attempted.
  final RxSet<String> _fetchedDays = <String>{}.obs;
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  String? get messName =>
      Get.find<DashboardController>().student.value?.mess.name;

  @override
  void onInit() {
    super.onInit();
    // Set the initial day to today.
    selectedDayIndex.value = DateTime.now().weekday - 1;
    fetchMenuForDay(days[selectedDayIndex.value]);
  }

  /// Fetches menu for a given day only if it hasn't been fetched before.
  Future<void> fetchMenuForDay(String dayName) async {
    final dayKey = dayName.toLowerCase();
    if (_fetchedDays.contains(dayKey)) {
      return;
    }

    isLoading.value = true;
    error.value = '';
    try {
      await Future.wait([
        _fetchRegularMenuForDay(dayName),
        _fetchExtraMenuForDay(dayName),
      ]);
    } catch (e) {
      error.value = 'Error: $e';
      AppSnackbar.error(e.toString());
    } finally {
      _fetchedDays.add(dayKey);
      isLoading.value = false;
    }
  }

  Future<void> _fetchRegularMenuForDay(String day) async {
    final dayKey = day.toLowerCase();
    final response = await MenuService().getMessMenu(dayKey);
    if (response.isSuccess) {
      final menuData = response.data['data'];
      if (menuData != null) {
        _regularMenuCache[dayKey] = DayMenuModel.fromJson(menuData);
      }
    } else {
      error.value = response.message ?? 'Failed to load menu for $day';
    }
  }

  Future<void> _fetchExtraMenuForDay(String day) async {
    final dayKey = day.toLowerCase();
    final response = await ExtraMenuService().getExtraMenu(dayKey);
    if (response.isSuccess) {
      final menuData = response.data['data'];
      if (menuData != null) {
        _extraMenuCache[dayKey] = DayExtraMenuModel.fromJson(menuData);
      }
    } else {
      error.value = response.message ?? 'Failed to load extra menu for $day';
    }
  }

  // Helper to get the regular menu for the selected day from the cache.
  DayMenuModel? getMenuForDay(String dayName) {
    return _regularMenuCache[dayName.toLowerCase()];
  }

  // Helper to get the extra menu for the selected day from the cache.
  DayExtraMenuModel? getExtraMenuForDay(String dayName) {
    return _extraMenuCache[dayName.toLowerCase()];
  }
}
