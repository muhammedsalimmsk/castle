import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:castle/Model/client_model/datum.dart';
import 'package:castle/Model/equipment_category_model/equipment_category_model.dart';
import 'package:castle/Model/equipment_model/datum.dart';
import 'package:castle/Model/equipment_model/equipment_model.dart';
import 'package:castle/Model/equipment_type_list_model/datum.dart';
import 'package:castle/Model/equipment_type_list_model/equipment_type_list_model.dart';
import 'package:castle/Model/sub_category_model/datum.dart';
import 'package:castle/Model/sub_category_model/sub_category_model.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../Model/client_model/client_model.dart';
import '../../Model/equipment_category_model/datum.dart';

class EquipmentController extends GetxController {
  var selectedValue = "Name".obs;
  final ApiService _apiService = ApiService();
  ClientRegisterController controller = Get.put(ClientRegisterController());
  EquipmentCategoryModel model = EquipmentCategoryModel();
  EquipmentModel equipmentModel = EquipmentModel();
  SubCategoryModel subCategoryModel = SubCategoryModel();
  RxList<SubCategoryData> subCatData = <SubCategoryData>[].obs;
  RxList<EquipmentDetailData> equipmentDetail = <EquipmentDetailData>[].obs;
  EquipmentTypeListModel dataList = EquipmentTypeListModel();
  RxList<EquipmentType> equipType = <EquipmentType>[].obs;
  var selectedEquipmentTypeName = ''.obs;
  TextEditingController locationRemarksController = TextEditingController();
  var equipmentTypeId = ''.obs;
  var locationType = ''.obs;
  RxList<EquipCat> catList = <EquipCat>[].obs;
  final clientData = <ClientData>[].obs;
  final searchQuery = ''.obs;
  final isFetchingClients = false.obs;
  int page = 1;
  String? lastSearch;
  String? lastCategoryId;
  RxString selectedSubCategoryName = ''.obs;
  var isSubCategoryLoading = false.obs;
  bool hasMoreClients = true;
  final selectedClientName = ''.obs;
  ClientModel clientModel = ClientModel();
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreData = true.obs;
  final nameController = TextEditingController();
  final modelController = TextEditingController();
  final serialNumberController = TextEditingController();
  final manufacturerController = TextEditingController();
  final locationController = TextEditingController();
  final clientIdController = TextEditingController();
  final categoryId = ''.obs;
  RxString? subCategoryId = "".obs;
  final specificationsController = TextEditingController();
  int currentPage = 1;
  final int limit = 10;
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

  Future<void> updateEquipment(String equipId) async {
    final data = {
      "name": nameController.text,
      "model": modelController.text,
      "serialNumber": serialNumberController.text,
      // "manufacturer": manufacturerController.text,
      "installationDate": installationDate.value?.toIso8601String(),
      "warrantyExpiry": warrantyExpiry.value?.toIso8601String(),
      "equipmentTypeId": equipmentTypeId.value,
      "locationType": locationType.value,
      "locationRemarks": locationRemarksController.text,
      "categoryId": categoryId.value,
      "subCategoryId": subCategoryId?.value,
    };

    final endpoint = "/api/v1/admin/equipment/$equipId";
    try {
      // Show loader
      Get.dialog(
        Center(child: CircularProgressIndicator(color: buttonColor)),
        barrierDismissible: false,
      );

      final response = await _apiService.patchRequest(
        endpoint,
        data: data,
        bearerToken: token,
      );

      if (response.isOk) {
        await getEquipment(); // refresh list
        Get.back(); // Close the loading dialog
        Get.back(); // Go back to previous screen
        Get.snackbar("Updated", "Updated Successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.back(); // Close the dialog
        Get.snackbar("Error", "Update failed",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back(); // Ensure dialog is closed on error
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
      rethrow;
    }
  }

  Future<void> getEquipmentTypes() async {
    try {
      final response = await _apiService
          .getRequest('/api/v1/admin/equipment-types', bearerToken: token);
      if (response.isOk) {
        final model = EquipmentTypeListModel.fromJson(response.body);
        equipType.value = model.data ?? [];
      }
    } catch (e) {
      print('Error loading equipment types: $e');
    }
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

  Future<void> getSubCategories({
    String? search,
    String? categoryId,
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      subCatData.clear();
      currentPage = 1;
      hasMoreData.value = true;
      isSubCategoryLoading.value = true; // 👈 Start loading for dialog/search
    }

    if (!hasMoreData.value) return;

    final baseUrl = '/api/v1/admin/equipment-subcategories';

    final queryParams = <String, String>{
      'page': currentPage.toString(),
      'limit': limit.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
      if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
    };

    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    try {
      if (isLoadMore) {
        isLoadingMore.value = true; // 👈 only for list bottom loader
      }

      final response =
          await _apiService.getRequest(uri.toString(), bearerToken: token);

      if (response.isOk) {
        final model = SubCategoryModel.fromJson(response.body);
        final newItems = model.data ?? [];

        if (newItems.length < limit) {
          hasMoreData.value = false;
        }

        subCatData.addAll(newItems);
        currentPage++;
        lastSearch = search;
        lastCategoryId = categoryId;
      } else {
        hasMoreData.value = false;
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
    } finally {
      if (!isLoadMore) isSubCategoryLoading.value = false;
      isLoadingMore.value = false;
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
      "modelNumber": modelController.text,
      "serialNumber": serialNumberController.text,
      "manufacturer": manufacturerController.text,
      "installationDate":
          installationDate.value?.toIso8601String().split('T').first,
      "warrantyExpiry":
          warrantyExpiry.value?.toIso8601String().split('T').first,
      "locationRemarks": locationRemarksController.text,
      'locationType': locationType.value.toUpperCase(),
      "categoryId": categoryId.value,
      "equipmentTypeId": equipmentTypeId.value,
      "subCategoryId": subCategoryId!.value,
      "clientId": clientId ?? clientIdController.text,
    };
    try {
      print(data);
      print(clientId);
      final response =
          await _apiService.postRequest(endpoint, data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        print('successfully');
        resetForm();
        await getEquipment();
        await getEquipmentDetail("admin");
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

  Future<List<EquipmentDetailData>?> getEquipmentDetail(String role) async {
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
      await getEquipmentTypes();
    }
  }
}
