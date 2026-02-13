import 'package:flutter/material.dart';
import '../../utils/auth_user.dart';
import '../auth/login.dart';

class ForgotPasswordOtp extends StatefulWidget {
  final String email;

  const ForgotPasswordOtp({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ForgotPasswordOtp> createState() => _ForgotPasswordOtpState();
}

class _ForgotPasswordOtpState extends State<ForgotPasswordOtp> {

  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthUser _authUser = AuthUser();

  bool isLoading = false;
  bool isPasswordVisible = false;

  bool get isButtonEnabled =>
      _otpController.text.isNotEmpty &&
      _passwordController.text.length >= 6;

  Future<void> _resetPassword() async {

    if (!isButtonEnabled || isLoading) return;

    setState(() => isLoading = true);

    try {
      final response = await _authUser.callApi(
        method: "POST",
        api: "/api/users/reset-password", // change if needed
        data: {
          "email": widget.email,
          "otp": _otpController.text.trim(),
          "newPassword": _passwordController.text.trim(),
        },
      );

      print("Reset Password Response: $response");

      if (response["status"] == 1) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response["message"] ?? "Password reset successful",
            ),
          ),
        );

        // Navigate to Login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
          (route) => false,
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"] ?? "Invalid OTP"),
          ),
        );
      }

    } catch (e) {
      print("Reset Password Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              'Reset your password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Prefilled Email (Read Only)
            TextField(
              controller: TextEditingController(text: widget.email),
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // OTP Field
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // New Password Field
            TextField(
              controller: _passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled && !isLoading
                    ? _resetPassword
                    : null,
                child: Text(
                  isLoading ? "Resetting..." : "Reset Password",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
