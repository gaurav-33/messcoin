import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messcoin/common/controllers/register_controller.dart';
import 'package:messcoin/core/routes/app_routes.dart';
import 'package:messcoin/core/widgets/app_bar.dart';
import 'package:messcoin/core/widgets/input_field.dart';
import 'package:messcoin/core/widgets/neu_button.dart';
import 'package:messcoin/core/widgets/neu_container.dart';
import 'package:messcoin/core/widgets/neu_loader.dart';
import 'package:messcoin/utils/responsive.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.put(RegisterController());
    final screenHeight = MediaQuery.of(context).size.height;
    final containerWidth = Responsive.contentWidth(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const NeuAppBar(),
                SizedBox(height: screenHeight * 0.05),
                NeuContainer(
                  width: containerWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "Register",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        _buildProfileImagePicker(
                            context, controller, containerWidth),
                        SizedBox(height: screenHeight * 0.02),
                        InputField(
                          label: 'Name',
                          hintText: 'Enter Name',
                          controller: controller.nameController,
                          width: Responsive.contentWidth(context),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        InputField(
                          label: 'Roll No',
                          hintText: 'Enter Roll No',
                          controller: controller.rollNoController,
                          keyboardType: TextInputType.number,
                          width: Responsive.contentWidth(context),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        InputField(
                          label: 'Email',
                          hintText: 'Enter Email',
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          width: Responsive.contentWidth(context),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        InputField(
                          label: 'Password',
                          hintText: 'Enter Password',
                          obscure: true,
                          controller: controller.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          width: Responsive.contentWidth(context),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        InputField(
                          label: 'Room No',
                          hintText: 'Enter Room No',
                          controller: controller.roomNoController,
                          width: Responsive.contentWidth(context),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        InputField(
                          label: 'Semester',
                          hintText: '1, 2, 3, 4...',
                          controller: controller.semesterController,
                          keyboardType: TextInputType.number,
                          width: Responsive.contentWidth(context),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        _buildHostelDropdown(
                            context, controller, containerWidth),
                        SizedBox(height: screenHeight * 0.02),
                        _buildMessDropdown(context, controller, containerWidth),
                        SizedBox(height: screenHeight * 0.03),
                        Obx(
                          () => NeuButton(
                            onTap: controller.registerStudent,
                            child: controller.isLoading.value
                                ? const NeuLoader(
                                    size: 40,
                                  )
                                : const Text(
                                    "Register",
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.getLogin());
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker(BuildContext context,
      RegisterController controller, double containerWidth) {
    return Column(
      children: [
        Obx(
          () => NeuContainer(
            shape: BoxShape.circle,
            padding: const EdgeInsets.all(5),
            child: CircleAvatar(
              radius: containerWidth * 0.1,
              backgroundColor: Theme.of(context).colorScheme.surface,
              backgroundImage: controller.pickedImage.value != null
                  ? FileImage(controller.pickedImage.value!)
                  : const AssetImage('assets/images/profile.png')
                      as ImageProvider,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeuButton(
              onTap: controller.pickImageFromCamera,
              width: 50,
              height: 50,
              shape: BoxShape.circle,
              child: const Icon(Icons.camera_alt),
            ),
            const SizedBox(width: 20),
            NeuButton(
              onTap: controller.pickImageFromGallery,
              width: 50,
              height: 50,
              shape: BoxShape.circle,
              child: const Icon(Icons.photo_library),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHostelDropdown(BuildContext context,
      RegisterController controller, double containerWidth) {
    return Obx(() => InputField(
          label: 'Hostel',
          hintText: 'Choose Hostel',
          readOnly: true,
          controller: TextEditingController(
              text: controller.selectedHostel.value.toUpperCase()),
          width: Responsive.contentWidth(context),
          onTap: () {
            Get.bottomSheet(
              Container(
                color: Theme.of(context).colorScheme.surface,
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

  Widget _buildMessDropdown(BuildContext context, RegisterController controller,
      double containerWidth) {
    return Obx(() => InputField(
          label: 'Mess',
          hintText: 'Choose Mess',
          readOnly: true,
          width: Responsive.contentWidth(context),
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
                      color: Theme.of(context).colorScheme.surface,
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
