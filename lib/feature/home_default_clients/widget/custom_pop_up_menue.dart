import 'dart:io';
import 'dart:ui' as ui;

import 'package:fixxa_app/feature/about/screen/about.dart';
import 'package:fixxa_app/feature/client_details/screen/client_details.dart';
import 'package:fixxa_app/feature/invoices/screen/invoices.dart';
import 'package:fixxa_app/feature/notification/screen/notification_data.dart';
import 'package:fixxa_app/feature/quotes_details/screen/quotes_details.dart';
import 'package:fixxa_app/feature/reports/screen/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomPopupMenu extends StatelessWidget {
  const CustomPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: const Color(0xffEBEBEB),
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      icon: Image(
        image: AssetImage(IconPath.three),
        fit: BoxFit.cover,
        width: 24.w,
        height: 24.h,
      ),
      offset: Offset(0, 40.h),
      onSelected: (String value) async {
        switch (value) {
          case 'Clients':
            Get.to(()=>ClientDetails());
            break;
          case 'Quotes':
            Get.to(()=>QuotesDetails());
            break;
          case 'Invoices':
            Get.to(()=>Invoices());

            break;

          case 'Reports':
            Get.to(()=>Reports());
            break;

          case 'Notifications':
            Get.to(()=>NotificationData());

            break;
          case 'About Fixxa':
            Get.to(()=>About());
            break;
          case 'Privacy policy':
            final Uri privacyUri = Uri.parse('https://www.fixxa.co.uk/Fixxa_Privacy_Policy.pdf');
            try {
              if (!await launchUrl(privacyUri, mode: LaunchMode.externalApplication)) {
                Get.snackbar('Error', 'Could not open privacy policy');
              }
            } catch (e) {
              Get.snackbar('Error', 'Could not open privacy policy');
            }

            break;

          case 'Exit':
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return Stack(
                  children: [
                    BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(color: Colors.transparent),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 24.h,
                        ), // Increased vertical padding
                        child: Material(
                          color: Colors.white.withValues(alpha: .9),
                          borderRadius: BorderRadius.circular(32.r),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                            height: 214.h, // Increased height of the container
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  image: AssetImage(IconPath.logoutproject),
                                  width: 48.w,
                                  height: 48.h,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  "Do you want to exit from the app?",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff1C1C1C),
                                  ),
                                ),
                                SizedBox(height: 24.h), // Added more spacing
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        exit(0);
                                      },
                                      child: Container(
                                        width: 162.w,
                                        height: 48.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            999.r,
                                          ),
                                          color: Color(0xff1C1C1C),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Yes, exit",
                                            style: GoogleFonts.urbanist(
                                              color: Color(0xffFFFFFF),
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        width: 162.w,
                                        height: 48.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            999.r,
                                          ),
                                          color: Color(0xffFFFFFF),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "No, keep me in",
                                            style: GoogleFonts.urbanist(
                                              color: Color(0xff172601),
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
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
                    ),
                  ],
                );
              },
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        // buildMenuItem('Clients', Icons.person),
        // buildDivider(),
        // buildMenuItem('Quotes', Icons.chat_bubble_outline),
        // buildDivider(),
        // buildMenuItem('Invoices', Icons.receipt_long_outlined),
        // buildDivider(),
        buildMenuItem('Reports', Icons.report),
        buildDivider(),
        buildMenuItem(
          'Notifications',
          Icons.notifications_outlined,
        ),
        buildDivider(),
        
        buildMenuItem('Privacy policy', Icons.shield_outlined),
        buildDivider(),

        buildMenuItem('Exit', Icons.logout),
      ],
    );
  }

  PopupMenuItem<String> buildMenuItem(
    String value,
    IconData icon, {
    bool showDot = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: SizedBox(
        width: 189.w,
        child: ListTile(
          leading: Icon(icon, color: Color(0xff3A8DFF)),
          title: Row(
            children: [
              Text(value),
              if (showDot) ...[
                SizedBox(width: 8.w),
                Container(
                  width: 7.w,
                  height: 7.h,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> buildDivider() {
    return PopupMenuItem<String>(
      height: 1,
      padding: EdgeInsets.zero,
      enabled: false,
      child: Divider(
        indent: 48,
        height: 1,
        thickness: 1,
        color: const Color(0xffE8E8E8).withValues(alpha: 0.50),
      ),
    );
  }
}
