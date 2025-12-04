import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/manually_quote_controller.dart';

class ServiceTable extends StatelessWidget {
  final ManuallyQuoteController controller;
  const ServiceTable({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
      ),
      child: Obx(() {
        final items = controller.services;
        if (items.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(12.h),
            child: Text('No services added yet', style: GoogleFonts.urbanist(color: Colors.grey)),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 36.h,
            dataRowHeight: 40.h,
            columns: [
              DataColumn(label: Text('Description', style: GoogleFonts.montserrat(fontSize: 12.sp))),
              DataColumn(label: Text('Service', style: GoogleFonts.montserrat(fontSize: 12.sp))),
              DataColumn(label: Text('Rate', style: GoogleFonts.montserrat(fontSize: 12.sp))),
              DataColumn(label: Text('Duration', style: GoogleFonts.montserrat(fontSize: 12.sp))),
            ],
            rows: items.map((item) {
              final desc = (item['description'] ?? '-').toString();
              final service = (item['service'] ?? item['service_type'] ?? item['dayhour'] ?? '-').toString();
              final rate = item['service_rate'] != null ? item['service_rate'].toString() : (item['rate'] != null ? item['rate'].toString() : '-');
              final duration = item['service_duration'] != null ? item['service_duration'].toString() : (item['quantity'] != null ? item['quantity'].toString() : '-');
              return DataRow(cells: [
                DataCell(Text(desc, style: GoogleFonts.urbanist(fontSize: 12.sp))),
                DataCell(Text(service, style: GoogleFonts.urbanist(fontSize: 12.sp))),
                DataCell(Text(rate, style: GoogleFonts.urbanist(fontSize: 12.sp))),
                DataCell(Text(duration, style: GoogleFonts.urbanist(fontSize: 12.sp))),
              ]);
            }).toList(),
          ),
        );
      }),
    );
  }
}
