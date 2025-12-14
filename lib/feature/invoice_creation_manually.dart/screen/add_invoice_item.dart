import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/controller/invoice_manually_controller.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/widget/days_hour_bottom_invoice_sheeet.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/widget/discount_type_invoice_sheet.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/widget/payment_invoice_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddInvoiceItem extends StatelessWidget {
  const AddInvoiceItem({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InvoiceManuallyController());
    
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
                          description: "Once you're all set click \"Done\"",
                        ),
                        SizedBox(height: 12.h),
                      ],
                    )
                  : SizedBox(height: 20.h)),

                SizedBox(height: 20.h),

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
                      onTap: () => DiscountTypeInvoiceSheet.show(context),

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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 18.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "On",
                            style: GoogleFonts.urbanist(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        ],
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
                      onTap: () => DaysHourBottomInvoiceSheeet.show(context),

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
                       SizedBox(width: 8.w),//
                           InkWell(
                      onTap: () => PaymentInvoiceSheet.show(context),

                      child: Image(
                        image: AssetImage(IconPath.leftarrow),
                        height: 24.h,
                        width: 24.w,
                        fit: BoxFit.cover,//
                      ),
                    ),

                      ],
                     ),

                   SizedBox(height: 12.h),
                // --- Service Table ---
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
                        // ignore: deprecated_member_use
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
