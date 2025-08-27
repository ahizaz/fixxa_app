import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessController extends GetxController{
  final locationController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();

  final isLoactionFocused = false.obs;
  final isLoactionhasText = false.obs;

  final phoneNumberFocused = false.obs;
  final phonenumberhasText =false.obs;

  final emailFocused =false.obs;
  final emailhasText = false.obs;
   bool get isFormValid => isLoactionhasText.value&& phonenumberhasText.value && emailhasText.value;
  @override
  void onInit() {
   locationController.addListener((){
    isLoactionhasText.value=locationController.text.isNotEmpty;
   });
   phoneNumberController.addListener((){
   phonenumberhasText.value=phoneNumberController.text.isNotEmpty;
   });
   emailController.addListener((){
   emailhasText.value=emailController.text.isNotEmpty;
   });
    super.onInit();
  }
  void clearPhone(){
    phoneNumberController.clear();
    phonenumberhasText.value=false;
  }
  void clearLocation(){
    locationController.clear();
    isLoactionhasText.value=false;

  }
  void clearEmail(){
    emailController.clear();
    emailhasText.value=false;
  }
  @override
  void onClose() {
  locationController.dispose();
  phoneNumberController.dispose();
  emailController.dispose();

    super.onClose();
  }
}