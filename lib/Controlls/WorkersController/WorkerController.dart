import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Model/depart_workers_model/data.dart';
import 'package:castle/Model/depart_workers_model/depart_workers_model.dart';
import 'package:castle/Model/depart_workers_model/worker.dart';
import 'package:castle/Model/workers_model/datum.dart';
import 'package:castle/Model/workers_model/workers_model.dart';
import 'package:castle/Screens/WorkersPage/WorkersPage.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WorkerController extends GetxController {
  RxBool isLoading = false.obs;
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final password = TextEditingController();
  final ApiService _apiService = ApiService();
  late WorkersModel workersModel = WorkersModel();
  late DepartWorkersModel departWorkersModel = DepartWorkersModel();
  RxList<WorkerList> workersDataByDep = <WorkerList>[].obs;
  var primaryDepartment = ''.obs;
  var selectedDepartments = <String>[].obs;
  // Example for reference:
  // var departments = [
  //   {'id': '1', 'name': 'Cleaning'},
  //   {'id': '2', 'name': 'Maintenance'},
  // ];
  RxList<WorkerData> workerList = <WorkerData>[].obs;
  String getWorkerName(String id) {
    try {
      return workerList.firstWhere((worker) => worker.id == id).firstName!;
    } catch (e) {
      return 'Unknown Worker';
    }
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
      "primaryDepartmentId": primaryDepartment.value.toString()
    };
    print(data);
    isLoading.value = true;
    try {
      final response =
          await _apiService.postRequest(endpoint, data, bearerToken: token);
      if (response.isOk) {
        print(response.body);
        resetController();
        Get.snackbar("Success", "Successfully created worker");
        await getWorkers();
        Get.off(WorkersPage());
      } else {
        print(response.body);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future getWorkerByDepartment(String departmentId) async {
    final endpoint = '/api/v1/admin/departments/$departmentId/workers';
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

  Future deleteWorker(String userId) async {
    isLoading.value = true;
    try {
      final response = await _apiService
          .deleteRequest('/api/v1/admin/workers/$userId', bearerToken: token);
      if (response.isOk) {
        resetController();
        await getWorkers();
        update();
        Get.back();
        Get.snackbar("Deleted", "Successfully deleted");
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
