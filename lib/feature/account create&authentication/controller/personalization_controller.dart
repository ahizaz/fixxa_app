import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
}
