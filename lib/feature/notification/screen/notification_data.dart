import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/notification/controller/notficationdatacontroller.dart';
import 'package:fixxa_app/feature/notification/widget/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationData extends StatelessWidget {
  const NotificationData({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotficationcontrollerData());
    controller.loadNotifications(); // demo data load

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GestureDetector(
            onTap: () async {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
              final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
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
                      child: const Text('Mark all as read'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clear_all',
                    child: Container(
                      color: Colors.transparent,
                      child: Text(
                        'Clear all',
                        style: TextStyle(color: Colors.red[600]),
                      ),
                    ),
                  ),
                ],
              );
              if (result == 'mark_all_read') {
                // controller.markAllAsRead();
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
              style:GoogleFonts.urbanist( 
                fontSize: 34.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff1C1C1C)
              )
              
            ),
            const SizedBox(height: 7.5),
            Row(
            children: [
              Image(image: AssetImage(IconPath.fire,),height: 24.h,width: 24.w,fit: BoxFit.cover,),
              SizedBox(width: 10.w,),
              Text("Priority",style: GoogleFonts.montserrat( 
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff434343)
              ),)
            ],
            ),
            SizedBox(height: 11.h,),
            
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
    );
  }

  Widget _buildOverdueInvoiceNotification(NotificationItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.orange,
            radius: 18,
            child: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item.subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(item.action ?? '', style: const TextStyle(color: Colors.white)),
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
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.pinkAccent,
            radius: 18,
            child: Icon(Icons.notifications_active_outlined, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item.subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
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
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))],
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
                Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item.subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
