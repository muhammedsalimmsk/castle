import 'package:castle/Colors/Colors.dart';
import 'package:castle/Screens/HomePage/AdminHomePage.dart';
import 'package:castle/Screens/HomePage/ClientHomePage.dart';
import 'package:castle/Screens/HomePage/WorkerHomePage.dart';
import 'package:flutter/material.dart';
import 'package:castle/Screens/HomePage/HomePage.dart';
import 'package:castle/Screens/LoginPage/LoginPage.dart';
import 'package:get/get.dart';
import '../../Controlls/AuthController/AuthController.dart';
import '../../main.dart'; // Your token check logic

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final AuthController controller = Get.put(AuthController());

  Future<Widget> checkAuth() async {
    bool isTokenValid = await checkTokenStatus();
    if (isTokenValid) {
      await controller.getProfile();
      if (userDetailModel?.data?.role == "CLIENT") {
        return ClientHomePage();
      } else if (userDetailModel?.data?.role == "WORKER") {
        return WorkerHomePage();
      } else {
        return DashboardPage();
      }
    } else {
      return LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              color: containerColor,
            )),
          );
        } else if (snapshot.hasError) {
          // Log error and fallback to login
          print('Error during checkAuth: ${snapshot.error}');
          return LoginPage();
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          // Fallback safety
          return LoginPage();
        }
      },
    );
  }
}
