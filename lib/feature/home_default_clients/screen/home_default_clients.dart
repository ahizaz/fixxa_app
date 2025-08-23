// import 'dart:io';
// import 'package:fixxa_app/core/utils/constants/icon_path.dart';
// import 'package:fixxa_app/core/utils/constants/image_path.dart';
// import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HomeDefaultClients extends StatelessWidget {
//   const HomeDefaultClients({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final PersonalizationController controller = Get.put(PersonalizationController());
//     double sent = 12;
//     double won = 8;
//     double lost = 4;
//     return Scaffold(
//       backgroundColor: Color(0xffF8F8F8),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(top: 10.h),
//                     child: InkWell(
//                       onTap: () {},
//                       child: Image(
//                         image: AssetImage(IconPath.thereedots),
//                         fit: BoxFit.cover,
//                         width: 24.w,
//                         height: 24.h,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 20.w),
//                   Padding(
//                     padding: EdgeInsets.only(top: 10.h),
//                     child: Image(
//                       image: AssetImage(ImagePath.fixxa),
//                       width: 110.w,
//                       height: 25.h,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Spacer(),
//                   Container(
//                     width: 137.w,
//                     height: 48.h,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(999.r),
//                       border: Border.all(
//                         width: 1,
//                         color: Color(0xffE8E8E8),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "€ 14,568 earned",
//                         style: GoogleFonts.montserrat(
//                           fontSize: 15.sp,
//                           fontWeight: FontWeight.w400,
//                           color: Color(0xff1C1C1C),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   Container(
//                     width: 48.w,
//                     height: 48.h,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         width: 1,
//                         color: Color(0xffE8E8E8),
//                       ),
//                     ),
//                     child: Obx(
//                       () => controller.selectedImage.value == null
//                           ? const SizedBox.shrink()
//                           : ClipOval(
//                               child: Image.file(
//                                 File(controller.selectedImage.value!.path),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.h),
//               Center(
//                 child: Text(
//                   "Good afternoon, Lee!",
//                   style: GoogleFonts.urbanist(
//                     fontSize: 28.sp,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xff1C1C1C),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24.h),
//               SizedBox(
//                 width: double.infinity,
//                 height: 191.h,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage(ImagePath.backgroundContainer),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(left: 16.w, top: 16.h),
//                         child: Text(
//                           "Quote Stats",
//                           style: GoogleFonts.urbanist(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 16.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildStatItem(
//                             value: 1.0, // Sent is always 100%
//                             color: Color(0xff00FFFF),
//                             label: "Sent",
//                             count: sent.toInt(),
//                           ),
//                           _buildStatItem(
//                             value: won / sent, // Won percentage
//                             color: Color(0xffFFFF00),
//                             label: "Won",
//                             count: won.toInt(),
//                           ),
//                           _buildStatItem(
//                             value: lost / sent, // Lost percentage
//                             color: Color(0xffFF4500),
//                             label: "Lost",
//                             count: lost.toInt(),
//                           ),
//                         ],
//                       ),
//                       // =========== END OF CORRECTION ===========
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper widget to avoid code repetition
//   Widget _buildStatItem({
//     required double value,
//     required Color color,
//     required String label,
//     required int count,
//   }) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: 60.w,
//           height: 60.h,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: color.withOpacity(0.6),
//                 blurRadius: 10,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // Background Track
//               CircularProgressIndicator(
//                 value: 1.0, // Full circle
//                 strokeWidth: 6.w, // A thicker stroke
//                 backgroundColor: Colors.transparent,
//                 color: color.withOpacity(0.3), // Semi-transparent track
//               ),
//               // Foreground Progress
//               CircularProgressIndicator(
//                 value: value,
//                 strokeWidth: 6.w, // A thicker stroke
//                 backgroundColor: Colors.transparent,
//                 color: color,
//                 strokeCap: StrokeCap.round, // Key Change: for rounded ends
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Text(
//           label,
//           style: GoogleFonts.urbanist(
//             fontSize: 16.sp,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Text(
//           "$count",
//           style: GoogleFonts.urbanist(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:io';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDefaultClients extends StatelessWidget {
  const HomeDefaultClients({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalizationController controller = Get.put(PersonalizationController());
    double sent = 12;
    double won = 8;
    double lost = 4;
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: InkWell(
                      onTap: () {},
                      child: Image(
                        image: AssetImage(IconPath.thereedots),
                        fit: BoxFit.cover,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Image(
                      image: AssetImage(ImagePath.fixxa),
                      width: 110.w,
                      height: 25.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 137.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999.r),
                      border: Border.all(
                        width: 1,
                        color: Color(0xffE8E8E8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "€ 14,568 earned",
                        style: GoogleFonts.montserrat(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff1C1C1C),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1,
                        color: Color(0xffE8E8E8),
                      ),
                    ),
                    child: Obx(
                      () => controller.selectedImage.value == null
                          ? const SizedBox.shrink()
                          : ClipOval(
                              child: Image.file(
                                File(controller.selectedImage.value!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "Good afternoon, Lee!",
                  style: GoogleFonts.urbanist(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff1C1C1C),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 191.h,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagePath.backgroundContainer),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.w, top: 16.h),
                        child: Text(
                          "Quote Stats",
                          style: GoogleFonts.urbanist(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(
                            value: 1.0, // Sent is always 100%
                            color: Color(0xff00FFFF),
                            label: "Sent",
                            count: sent.toInt(),
                          ),
                          _buildStatItem(
                            value: won / sent, // Won percentage
                            color: Color(0xffFFFF00),
                            label: "Won",
                            count: won.toInt(),
                          ),
                          _buildStatItem(
                            value: lost / sent, // Lost percentage
                            color: Color(0xffFF4500),
                            label: "Lost",
                            count: lost.toInt(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to avoid code repetition
  Widget _buildStatItem({
    required double value,
    required Color color,
    required String label,
    required int count,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.6),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Track (hollow circle with no fill)
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withOpacity(0.3),
                    width: 6.w,
                  ),
                ),
              ),
              // Foreground Progress (hollow with no inner color)
              Padding(
                padding: EdgeInsets.all(3.w), // Adjust padding to create hollow center
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 6.w,
                  backgroundColor: Colors.transparent,
                  color: color,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          "$count",
          style: GoogleFonts.urbanist(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}