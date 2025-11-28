import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/manually_quote_controller.dart';

class DateRow extends StatelessWidget {
  final ManuallyQuoteController controller;
  const DateRow({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                controller.issueDate.value = picked.toIso8601String().split('T').first;
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Obx(() => Text(controller.issueDate.value ?? 'Issue Date')),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(Duration(days: 7)),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                controller.dueDate.value = picked.toIso8601String().split('T').first;
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Obx(() => Text(controller.dueDate.value ?? 'Due Date')),
            ),
          ),
        ),
      ],
    );
  }
}
