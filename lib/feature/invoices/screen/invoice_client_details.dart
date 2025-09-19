import 'dart:ui';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/invoices/controller/invoice_controller.dart';
import 'package:fixxa_app/feature/invoices/screen/invoice_edit_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InvoiceClientDetails extends StatelessWidget {
  final InvoiceData invoice;
  const InvoiceClientDetails({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InvoiceController>();
    return Scaffold(
      backgroundColor: Color(0xffF8F8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image(
                        image: const AssetImage(IconPath.backicon),
                        width: 18.w,
                        height: 24.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Back", // This should probably be "My Profile" as per the initial design, or dynamic
                      style: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff3A8DFF),
                      ),
                    ),
                    Spacer(),
                    PopupMenuButton<String>(
                      icon: Image(
                        image: const AssetImage(IconPath.clienthreedots),
                        width: 24.w,
                        height: 24.h,
                        fit: BoxFit.cover,
                      ),
                      offset: Offset(0, 48.h), // Adjust offset to position the menu
                      onSelected: (String result) {
                        if (result == 'edit') {
                          Get.to(() => InvoiceEditDetails(invoice: invoice));
                        } else if (result == 'remove') {
                          Get.dialog(
                            Stack(
                              children: [
                                Positioned.fill(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: 300.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(color: const Color(0xffE8E8E8)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16.w),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Are you sure you want to remove the client from your Fixxa account?",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.urbanist(
                                              decoration: TextDecoration.none,
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff1C1C1C),
                                            ),
                                          ),
                                          SizedBox(height: 24.h),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    height: 48.h,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xff1C1C1C),
                                                      borderRadius: BorderRadius.circular(999.r),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "No, Keep it",
                                                        style: GoogleFonts.montserrat(
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white,
                                                          decoration: TextDecoration.none,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 12.w),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    final invoiceController = Get.find<InvoiceController>();
                                                    invoiceController.invoices.removeWhere((i) => i.id == invoice.id);
                                                    Get.back(); // Close dialog
                                                    Get.back(); // Go back to invoices list
                                                  },
                                                  child: Container(
                                                    height: 48.h,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xffD94E2E),
                                                      borderRadius: BorderRadius.circular(999.r),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Yes, Remove",
                                                        style: GoogleFonts.montserrat(
                                                          fontSize: 15.sp,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white,
                                                          decoration: TextDecoration.none,
                                                        ),
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
                              ],
                            ),
                            barrierDismissible: false,
                            barrierColor: Colors.transparent,
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage(IconPath.penline),
                                width: 24.w,
                                height: 24.h,
                                fit: BoxFit.cover,
                                color: Color(0xff3ABDFF),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Edit client details',
                                style: GoogleFonts.urbanist(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff434343),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'remove',
                          child: Row(
                            children: [
                              Image(
                                image: AssetImage(IconPath.trash),
                                width: 18.w,
                                height: 20.h,
                                fit: BoxFit.cover,
                                color: Color(0xffD94E2E),
                              ),
                              SizedBox(width: 18.w),
                              Text(
                                'Remove client',
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      color: const Color(0xffF2F2F2), // Background color of the pop-up
                      elevation: 8, // Shadow of the pop-up
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Obx(
                () {
                  final currentInvoice = controller.invoices.firstWhere((i) => i.id == invoice.id);
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      width: double.infinity,
                      height: 195.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage(ImagePath.backgroundContainer),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40.r,
                            backgroundColor: Colors.grey[200],
                            child: Text(
                              currentInvoice.customerName[0],
                              style: GoogleFonts.urbanist(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            currentInvoice.customerName,
                            style: GoogleFonts.urbanist(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xffE8E8E8),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            currentInvoice.email,
                            style: GoogleFonts.urbanist(
                              fontSize: 16.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            currentInvoice.phone ?? "+44 1234 567896",
                            style: GoogleFonts.montserrat(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffA2A2A2),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3, // Number of plumbing invoices from the image
                itemBuilder: (context, index) {
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
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Plumbing",
                                style: GoogleFonts.urbanist(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff1C1C1C),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: (invoice.paidAmount > 0)
                                      ? const Color(0xffE8F5E9) // green background if paid
                                      : const Color(0xffFFF3E0), // orange background if pending
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  (invoice.paidAmount > 0)
                                      ? "£${invoice.paidAmount.toStringAsFixed(2)} paid"
                                      : "£${invoice.pendingAmount.toStringAsFixed(2)} pending",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: (invoice.paidAmount > 0) ? Colors.green[700] : Colors.orange[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16.sp,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "London, UK",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16.sp,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "17 Mar, 2025",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}