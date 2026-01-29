import 'package:flutter/material.dart';
import 'email_otp_screen.dart';
import 'package:expo/core/constant/colors.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification"),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Verify your contact details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "This process takes less than 5 minutes",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            /// 🔹 EMAIL VERIFICATION (CLICKABLE)
            _tile(
              context,
              Icons.email,
              "Confirm email address",
              true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmailOtpScreen(),
                  ),
                );
              },
            ),

            _tile(context, Icons.person, "Add profile information", false),
            _tile(context, Icons.phone, "Confirm phone number", false),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _tile(
    BuildContext context,
    IconData icon,
    String title,
    bool verified, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
            Icon(
              verified ? Icons.check_circle : Icons.arrow_forward_ios,
              size: 18,
              color: verified ? Colors.green : Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
