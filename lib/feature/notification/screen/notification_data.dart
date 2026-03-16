import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/notification/controller/notficationdatacontroller.dart';
import 'package:fixxa_app/feature/notification/model/notification_model.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/add_client.dart';
import 'package:fixxa_app/core/services/spotlight_service.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xffF8F8FF),
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
              final Offset buttonPosition =
                  button.localToGlobal(Offset.zero, ancestor: overlay);
              final result = await showMenu(
                context: context,
                position: RelativeRect.fromRect(
                  Rect.fromLTWH(buttonPosition.dx - 100,
                      buttonPosition.dy + 100, button.size.width, button.size.height),
                  Offset.zero & overlay.size,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.grey[200],
                items: [
                  PopupMenuItem(
                    value: 'mark_all_read',
                    child: Text(
                      'Mark all as read',
                      style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff434343)),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clear_all',
                    child: Text(
                      'Clear all',
                      style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffD94E2E)),
                    ),
                  ),
                ],
              );
              if (result == 'clear_all') {
                controller.notifications.clear();
              }
            },
            child: Image.asset(IconPath.three, height: 30.h, width: 30.w),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notifications",
              style: GoogleFonts.urbanist(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff1C1C1C)),
            ),
            SizedBox(height: 7.5.h),
            Row(
              children: [
                Image.asset(IconPath.fire, height: 24.h, width: 24.w,
                    fit: BoxFit.cover),
                SizedBox(width: 10.w),
                Text(
                  "Priority",
                  style: GoogleFonts.montserrat(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff434343)),
                ),
              ],
            ),
            SizedBox(height: 11.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined,
                            size: 60, color: Colors.grey[400]),
                        SizedBox(height: 12.h),
                        Text(
                          'No notifications yet',
                          style: GoogleFonts.urbanist(
                              fontSize: 16.sp, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: controller.fetchNotifications,
                  child: ListView.separated(
                    itemCount: controller.notifications.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(
                          controller.notifications[index]);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 94.h + 40.h,
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
                      fit: BoxFit.contain),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Builder(builder: (context) {
                          return InkWell(
                            onTap: () async {
                              final RenderBox box =
                                  context.findRenderObject() as RenderBox;
                              final Offset position =
                                  box.localToGlobal(Offset.zero);
                              final result = await showMenu<String>(
                                context: context,
                                color: const Color(0xffF2F2F2),
                                position: RelativeRect.fromLTRB(
                                    position.dx, position.dy - 120,
                                    position.dx + 100, 0),
                                items: [
                                  PopupMenuItem(
                                    value: 'quote',
                                    child: Row(children: [
                                      Image.asset(IconPath.createquote,
                                          height: 24.h, width: 24.w),
                                      const SizedBox(width: 8),
                                      Text("Create Quote",
                                          style: GoogleFonts.urbanist(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w500)),
                                    ]),
                                  ),
                                  PopupMenuItem(
                                    value: 'invoice',
                                    child: Row(children: [
                                      Image.asset(IconPath.createinvoice,
                                          height: 24.h, width: 24.w),
                                      const SizedBox(width: 8),
                                      Text("Create Invoice",
                                          style: GoogleFonts.urbanist(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w500)),
                                    ]),
                                  ),
                                  PopupMenuItem(
                                    value: 'add_client',
                                    child: Row(children: [
                                      const Icon(Icons.person_add, size: 24),
                                      const SizedBox(width: 8),
                                      const Text('Add Client'),
                                    ]),
                                  ),
                                ],
                              );
                              if (result == 'quote') {
                                SpotlightService.instance
                                    .setNavigationSource('other');
                                QuoteDialog.show(context);
                              } else if (result == 'invoice') {
                                SpotlightService.instance
                                    .setNavigationSource('other');
                                InvoiceDialog.show(context);
                              } else if (result == 'add_client') {
                                Get.to(() => const AddClient());
                              }
                            },
                            child: Image.asset(IconPath.plus,
                                width: 24.w, height: 24.h, fit: BoxFit.cover),
                          );
                        }),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () => Get.to(() => ScannerScreen()),
                          child: Image.asset(IconPath.scantext,
                              width: 24.w, height: 24.h, fit: BoxFit.cover),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Image.asset(IconPath.voiceai,
                          width: 56.w, height: 56.h, fit: BoxFit.cover),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel item) {
    final isUnread = !item.isRead;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xffF0F4FF) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isUnread
            ? Border.all(color: const Color(0xff4A6CF7).withOpacity(0.3))
            : Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeIcon(item.notificationType),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.urbanist(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff1C1C1C),
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xff4A6CF7),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  item.body,
                  style: GoogleFonts.urbanist(
                    fontSize: 13.sp,
                    color: const Color(0xff6B6B6B),
                    height: 1.4,
                  ),
                ),
                if (item.data != null) ...[
                  SizedBox(height: 10.h),
                  _buildDataChips(item.data!),
                ],
                SizedBox(height: 8.h),
                Text(
                  _formatTime(item.createdAt),
                  style: GoogleFonts.urbanist(
                    fontSize: 11.sp,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeIcon(String type) {
    switch (type) {
      case 'invoice_paid':
        return Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xff22C55E).withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.attach_money_rounded,
              color: Color(0xff22C55E), size: 24),
        );
      case 'invoice_overdue':
        return Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xffEF4444).withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.warning_amber_rounded,
              color: Color(0xffEF4444), size: 24),
        );
      case 'quote_created':
      case 'quote_reminder':
        return Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xffF59E0B).withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.description_outlined,
              color: Color(0xffF59E0B), size: 24),
        );
      default:
        return Container(
          width: 44.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: const Color(0xff4A6CF7).withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.notifications_outlined,
              color: Color(0xff4A6CF7), size: 24),
        );
    }
  }

  Widget _buildDataChips(NotificationPayload data) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        if (data.total.isNotEmpty && data.total != '0.00')
          _chip('£${data.total}', const Color(0xff22C55E),
              const Color(0xffECFDF5)),
        if (data.invoiceNumber.isNotEmpty)
          _chip('#${data.invoiceNumber}', const Color(0xff4A6CF7),
              const Color(0xffEFF2FF)),
        if (data.clientName.isNotEmpty)
          _chip(data.clientName, const Color(0xff6B7280),
              const Color(0xffF3F4F6)),
      ],
    );
  }

  Widget _chip(String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}