import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/widget/days_hour_botttom_sheet.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/widget/discount_type_bottom_sheet.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/widget/payment_bottom_sheet.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/widget/service_table.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/widget/material_table.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/widget/add_item_header.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/widget/date_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/controller/manually_quote_controller.dart';

class AddItem extends StatelessWidget {
  const AddItem({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ManuallyQuoteController());
    
    // Start spotlight when screen loads (only first time)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startAddItemScreenSpotlight();
    });

    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                AddItemHeader(controller: controller),

                // --------- Spotlight Bubble for Done Button -----------
                Obx(() => controller.showAddItemScreenSpotlight.value 
                  ? Column(
                      children: [
                        SizedBox(height: 8.h),
                        SpotlightBubble(
                          title: "Done",
                          description: "Once you’re all set click “Done”",
                        ),
                        SizedBox(height: 12.h),
                      ],
                    )
                  : SizedBox(height: 20.h)),

                // Dates
                DateRow(controller: controller),
                SizedBox(height: 12.h),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Discount amount',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (v) {
                    controller.discountAmount.value = double.tryParse(v) ?? 0.0;
                  },
                ),
                SizedBox(height: 12.h),
                Obx(() => controller.isTaxable.value
                  ? Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            hintText: 'VAT rate (%)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (v) {
                            controller.vatRate.value = double.tryParse(v) ?? 0.0;
                          },
                        ),
                        SizedBox(height: 12.h),
                      ],
                    )
                      : SizedBox.shrink()),
                    SizedBox(height: 12.h),
                    // --- Service Table (shows current service items) ---
                    Row(
                      children: [
                        Text(
                          'Service Table',
                          style: GoogleFonts.montserrat(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff434343),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => controller.showAddServiceDialog(context),
                          icon: Icon(Icons.add, size: 22.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ServiceTable(controller: controller),

                    SizedBox(height: 12.h),
                    // --- Material Table (demo layout) ---
                    Row(
                      children: [
                        Text(
                          'Material Table',
                          style: GoogleFonts.montserrat(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff434343),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => controller.showAddMaterialDialog(context),
                          icon: Icon(Icons.add, size: 22.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    MaterialTable(controller: controller),

                    SizedBox(height: 12.h),
                    Text('Signature', style: GoogleFonts.montserrat(fontSize: 13.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 6.h),
                Obx(() => InkWell(
                  onTap: () => controller.showSignatureDialog(context),
                  child: Container(
                    width: double.infinity,
                    height: 120.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                    ),
                    child: controller.hasSignature.value && controller.signatureBytes != null
                        ? Image.memory(controller.signatureBytes!, fit: BoxFit.contain)
                        : Center(child: Text('Tap here to sign')),
                  ),
                )),
                SizedBox(height: 16.h),

                /// Discount Type
                Row(
                  children: [
                    Text(
                      "Discount type",
                      style: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff1C1C1C),
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => Text(
                        controller.discountType.value,
                        style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff3A8DFF),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: () => DiscountTypeBottomSheet.show(context),

                      child: Image(
                        image: AssetImage(IconPath.leftarrow),
                        height: 24.h,
                        width: 24.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Vat",
                      style: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff1C1C1C),
                      ),
                    ),
                    Obx(
                      () => Switch(
                        value: controller.isTaxable.value,
                        onChanged: (val) {
                          controller.isTaxable.value = val;
                        },
                        activeThumbColor: Colors.blue,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),
                Row(
                  children: [
                    Text(
                      "Days or hours",
                      style: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff1C1C1C),
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => Text(
                        controller.dayhour.value,
                        style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff3A8DFF),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: () => DaysHourBotttomSheet.show(context),

                      child: Image(
                        image: AssetImage(IconPath.leftarrow),
                        height: 24.h,
                        width: 24.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                       Text(
                      "Payment",
                      style: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff1C1C1C),
                      ),
                    ),
                    const Spacer(),
                       Obx(
                      () => Text(
                        controller.payment.value,
                        style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff3A8DFF),
                        ),
                      ),
                    ),
                     SizedBox(width: 8.w),
                         InkWell(
                      onTap: () => PaymentBottomSheet.show(context),

                      child: Image(
                        image: AssetImage(IconPath.leftarrow),
                        height: 24.h,
                        width: 24.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


