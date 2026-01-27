import 'package:flutter/material.dart';

import '../../constant/colors.dart';

class FullWidthButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color color;
  final Color textColor;

  const FullWidthButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
