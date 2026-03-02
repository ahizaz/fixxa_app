import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/notification/controller/notficationdatacontroller.dart';
import 'package:fixxa_app/feature/notification/widget/notification_item.dart';

import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/add_client.dart';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_creation.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationData extends StatelessWidget {
  const NotificationData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotficationcontrollerData());
    controller.loadNotifications();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GestureDetector(
            onTap: () async {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset buttonPosition = button.localToGlobal(
                Offset.zero,
                ancestor: overlay,
              );
              final result = await showMenu(
                context: context,
                position: RelativeRect.fromRect(
                  Rect.fromLTWH(
                    buttonPosition.dx - 100,
                    buttonPosition.dy + 100,
                    button.size.width,
                    button.size.height,
                  ),
                  Offset.zero & overlay.size,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: Colors.grey[200],
                items: [
                  PopupMenuItem(
                    value: 'mark_all_read',
                    child: Container(
                      color: Colors.transparent,
                      child: Text(
                        'Mark all as read',
                        style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff434343),
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clear_all',
                    child: Container(
                      color: Colors.transparent,
                      child: Text(
                        'Clear all',
                        style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffD94E2E),
                        ),
                      ),
                    ),
                  ),
                ],
              );
              if (result == 'mark_all_read') {
              } else if (result == 'clear_all') {
                controller.notifications.clear();
              }
            },
            child: Image.asset(IconPath.three, height: 30.h, width: 30.w),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notification",
              style: GoogleFonts.urbanist(
                fontSize: 34.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff1C1C1C),
              ),
            ),
            const SizedBox(height: 7.5),
            Row(
              children: [
                Image(
                  image: AssetImage(IconPath.fire),
                  height: 24.h,
                  width: 24.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Priority",
                  style: GoogleFonts.montserrat(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff434343),
                  ),
                ),
              ],
            ),
            SizedBox(height: 11.h),
            Expanded(
              child: Obx(() {
                return ListView.separated(
                  itemCount: controller.notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final item = controller.notifications[index];
                    switch (item.type) {
                      case 'overdue':
                        return _buildOverdueInvoiceNotification(item);
                      case 'quote':
                        return _buildQuoteReminderNotification(item);
                      case 'paid':
                        return _buildPaidInvoiceNotification(item);
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 94.h + 40.h, // Button height + 40.h gap
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 94.h,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImagePath.mainbutton),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Builder(
                          builder: (context) {
                            return InkWell(
                              onTap: () async {
                                final RenderBox box =
                                    context.findRenderObject() as RenderBox;
                                final Offset position = box.localToGlobal(
                                  Offset.zero,
                                );

                                final result = await showMenu<String>(
                                  context: context,
                                  color: const Color(0xffF2F2F2),
                                  position: RelativeRect.fromLTRB(
                                    position.dx,
                                    position.dy - 120,
                                    position.dx + 100,
                                    0,
                                  ),
                                  items: [
                                    PopupMenuItem(
                                      value: 'quote',
                                      child: Row(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                              IconPath.createquote,
                                            ),
                                            height: 24.h,
                                            width: 24.w,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Create Quote",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff1C1C1C),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'invoice',
                                      child: Row(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                              IconPath.createinvoice,
                                            ),
                                            height: 24.h,
                                            width: 24.w,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Create Invoice",
                                            style: GoogleFonts.urbanist(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff1C1C1C),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'add_client',
                                      child: Row(
                                        children: [
                                          Icon(Icons.person_add, size: 24),
                                          SizedBox(width: 8),
                                          const Text('Add Client'),
                                        ],
                                      ),
                                    ),
                                  ],
                                );

                                if (result == 'quote') {
                                  // Set navigation source for other pages
                                  SpotlightService.instance.setNavigationSource('other');
                                  QuoteDialog.show(context);
                                } else if (result == 'invoice') {
                                  // Set navigation source for other pages
                                  SpotlightService.instance.setNavigationSource('other');
                                  InvoiceDialog.show(context);
                                } else if (result == 'add_client') {
                                  Get.to(() => const AddClient());
                                }
                              },
                              child: Image.asset(
                                IconPath.plus,
                                width: 24.w,
                                height: 24.h,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            Get.to(() => ScannerScreen());
                          },
                          child: Image.asset(
                            IconPath.scantext,
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: InkWell(
                        onTap: () {
                          showCustomDialog(context);
                        },
                        child: Image.asset(
                          IconPath.voiceai,
                          width: 56.w,
                          height: 56.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h), // নিচে gap
          ],
        ),
      ),
    );
  }

  Widget _buildOverdueInvoiceNotification(NotificationItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: AssetImage(IconPath.notificationnotice),
                width: 40.w,
                height: 40.h,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.urbanist(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff1C1C1C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 32.h,
                width: 91.w,
                decoration: BoxDecoration(
                  color: const Color(0xff1C1C1C),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Center(
                  child: Text(
                    "Remind",
                    style: GoogleFonts.urbanist(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffFFFFFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteReminderNotification(NotificationItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image(
                image: AssetImage(IconPath.remindernotification),
                width: 40.w,
                height: 40.h,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 111.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF2CB05),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Center(
                  child: Text(
                    "Mark won",
                    style: GoogleFonts.urbanist(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 111.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: const Color(0xffD94E2E),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Center(
                  child: Text(
                    "Mark Lost",
                    style: GoogleFonts.urbanist(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffFFFFFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaidInvoiceNotification(NotificationItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.green,
            radius: 18,
            child: Icon(Icons.check, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
