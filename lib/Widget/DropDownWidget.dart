import 'package:castle/Colors/Colors.dart';
import 'package:flutter/material.dart';

class DropDownOptionWidget extends StatelessWidget {
  final String label;
  final String hint;
  final List<String> options;

  const DropDownOptionWidget({
    super.key,
    required this.label,
    required this.hint,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      dropdownColor: backgroundColor,
      isExpanded: true, // ✅ Ensure full width
      hint: Text(hint, style: TextStyle(color: Colors.grey, fontSize: 16)),
      decoration: InputDecoration(
        labelText: label, // ✅ Show "Client Name*"
        labelStyle: TextStyle(color: Colors.black, fontSize: 14),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: shadeColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: shadeColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: containerColor),
        ),
      ),
      value: null, // ✅ No default selection
      items: options.map((option) {
        return DropdownMenuItem(
          value: option,
          child: Text(option, style: TextStyle(fontSize: 16)),
        );
      }).toList(),
      onChanged: (value) {},
      icon: Icon(Icons.arrow_drop_down,
          color: Colors.grey), // ✅ Match arrow style
    );
  }
}
