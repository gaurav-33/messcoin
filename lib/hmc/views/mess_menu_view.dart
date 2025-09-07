import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/core/widgets/app_bar.dart';
import 'package:messcoin/hmc/controllers/hmc_mess_menu_controller.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/neu_loader.dart';
import '../../../../utils/responsive.dart';

class MessMenuView extends StatelessWidget {
  const MessMenuView({super.key});

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
    final HmcMessMenuController controller = Get.find<HmcMessMenuController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final dayName = controller.days[controller.selectedDayIndex.value];
          final menu = controller.getMenuForDay(dayName);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const NeuAppBar(
                    toBack: true,
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
                        invert: isSelected,
                        child: Text(
                          controller.days[index].substring(0, 3),
                          style: TextStyle(
                            color: isSelected ? theme.colorScheme.onSecondary : theme.colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: height * 0.03),
                  controller.isLoading.value
                      ? const NeuLoader()
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
                                        style: theme.textTheme.headlineMedium,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    buildMealSection(context, 'Breakfast',
                                        menu.breakfast?.items, containerWidth, theme),
                                    buildMealSection(context, 'Lunch',
                                        menu.lunch?.items, containerWidth, theme),
                                    buildMealSection(context, 'Snacks',
                                        menu.snacks?.items, containerWidth, theme),
                                    buildMealSection(context, 'Dinner',
                                        menu.dinner?.items, containerWidth, theme),
                                  ],
                                ),
                        ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildMealSection(
      BuildContext context, String meal, List<String>? items, double width, ThemeData theme) {
    if (items == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: NeuContainer(
          width: width * 0.75,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(meal, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        Icon(Icons.circle,
                            size: 8, color: theme.colorScheme.secondary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(item,
                              style: theme.textTheme.bodyMedium),
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