import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Model/parts_list_model/datum.dart';
import 'package:castle/Model/parts_list_model/parts_list_model.dart';
import 'package:castle/Model/requested_parts_model/datum.dart';
import 'package:castle/Model/requested_parts_model/requested_parts_model.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:get/get.dart';

class PartsController extends GetxController {
  final ApiService _apiService = ApiService();
  late PartsListModel partsListModel = PartsListModel();
  RxList<PartsDetail> partsData = <PartsDetail>[].obs;
  late RequestedPartsModel dataModel = RequestedPartsModel();
  RxList<RequestedParts> requestedParts = <RequestedParts>[].obs;
  int currentPage = 1;
  int limit = 10;
  bool isRefresh = false;
  bool hasMore = true;
  bool hasMore2 = true;
  RxBool isLoading = false.obs;
  Future createParts(Map<String, dynamic> data) async {
    isLoading.value = true;
    final endpoint = "/api/v1/admin/inventory-parts";
    try {
      final response =
          await _apiService.postRequest(endpoint, data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future getPartsList() async {
    final endpoint = "/api/v1/admin/inventory-parts";
    if (isRefresh) {
      currentPage = 1;
      hasMore = true;
    }
    if (isLoading.value || !hasMore) return;
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        partsListModel = PartsListModel.fromJson(response.body);

        if (isRefresh || currentPage == 1) {
          partsData.value = partsListModel.data!;
        } else {
          partsData.addAll(partsListModel.data!);
        }
        if (partsListModel.data!.length < limit) {
          hasMore = false;
        } else {
          currentPage++;
        }
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future getRequestedList() async {
    print("requested list api working");
    final endpoint =
        "/api/v1/admin/part-requests?page=$currentPage&limit=$limit";
    if (isRefresh) {
      currentPage = 1;
      hasMore2 = true;
    }
    if (isLoading.value || !hasMore2) return;
    try {
      final response =
          await _apiService.getRequest(endpoint, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        dataModel = RequestedPartsModel.fromJson(response.body);
        if (isRefresh || currentPage == 1) {
          requestedParts.value = dataModel.data!;
        } else {
          requestedParts.addAll(dataModel.data!);
        }
        if (dataModel.data!.length < limit) {
          hasMore2 = false;
        } else {
          currentPage++;
        }
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getPartsList();
    await getRequestedList();
  }
}
