import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuoteEditDetailsController extends GetxController{
    late final int quoteIndex;
    QuoteEditDetailsController(this.quoteIndex);
    final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
    final isNameFocused = false.obs;
  final isNamehasText = false.obs;

  final isEmailFocused = false.obs;
  final isEmailhasText = false.obs;

  final isPhoneFocused = false.obs;
  final isPhonehasText = false.obs;
}