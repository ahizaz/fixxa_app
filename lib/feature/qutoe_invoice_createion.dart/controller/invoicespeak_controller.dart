import 'dart:io';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    print("❌ No file to upload!");
    return;
  }

  final supabase = Supabase.instance.client;
  final file = File(recordedFilePath.value);
  final fileName = recordedFilePath.value.split('/').last;
  final bucketName = 'audio_storage';  // ✅ AI Developer-এর জন্য

  try {
    print("📤 Uploading to audio_storage: $fileName");
    
    await supabase.storage.from(bucketName).upload(fileName, file);
    
    final url = supabase.storage.from(bucketName).getPublicUrl(fileName);
    uploadedUrl.value = url;
    
    print("✅ Uploaded! URL: $url");
    print("🎉 AI Developer এই URL পাবে!");
    
  } catch (e) {
    print("❌ Upload Failed: $e");
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