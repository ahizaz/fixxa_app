import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController createnewPassword = TextEditingController();
  final TextEditingController confirmnewPassword = TextEditingController();

  var createnewhasText = false.obs;
  var confirmnewhasText = false.obs; // Renamed for clarity

  var obsecurecreatenew = true.obs;
  var obsecureconfirmnew = true.obs;

  var isFormValid = false.obs;

  @override
  void onInit() {
    createnewPassword.addListener(() {
      createnewhasText.value = createnewPassword.text.isNotEmpty;
      _validateForm();
    });
    confirmnewPassword.addListener(() {
      confirmnewhasText.value = confirmnewPassword.text.isNotEmpty;
      _validateForm();
    });
    super.onInit();
  }

  void _validateForm() {
    isFormValid.value =
        createnewhasText.value &&
        confirmnewhasText.value &&
        createnewPassword.text == confirmnewPassword.text &&
        createnewPassword.text.isNotEmpty;
  }

  void togglecreatenewPassVisibility() {
    obsecurecreatenew.value = !obsecurecreatenew.value;
  }

  void toggleconfirmnewPassVisibility() {
    obsecureconfirmnew.value = !obsecureconfirmnew.value;
  }

  // Reset Password API Method
  Future<void> resetPassword() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Resetting password...');

      debugPrint('🔄 Resetting Password...');
      debugPrint('🔒 New Password: ${createnewPassword.text}');

      // Get access token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('reset_password_token');

      if (token == null) {
        debugPrint('❌ No access token found');
        EasyLoading.dismiss();
        EasyLoading.showError('Session expired. Please try again.');
        return;
      }

      debugPrint('🔑 Access Token: ${token.substring(0, 20)}...');

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "new_password": createnewPassword.text.trim(),
      };

      debugPrint('Request Body: ${jsonEncode(requestBody)}');

      // Make API call
      final response = await http.post(
        Uri.parse(Urls.resetpassword),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint(' Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Password reset successfully!');
        debugPrint('📄 Response Data: $responseData');

        EasyLoading.showSuccess('Password reset successfully!');
        return; // Success - will show dialog in UI
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint(' Error: $errorData');
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to reset password',
        );
        throw Exception('Failed to reset password');
      }
    } catch (e) {
      debugPrint('❌ Exception occurred: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Error: ${e.toString()}');
      rethrow;
    }
  }

  // Remove reset password token from SharedPreferences
  Future<void> removeResetPasswordToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('reset_password_token');
      debugPrint('🗑️ Reset password token removed from SharedPreferences');
    } catch (e) {
      debugPrint('❌ Error removing token: $e');
    }
  }

  @override
  void onClose() {
    createnewPassword.dispose();
    confirmnewPassword.dispose();
    super.onClose();
  }
}
