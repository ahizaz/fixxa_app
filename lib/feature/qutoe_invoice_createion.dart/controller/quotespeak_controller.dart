import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class VoiceController extends GetxController {
  final recorder = AudioRecorder();
  final player = AudioPlayer();
  var isRecording = false.obs;
  var recordedFilePath = "".obs;
  var isPlayed = false.obs;

  Future<void> startRecording() async {
    if (await recorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final filePath = "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.wav";
      await recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 44100,
        ),
        path: filePath,
      );
      recordedFilePath.value = filePath;
      isRecording.value = true;
      isPlayed.value = false;
    }
  }

  Future<void> stopRecording() async {
    final path = await recorder.stop();
    isRecording.value = false;
    if (path != null) {
      recordedFilePath.value = path;
    }
  }

  Future<void> cancelRecording() async {
    await recorder.cancel();
    isRecording.value = false;
    recordedFilePath.value = "";
    isPlayed.value = false;
  }

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

  Future<void> playRecording() async {
    if (recordedFilePath.value.isNotEmpty) {
      await player.setFilePath(recordedFilePath.value);
      player.play();
      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          isPlayed.value = true;
        }
      });
    }
  }

  @override
  void onClose() {
    recorder.dispose();
    player.dispose();
    super.onClose();
  }
}