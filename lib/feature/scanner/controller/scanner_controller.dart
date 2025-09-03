
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart'; // Import open_filex

class ScannerController extends GetxController {
  RxBool isScanning = false.obs;
  Rx<XFile?> scannedImage = Rx<XFile?>(null);
  RxString scannedData = ''.obs;
  Rx<File?> generatedPdfFile = Rx<File?>(null);
  RxBool pdfGenerated = false.obs; // To control visibility of PDF section
  RxString savedPdfPath = ''.obs; // To store the path of the permanently saved PDF

  Future<void> startScan() async {
    isScanning.value = true;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      scannedImage.value = image;
      final inputImage = InputImage.fromFilePath(image.path);
      // ignore: deprecated_member_use
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

  Future<void> generateTemporaryPdf() async {
    final pdf = pw.Document();
    final imageFile = scannedImage.value != null ? File(scannedImage.value!.path) : null;

    pw.ImageProvider? pdfImage;
    if (imageFile != null) {
      final imageBytes = await imageFile.readAsBytes();
      pdfImage = pw.MemoryImage(imageBytes);
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Scanned Invoice',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            if (pdfImage != null)
              pw.Container(
                height: 300,
                child: pw.Image(pdfImage),
              ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Extracted Text:',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              scannedData.value.isEmpty ? 'No text extracted.' : scannedData.value,
              style: const pw.TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/quote_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());

    generatedPdfFile.value = file;
    pdfGenerated.value = true; // Set to true after PDF is generated
  }

  Future<void> savePdfToDevice() async {
    if (generatedPdfFile.value == null) {
      Get.snackbar('Error', 'No PDF to save. Please generate one first.');
      return;
    }

    try {
      Directory? appDirectory;
      if (Platform.isAndroid) {
        appDirectory = await getExternalStorageDirectory(); // App-private external storage
      } else if (Platform.isIOS) {
        appDirectory = await getApplicationDocumentsDirectory(); // App's documents on iOS
      }

      if (appDirectory == null) {
        Get.snackbar('Error', 'Could not get storage directory.');
        return;
      }

      // Create a custom directory within the app's storage
      final String customPath = '${appDirectory.path}/FixxaPDFs';
      final Directory customDirectory = Directory(customPath);
      if (!await customDirectory.exists()) {
        await customDirectory.create(recursive: true);
      }

      final String fileName = 'quote_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final String newPath = '${customDirectory.path}/$fileName';
      
      await generatedPdfFile.value!.copy(newPath);
      savedPdfPath.value = newPath; // Store the permanently saved path
      Get.snackbar('Success', 'PDF saved to: $newPath',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5));
      
      // Optionally, reset the temporary generatedPdfFile if you only want the saved one
      // generatedPdfFile.value = null;

    } catch (e) {
      Get.snackbar('Error', 'Failed to save PDF: $e');
    }
  }

  Future<void> viewSavedPdf(String path) async {
    if (await File(path).exists()) {
      OpenFilex.open(path);
    } else {
      Get.snackbar('Error', 'File not found at $path');
    }
  }

  void resetScan() {
    scannedImage.value = null;
    scannedData.value = '';
    generatedPdfFile.value = null;
    pdfGenerated.value = false;
    savedPdfPath.value = '';
  }
}