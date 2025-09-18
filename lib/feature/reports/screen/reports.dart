///import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/reports/controller/report_controller.dart';
import 'package:fixxa_app/feature/reports/screen/balance_report.dart';
import 'package:fixxa_app/feature/reports/screen/invoices_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    final reportController  =  Get.put(ReportController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start ,
            children: [
             Row(
  children: [
    InkWell(
      onTap: () {
        Get.back();
      },
      child: Image(
        image: AssetImage(IconPath.arrowleftpic),
        height: 24.h,
        width: 24.w,
        fit: BoxFit.cover,
      ),
    ),
    SizedBox(width: 90.w),
    Text(
      "Reports",
      style: GoogleFonts.urbanist(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        color: Color(0xff1C1C1C),
      ),
    ),
    const Spacer(),

    // 👉 Report Type Toggle (Weekly / Monthly)
    Obx(() {
      return InkWell(
        onTap: () => reportController.toggleReportType(),
        child: Row(
          children: [
            Text(
              reportController.reportType.value,
              style: GoogleFonts.urbanist(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1C1C1C),
              ),
            ),
            SizedBox(width: 4.w),
            const Icon(Icons.arrow_drop_down_sharp),
          ],
        ),
      );
    }),
  ],
),

     
              SizedBox(height: 20.h,),
                  Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
                  height: 32.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => reportController .selectedTab.value = 0,
                          child: Obx(
                            () => Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    reportController .selectedTab.value == 0
                                        ? Color(0xffFFFFFF)
                                        : Color(0xffF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  if (reportController .selectedTab.value == 0)
                                    BoxShadow(
                                      color: Color(
                                        0xff000000,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 1,
                                    ),
                                ],
                              ),
                              child: Text(
                                "Invoices",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color:
                                     reportController .selectedTab.value == 0
                                          ? Color(0xff1A1A1A)
                                          : Color(0xff666666),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => reportController .selectedTab.value = 1,
                          child: Obx(
                            () => Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color:
                                    reportController .selectedTab.value == 1
                                        ? Color(0xffFFFFFF)
                                        : Color(0xffF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  if (reportController .selectedTab.value == 1)
                                    BoxShadow(
                                      color: Color(
                                        0xff000000,
                                      ).withValues(alpha: .3),
                                      blurRadius: 1,
                                    ),
                                ],
                              ),
                              child: Text(
                                "Balance",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      reportController .selectedTab.value == 1
                                          ? Color(0xff1A1A1A)
                                          : Color(0xff666666),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    ),
     SizedBox(height: 45.h),
              Obx(() {
                final selected = reportController.selectedTab.value;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: selected == 0
                      ? const InvoicesReport(key: ValueKey('invoice'))
                      : const BalanceReport(key: ValueKey('balance')),
                );
              }),

           
            ],
          ),
        ),
      ),
    );
  }
}