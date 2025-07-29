import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:castle/Model/client_model/datum.dart';
import 'package:castle/Model/equipment_category_model/datum.dart';
import 'package:castle/Model/equipment_category_model/equipment_category_model.dart';
import 'package:castle/Model/equipment_model/datum.dart';
import 'package:castle/Model/equipment_model/equipment_model.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../Model/client_model/client_model.dart';

class EquipmentController extends GetxController {
  var selectedValue = "Name".obs;
  final ApiService _apiService = ApiService();
  ClientRegisterController controller = Get.put(ClientRegisterController());
  EquipmentCategoryModel model = EquipmentCategoryModel();
  EquipmentModel equipmentModel = EquipmentModel();
  RxList<EquipmentDetails> equipmentDetail = <EquipmentDetails>[].obs;
  RxList<EquipCat> catList = <EquipCat>[].obs;
  final clientData = <ClientData>[].obs;
  final searchQuery = ''.obs;
  final isFetchingClients = false.obs;
  int page = 1;
  bool hasMoreClients = true;
  final selectedClientName = ''.obs;
  ClientModel clientModel = ClientModel();
  RxBool isLoading = false.obs;

  final nameController = TextEditingController();
  final modelController = TextEditingController();
  final serialNumberController = TextEditingController();
  final manufacturerController = TextEditingController();
  final locationController = TextEditingController();
  final clientIdController = TextEditingController();
  final categoryId = ''.obs;
  final specificationsController = TextEditingController();

  final installationDate = Rxn<DateTime>();
  final warrantyExpiry = Rxn<DateTime>();

  List<ClientData> get filteredClients {
    if (searchQuery.value.isEmpty) {
      return clientData;
    }
    return clientData
        .where((c) =>
            (c.firstName ?? '')
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            (c.lastName ?? '')
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  List<String> sortOptions = ["Name", "Price", "Rating"];
  var isOpen = false.obs;

  void toggle() {
    isOpen.value = !isOpen.value;
  }

  Future getCategory() async {
    final endpoint = '/api/v1/admin/equipment-categories';
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        model = EquipmentCategoryModel.fromJson(response.body);
        catList.addAll(model.data!);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future getClientList({bool isRefresh = false}) async {
    if (isFetchingClients.value || !hasMoreClients) return;

    isFetchingClients.value = true;
    if (isRefresh) {
      page = 1;
      hasMoreClients = true;
      clientData.clear();
    }

    try {
      final response = await _apiService.getRequest(
        '/api/v1/admin/clients?page=$page&limit=10&search=${searchQuery.value}',
        bearerToken: token,
      );
      if (response.isOk) {
        clientModel = ClientModel.fromJson(response.body);
        final newClients = clientModel.data!;
        if (newClients.isEmpty) {
          hasMoreClients = false;
        } else {
          clientData.addAll(newClients);
          page++;
        }
      } else {
        print(response.body);
      }
    } catch (e) {
      print("Client fetch error: $e");
    } finally {
      isFetchingClients.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    getClientList(isRefresh: true);
  }

  final specificationInput = TextEditingController();
  final specifications = <String>[].obs;

  void addSpecificationFromInput() {
    final value = specificationInput.text.trim();
    if (value.isNotEmpty && !specifications.contains(value)) {
      specifications.add(value);
      specificationInput.clear();
    }
  }

  void removeSpecification(String value) {
    specifications.remove(value);
  }

  Future createEquipment(String? clientId) async {
    isLoading.value = true;
    final endpoint = '/api/v1/admin/equipment';
    final data = {
      "name": nameController.text,
      "model": modelController.text,
      "serialNumber": serialNumberController.text,
      "manufacturer": manufacturerController.text,
      "installationDate":
          installationDate.value?.toIso8601String().split('T').first,
      "warrantyExpiry":
          warrantyExpiry.value?.toIso8601String().split('T').first,
      "location": locationController.text,
      "specifications": {for (var spec in specifications) spec: ""},
      "clientId": clientId ?? clientIdController.text,
      "categoryId": categoryId.value
    };
    try {
      print(clientId);
      final response =
          await _apiService.postRequest(endpoint, data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        print('successfully');
        resetForm();
        await getEquipment();
        controller.dispose();
        Get.back();
        Get.back();
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

  Future getEquipment() async {
    final endpoint = '/api/v1/admin/equipment';
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        equipmentModel = EquipmentModel.fromJson(response.body);
        equipmentDetail.value = equipmentModel.data!;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<EquipmentDetails>?> getEquipmentDetail(String role) async {
    final endpoint = '/api/v1/$role/equipment';
    try {
      print(endpoint);
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print("ujbbsbbb${response.body}");
        equipmentModel = EquipmentModel.fromJson(response.body);
        return equipmentDetail.value = equipmentModel.data!;
      } else {
        print("usjhgfdsa${response.body}");
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future getClientEquipment() async {
    final endpoint = '/api/v1/client/equipment';
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print("client equipment ${response.body}");
        equipmentModel = EquipmentModel.fromJson(response.body);
        return equipmentDetail.value = equipmentModel.data!;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void resetForm() {
    nameController.clear();
    modelController.clear();
    serialNumberController.clear();
    manufacturerController.clear();
    locationController.clear();
    clientIdController.clear();
    specificationsController.clear();

    categoryId.value = '';
    installationDate.value = null;
    warrantyExpiry.value = null;

    selectedClientName.value = '';
    specifications.clear();
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    if (userDetailModel!.data!.role == "CLIENT") {
      await getClientEquipment();
    }
    await getCategory();
    await getEquipment();
    if (userDetailModel!.data!.role == "ADMIN") {
      await getClientList();
    }
  }
}
