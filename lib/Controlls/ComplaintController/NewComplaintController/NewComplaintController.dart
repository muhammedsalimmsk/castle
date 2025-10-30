import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NewComplaintController extends GetxController {
  var currentPage = 0.obs; // Observable page index
  RxBool isLoading = false.obs;
  PageController pageController = PageController();
  final ApiService _apiService = ApiService();
  final TextEditingController email = TextEditingController();
  final contactPerson = TextEditingController();
  EquipmentController controller = Get.find();
  var isDeleting = false.obs;

  void nextPage() {
    if (currentPage.value == 0) {
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // Handle form submission here
      print("Form Submitted");
    }
  }

  Future complaintRegister(String role, String title, String description,
      String priority, String equipmentId) async {
    isLoading.value = true;
    final endpoint = '/api/v1/$role/complaints';
    final data = {
      "title": title,
      "description": description,
      "priority": priority.toUpperCase(),
      "equipmentId": equipmentId
    };
    try {
      final response =
          await _apiService.postRequest(endpoint, data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        await controller.getEquipmentDetail(role);
        Get.back();

        Get.snackbar("Success", "Successfully registered complaint",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future deleteEquip(String id) async {
    final endpoint = "/api/v1/admin/equipment/$id";
    isDeleting.value = true;
    try {
      final response =
          await _apiService.deleteRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        print(endpoint);
        await controller.getEquipment();
        Get.back();
        Get.back();
        Get.snackbar("Deleted", "Deleted successfully");
      } else {
        print(endpoint);
        print(response.body);
        Get.snackbar("Error", "Something error please try later");
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isDeleting.value = false;
    }
  }
}
