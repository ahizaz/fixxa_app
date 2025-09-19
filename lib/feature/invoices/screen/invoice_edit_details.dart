import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/invoices/controller/invoice_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InvoiceEditDetails  extends StatelessWidget {
  final InvoiceData invoice;

  InvoiceEditDetails({super.key, required this.invoice});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with current values
    nameController.text = invoice.customerName;
    emailController.text = invoice.email;
    phoneController.text = invoice.phone ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: Image(
                      image: const AssetImage(IconPath.backicon),
                      width: 32.w,
                      height: 32.h,
                    ),
                  ),
                  Text(
                    "Client details",
                    style: GoogleFonts.urbanist(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1C1C1C),
                    ),
                  ),
                  SizedBox(width: 32.w), // For alignment
                ],
              ),
            ),
            Divider(height: 1.h, color: Colors.grey[200]),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInputField("Name", nameController),
                    SizedBox(height: 16.h),
                    buildInputField("Email", emailController),
                    SizedBox(height: 16.h),
                    buildInputField("Phone number", phoneController),
                  ],
                ),
              ),
            ),

            // Save Button
            Padding(
              padding: EdgeInsets.all(16.w),
              child: ElevatedButton(
                onPressed: () {
                  // Save changes
                  final controller = Get.find<InvoiceController>();
                  controller.updateClientDetails(
                    invoice.id,
                    nameController.text,
                    emailController.text,
                    phoneController.text,
                  );
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 56.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  "Save changes",
                  style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          style: GoogleFonts.urbanist(
            fontSize: 16.sp,
            color: const Color(0xff1C1C1C),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }
}