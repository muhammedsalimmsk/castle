import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Model/depart_workers_model/depart_workers_model.dart';
import 'package:castle/Model/depart_workers_model/worker.dart';
import 'package:castle/Model/workers_model/datum.dart';
import 'package:castle/Model/workers_model/workers_model.dart';
import 'package:castle/Model/login_details_model/login_details_model.dart';
import 'package:castle/Model/login_details_model/data.dart';
import 'package:castle/Screens/WorkersPage/WorkersPage.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class WorkerController extends GetxController {
  RxBool isLoading = false.obs;
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final password = TextEditingController();
  final customBadge = TextEditingController();
  final ApiService _apiService = ApiService();
  late WorkersModel workersModel = WorkersModel();
  late DepartWorkersModel departWorkersModel = DepartWorkersModel();
  RxList<WorkerList> workersDataByDep = <WorkerList>[].obs;
  bool isUpdateWorker = false;
  var primaryDepartment = ''.obs;
  var selectedDepartments = <String>[].obs;
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  RxList<WorkerData> workerList = <WorkerData>[].obs;
  RxBool isLoadingLoginDetails = false.obs;
  LoginDetailsData? loginDetailsData;

  Future<LoginDetailsData?> getLoginDetails(String userId) async {
    final endpoint = "/api/v1/admin/users/$userId/devices";
    isLoadingLoginDetails.value = true;
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        final loginDetailsModel = LoginDetailsModel.fromJson(response.body);
        loginDetailsData = loginDetailsModel.data;
        return loginDetailsData;
      } else {
        print(response.body);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoadingLoginDetails.value = false;
    }
  }

  String getWorkerName(String id) {
    try {
      return workerList.firstWhere((worker) => worker.id == id).firstName!;
    } catch (e) {
      return 'Unknown Worker';
    }
  }

  void addWorkerData(WorkerData worker) {
    isUpdateWorker = true;
    firstName.text = worker.firstName ?? "";
    lastName.text = worker.lastName ?? "";
    emailController.text = worker.email ?? "";
    phoneController.text = worker.phone ?? "";
    password.clear();
  }

  void clearField() {
    isUpdateWorker = false;
    firstName.clear();
    lastName.clear();
    emailController.clear();
    phoneController.clear();
    password.clear();
    customBadge.clear();
    primaryDepartment.value = '';
    selectedDepartments.clear();
  }

  Future createWorker() async {
    final endpoint = '/api/v1/admin/workers';
    final data = {
      "email": emailController.text.trim(),
      "password": password.text,
      "firstName": firstName.text.trim(),
      "lastName": lastName.text.trim(),
      "phone": phoneController.text,
      "departmentIds": selectedDepartments,
      "primaryDepartmentId": primaryDepartment.value.toString(),
      if (customBadge.text.trim().isNotEmpty)
        "customBadge": customBadge.text.trim()
    };
    print(data);
    isLoading.value = true;
    try {
      final response =
          await _apiService.postRequest(endpoint, data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        resetController();
        await getWorkers();
        Get.offNamed('/workers');
        // Show dialog after navigation completes
        Future.delayed(const Duration(milliseconds: 300), () {
          _showSuccessDialog("Success", "Successfully created worker");
        });
      } else {
        print(response.body);
        _showErrorDialog("Error", response.body['error'] ?? "Failed to create worker");
      }
    } catch (e) {
      _showErrorDialog("Error", "Something went wrong. Please try again later.");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future updateWorker(String workerId) async {
    final endpoint = "/api/v1/admin/workers/$workerId";
    isLoading.value = true;
    print(password.text);
    final data = {
      "email": emailController.text.trim(),
       if (password.text.trim().isNotEmpty)
    "password": password.text,
      "firstName": firstName.text.trim(),
      "lastName": lastName.text.trim(),
      "phone": phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
      "departmentIds": selectedDepartments,
      "primaryDepartmentId": primaryDepartment.value.toString(),
      if (customBadge.text.trim().isNotEmpty)
        "customBadge": customBadge.text.trim()
    };

    try {
      print(data);
      final response = await _apiService.patchRequest(endpoint,
          data: data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        final updatedWorkerData = WorkerData.fromJson(response.body['data']);
        final index = workerList.indexWhere((ab) => ab.id == workerId);

        if (index != -1) {
          // Replace the old data with the updated data
          workerList[index] = updatedWorkerData;
          workerList.refresh(); // If workerList is an RxList (GetX)
        }
        Get.back();
        Get.back();
        _showSuccessDialog("Success", "Successfully updated worker");
      } else {
        print(response.body);
        _showErrorDialog("Error", response.body['error'] ?? "Failed to update worker");
      }
    } catch (e) {
      _showErrorDialog("Error", "Something went wrong. Please try again later.");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessDialog(String title, String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      Get.back(closeOverlays: false);
                    } catch (e) {
                      if (Get.context != null) {
                        Navigator.of(Get.context!).pop();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("OK"),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showErrorDialog(String title, String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    try {
                      Get.back(closeOverlays: false);
                    } catch (e) {
                      if (Get.context != null) {
                        Navigator.of(Get.context!).pop();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("OK"),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future getWorkerByDepartment(String departmentId) async {
    final endpoint = '/api/v1/common/departments/$departmentId/workers';
    print(endpoint);
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);

      if (response.isOk) {
        print(response.body);
        departWorkersModel = DepartWorkersModel.fromJson(response.body);
        workersDataByDep.value = departWorkersModel.data!.workersList!;
      } else {
        print(response.body);
        Get.snackbar("Error", "Something error please try again later");
      }
    } catch (e) {
      rethrow;
    }
  }

  //
  Future getWorkers() async {
    try {
      final response = await _apiService.getRequest('/api/v1/admin/workers',
          bearerToken: token);
      if (response.isOk) {
        print(response.body);
        workersModel = WorkersModel.fromJson(
          response.body,
        );
        workerList.value = workersModel.data!;
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future deleteWorker(String workerId) async {
    isLoading.value = true;
    try {
      final response = await _apiService
          .deleteRequest('/api/v1/admin/workers/$workerId', bearerToken: token);
      if (response.isOk) {
        print(response.body);
        resetController();
        workerList.removeWhere((worker) => worker.id == workerId);
        workerList.refresh();
        Get.back();
        Get.snackbar("Deleted", "Successfully deleted");
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

  void resetController() {
    emailController.clear();
    phoneController.clear();
    firstName.clear();
    lastName.clear();
    password.clear();
    customBadge.clear();
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getWorkers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    workerList.clear();
  }
}
