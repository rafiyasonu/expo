import 'dart:async';
import 'dart:convert';
import 'package:expo/features/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/layout/main_layout.dart';
import '../../core/constant/colors.dart';
import '../../core/widget/buttons/dynamic_button.dart';
import '../../core/widget/textfields/my_text_field.dart';
import '../../utils/auth_user.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {

  final TextEditingController otpController = TextEditingController();
  final AuthUser authUser = AuthUser();

  bool isLoading = false;
  bool isButtonEnabled = false;

  bool isResending = false;
  int resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    otpController.addListener(() {
      setState(() {
        isButtonEnabled = otpController.text.isNotEmpty;
      });
    });

    _startResendTimer();
  }

  void _startResendTimer() {
    resendTimer = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer == 0) {
        timer.cancel();
      } else {
        setState(() {
          resendTimer--;
        });
      }
    });
  }

  // ---------------- VERIFY OTP ----------------

  Future<void> verifyOtpApi() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await authUser.callApi(
        method: "POST",
        api: "/api/users/verify-email",
        data: {
          "email": widget.email,
          "otp": otpController.text.trim(),
        },
      );

      print("OTP Response: $response");

      if (response["status"] == 1) {

        final prefs = await SharedPreferences.getInstance();

        final token = response["data"]["token"];
        final user = response["data"]["user"];

        await prefs.setString("token", token);
        await prefs.setString("user_data", jsonEncode(user));
        await prefs.setBool("is_logged_in", true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Login Successful")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
          (route) => false,
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Invalid OTP")),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verification Failed")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ---------------- RESEND OTP ----------------

  Future<void> resendOtpApi() async {

    if (resendTimer > 0 || isResending) return;

    setState(() => isResending = true);

    try {
      final response = await authUser.callApi(
        method: "POST",
        api: "/api/users/resend-otp",
        data: {
          "email": widget.email,
        },
      );

      print("Resend OTP Response: $response");

      if (response["status"] == 1) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "OTP Resent")),
        );

        _startResendTimer();

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Failed to resend OTP")),
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Resend Failed")),
      );
    } finally {
      setState(() => isResending = false);
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 80),

              const Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Enter the OTP sent to ${widget.email}",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              MyTextField(
                controller: otpController,
                label: "Enter OTP",
                keyboardType: TextInputType.number,
                prefixIcon: Icons.security,
              ),

              const SizedBox(height: 15),

              // 🔁 RESEND SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    resendTimer > 0
                        ? "Resend OTP in $resendTimer sec"
                        : "Didn't receive OTP?",
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: resendTimer == 0 ? resendOtpApi : null,
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        color: resendTimer == 0
                            ? AppColors.primary
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              DynamicButton(
                text: isLoading ? "Verifying..." : "Verify OTP",
                isEnabled: isButtonEnabled && !isLoading,
                onPressed: isButtonEnabled && !isLoading
                    ? verifyOtpApi
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
