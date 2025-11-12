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

  @override
  void onInit() {
    super.onInit();
    // Fetch data when the controller is first created
    fetchSubscriptionData();
    fetchUserProfile();
  }

  /// This method will eventually contain your real API call.
  Future<void> fetchSubscriptionData() async {
    try {
      isLoading(true);

      // Simulate a network delay, just like a real API call would have.
      await Future.delayed(const Duration(seconds: 2));

      // --- This is your static data, structured like JSON from an API ---
      final mockApiData = {
        'earnedAmountDisplay': '£8,360',
        'amountLeftDisplay': '£1,640',
        'progressValue': 0.836, // This is 8360 / 10000
      };

      // We use the model to parse the data.
      subscriptionProgress.value = SubscriptionProgress.fromMap(mockApiData);
    } catch (e) {
      // Handle potential errors here in the future.
    } finally {
      // Make sure loading is set to false after the operation.
      isLoading(false);
    }
  }

  /// Fetch user profile data (business name and email)
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
        
        // Check different possible response structures
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
