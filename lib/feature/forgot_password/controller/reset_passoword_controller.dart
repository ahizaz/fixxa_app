
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController createnewPassword = TextEditingController();
  final TextEditingController confirmnewPassword = TextEditingController();

  var createnewhasText = false.obs;
  var confirmnewhasText = false.obs;  // Renamed for clarity

  var obsecurecreatenew = true.obs;
  var obsecureconfirmnew = true.obs;

  bool get isFormValid=>createnewhasText.value&&confirmnewhasText.value;

  @override
  void onInit() {
    createnewPassword.addListener(() {
      createnewhasText.value = createnewPassword.text.isNotEmpty;
    });
    confirmnewPassword.addListener(() {
      confirmnewhasText.value = confirmnewPassword.text.isNotEmpty;
    });
    super.onInit();
  }

  void togglecreatenewPassVisibility() {
    obsecurecreatenew.value = !obsecurecreatenew.value;
  }

  void toggleconfirmnewPassVisibility() {
    obsecureconfirmnew.value = !obsecureconfirmnew.value;
  }
}