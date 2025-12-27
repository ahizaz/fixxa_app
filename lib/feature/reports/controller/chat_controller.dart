// lib/feature/reports/controller/chat_controller.dart

import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fixxa_app/core/urls/urls.dart';

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
    // Call AI chat API
    _callAiChatApi(message);
  }

  Future<void> _callAiChatApi(String userText) async {
    const String userId = '33b4bd06-3f42-440f-ba4a-edb163221dc6';
    final uri = Uri.parse(Urls.aiChat);

    try {
      EasyLoading.show(status: 'Thinking...');

      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'user_text': userText}),
      );

      // Debug print full response
      print('AI chat response status: ${resp.statusCode}');
      print('AI chat response body: ${resp.body}');

      if (resp.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(resp.body);
        final String botReply = data['response']?.toString() ?? 'No response';
        addBotMessage(botReply);
        // Show the actual AI response to the user via EasyLoading
        EasyLoading.showSuccess(botReply);
      } else {
        addBotMessage('Sorry, something went wrong.');
        EasyLoading.showError('Failed to get response');
      }
    } catch (e) {
      print('AI chat error: $e');
      addBotMessage('An error occurred while contacting AI.');
      EasyLoading.showError('An error occurred');
    } finally {
      EasyLoading.dismiss();
    }
  }
}
