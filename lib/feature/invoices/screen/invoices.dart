import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/invoices/controller/invoice_controller.dart';
import 'package:fixxa_app/feature/invoices/screen/invoice_client_details.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_creation.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixxa_app/core/utils/network_helper.dart';

class Invoices extends StatelessWidget {
  Invoices({super.key});

  final controller = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),

      /// ✅ main button এখন সবসময় নিচে থাকবে
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Close button
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
                ],
              ),
            ),

            /// Title
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

            /// Invoice list (scrollable)
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.invoices.length,
                  itemBuilder: (context, index) {
                    final invoice = controller.invoices[index];
                    String formattedPaid = invoice.paidAmount
                        .toStringAsFixed(0)
                        .replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        );
                    String formattedPending = invoice.pendingAmount
                        .toStringAsFixed(0)
                        .replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        );
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => InvoiceClientDetails(invoice: invoice));
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                backgroundImage: invoice.avatarUrl != null
                                  ? NetworkImage(normalizeImageUrl(invoice.avatarUrl!))
                                  : null,
                                backgroundColor: Colors.grey[200],
                                child: invoice.avatarUrl == null
                                    ? Text(
                                        invoice.customerName.isNotEmpty 
                                            ? invoice.customerName[0] 
                                            : "?",
                                        style: GoogleFonts.urbanist(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : null,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      invoice.customerName,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff1C1C1C),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      invoice.email,
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFFFDE7),
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.description_outlined,
                                                size: 16.sp,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                '${invoice.invoiceNumber} ${invoice.invoiceNumber == 1 ? 'Invoice' : 'Invoices'}',
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12.sp,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xffE8F5E9),
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle_outline,
                                                size: 16.sp,
                                                color: Colors.green[700],
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                '€$formattedPaid paid',
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 12.sp,
                                                  color: const Color(
                                                    0xff0B8E5E,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffFFF3E0),
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.pending_outlined,
                                            size: 16.sp,
                                            color: const Color(0xffD94E2E),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            '€$formattedPending pending',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12.sp,
                                              color: Colors.orange[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey[400],
                                size: 24.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          width: double.infinity,
          height: 94.h + 60.h,
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
                                        image: AssetImage(IconPath.createquote),
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
      ),
    );
  }
}
