import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/manually_quote_controller.dart';

class AddItemHeader extends StatelessWidget {
  final ManuallyQuoteController controller;
  const AddItemHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close, color: Colors.black),
        ),
        SizedBox(width: 5.w),
        Text(
          "New Item",
          style: GoogleFonts.urbanist(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1C1C1C),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () async {
            controller.saveOrUpdateItemFromAddScreen();
            debugPrint('📝 Selected client id: ${controller.selectedClient['id']}');
            EasyLoading.show(status: 'Sending quote...');
            final result = await controller.createQuote();
            EasyLoading.dismiss();
            debugPrint('📤 createQuote result: $result');
            if (result == true) {
              Get.back();
            }
          },
          child: Text(
            "Done",
            style: GoogleFonts.urbanist(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff3A8DFF),
            ),
          ),
        ),
      ],
    );
  }
}
