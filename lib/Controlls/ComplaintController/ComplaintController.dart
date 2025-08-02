import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Model/complaint_detail_model/complaint_detail_model.dart';
import 'package:castle/Model/complaint_model/complaint_model.dart';
import 'package:castle/Model/complaint_model/datum.dart';
import 'package:castle/Model/parts_list_model/datum.dart';
import 'package:castle/Model/parts_list_model/parts_list_model.dart';
import 'package:castle/Model/requested_parts_data_model/datum.dart';
import 'package:castle/Model/requested_parts_data_model/requested_parts_data_model.dart';
import 'package:castle/Model/workers_model/time_line_complaint_model/status_update.dart';
import 'package:castle/Model/workers_model/time_line_complaint_model/time_line_complaint_model.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ComplaintController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  ComplaintModel dataModel = ComplaintModel();
  RxList<Map<String, dynamic>> requestedParts = <Map<String, dynamic>>[].obs;
  RequestedPartsDataModel partsDataModel = RequestedPartsDataModel();
  RxList<RequestedPartsData> partsModel = <RequestedPartsData>[].obs;
  late ComplaintDetailModel complaintDetailModel = ComplaintDetailModel();

  final RxString selectedTeamLead = ''.obs;
  RxList<String> tempSelectedWorkers = <String>[].obs;
  void addRequestedPart(Map<String, dynamic> part) {
    requestedParts.add(part);
  }

  void removeRequestedPart(int index) {
    requestedParts.removeAt(index);
  }

  void clearRequestedParts() {
    requestedParts.clear();
  }

  Future fetchComplaintDetails(String complaintId, String role) async {
    isLoading.value = true;
    update();
    final endpoint = '/api/v1/$role/complaints/$complaintId';
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        complaintDetailModel = ComplaintDetailModel.fromJson(response.body);
      } else {
        print(response.body);
        Get.snackbar("Error", "Something error please try later",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
      update();
    }
  }

