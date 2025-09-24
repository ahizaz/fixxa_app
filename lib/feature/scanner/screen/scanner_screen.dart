import 'package:fixxa_app/feature/scanner/controller/scanner_controller.dart';
import 'package:fixxa_app/feature/scanner/screen/pdf_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScannerController scannerController = Get.put(ScannerController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Scanner",
          style: GoogleFonts.urbanist(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (scannerController.isScanning.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Scanning in progress..."),
              ],
            ),
          );
        } else if (scannerController.scannedImage.value != null) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Scanned Invoice",
                      style: GoogleFonts.urbanist(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff1C1C1C),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      File(scannerController.scannedImage.value!.path),
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Extracted Text:",
                    style: GoogleFonts.urbanist(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Text(
                        scannerController.scannedData.value.isEmpty
                            ? "No text extracted."
                            : scannerController.scannedData.value,
                        style: GoogleFonts.urbanist(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff434343),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Generate PDF Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        scannerController.generateTemporaryPdf();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3A8DFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Text(
                          "Generate PDF",
                          style: GoogleFonts.urbanist(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Display PDF options if generated
                  Obx(() {
                    if (scannerController.pdfGenerated.value) {
                      return Column(
                        children: [
                          // PDF representation (like your image)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                  size: 30,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quote PDF',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '4.6 MB', // You can calculate actual size if needed
                                        style: GoogleFonts.urbanist(
                                          fontSize: 12.sp,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                if (scannerController.generatedPdfFile.value !=
                                    null)
                                  GestureDetector(
                                    onTap: () {
                                      // Directly view the temporary PDF
                                      Get.to(
                                        () => PdfViewerScreen(
                                          pdfPath: scannerController
                                              .generatedPdfFile
                                              .value!
                                              .path,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "View",
                                      style: GoogleFonts.urbanist(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff3A8DFF),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          // Save PDF Button
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                scannerController.savePdfToDevice();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.green, // Different color for save
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                child: Text(
                                  "Save PDF to Device",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // View Saved PDF Button (only if a permanent path exists)
                          if (scannerController.savedPdfPath.value.isNotEmpty)
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  scannerController.viewSavedPdf(
                                    scannerController.savedPdfPath.value,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .orange, // Different color for view saved
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 10.h,
                                  ),
                                  child: Text(
                                    "View Saved PDF",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: 20.h),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  // Scan Again Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        scannerController.resetScan();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff3A8DFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Text(
                          "Scan Again",
                          style: GoogleFonts.urbanist(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  size: 150,
                  color: Colors.blueGrey,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Full Page Scanner Active",
                  style: GoogleFonts.urbanist(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff1C1C1C),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                Text(
                  "Ready to scan",
                  style: GoogleFonts.urbanist(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: () {
                    scannerController.startScan();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3A8DFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Text(
                      "Start Scan",
                      style: GoogleFonts.urbanist(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
