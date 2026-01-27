import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Controlls/ComplaintController/ComplaintController.dart';
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
  EquipmentController get controller {
    try {
      return Get.find<EquipmentController>();
    } catch (e) {
      return Get.put(EquipmentController());
    }
  }
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
    final endpoint = '/api/v1/common/complaints';
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
        
        // Refresh complaint list
        try {
          final complaintController = Get.find<ComplaintController>();
          complaintController.hasMore = true;
          complaintController.isRefresh = true;
          complaintController.page = 1;
          await complaintController.getComplaint(role: role);
          complaintController.isRefresh = false;
          complaintController.update();
        } catch (e) {
          print('Error refreshing complaint list: $e');
        }
        
        Get.snackbar("Success", "Successfully registered complaint",
            snackPosition: SnackPosition.BOTTOM);
        
        // Wait a bit for snackbar to show, then navigate back
        await Future.delayed(Duration(milliseconds: 500));
        Get.back();
      } else {
        print(response.body);
        Get.snackbar("Error", "Failed to register complaint",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future deleteEquip(String id) async {
    final endpoint = "/api/v1/common/equipment/$id";
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
