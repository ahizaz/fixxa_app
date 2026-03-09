import 'package:fixxa_app/feature/reports/controller/report_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BalanceReport extends StatelessWidget {
  const BalanceReport({super.key});

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
              final isMonthly = controller.reportType.value == "Monthly";
              final chartData = controller.chartData;

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() == 0) {
                            const monthNames = [
                              'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                              'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                            ];
                            final m = controller.selectedMonth.value;
                            return Text(
                              isMonthly
                                  ? (m >= 1 && m <= 12 ? monthNames[m - 1] : '')
                                  : '${controller.selectedYear.value}',
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: chartData.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value,
                          color: const Color(0xff0E8E5E),
                          width: 48.w,
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
                    ),
                    const SizedBox(height: 12),
                    _buildRow(
                      "Unpaid",
                      "£${controller.unpaid.value.toStringAsFixed(2)}",
                      Colors.red,
                    ),
                    const SizedBox(height: 12),
                    _buildRow(
                      "Total",
                      "£${controller.total.value.toStringAsFixed(2)}",
                      Colors.green,
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

  Widget _buildRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
