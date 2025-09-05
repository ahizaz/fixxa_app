import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class VoiceController extends GetxController {
  final recorder = AudioRecorder();   // ✅ নতুন API
  final player = AudioPlayer();

  var isRecording = false.obs;
  var recordedFilePath = "".obs;

  /// Start recording
  Future<void> startRecording() async {
    if (await recorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a";

      await recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      recordedFilePath.value = filePath;
      isRecording.value = true;
    }
  }

  /// Stop recording
  Future<void> stopRecording() async {
    final path = await recorder.stop();
    isRecording.value = false;

    if (path != null) {
      recordedFilePath.value = path;
    }
  }

  /// Cancel recording (remove file)
  Future<void> cancelRecording() async {
    await recorder.cancel();
    isRecording.value = false;
    recordedFilePath.value = "";
  }

  /// Confirm recording (finalize and keep file)
  Future<void> confirmRecording() async {
    if (isRecording.value) {
      final path = await recorder.stop();
      isRecording.value = false;

      if (path != null) {
        recordedFilePath.value = path;
        print("✅ Recording confirmed: $path");
      }
    } else {
      print("⚠️ No active recording to confirm");
    }
  }

  /// Play the recorded audio
  Future<void> playRecording() async {
    if (recordedFilePath.value.isNotEmpty) {
      await player.setFilePath(recordedFilePath.value);
      player.play();
    }
  }

  @override
  void onClose() {
    recorder.dispose();   // ✅ properly dispose
    player.dispose();
    super.onClose();
  }
}
