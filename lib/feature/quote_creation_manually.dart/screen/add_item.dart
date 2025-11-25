import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/widget/days_hour_botttom_sheet.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/widget/discount_type_bottom_sheet.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/widget/payment_bottom_sheet.dart';
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
                          });
                        }

                        // Optionally clear controllers
                        controller.descriptionController.clear();
                        controller.estimatedCostController.clear();
                        controller.quantityController.clear();
                        controller.discountType.value = "None";
                        controller.isTaxable.value = false;
                        controller.dayhour.value = "Days";

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

                // --- Moved fields: Issue Date, Due Date, Discount amount/type, VAT rate (visible when VAT on), Signature ---
                Row(
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
                ),
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

                    // --- Service Table (shows current service items) ---
                    SizedBox(height: 12.h),
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
                          onPressed: () {
                            final descCtrl = TextEditingController();
                            final serviceCtrl = TextEditingController();
                            final rateCtrl = TextEditingController();
                            final durationCtrl = TextEditingController();

                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Add Service', style: GoogleFonts.urbanist()),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(controller: descCtrl, decoration: InputDecoration(labelText: 'Description')),
                                      TextField(controller: serviceCtrl, decoration: InputDecoration(labelText: 'Service')),
                                      TextField(controller: rateCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Rate')),
                                      TextField(controller: durationCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Duration')),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
                                  TextButton(
                                    onPressed: () {
                                      final desc = descCtrl.text.trim();
                                      final service = serviceCtrl.text.trim();
                                      final rate = double.tryParse(rateCtrl.text) ?? 0.0;
                                      final duration = int.tryParse(durationCtrl.text) ?? 1;
                                      controller.addService(description: desc, service: service, rate: rate, duration: duration);
                                      Navigator.pop(ctx);
                                    },
                                    child: Text('Add'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.add, size: 22.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
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
                              final service = (item['service'] ?? item['dayhour'] ?? '-').toString();
                              final rate = item['rate'] != null ? item['rate'].toString() : '-';
                              final duration = item['quantity'] != null ? item['quantity'].toString() : '-';
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
                    ),

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
                          onPressed: () {
                            final matCtrl = TextEditingController();
                            final qtyCtrl = TextEditingController();
                            final unitCtrl = TextEditingController();

                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Add Material', style: GoogleFonts.urbanist()),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(controller: matCtrl, decoration: InputDecoration(labelText: 'Material')),
                                    TextField(controller: qtyCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Quantity')),
                                    TextField(controller: unitCtrl, decoration: InputDecoration(labelText: 'Unit Price')),
                                  ],
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
                                  TextButton(
                                    onPressed: () {
                                      final mat = matCtrl.text.trim();
                                      final qty = int.tryParse(qtyCtrl.text) ?? 1;
                                      final unit = unitCtrl.text.trim();
                                      controller.addMaterial(material: mat, quantity: qty, unitPrice: unit);
                                      Navigator.pop(ctx);
                                    },
                                    child: Text('Add'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.add, size: 22.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Container(
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
                    ),

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

class _UpwardSpotlightBubble extends StatelessWidget {
  final String title;
  final String description;

  const _UpwardSpotlightBubble({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

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
        // Upward pointing arrow
        Positioned(
          top: -10.h,
          right: 24.w,
          child: CustomPaint(
            size: Size(20, 10),
            painter: _UpwardBubbleArrowPainter(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _UpwardBubbleArrowPainter extends CustomPainter {
  final Color color;
  _UpwardBubbleArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
