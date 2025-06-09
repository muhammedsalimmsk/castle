import 'package:flutter/material.dart';

import '../Colors/Colors.dart';
class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  const CustomTextField({super.key, required this.hint, this.icon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          suffixIcon: Icon(icon),
          hintText: hint,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: containerColor),),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: shadeColor)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color:shadeColor))),
    );
  }
}