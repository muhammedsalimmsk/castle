// ClientPartsController.dart

import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Model/client_requested_parts_model/client_requested_parts_model.dart';
import '../../Model/client_requested_parts_model/datum.dart';
import 'package:get/get.dart';

class ClientPartsController extends GetxController {
  List<ClientPartsList> partsList = [];
  final ApiService _apiService = ApiService();
  RxBool isLoading = false.obs;
  bool isMoreDataAvailable = true;
  RxString selectedStatus = 'PENDING'.obs;
  int currentPage = 1;
  final int limit = 10;

  Future updateParts(
      String partId, String status, String note, String role) async {
    final endpoint = "/api/v1/client/part-requests/$partId";
    final data = {"status": status, "clientNotes": note};
    Get.dialog(Center(
      child: CircularProgressIndicator(
        color: buttonColor,
      ),
    ));
    try {
      final response = await _apiService.patchRequest(endpoint,
          data: data, bearerToken: token);
      if (response.isOk) {
        getRequestedParts(role, reset: true);
      } else {
        print(response.body);
      }
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  Future<List<ClientPartsList>> getRequestedParts(String role,
      {bool reset = false}) async {
    if (isLoading.value) return partsList;

    if (reset) {
      currentPage = 1;
      partsList.clear();
      isMoreDataAvailable = true;
    }

    isLoading.value = true;
    update();
    final endpoint =
        "/api/v1/admin/part-requests?page=$currentPage&limit=$limit&status=$selectedStatus";

    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        final model = ClientRequestedPartsModel.fromJson(response.body);

        if (model.data != null && model.data!.isNotEmpty) {
          partsList.addAll(model.data!);
          currentPage++;
          if (model.data!.length < limit) isMoreDataAvailable = false;
        } else {
          isMoreDataAvailable = false;
        }
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      print("Error fetching parts: $e");
    }

    isLoading.value = false;
    update();
    return partsList;
  }

  void changeStatus(String newStatus) {
    selectedStatus.value = newStatus;
    getRequestedParts(userDetailModel!.data!.role!.toLowerCase(), reset: true);
  }
}
