import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fixxa_app/feature/account%20create&authentication/screen/verify_mail.dart';
import 'package:fixxa_app/core/urls/urls.dart';

class CreateAccountController extends GetxController {
  final createaccountemailController = TextEditingController();
  var obsecureText = true.obs;
  final TextEditingController createPasswordController =
      TextEditingController();
  final TextEditingController referralCodeController =
      TextEditingController();
  var hasText = false.obs;
  var hasReferralText = false.obs;

  bool get isFormValid => isCreateEmailhasText.value && hasText.value;

  final isCreateEmailFocused = false.obs; //

  final isCreateEmailhasText = false.obs;

  @override 
  void onInit() {
    super.onInit();
    createaccountemailController.addListener(() {
      isCreateEmailhasText.value = createaccountemailController.text.isNotEmpty;
    });
    createPasswordController.addListener(() {
      hasText.value = createPasswordController.text.isNotEmpty;
    });
    referralCodeController.addListener(() {
      hasReferralText.value = referralCodeController.text.isNotEmpty;
    });
  }

  void togglePasswordVisibility() {
    obsecureText.value = !obsecureText.value;
  }

  void clearEmail() {
    createaccountemailController.clear();
    isCreateEmailhasText.value = false;
  }

  void cleaPassword() {
    createPasswordController.clear();
  }

  void clearReferralCode() {
    referralCodeController.clear();
    hasReferralText.value = false;
  }

  // API Call Method
  Future<void> createAccount() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Creating account...');
      
      debugPrint(' Starting account creation...');
      debugPrint(' Email: ${createaccountemailController.text}');
      debugPrint(' Password: ${createPasswordController.text}');
      debugPrint(' Referral Code: ${referralCodeController.text}');

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "email": createaccountemailController.text.trim(),
        "password": createPasswordController.text,
        "referral_code": referralCodeController.text.trim(),
      };

      debugPrint('📦 Request Body: ${jsonEncode(requestBody)}');

      // Make API call
      final response = await http.post(
        Uri.parse(Urls.signup),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint(' Response Status Code: ${response.statusCode}');
      debugPrint(' Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint(' Account created successfully!');
        debugPrint(' Response Data: $responseData');
        
        EasyLoading.showSuccess('Account created successfully!');
        
        // Navigate to verify mail screen
        Get.to(() => const VerifyMail());
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint(' Error: ${errorData}');
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to create account',
        );
      }
    } catch (e) {
      debugPrint(' Exception occurred: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    createaccountemailController.dispose();
    createPasswordController.dispose();
    referralCodeController.dispose();
    super.onClose();
  }
}
