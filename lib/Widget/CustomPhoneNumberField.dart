import 'package:castle/Colors/Colors.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomPhoneNumberField extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      disableLengthCheck: true,
      controller: phoneController,

      decoration: InputDecoration(
        labelText: "Phone Number",
        focusedBorder: OutlineInputBorder(
          borderRadius:  BorderRadius.circular(8),
          borderSide: BorderSide(color: containerColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: shadeColor),
        ),
      ),
      initialCountryCode: 'NG', // Default to Nigeria (+234)
      onChanged: (phone) {
        print('Phone number: ${phone.completeNumber}');
      },
    );
  }
}
