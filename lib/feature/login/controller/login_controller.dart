import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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

  @override
  void onClose() {
    loginEmailCOntroller.dispose();
    loginPasswordController.dispose();
    super.onClose();
  }
}
