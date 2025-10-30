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
  var isUpdating = false.obs;
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
        final newSub = SubCategory.fromJson(response.body['data']);

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

  Future deleteSubCat(String subCatId, String catId) async {
    final endpoint = "/api/v1/admin/equipment-subcategories/$subCatId";
    isDeleting.value = true;
    try {
      final response =
          await _apiService.deleteRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        final category = catList.firstWhereOrNull((cat) => cat.id == catId);

        if (category != null) {
          // Remove the specific subcategory from that category
          category.subCategories!.removeWhere((sub) => sub.id == subCatId);

          // If using GetX reactive list
          catList.refresh();
          update();
          Get.back();

          print("Subcategory removed successfully ✅");
        } else {
          print("Category not found ❌");
        }
      } else {
        print(response.body);
        Get.snackbar("Error", "Something error please try later");
      }
    } catch (e) {
      rethrow;
    } finally {
      isDeleting.value = false;
    }
  }

  Future updateCategory(
      {required String catId,
      required String name,
      required String description}) async {
    final endpoint = "/api/v1/admin/equipment-categories/$catId";
    final data = {"name": name, "description": description};
    isUpdating.value = true;
    try {
      final response = await _apiService.patchRequest(endpoint,
          data: data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        final updatedCat = EquipCat.fromJson(response.body['data']);
        final index = catList.indexWhere((e) => e.id == catId);
        print(updatedCat.name);
        if (index != -1) {
          catList[index] = updatedCat;
          catList.refresh();
          Get.back();
          Get.back();
          Get.snackbar("Success", "Successfully updated");
        }
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isUpdating.value = false;
    }
  }

  Future updateSubCat(
      {required String subCatId,
      required String name,
      required String description,
      required String catId}) async {
    final endpoint = "/api/v1/admin/equipment-subcategories/$subCatId";
    isUpdating.value = true;
    final data = {
      "name": name,
      "description": description,
      "categoryId": catId
    };

    try {
      final response = await _apiService.patchRequest(endpoint,
          data: data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        final updatedSubCat = SubCategory.fromJson(response.body['data']);
        final category = catList.firstWhereOrNull((cat) => cat.id == catId);

        if (category != null) {
          // Remove the specific subcategory from that category
          final index =
              category.subCategories!.indexWhere((e) => e.id == subCatId);
          if (index != -1) {
            category.subCategories![index] = updatedSubCat;
            catList.refresh();

            Get.back();
            Get.snackbar("Success", "Successfully updated");
          }
        }
        // If using GetX reactive list
      } else {
        print(response.body);
        Get.snackbar("Error", "Something error please try later");
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isUpdating.value = false;
    }
  }

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
