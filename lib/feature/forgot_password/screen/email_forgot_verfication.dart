import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/forgot_password/screen/reset_passwprd_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailForgotVerfication extends StatelessWidget {
  const EmailForgotVerfication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Color(0xffFFFFFF),
             body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 9.h,),
            InkWell(onTap: (){
              Get.back();
            },child: Image(image: AssetImage(IconPath.arrowleft),fit: BoxFit.cover,width: 24.w,height: 24.h,)),
            SizedBox(height: 16.h,),
            Text("Verify your email",style: GoogleFonts.urbanist(
              fontWeight: FontWeight.w700,
              fontSize: 34.sp,
              color: Color(0xff1C1C1C)
            ),),
            SizedBox(height: 16.h,),
            Text("We've sent an email to Steve ***@gmail.com\nClick on link inside to get started",style:GoogleFonts.montserrat(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xff434343)
            ),),
            SizedBox(height: 24.h,),
            InkWell(
              onTap: (){
             Get.to(()=>ResetPasswprdDefault());
              },
              child: Text("Open Mail App",style: GoogleFonts.urbanist(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff3A8DFF)
              ),),
            ),
            SizedBox(height: 24.h,),
            Text("Resend email",style: GoogleFonts.urbanist(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xff3A8DFF)
            ),)
            ],
          ),
        ),
      ),
    );
  }
}