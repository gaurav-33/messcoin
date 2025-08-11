import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/input_field.dart';
import '../../core/widgets/neu_button.dart';
import '../../core/widgets/neu_container.dart';
import '../../core/widgets/app_bar.dart';
import '../../core/widgets/neu_loader.dart';
import '../../utils/responsive.dart';
import '../controllers/register_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.put(RegisterController());

    // Use MediaQuery for screen-relative sizing
    final double screenHeight = MediaQuery.of(context).size.height;
    // final double screenWidth = MediaQuery.of(context).size.width;

    // Use the Responsive class for consistent content width
    final double containerWidth = Responsive.contentWidth(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // Ensure the content can be centered vertically on larger screens
          constraints: BoxConstraints(minHeight: screenHeight),
          padding: EdgeInsets.symmetric(
              horizontal: Responsive.contentPadding(context)),
          child: Center(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NeuAppBar(),
                  SizedBox(height: screenHeight * 0.03),

                  // The main container for the registration form
                  NeuContainer(
                    width: containerWidth,
                    // The height is now determined by the content, which is better
                    // for a long form that needs to scroll.
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Register",
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 20),

                          // Profile picture and image pickers
                          _buildProfileImagePicker(
                              context, controller, containerWidth),
                          const SizedBox(height: 10),

                          // Form fields
                          InputField(
                            width: containerWidth * 0.9,
                            label: 'Name',
                            hintText: 'Enter Name',
                            controller: controller.nameController,
                          ),
                          InputField(
                            width: containerWidth * 0.9,
                            label: 'Roll No',
                            hintText: 'Enter Roll No',
                            controller: controller.rollNoController,
                            keyboardType: TextInputType.number,
                          ),
                          InputField(
                            width: containerWidth * 0.9,
                            label: 'Email',
                            hintText: 'Enter Email',
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          InputField(
                            width: containerWidth * 0.9,
                            label: 'Password',
                            hintText: 'Enter Password',
                            obscure: true,
                            controller: controller.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                          ),
                          InputField(
                            width: containerWidth * 0.9,
                            label: 'Room No',
                            hintText: 'Enter Room No',
                            controller: controller.roomNoController,
                          ),
                          InputField(
                            width: containerWidth * 0.9,
                            label: 'Semester',
                            hintText: '1, 2, 3, 4...',
                            controller: controller.semesterController,
                            keyboardType: TextInputType.number,
                          ),
                          _buildHostelDropdown(
                              context, controller, containerWidth),
                          _buildMessDropdown(
                              context, controller, containerWidth),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Register Button
                  Obx(() {
                    return NeuButton(
                      width: containerWidth * 0.5,
                      height: 50,
                      onTap: () {
                        controller.registerStudent();
                      },
                      child: controller.isLoading.value
                          ? const NeuLoader()
                          : const Text(
                              "Register",
                              style: TextStyle(fontSize: 18),
                            ),
                    );
                  }),

                  SizedBox(height: screenHeight * 0.03),

                  // Login Button
                  NeuButton(
                    width: containerWidth * 0.4,
                    height: 45,
                    onTap: () {
                      Get.offAllNamed(AppRoutes.getLogin());
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Extracted widget for profile image section for better readability
  Widget _buildProfileImagePicker(BuildContext context,
      RegisterController controller, double containerWidth) {
    return Obx(() => Column(
          children: [
            NeuContainer(
              shape: BoxShape.circle,
              padding: const EdgeInsets.all(5),
              child: CircleAvatar(
                radius: containerWidth * 0.15, // Responsive radius
                backgroundColor: AppColors.bgColor,
                backgroundImage: controller.pickedImage.value != null
                    ? FileImage(controller.pickedImage.value!)
                    : const AssetImage('assets/images/profile.png')
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                NeuButton(
                    shape: BoxShape.circle,
                    height: 50,
                    width: 50,
                    onTap: () async {
                      await controller.pickImageFromCamera();
                    },
                    child: Image.asset(
                      'assets/images/camera.png',
                      color: AppColors.lightDark,
                      height: 25, // Using fixed size for icon clarity
                    )),
                const SizedBox(width: 25),
                NeuButton(
                    shape: BoxShape.circle,
                    height: 50,
                    width: 50,
                    onTap: () async {
                      await controller.pickImageFromGallery();
                    },
                    child: Image.asset(
                      'assets/images/gallery.png',
                      color: AppColors.lightDark,
                      height: 25, // Using fixed size for icon clarity
                    )),
              ],
            ),
          ],
        ));
  }

  // Hostel Dropdown Input Field
  Widget _buildHostelDropdown(BuildContext context,
      RegisterController controller, double containerWidth) {
    return Obx(() => InputField(
          width: containerWidth * 0.9,
          label: 'Hostel',
          hintText: 'Choose Hostel',
          readOnly: true,
          controller: TextEditingController(
              text: controller.selectedHostel.value.toUpperCase()),
          onTap: () {
            Get.bottomSheet(
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: controller.hostels.map((hostel) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NeuButton(
                        child: Text(hostel.toUpperCase()),
                        onTap: () {
                          controller.selectHostel(hostel);
                          Get.back();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ));
  }

  // Mess Dropdown Input Field
  Widget _buildMessDropdown(BuildContext context, RegisterController controller,
      double containerWidth) {
    return Obx(() => InputField(
          width: containerWidth * 0.9,
          label: 'Mess',
          hintText: 'Choose Mess',
          readOnly: true,
          controller: TextEditingController(
            text: controller.selectedMessId.value.isEmpty
                ? ''
                : (controller.messList
                        .firstWhereOrNull(
                            (m) => m.id == controller.selectedMessId.value)
                        ?.name
                        .toUpperCase() ??
                    ''),
          ),
          onTap: controller.selectedHostel.value.isEmpty
              ? null
              : () {
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.bgColor,
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: controller.filteredMesses.map((mess) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: NeuButton(
                              child: Text(mess.name.toUpperCase()),
                              onTap: () {
                                controller.selectMess(mess.id);
                                Get.back();
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
        ));
  }
}
