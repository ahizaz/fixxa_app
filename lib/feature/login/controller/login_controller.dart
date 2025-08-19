import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{
    final loginEmailCOntroller = TextEditingController();
    final isLoginEmailFocuesd = false.obs;
    final isLoginEmailhasText = false.obs;
    @override
  void onInit() {
   loginEmailCOntroller.addListener((){
isLoginEmailhasText.value=loginEmailCOntroller.text.isNotEmpty;
   });
    super.onInit();
  }
  void clearEmail(){
    loginEmailCOntroller.clear();
    isLoginEmailhasText.value=false;

  }
  @override
  void onClose() {
   loginEmailCOntroller.dispose();
    super.onClose();
  }

}
