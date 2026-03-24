import 'package:fixxa_app/core/services/revenue_cat_service.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/feature/profile/widget/subscription_progress.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();

  // --- State Management for API Data ---
  var isLoading = true.obs;
  var subscriptionProgress = Rx<SubscriptionProgress?>(null);
  
  // --- User Profile Data ---
  var businessName = ''.obs;
  var userEmail = ''.obs;
  var isProfileLoading = true.obs;

  // --- Subscription Status ---
  var isSubscribed = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch data when the controller is first created
    fetchSubscriptionData();
    fetchUserProfile();
    _checkSubscription();
  }

  Future<void> _checkSubscription() async {
    isSubscribed.value = await RevenueCatService.isSubscribed();
  }

  /// Call this after a successful purchase to refresh status
  Future<void> refreshSubscription() async {
    await _checkSubscription();
  }


  Future<void> fetchSubscriptionData() async {
    try {
      isLoading(true);

      // Build the yearly financial statistics URL (current year)
      final year = DateTime.now().year;
      final url = Urls.financialStatisticsYearly(year);

      // Get access token (same helper used for profile calls)
      final token = await LoginController.getAccessToken();
      if (token == null) {
        debugPrint('❌ No access token found for financial statistics');
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('📥 Financial stats status: ${response.statusCode}');
      debugPrint('📥 Financial stats body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final data = body['data'] as Map<String, dynamic>?;

        if (data != null) {
          final totalAmount = (data['total_amount'] ?? 0).toDouble();
          final paidAmount = (data['paid_amount'] ?? 0).toDouble();

          // Compute progress as paid / total (guard divide by zero)
          final progressValue = (totalAmount > 0) ? (paidAmount / totalAmount) : 0.0;

          // Helper to format currency like "£8,360"
          String formatCurrency(double value) {
            final intValue = value.round();
            final s = intValue.toString();
            final reg = RegExp(r"\B(?=(\d{3})+(?!\d))");
            return '£' + s.replaceAllMapped(reg, (m) => ',');
          }

          final earnedDisplay = formatCurrency(paidAmount);
          final amountLeft = (totalAmount - paidAmount).clamp(0, double.infinity);
          final amountLeftDisplay = formatCurrency(amountLeft.toDouble());

          subscriptionProgress.value = SubscriptionProgress(
            earnedAmountDisplay: earnedDisplay,
            amountLeftDisplay: amountLeftDisplay,
            progressValue: progressValue.clamp(0.0, 1.0),
          );
        } else {
          debugPrint('⚠️ financial statistics returned no data');
        }
      } else {
        debugPrint('❌ Failed to fetch financial statistics: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching financial statistics: $e');
    } finally {
      // Make sure loading is set to false after the operation.
      isLoading(false);
    }
  }


  Future<void> fetchUserProfile() async {
    try {
      isProfileLoading(true);
      
      // Get access token
      final token = await LoginController.getAccessToken();
      if (token == null) {
        debugPrint('❌ No access token found');
        // Try to load from SharedPreferences as fallback
        await _loadFromLocalStorage();
        return;
      }
      
      // Make API call to get user profile
      final response = await http.get(
        Uri.parse(Urls.busineesProfile),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      debugPrint('📥 Profile Response Status: ${response.statusCode}');
      debugPrint('📥 Profile Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        

        if (responseData['data'] != null) {
          businessName.value = responseData['data']['business_name'] ?? '';
          userEmail.value = responseData['data']['email'] ?? '';
        } else if (responseData['business_name'] != null) {
          businessName.value = responseData['business_name'] ?? '';
          userEmail.value = responseData['email'] ?? '';
        }
        
        debugPrint('✅ Business Name: ${businessName.value}');
        debugPrint('✅ User Email: ${userEmail.value}');
      } else {
        debugPrint('❌ Failed to fetch profile: ${response.statusCode}');
        // Load from local storage as fallback
        await _loadFromLocalStorage();
      }
    } catch (e) {
      debugPrint('❌ Error fetching profile: $e');
      // Load from local storage as fallback
      await _loadFromLocalStorage();
    } finally {
      isProfileLoading(false);
    }
  }

  /// Load user data from SharedPreferences
  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      businessName.value = prefs.getString('business_name') ?? '';
      userEmail.value = prefs.getString('user_email') ?? '';
      
      debugPrint('📦 Loaded from local storage:');
      debugPrint('   Business Name: ${businessName.value}');
      debugPrint('   User Email: ${userEmail.value}');
    } catch (e) {
      debugPrint('❌ Error loading from local storage: $e');
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
    }
  }
}
