import 'package:flutter/material.dart';
import 'package:expo/core/constant/colors.dart';

class EmailOtpScreen extends StatefulWidget {
  const EmailOtpScreen({super.key});

  @override
  State<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends State<EmailOtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confirm your email"),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "We've sent you an email with verification code",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 6),
            const Text(
              "Enter the code we sent to:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const Text(
              "m*****ft@gmail.com",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            /// 🔹 OTP INPUT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => _otpBox(_controllers[index]),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // STATIC VERIFY
                  Navigator.pop(context);
                },
                child: const Text("Verify"),
              ),
            ),

            TextButton(
              onPressed: () {},
              child: const Text("I didn’t receive a code"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(TextEditingController controller) {
    return SizedBox(
      width: 45,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
