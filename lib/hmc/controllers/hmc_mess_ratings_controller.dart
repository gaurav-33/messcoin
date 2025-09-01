import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messcoin/core/models/weekly_rating_model.dart';
import '../../core/services/dashboard_service.dart';

class MessRatingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  RxList<WeeklyRatingModel> currentWeekRatings = <WeeklyRatingModel>[].obs;
  RxList<WeeklyRatingModel> previousWeekRatings = <WeeklyRatingModel>[].obs;
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
      currentWeekRatings.clear();
      previousWeekRatings.clear();
      weeklyRatingsByWeek.clear();
      final currentWeekDateStr = DateFormat('yyyy-MM-dd').format(now);
      final currentWeekRes =
          await DashboardService().getWeeklyRating(currentWeekDateStr);
      if (currentWeekRes.isSuccess) {
        final ratings = (currentWeekRes.data['data'] as List)
            .map((e) => WeeklyRatingModel.fromJson(e))
            .toList();
        currentWeekRatings.addAll(ratings);
        weeklyRatingsByWeek[currentWeekDateStr] = ratings;
      }

      for (int i = 0; i <= 5; i++) {
        // Loop from 5 down to 0 to get 6 periods
        final date = now.subtract(Duration(days: 7 * i));
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        final res = await DashboardService().getWeeklyRating(dateStr);
        if (res.isSuccess) {
          final ratings = (res.data['data'] as List)
              .map((e) => WeeklyRatingModel.fromJson(e))
              .toList();
          previousWeekRatings.addAll(ratings);
          weeklyRatingsByWeek[dateStr] = ratings;
        }
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
