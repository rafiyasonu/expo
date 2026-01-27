import 'package:flutter/material.dart';

import '../../core/constant/colors.dart';
import '../../core/widget/buttons/dynamic_button.dart';
import '../../core/widget/textfields/my_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _LoginState();
}

class _LoginState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  bool isButtonEnabled = false;

  // final AuthUser _authUser = AuthUser();
  bool isLoading = false;

  // Future<void> _forgotPassword() async {
  //   if (!isButtonEnabled || isLoading) return;
  //
  //   setState(() => isLoading = true);
  //
  //   final response = await _authUser.callApi(
  //     method: "POST",
  //     api: "/forgot_password",
  //     requireAuth: false,
  //     data: {
  //       "email": emailController.text.trim(),
  //     },
  //   );
  //
  //   setState(() => isLoading = false);
  //
  //   if (response != null && response["status"] == 1) {
  //     final memberId =
  //     response["response"]?["data"]?["member_id"]?.toString();
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("OTP sent to your email"),
  //       ),
  //     );
  //
  //     // 🔜 NEXT STEP (recommended):
  //     // Navigate to OTP verification screen for password reset
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => ForgotPasswordOtp(
  //           email: emailController.text.trim(),
  //           memberId: memberId!,
  //         ),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(response?["message"] ?? "Something went wrong"),
  //       ),
  //     );
  //   }
  // }


  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateForm);
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  void _validateForm() {
    setState(() {
      isButtonEnabled =
          emailController.text.isNotEmpty &&
              _isValidEmail(emailController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 90),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // ← Go back
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            6,
                            0,
                            0,
                            0,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 18, // optional: reduce size so it fits nicely
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your email address to receive a reset link and regain access to your account",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textColor, fontSize: 14, fontWeight: FontWeight.w500,),
              ),
              const SizedBox(height: 30),

              MyTextField(
                controller: emailController,
                label: "Email Address",
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 30),

              // Login Button
              DynamicButton(
                text: isLoading ? "Submitting..." : "Submit",
                isEnabled: isButtonEnabled && !isLoading,
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => ForgotPasswordOtp(
                  //
                  //     ),
                  //   ),
                  // );
                }
              ),

            ],
          ),
        ),
      ),
    );
  }

}
