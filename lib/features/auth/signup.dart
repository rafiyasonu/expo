import 'package:flutter/material.dart';

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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController partnerCodeController = TextEditingController();
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
          emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty &&
              selectedCountry != null &&
              isTaxDeclarationChecked;
    });
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
                            isTaxDeclarationChecked = !isTaxDeclarationChecked;
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
                  text: "Get OTP",
                  isEnabled: isButtonEnabled,
                  onPressed: isButtonEnabled ? () {} : null,
                ),

                const SizedBox(height: 15),

                _loginText(),

                const SizedBox(height: 20),
                const Divider(thickness: 1),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton('assets/images/google.png'),
                    const SizedBox(width: 10),
                    const Text(
                      "Signup with Google",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- COUNTRY DROPDOWN ----------------

  Widget countryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCountry,
      hint: const Text(
        "Select Country",
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.public, color: Colors.grey, size: 18),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black12, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black12, width: 1),
        ),
      ),
      items: countries.map((country) {
        return DropdownMenuItem<String>(
          value: country,
          child: Text(country),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCountry = value;
          _validateForm(); // re-check button state
        });
      },
    );
  }

  // ---------------- UI COMPONENTS ----------------

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
          child: Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
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

  Widget _socialButton(String asset) {
    return Container(
      height: 40,
      width: 40,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Image.asset(asset),
    );
  }
}