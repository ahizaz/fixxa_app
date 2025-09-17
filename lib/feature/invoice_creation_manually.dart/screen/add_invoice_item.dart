import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/widget/days_hour_bottom_invoice_sheeet.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/widget/discount_type_invoice_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddInvoiceItem extends StatelessWidget {
const AddInvoiceItem({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvoiceManuallyController());
  return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Row
                Row(
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
                 // ...existing code...
GestureDetector(
  onTap: () {
    // Collect values from controllers
    final description = controller.descriptionController.text;
    final rate = double.tryParse(controller.estimatedCostController.text) ?? 0.0;
    final quantity = int.tryParse(controller.quantityController.text) ?? 1;
    final discountType = controller.discountType.value;
    final isTaxable = controller.isTaxable.value;
    final dayhour = controller.dayhour.value;

    // Add item to controller's items list
    controller.items.add({
      'description': description,
      'rate': rate,
      'quantity': quantity,
      'discountType': discountType,
      'isTaxable': isTaxable,
      'dayhour': dayhour,
      'price': rate * quantity, // You can adjust price calculation as needed
    });

    // Optionally clear controllers
    controller.descriptionController.clear();
    controller.estimatedCostController.clear();
    controller.quantityController.clear();

    // Go back to previous screen
    Get.back();
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
// ...existing code...
                  ],
                ),

                SizedBox(height: 20.h),

                /// Description Box
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    controller: controller.descriptionController,
                    maxLines: 5,
                    style: GoogleFonts.urbanist(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write item description...",
                      hintStyle: GoogleFonts.urbanist(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                      labelText: "Description (Optional)",
                      labelStyle: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff434343),
                      ),
                      alignLabelWithHint: true,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// Estimated Cost + Quantity
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: TextField(
                          controller: controller.estimatedCostController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.urbanist(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Rate",
                            labelStyle: GoogleFonts.urbanist(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                            hintText: "£0.00",
                            hintStyle: GoogleFonts.urbanist(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: TextField(
                          controller: controller.quantityController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.urbanist(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Quantity (days)",
                            labelStyle: GoogleFonts.urbanist(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                            hintText: "0",
                            hintStyle: GoogleFonts.urbanist(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),

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
                    Obx(() => Text(
                          controller.discountType.value,
                          style: GoogleFonts.urbanist(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff3A8DFF),
                          ),
                        )),
                    SizedBox(width: 8.w),
                    InkWell(
                      
                     onTap: () => DiscountTypeInvoiceSheet.show(context),
                      
                      child: Image(
                        image: AssetImage(IconPath.leftarrow),
                        height: 24.h,
                        width: 24.w,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 24.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                       Text(
                      "Taxable",
                      style: GoogleFonts.montserrat(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff1C1C1C),
                      ),
                    ),
                    Obx(()=>Switch(value: controller.isTaxable.value, onChanged: (val){
                     controller.isTaxable.value = val;
                    },
                     activeColor: Colors.blue,
                    
                    ))
                  ],
                ),

                  SizedBox(height: 24.h,),
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
                              Obx(() => Text(
                          controller.dayhour.value,
                          style: GoogleFonts.urbanist(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff3A8DFF),
                          ),
                        )),
                        SizedBox(width: 8.w),
                                InkWell(
                      
                            onTap: () => DaysHourBottomInvoiceSheeet.show(context),
                      
                      child: Image(
                        image: AssetImage(IconPath.leftarrow),
                        height: 24.h,
                        width: 24.w,
                        fit: BoxFit.cover,
                      ),
                    )

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