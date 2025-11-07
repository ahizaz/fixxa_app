import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fixxa_app/feature/account%20create&authentication/screen/verify_mail.dart';
import 'package:fixxa_app/feature/account%20create&authentication/screen/personalization_step1.dart';
import 'package:fixxa_app/feature/account%20create&authentication/screen/otp_verification.dart';
import 'package:fixxa_app/feature/account%20create&authentication/screen/resend_password_check_otp.dart';
import 'package:fixxa_app/feature/forgot_password/screen/reset_passwprd_default.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountController extends GetxController {
  final createaccountemailController = TextEditingController();
  var obsecureText = true.obs;
  final TextEditingController createPasswordController =
      TextEditingController();
  final TextEditingController referralCodeController =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();
  var hasText = false.obs;
  var hasReferralText = false.obs;

  bool get isFormValid => isCreateEmailhasText.value && hasText.value;

  final isCreateEmailFocused = false.obs; //

  final isCreateEmailhasText = false.obs;
  

  var userId = ''.obs;
  var accessToken = ''.obs;
  var refreshToken = ''.obs;

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

  // Clear all form fields
  void clearAllFields() {
    createaccountemailController.clear();
    createPasswordController.clear();
    referralCodeController.clear();
    otpController.clear();
    isCreateEmailhasText.value = false;
    hasText.value = false;
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
        
        // Clear password and referral code fields after successful signup
        createPasswordController.clear();
        referralCodeController.clear();
        hasText.value = false;
        hasReferralText.value = false;
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

  // OTP Verification Method
  Future<void> verifyOtp() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Verifying OTP...');
      
      debugPrint(' Starting OTP verification...');
      debugPrint('Email: ${createaccountemailController.text}');
      debugPrint('OTP Code: ${otpController.text}');

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "email": createaccountemailController.text.trim(),
        "otp_code": otpController.text.trim(),
      };

      debugPrint(' Request Body: ${jsonEncode(requestBody)}');

      // Make API call
      final response = await http.post(
        Uri.parse(Urls.verifyOtp),
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
        debugPrint('OTP verified successfully!');
        debugPrint(' Response Data: $responseData');
        
        // Store user data from response
        if (responseData['data'] != null) {
          userId.value = responseData['data']['user']['id'] ?? '';
          accessToken.value = responseData['data']['access'] ?? '';
          refreshToken.value = responseData['data']['refresh'] ?? '';
          
          debugPrint(' Stored User ID: ${userId.value}');
          debugPrint(' Stored Access Token: ${accessToken.value}');
        }
        
        EasyLoading.showSuccess('OTP verified successfully!');
        
        // Navigate to PersonalizationStep1
        Get.to(() => const PersonalizationStep1());
        
        // Clear all form fields after successful OTP verification
        clearAllFields();
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint(' Error: ${errorData}');
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to verify OTP',
        );
      }
    } catch (e) {
      debugPrint(' Exception occurred: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }

  // Resend OTP Method
  Future<void> resendOtp() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Resending OTP...');
      
      debugPrint('🔄 Resending OTP...');
      debugPrint('📧 Email: ${createaccountemailController.text}');

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "email": createaccountemailController.text.trim(),
      };

      debugPrint(' Request Body: ${jsonEncode(requestBody)}');

      // Make API call
      final response = await http.post(
        Uri.parse(Urls.resendOtp),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint(' Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('OTP resent successfully!');
        debugPrint(' Response Data: $responseData');
        
        EasyLoading.showSuccess('OTP resent successfully!');
        
        // Navigate to OTP Verification page
        Get.to(() => const OtpVerification());
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint(' Error: ${errorData}');
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to resend OTP',
        );
      }
    } catch (e) {
      debugPrint(' Exception occurred: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }

  // Forgot Password - Send OTP Method
  Future<void> forgotPassword() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Sending OTP...');
      
      debugPrint('🔄 Sending Forgot Password OTP...');
      debugPrint('📧 Email: ${createaccountemailController.text}');

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "email": createaccountemailController.text.trim(),
      };

      debugPrint('📦 Request Body: ${jsonEncode(requestBody)}');

      // Make API call
      final response = await http.post(
        Uri.parse(Urls.forgotpassword),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('📥 Response Status Code: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ Forgot Password OTP sent successfully!');
        debugPrint('📄 Response Data: $responseData');
        
        EasyLoading.showSuccess('OTP sent to your email!');
        
        // Navigate to password reset OTP verification page
        Get.to(() => const ResendPasswordCheckOtp());
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint('❌ Error: ${errorData}');
        
        // Handle specific email validation error
        String errorMessage = 'Failed to send OTP';
        if (errorData['data'] != null && errorData['data']['email'] != null) {
          errorMessage = errorData['data']['email'][0] ?? errorMessage;
        } else if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }
        
        EasyLoading.showError(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ Exception occurred: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }

  // Resend Password Reset OTP Method
  Future<void> resendPasswordOtp() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Sending Password Reset OTP...');
      
      debugPrint('🔄 Sending Password Reset OTP...');
      debugPrint('📧 Email: ${createaccountemailController.text}');

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "email": createaccountemailController.text.trim(),
      };

      debugPrint(' Request Body: ${jsonEncode(requestBody)}');

      // Make API call
      final response = await http.post(
        Uri.parse(Urls.resendOtp),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint(' Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('Password Reset OTP sent successfully!');
        debugPrint(' Response Data: $responseData');
        
        EasyLoading.showSuccess('Password Reset OTP sent successfully!');
        
        // You can navigate to password reset OTP verification page here
        // Get.to(() => const PasswordResetOtpVerification());
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint(' Error: ${errorData}');
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to send Password Reset OTP',
        );
      }
    } catch (e) {
      debugPrint(' Exception occurred: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }

  // Verify Password Reset OTP Method
  Future<void> verifyPasswordResetOtp(String otpCode) async {
    try {
      // Show loading
      EasyLoading.show(status: 'Verifying OTP...');
      
      debugPrint('🔄 Verifying Password Reset OTP...');
      debugPrint('📧 Email: ${createaccountemailController.text}');
      debugPrint('🔢 OTP Code: $otpCode');

      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "email": createaccountemailController.text.trim(),
        "otp_code": otpCode,
      };

      debugPrint('📦 Request Body: ${jsonEncode(requestBody)}');

      // Make API call
      final response = await http.post(
        Uri.parse(Urls.verifyOtp),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      debugPrint('📥 Response Status Code: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('✅ OTP verified successfully!');
        debugPrint('📄 Response Data: $responseData');
        
        // Save access token to SharedPreferences
        if (responseData['data'] != null && responseData['data']['access'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('reset_password_token', responseData['data']['access']);
          debugPrint('💾 Access token saved to SharedPreferences');
        }
        
        EasyLoading.showSuccess('OTP verified successfully!');
        
        // Navigate to Reset Password page
        Get.to(() => const ResetPasswordDefault());
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint('❌ Error: ${errorData}');
        
        String errorMessage = 'Invalid OTP';
        if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        } else if (errorData['data'] != null && errorData['data']['otp_code'] != null) {
          errorMessage = errorData['data']['otp_code'][0] ?? errorMessage;
        }
        
        EasyLoading.showError(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ Exception occurred: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    createaccountemailController.dispose();
    createPasswordController.dispose();
    referralCodeController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
