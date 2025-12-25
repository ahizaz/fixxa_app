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

class VoiceController extends GetxController {
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
    final fileName = 'quote_${DateTime.now().millisecondsSinceEpoch}.wav';

    try {
      debugPrint("📤 Uploading quote recording: $fileName");

      // Read file as bytes
      final fileBytes = await file.readAsBytes();
      final uint8ListBytes = Uint8List.fromList(fileBytes);

      // Upload using SupabaseService
      final url = await SupabaseService.instance.uploadQuoteRecording(
        fileName: fileName,
        fileBytes: uint8ListBytes,
      );

      uploadedUrl.value = url;
      debugPrint("✅ Quote recording uploaded: $url");
      Get.snackbar('Success', 'Quote recording uploaded successfully!');

      // Call AI API to process the audio
      await _processAudioWithAI();
    } catch (e) {
      debugPrint("❌ Upload failed: $e");
      Get.snackbar('Error', 'Upload failed: $e');
    }
  }

  // Process audio with AI API
  Future<void> _processAudioWithAI() async {
    try {
      debugPrint("🤖 Calling AI API to process quote audio...");

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/ProcessAudio'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': 'quote'}),
      );

      debugPrint("📡 AI API Response Status: ${response.statusCode}");
      debugPrint("📄 AI API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Save the JSON data in a variable
        final Map<String, dynamic> aiData = jsonDecode(response.body);

        // Print the data
        debugPrint("✅ AI Processing Successful!");
        debugPrint("📊 AI Data: $aiData");
        debugPrint("📝 Transcription: ${aiData['transcription']}");
        debugPrint("👤 Client Data: ${aiData['client_data']}");

        Get.snackbar(
          'AI Processing Complete',
          'Quote data extracted successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // TODO: Use aiData to populate quote form
        // You can access: aiData['client_data'], aiData['transcription'], etc.
      } else {
        debugPrint("❌ AI API Error: ${response.statusCode}");
        Get.snackbar(
          'AI Error',
          'Failed to process audio: ${response.statusCode}',
        );
      }
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
