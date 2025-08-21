import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswprdDefault extends StatelessWidget {
  const ResetPasswprdDefault({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 16.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              children: [
                    InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Image(image: AssetImage(IconPath.backicon),width: 18.w,height: 24.h,fit: BoxFit.cover,)),
                    SizedBox(width: 5.w,),
                    Text("Back",style: GoogleFonts.montserrat(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff3A8DFF)
                    ),),
                
              ],
            ),
                SizedBox(height: 14.h,),
                    Center(
                      child: Text("Reset Password",style: GoogleFonts.urbanist(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1C1C1C)
                      ),),
                    ),
                    SizedBox(height: 24.h,),
                    
            ],
          ),
        ),
      ),
    );
  }
}