import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:fixxa_app/core/services/supabase_service.dart';
import 'package:fixxa_app/core/urls/urls.dart';
import 'package:fixxa_app/feature/login/controller/login_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/quote_ai_generated_controller.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/invoice_ai_generated.dart';
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
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
    try {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        Get.snackbar('Permission', 'Microphone permission denied. Please grant and retry');
        debugPrint('❌ startRecording: microphone permission denied (permission_handler)');
        return;
      }

      final hasPerm = await recorder.hasPermission();
      if (!hasPerm) {
        Get.snackbar('Permission', 'Microphone permission denied by recorder. Please grant and retry');
        debugPrint('❌ startRecording: microphone permission denied (recorder)');
        return;
      }

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
    } catch (e) {
      debugPrint('❌ startRecording error: $e');
      Get.snackbar('Recording error', e.toString());
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

  /// Upload the recorded (WAV/MP3) directly to the Invoice AI endpoint
  /// using multipart/form-data under field name `audio` and update
  /// `InvoiceAiGeneratedController` with returned data.
  Future<void> uploadRecordingToInvoiceAi() async {
    if (recordedFilePath.value.isEmpty) {
      debugPrint("❌ No file to upload to Invoice AI!");
      return;
    }

    String uploadPath = recordedFilePath.value;
    final file = File(uploadPath);
    final ext = p.extension(uploadPath).toLowerCase();
    final fileName = 'invoice_${DateTime.now().millisecondsSinceEpoch}$ext';

    try {
      EasyLoading.show(status: 'Uploading voice...');
      debugPrint('📤 Uploading to Invoice AI: $fileName -> ${Urls.invoiceaiAudio}');

      final uri = Uri.parse(Urls.invoiceaiAudio);
      final request = http.MultipartRequest('POST', uri);

      // Determine client id to send with request. API expects `client_id` field
      int? clientId;
      try {
        // Prefer invoice manual controller
        if (Get.isRegistered<InvoiceManuallyController>()) {
          final imc = Get.find<InvoiceManuallyController>();
          final cid = imc.selectedClient['id'] ?? imc.selectedClient['client_id'] ?? imc.selectedClient['client'];
          if (cid != null) clientId = int.tryParse(cid.toString());
        }

        // If not found, try the manually-quote controller (UI sometimes uses this)
        if (clientId == null && Get.isRegistered<ManuallyQuoteController>()) {
          final mqc = Get.find<ManuallyQuoteController>();
          final cid = mqc.selectedClient['id'] ?? mqc.selectedClient['client_id'] ?? mqc.selectedClient['client'];
          if (cid != null) clientId = int.tryParse(cid.toString());
        }

        // Fallback: try to read client from existing InvoiceAiGeneratedController data
        if (clientId == null && Get.isRegistered<InvoiceAiGeneratedController>()) {
          final ictrl = Get.find<InvoiceAiGeneratedController>();
          final cid = ictrl.quoteData['client'] ?? ictrl.quoteData['client_id'];
          if (cid != null) clientId = int.tryParse(cid.toString());
        }

        // Last resort: try QuoteAiGeneratedController (shared data between quote/invoice flows)
        if (clientId == null && Get.isRegistered<QuoteAiGeneratedController>()) {
          final qctrl = Get.find<QuoteAiGeneratedController>();
          final cid = qctrl.quoteData['client'] ?? qctrl.quoteData['client_id'];
          if (cid != null) clientId = int.tryParse(cid.toString());
        }
      } catch (_) {}

      if (clientId == null) {
        EasyLoading.dismiss();
        EasyLoading.showError('Please select a client before uploading voice');
        debugPrint('❌ Invoice AI upload aborted: client id not available');
        return;
      }

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

      debugPrint('📤 Invoice AI response status: ${resp.statusCode}');
      debugPrint('📤 Invoice AI body: ${resp.body}');

      EasyLoading.dismiss();

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        try {
          final Map<String, dynamic> body = json.decode(resp.body);
          final data = body['data'] ?? body;

          if (data is Map<String, dynamic>) {
            // Update InvoiceAiGeneratedController so UI updates
            try {
              final invoiceController = Get.isRegistered<InvoiceAiGeneratedController>()
                  ? Get.find<InvoiceAiGeneratedController>()
                  : Get.put(InvoiceAiGeneratedController());
              invoiceController.quoteData.value = Map<String, dynamic>.from(data);
              debugPrint('✅ InvoiceAiGeneratedController.quoteData updated from Invoice AI');
            } catch (e) {
              debugPrint('⚠️ Failed to update InvoiceAiGeneratedController: $e');
            }

            EasyLoading.showSuccess('Invoice created successfully from voice');

            // Navigate to Invoice AI generated page
            try {
              Get.to(() => const InvoiceAiGenerated());
            } catch (e) {
              debugPrint('⚠️ Navigation to InvoiceAiGenerated failed: $e');
            }
          } else {
            EasyLoading.showError('Invalid response data from Invoice AI');
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
      debugPrint('❌ Upload to Invoice AI failed: $e');
      Get.snackbar('Error', 'Upload failed: $e');
    } finally {
      // no local cleanup required
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
