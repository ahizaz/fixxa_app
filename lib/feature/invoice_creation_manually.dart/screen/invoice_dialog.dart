import 'dart:ui';

import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/add_invoice_client.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/add_invoice_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/export_invoice_preview.dart';

class InvoiceDialog {
  static void show(BuildContext context) {
    final InvoiceManuallyController controller = Get.put(
      InvoiceManuallyController(),
    );
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3), // background dim
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // blur effect
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 16.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Obx(
              () => AbsorbPointer(
                absorbing:
                    controller.showSpotlight.value ||
                    controller.showAddItemSpotlight.value ||
                    controller.showPaymentSpotlight.value ||
                    controller.showPreviewSpotlight.value,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight:
                        MediaQuery.of(context).size.height *
                        0.95, // Increased to 95% of screen height
                  ),
                  padding: EdgeInsets.all(20.w),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.auto_awesome, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  "Invoice",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                controller.clearClientData();
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // --------- Spotlight Bubble (help tooltip) -----------
                        Obx(
                          () => controller.showSpotlight.value
                              ? SpotlightBubble(
                                  title: "Add client",
                                  description:
                                      "Choose your client whom you want to send the invoice.",
                                )
                              : SizedBox.shrink(),
                        ),

                        // Client input
                        Text(
                          "CLIENT",
                          style: GoogleFonts.montserrat(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1C1C1C),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Obx(() {
                          Map<String, dynamic> client =
                              controller.selectedClient;
                          final String name = client['name'] ?? "";
                          final String businessName =
                              client['business_name'] ?? "";
                          final String initials =
                              name.isNotEmpty &&
                                  name.split(" ").first.isNotEmpty
                              ? name.split(" ").first[0].toUpperCase()
                              : "?";
                          return InkWell(
                            onTap: () {
                              Get.to(() => AddInvoiceClient());
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Color(0xffE8E8E8),
                                  width: 2,
                                ),
                                color: Colors.white,
                              ),
                              child: client.isEmpty
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_add),
                                        SizedBox(width: 10.w),
                                        Text(
                                          "Add client",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff1C1C1C),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20.r,
                                          backgroundColor: Colors.grey[300],
                                          child: Text(
                                            initials,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (businessName.isNotEmpty)
                                                Text(
                                                  businessName,
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 17.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                              Text(
                                                name,
                                                style: GoogleFonts.urbanist(
                                                  fontSize:
                                                      businessName.isNotEmpty
                                                      ? 14.sp
                                                      : 17.sp,
                                                  fontWeight:
                                                      businessName.isNotEmpty
                                                      ? FontWeight.w400
                                                      : FontWeight.w600,
                                                  color: businessName.isNotEmpty
                                                      ? Colors.grey[600]
                                                      : Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Empty space to balance the avatar on the left
                                        SizedBox(width: 40.w),
                                      ],
                                    ),
                            ),
                          );
                        }),
                        SizedBox(height: 16.h),
                        // Work input
                        Text(
                          "DESCRIPTION OF WORK",
                          style: GoogleFonts.montserrat(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1C1C1C),
                          ),
                        ),
                        SizedBox(height: 6.h),

