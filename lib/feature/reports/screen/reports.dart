import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/feature/reports/controller/report_controller.dart';
import 'package:fixxa_app/feature/reports/screen/ai_chat_bot.dart';
import 'package:fixxa_app/feature/reports/screen/balance_report.dart';
import 'package:fixxa_app/feature/reports/screen/invoices_report.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    final reportController = Get.put(ReportController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      IconPath.arrowleftpic,
                      height: 24.h,
                      width: 24.w,
                    ),
                  ),
                  SizedBox(width: 90.w),
                  Text(
                    "Reports",
                    style: GoogleFonts.urbanist(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                  const Spacer(),
                  Obx(
                    () => InkWell(
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
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Container(
                  height: 32.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => reportController.selectedTab.value = 0,
                          child: Obx(
                            () => Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: reportController.selectedTab.value == 0
                                    ? const Color(0xffFFFFFF)
                                    : const Color(0xffF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  if (reportController.selectedTab.value == 0)
                                    BoxShadow(
                                      color: Colors.black.withAlpha(77),
                                      blurRadius: 1,
                                    ),
                                ],
                              ),
                              child: Text(
                                "Invoices",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: reportController.selectedTab.value == 0
                                      ? const Color(0xff1A1A1A)
                                      : const Color(0xff666666),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => reportController.selectedTab.value = 1,
                          child: Obx(
                            () => Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: reportController.selectedTab.value == 1
                                    ? const Color(0xffFFFFFF)
                                    : const Color(0xffF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  if (reportController.selectedTab.value == 1)
                                    BoxShadow(
                                      color: Colors.black.withAlpha(77),
                                      blurRadius: 1,
                                    ),
                                ],
                              ),
                              child: Text(
                                "Balance",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: reportController.selectedTab.value == 1
                                      ? const Color(0xff1A1A1A)
                                      : const Color(0xff666666),
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
              SizedBox(height: 20.h),
              // Expanded for reports content
              Expanded(
                child: Obx(() {
                  final selected = reportController.selectedTab.value;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: selected == 0
                        ? const InvoicesReport(key: ValueKey('invoice'))
                        : const BalanceReport(key: ValueKey('balance')),
                  );
                }),
              ),
              // Bottom Button Container
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
                                            Image.asset(
                                              IconPath.createquote,
                                              height: 24.h,
                                              width: 24.w,
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
                                            Image.asset(
                                              IconPath.createinvoice,
                                              height: 24.h,
                                              width: 24.w,
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
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () => Get.to(() => ScannerScreen()),
                            child: Image.asset(
                              IconPath.scantext,
                              width: 24.w,
                              height: 24.h,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ChatScreen(),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Image.asset(
                            IconPath.voiceai,
                            width: 56.w,
                            height: 56.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
