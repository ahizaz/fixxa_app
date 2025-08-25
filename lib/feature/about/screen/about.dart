// import 'package:fixxa_app/core/utils/constants/icon_path.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class About extends StatelessWidget {
//   const About({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF8F8FF),
//       body: SafeArea(
//         child: Padding(
//           padding:  EdgeInsets.symmetric(horizontal: 16.w),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           Get.back();
//                         },
//                         child: Image(
//                           image: const AssetImage(IconPath.backicon),
//                           width: 18.w,
//                           height: 24.h,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       SizedBox(width: 5.w),
//                       Text(
//                         "Back",
//                         style: GoogleFonts.montserrat(
//                           fontSize: 17.sp,
//                           fontWeight: FontWeight.w400,
//                           color: const Color(0xff3A8DFF),
//                         ),
//                       ),
                      
//                       Center(
//                         child: Text("About",style: GoogleFonts.urbanist(
//                           fontSize: 17.sp,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xff000000)
//                         ),),
//                       )
//                     ],
//                   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8FF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           
              SizedBox(
                height: 48.h, 
                child: Stack(
                  alignment: Alignment.center, 
                  children: [
                  
                    Text(
                      "About",
                      style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff000000)),
                    ),
        
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
                          "Back",
                          style: GoogleFonts.montserrat(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff3A8DFF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 26.h,),
              Container(
                width: double.infinity,
           
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Version",style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff434343)
                          ),),
                          Spacer(),
                          Text("2.5.07",style: GoogleFonts.montserrat(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff434343)
                          ),)
                        ],
                      ),
                      SizedBox(height: 16.h,),
                             Row(
                        children: [
                          Text("Terms of use",style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff434343)
                          ),),
                          Spacer(),
                         Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                  size: 24.sp,
                                ),
                        ],
                      ),
                           SizedBox(height: 16.h,),
                                Row(
                        children: [
                          Text("Visit us",style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff434343)
                          ),),
                          Spacer(),
                       Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                  size: 24.sp,
                                ),
                        ],
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}