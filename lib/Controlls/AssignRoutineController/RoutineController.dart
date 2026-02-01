import 'dart:async';

import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/WorkerRoutineController/WorkerRoutineController.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:castle/Model/routine_model/datum.dart';
import 'package:castle/Model/routine_model/routine_model.dart';
import 'package:castle/Model/routine_task_model/datum.dart';
import 'package:castle/Model/routine_task_model/routine_task_model.dart';
import 'package:castle/Model/routine_task_model/tasked_routine_detail_model/data.dart';
import 'package:castle/Model/routine_task_model/tasked_routine_detail_model/tasked_routine_detail_model.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Model/equipment_model/datum.dart';
import '../../Model/equipment_model/equipment_model.dart';
import '../../Model/workers_model/datum.dart';
import '../../Model/workers_model/workers_model.dart';
import '../../Model/client_model/datum.dart';
import '../../Colors/Colors.dart';

class AssignRoutineController extends GetxController {
  final nameController = TextEditingController();
  final ApiService _apiService = ApiService();
  WorkerTaskController controller = Get.put(WorkerTaskController());
  RxString selectedWorkerName = ''.obs;
  String selectedWorkerId = "";
  RxString selectedEquipmentName = ''.obs;
  RxString selectedClientName = ''.obs;
  String selectedClientId = "";
  final descriptionController = TextEditingController();
  late ClientRegisterController clientController = Get.put(ClientRegisterController());
  RxList<ClientData> clientList = <ClientData>[].obs;
  late RoutineModel routineModel = RoutineModel();
  RxList<RoutineDetail> routineList = <RoutineDetail>[].obs;
  late RoutineTaskModel taskModel = RoutineTaskModel();
  RxList<TaskDetail> taskDetails = <TaskDetail>[].obs;
  final RxString selectedStatus = ''.obs;
  EquipmentModel equipmentModel = EquipmentModel();
  RxList<EquipmentDetailData> equipmentDetail = <EquipmentDetailData>[].obs;
  final TextEditingController notesController = TextEditingController();
  List<Map<String, dynamic>>? taskReadings;

  int taskPage = 1;
  int taskLimit = 1;
  bool taskHasMore = true;
  RxBool taskIsLoading = false.obs;
  bool taskIsRefresh = false;
  int currentPage = 1;
  int limit = 10;
  bool hasMore = true;
  bool isRefresh = false;
  RxBool isLoading2 = false.obs;
  RxBool isLoading = false.obs;
  String searchQuery = "";
  String filteredFree = "";
  Timer? _searchDebounce;
  final selectedFrequency = 'DAILY'.obs;
  final listFrequencyFilter = ''.obs;
  final selectedTime = ''.obs;
  final selectedDayOfWeek = 0.obs;
  final selectedDayOfMonth = 1.obs;
  final selectedEquipmentId = ''.obs;
  RxList<String> readings = <String>[].obs;
  final readingController = TextEditingController();
  String? role;
  final isSubmitting = false.obs;
  late TaskedRoutineDetailModel taskedRoutineDetailModel =
      TaskedRoutineDetailModel();
  Rx<WorkerTaskDetail> workerTaskDetail = WorkerTaskDetail().obs;
  late WorkersModel workersModel = WorkersModel();
  RxList<WorkerData> workerList = <WorkerData>[].obs;
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

