import 'package:castle/Screens/HomePage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Colors/Colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.plusJakartaSansTextTheme()
            .copyWith(
              bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 12),
              bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 12),
              bodySmall: GoogleFonts.plusJakartaSans(fontSize: 12),
            )
            .apply(
              bodyColor: containerColor, // Set text color
              displayColor: containerColor,
            ),
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: HomePage(),
    );
  }
}
