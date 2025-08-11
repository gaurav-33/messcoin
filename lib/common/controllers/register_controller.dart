import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/student_service.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/validators.dart';
import '../../core/models/mess_model.dart';
import '../../core/network/api_response.dart';
import '../../core/services/mess_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final rollNoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final roomNoController = TextEditingController();
  final semesterController = TextEditingController();

  RxBool isLoading = false.obs;

  List<MessModel> messList = [];
  var selectedHostel = ''.obs;
  var selectedMessId = ''.obs;
  var pickedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    getAllMess();
  }

  @override
  void onClose() {
    nameController.dispose();
    rollNoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    roomNoController.dispose();
    semesterController.dispose();
    super.onClose();
  }

  List<String> get hostels => messList.map((m) => m.hostel).toSet().toList();

  List<MessModel> get filteredMesses =>
      messList.where((m) => m.hostel == selectedHostel.value).toList();

  void selectHostel(String hostel) {
    selectedHostel.value = hostel;
    selectedMessId.value = '';
  }

  void selectMess(String messId) {
    selectedMessId.value = messId;
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        final file = File(image.path);
        final bytes = await file.length();
        if (bytes > 10 * 1024 * 1024) {
          // 10MB
          AppSnackbar.error('Profile photo cannot exceed 10MB');
          return;
        }
        pickedImage.value = file;
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final file = File(image.path);
        final bytes = await file.length();
        if (bytes > 10 * 1024 * 1024) {
          // 10MB
          AppSnackbar.error('Profile photo cannot exceed 10MB');
          return;
        }
        pickedImage.value = file;
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  void registerStudent() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final name = nameController.text.trim();
      final rollNo = rollNoController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final roomNo = roomNoController.text.trim();
      final semester = semesterController.text.trim();
      final hostel = selectedHostel.value;
      final messId = selectedMessId.value;

      final nameError = Validators.validateName(name);
      final rollNoError = Validators.validateRollNo(rollNo);
      final emailError = Validators.validateEmail(email);
      final passwordError = Validators.validatePassword(password);
      final roomNoError = Validators.validateRoomNo(roomNo);
      final semesterError = Validators.validateSemester(semester);
      final hostelError = Validators.validateHostel(hostel);
      final messError = Validators.validateMess(messId);

      if (nameError != null) {
        AppSnackbar.error(nameError);
        return;
      }
      if (rollNoError != null) {
        AppSnackbar.error(rollNoError);
        return;
      }
      if (emailError != null) {
        AppSnackbar.error(emailError);
        return;
      }
      if (passwordError != null) {
        AppSnackbar.error(passwordError);
        return;
      }
      if (roomNoError != null) {
        AppSnackbar.error(roomNoError);
        return;
      }
      if (semesterError != null) {
        AppSnackbar.error(semesterError);
        return;
      }
      if (hostelError != null) {
        AppSnackbar.error(hostelError);
        return;
      }
      if (messError != null) {
        AppSnackbar.error(messError);
        return;
      }
      if (pickedImage.value == null) {
        AppSnackbar.error('Select Profile Photo');
        return;
      }

      final response = await StudentService().signup(
          name: name,
          email: email,
          password: password,
          roomNo: roomNo,
          rollNo: rollNo,
          semester: int.parse(semester),
          messId: messId,
          imageFile: pickedImage.value?.path);
      if (response.isSuccess) {
        Get.offAllNamed(AppRoutes.getOtp(), arguments: {
          'email': email,
        });
      } else {
        AppSnackbar.error(
            response.message ?? "Something went wrong during registration");
        return;
      }
      AppSnackbar.success('Registration successful!');
    } finally {
      isLoading.value = false;
      nameController.clear();
      rollNoController.clear();
      emailController.clear();
      passwordController.clear();
      roomNoController.clear();
      semesterController.clear();
      selectedHostel.value = '';
      selectedMessId.value = '';
    }
  }

  void getAllMess() async {
    ApiResponse response = await MessService().getAllMess();
    if (response.isSuccess) {
      messList = (response.data['data'] as List)
          .map((mess) => MessModel.fromJson(mess))
          .toList();
    } else {
      AppSnackbar.error(
          response.message ?? "Something went wrong while fetching mess data");
      print("Error fetching mess data: ${response.message}");
    }
  }
}
