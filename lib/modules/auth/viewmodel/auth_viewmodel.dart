import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AuthViewModel extends GetxController {
  // Login form controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Signup form controllers
  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();
  final signupFamilyCodeController = TextEditingController();

  // Forgot password controller
  final forgotPasswordEmailController = TextEditingController();

  // Photo picker
  final signupPhotoPath = ''.obs;
  File? signupPhotoFile;
  final ImagePicker _picker = ImagePicker();

  // Observable states
  final isLoading = false.obs;
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final rememberMe = false.obs;

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signupNameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    signupFamilyCodeController.dispose();
    forgotPasswordEmailController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  // Login method (UI only for now)
  Future<void> login() async {
    if (loginEmailController.text.isEmpty ||
        loginPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2)); // Simulate API call
    isLoading.value = false;

    Get.snackbar(
      'Success',
      'Login successful! (UI Only)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );

    // Navigate to main app
    Get.offAllNamed('/main');
  }

  // Signup method (UI only for now)
  Future<void> signup() async {
    if (signupNameController.text.isEmpty ||
        signupEmailController.text.isEmpty ||
        signupPasswordController.text.isEmpty ||
        signupConfirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    if (signupPasswordController.text != signupConfirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2)); // Simulate API call
    isLoading.value = false;

    Get.snackbar(
      'Success',
      'Account created successfully! (UI Only)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );

    // Navigate to main app
    Get.offAllNamed('/main');
  }

  // Forgot password method (UI only for now)
  Future<void> forgotPassword() async {
    if (forgotPasswordEmailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2)); // Simulate API call
    isLoading.value = false;

    Get.snackbar(
      'Success',
      'Password reset link sent! (UI Only)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );

    Get.back();
  }

  // Social login methods (UI only for now)
  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false;

    Get.snackbar(
      'Success',
      'Google login successful! (UI Only)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );

    Get.offAllNamed('/main');
  }

  Future<void> loginWithApple() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false;

    Get.snackbar(
      'Success',
      'Apple login successful! (UI Only)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
    );

    Get.offAllNamed('/main');
  }

  // Photo picker methods
  Future<void> pickPhotoFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo != null) {
        signupPhotoFile = File(photo.path);
        signupPhotoPath.value = photo.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> pickPhotoFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo != null) {
        signupPhotoFile = File(photo.path);
        signupPhotoPath.value = photo.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
}
