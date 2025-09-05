import 'dart:ui';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:fixxa_app/feature/viewquote_edit_details/screen/edit_quote_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewQuoteEditDetails extends StatelessWidget {
  final int quoteIndex;
  const ViewQuoteEditDetails({super.key, required this.quoteIndex});
  @override
  Widget build(BuildContext context) {
    final HomeDefaultController homeController = Get.find<HomeDefaultController>();
    return Obx(() {
      final data = homeController.quoteData[quoteIndex];
      return Scaffold(
        backgroundColor: const Color(0xffF8F8FF),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Image(
                          image: const AssetImage(IconPath.backicon),
                          width: 18.w,
                          height: 24.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "Quote details",
                        style: GoogleFonts.montserrat(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff3A8DFF),
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton<String>(
                        icon: Image(
                          image: const AssetImage(IconPath.clienthreedots),
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.cover,
                        ),
                        offset: Offset(0, 48.h),
                        onSelected: (String result) {
                          if (result == 'edit') {
                              Get.to(() => EditQuoteDetails(quoteIndex: quoteIndex));
                          } else if (result == 'remove') {
                            Get.dialog(
                              Stack(
                                children: [
                                  Positioned.fill(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                      child: Container(
                                        color: Colors.black.withValues(alpha: .3),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: 300.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12.r),
                                        border: Border.all(color: const Color(0xffE8E8E8)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(16.w),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Are you sure you want to remove the client from your Fixxa account?",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.urbanist(
                                                decoration: TextDecoration.none,
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff1C1C1C),
                                              ),
                                            ),
                                            SizedBox(height: 24.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                      height: 48.h,
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xff1C1C1C),
                                                        borderRadius: BorderRadius.circular(999.r),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "No, Keep it",
                                                          style: GoogleFonts.montserrat(
                                                            fontSize: 15.sp,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.white,
                                                            decoration: TextDecoration.none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      homeController.quoteData.removeAt(quoteIndex);
                                                         Get.close(2);
                                                    },
                                                    child: Container(
                                                      height: 48.h,
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xffD94E2E),
                                                        borderRadius: BorderRadius.circular(999.r),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Yes, Remove",
                                                          style: GoogleFonts.montserrat(
                                                            fontSize: 15.sp,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.white,
                                                            decoration: TextDecoration.none,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              barrierDismissible: false,
                              barrierColor: Colors.transparent,
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Image(image: AssetImage(IconPath.penline), width: 24.w, height: 24.h, fit: BoxFit.cover, color: Color(0xff3ABDFF)),
                                SizedBox(width: 10.w),
                                Text(
                                  'Edit client details',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff434343),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'remove',
                            child: Row(
                              children: [
                                Image(image: AssetImage(IconPath.trash), width: 18.w, height: 20.h, fit: BoxFit.cover, color: Color(0xffD94E2E)),
                                SizedBox(width: 18.w),
                                Text(
                                  'Delete folder',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff1C1C1C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        color: const Color(0xffF2F2F2),
                        elevation: 8,
                      )
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    width: double.infinity,
                    height: 188.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage(ImagePath.backgroundContainer),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40.r,
                          backgroundImage: AssetImage(data["image"]),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          data["name"],
                          style: GoogleFonts.urbanist(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          data["email"],
                          style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          data["phone"],
                          style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    "Quotes (${data["quotes"]})",
                    style: GoogleFonts.urbanist(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                  _buildJobItem("Plumbing", "London, UK", "17 Mar, 2025", "Pending", "£120 earned"),
                  _buildJobItem("Plumbing", "London, UK", "17 Mar, 2025", "Won", "£240 earned"),
                  _buildJobItem("Electric service", "London, UK", "17 Mar, 2025", "Lost", "£99 earned"),
                  _buildJobItem("Electric service", "London, UK", "17 Mar, 2025", "Lost", "£99 earned"),
                  SizedBox(height: 34.h),
                //  Center(
                //   child: Container(
                //     height: 68.h,
                //     width: 190.w, // responsive রাখছেন
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(24.r),
                //       color: const Color(0xffFFFFFF).withValues(alpha: 0.60),
                //       border: Border.all(
                //         width: 1,
                //         color: const Color(0xffE8E8E8),
                //       ),
                //       boxShadow: [
                //         BoxShadow(
                //           color: const Color(0xff000000).withValues(alpha: 0.12),
                //           offset: const Offset(0, 0),
                //           blurRadius: 25,
                //         )
                //       ],
                //     ),
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(
                //           horizontal: 12.w, vertical: 6.h),
                //       child: Row(
                //         children: [
                //           /// Left Icon
                //                                  Flexible(
                //           flex: 2,
                //           child: InkWell(
                //             onTap: () {
                //             },
                //             child: PopupMenuButton<String>(
                //               offset: Offset(-90, -180), // Adjust the Y-offset as needed (e.g., -120 pixels upwards)
                //               icon: Icon(
                //                 Icons.add,
                //                 color: const Color(0xff434343),
                //                 size: 24,
                //               ),
                //               onSelected: (String result) {
                //                 // Handle the selected option here
                //                 if (result == 'scan') {
                //                     Get.to(() =>
                //                         const ScannerScreen());
                                 
                //                 } else if (result == 'camera') {
                              
                                
                //                 } else if (result == 'new_invoice') {
                                
                //                   // Add your navigation or logic for New Invoice
                //                 }
                //               },
                //               itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                //                 PopupMenuItem<String>(
                //                   value: 'scan',
                //                   child: Row(
                //                     children: [
                //                       Image.asset(IconPath.scan, width: 24.w, height: 24.h), // Assuming you have a scan icon
                //                       SizedBox(width: 12.w),
                //                       Text('Scan',style: GoogleFonts.urbanist( 
                //                         fontSize: 17.sp,
                //                         fontWeight: FontWeight.w500,
                //                         color: Color(0xff7B7B7B)
                //                       ),),
                //                     ],
                //                   ),
                //                 ),
                //                 PopupMenuItem<String>(
                //                   value: 'camera',
                //                   child: Row(
                //                     children: [
                //                        Image.asset(IconPath.cameras, width: 24.w, height: 24.h),
                //                       SizedBox(width: 12.w),
                //                           Text('Camera',style: GoogleFonts.urbanist( 
                //                         fontSize: 17.sp,
                //                         fontWeight: FontWeight.w500,
                //                         color: Color(0xff7B7B7B)
                //                       ),),
                //                     ],
                //                   ),
                //                 ),
                //                 PopupMenuItem<String>(
                //                   value: 'new_invoice',
                //                   child: Row(
                //                     children: [
                //                    Image.asset(IconPath.filepen, width: 24.w, height: 24.h),
                //                       SizedBox(width: 12.w),
                //                         Text('New Invoice',style: GoogleFonts.urbanist( 
                //                         fontSize: 17.sp,
                //                         fontWeight: FontWeight.w500,
                //                         color: Color(0xff7B7B7B)
                //                       ),),
                //                     ],
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),

                //           SizedBox(width: 15.w),

                //           Flexible(
                //             flex: 3,
                //             child: Image.asset(
                //               ImagePath.ball,
                           
                //               height: 56.h,
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //           const Spacer(),
                //           Flexible(
                //             flex: 1,
                //             child: Image.asset(
                //               IconPath.mic,
                //               width: 24.w,
                //               height: 24.h,
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                              SizedBox(
  width: double.infinity,
  height: 94.h,
  child: Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(ImagePath.mainbutton),
        fit: BoxFit.contain,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: 30), // left padding
            Image.asset(
              IconPath.plus,
              width: 24.w,
              height: 24.h,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 20), // gap between plus & scan
            Image.asset(
              IconPath.scantext,
              width: 24.w,
              height: 24.h,
              fit: BoxFit.cover,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: 40), // right padding
          child: Image.asset(
            IconPath.voiceai,
            width: 56.w,
            height: 56.h,
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  ),
),

                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildJobItem(String service, String location, String date, String status, String earnings) {
    Color statusBackgroundColor;
    switch (status) {
      case "Pending":
        statusBackgroundColor = const Color(0xffCA9846); // Yellow for Pending
        break;
      case "Won":
        statusBackgroundColor = const Color(0xffF2CB05); // Green for Won
        break;
      case "Lost":
        statusBackgroundColor = const Color(0xffD94E2E); // Red for Lost
        break;
      default:
        statusBackgroundColor = const Color(0xff0B8E5E); // Default green
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xffE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service,
            style: GoogleFonts.urbanist(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1C1C1C),
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Image(image: const AssetImage(IconPath.flag), width: 12.w, height: 12.h),
              SizedBox(width: 4.w),
              Text(
                location,
                style: GoogleFonts.montserrat(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff434343),
                ),
              ),
              SizedBox(width: 12.w),
              const Icon(Icons.circle, size: 6, color: Color(0xffBDBDBD)),
              SizedBox(width: 12.w),
              Image(image: const AssetImage(IconPath.clock), width: 16.w, height: 16.h),
              SizedBox(width: 4.w),
              Text(
                date,
                style: GoogleFonts.montserrat(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff434343),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBackgroundColor, // Use the dynamically determined color
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.montserrat(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffFFFFFF),
                  ),
                ),
              ),
              Text(
                earnings,
                style: GoogleFonts.montserrat(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff3A8DFF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}