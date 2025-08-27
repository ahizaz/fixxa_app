
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';

class EditDetailsController extends GetxController{
  late final int clientIndex;
  EditDetailsController(this.clientIndex);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final isNameFocused = false.obs;
  final isNamehasText = false.obs;

  final isEmailFocused = false.obs;
  final isEmailhasText = false.obs;

  final isPhoneFocused = false.obs;
  final isPhonehasText = false.obs;
  bool get isFormValid=>isNamehasText.value && isEmailhasText.value && isPhonehasText.value;
  @override
  void onInit() {
    final homeController = Get.find<HomeDefaultController>();
    final data = homeController.clientData[clientIndex];
    nameController.text = data['name'];
    emailController.text = data['email'];
    phoneNumberController.text = data['phone'];
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