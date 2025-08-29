// import 'package:fixxa_app/feature/scanner/controller/scanner_controller.dart'; // Import your controller
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ScannerScreen extends StatelessWidget {
//   const ScannerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Initialize your controller. Get.put makes it available globally.
//     // If this screen is transient and the controller isn't needed elsewhere,
//     // you might use Get.lazyPut or Get.create for better resource management.
//     final ScannerController scannerController = Get.put(ScannerController());

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Scanner",
//           style: GoogleFonts.urbanist(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.qr_code_scanner,
//               size: 150.w,
//               color: Colors.blueGrey,
//             ),
//             SizedBox(height: 20.h),
//             Text(
//               "Full Page Scanner Active",
//               style: GoogleFonts.urbanist(
//                 fontSize: 22.sp,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xff1C1C1C),
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 30.h),
//             Obx(() => Text(
//                   scannerController.isScanning.value ? "Scanning..." : "Ready to scan",
//                   style: GoogleFonts.urbanist(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w400,
//                     color: scannerController.isScanning.value ? Colors.blue : Colors.green,
//                   ),
//                 )),
//             SizedBox(height: 30.h),
//             ElevatedButton(
//               onPressed: () {
//                 scannerController.startScan();
//               },
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//                 child: Text(
//                   "Start Scan",
//                   style: GoogleFonts.urbanist(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xff3A8DFF),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:fixxa_app/feature/scanner/controller/scanner_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize your controller. Get.put makes it available globally.
    // If this screen is transient and the controller isn't needed elsewhere,
    // you might use Get.lazyPut or Get.create for better resource management.
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
                      "Scanned Page",
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
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
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
                  SizedBox(height: 30.h),
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
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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