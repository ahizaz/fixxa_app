import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/widget/days_hour_bottom_invoice_sheeet.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/widget/discount_type_invoice_sheet.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/widget/payment_invoice_sheet.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/widget/combined_invoice_items_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddInvoiceItem extends StatelessWidget {
  const AddInvoiceItem({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvoiceManuallyController());

    // Use controllers from InvoiceManuallyController (kept in controller)

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
                    GestureDetector(
                      onTap: () async {
                        // Only save if there's actual data in the form fields
                        final hasDescription = controller.descriptionController.text
                            .trim()
                            .isNotEmpty;
                        final hasRate = controller.estimatedCostController.text
                            .trim()
                            .isNotEmpty;

                        if (hasDescription || hasRate) {
                          // Collect values from controllers
                          final description =
                              controller.descriptionController.text;
                          final rate =
                              double.tryParse(
                                controller.estimatedCostController.text,
                              ) ??
                              0.0;
                          final quantity =
                              int.tryParse(controller.quantityController.text) ??
                              1;
                          final discountType = controller.discountType.value;
                          final isTaxable = controller.isTaxable.value;
                          final dayhour = controller.dayhour.value;

                          // Check if we're editing an existing item or adding a new one
                          if (controller.editItemIndex != null) {
                            // Update existing item
                            controller.items[controller.editItemIndex!] = {
                              'description': description,
                              'rate': rate,
                              'quantity': quantity,
                              'discountType': discountType,
                              'isTaxable': isTaxable,
                              'dayhour': dayhour,
                              'price': rate * quantity,
                              'bank_name': controller.bankNameController.text.trim(),
                              'account_name': controller.accountNameController.text.trim(),
                              'sort_code': controller.sortCodeController.text.trim(),
                              'account_no': controller.accountNoController.text.trim(),
                            };
                            // Reset edit index
                            controller.editItemIndex = null;
                          } else {
                            // Add new item to controller's items list
                            controller.items.add({
                              'description': description,
                              'rate': rate,
                              'quantity': quantity,
                              'discountType': discountType,
                              'isTaxable': isTaxable,
                              'dayhour': dayhour,
                              'price': rate * quantity,
                              'bank_name': controller.bankNameController.text.trim(),
                              'account_name': controller.accountNameController.text.trim(),
                              'sort_code': controller.sortCodeController.text.trim(),
                              'account_no': controller.accountNoController.text.trim(),
                            });
                          }

                          // Clear controllers
                          controller.descriptionController.clear();
                          controller.estimatedCostController.clear();
                          controller.quantityController.clear();
                          controller.setDiscountType("None");
                          controller.isTaxable.value = false;
                          controller.dayhour.value = "Days";
                          controller.bankNameController.clear();
                          controller.accountNameController.clear();
                          controller.sortCodeController.clear();
                          controller.accountNoController.clear();
                        }

                        // Create invoice and fetch financials from backend
                        final success = await controller.createInvoice();
                        if (success) {
                          Get.back();
                          // Fetch financial details if needed
                          if (controller.invoiceId.value != null) {
                            await controller.fetchFinancials(id: controller.invoiceId.value);
                          }
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
                ),

                // --------- Spotlight Bubble for Done Button -----------
                Obx(
                  () => controller.showAddItemScreenSpotlight.value
                      ? Column(
                          children: [
                            SizedBox(height: 8.h),
                            SpotlightBubble(
                              title: "Done",
                              description: "Once you're all set click \"Done\"",
                            ),
                            SizedBox(height: 12.h),
                          ],
                        )
                      : SizedBox(height: 20.h),
                ),

                // Dates
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate:
                                  controller.issueDate.value ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              controller.issueDate.value = date;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8.r),
                              color: Colors.white,
                            ),
                            child: Text(
                              controller.issueDate.value != null
                                  ? "${controller.issueDate.value!.day}/${controller.issueDate.value!.month}/${controller.issueDate.value!.year}"
                                  : 'Issue Date',
                              style: GoogleFonts.urbanist(
                                fontSize: 16.sp,
                                color: controller.issueDate.value != null
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Obx(
                        () => InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate:
                                  controller.dueDate.value ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              controller.dueDate.value = date;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8.r),
                              color: Colors.white,
                            ),
                            child: Text(
                              controller.dueDate.value != null
                                  ? "${controller.dueDate.value!.day}/${controller.dueDate.value!.month}/${controller.dueDate.value!.year}"
                                  : 'Due Date',
                              style: GoogleFonts.urbanist(
                                fontSize: 16.sp,
                                color: controller.dueDate.value != null
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // TextField(
                //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                //   decoration: InputDecoration(
                //     hintText: 'Discount amount',
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(8.r),
                //     ),
                //     filled: true,
                //     fillColor: Colors.white,
                //   ),
                //   onChanged: (v) {
                //     controller.discountAmount.value = double.tryParse(v) ?? 0.0;
                //   },
                // ),
                // SizedBox(height: 12.h),
                Obx(
                  () => controller.isTaxable.value
                      ? Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                hintText: 'VAT rate (%)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              onChanged: (v) {
                                controller.vatRate.value =
                                    double.tryParse(v) ?? 0.0;
                              },
                            ),
                            SizedBox(height: 12.h),
                          ],
                        )
                      : SizedBox.shrink(),
                ),
                SizedBox(height: 12.h),
                // --- Items Section ---
                Row(
                  children: [
                    Text(
                      'Items',
                      style: GoogleFonts.montserrat(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff434343),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () =>
                          controller.showAddCombinedItemDialog(context),
                      icon: Icon(Icons.add, size: 22.sp),
                      tooltip: 'Add Item',
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                CombinedInvoiceItemsTable(controller: controller),

                SizedBox(height: 12.h),

                // Bank details fields (local to this add-item screen)
                TextField(
                  controller: controller.bankNameController,
                  decoration: InputDecoration(
                    hintText: 'Bank Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: controller.accountNameController,
                  decoration: InputDecoration(
                    hintText: 'Account Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.sortCodeController,
                        decoration: InputDecoration(
                          hintText: 'Sort Code',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: controller.accountNoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Account No',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                /// Discount Type
           
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SpotlightBubble extends StatelessWidget {
  final String title;
  final String description;

  const SpotlightBubble({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: GoogleFonts.urbanist(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        // Arrow pointer
        Positioned(
          bottom: -10.h,
          left: 24.w,
          child: CustomPaint(
            size: Size(20, 10),
            painter: _BubbleArrowPainter(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _BubbleArrowPainter extends CustomPainter {
  final Color color;
  _BubbleArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