  void pickTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timeOfDay != null) {
      // Convert to 24-hour formatted string (HH:mm)
      final now = DateTime.now();
      final DateTime fullTime = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      final formattedTime =
          "${fullTime.hour.toString().padLeft(2, '0')}:${fullTime.minute.toString().padLeft(2, '0')}";

      selectedTime.value = formattedTime; // store in 24-hour format
    }
  }

  Future<void> submitRoutine(String assignedWorkerId) async {
    if (nameController.text.trim().isEmpty ||
        selectedTime.value.isEmpty ||
        selectedEquipmentId.value.isEmpty) {
      Get.snackbar("Validation Error", "All fields are required");
      return;
    }
    final Map<String, dynamic> routineData = {
      "name": nameController.text.trim(),
      "description": descriptionController.text.trim(),
      "frequency": selectedFrequency.value,
      "timeSlot": selectedTime.value,
      "equipmentId": selectedEquipmentId.value,
      "assignedWorkerId": assignedWorkerId,
    };

// Conditionally add fields
    if (selectedFrequency.value == "WEEKLY") {
      routineData["dayOfWeek"] = selectedDayOfWeek.value;
    }

    if (selectedFrequency.value == "MONTHLY") {
      routineData["dayOfMonth"] = selectedDayOfMonth.value;
    }

    // Add readings array
    routineData["readings"] = readings.toList();

    final endpoint = "/api/v1/admin/routines";
    print(routineData);
    isSubmitting.value = true;
    try {
      // Replace with your API call logic
      final response = await _apiService.postRequest(endpoint, routineData,
          bearerToken: token);
      if (response.isOk) {
        print(response.body);
        isRefresh = true;
        await getRoutine();
        print(role);
        isRefresh = false;
        Get.back(); // Close the form page
        Get.snackbar("Success", "Routine assigned successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        print(response.body);
        Get.snackbar("Error", "Failed to assign routine");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Failed to assign routine");
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> setFrequencyFilter(String frequency) async {
    listFrequencyFilter.value = frequency;
    filteredFree = frequency;
    isRefresh = true;
    await getRoutine();
    isRefresh = false;
  }

  void onSearchChanged(String query) {
    searchQuery = query.trim();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () async {
      isRefresh = true;
      await getRoutine();
      isRefresh = false;
    });
  }

  Future getRoutine() async {
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
    }
    if (isLoading2.value || !hasMore) return;
    var endpoint = "/api/v1/common/routines?page=$currentPage&limit=$limit";
    if (searchQuery.isNotEmpty) {
      endpoint += "&search=${Uri.encodeComponent(searchQuery)}";
    }
    if (filteredFree.isNotEmpty) {
      endpoint += "&frequency=$filteredFree";
    }

    isLoading2.value = true;
    try {
      print(endpoint);
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        routineModel = RoutineModel.fromJson(response.body);
        if (isRefresh || currentPage == 1) {
          // First page or refresh
          routineList.value = routineModel.data!;
        } else {
          // Append for next pages
          routineList.addAll(routineModel.data!);
        }
        if (routineModel.data!.length < limit) {
          hasMore = false;
        } else {
          currentPage++;
        }
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      return;
    } finally {
      isLoading2.value = false;
    }
  }

  Future deleteRoutine(String routineId) async {
    isLoading.value = true;
    final endpoint = "/api/v1/admin/routines/$routineId";
    try {
      final response =
          await _apiService.deleteRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        isRefresh = true;
        await getRoutine();
        isRefresh = false;
        Get.back();
        Get.snackbar("Deleted", "Routine deleted successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        print(response.statusCode);
        print(response.body);
        Get.snackbar("Error", "Failed to delete routine",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future updateRoutineStatus(String routineId, String status,
      {String? notes, List<Map<String, dynamic>>? readings}) async {
    final endpoint = "/api/v1/worker/routine-tasks/$routineId/status";
    final data = {
      "status": status,
      "notes": notes ?? "string",
      if (readings != null) "readings": readings,
    };
    try {
      final response = await _apiService.patchRequest(endpoint,
          data: data, bearerToken: token);
      if (response.isOk) {}
    } catch (e) {
      rethrow;
    }
  }

  void _showSuccessDialog(String message) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: cardShadowColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Success",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: subtitleColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      buttonColor,
                      buttonColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "OK",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: cardShadowColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: notWorkingTextColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: notWorkingTextColor,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Error",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: subtitleColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      notWorkingTextColor,
                      notWorkingTextColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: notWorkingTextColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        "OK",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future updateRoutine(String routineId, dynamic data) async {
    final endpoint = "/api/v1/admin/routines/$routineId";
    isSubmitting.value = true;
    try {
      final response = await _apiService.patchRequest(endpoint,
          data: data, bearerToken: token);
      if (response.isOk) {
        print("sssssssssssss${response.body}");
        isRefresh = true;
        await getRoutine();
        isRefresh = false;
        
        // Navigate back FIRST
        Get.back(closeOverlays: false);
        
        // Show success dialog on the previous page after navigation completes
        Future.delayed(const Duration(milliseconds: 500), () {
          _showSuccessDialog("Routine updated successfully");
        });
        
        // Clear form data after navigation (don't clear while still on update page)
        Future.delayed(const Duration(milliseconds: 400), () {
          nameController.clear();
          descriptionController.clear();
          selectedFrequency.value = 'DAILY';
          selectedTime.value = '';
          selectedDayOfWeek.value = 0;
          selectedDayOfMonth.value = 1;
          selectedWorkerId = '';
          selectedWorkerName.value = '';
          readings.clear();
          readingController.clear();
        });
      } else {
        print("ERROR: Update routine failed");
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        print("Request Data: $data");

        String errorMessage = "Failed to update routine";
        if (response.body != null && response.body is Map && response.body.containsKey('error')) {
          errorMessage = response.body['error'] ?? errorMessage;
        } else if (response.body != null && response.body is Map && response.body.containsKey('message')) {
          errorMessage = response.body['message'] ?? errorMessage;
        }

        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      _showErrorDialog("An error occurred while updating the routine. Please try again.");
      rethrow;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future getRoutinetask(
    String? status,
    String routineId,
  ) async {
    if (taskIsRefresh) {
      taskPage = 1;
      taskHasMore = true;
    }
    if (taskIsLoading.value || !taskHasMore) return;
    String endpoint = "/api/v1/common/routine-tasks?page=1&limit=10";
    endpoint += "&routineId=$routineId";
    if (status != '') {
      endpoint += "&status=$status";
    }

    try {
      print(endpoint);
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        taskModel = RoutineTaskModel.fromJson(response.body);
        print(response.body);
        if (taskIsRefresh || taskPage == 1) {
          taskDetails.value = taskModel.data!;
        } else {
          taskDetails.addAll(taskModel.data!);
        }
        if (taskModel.data!.length < limit) {
          taskHasMore = false;
        } else {
          taskPage++;
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<WorkerTaskDetail?> fetchRoutineTask(String routineId) async {
    final endpoint = "/api/v1/common/routine-tasks/$routineId";
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        taskedRoutineDetailModel =
            TaskedRoutineDetailModel.fromJson(response.body);
        return workerTaskDetail.value = taskedRoutineDetailModel.data!;
      } else {
        print(response.body);
        Get.snackbar("Error", "Failed to fetch detail",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future updateRoutineTask(String routineId, String status, String note,
      {List<Map<String, dynamic>>? readings}) async {
    final endpoint = "/api/v1/worker/routine-tasks/$routineId/status";
    final data = {
      'status': status,
      'notes': note,
      if (readings != null) 'readings': readings,
    };
    isLoading.value = true;
    try {
      final response = await _apiService.patchRequest(endpoint,
          data: data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        await controller.refreshTasks();
        Get.back();
        Get.snackbar("Updated", "Status updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        print(response.body);
        Get.snackbar("Error", "Failed to update status",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future getEquipment({String? clientId}) async {
    final baseUrl = '/api/v1/common/equipment';
    final queryParams = <String, String>{};
    if (clientId != null && clientId.isNotEmpty) {
      queryParams['clientId'] = clientId;
    }
    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
    try {
      final response =
          await _apiService.getRequest(uri.toString(), bearerToken: token);
      if (response.isOk) {
        equipmentModel = EquipmentModel.fromJson(response.body);
        equipmentDetail.value = equipmentModel.data!;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future getClients() async {
    try {
      if (clientController.clientData.isEmpty) {
        await clientController.getClientList();
      }
      clientList.value = clientController.clientData;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    role = userDetailModel!.data!.role == "ADMIN" ? "admin" : "worker";
    super.onInit();
    await getRoutine();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }
}
