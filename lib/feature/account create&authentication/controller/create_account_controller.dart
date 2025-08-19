import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CreateAccountController extends GetxController {
  final createaccountemailController = TextEditingController();
  final TextEditingController ereatepasswordController = TextEditingController();

     RxBool isPasswordVisible = false.obs;

   void toogleVisibility(){
     isPasswordVisible.value = !isPasswordVisible.value;
   }
  final isCreateEmailFocused = false.obs;

  final isCreateEmailhasText = false.obs;

  @override
  void onInit() {
    super.onInit();
    createaccountemailController.addListener(() {
      isCreateEmailhasText.value = createaccountemailController.text.isNotEmpty;
    });
  }

  void clearEmail() {
    createaccountemailController.clear();
    isCreateEmailhasText.value = false;
  }

  @override
  void onClose() {
    createaccountemailController.dispose();
    super.onClose();
  }
}