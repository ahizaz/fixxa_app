import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/add_client.dart';
import 'package:fixxa_app/core/services/spotlight_service.dart';
import 'package:fixxa_app/feature/reports/controller/report_controller.dart';
import 'package:fixxa_app/feature/reports/screen/ai_chat_bot.dart';
import 'package:fixxa_app/feature/reports/screen/invoices_report.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  void _showPeriodPicker(BuildContext context, reportController) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return _PeriodPickerSheet(reportController: reportController);
      },
    );
  }

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
              // Main content is now scrollable to prevent overflow
              Expanded(
                child: SingleChildScrollView(
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
                              onTap: () => _showPeriodPicker(context, reportController),
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
                      SizedBox(height: 20.h),
                      // Single unified report view (tabs removed). Showing Invoices graph by default.
                      SizedBox(
                        height: 400.h, // Adjust as needed for your layout
                        child: const InvoicesReport(),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom Button Container remains fixed
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
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: ChatScreen(),
                            ),
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

class _PeriodPickerSheet extends StatefulWidget {
  final dynamic reportController;
  const _PeriodPickerSheet({required this.reportController});

  @override
  State<_PeriodPickerSheet> createState() => _PeriodPickerSheetState();
}

class _PeriodPickerSheetState extends State<_PeriodPickerSheet> {
  late String _selectedType;
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.reportController.reportType.value;
    _selectedYear = widget.reportController.selectedYear.value;
    _selectedMonth = widget.reportController.selectedMonth.value;
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(10, (i) => currentYear - i);
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    return Padding(
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Select Period',
              style: GoogleFonts.urbanist(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1C1C1C),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Type selector
          Row(
            children: ['Monthly', 'Yearly'].map((type) {
              final selected = _selectedType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedType = type),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xff0E8E5E) : const Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        type,
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : const Color(0xff1C1C1C),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Year dropdown
          DropdownButtonFormField<int>(
            value: _selectedYear,
            decoration: InputDecoration(
              labelText: 'Year',
              labelStyle: GoogleFonts.urbanist(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: years
                .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedYear = val);
            },
          ),
          if (_selectedType == 'Monthly') ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _selectedMonth,
              decoration: InputDecoration(
                labelText: 'Month',
                labelStyle: GoogleFonts.urbanist(),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: List.generate(12, (i) => i + 1)
                  .map((m) => DropdownMenuItem(value: m, child: Text(monthNames[m - 1])))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedMonth = val);
              },
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0E8E5E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                widget.reportController.reportType.value = _selectedType;
                widget.reportController.selectedYear.value = _selectedYear;
                widget.reportController.selectedMonth.value = _selectedMonth;
                widget.reportController.fetchFinancialStatistics();
                Get.back();
              },
              child: Text(
                'Apply',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
