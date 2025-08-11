import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../core/services/feedback_service.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/validators.dart';

class WriteFeedbackController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt rating = 0.obs;
  Rxn<File> pickedImage = Rxn<File>();
  final feedbackTextController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void onClose() {
    feedbackTextController.dispose();
    super.onClose();
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        pickedImage.value = File(image.path);
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        pickedImage.value = File(image.path);
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> submitFeedback() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final feedback = feedbackTextController.text.trim();
      final feedbackError = Validators.validateFeedback(feedback);
      if (feedbackError != null) {
        AppSnackbar.error(feedbackError);
        return;
      }

      final response = await FeedbackService().createFeedback(
        rating: rating.value,
        feedback: feedback,
        imageFile: pickedImage.value?.path,
      );
      if (response.isSuccess) {
        AppSnackbar.success('Feedback submitted successfully');
        rating.value = 0;
        feedbackTextController.clear();
        pickedImage.value = null;
      } else {
        AppSnackbar.error(response.message ?? 'Failed to submit feedback');
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
