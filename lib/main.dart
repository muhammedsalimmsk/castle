import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Screens/HomePage/HomePage.dart';
import 'package:castle/Screens/LoginPage/LoginPage.dart';
import 'package:castle/Screens/SplashScreen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Colors/Colors.dart';
import 'Model/auth_model/auth_model.dart';
import 'Screens/ClientPage/ClientPage.dart';
import 'Screens/ComplaintsPage/ComplaintPage.dart';
import 'Screens/EquipmentPage/EquipmentPage.dart';
import 'Screens/HomePage/AdminHomePage.dart';
import 'Screens/HomePage/ClientHomePage.dart';
import 'Screens/HomePage/WorkerHomePage.dart';
import 'Screens/PartsRequestPagee/PartsListPage.dart';
import 'Screens/PartsRequestPagee/PartsRequestPage.dart';
import 'Screens/RoutineScreens/RoutinePage/RoutinePage.dart';
import 'Screens/RoutineScreens/WorkerRoutinePage.dart';
import 'Screens/WorkersPage/WorkersPage.dart';
import 'Services/ApiService.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true;
  usePathUrlStrategy();
  runApp(const MyApp());
}

Future<bool> checkTokenStatus() async {
  final prefs = await SharedPreferences.getInstance();

  final jwToken = prefs.getString('token');
  token = jwToken;

  final refreshToken = prefs.getString('refreshToken');
  final expiresAtStr = prefs.getString('expiresAt');

  if (token == null || refreshToken == null || expiresAtStr == null) {
    return false;
  }

  final expiresAt = DateTime.tryParse(expiresAtStr);
  if (expiresAt == null) return false;

  final now = DateTime.now();

  // ✅ Check if token is expired
  if (now.isAfter(expiresAt)) {
    try {
      final apiService = ApiService();
      final response = await apiService.postRequest(
        '/api/v1/auth/refresh',
        {'refreshToken': refreshToken},
      );

      if (response.isOk) {
        final model = AuthModel.fromJson(response.body);
        await prefs.setString('token', model.data?.token ?? '');
        await prefs.setString('refreshToken', model.data?.refreshToken ?? '');
        await prefs.setString(
          'expiresAt',
          model.data?.expiresAt?.toIso8601String() ?? '',
        );
        return true;
      } else {
        return false; // Refresh failed
      }
    } catch (e) {
      print("Error refreshing token: $e");
      return false;
    }
  } else {
    return true; // Token still valid
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: backgroundColor,
        fontFamily: GoogleFonts.ptSans().fontFamily, // 👈 Add this line
        textTheme: GoogleFonts.ptSansTextTheme().apply(
          bodyColor: containerColor,
          displayColor: containerColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
      ),
      getPages: [
        GetPage(name: '/home', page: () => DashboardPage()),
        GetPage(name: '/workerHome', page: () => WorkerHomePage()),
        GetPage(name: '/clientHome', page: () => ClientHomePage()),
        GetPage(name: '/equipment', page: () => EquipmentPage()),
        GetPage(name: '/complaints', page: () => ComplaintPage()),
        GetPage(name: '/routine', page: () => RoutinePage()),
        GetPage(name: '/workerRoutine', page: () => WorkerRoutinePage()),
        GetPage(name: '/partsList', page: () => PartsListPage()),
        GetPage(name: '/clients', page: () => ClientPage()),
        GetPage(name: '/workers', page: () => WorkersPage()),
        GetPage(name: '/requestedParts', page: () => RequestedPartsPage()),
        // add more as needed
      ],
      home: SplashScreen(),
    );
  }
}
