import 'package:flutter/material.dart';

class OnboardingTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;

  const OnboardingTextfield({
    super.key,
    required this.controller,
    required this.label,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: Colors.grey,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,



        // Label
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),

        // Optional suffix icon
        suffixIcon:
        suffixIcon != null ? Icon(suffixIcon, color: Colors.grey, size: 19) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        // Borders
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
