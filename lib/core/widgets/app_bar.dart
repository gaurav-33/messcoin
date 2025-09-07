import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../core/widgets/neu_container.dart';

class NeuAppBar extends StatelessWidget {
  const NeuAppBar({super.key, this.toBack = false});
  final bool? toBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: NeuContainer(
        height: screenHeight < 500 ? 70 : screenHeight * 0.1,
        width: screenWidth * 0.92,
        child: Stack(
          children: [
            if (toBack ?? false)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: SvgPicture.asset('assets/svgs/back.svg', color: theme.iconTheme.color),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  highlightColor: theme.colorScheme.secondary.withOpacity(0.1),
                ),
              ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Mess Coin',
                style: theme.textTheme.headlineLarge,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                iconSize: 20,
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: theme.iconTheme.color,
                ),
                onPressed: () {
                  Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}