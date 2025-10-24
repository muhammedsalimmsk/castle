import 'package:castle/Colors/Colors.dart';
import 'package:castle/Model/auth_model/UserModel.dart';
import 'package:castle/Model/auth_model/auth_model.dart';
import 'package:castle/Model/user_detail_model/user_detail_model.dart';
import 'package:castle/Screens/HomePage/HomePage.dart';
import 'package:castle/Screens/LoginPage/LoginPage.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? token;

UserDetailModel? userDetailModel;

class AuthController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  var isLoading = false.obs;

  late AuthModel model = AuthModel();
  Future loginWithUserName() async {
    final data = {
      "email": userNameController.text.toLowerCase().trim(),
      "password": passwordController.text
    };
    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Username and password cannot be empty!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    try {
      isLoading.value = true;
      final response =
          await _apiService.postRequest('/api/v1/auth/login', data);
      Get.back();
      if (response.isOk) {
        print(response.body);
        model = AuthModel.fromJson(response.body);

        final prefs = await SharedPreferences.getInstance();
        token = model.data!.token;
        await prefs.setString('token', model.data?.token ?? '');
        await prefs.setString('refreshToken', model.data?.refreshToken ?? '');
        await prefs.setString(
            'expiresAt', model.data?.expiresAt?.toIso8601String() ?? '');
        await getProfile();
        Get.offAll(HomePage());
      } else {
        print(response.statusCode);
        print(response.body);
        var responseBody = response.body;

        if (responseBody['error'] ==
            'Invalid credentials or inactive account') {
          Get.snackbar(
            "Error",
            "Invalid Credentials",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        } else if (responseBody['error'] == "Invalid credentials") {
          Get.snackbar(
            "Error",
            "Invalid Credentials",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkTokenStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final jwToken = prefs.getString('token');
    token = jwToken;
    final refreshToken = prefs.getString('refreshToken');
    final expiresAtStr = prefs.getString('expiresAt');

    if (token == null || refreshToken == null || expiresAtStr == null) {
      print('No token data saved');
      return;
    }

    DateTime expiresAt = DateTime.parse(expiresAtStr);
    DateTime now = DateTime.now();

    if (expiresAt.day == now.day &&
        expiresAt.month == now.month &&
        expiresAt.year == now.year) {
      print('Token is valid for today');
      // You can directly go to homepage or use the token
    } else {
      print('Token expired. Attempting to refresh.');
      await refreshTokenCall(refreshToken);
    }
  }

  Future<void> refreshTokenCall(String refreshToken) async {
    try {
      final response =
          await _apiService.postRequest('/api/v1/auth/refresh-token', {
        'refreshToken': refreshToken,
      });

      if (response.isOk) {
        AuthModel refreshedModel = AuthModel.fromJson(response.body);

        // Save new token info
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', refreshedModel.data?.token ?? '');
        await prefs.setString(
            'refreshToken', refreshedModel.data?.refreshToken ?? '');
        await prefs.setString('expiresAt',
            refreshedModel.data?.expiresAt?.toIso8601String() ?? '');
        print(response.body);
        print(refreshToken);
        print('Token refreshed successfully');
      } else {
        print('Failed to refresh token: ${response.body}');
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
  }

  Future getProfile() async {
    try {
      final response = await _apiService.getRequest('/api/v1/auth/profile',
          bearerToken: token);
      print("profile data fetched successfully");
      if (response.isOk) {
        print(response.body);
        userDetailModel = UserDetailModel.fromJson(response.body);
      } else {
        print(response.body);
        if (response.body['error'] == "Invalid or inactive user" ||
            response.body['error'] == "Invalid or expired token") {
          Get.offAll(LoginPage());
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
