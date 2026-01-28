import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ACCOUNT TITLE
            const Text(
              "Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// STATUS + DEPOSIT LIMIT
            Row(
              children: [
                Expanded(child: _statusCard()),
                const SizedBox(width: 12),
                Expanded(child: _depositCard()),
              ],
            ),

            const SizedBox(height: 24),

            /// VERIFICATION STEPS
            const Text(
              "Verification steps",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _verificationStep(
              step: "1",
              title: "Confirm email and phone number",
              subtitle:
                  "Add profile information · Phone number",
              buttonText: "Complete now",
              isActive: true,
            ),

            _verificationStep(
              step: "2",
              title: "Identity verification",
              subtitle: "Upload your ID document",
              isActive: false,
            ),

            _verificationStep(
              step: "3",
              title: "Residential address verification",
              subtitle: "Confirm your address",
              isActive: false,
            ),
          ],
        ),
      ),
    );
  }

  /// STATUS CARD
  static Widget _statusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Status", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 8),
          Text(
            "Not verified",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
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

  /// DEPOSIT CARD
  static Widget _depositCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Deposit limit", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 8),
          Text(
            "0 USD",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Verify your account to unlock limits",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// VERIFICATION STEP CARD
  static Widget _verificationStep({
    required String step,
    required String title,
    required String subtitle,
    required bool isActive,
    String? buttonText,
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
                    isActive ? Colors.blue : Colors.grey.shade400,
                child: Text(
                  step,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade600,
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey),
          ),
          if (buttonText != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              onPressed: () {},
              child: Text(buttonText),
            )
          ]
        ],
      ),
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
