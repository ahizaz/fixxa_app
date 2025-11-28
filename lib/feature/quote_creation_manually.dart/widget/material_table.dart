import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/manually_quote_controller.dart';

class MaterialTable extends StatelessWidget {
  final ManuallyQuoteController controller;
  const MaterialTable({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
      ),
      child: Obx(() {
        final mats = controller.materials;
        if (mats.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(12.h),
            child: Text('No materials added yet', style: GoogleFonts.urbanist(color: Colors.grey)),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 36.h,
            dataRowHeight: 40.h,
            columns: [
              DataColumn(label: Text('Material', style: GoogleFonts.montserrat(fontSize: 12.sp))),
              DataColumn(label: Text('Quantity', style: GoogleFonts.montserrat(fontSize: 12.sp))),
              DataColumn(label: Text('Unit Price', style: GoogleFonts.montserrat(fontSize: 12.sp))),
              DataColumn(label: Text('Amount', style: GoogleFonts.montserrat(fontSize: 12.sp))),
            ],
            rows: mats.map((m) {
              return DataRow(cells: [
                DataCell(Text((m['material'] ?? '-').toString(), style: GoogleFonts.urbanist(fontSize: 12.sp))),
                DataCell(Text((m['quantity'] ?? '-').toString(), style: GoogleFonts.urbanist(fontSize: 12.sp))),
                DataCell(Text((m['unit_price'] ?? '-').toString(), style: GoogleFonts.urbanist(fontSize: 12.sp))),
                DataCell(Text((m['amount'] ?? '-').toString(), style: GoogleFonts.urbanist(fontSize: 12.sp))),
              ]);
            }).toList(),
          ),
        );
      }),
    );
  }
}
