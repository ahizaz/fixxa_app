import 'dart:io';
import 'dart:typed_data';
import 'package:fixxa_app/core/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

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
    } catch (e) {
      debugPrint("❌ Upload failed: $e");
      Get.snackbar('Error', 'Upload failed: $e');
    }
  }

  @override
  void onClose() {
    recorder.dispose();
    player.dispose();
    super.onClose();
  }
}
