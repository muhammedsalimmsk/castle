import 'package:flutter/material.dart';
import '../Colors/Colors.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final String? label; // ✅ Make label optional
  final IconData? icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final bool enable;

  const CustomTextField(
      {super.key,
      required this.hint,
      this.label, // ✅ Optional label
      this.icon,
      this.keyboardType,
      required this.controller,
      this.validator,
      this.maxLines = 1,
      this.enable = true});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      style: TextStyle(color: containerColor),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        enabled: enable,
        hintStyle: TextStyle(color: subtitleColor),
        floatingLabelBehavior: label != null
            ? FloatingLabelBehavior.always
            : FloatingLabelBehavior.never,
        suffixIcon: icon != null ? Icon(icon, color: shadeColor) : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: buttonColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
