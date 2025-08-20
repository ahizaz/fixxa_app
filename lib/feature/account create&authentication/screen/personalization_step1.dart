import 'package:fixxa_app/feature/account%20create&authentication/controller/personalization_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalizationStep1 extends StatelessWidget {
  const PersonalizationStep1({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalizationController controller = Get.put(PersonalizationController());

    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(padding: EdgeInsetsGeometry.all(16.0),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             
            Row(
  children: [
    Expanded(
      child: Obx(() => LinearProgressIndicator(
            value: controller.currentStep.value,
            minHeight: 5,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          )),
    ),
    SizedBox(width: 16.w),
    Text(
      "1/2",
      style: GoogleFonts.montserrat(
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
          color: Color(0xff000000)),
    )
  ],
),
    SizedBox(height: 34.h,),
    Text("Finish creating your\nFixxa account",style:GoogleFonts.urbanist(
      fontSize: 34.sp,
      fontWeight: FontWeight.w700,
      color: Color(0xff1C1C1C)
    ),),
    SizedBox(height: 16.h,),
    Text("Tell us about you",style: GoogleFonts.montserrat(
      fontSize: 17.sp,
      fontWeight: FontWeight.w400,
      color: Color(0xff434343)
    ),),
    SizedBox(height: 24.h,),
    Container(
      width: double.infinity,
      height: 64.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Color(0xffE8E8E8),
          width: 2
        ),
        
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 14.h),
          hintText: "Your full name",
          hintStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            color: Color(0xff78816C)
          ),
          border: InputBorder.none
        ),
      ),
    ),
    SizedBox(height: 16.h,),
      Container(
      width: double.infinity,
      height: 64.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Color(0xffE8E8E8),
          width: 2
        ),
        
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 14.h),
          hintText: "Business name",
          hintStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            color: Color(0xff78816C)
          ),
          border: InputBorder.none
        ),
      ),
    ),

          ],
        ),
        ),
      ),
    );
  }
}