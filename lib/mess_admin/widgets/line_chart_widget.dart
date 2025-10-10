import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../core/models/daily_summary_model.dart';
import '../../core/widgets/neu_container.dart';

class LineChartWidget extends StatelessWidget {
  final String title;
  final Color? color;
  final List<DailySummaryModel> data;
  final double Function(DailySummaryModel) valueSelector;

  const LineChartWidget({
    super.key,
    required this.title,
    required this.data,
    this.color,
    required this.valueSelector,
  });

  @override
  Widget build(BuildContext context) {
    // Pad data to always have 7 days (last 7 days excluding today)
    final now = DateTime.now();
    final Map<String, DailySummaryModel> byDate = {
      for (var d in data) d.date.toLocal().toIso8601String().substring(0, 10): d
    };
    List<DailySummaryModel> paddedData = [];
    for (int i = 7; i >= 1; i--) {
      final date =
          DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final key = date.toIso8601String().substring(0, 10);
      if (byDate.containsKey(key)) {
        paddedData.add(byDate[key]!);
      } else {
        paddedData.add(DailySummaryModel(
          mess: '',
          date: date,
          transactionCount: 0,
          transactionTotalAmount: 0,
          couponCount: 0,
          couponTotalAmount: 0,
          feedbackCount: 0,
          feedbackAvgRating: 0,
          mealWiseSummary: const [],
        ));
      }
    }
    if (paddedData.isEmpty) {
      return NeuContainer(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text('No data available',
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      );
    }
    final spots = List.generate(
      paddedData.length,
      (i) => FlSpot(i.toDouble(), valueSelector(paddedData[i])),
    );
    final bottomTitle = {
      for (int i = 0; i < paddedData.length; i++)
        i: "${paddedData[i].date.toLocal().day.toString().padLeft(2, '0')}/${paddedData[i].date.toLocal().month.toString().padLeft(2, '0')}"
    };

    return NeuContainer(
      padding: EdgeInsets.only(left: 16, right: 25, top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 16 / 6,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) =>
                        (color ?? AppColors.dark).withOpacity(0.85),
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          spot.y.toStringAsFixed(0),
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return bottomTitle[value.toInt()] != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  bottomTitle[value.toInt()]!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              )
                            : SizedBox();
                      },
                      showTitles: true,
                      interval: 1,
                      reservedSize: 50,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    color: color ?? AppColors.dark,
                    barWidth: 2.5,
                    belowBarData: BarAreaData(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          color != null
                              ? color!.withOpacity(0.7)
                              : AppColors.dark.withOpacity(0.7),
                          color != null
                              ? color!.withOpacity(0.05)
                              : AppColors.darkShadowColor
                        ],
                      ),
                      show: true,
                    ),
                    dotData: FlDotData(show: false),
                    spots: spots,
                  )
                ],
                minX: 0,
                maxX: (paddedData.length - 1).toDouble(),
                minY: 0,
                maxY: _getMaxY(spots),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 100;
    final max = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return (max * 1.2).ceilToDouble();
  }
}
