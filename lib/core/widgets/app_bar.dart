import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messcoin/config/app_colors.dart';
import '../../core/widgets/neu_container.dart';

class NeuAppBar extends StatelessWidget {
  const NeuAppBar({super.key, this.toBack = false});
  final bool? toBack;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: NeuContainer(
        height: screenHeight < 500 ? 70 : screenHeight * 0.1,
        width: screenWidth * 0.92,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            if (toBack != null && toBack == true)
              IconButton(
                icon:  SvgPicture.asset('assets/svgs/back.svg', color: AppColors.lightDark,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                highlightColor: AppColors.primaryColor.withOpacity(0.1),

              ),

            // Spacer to push text to center
            Expanded(
              child: Center(
                child: Text(
                  'Mess Coin',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),

            if (toBack != null && toBack == true)
              // Placeholder to balance the back button
              const SizedBox(width: 48), // same width as IconButton
          ],
        ),
      ),
    );
  }
}
