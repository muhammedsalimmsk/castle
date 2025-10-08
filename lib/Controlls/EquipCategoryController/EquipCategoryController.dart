import 'package:castle/Services/ApiService.dart';
import 'package:get/get.dart';

import 'package:castle/Model/equipment_category_model/sub_category.dart';
import '../../Model/equipment_category_model/datum.dart';
import '../../Model/equipment_category_model/equipment_category_model.dart';
import '../AuthController/AuthController.dart';

class EquipmentCategoryController extends GetxController {
  final ApiService _apiService = ApiService();
  EquipmentCategoryModel model = EquipmentCategoryModel();
  RxList<EquipCat> catList = <EquipCat>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  var isDeleting = false.obs;
  Future getCategory() async {
    final endpoint = '/api/v1/admin/equipment-categories';
    isLoading.value = true;
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
    } finally {
      isLoading.value = false;
    }
  }

  Future createCategory(String name, String description) async {
    final endpoint = "/api/v1/admin/equipment-categories";
    final data = {'name': name, 'description': description};
    isLoading1.value = true;
    try {
      final response =
          await _apiService.postRequest(endpoint, data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        final dataJson = response.body['data'];
        final newCat = EquipCat.fromJson(dataJson); // parse into model
        catList.add(newCat);
        print("new cat id is=${newCat.id}");
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

  Future createSubCategory(
      String name, String description, String catId) async {
    final endpoint = "/api/v1/admin/equipment-subcategories";
    final data = {
      'name': name,
      'description': description,
      'categoryId': catId
    };
    isLoading1.value = true;
    try {
      final response =
          await _apiService.postRequest(endpoint, data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        final newSub = SubCategory(name: name, description: description);

        // update the correct category’s subcategory list
        final categoryIndex = catList.indexWhere((c) => c.id == catId);
        if (categoryIndex != -1) {
          catList[categoryIndex].subCategories ??= []; // init if null
          catList[categoryIndex].subCategories!.add(newSub);
          update();
        }
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

  Future deleteSubCat(String subCatId) async {}
  Future deleteCategory(String catId) async {
    final endpoint = "/api/v1/admin/equipment-categories/$catId";
    isDeleting.value = true;
    try {
      final response =
          await _apiService.deleteRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        catList.removeWhere((cat) => cat.id == catId);
        update();
        Get.back();
        Get.back(); // rebuild GetBuilder/Obx listeners
      } else {
        print(response.body);
        Get.snackbar("Error", response.body['error']);
      }
    } catch (e) {
      rethrow;
    } finally {
      isDeleting.value = false;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getCategory();
  }
}
