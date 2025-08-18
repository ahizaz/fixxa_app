import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/account%20create&authentication/screen/create_account_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeSceen extends StatelessWidget {
  const WelcomeSceen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(ImagePath.welcomeScreen),fit: BoxFit.cover)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             InkWell(
              onTap: (){
               Get.to(()=>CreateAccountDefault());
              },
               child: Container(
                 margin: EdgeInsets.only(bottom: 30.h),
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(999.r)
                ),
                child: Center(
                  child: Text("Join",style: GoogleFonts.urbanist(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff1C1C1C)
                  ),),
                ),
               ),
             ),

             InkWell(
              onTap: (){

              },
               child: Center(
                child: Text("Sign In",style: GoogleFonts.urbanist(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffFFFFFF),
                ),),
               ),
             ),
             SizedBox(height: 24.h,),


            ],
          ),
        ),
      ),
    );
  }
}