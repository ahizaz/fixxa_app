// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// class ScannerController extends GetxController {
//   // Example observable, if you needed to manage a scanning state or result
//   RxBool isScanning = false.obs;

//   void startScan() {
//     isScanning.value = true;
//     // In a real app, this would initiate actual scanning logic (e.g., using a camera package)
//     print("Starting scan...");
//     // Simulate a scan process
//     Future.delayed(const Duration(seconds: 3), () {
//       isScanning.value = false;
//       print("Scan finished.");
//       // You might then process the scanned data or navigate
//     });
//   }

//   // You can add more methods here for handling scan results, camera control, etc.
// }
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

  // You can add more methods here for handling scan results, camera control, etc.
}