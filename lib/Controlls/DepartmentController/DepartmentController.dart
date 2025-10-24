import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Model/department_model/datum.dart';
import 'package:castle/Model/department_model/department_model.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DepartmentController extends GetxController {
  final ApiService _apiService = ApiService();
  DepartmentModel departmentModel = DepartmentModel();
  RxList<DepartmentData> departDetails = <DepartmentData>[].obs;
  var isDeleting = false.obs;
  var isCreating = false.obs;
  var isLoading = false.obs;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  Future createDepartment(String name, String descr) async {
    final data = {"name": name, "description": descr};
    final endpoint = '/api/v1/admin/departments';
    isCreating.value = true;
    try {
      final response =
          await _apiService.postRequest(endpoint, data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        Get.snackbar("Success", "Created");
      } else {
        print(response.body);
        Get.snackbar("Error", response.body['error'],
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isCreating.value = false;
      update();
    }
  }

  Future deleteDepartment(String departId) async {
    final endpoint = "/api/v1/admin/departments/$departId";
    isDeleting.value = true;
    try {
      final response =
          await _apiService.deleteRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        Get.back();
      } else {
        Get.snackbar("Error", response.body['error']);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isDeleting.value = false;
    }
  }

  Future getDepartment() async {
    final endpoint = '/api/v1/admin/departments';
    isLoading.value = true;
    update();
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        departmentModel = DepartmentModel.fromJson(response.body);
        departDetails.value = departmentModel.data!;
      } else {
        print(response.body);
        Get.snackbar("Error", "Something wrong please try later");
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future updateDepartment(String name, String descr, String departId) async {
    final data = {"name": name, "description": descr, "isActive": true};
    print(departId);
    final endpoint = '/api/v1/admin/departments/$departId';
    isCreating.value = true;
    try {
      final response = await _apiService.patchRequest(endpoint,
          data: data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        final updatedData = response.body['data'];

        // ✅ Update local list by ID
        int index = departDetails.indexWhere((d) => d.id == departId);
        if (index != -1) {
          departDetails[index] = DepartmentData(
            id: updatedData['id'],
            name: updatedData['name'],
            description: updatedData['description'],
            isActive: updatedData['isActive'],
            updatedAt: DateTime.tryParse(updatedData['updatedAt'] ?? ""),
          );

          departDetails.refresh();
          update(); // 🚨 Required for RxList to update UI
        }
        Get.snackbar("Success", "Updated successfully");
      } else {
        print(response.body);
        print(departId);
        Get.snackbar("Error", response.body['error'],
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isCreating.value = false;
      update();
    }
  }
}
