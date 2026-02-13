import 'dart:convert';
import 'package:expo/core/layout/main_layout.dart';
import 'package:expo/features/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constant/colors.dart';
import '../../core/widget/buttons/dynamic_button.dart';
import '../../core/widget/textfields/my_text_field.dart';
import 'package:expo/utils/auth_user.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthUser authUser = AuthUser();

  bool isButtonEnabled = false;
  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    _checkLoginStatus(); // 👈 Auto-login check
  }

  // ================= AUTO LOGIN =================
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token != null && token.isNotEmpty) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainLayout()),
        (route) => false,
      );
    }
  }

  void _validateForm() {
    setState(() {
      isButtonEnabled =
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    });
  }

  // ================= LOGIN API =================
  Future<void> loginApi() async {
    setState(() => isLoading = true);

    try {
      final response = await authUser.callApi(
        method: "POST",
        api: "/api/users/login",
        data: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      print("Login Response: $response");

      if (response["status"] == 1) {
        final prefs = await SharedPreferences.getInstance();

        final token = response["data"]["token"];
        final user = response["data"]["user"];

        await prefs.setString("token", token);
        await prefs.setString("user_data", jsonEncode(user));
        await prefs.setBool("is_logged_in", true);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Login Successful")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
          (route) => false, // 🚫 no back to login
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Login Failed")),
        );
      }
    } catch (e) {
      print("Login Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 10, 15, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your email and password to securely access and manage your account.",
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
                const SizedBox(height: 15),

                MyTextField(
                  controller: passwordController,
                  label: "Your Password",
                  prefixIcon: Icons.lock,
                  obscureText: !isPasswordVisible,
                  suffixIcon: isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onSuffixTap: () {
                    setState(() => isPasswordVisible = !isPasswordVisible);
                  },
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotPassword()),
                      );
                    },
                    child: const Text("Forgot Password"),
                  ),
                ),

                const SizedBox(height: 12),

                DynamicButton(
                  text: isLoading ? "Please wait..." : "Login",
                  isEnabled: isButtonEnabled && !isLoading,
                  onPressed: isButtonEnabled && !isLoading ? loginApi : null,
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Do not have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Signup()),
                        );
                      },
                      child: const Text(
                        "Sign up now",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
