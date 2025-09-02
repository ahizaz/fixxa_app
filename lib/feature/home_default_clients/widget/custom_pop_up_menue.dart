import 'package:fixxa_app/feature/about/screen/about.dart';
import 'package:fixxa_app/feature/client_details/screen/client_details.dart';
import 'package:fixxa_app/feature/invoices/screen/invoices.dart';
import 'package:fixxa_app/feature/notification/screen/notification_data.dart';
import 'package:fixxa_app/feature/notification_preferences/screen/notification_screen.dart';
import 'package:fixxa_app/feature/privacy_policy.dart/screen/privacy_policy.dart';
import 'package:fixxa_app/feature/quotes_details/screen/quotes_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:get/get.dart';

class CustomPopupMenu extends StatelessWidget {
  const CustomPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: const Color(0xffEBEBEB),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      icon: Image(
        image: AssetImage(IconPath.three),
        fit: BoxFit.cover,
        width: 24.w,
        height: 24.h,
      ),
      offset: Offset(0, 40.h),
      onSelected: (String value) {
        switch (value) {
          case 'Clients':
           Get.to(ClientDetails());
            break;
          case 'Quotes':
           Get.to(QuotesDetails());
            break;
          case 'Invoices':
          Get.to(Invoices());
           
            break;
          case 'Notifications':
           Get.to(NotificationData());
           
            break;
          case 'About Fixxa':
           Get.to(About());
            break;
          case 'Privacy policy':
          Get.to(PrivacyPolicy());
           
            break;
          case 'Rate us':
            
            break;
          case 'Exit':
       
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        buildMenuItem('Clients', Icons.person),
        buildDivider(),
        buildMenuItem('Quotes', Icons.chat_bubble_outline),
        buildDivider(),
        buildMenuItem('Invoices', Icons.receipt_long_outlined),
        buildDivider(),
        buildMenuItem('Notifications', Icons.notifications_outlined, showDot: true),
        buildDivider(),
        buildMenuItem('About Fixxa', Icons.info_outline),
        buildDivider(),
        buildMenuItem('Privacy policy', Icons.shield_outlined),
        buildDivider(),
        buildMenuItem('Rate us', Icons.star_outline),
        buildDivider(),
        buildMenuItem('Exit', Icons.logout),
      ],
    );
  }

  PopupMenuItem<String> buildMenuItem(String value, IconData icon, {bool showDot = false}) {
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
                )
              ]
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
