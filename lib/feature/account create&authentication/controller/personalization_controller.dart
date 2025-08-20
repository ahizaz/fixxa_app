import 'package:get/get.dart';

class PersonalizationController extends GetxController{
  var currentStep = 0.5.obs;
  void nextStep(){
    if(currentStep.value<1.0){
      currentStep.value=0.5;
    }
  }
}