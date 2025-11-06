import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fixxa_app/feature/account%20create&authentication/controller/create_account_controller.dart';

class ResendPasswordCheckOtp extends StatelessWidget {
  const ResendPasswordCheckOtp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateAccountController>();
    
    // Create 6 TextEditingControllers and FocusNodes for OTP fields
    final List<TextEditingController> otpControllers = List.generate(
      6,
      (index) => TextEditingController(),
    );
    final List<FocusNode> focusNodes = List.generate(
      6,
      (index) => FocusNode(),
    );
    
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        title: const Text('Password Reset OTP'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_reset_outlined,
                size: 80,
                color: Color.fromRGBO(114, 178, 238, 1),
              ),
              const SizedBox(height: 30),
              const Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Enter the 6-digit code sent to:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.createaccountemailController.text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(114, 178, 238, 1),
                ),
              ),
              const SizedBox(height: 40),
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 50,
                    height: 60,
                    child: TextField(
                      controller: otpControllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE8E8E8),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(114, 178, 238, 1),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffE8E8E8),
                            width: 2,
                          ),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          // Move to next field
                          focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          // Move to previous field
                          focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Collect OTP from all fields
                    String otp = otpControllers.map((c) => c.text).join();
                    if (otp.length == 6) {
                      // Verify OTP via API
                      controller.verifyPasswordResetOtp(otp);
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please enter complete 6-digit OTP',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(114, 178, 238, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  controller.resendPasswordOtp();
                },
                child: const Text(
                  'Resend OTP',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(114, 178, 238, 1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}