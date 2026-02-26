import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/tap_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/invoice_ai_generated_controller.dart';
///voicecontroller 
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

    // Convert WAV to MP3 (FFmpeg) if necessary, then upload to custom API endpoint.
    String uploadPath = recordedFilePath.value;
    if (uploadPath.toLowerCase().endsWith('.wav')) {
      final mp3 = await _convertWavToMp3(uploadPath);
      if (mp3 == null) {
        Get.snackbar('Error', 'Audio conversion failed');
        return;
      }
      uploadPath = mp3;
    }

    final file = File(uploadPath);
    final fileName = 'quote_${DateTime.now().millisecondsSinceEpoch}.mp3';

    try {
      debugPrint("📤 Uploading quote recording (MP3): $fileName");

      // TODO: replace with your real API endpoint
      final uri = Uri.parse('https://example.com/api/upload-audio');

      final request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        uploadPath,
        filename: fileName,
        contentType: MediaType('audio', 'mpeg'),
      ));

      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);
      if (resp.statusCode == 200) {
        // Assume API returns the uploaded file URL in the body (adjust parsing as needed)
        uploadedUrl.value = resp.body;
        debugPrint("✅ Quote recording uploaded: ${resp.body}");
        Get.snackbar('Success', 'Quote recording uploaded successfully!');

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

        // Delegate AI processing to InvoiceAiGeneratedController
        try {
          final aiController = Get.isRegistered<InvoiceAiGeneratedController>()
              ? Get.find<InvoiceAiGeneratedController>()
              : Get.put(InvoiceAiGeneratedController());

          debugPrint('🤖 Calling AI API to process ${isQuote ? 'quote' : 'invoice'} audio...');
          await aiController.processAiAudio(isQuote: isQuote);
        } catch (e) {
          debugPrint('❌ Failed to call AI controller: $e');
        }
      } else {
        debugPrint('❌ Upload failed: ${resp.statusCode} ${resp.body}');
        Get.snackbar('Error', 'Upload failed: ${resp.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Upload failed: $e");
      Get.snackbar('Error', 'Upload failed: $e');
    } finally {
      // Cleanup temporary MP3 if created
      try {
        if (uploadPath != recordedFilePath.value && File(uploadPath).existsSync()) {
          await File(uploadPath).delete();
        }
      } catch (_) {}
    }
  }

  // Convert WAV to MP3 using FFmpeg
  Future<String?> _convertWavToMp3(String wavPath) async {
    try {
      final dir = await getTemporaryDirectory();
      final outName = '${p.basenameWithoutExtension(wavPath)}_${DateTime.now().millisecondsSinceEpoch}.mp3';
      final mp3Path = p.join(dir.path, outName);
      final cmd = '-y -i "$wavPath" -codec:a libmp3lame -qscale:a 2 "$mp3Path"';
      final session = await FFmpegKit.execute(cmd);
      final returnCode = await session.getReturnCode();
      if (returnCode != null && ReturnCode.isSuccess(returnCode)) {
        return mp3Path;
      } else {
        debugPrint('FFmpeg conversion failed, rc=$returnCode');
        return null;
      }
    } catch (e) {
      debugPrint('Conversion error: $e');
      return null;
    }
  }

  // Process audio with AI API
  Future<void> _processAudioWithAI() async {
    try {
      final aiController = Get.isRegistered<InvoiceAiGeneratedController>()
          ? Get.find<InvoiceAiGeneratedController>()
          : Get.put(InvoiceAiGeneratedController());

      debugPrint('🤖 _processAudioWithAI: delegating to InvoiceAiGeneratedController');
      await aiController.processAiAudio(isQuote: true);
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
