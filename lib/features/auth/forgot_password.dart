import 'package:flutter/material.dart';
import '../../core/constant/colors.dart';
import '../../core/widget/buttons/dynamic_button.dart';
import '../../core/widget/textfields/my_text_field.dart';
import '../../utils/auth_user.dart';
import 'forgot_password_otp.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final TextEditingController emailController = TextEditingController();
  final AuthUser _authUser = AuthUser();

  bool isButtonEnabled = false;
  bool isLoading = false;

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

  Future<void> _forgotPassword() async {
    if (!isButtonEnabled || isLoading) return;

    setState(() => isLoading = true);

    try {
      final response = await _authUser.
      callApi(
        method: "POST",
        api: "/api/users/forgot-password",
        data: {
          "email": emailController.text.trim(),
        },
      );

      print("Forgot Password Response: $response");

      if (response["status"] == 1) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"] ?? "OTP sent to your email"),
          ),
        );

        // Navigate to OTP screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ForgotPasswordOtp(
              email: emailController.text.trim(),
            ),
          ),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"] ?? "Something went wrong"),
          ),
        );
      }

    } catch (e) {
      print("Forgot Password Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Request Failed"),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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
                      onTap: () => Navigator.pop(context),
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
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 18,
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
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              MyTextField(
                controller: emailController,
                label: "Email Address",
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 30),

              DynamicButton(
                text: isLoading ? "Submitting..." : "Submit",
                isEnabled: isButtonEnabled && !isLoading,
                onPressed: isButtonEnabled && !isLoading
                    ? _forgotPassword
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