// Already existing in your controller
  Future<void> updatePartRequestStatus(
      String partRequestId, String newStatus) async {
    final endpoint = "/api/v1/worker/part-requests/$partRequestId/collect";

    try {
      final response = await _apiService.patchRequest(endpoint,
          data: null, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        Get.snackbar("Success", "Collected update successfully",
            backgroundColor: Colors.green);
      } else {
        print("sghjkjhgshshjjjjjj${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }

  final RxList<String> selectedWorkers = <String>[].obs;
  final Rx<DateTime> dueDate = DateTime.now().add(const Duration(days: 3)).obs;
  bool isWorkerSelected(String workerId) {
    return selectedWorkers.contains(workerId);
  }

  RxList<StatusUpdate> statusDetails = <StatusUpdate>[].obs;
  RxList<PartsDetail> partsList = <PartsDetail>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoading2 = false.obs;
  RxBool isLoading3 = false.obs;
  RxList<ComplaintDetails> details = <ComplaintDetails>[].obs;
  int page = 1;
  int limit = 10;
  bool hasMore = true;
  bool isRefresh = false;
  String search = '';
  final List<String> statuses = [
    'OPEN',
    'ASSIGNED',
    'IN_PROGRESS',
    'PARTS_REQUESTED',
    'PARTS_APPROVED',
    'PARTS_REJECTED',
    'RESOLVED',
    'CLOSED',
  ];

  final List<String> priorities = [
    'LOW',
    'MEDIUM',
    'HIGH',
    'URGENT',
  ];
  void selectDueDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: dueDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(dueDate.value),
      );

      if (selectedTime != null) {
        dueDate.value = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }
  }

  String get formattedDueDate =>
      DateFormat('yyyy-MM-dd HH:mm').format(dueDate.value);
  var selectedStatus = ''.obs;
  var selectedPriority = ''.obs;

  void setStatus(String value) {
    selectedStatus.value = value;
  }

  void setPriority(String value) {
    selectedPriority.value = value;
  }

  void scrollToRight() {
    scrollController.animateTo(
      scrollController.offset + 410,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future getRequestedPartsList() async {
    final endpoint = "/api/v1/worker/part-requests";
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        partsDataModel = RequestedPartsDataModel.fromJson(response.body);
        partsModel.value = partsDataModel.data!;
      } else {
        print(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    // TODO: implement onInit
    final role = userDetailModel!.data!.role!.toLowerCase();

    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        await getComplaint(role: role);
      }
    });

    print(role);
    await getComplaint(role: userDetailModel!.data!.role!.toLowerCase());
  }

  void scrollToLeft() {
    scrollController.animateTo(
      scrollController.offset - 410,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> requestMultipleParts(String complaintId, String type) async {
    if (requestedParts.isEmpty) return;
    isLoading3.value = true;
    for (var part in requestedParts) {
      await requestPart({
        "complaintId": complaintId,
        "partId": part["partId"],
        "quantity": part["quantity"],
        "type": type,
        "reason": part["reason"],
        "urgency": part["urgency"],
      });
    }
    isLoading3.value = false;
    clearRequestedParts();
  }

  Future getComplaint({required String role}) async {
    print(role);
    print(isLoading.value);
    print(!hasMore);
    if (isRefresh) {
      page = 1;
      hasMore = true;
    }
    if (isLoading.value || !hasMore) return;

    isLoading.value = true;

    final endpoint =
        "/api/v1/$role/complaints?page=$page&limit=$limit&search=$search";

    try {
      print(endpoint);
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print("ssssssssssssssss${response.body}");
        dataModel = ComplaintModel.fromJson(response.body);

        if (isRefresh || page == 1) {
          // First page or refresh
          details.value = dataModel.data!;
        } else {
          // Append for next pages
          details.addAll(dataModel.data!);
        }
        if (dataModel.data!.length < limit) {
          hasMore = false;
        } else {
          page++;
        }
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

  Future assignComplaint(String complaintId,
      {required String teamLeadId,
      required List<String> workerIds,
      required DateTime dueDate}) async {
    isLoading.value = true;
    final endpoint = "/api/v1/admin/complaints/$complaintId/assign-team";
    final data = {
      'teamLeadId': teamLeadId,
      'workerIds': workerIds,
      'dueDate': dueDate.toIso8601String(),
    };
    try {
      final response = await _apiService.patchRequest(endpoint,
          data: data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        isRefresh = true;
        await getComplaint(role: "admin");
        Get.back();
        Get.snackbar("Success", "Successfully assigned work");
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

  Future<void> updateComplaintComment(
      String role, String complaintId, String comment) async {
    final endpoint = "/api/v1/$role/complaints/$complaintId/comments";
    try {
      isLoading2.value = true;
      final body = {
        "content": comment,
        "type": "GENERAL",
      };
      final response =
          await _apiService.postRequest(endpoint, body, bearerToken: token);
      if (response.isOk) {
        print(response.body);
      } else {
        print(response.body);
        Get.snackbar("Error", response.body['error']);
      }
    } finally {
      isLoading2.value = false;
    }
  }

  Future updateComplaint(String complaintId, String status, String note) async {
    final endpoint = "/api/v1/worker/complaints/$complaintId/status";
    isLoading2.value = true;
    final data = {'status': status, 'notes': note};
    try {
      final response = await _apiService.patchRequest(endpoint,
          data: data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        hasMore = true;
        await getComplaint(
          role: "worker",
        );
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    "Success",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Successfully updated status",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      Get.back();
                      // Dismiss the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child:
                        const Text("OK", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        print(data);
        print(response.body);
        Get.snackbar("Error", "Please try after sometimes",
            backgroundColor: Colors.redAccent);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading2.value = false;
    }
  }

  Future<List<StatusUpdate>?> getComplaintTimeLine(String complaintId) async {
    final endpoint = '/api/v1/client/complaints/$complaintId';
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        final data = TimeLineComplaintModel.fromJson(response.body);
        return statusDetails.value = data.data!.statusUpdates!;
      } else {
        print(response.body);
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future getPartsList() async {
    final endpoint = "/api/v1/worker/available-parts";
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        final data = PartsListModel.fromJson(response.body);
        partsList.value = data.data!;
      }
    } catch (e) {
      rethrow;
    } finally {}
  }

  Future requestPart(data) async {
    isLoading3.value = true;
    final endpoint = "/api/v1/worker/part-requests";

    try {
      print(data);
      final response =
          await _apiService.postRequest(endpoint, data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    "Success",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Successfully requested",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      Get.back();
                      // Dismiss the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child:
                        const Text("OK", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        print(response.body);
        Get.snackbar("Error", "Something error please try after some times");
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading3.value = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
