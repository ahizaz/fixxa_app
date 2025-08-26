import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Invoices extends StatelessWidget {
  const Invoices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: Color(0xffFFFFFF),
   body: SafeArea(child: SingleChildScrollView(
    child: Padding(padding:EdgeInsets.symmetric(horizontal: 6.w),
    child: Column(
       mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image(
                          image: const AssetImage(IconPath.cross),
                          width: 32.w,
                          height: 32.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.add, color: const Color(0xff3A8DFF), size: 18.sp),
                      SizedBox(width: 10.w),
                      Text(
                        "Add Contact",
                        style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff3A8DFF),
                        ),
                      ),
                    ],
                  ),
                ),
                    Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                  child: Text(
                    "Invoices",
                    style: GoogleFonts.urbanist(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                ),
      ],
    ),
    
    ),

   )),
    );
  }
}