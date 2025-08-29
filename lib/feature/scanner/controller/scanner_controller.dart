
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ScannerController extends GetxController {
  RxBool isScanning = false.obs;
  Rx<XFile?> scannedImage = Rx<XFile?>(null);
  RxString scannedData = ''.obs;

  Future<void> startScan() async {
    isScanning.value = true;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      scannedImage.value = image;
      final inputImage = InputImage.fromFilePath(image.path);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      try {
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
        scannedData.value = recognizedText.text;
      } catch (e) {
        scannedData.value = 'Error extracting text: $e';
      } finally {
        textRecognizer.close();
      }
    }
    isScanning.value = false;
  }

  void resetScan() {
    scannedImage.value = null;
    scannedData.value = '';
  }


}