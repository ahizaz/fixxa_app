// lib/feature/reports/controller/chat_controller.dart

import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';

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
    final uri = Uri.parse(Urls.aiChat);

    try {
      EasyLoading.show(status: 'Thinking...');

      // Get access token and attach Authorization header
      final token = await LoginController.getAccessToken();
      if (token == null || token.isEmpty) {
        EasyLoading.dismiss();
        addBotMessage('Please login to use AI chat.');
        EasyLoading.showError('Please login first');
        return;
      }

      final resp = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'question': userText}),
      );

      // Debug print full response
      print('AI chat response status: ${resp.statusCode}');
      print('AI chat response body: ${resp.body}');

      if (resp.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(resp.body);
        final bool ok = json['success'] == true || json['statusCode'] == 200;
        String botReply = 'No response';

        if (ok) {
          final Map<String, dynamic>? d = json['data'] is Map ? json['data'] as Map<String, dynamic> : null;
          botReply = d?['answer']?.toString() ?? d?['message']?.toString() ?? json['message']?.toString() ?? botReply;
        } else {
          botReply = json['message']?.toString() ?? 'Failed to process query.';
        }

        addBotMessage(botReply);
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
