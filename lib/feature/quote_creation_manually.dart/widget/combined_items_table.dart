import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/manually_quote_controller.dart';

class CombinedItemsTable extends StatelessWidget {
  final ManuallyQuoteController controller;
  const CombinedItemsTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
      ),
      child: Obx(() {
        final itemsList = controller.items;
        if (itemsList.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(12.h),
            child: Text(
              'No items added yet',
              style: GoogleFonts.urbanist(color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 36.h,
            dataRowHeight: 40.h,
            columns: [
              DataColumn(
                label: Text(
                  'Description',
                  style: GoogleFonts.montserrat(fontSize: 11.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Service',
                  style: GoogleFonts.montserrat(fontSize: 11.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Rate',
                  style: GoogleFonts.montserrat(fontSize: 11.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Duration',
                  style: GoogleFonts.montserrat(fontSize: 11.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Material',
                  style: GoogleFonts.montserrat(fontSize: 11.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Qty',
                  style: GoogleFonts.montserrat(fontSize: 11.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Unit Price',
                  style: GoogleFonts.montserrat(fontSize: 11.sp),
                ),
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: GoogleFonts.montserrat(fontSize: 11.sp),
                ),
              ),
            ],
            rows: itemsList.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              final desc =
                  (item['quote_description'] ?? item['description'] ?? '')
                      .toString();
              final service = (item['service_type'] ?? item['service'] ?? '')
                  .toString();
              final rate = (item['service_rate'] ?? 0.0).toString();
              final duration = (item['service_duration'] ?? 0.0).toString();
              final material = (item['material_name'] ?? item['material'] ?? '')
                  .toString();
              final qty = (item['quantity'] ?? 0).toString();
              final unitPrice = (item['unit_price'] ?? 0.0).toString();

              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      desc.isEmpty ? '-' : desc,
                      style: GoogleFonts.urbanist(fontSize: 11.sp),
                    ),
                  ),
                  DataCell(
                    Text(
                      service.isEmpty ? '-' : service,
                      style: GoogleFonts.urbanist(fontSize: 11.sp),
                    ),
                  ),
                  DataCell(
                    Text(rate, style: GoogleFonts.urbanist(fontSize: 11.sp)),
                  ),
                  DataCell(
                    Text(
                      duration,
                      style: GoogleFonts.urbanist(fontSize: 11.sp),
                    ),
                  ),
                  DataCell(
                    Text(
                      material.isEmpty ? '-' : material,
                      style: GoogleFonts.urbanist(fontSize: 11.sp),
                    ),
                  ),
                  DataCell(
                    Text(qty, style: GoogleFonts.urbanist(fontSize: 11.sp)),
                  ),
                  DataCell(
                    Text(
                      unitPrice,
                      style: GoogleFonts.urbanist(fontSize: 11.sp),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete, size: 18.sp, color: Colors.red),
                      onPressed: () {
                        controller.items.removeAt(index);
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
