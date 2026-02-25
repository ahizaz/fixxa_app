import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/create_account_controller.dart';
import 'package:fixxa_app/feature/login/screen/login_default.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalizationController extends GetxController {
  /// Text controllers
  final nameController = TextEditingController();
  final businessController = TextEditingController();
  final phoneController = TextEditingController();

  /// Reactive flags
  var namehasText = false.obs;
  var businesHasText = false.obs;
  var phoneHasText = false.obs;
  var countryCode = ''.obs;

  var businessName = "".obs;

  /// Form validation
  bool get isFormValid =>
      namehasText.value && businesHasText.value && phoneHasText.value;

  /// Progress step (0.5 for Step1, 1.0 for Step2)
  var currentStep = 0.5.obs;
  var selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();
  final _storage = GetStorage();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
      // Save image path locally
      await _storage.write('business_logo_path', image.path);
    }
  }

  @override
  void onInit() {
    super.onInit();

    // Load saved image path if exists
    _loadSavedImage();

    // Load saved business name if exists
    _loadSavedBusinessName();

    /// Listen to name field
    nameController.addListener(() {
      namehasText.value = nameController.text.isNotEmpty;
    });

    /// Listen to business field
    businessController.addListener(() {
      businesHasText.value = businessController.text.isNotEmpty;
      businessName.value = businessController.text;
    });

    /// Listen to phone field
    phoneController.addListener(() {
      phoneHasText.value = phoneController.text.isNotEmpty;
    });
  }

  /// Load saved business name from storage
  Future<void> _loadSavedBusinessName() async {
    final savedName = _storage.read('business_name');
    if (savedName != null && savedName is String) {
      businessName.value = savedName;
      businessController.text = savedName;
    }
  }

  /// Load saved image from storage
  Future<void> _loadSavedImage() async {
    final savedPath = _storage.read('business_logo_path');
    if (savedPath != null) {
      selectedImage.value = XFile(savedPath);
    }
  }

  /// Clear methods
  void clearName() {
    nameController.clear();
    namehasText.value = false;
  }

  void clearBusinessText() {
    businessController.clear();
    businesHasText.value = false;
  }

  void clearPhoneText() {
    phoneController.clear();
    phoneHasText.value = false;
  }

  /// Move to Step2 (full progress)
  void nextStep() {
    currentStep.value = 1.0;
  }

  /// Persist Step 1 values locally so we can greet the user later.
  ///
  /// This is intentionally "best-effort" (no UI blocking); the app can still
  /// proceed even if local storage fails.
  Future<void> persistStep1Locally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', nameController.text.trim());
      await prefs.setString('business_name', businessController.text.trim());
      await prefs.setString('whatsapp_number', phoneController.text.trim());
    } catch (e) {
      debugPrint('⚠️ Failed to persist step1 data locally: $e');
    }
  }

  /// Submit Business Profile (POST API with FormData)
  Future<void> submitBusinessProfile() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Creating profile...');

      debugPrint(' Starting business profile submission...');

      // Get user_id from CreateAccountController
      final CreateAccountController authController =
          Get.find<CreateAccountController>();
      final String userId = authController.userId.value;

      if (userId.isEmpty) {
        EasyLoading.dismiss();
        EasyLoading.showError('User ID not found. Please login again.');
        return;
      }

      debugPrint(' User ID: $userId');
      debugPrint(' Business Name: ${businessController.text}');
      debugPrint(' WhatsApp Number: ${phoneController.text}');
      debugPrint(' Logo: ${selectedImage.value?.path ?? "No image selected"}');

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Urls.busineesProfile),
      );

      // Add form fields
      request.fields['business_name'] = businessController.text.trim();
      request.fields['whatsapp_number'] = phoneController.text.trim();
      request.fields['user_id'] = userId;

      // Add logo if selected
      if (selectedImage.value != null) {
        var logoFile = await http.MultipartFile.fromPath(
          'logo',
          selectedImage.value!.path,
        );
        request.files.add(logoFile);
        debugPrint(' Logo file attached: ${selectedImage.value!.name}');
      }

      debugPrint('Request Fields: ${request.fields}');
      debugPrint(' Request Files: ${request.files.length}');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint(' Response Status Code: ${response.statusCode}');
      debugPrint(' Response Body: ${response.body}');

      // Hide loading
      EasyLoading.dismiss();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint(' Business profile created successfully!');
        debugPrint('Response Data: $responseData');

        // Save business name to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('business_name', businessController.text.trim());
        debugPrint(' Business name saved: ${businessController.text.trim()}');

        // Also persist the user's name (collected in step1) for UI greeting.
        await prefs.setString('user_name', nameController.text.trim());

        EasyLoading.showSuccess('Profile created successfully!');

        // Navigate to LoginDefault after successful submission
        Get.offAll(() => LoginDefault());
        return;
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint(' Error: $errorData');
        EasyLoading.showError(
          errorData['message'] ?? 'Failed to create business profile',
        );
      }
    } catch (e) {
      debugPrint(' Exception occurred: $e');
      EasyLoading.dismiss();
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }
}
