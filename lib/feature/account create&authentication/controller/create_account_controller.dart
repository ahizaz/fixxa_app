import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CreateAccountController extends GetxController {
  final createaccountemailController = TextEditingController();
  var obsecureText = true.obs;
  final TextEditingController createPasswordController = TextEditingController();
  var hasText = false.obs;


     
 bool get isFormValid =>
      isCreateEmailhasText.value && hasText.value;
 
  final isCreateEmailFocused = false.obs;//

  final isCreateEmailhasText = false.obs;

  @override
  void onInit() {
    super.onInit();
    createaccountemailController.addListener(() {
      isCreateEmailhasText.value = createaccountemailController.text.isNotEmpty;
    });
    createPasswordController.addListener((){
   hasText.value = createPasswordController.text.isNotEmpty;
    });
  }
  void togglePasswordVisibility(){
    obsecureText.value=!obsecureText.value;
  }

  void clearEmail() {
    createaccountemailController.clear();
    isCreateEmailhasText.value = false;
  }
void cleaPassword(){
  createPasswordController.clear();
}

  @override
  void onClose() {
    createaccountemailController.dispose();
    createPasswordController.dispose();
    super.onClose();
  }
}