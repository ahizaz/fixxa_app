import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditDetailsController extends GetxController{
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final isNameFocused = false.obs;
  final isNamehasText = false.obs;

  final isEmailFocused = false.obs;
  final isEmailhasText = false.obs;

  final isPhoneFocused = false.obs;
  final isPhonehasText = false.obs;
  @override
  void onInit() {
    nameController.addListener((){
   isNamehasText.value = nameController.text.isNotEmpty;
    });
    emailController.addListener((){
    isEmailhasText.value=emailController.text.isNotEmpty;
    });
    phoneNumberController.addListener((){
    isPhonehasText.value=phoneNumberController.text.isNotEmpty;
    });
    
    super.onInit();
  }
  void clearName(){
    nameController.clear();
    isNamehasText.value=false;
  }
  void clearEmail(){
    emailController.clear();
    isEmailhasText.value=false;
  }
  void clearPhone(){
    phoneNumberController.clear();
    isPhonehasText.value=false;
  }
}