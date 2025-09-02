
import 'dart:io';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/client.dart';
import 'package:fixxa_app/feature/home_default_clients/screen/quotes.dart';
import 'package:fixxa_app/feature/home_default_clients/widget/custom_pop_up_menue.dart';
import 'package:fixxa_app/feature/home_default_clients/widget/state_item_widget.dart';
import 'package:fixxa_app/feature/profile/screen/profile_screen.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
class HomeDefaultClients extends StatelessWidget {
  const HomeDefaultClients({super.key});
  @override
  Widget build(BuildContext context) {
    final PersonalizationController controller =
        Get.put(PersonalizationController());
    final HomeDefaultController homeController =
        Get.put(HomeDefaultController());
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center, // Vertically center align items
                  children: [
                    CustomPopupMenu(),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Image(
                        image: AssetImage(ImagePath.fixxa),
                        width: 110.w,
                        height: 25.h,
                        fit: BoxFit.cover, // আগের মতোই cover থাকবে
                      ),
                    ),

                    Spacer(),
                    Container(
                      height: 48.h,
                     width: 137.w,
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
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis, 
                          maxLines: 1,
                          style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff1C1C1C),
                          ),
                        ),
                      ),
                    ),
                
                    InkWell(
                      onTap: (){
                        Get.to(ProfileScreen());
                      },
                      child: Container(
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
                            buildStatItem(
                              value: homeController
                                  .sent.value, // Sent from controller
                              color: Color(0xff00FFFF),
                              label: "Sent",
                              count: homeController.sent.value.toInt(),
                            ),
                            buildStatItem(
                              value: homeController.won.value /
                                  homeController
                                      .sent.value, // Won percentage
                              color: Color(0xffFFFF00),
                              label: "Won",
                              count: homeController.won.value.toInt(),
                            ),
                            buildStatItem(
                              value: homeController.lost.value /
                                  homeController
                                      .sent.value, // Lost percentage
                              color: Color(0xffD94E2E).withValues(alpha:  0.33), // Corrected withOpacity
                              label: "Lost",
                              count: homeController.lost.value.toInt(),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => homeController.switchTab(0),
                              child: Column(
                                children: [
                                  Text(
                                    "Clients",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          homeController.selectedTab.value == 0
                                              ? Color(0xff3A8DFF)
                                              : Color(0xff434343),
                                    ),
                                  ),
                                  if (homeController.selectedTab.value == 0)
                                    Container(
                                      margin: EdgeInsets.only(top: 4.h),
                                      height: 2.h,
                                      width: 40.w,
                                      color: Color(0xff3A8DFF),///....
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            GestureDetector(
                              onTap: () => homeController.switchTab(1),
                              child: Column(
                                children: [
                                  Text(
                                    "Quotes",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          homeController.selectedTab.value == 1
                                              ? Color(0xff3A8DFF)
                                              : Color(0xff434343),
                                    ),
                                  ),
                                  if (homeController.selectedTab.value == 1)
                                    Container(
                                      margin: EdgeInsets.only(top: 4.h),
                                      height: 2.h,
                                      width: 54.w,
                                      color: Color(0xff3A8DFF),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                       
                        homeController.selectedTab.value == 0
                            ? Row(
                                children: [
                                  Image(
                                    image: AssetImage(ImagePath.import),
                                    width: 24.w,
                                    height: 24.h,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Import",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff3A8DFF),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Icon(Icons.add,
                                      color: Color(0xff3A8DFF), size: 18.sp),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "New folder",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff3A8DFF),
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    )),
                SizedBox(height: 20.h),

            
                Obx(() {
                  if (homeController.selectedTab.value == 0) {
                    return Client();
                  } else {
                    return Quotes();
                  }
                }),
                SizedBox(height: 41.h),
                Center(
                  child: Container(
                    height: 68.h,
                    width: 190.w, // responsive রাখছেন
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24.r),
                      color: const Color(0xffFFFFFF).withValues(alpha: 0.60),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xffE8E8E8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff000000).withValues(alpha: 0.12),
                          offset: const Offset(0, 0),
                          blurRadius: 25,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      child: Row(
                        children: [
                          /// Left Icon
                                                 Flexible(
                          flex: 2,
                          child: InkWell(
                            onTap: () {
                              // This onTap will not be directly used if PopupMenuButton handles the tap.
                              // However, if you want some action to happen even if the menu isn't opened, you can keep it.
                            },
                            child: PopupMenuButton<String>(
                              offset: Offset(-90, -180), // Adjust the Y-offset as needed (e.g., -120 pixels upwards)
                              icon: Icon(
                                Icons.add,
                                color: const Color(0xff434343),
                                size: 24,
                              ),
                              onSelected: (String result) {
                                // Handle the selected option here
                                if (result == 'scan') {
                                    Get.to(() =>
                                        const ScannerScreen());
                                  // Add your navigation or logic for Scan
                                } else if (result == 'camera') {
                              
                                  // Add your navigation or logic for Camera
                                } else if (result == 'new_invoice') {
                                
                                  // Add your navigation or logic for New Invoice
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'scan',
                                  child: Row(
                                    children: [
                                      Image.asset(IconPath.scan, width: 24.w, height: 24.h), // Assuming you have a scan icon
                                      SizedBox(width: 12.w),
                                      Text('Scan',style: GoogleFonts.urbanist( 
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff7B7B7B)
                                      ),),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'camera',
                                  child: Row(
                                    children: [
                                       Image.asset(IconPath.cameras, width: 24.w, height: 24.h),
                                      SizedBox(width: 12.w),
                                          Text('Camera',style: GoogleFonts.urbanist( 
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff7B7B7B)
                                      ),),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'new_invoice',
                                  child: Row(
                                    children: [
                                   Image.asset(IconPath.filepen, width: 24.w, height: 24.h),
                                      SizedBox(width: 12.w),
                                        Text('New Invoice',style: GoogleFonts.urbanist( 
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff7B7B7B)
                                      ),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                          SizedBox(width: 15.w),

                          Flexible(
                            flex: 3,
                            child: Image.asset(
                              ImagePath.ball,
                           
                              height: 56.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Spacer(),
                          Flexible(
                            flex: 1,
                            child: Image.asset(
                              IconPath.mic,
                              width: 24.w,
                              height: 24.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h)
              ],
            ),
          ),
        ),
      ),
    );
  }
}