import 'package:expo/core/constant/colors.dart';
import 'package:expo/features/profile/verification/identity_verifcation.dart';
import 'package:expo/features/profile/verification/residential_verification.dart';
import 'package:flutter/material.dart';
import 'verification_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// BACK + ACCOUNT TITLE
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _statusCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _depositCard()),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                "Verification steps",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              /// STEP 1
              _verificationStep(
                context,
                step: "1",
                title: "Confirm email and phone number",
                subtitle: "Add profile information · Phone number",
                isActive: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VerificationScreen(),
                    ),
                  );
                },
              ),

              /// STEP 2
              _verificationStep(
                context,
                step: "2",
                title: "Identity verification",
                subtitle: "Upload your ID document",
                isActive: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const IdentityVerificationScreen(),
                    ),
                  );
                },
              ),

              /// STEP 3
              _verificationStep(
                context,
                step: "3",
                title: "Residential address verification",
                subtitle: "Confirm your address",
                isActive: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResidentialVerification(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- CARDS ----------------

  static Widget _statusCard() {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Status", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 8),
          Text(
            "Not verified",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "0/3 steps complete",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  static Widget _depositCard() {
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Deposit limit", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 8),
          Text("0 USD", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(
            "Verify your account to unlock limits",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ---------------- VERIFICATION STEP ----------------

  static Widget _verificationStep(
    BuildContext context, {
    required String step,
    required String title,
    required String subtitle,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor:
                    isActive ? AppColors.primary : Colors.grey.shade400,
                child: Text(
                  step,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),

          if (isActive && onTap != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: onTap,
              child: const Text("Complete now"),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: child,
    );
  }

  static BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}
