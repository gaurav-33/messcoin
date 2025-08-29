import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/neu_container.dart';
import '../../student/controllers/id_card_controller.dart';
import '../../utils/extensions.dart';
import '../../../../utils/responsive.dart';
import '../../utils/show_image_dialog.dart';
// import '../../../../core/widgets/neu_button.dart';

class IdCardView extends StatelessWidget {
  const IdCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final IdCardController controller = Get.put(IdCardController());

    final isFlipped = false.obs;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const NeuAppBar(toBack: true),
                const SizedBox(height: 24),
                Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: isFlipped.value
                        ? _buildCardFront(context, controller)
                        : _buildCardFront(context, controller),
                  ),
                ),
                const SizedBox(height: 32),
                // Obx(
                //   () => NeuButton(
                //     width: 200,
                //     onTap: () => isFlipped.value = !isFlipped.value,
                //     child: Text(
                //       isFlipped.value ? 'Show Info' : 'Show QR Code',
                //       style: const TextStyle(fontSize: 16),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardFront(BuildContext context, IdCardController controller) {
    return NeuContainer(
      key: const ValueKey('cardFront'),
      width: Responsive.contentWidth(context),
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool useVerticalLayout = constraints.maxWidth < 350;

          return useVerticalLayout
              ? _buildVerticalLayout(context, controller)
              : _buildHorizontalLayout(context, controller);
        },
      ),
    );
  }

  // Widget _buildCardBack(BuildContext context, IdCardController controller) {
  //   final cardWidth = Responsive.contentWidth(context);
  //   return NeuContainer(
  //     key: const ValueKey('cardBack'),
  //     width: cardWidth,
  //     padding: const EdgeInsets.all(24),
  //     child: Column(
  //       children: [
  //         Text("Scan for Mess Entry",
  //             style: Theme.of(context).textTheme.headlineSmall),
  //         const SizedBox(height: 24),
  //         Container(
  //           padding: const EdgeInsets.all(16),
  //           child: Icon(
  //             Icons.qr_code_2_rounded,
  //             size: cardWidth * 0.5,
  //             color: AppColors.dark,
  //           ),
  //         ),
  //         const SizedBox(height: 24),
  //         Text(
  //           controller.studentModel?.rollNo ?? '-------',
  //           style: Theme.of(context)
  //               .textTheme
  //               .titleLarge
  //               ?.copyWith(letterSpacing: 2),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildHorizontalLayout(
      BuildContext context, IdCardController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () =>
                  showImageDialog(context, controller.studentModel!.imageUrl),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.bgColor,
                backgroundImage: controller.studentModel?.imageUrl != ''
                    ? NetworkImage(controller.studentModel!.imageUrl)
                    : AssetImage('assets/images/profile.png'),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildStudentInfo(context, controller),
            ),
          ],
        ),
        _buildFooter(context, controller),
      ],
    );
  }

  Widget _buildVerticalLayout(
      BuildContext context, IdCardController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () =>
              showImageDialog(context, controller.studentModel!.imageUrl),
          child: CircleAvatar(
            radius: 60,
            backgroundImage: controller.studentModel!.imageUrl != ''
                ? NetworkImage(controller.studentModel!.imageUrl)
                : AssetImage('assets/images/profile.png'),
          ),
        ),
        const SizedBox(height: 20),
        _buildStudentInfo(context, controller),
        _buildFooter(context, controller),
      ],
    );
  }

  Widget _buildStudentInfo(BuildContext context, IdCardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.studentModel?.fullName.toCamelCase() ?? 'Student Name',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Roll No: ${controller.studentModel?.rollNo ?? 'N/A'}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 4),
        Text(
          'Room No: ${controller.studentModel?.roomNo ?? 'N/A'}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, IdCardController controller) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Divider(thickness: 1.2, color: Colors.grey.shade400),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.restaurant_menu,
                color: AppColors.primaryColor, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                controller.studentModel?.mess.name.toCamelCase() ?? 'Mess Name',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              'MESS CARD',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
