import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountDefault extends StatelessWidget {
  const CreateAccountDefault({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 7.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               InkWell(
                onTap: (){
                 Navigator.pop(context);
                },
                child: Image(image: AssetImage(IconPath.cross),width: 32.w,height: 32.h,fit: BoxFit.cover,))
              ],
            ),
            SizedBox(
              height: 9.h,
            ),
            Center(child: Image(image: AssetImage(ImagePath.title),fit: BoxFit.cover,height: 42.h,)),
            SizedBox(height: 36.h,),
            Center(
              child: Text("90 days trial FREE",style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w700,
                fontSize: 34.sp,
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