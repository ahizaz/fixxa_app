import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                    
                     IconButton(
                       icon: const Icon(Icons.close, color: Colors.black),
                       onPressed: () => Navigator.pop(context),
                     ),
                   ],
                 ),
                 SizedBox(height: 16.h,),
                 Text("Upgrade to Fixxa pro",style: GoogleFonts.urbanist( 
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1C1C1C),
                 ),),
                 SizedBox(height: 48.h,),
                 Text("Select a billing option",style: GoogleFonts.montserrat( 
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff434343)
                 ),),
                 SizedBox(height: 16.h,),
                 Row(
                  children: [
                    Expanded(child: Container(
                     height: 71.h,
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: Color(0xffE8E8E8),
                        width: 1.4
                      )
                      
                     ),
                     child: Center(
                      child: Text("Pay monthly",style: GoogleFonts.urbanist(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff1C1C1C)

                      ),),
                     ),
                    )),
                    SizedBox(width: 4.w,),
                         Expanded(child: Container(
                     height: 71.h,
                     decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(
                        color: Color(0xffE8E8E8),
                        width: 1.4
                      )
                      
                     ),
                     child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                            Text("Pay monthly",style: GoogleFonts.urbanist(
                         fontSize: 17.sp,
                         fontWeight: FontWeight.w500,
                         color: Color(0xff1C1C1C)
                       
                       ),),
                          Text("save 20% £39/year",style: GoogleFonts.urbanist(
                         fontSize: 17.sp,
                         fontWeight: FontWeight.w500,
                         color: Color(0xff1C1C1C)
                       
                       ),),
                       
                       ],
                     ),
                    )),
                  ],
                 ),
                 SizedBox(height: 48.h,),
                   Text("Select a membership plan",style: GoogleFonts.montserrat( 
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff434343)
                       ),),
                       SizedBox(height: 16.h,),
                       Container(
                 
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: Color(0xffE8E8E8),
                            width: 1,
                          ),
                          
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 32.h,),
                            Center(
                              child: Text(
                                "Member",style: GoogleFonts.urbanist( 
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff1C1C1C)
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h,),
                              Center(
                              child: Text(
                                "£39 GBP/month",style: GoogleFonts.urbanist( 
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff1C1C1C)
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h,),
                            Center(
                              child: Text("Unlock premium quoting & invoicing tools – \n convert voice to invoices 3x faster. Cancel\n                anytime with one tap",style: GoogleFonts.montserrat( 
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff000000)
                              ),),
                            ),
                            SizedBox(height: 24.h,),
                            Padding(padding: EdgeInsets.symmetric(
                              horizontal: 32.w
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 44.h,
                              decoration: BoxDecoration(
                                color: Color(0xff1C1C1C),
                                borderRadius: BorderRadius.circular(999.r)
                              ),
                              child: Center(
                                child: Text("Continue",style: GoogleFonts.urbanist( 
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffFFFFFF)
                                ),),
                              ),
                            ),
                            ),
                            SizedBox(height: 24.h,),
                          Divider(
                            height: 1,
                        color: Color(0xffE8E8E8),
                        indent: 35,
                        endIndent: 35,
                          ),

                          SizedBox(height: 24.h,),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 32.w),
                            child: Row(
                              children: [
                                Image(image: AssetImage(IconPath.check),width: 20.w,height: 20.h,fit: BoxFit.cover,),
                                SizedBox(width: 12.w,),
                                Text("Voice to invoice conversion",style: GoogleFonts.urbanist( 
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff434343)
                                ),),
                                SizedBox(height: 10.h,),

                              ],
                            ),
                            
                          ),
                          SizedBox(height: 10.h,),
                             Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 32.w),
                            child: Row(
                              children: [
                                Image(image: AssetImage(IconPath.check),width: 20.w,height: 20.h,fit: BoxFit.cover,),
                                SizedBox(width: 12.w,),
                                Text("Voice to invoice conversion",style: GoogleFonts.urbanist( 
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff434343)
                                ),),
                                SizedBox(height: 10.h,),
                                
                              ],
                            ),
                          ),
                           SizedBox(height: 10.h,),
                             Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 32.w),
                            child: Row(
                              children: [
                                Image(image: AssetImage(IconPath.check),width: 20.w,height: 20.h,fit: BoxFit.cover,),
                                SizedBox(width: 12.w,),
                                Text("Priority support",style: GoogleFonts.urbanist( 
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff434343)
                                ),),
                                SizedBox(height: 10.h,),
                                
                              ],
                            ),
                          ),
                          SizedBox(height: 47.h,),
                            
                          ],
                        ),
                       )
              ],
            ),
          ),
        ),
      ),
    );
  }
}