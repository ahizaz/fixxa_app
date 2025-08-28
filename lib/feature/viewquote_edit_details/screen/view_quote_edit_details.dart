
import 'dart:ui';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/home_default_clients/controller/home_default_controller.dart';
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
    return Obx((){
      final data = homeController.quoteData[quoteIndex];
     return Scaffold(
        backgroundColor: const Color(0xffF8F8FF),
        body: SafeArea(child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // This outer Row now correctly takes up available width
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
                      const Spacer(), // This Spacer will now correctly fill the space
                      PopupMenuButton<String>(
                        icon: Image(
                          image: const AssetImage(IconPath.clienthreedots),
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.cover,
                        ),
                        offset: Offset(0, 48.h),
                        onSelected: (String result){
                          if(result=='edit'){
                            // Handle edit
                          }else if(result == 'remove'){
                            Get.dialog(
                              Stack(
                                children: [
                                  Positioned.fill(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.3), // Corrected withValues to withOpacity
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
                                                      // Handle remove
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
                               Image(image: AssetImage(IconPath.penline,),width: 24.w,height: 24.h,fit: BoxFit.cover,color: Color(0xff3ABDFF),),
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
                              Image(image: AssetImage(IconPath.trash),
                              width: 18.w,
                              height: 20.h,
                              fit: BoxFit.cover,
                              color: Color(0xffD94E2E),
                              ),
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
                        color: const Color(0xffF2F2F2), // Background color of the pop-up
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
                          backgroundImage: AssetImage(data[ "image"]), // Use client's image
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          data[ "name"], // Use client's name
                          style: GoogleFonts.urbanist(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          data["email"], // Use client's email
                          style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          data["phone"], // Use client's phone
                          style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffFFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
          ),
           ),
        )
        ),

     );
    });
  }
}