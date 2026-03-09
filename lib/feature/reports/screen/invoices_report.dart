import 'dart:math';
import 'package:fixxa_app/feature/reports/screen/paid_invoices.dart';
import 'package:fixxa_app/feature/reports/screen/total_report.dart';
import 'package:fixxa_app/feature/reports/screen/unpaid_invoices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/report_controller.dart';

class InvoicesReport extends StatelessWidget {
  const InvoicesReport({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportController>();

    return SingleChildScrollView(
      child: Column(
        children: [
          // ===== Bell Curve Chart =====
          Obx(() {
            final isMonthly = controller.reportType.value == "Monthly";
            final label = isMonthly
                ? _monthName(controller.selectedMonth.value)
                : '${controller.selectedYear.value}';
            final double total = controller.total.value;
            final double paid = controller.paid.value;
            final double paidRatio = total > 0 ? (paid / total).clamp(0.0, 1.0) : 0.0;

            // Build 5 evenly-spaced Y-axis labels from paid_amount down to 0
            final List<String> yLabels = List.generate(5, (i) {
              final val = paid * (4 - i) / 4;
              if (val >= 1000) {
                return '£${(val / 1000).toStringAsFixed(1)}k';
              }
              return '£${val.toStringAsFixed(0)}';
            });

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 220.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Y-axis labels
                        SizedBox(
                          width: 46.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: yLabels
                                .map(
                                  (l) => Padding(
                                    padding: EdgeInsets.only(right: 4.w),
                                    child: Text(
                                      l,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        // Bell curve
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: CustomPaint(
                              painter: _BellCurvePainter(paidRatio: paidRatio),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1565C0),
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

          // ===== Summary Card =====
          Obx(() {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRow(
                      "Paid",
                      "£${controller.paid.value.toStringAsFixed(2)}",
                      Colors.green,
                      onArrowTap: () {
                        Get.to(
                          () => PaidInvoices(),
                        ); // PaidDetailsPage holo tomaar target page
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildRow(
                      "Unpaid",
                      "£${controller.unpaid.value.toStringAsFixed(2)}",
                      Colors.red,
                      onArrowTap: () {
                        Get.to(() => UnpaidInvoices());
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildRow(
                      "Total",
                      "£${controller.total.value.toStringAsFixed(2)}",
                      Colors.green,
                      onArrowTap: () {
                        Get.to(() => TotalInvoices());
                      },
                    ),
                    // VAT removed as per design request
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    Color color, {
    VoidCallback? onArrowTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            SizedBox(width: 6),
            // InkWell(
            //   onTap: onArrowTap,
            //   child: Icon(Icons.arrow_forward_ios, size: 16, color: color),
            // ),
          ],
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }
}

class _BellCurvePainter extends CustomPainter {
  final double paidRatio;

  const _BellCurvePainter({this.paidRatio = 1.0});

  static const double _xMin = -4.0;
  static const double _xMax = 4.0;
  static const int _steps = 300;

  double _gaussian(double x) => exp(-0.5 * x * x) * paidRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Reserve bottom margin for axis
    const double bottomPad = 20.0;
    const double topPad = 12.0;
    final double chartH = h - bottomPad - topPad;

    double xToScreen(double x) =>
        (x - _xMin) / (_xMax - _xMin) * w;

    double yToScreen(double y) =>
        topPad + chartH * (1.0 - y);

    final baselineY = yToScreen(0.0);

    // ---- Filled path ----
    final fillPath = Path()..moveTo(xToScreen(_xMin), baselineY);
    for (int i = 0; i <= _steps; i++) {
      final double x = _xMin + (_xMax - _xMin) * i / _steps;
      fillPath.lineTo(xToScreen(x), yToScreen(_gaussian(x)));
    }
    fillPath.lineTo(xToScreen(_xMax), baselineY);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = const Color(0xFFADD8F0)
        ..style = PaintingStyle.fill,
    );

    // ---- Curve stroke ----
    final curvePath = Path()
      ..moveTo(xToScreen(_xMin), baselineY);
    for (int i = 0; i <= _steps; i++) {
      final double x = _xMin + (_xMax - _xMin) * i / _steps;
      curvePath.lineTo(xToScreen(x), yToScreen(_gaussian(x)));
    }
    curvePath.lineTo(xToScreen(_xMax), baselineY);

    canvas.drawPath(
      curvePath,
      Paint()
        ..color = const Color(0xFF1A5FA8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // ---- White vertical dividers (only if curve is visible) ----
    if (paidRatio > 0.01) {
      const dividers = [-1.5, -0.5, 0.5, 1.5];
      final divPaint = Paint()
        ..color = Colors.white.withOpacity(0.85)
        ..strokeWidth = 1.6;

      for (final xPos in dividers) {
        final double sx = xToScreen(xPos);
        final double topY = yToScreen(_gaussian(xPos));
        canvas.drawLine(Offset(sx, topY), Offset(sx, baselineY), divPaint);
      }
    }

    // ---- Axes ----
    final axisPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.2;

    // Y-axis
    canvas.drawLine(Offset(0, topPad), Offset(0, baselineY), axisPaint);
    // X-axis
    canvas.drawLine(Offset(0, baselineY), Offset(w, baselineY), axisPaint);
  }

  @override
  bool shouldRepaint(_BellCurvePainter oldDelegate) =>
      oldDelegate.paidRatio != paidRatio;
}
