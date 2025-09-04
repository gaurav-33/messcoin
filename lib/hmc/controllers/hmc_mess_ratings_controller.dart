import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messcoin/core/models/weekly_rating_model.dart';
import '../../core/services/dashboard_service.dart';

class MessRatingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  RxMap<String, List<WeeklyRatingModel>> weeklyRatingsByWeek =
      <String, List<WeeklyRatingModel>>{}.obs;

  @override
  void onInit() {
    fetchWeeklyRatings();
    super.onInit();
  }

  Future<void> fetchWeeklyRatings() async {
    isLoading.value = true;
    error.value = '';
    try {
      final now = DateTime.now();
      weeklyRatingsByWeek.clear();

      final futures = <Future>[];
      for (int i = 0; i <= 5; i++) {
        final date = now.subtract(Duration(days: 7 * i));
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        futures.add(DashboardService().getWeeklyRating(dateStr));
      }

      final results = await Future.wait(futures);

      for (final res in results) {
        if (res.isSuccess) {
          final ratings = (res.data['data'] as List)
              .map((e) => WeeklyRatingModel.fromJson(e))
              .toList();
          if (ratings.isNotEmpty) {
            final dateStr = DateFormat('yyyy-MM-dd')
                .format(ratings.first.startOfWeek.toLocal());
            weeklyRatingsByWeek[dateStr] = ratings;
          }
        }
      }
    } catch (e) {
      error.value = e.toString();
      print(error.value);
    } finally {
      isLoading.value = false;
    }
  }
}
