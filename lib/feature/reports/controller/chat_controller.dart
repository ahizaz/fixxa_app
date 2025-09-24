// lib/feature/reports/controller/chat_controller.dart

import 'package:get/get.dart';

class ChatController extends GetxController {
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Add initial bot message
    addBotMessage("Hello, what can I do for you?");
  }

  void addBotMessage(String message) {
    messages.add({
      'isBot': true,
      'message': message,
      'timestamp': DateTime.now(),
    });
  }

  void addUserMessage(String message) {
    messages.add({
      'isBot': false,
      'message': message,
      'timestamp': DateTime.now(),
    });

    // Simulate bot response (replace with actual API call in future)
    Future.delayed(Duration(seconds: 1), () {
      addBotMessage("Sure! I will help you with that.");
    });
  }
}
