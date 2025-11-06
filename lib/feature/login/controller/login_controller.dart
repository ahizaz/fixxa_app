import 'dart:convert';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final loginEmailCOntroller = TextEditingController();
  var obsecureText = true.obs;
  final TextEditingController loginPasswordController = TextEditingController();
  var hasText = false.obs;

  final isLoginEmailFocuesd = false.obs;
  final isLoginEmailhasText = false.obs;
  bool get isFormValid => isLoginEmailhasText.value && hasText.value;
  @override
  void onInit() {
    loginEmailCOntroller.addListener(() {
      isLoginEmailhasText.value = loginEmailCOntroller.text.isNotEmpty;
    });
    loginPasswordController.addListener(() {
      hasText.value = loginPasswordController.text.isNotEmpty;

      ///
    });
    super.onInit();
  }

  void togglePasswordVisibility() {
    obsecureText.value = !obsecureText.value;
  }

  void clearEmail() {
    loginEmailCOntroller.clear();
    isLoginEmailhasText.value = false;
  }

  // Clear all fields
  void clearAllFields() {
    loginEmailCOntroller.clear();
    loginPasswordController.clear();
    isLoginEmailhasText.value = false;
    hasText.value = false;
  }

  // Login method with POST request
  Future<bool> login() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Logging in...');

      // POST request to login API
      final response = await http.post(
        Uri.parse(Urls.login),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': loginEmailCOntroller.text.trim(),
          'password': loginPasswordController.text,
        }),
      );

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success - clear fields before navigation
        clearAllFields();
        
        // Show success message
        EasyLoading.showSuccess('Login successful!');
        return true;
      } else {
        // Show error message
        final errorData = jsonDecode(response.body);
        EasyLoading.showError(
          errorData['message'] ?? 'Login failed. Please try again.',
        );
        return false;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('An error occurred: $e');
      return false;
    }
  }

  @override
  void onClose() {
    loginEmailCOntroller.dispose();
    loginPasswordController.dispose();
    super.onClose();
  }
}
