import 'package:get/get.dart';
import '../../core/models/day_extra_menu_model.dart';
import '../../core/services/extra_menu_service.dart';
import '../../utils/app_snackbar.dart';

class ExtraMenuController extends GetxController {
  RxList<DayExtraMenuModel> weeklyMenu = <DayExtraMenuModel>[].obs;
  List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  int todayIndex = DateTime.now().weekday % 7;
  late final RxInt selectedDayIndex;

  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  @override
  void onInit() {
    selectedDayIndex = todayIndex.obs;
    fetchExtraMenu();
    super.onInit();
  }

  Future<void> fetchExtraMenu() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await ExtraMenuService().getAllExtraMenu();
      if (response.isSuccess) {
        final List<dynamic> dataList = response.data['data'] ?? [];
        weeklyMenu.value =
            dataList.map((e) => DayExtraMenuModel.fromJson(e)).toList();
      } else {
        error.value = response.message ?? 'Failed to load extra menu';
      }
    } catch (e) {
      error.value = 'Error: $e';
      AppSnackbar.error(e.toString(), title: 'Error while loading extra menu');
    } finally {
      isLoading.value = false;
    }
  }

  DayExtraMenuModel? getExtraMenuForDay(String day) {
    try {
      return weeklyMenu
          .firstWhereOrNull((menu) => menu.day == day.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  Future<void> addExtraMenuItem({
    required String day,
    required String meal,
    required String item,
    required int price,
  }) async {
    isLoading.value = true;
    try {
      final response = await ExtraMenuService().upsertExtraMenu({
        'day': day.toLowerCase(),
        'meal': meal.toLowerCase(),
        'item': item,
        'price': price,
      });
      if (response.isSuccess) {
        AppSnackbar.success('Item added successfully');
        await fetchExtraMenu();
      } else {
        AppSnackbar.error(response.message ?? 'Failed to add item');
      }
    } catch (e) {
      AppSnackbar.error(e.toString(), title: 'Error while adding item');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editExtraMenuItem({
    required String day,
    required String meal,
    required String oldItem,
    required String newItem,
    required int price,
  }) async {
    isLoading.value = true;
    try {
      final response = await ExtraMenuService().upsertExtraMenu({
        'day': day.toLowerCase(),
        'meal': meal.toLowerCase(),
        'oldItem': oldItem,
        'item': newItem,
        'price': price,
      });
      if (response.isSuccess) {
        AppSnackbar.success('Item updated successfully');
        await fetchExtraMenu();
      } else {
        AppSnackbar.error(response.message ?? 'Failed to update item');
      }
    } catch (e) {
      AppSnackbar.error(e.toString(), title: 'Error while updating item');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteExtraMenuItem({
    required String day,
    required String meal, 
    required String item,
  }) async {
    isLoading.value = true;
    try {
      final response = await ExtraMenuService().deleteExtraMenu({
        'day': day.toLowerCase(),
        'meal': meal.toLowerCase(),
        'item': item,
      });
      if (response.isSuccess) {
        AppSnackbar.success('Item deleted successfully');
        await fetchExtraMenu();
      } else {
        AppSnackbar.error(response.message ?? 'Failed to delete item');
      }
    } catch (e) {
      AppSnackbar.error(e.toString(), title: 'Error while deleting item');
    } finally {
      isLoading.value = false;
    }
  }
}
