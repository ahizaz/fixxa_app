import 'package:fixxa_app/core/utils/constants/icon_path.dart';
import 'package:fixxa_app/core/utils/constants/image_path.dart';
import 'package:fixxa_app/feature/invoice_creation_manually.dart/screen/invoice_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/quote_dialog.dart';
import 'package:fixxa_app/feature/quote_creation_manually.dart/screen/add_client.dart';
import 'package:fixxa_app/feature/qutoe_invoice_createion.dart/screen/quote_creation.dart';
import 'package:fixxa_app/feature/scanner/screen/scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               
                SizedBox(
                  height: 48.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "Privacy policy",
                        style: GoogleFonts.urbanist(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff000000),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Image(
                              image: const AssetImage(IconPath.backicon),
                              width: 18.w,
                              height: 24.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "Back",
                            style: GoogleFonts.montserrat(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff3A8DFF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                Text(
                  "Privacy Policy",
                  style: GoogleFonts.urbanist(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 8.h),

                Text(
                  "Last updated: March 2, 2026",
                  style: GoogleFonts.urbanist(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 32.h),

                Text(
                  "At FIXXA, we take your privacy seriously. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our services. Please read this policy carefully to understand our practices regarding your personal data.",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),

                // Section 1
                Text(
                  "1. Information We Collect",
                  style: GoogleFonts.urbanist(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "Personal Information",
                  style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                SizedBox(height: 8.h),

                Text(
                  "We may collect personal information that you provide to us, including:",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8.h),

                _buildBulletPoint("Name and contact information (email address, phone number)"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Account credentials (username and password)"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Payment and billing information"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Professional information (business name, tax details)"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Communication preferences"),
                SizedBox(height: 16.h),

                Text(
                  "Usage Information",
                  style: GoogleFonts.urbanist(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                SizedBox(height: 8.h),

                Text(
                  "We automatically collect certain information about your device and how you interact with our services:",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8.h),

                _buildBulletPoint("Device information (IP address, browser type, operating system)"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Usage data (pages visited, features used, time spent)"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Location information (approximate location based on IP address)"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Cookies and similar tracking technologies"),
                SizedBox(height: 32.h),

                // Section 2
                Text(
                  "2. How We Use Your Information",
                  style: GoogleFonts.urbanist(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "We use the information we collect to:",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8.h),

                _buildBulletPoint("Provide, maintain, and improve our services"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Process your transactions and manage your account"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Send you technical notices, updates, and support messages"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Respond to your comments, questions, and customer service requests"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Communicate with you about products, services, and events"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Monitor and analyze trends, usage, and activities"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Detect, prevent, and address technical issues and security threats"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Comply with legal obligations and enforce our terms"),
                SizedBox(height: 32.h),

                // Section 3
                Text(
                  "3. How We Share Your Information",
                  style: GoogleFonts.urbanist(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "We may share your information in the following circumstances:",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8.h),

                _buildBulletPoint("Service Providers: With third-party vendors who perform services on our behalf (payment processing, data analysis, email delivery)"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Business Transfers: In connection with a merger, acquisition, or sale of assets"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Legal Requirements: When required by law or to protect our rights and safety"),
                SizedBox(height: 8.h),
                _buildBulletPoint("With Your Consent: When you explicitly agree to share your information"),
                SizedBox(height: 16.h),

                Text(
                  "We do not sell your personal information to third parties.",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),

                // Section 4
                Text(
                  "4. Data Security",
                  style: GoogleFonts.urbanist(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. These measures include:",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8.h),

                _buildBulletPoint("Encryption of data in transit and at rest"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Regular security assessments and updates"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Access controls and authentication procedures"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Employee training on data protection"),
                SizedBox(height: 16.h),

                Text(
                  "However, no method of transmission over the Internet or electronic storage is 100% secure. While we strive to protect your personal information, we cannot guarantee its absolute security.",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),

                // Section 5
                Text(
                  "5. Your Data Rights",
                  style: GoogleFonts.urbanist(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "You have the following rights regarding your personal information:",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8.h),

                _buildBulletPoint("Access: Request a copy of the personal information we hold about you"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Correction: Request correction of inaccurate or incomplete information"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Deletion: Request deletion of your personal information"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Portability: Request a copy of your data in a structured, machine-readable format"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Opt-out: Unsubscribe from marketing communications"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Object: Object to processing of your personal information"),
                SizedBox(height: 16.h),

                Text(
                  "To exercise these rights, please contact us at support@fixxa.ai.",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),

                // Section 6
                Text(
                  "6. Cookies and Tracking Technologies",
                  style: GoogleFonts.urbanist(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "We use cookies and similar tracking technologies to track activity on our service and store certain information. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent.",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "Types of cookies we use:",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8.h),

                _buildBulletPoint("Essential Cookies: Required for the service to function properly"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Analytics Cookies: Help us understand how users interact with our service"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Preference Cookies: Remember your preferences and settings"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Marketing Cookies: Used to deliver relevant advertisements"),
                SizedBox(height: 32.h),

                // Section 7
                Text(
                  "7. Data Retention",
                  style: GoogleFonts.urbanist(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "We retain your personal information for as long as necessary to provide our services and fulfill the purposes outlined in this Privacy Policy. We will also retain and use your information to comply with legal obligations, resolve disputes, and enforce our agreements.",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),

                // Section 8
                Text(
                  "8. International Data Transfers",
                  style: GoogleFonts.urbanist(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "Your information may be transferred to and maintained on computers located outside of your jurisdiction where data protection laws may differ. We ensure appropriate safeguards are in place to protect your information in accordance with this Privacy Policy.",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),

                // Section 9
                Text(
                  "9. Children's Privacy",
                  style: GoogleFonts.urbanist(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "Our services are not intended for individuals under the age of 18. We do not knowingly collect personal information from children. If you become aware that a child has provided us with personal information, please contact us, and we will take steps to delete such information.",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),

                // Section 10
                Text(
                  "10. Changes to This Privacy Policy",
                  style: GoogleFonts.urbanist(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the \"Last updated\" date. You are advised to review this Privacy Policy periodically for any changes.",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.h),

                // Section 11
                Text(
                  "11. Contact Us",
                  style: GoogleFonts.urbanist(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff3A8DFF),
                  ),
                ),
                SizedBox(height: 16.h),

                Text(
                  "If you have any questions about this Privacy Policy, please contact us:",
                  style: GoogleFonts.urbanist(
                    fontSize: 15.sp,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),

                _buildBulletPoint("Email: support@fixxa.ai"),
                SizedBox(height: 8.h),
                _buildBulletPoint("Phone: +44 7943 568038"),

                SizedBox(height: 40.h),
                // Bottom button
                SizedBox(
                  width: double.infinity,
                  height: 94.h,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImagePath.mainbutton),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 30),
                            Builder(
                              builder: (context) {
                                return InkWell(
                                  onTap: () async {
                                    final RenderBox box =
                                        context.findRenderObject() as RenderBox;
                                    final Offset position = box.localToGlobal(
                                      Offset.zero,
                                    );

                                    final result = await showMenu<String>(
                                      context: context,
                                      color: const Color(0xffF2F2F2),
                                      position: RelativeRect.fromLTRB(
                                        position.dx,
                                        position.dy - 120,
                                        position.dx + 100,
                                        0,
                                      ),
                                      items: [
                                        PopupMenuItem(
                                          value: 'quote',
                                          child: Row(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                  IconPath.createquote,
                                                ),
                                                height: 24.h,
                                                width: 24.w,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Create Quote",
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(
                                                    0xff1C1C1C,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'invoice',
                                          child: Row(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                  IconPath.createinvoice,
                                                ),
                                                height: 24.h,
                                                width: 24.w,
                                                fit: BoxFit.cover,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "Create Invoice",
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color(
                                                    0xff1C1C1C,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'add_client',
                                          child: Row(
                                            children: [
                                              Icon(Icons.person_add, size: 24),
                                              SizedBox(width: 8),
                                              const Text('Add Client'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );

                                    if (result == 'quote') {
                                      QuoteDialog.show(context);
                                    } else if (result == 'invoice') {
                                      InvoiceDialog.show(context);
                                    } else if (result == 'add_client') {
                                      Get.to(() => const AddClient());
                                    }
                                  },
                                  child: Image.asset(
                                    IconPath.plus,
                                    width: 24.w,
                                    height: 24.h,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: () {
                                Get.to(() => ScannerScreen());
                              },
                              child: Image.asset(
                                IconPath.scantext,
                                width: 24.w,
                                height: 24.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: InkWell(
                            onTap: () {
                              showCustomDialog(context);
                            },
                            child: Image.asset(
                              IconPath.voiceai,
                              width: 56.w,
                              height: 56.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            "•",
            style: GoogleFonts.urbanist(
              fontSize: 15.sp,
              color: Colors.grey[800],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
              fontSize: 15.sp,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
