import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/invoices/controller/invoice_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Invoices extends StatelessWidget {
  Invoices({super.key});

  final controller = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
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

            /// Invoice list
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = controller.invoices[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            // Handle invoice tap
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24.r,
                                  backgroundColor: Colors.grey[200],
                                  child: Text(
                                    invoice.customerName[0],
                                    style: GoogleFonts.urbanist(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
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
                                              color: const Color(0xffF5F5F5),
                                              borderRadius: BorderRadius.circular(4.r),
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
                                                  '${invoice.invoiceNumber} Invoice',
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
                                              color: invoice.status == 'paid'
                                                  ? const Color(0xffE8F5E9)
                                                  : const Color(0xffFFF3E0),
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  invoice.status == 'paid'
                                                      ? Icons.check_circle_outline
                                                      : Icons.pending_outlined,
                                                  size: 16.sp,
                                                  color: invoice.status == 'paid'
                                                      ? Colors.green[700]
                                                      : Colors.orange[700],
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  '£${invoice.amount.toStringAsFixed(0)} ${invoice.status}',
                                                  style: GoogleFonts.urbanist(
                                                    fontSize: 12.sp,
                                                    color: invoice.status == 'paid'
                                                        ? Colors.green[700]
                                                        : Colors.orange[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
