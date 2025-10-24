import 'package:get/get.dart';

import '../../Model/worker_dash_model/data.dart';
import '../../Model/worker_dash_model/worker_dash_model.dart';
import '../../Services/ApiService.dart';
import '../AuthController/AuthController.dart';

class WorkerDashboardController extends GetxController {
  var isLoading = true.obs;
  final ApiService _apiService = ApiService();
  Rx<WorkerDashData> dashboardData = WorkerDashData().obs;

  void fetchDashboardData() async {
    final endpoint = "/api/v1/worker/dashboard";
    try {
      isLoading.value = true;
      final response = await _apiService.getRequest(endpoint,
          bearerToken: token); // Your API call
      if (response.isOk) {
        print(response.body);
        final data = WorkerDashModel.fromJson(response.body);
        dashboardData.value = data.data!;
        print("jjjjjjj${dashboardData.value}");
      } else {
        print(response.body);
      }
    } catch (e) {
      print("Worker  Dashboard error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchDashboardData();
  }
}
