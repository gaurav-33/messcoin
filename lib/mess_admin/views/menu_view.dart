import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../mess_admin/controllers/menu_controller.dart';
import '../../../../utils/responsive.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double containerWidth = width;
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isTablet = Responsive.isTablet(context);
    if (isDesktop) {
      containerWidth = 800;
    } else if (isTablet) {
      containerWidth = 700;
    }
    final AdminMenuController controller = Get.find<AdminMenuController>();

    return Scaffold(
      body: Obx(() {
        final dayName = controller.days[controller.selectedDayIndex.value];
        final menu = controller.getMenuForDay(dayName);
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    if (!isDesktop)
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: NeuButton(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            width: 45,
                            child: Icon(
                              Icons.menu,
                              color: AppColors.dark,
                            )),
                      ),
                    if (!isDesktop)
                      SizedBox(
                        width: 16,
                      ),
                    Text('Daily Menu',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Wrap(
                  spacing: containerWidth * 0.03,
                  runSpacing: containerWidth * 0.03,
                  children: List.generate(controller.days.length, (index) {
                    final isSelected =
                        index == controller.selectedDayIndex.value;
                    return NeuButton(
                      width: containerWidth * 0.1,
                      height: containerWidth * 0.1,
                      shape: BoxShape.circle,
                      onTap: () {
                        controller.selectedDayIndex.value = index;
                      },
                      child: Text(
                        controller.days[index].substring(0, 3),
                        style: TextStyle(
                          color: isSelected ? AppColors.primaryColor : null,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: height * 0.03),
                controller.isLoading.value
                    ? NeuLoader()
                    : Container(
                        width: containerWidth,
                        padding: const EdgeInsets.all(16),
                        child: menu == null
                            ? Center(
                                child: Text('No menu available for $dayName'))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Mess Menu - $dayName',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  buildMealSection(context, 'Breakfast',
                                      menu.breakfast?.items, containerWidth),
                                  buildMealSection(context, 'Lunch',
                                      menu.lunch?.items, containerWidth),
                                  buildMealSection(context, 'Snacks',
                                      menu.snacks?.items, containerWidth),
                                  buildMealSection(context, 'Dinner',
                                      menu.dinner?.items, containerWidth),
                                ],
                              ),
                      ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildMealSection(
      BuildContext context, String meal, List<String>? items, double width) {
    if (items == null) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: NeuContainer(
          width: width * 0.75,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(meal, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        Icon(Icons.circle,
                            size: 8, color: AppColors.primaryColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(item,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
