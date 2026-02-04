import 'package:flutter/material.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  bool showHelpScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm phone number'),
        leading: showHelpScreen
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    showHelpScreen = false;
                  });
                },
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: showHelpScreen ? _helpView() : _otpView(),
      ),
    );
  }

  // ================= OTP VIEW =================
  Widget _otpView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter the code we sent via SMS or a messaging app:',
        ),
        const SizedBox(height: 6),
        const Text(
          '+55 95 2595 2621',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (_) => _otpBox()),
        ),

        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Look for a code from verified account: Exness.\n'
            'Only a 6-digit code. No links or files.',
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Get a new code in 00:48',
          style: TextStyle(color: Colors.grey),
        ),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: () {
            setState(() {
              showHelpScreen = true;
            });
          },
          child: const Text(
            "I didn't receive a code",
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),

        const Spacer(),

        const Center(
          child: Text(
            '🔒 All data is encrypted for security',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        )
      ],
    );
  }

  // ================= HELP VIEW =================
  Widget _helpView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'If you did not receive an SMS',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        const Text('Make sure that:'),
        const SizedBox(height: 8),

        _bullet('You have a strong network connection'),
        _bullet('Your phone has available memory'),
        _bullet('You do not have active SMS restrictions'),

        const SizedBox(height: 20),

        const Text('Consider:'),
        const SizedBox(height: 8),

        _bullet('Restarting your phone'),
        _bullet('Requesting a new code'),

        const SizedBox(height: 20),

        GestureDetector(
          onTap: () {
            // handle can't access device
          },
          child: const Text(
            "I can't access my device",
            style: TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),

        const Spacer(),

        const Center(
          child: Text(
            '🔒 All data is encrypted for security',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        )
      ],
    );
  }

  // ================= COMMON WIDGETS =================
  Widget _otpBox() {
    return SizedBox(
      width: 45,
      child: TextField(
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
