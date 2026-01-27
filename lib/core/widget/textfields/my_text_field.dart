import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final VoidCallback? onSuffixTap;

  const MyTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: Colors.grey,

      // 🔥 FIX: call the callback here!
      onChanged: onChanged,

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,

        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),

        prefixIcon: Icon(prefixIcon, color: Colors.grey, size: 18),

        suffixIcon: suffixIcon != null
            ? GestureDetector(
          onTap: onSuffixTap,
          child: Icon(
            suffixIcon,
            color: Colors.grey,
          ),
        )
            : null,

        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

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