                        Obx(() {
                          final items = controller
                              .items; // Assume items is an RxList in your controller
                          return Column(
                            children: [
                              ...items.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                final double price = (item['price'] is num)
                                    ? (item['price'] as num).toDouble()
                                    : double.tryParse(
                                            item['price']?.toString() ?? '0',
                                          ) ??
                                          0.0;
                                final String desc = (item['description'] ?? '')
                                    .toString()
                                    .trim();

                                // Skip rendering empty/zero items to avoid blank rows with £0.0
                                if (price <= 0 || desc.isEmpty) {
                                  return SizedBox.shrink();
                                }

                                return InkWell(
                                  onTap: () {
                                    // Edit existing item
                                    controller.editItemIndex = index;
                                    controller.descriptionController.text =
                                        item['description'] ?? '';
                                    // Try service_rate first, then fall back to rate
                                    final rateValue =
                                        item['service_rate'] ??
                                        item['unit_price'] ??
                                        item['rate'] ??
                                        0.0;
                                    controller.estimatedCostController.text =
                                        rateValue.toString();
                                    controller.quantityController.text =
                                        (item['quantity'] ?? 1).toString();
                                    controller.discountType.value =
                                        item['discountType'] ?? 'None';
                                    controller.isTaxable.value =
                                        item['isTaxable'] ?? false;
                                    controller.dayhour.value =
                                        item['dayhour'] ?? 'Days';
                                    Get.to(() => AddInvoiceItem());
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: Color(0xffE8E8E8),
                                        width: 2,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['description'] ?? '',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "£${item['price'] ?? ''}",
                                          style: GoogleFonts.urbanist(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),

                              // --------- Add Item Spotlight Bubble -----------
                              Obx(
                                () =>
                                    !controller.showSpotlight.value &&
                                        controller.showAddItemSpotlight.value
                                    ? Column(
                                        children: [
                                          SizedBox(height: 8.h),
                                          SpotlightBubble(
                                            title: "Add Service",
                                            description:
                                                "Add services or items to your invoice.",
                                          ),
                                        ],
                                      )
                                    : SizedBox.shrink(),
                              ),

                              InkWell(
                                onTap: () {
                                  _showPaymentModeSheet(context, controller);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 64.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: Color(0xffE8E8E8),
                                      width: 2,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add),
                                      SizedBox(width: 8),
                                      Text(
                                        "Add Service",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff1C1C1C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        SizedBox(height: 20.h),
                        // Totals section with background color
                        Obx(
                          () => Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              children: [
                                _buildRow(
                                  "Subtotal",
                                  "£${controller.subtotal.value.toStringAsFixed(2)}",
                                ),
                              
                                _buildRow(
                                  "VAT (${controller.vatRate.value.toStringAsFixed(0)}%)",
                                  "£${controller.tax.value.toStringAsFixed(2)}",
                                ),
                                Divider(),
                                _buildRow(
                                  "Total",
                                  "£${controller.total.value.toStringAsFixed(2)}",
                                  bold: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // --------- Preview Spotlight Bubble -----------
                        Obx(
                          () =>
                              !controller.showSpotlight.value &&
                                  !controller.showAddItemSpotlight.value &&
                                  !controller.showPaymentSpotlight.value &&
                                  controller.showPreviewSpotlight.value
                              ? Column(
                                  children: [
                                    SpotlightBubble(
                                      title: "Invoice preview",
                                      description:
                                          "View the invoice in branded format.",
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),

                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Obx(() {
                                final canExportPdf = controller.invoiceId.value != null;
                                return PopupMenuButton<String>(
                                onSelected: (String value) {
                                  // Handle export actions
                                  switch (value) {
                                    case 'pdf':
                                      if (!canExportPdf) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ExportInvoicePage(
                                            data: {
                                              'invoice_id': controller.invoiceId.value,
                                            },
                                          ),
                                        ),
                                      );
                                      break;
                                    case 'csv':
                                      controller.exportInvoiceAsCsv();
                                      break;
                                    case 'excel':
                                      controller.exportInvoiceAsExcel();
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                      PopupMenuItem<String>(
                                        value: 'pdf',
                                        enabled: canExportPdf,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.picture_as_pdf,
                                              size: 18,
                                              color: canExportPdf ? Colors.red : Colors.grey,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Export as PDF',
                                              style: TextStyle(
                                                color: canExportPdf ? null : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'csv',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.table_chart,
                                              size: 18,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 8),
                                            Text('Export as CSV'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'excel',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.grid_on,
                                              size: 18,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(width: 8),
                                            Text('Export as Excel'),
                                          ],
                                        ),
                                      ),
                                    ],
                                child: Container(
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Export",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              }),
                            ),
                            SizedBox(width: 8.w),
                            // Expanded(
                            //   child: PopupMenuButton<String>(
                            //     onSelected: (String value) async {
                            //       // Handle send actions
                            //       switch (value) {
                            //         case 'email':
                            //           // Send via Email action
                            //           debugPrint('📧 Send via Email clicked');
                                      
                            //           // Get controller instance
                            //           final controller = Get.find<InvoiceManuallyController>();
                                      
                            //           // Call send email method
                            //           await controller.sendInvoiceEmail();
                            //           break;
                            //         case 'whatsapp':
                            //           // Send via WhatsApp action
                            //           debugPrint('📱 Send via WhatsApp clicked');
                                      
                            //           // Call send WhatsApp method
                            //           await controller.sendInvoiceWhatsApp();
                            //           break;
                            //       }
                            //     },
                            //     itemBuilder: (BuildContext context) =>
                            //         <PopupMenuEntry<String>>[
                            //           PopupMenuItem<String>(
                            //             value: 'email',
                            //             child: Row(
                            //               children: [
                            //                 Icon(
                            //                   Icons.email,
                            //                   size: 18,
                            //                   color: Colors.blue,
                            //                 ),
                            //                 SizedBox(width: 8),
                            //                 Text('Send via Email'),
                            //               ],
                            //             ),
                            //           ),
                            //           PopupMenuItem<String>(
                            //             value: 'whatsapp',
                            //             child: Row(
                            //               children: [
                            //                 Icon(
                            //                   Icons.chat,
                            //                   size: 18,
                            //                   color: Colors.green,
                            //                 ),
                            //                 SizedBox(width: 8),
                            //                 Text('Send via WhatsApp'),
                            //               ],
                            //             ),
                            //           ),
                            //         ],
                            //     child: Container(
                            //       height: 48.h,
                            //       decoration: BoxDecoration(
                            //         color: Colors.blue,
                            //         borderRadius: BorderRadius.circular(30.r),
                            //       ),
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           Text(
                            //             "Send",
                            //             style: TextStyle(color: Colors.white),
                            //           ),
                            //           SizedBox(width: 4.w),
                            //           Icon(
                            //             Icons.arrow_drop_down,
                            //             color: Colors.white,
                            //             size: 20,
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void _showPaymentModeSheet(
    BuildContext context,
    InvoiceManuallyController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                "How do you want to get paid?",
                style: GoogleFonts.urbanist(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff1C1C1C),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Choose a payment method for this invoice.",
                style: GoogleFonts.urbanist(
                  fontSize: 13.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20.h),

              // Enable Smart Pay option
              InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () async {
                  Navigator.pop(ctx);
                  final isConnected = await controller.checkStripeStatus();
                  if (isConnected) {
                    controller.isSmartPayEnabled.value = true;
                    Get.to(() => AddInvoiceItem());
                  } else {
                    // Not connected – start Stripe onboarding.
                    // User will return to app after completing onboarding.
                    await controller.connectWithStripe();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff3A8DFF), width: 1.5),
                    borderRadius: BorderRadius.circular(12.r),
                    color: const Color(0xffEDF5FF),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42.w,
                        height: 42.h,
                        decoration: BoxDecoration(
                          color: const Color(0xff3A8DFF),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.bolt,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Enable Smart Pay",
                              style: GoogleFonts.urbanist(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff1C1C1C),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Payment link included in invoice",
                              style: GoogleFonts.urbanist(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: const Color(0xff3A8DFF),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Manual Payment option
              InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  Navigator.pop(ctx);
                  controller.isSmartPayEnabled.value = false;
                  Get.to(() => AddInvoiceItem());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42.w,
                        height: 42.h,
                        decoration: BoxDecoration(
                          color: const Color(0xff34C759),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.account_balance,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Manual Payment",
                              style: GoogleFonts.urbanist(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff1C1C1C),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Bank transfer details only, no payment link",
                              style: GoogleFonts.urbanist(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- Spotlight Bubble Widget ----------
class SpotlightBubble extends StatelessWidget {
  final String title;
  final String description;

  const SpotlightBubble({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h), // Add margin to accommodate arrow
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: GoogleFonts.urbanist(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Arrow pointer - adjusted position to avoid negative overflow
          Positioned(
            bottom: -8.h,
            left: 24.w,
            child: SizedBox(
              width: 20,
              height: 8,
              child: CustomPaint(
                painter: _BubbleArrowPainter(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleArrowPainter extends CustomPainter {
  final Color color;
  _BubbleArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    // Add shadow to match the bubble
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.07), 2, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
