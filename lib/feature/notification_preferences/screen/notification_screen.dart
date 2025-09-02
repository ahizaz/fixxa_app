
import 'package:fixxa_app/feature/notification_preferences/controller/notification_controller.dart';
import 'package:fixxa_app/feature/notification_preferences/widget/notification_toggle_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: const Color(0xffF8F8FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                 
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

             Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Notification settings',
                style: GoogleFonts.urbanist(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff1C1C1C)
                ),
              ),
            ),
           Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.h),
              child: Text(
                'Updates and promotions',
                style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1C1C1C),
                  fontSize: 17.sp,
                ),
              ),
            ),
              Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Text(
                'Be the first to know about new features, promo codes\nand deals',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff434343),
                  fontSize: 13.sp,
                ),
              ),
            ),

                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
                      child: Container(
                             
                                   
                                    decoration: BoxDecoration(
                                      color: Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.circular(16.r),
                               
                      
                                    ),
                                    child: Column(
                                      children: [
                                        Obx(() => NotificationToggleTile(
                          title: 'Email',
                          value: controller.emailUpdates.value,
                          onChanged: controller.toggleEmailUpdates,
                        )),
                        
                        Divider(
                          indent: 20,
                          endIndent: 25,
                   
                        ),
                                        Obx(() => NotificationToggleTile(
                          title: 'SMS',
                          value: controller.smsUpdates.value,
                          onChanged: controller.toggleSmsUpdates,
                        )),
                           Divider(
                          indent: 20,
                          endIndent: 25,
                   
                        ),
                                        Obx(() => NotificationToggleTile(
                          title: 'Push notifications',
                          value: controller.pushUpdates.value,
                          onChanged: controller.togglePushUpdates,
                        )),
                                      ],
                                    ),
                                  ),
                    ),

 SizedBox(height: 16.h),
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Reminders',
                style: GoogleFonts.urbanist(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1C1C1C),
                ),
              ),
            ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Text(
                'Get reminders about payment, invoice tracking, quote won and lost',
                style: GoogleFonts.montserrat(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff434343)
                ),
              ),
            ),

            Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
                      child: Container(
                             
                                   
                                    decoration: BoxDecoration(
                                      color: Color(0xffFFFFFF),
                                      borderRadius: BorderRadius.circular(16.r),
                               
                      
                                    ),
                                    child: Column(
                                      children: [
                                        Obx(() => NotificationToggleTile(
                          title: 'Email',
                          value: controller.emailUpdates.value,
                          onChanged: controller.toggleEmailUpdates,
                        )),
                        
                        Divider(
                          indent: 20,
                          endIndent: 25,
                   
                        ),
                                        Obx(() => NotificationToggleTile(
                          title: 'SMS',
                          value: controller.smsUpdates.value,
                          onChanged: controller.toggleSmsUpdates,
                        )),
                           Divider(
                          indent: 20,
                          endIndent: 25,
                   
                        ),
                                        Obx(() => NotificationToggleTile(
                          title: 'Push notifications',
                          value: controller.pushUpdates.value,
                          onChanged: controller.togglePushUpdates,
                        )),
                                      ],
                                    ),
                                  ),
                    ),

            const SizedBox(height: 20),
    
          ],
        ),
      ),
    );
  }
}
