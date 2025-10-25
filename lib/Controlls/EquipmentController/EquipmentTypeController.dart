import 'package:castle/Services/ApiService.dart';
import 'package:get/get.dart';
import 'package:castle/Model/equipment_type_list_model/datum.dart';

import '../../Model/equipment_type_list_model/equipment_type_list_model.dart';
import '../AuthController/AuthController.dart';

class EquipmentTypeController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<EquipmentType> equipType = <EquipmentType>[].obs;
  final ApiService _apiService = ApiService();
  RxBool isLoading1 = false.obs;
  Future getEquipmentTypes() async {
    try {
      final response = await _apiService
          .getRequest('/api/v1/admin/equipment-types', bearerToken: token);
      if (response.isOk) {
        print(response.body);
        final model = EquipmentTypeListModel.fromJson(response.body);
        equipType.value = model.data ?? [];
        update();
      } else {
        print(response.body);
        Get.snackbar("Error", "Something error please try again later");
      }
    } catch (e) {
      print('Error loading equipment types: $e');
    }
  }

  Future createType(String name, String description) async {
    final endpoint = "/api/v1/admin/equipment-types";
    final data = {'name': name, 'description': description};
    isLoading1.value = true;
    try {
      final response =
          await _apiService.postRequest(endpoint, data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        final dataJson = response.body['data'];
        final newType = EquipmentType.fromJson(dataJson); // parse into model
        equipType.add(newType);
        print("new cat id is=${newType.id}");
        update();
        Get.back();
      } else {
        print(response.body);
        Get.snackbar("Error", response.body['error']);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading1.value = false;
      update();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getEquipmentTypes();
  }
}
