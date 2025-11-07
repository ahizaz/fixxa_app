import 'dart:convert';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
        // Parse response to get access token
        final responseData = jsonDecode(response.body);
        debugPrint('📥 Login Response: $responseData');
        
        // Try multiple possible token locations in response
        String? accessToken;
        
        if (responseData['data'] != null && responseData['data']['access'] != null) {
          // Structure: { data: { access: "token" } }
          accessToken = responseData['data']['access'];
        } else if (responseData['access_token'] != null) {
          // Structure: { access_token: "token" }
          accessToken = responseData['access_token'];
        } else if (responseData['token'] != null) {
          // Structure: { token: "token" }
          accessToken = responseData['token'];
        } else if (responseData['access'] != null) {
          // Structure: { access: "token" }
          accessToken = responseData['access'];
        }
        
        // Save access token in SharedPreferences
        if (accessToken != null && accessToken.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', accessToken);
          debugPrint(' Access token saved successfully');
          debugPrint(' Access Token: ${accessToken.substring(0, 20)}...');
        } else {
          debugPrint(' Warning: No access token found in response');
        }
        
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

  // Get access token from SharedPreferences
  static Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('access_token');
    } catch (e) {
      debugPrint('❌ Error getting access token: $e');
      return null;
    }
  }

  // Remove access token from SharedPreferences (for logout)
  static Future<void> removeAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      debugPrint('🗑️ Access token removed successfully');
    } catch (e) {
      debugPrint('❌ Error removing access token: $e');
    }
  }

  @override
  void onClose() {
    loginEmailCOntroller.dispose();
    loginPasswordController.dispose();
    super.onClose();
  }
}
