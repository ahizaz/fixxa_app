import 'package:fl_chart/fl_chart.dart';
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
          // ===== Chart =====
          SizedBox(
            height: 220,
            child: Obx(() {
              // কোন ডাটা নেবে (weekly / monthly)
              final isWeekly = controller.reportType.value == "Weekly";
              final chartData = isWeekly
                  ? controller.weeklyData
                  : controller.monthlyData;

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (isWeekly) {
                            final days = [
                              "Sat",
                              "Sun",
                              "Mon",
                              "Tue",
                              "Wed",
                              "Thu",
                              "Fri"
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < days.length) {
                              return Text(days[value.toInt()]);
                            }
                          } else {
                            final months = [
                              "Jan",
                              "Feb",
                              "Mar",
                              "Apr",
                              "May",
                              "Jun",
                              "Jul",
                              "Aug",
                              "Sep",
                              "Oct",
                              "Nov",
                              "Dec"
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < months.length) {
                              return Text(months[value.toInt()]);
                            }
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: chartData.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value,
                          color: const Color(0xff0E8E5E),
                          width: isWeekly ? 32.w : 20.w,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // ===== Summary Card =====
          Obx(() {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRow("Paid",
                        "£${controller.paid.value.toStringAsFixed(2)}",
                        Colors.green),
                    const SizedBox(height: 12),
                    _buildRow("Unpaid",
                        "£${controller.unpaid.value.toStringAsFixed(2)}",
                        Colors.red),
                    const SizedBox(height: 12),
                    _buildRow("Total",
                        "£${controller.total.value.toStringAsFixed(2)}",
                        Colors.green),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("TAX",
                            style: TextStyle(
                                fontSize: 14, color: Colors.black54)),
                        Text("£${controller.tax.value.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black87)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Text(value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}