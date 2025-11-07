import 'package:fixxa_app/app.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_storage/get_storage.dart';

// void main() {
//   runApp(const FixxaApp());
// }
Future<void>main()async{
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage first for persistent data
  await GetStorage.init();
  
   const supabaseUrl = 'https://hnvtfxhapzjvglozozds.supabase.co';
   const supabaseAnonkey =  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhudnRmeGhhcHpqdmdsb3pvemRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkxMzk1NDgsImV4cCI6MjA3NDcxNTU0OH0.GuXrupca8jBWWjpmBzEppG0hsmAv7ZbrNwysHWKthAI';
    await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonkey,
    // debug: true,
  );
  runApp(const FixxaApp());
}
// /import 'dart:ui' as ui;

// import 'package:fixxa_app/core/utils/constants/icon_path.dart';
// import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/controller/invoicespeak_controller.dart';
// import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/invoice_ai_generated.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';


// class InvoiceSpoke extends StatelessWidget {
//   const InvoiceSpoke({super.key});

//  @override
//   Widget build(BuildContext context) {
//     final voiceCtrl = Get.put( InvoicespeakController());
//     return Column(
//       children: [
//         SizedBox(height: 26.h),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w),
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: const Color(0xffFFFFFF),
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 14.h),
//                   Image(
//                     image: AssetImage(IconPath.lightlamp),
//                     width: 24.w,
//                     height: 24.h,
//                     fit: BoxFit.cover,
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     "Tips",
//                     style: GoogleFonts.urbanist(
//                       fontSize: 17.sp,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xff1C1C1C),
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Text(
//                     "Client name, list and describe the item\nin details, add any other details.",
//                     style: GoogleFonts.urbanist(
//                       fontSize: 15.sp,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xff1C1C1C),
//                     ),
//                   ),
//                   SizedBox(height: 14.h),
//                   Center(
//                     child: Obx(() {
//                       if (voiceCtrl.isRecording.value) {
//                         return Column(
//                           children: [
//                             Container(
//                               height: 60.h,
//                               width: double.infinity,
//                               color: Colors.grey[200],
//                               child: Center(
//                                 child: Text(
//                                   "Waveform (Recording... WAV)",
//                                   style: GoogleFonts.urbanist(
//                                     fontSize: 14.sp,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 10.h),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 GestureDetector(
//                                   onTap: voiceCtrl.pauseRecording,
//                                   child: CircleAvatar(
//                                     radius: 28.r,
//                                     backgroundColor: Colors.red,
//                                     child: Icon(
//                                       Icons.pause,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 20.w),
//                                 GestureDetector(
//                                   onTap: () async {
//                                     await voiceCtrl.confirmRecording();
//                                     // Directly show the popup and navigate
//                                     showDialog(
//                                       context: context,
//                                       barrierDismissible: false,
//                                       builder: (context) => BackdropFilter(
//                                         filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                                         child: AlertDialog(
//                                           content: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Icon(Icons.mic, size: 50),
//                                               SizedBox(height: 10.h),
//                                               Text(
//                                                 "Processing your quote...",
//                                                 style: GoogleFonts.urbanist(
//                                                   fontSize: 16.sp,
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                     // Wait for 2 seconds before navigating
//                                     await Future.delayed(const Duration(seconds: 2));
//                                     Navigator.pop(context); // Close the dialog
//                                     Get.to(() => InvoiceAiGenerated()); // Navigate to next page
//                                   },
//                                   child: CircleAvatar(
//                                     radius: 28.r,
//                                     backgroundColor: Colors.green,
//                                     child: Icon(
//                                       Icons.check,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         );
//                       } else if (voiceCtrl.isPaused.value) {
//                         return Column(
//                           children: [
//                             Container(
//                               height: 60.h,
//                               width: double.infinity,
//                               color: Colors.grey[200],
//                               child: Center(
//                                 child: Text(
//                                   "Paused",
//                                   style: GoogleFonts.urbanist(
//                                     fontSize: 14.sp,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 10.h),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 GestureDetector(
//                                   onTap: voiceCtrl.resumeRecording,
//                                   child: CircleAvatar(
//                                     radius: 28.r,
//                                     backgroundColor: Colors.blue,
//                                     child: Icon(
//                                       Icons.play_arrow,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 20.w),
//                                 GestureDetector(
//                                   onTap: () async {
//                                     await voiceCtrl.confirmRecording();
//                                     // Directly show the popup and navigate
//                                     showDialog(
//                                       context: context,
//                                       barrierDismissible: false,
//                                       builder: (context) => BackdropFilter(
//                                         filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                                         child: AlertDialog(
//                                           content: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               Icon(Icons.mic, size: 50),
//                                               SizedBox(height: 10.h),
//                                               Text(
//                                                 "Processing your quote...",
//                                                 style: GoogleFonts.urbanist(
//                                                   fontSize: 16.sp,
//                                                   fontWeight: FontWeight.w600,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                     // Wait for 2 seconds before navigating
//                                     await Future.delayed(const Duration(seconds: 2));
//                                     Navigator.pop(context); // Close the dialog
//                                     Get.to(() => InvoiceAiGenerated()); // Navigate to next page
//                                   },
//                                   child: CircleAvatar(
//                                     radius: 28.r,
//                                     backgroundColor: Colors.green,
//                                     child: Icon(
//                                       Icons.check,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         );
//                       } else {
//                         return GestureDetector(
//                           onTap: voiceCtrl.startRecording,
//                           child: CircleAvatar(
//                             radius: 30.r,
//                             backgroundColor: Colors.black,
//                             child: Icon(
//                               Icons.mic,
//                               color: Colors.white,
//                               size: 30.sp,
//                             ),
//                           ),
//                         );
//                       }
//                     }),
//                   ),
//                   SizedBox(height: 16.h),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
// .......................import 'package:get/get.dart';
// import 'package:record/record.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:path_provider/path_provider.dart';

// class InvoicespeakController extends GetxController {
//   final recorder = AudioRecorder();
//   final player = AudioPlayer();
//   var isRecording = false.obs;
//   var isPaused = false.obs;
//   var recordedFilePath = "".obs;
//   var isPlayed = false.obs;

//   Future<void> startRecording() async {
//     if (await recorder.hasPermission()) {
//       final dir = await getTemporaryDirectory();
//       final filePath =
//           "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.wav";
//       await recorder.start(
//         const RecordConfig(encoder: AudioEncoder.wav, sampleRate: 44100),
//         path: filePath,
//       );
//       recordedFilePath.value = filePath;
//       isRecording.value = true;
//       isPaused.value = false;
//       isPlayed.value = false;
//     }
//   }

//   Future<void> pauseRecording() async {
//     if (isRecording.value) {
//       await recorder.pause();
//       isRecording.value = false;
//       isPaused.value = true;
//     }
//   }

//   Future<void> resumeRecording() async {
//     if (isPaused.value) {
//       await recorder.resume();
//       isRecording.value = true;
//       isPaused.value = false;
//     }
//   }

//   Future<void> stopRecording() async {
//     final path = await recorder.stop();
//     isRecording.value = false;
//     isPaused.value = false;
//     if (path != null) {
//       recordedFilePath.value = path;
//     }
//   }

//   Future<void> cancelRecording() async {
//     await recorder.cancel();
//     isRecording.value = false;
//     isPaused.value = false;
//     recordedFilePath.value = "";
//     isPlayed.value = false;
//   }

//   Future<void> confirmRecording() async {
//     final path = await recorder.stop();
//     isRecording.value = false;
//     isPaused.value = false;
//     if (path != null) {
//       recordedFilePath.value = path;
//     }
//   }

//   @override
//   void onClose() {
//     recorder.dispose();
//     player.dispose();
//     super.onClose();
//   }
// }
