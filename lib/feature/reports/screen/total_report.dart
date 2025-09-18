import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fixxa_app/feature/reports/controller/report_controller.dart';

class TotalInvoices extends StatelessWidget {
  const TotalInvoices({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.find<ReportController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Total invoices",
          style: GoogleFonts.urbanist(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() => ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: controller.totalInvoices.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final invoice = controller.totalInvoices[index];
          final bool isPaid = invoice['status'] == 'paid';
          
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: Colors.grey.shade300,
                child: Image.asset(invoice['avatar'], fit: BoxFit.cover, width: 40.w, height: 40.h),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice['name'],
                      style: GoogleFonts.urbanist(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      invoice['email'],
                      style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: isPaid ? Color(0xff0B8E5E) : Color(0xffB5681B), // Green for paid, Orange for unpaid
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        "${invoice['currency']}${invoice['amount'].toStringAsFixed(0)} ${invoice['status']}",
                        style: GoogleFonts.urbanist(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      )),
    );
  }
}