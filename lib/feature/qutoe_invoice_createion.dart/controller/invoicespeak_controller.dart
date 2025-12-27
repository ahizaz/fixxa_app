import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:fixxa_app/core/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/tap_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/invoice_ai_generated_controller.dart';

class InvoicespeakController extends GetxController {
  final recorder = AudioRecorder();
  final player = AudioPlayer();
  var isRecording = false.obs;
  var isPaused = false.obs;
  var recordedFilePath = "".obs;
  var isPlayed = false.obs;
  var uploadedUrl = "".obs;

  Future<void> startRecording() async {
    if (await recorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final filePath =
          "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.wav";
      await recorder.start(
        const RecordConfig(encoder: AudioEncoder.wav, sampleRate: 44100),
        path: filePath,
      );
      recordedFilePath.value = filePath;
      isRecording.value = true;
      isPaused.value = false;
      isPlayed.value = false;
    }
  }

  Future<void> pauseRecording() async {
    if (isRecording.value) {
      await recorder.pause();
      isRecording.value = false;
      isPaused.value = true;
    }
  }

  Future<void> resumeRecording() async {
    if (isPaused.value) {
      await recorder.resume();
      isRecording.value = true;
      isPaused.value = false;
    }
  }

  Future<void> stopRecording() async {
    final path = await recorder.stop();
    isRecording.value = false;
    isPaused.value = false;
    if (path != null) {
      recordedFilePath.value = path;
    }
  }

  Future<void> cancelRecording() async {
    await recorder.cancel();
    isRecording.value = false;
    isPaused.value = false;
    recordedFilePath.value = "";
    isPlayed.value = false;
  }

  Future<void> confirmRecording() async {
    final path = await recorder.stop();
    isRecording.value = false;
    isPaused.value = false;
    if (path != null) {
      recordedFilePath.value = path;
    }
  }

  Future<void> uploadRecordingToSupabase() async {
    if (recordedFilePath.value.isEmpty) {
      debugPrint("❌ No file to upload!");
      return;
    }

    final file = File(recordedFilePath.value);
    final fileName = 'invoice_${DateTime.now().millisecondsSinceEpoch}.wav';

    try {
      debugPrint("📤 Uploading invoice recording: $fileName");

      // Read file as bytes
      final fileBytes = await file.readAsBytes();
      final uint8ListBytes = Uint8List.fromList(fileBytes);

      // Upload using SupabaseService
      final url = await SupabaseService.instance.uploadInvoiceRecording(
        fileName: fileName,
        fileBytes: uint8ListBytes,
      );

      uploadedUrl.value = url;
      debugPrint("✅ Invoice recording uploaded: $url");
      Get.snackbar('Success', 'Invoice recording uploaded successfully!');

      // Determine whether current tab is Quote (0) or Invoice (1)
      bool isQuote = true;
      try {
        final tapController = Get.isRegistered<TapController>()
            ? Get.find<TapController>()
            : Get.put(TapController());
        isQuote = tapController.selectedTab.value == 0;
      } catch (e) {
        debugPrint('⚠️ Could not determine tab, defaulting to Quote: $e');
      }

      // Call central AI processor in InvoiceAiGeneratedController
      try {
        final aiController = Get.isRegistered<InvoiceAiGeneratedController>()
            ? Get.find<InvoiceAiGeneratedController>()
            : Get.put(InvoiceAiGeneratedController());

        debugPrint('🤖 Calling AI API to process ${isQuote ? 'quote' : 'invoice'} audio...');
        await aiController.processAiAudio(isQuote: isQuote);
      } catch (e) {
        debugPrint('❌ Failed to call AI controller: $e');
      }
    } catch (e) {
      debugPrint("❌ Upload failed: $e");
      Get.snackbar('Error', 'Upload failed: $e');
    }
  }

  // Process audio with AI API
  Future<void> _processAudioWithAI() async {
    try {
      // Default to invoice processing when this helper is used directly
      final aiController = Get.isRegistered<InvoiceAiGeneratedController>()
          ? Get.find<InvoiceAiGeneratedController>()
          : Get.put(InvoiceAiGeneratedController());

      debugPrint('🤖 _processAudioWithAI: delegating to InvoiceAiGeneratedController');
      await aiController.processAiAudio(isQuote: false);
    } catch (e) {
      debugPrint("❌ AI API Exception: $e");
      Get.snackbar('AI Error', 'Failed to call AI API: $e');
    }
  }

  @override
  void onClose() {
    recorder.dispose();
    player.dispose();
    super.onClose();
  }
}
