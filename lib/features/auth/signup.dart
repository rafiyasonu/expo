import 'package:expo/features/auth/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:expo/utils/auth_user.dart';
import '../../core/constant/colors.dart';
import '../../core/widget/buttons/dynamic_button.dart';
import '../../core/widget/textfields/my_text_field.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isTaxDeclarationChecked = false;
  bool isPasswordVisible = false;
  bool isButtonEnabled = false;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController partnerCodeController = TextEditingController();

  final AuthUser authUser = AuthUser();

  String? selectedCountry;

  final List<String> countries = [
    'United States',
    'United Kingdom',
    'India',
    'Canada',
    'Australia',
    'Germany',
  ];

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      isButtonEnabled =
          emailController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty &&
          selectedCountry != null &&
          isTaxDeclarationChecked;
    });
  }

  // ================= SIGNUP API =================

  Future<void> signupApi() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await authUser.callApi(
        method: "POST",
        api: "/api/users/signup",
        data: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "location": selectedCountry,
          "partner_code": partnerCodeController.text.trim(),
        },
      );

      print("Signup Response: $response");

      // ✅ Convert status safely (handles int OR string)
      final status = response["status"].toString();

      if (status == "1") {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response["message"] ??
                  "Signup successful. Please verify your email.",
            ),
          ),
        );

        // Go to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VerifyOtpScreen(email: emailController.text.trim())),
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"] ?? "Signup Failed"),
          ),
        );
      }
    } catch (e) {
      print("Signup Error: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Server error. Please try again."),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    partnerCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _backButton(),
                const SizedBox(height: 60),

                const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Create a new account to get started and enjoy seamless access to your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 30),

                MyTextField(
                  label: "Email Address",
                  prefixIcon: Icons.email,
                  controller: emailController,
                ),

                const SizedBox(height: 15),

                MyTextField(
                  label: "Create Password",
                  prefixIcon: Icons.lock,
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  suffixIcon: isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onSuffixTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),

                const SizedBox(height: 15),

                countryDropdown(),

                const SizedBox(height: 15),

                MyTextField(
                  label: "Partner Code",
                  prefixIcon: Icons.numbers,
                  controller: partnerCodeController,
                ),

                const SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isTaxDeclarationChecked,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          isTaxDeclarationChecked = value ?? false;
                          _validateForm();
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isTaxDeclarationChecked =
                                !isTaxDeclarationChecked;
                            _validateForm();
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            "I declare and confirm that I am not a citizen or resident of the US for tax purposes.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                DynamicButton(
                  text: isLoading ? "Please wait..." : "Get OTP",
                  isEnabled: isButtonEnabled && !isLoading,
                  onPressed:
                      isButtonEnabled && !isLoading ? signupApi : null,
                ),

                const SizedBox(height: 15),

                _loginText(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget countryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCountry,
      hint: const Text("Select Country"),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.public),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      items: countries
          .map((country) => DropdownMenuItem(
                value: country,
                child: Text(country),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedCountry = value;
          _validateForm();
        });
      },
    );
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Padding(
          padding: EdgeInsetsDirectional.only(start: 6),
          child: Icon(Icons.arrow_back_ios,
              size: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Login()),
            );
          },
          child: const Text(
            "Sign In",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
