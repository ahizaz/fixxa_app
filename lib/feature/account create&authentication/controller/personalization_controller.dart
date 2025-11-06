import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/create_account_controller.dart';
import 'package:fixxa_app/feature/login/screen/login_default.dart';

class PersonalizationController extends GetxController {
  /// Text controllers
  final nameController = TextEditingController();
  final businessController = TextEditingController();
  final phoneController = TextEditingController();

  /// Reactive flags
  var namehasText = false.obs;
  var businesHasText = false.obs;
  var phoneHasText = false.obs;

  /// Form validation
  bool get isFormValid =>
      namehasText.value && businesHasText.value && phoneHasText.value;

  /// Progress step (0.5 for Step1, 1.0 for Step2)
  var currentStep = 0.5.obs;
  var selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
    }
  }

  @override
  void onInit() {
    super.onInit();

    /// Listen to name field
    nameController.addListener(() {
      namehasText.value = nameController.text.isNotEmpty;
    });

    /// Listen to business field
    businessController.addListener(() {
      businesHasText.value = businessController.text.isNotEmpty;
    });

    /// Listen to phone field
    phoneController.addListener(() {
      phoneHasText.value = phoneController.text.isNotEmpty;
    });
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

  /// Submit Business Profile (POST API with FormData)
  Future<void> submitBusinessProfile() async {
    try {
      // Show loading
      EasyLoading.show(status: 'Creating profile...');
      
      debugPrint(' Starting business profile submission...');
      
      // Get user_id from CreateAccountController
      final CreateAccountController authController = Get.find<CreateAccountController>();
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
        
        EasyLoading.showSuccess('Profile created successfully!');
        
        // Navigate to LoginDefault after successful submission
        Get.offAll(() => LoginDefault());
        return;
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint(' Error: ${errorData}');
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
