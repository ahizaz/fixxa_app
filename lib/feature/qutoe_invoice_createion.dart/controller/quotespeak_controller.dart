import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/quote_ai_generated_controller.dart';
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
import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_ai_generated.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

    // Use recorded file directly (WAV or MP3). No FFmpeg conversion required.
    String uploadPath = recordedFilePath.value;
    final file = File(uploadPath);
    final ext = p.extension(uploadPath).toLowerCase();
    final fileName = 'quote_${DateTime.now().millisecondsSinceEpoch}$ext';

    try {
      debugPrint("📤 Uploading quote recording (MP3): $fileName");

      // TODO: replace with your real API endpoint
      final uri = Uri.parse('https://example.com/api/upload-audio');

      final request = http.MultipartRequest('POST', uri);
      final mime = uploadPath.toLowerCase().endsWith('.wav')
          ? MediaType('audio', 'wav')
          : MediaType('audio', 'mpeg');
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        uploadPath,
        filename: fileName,
        contentType: mime,
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
      // No conversion files to cleanup when using the recorded file directly.
    }
  }

  /// Upload the recorded (or converted) MP3 directly to the Quote AI endpoint
  /// as multipart/form-data under field name `audio` and navigate to
  /// `QuoteAiGenerated` when response contains quote data.
  Future<void> uploadRecordingToQuoteAi() async {
    if (recordedFilePath.value.isEmpty) {
      debugPrint("❌ No file to upload to Quote AI!");
      return;
    }

    // Use the recorded file directly (WAV or MP3). No FFmpeg conversion required.
    String uploadPath = recordedFilePath.value;
    final file = File(uploadPath);
    final ext = p.extension(uploadPath).toLowerCase();
    final fileName = 'quote_${DateTime.now().millisecondsSinceEpoch}$ext';

    try {
      EasyLoading.show(status: 'Uploading voice...');
      debugPrint('📤 Uploading to Quote AI: $fileName -> ${Urls.quoteaiAudio}');

      final uri = Uri.parse(Urls.quoteaiAudio);
      final request = http.MultipartRequest('POST', uri);

      // Determine client id to send with request. API requires client id field
      int? clientId;
      try {
        if (Get.isRegistered<ManuallyQuoteController>()) {
          final mqc = Get.find<ManuallyQuoteController>();
          final cid = mqc.selectedClient['id'] ?? mqc.selectedClient['client_id'] ?? mqc.selectedClient['client'];
          if (cid != null) clientId = int.tryParse(cid.toString());
        }
      } catch (_) {}

      // Fallback: try to read client from existing QuoteAiGeneratedController data
      try {
        if (clientId == null && Get.isRegistered<QuoteAiGeneratedController>()) {
          final qctrl = Get.find<QuoteAiGeneratedController>();
          final cid = qctrl.quoteData['client'] ?? qctrl.quoteData['client_id'];
          if (cid != null) clientId = int.tryParse(cid.toString());
        }
      } catch (_) {}

      if (clientId == null) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please select a client before uploading voice');
        debugPrint('❌ Quote AI upload aborted: client id not available');
        return;
      }

      // Attach client id as form field (API expects `client_id`)
      request.fields['client_id'] = clientId.toString();
      debugPrint('📤 Sending client_id: ${clientId.toString()}');

      // Attach authorization token if available
      try {
        final token = await LoginController.getAccessToken();
        if (token != null && token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      } catch (_) {}

      final mime = uploadPath.toLowerCase().endsWith('.wav')
          ? MediaType('audio', 'wav')
          : MediaType('audio', 'mpeg');

      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        uploadPath,
        filename: fileName,
        contentType: mime,
      ));

      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);

      debugPrint('📤 Quote AI response status: ${resp.statusCode}');
      debugPrint('📤 Quote AI body: ${resp.body}');

      EasyLoading.dismiss();

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        try {
          final Map<String, dynamic> body = json.decode(resp.body);
          final data = body['data'] ?? body;

          if (data is Map<String, dynamic>) {
            // Update QuoteAiGeneratedController so UI updates
            try {
              final quoteController = Get.isRegistered<QuoteAiGeneratedController>()
                  ? Get.find<QuoteAiGeneratedController>()
                  : Get.put(QuoteAiGeneratedController());
              quoteController.quoteData.value = Map<String, dynamic>.from(data);
              debugPrint('✅ QuoteAiGeneratedController.quoteData updated from Quote AI');
            } catch (e) {
              debugPrint('⚠️ Failed to update QuoteAiGeneratedController: $e');
            }

            EasyLoading.showSuccess('Quote created successfully from voice');

            // Navigate to QuoteAiGenerated screen and ensure it refreshes
            try {
              Get.to(() => const QuoteAiGenerated());
            } catch (e) {
              debugPrint('⚠️ Navigation to QuoteAiGenerated failed: $e');
            }
          } else {
            EasyLoading.showError('Invalid response data from Quote AI');
          }
        } catch (e) {
          EasyLoading.showError('Failed to parse response: $e');
          debugPrint('❌ Parse error: $e');
        }
      } else {
        EasyLoading.showError('Upload failed: ${resp.statusCode}');
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Upload to Quote AI failed: $e');
      Get.snackbar('Error', 'Upload failed: $e');
    } finally {
      // No conversion files to cleanup when sending the recorded file directly.
    }
  }

  // Convert WAV to MP3 using FFmpeg
  // No local conversion required — server accepts WAV/MP3 directly.

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
