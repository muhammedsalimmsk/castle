import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Model/dashboard_model/dashboard_model.dart';
import 'package:castle/Model/dashboard_model/data.dart';
import 'package:get/get.dart';
import '../../Services/ApiService.dart'; // Replace with your API service file

class DashboardController extends GetxController {
  var isLoading = true.obs;
  final ApiService _apiService = ApiService();
  Rx<DashboardData> dashboardData = DashboardData().obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  void fetchDashboardData() async {
    final endpoint = "/api/v1/admin/dashboard";
    try {
      isLoading.value = true;
      final response = await _apiService.getRequest(endpoint,
          bearerToken: token); // Your API call
      if (response.isOk) {
        print(response.body);
        final data = DashboardModel.fromJson(response.body);
        dashboardData.value = data.data!;
      } else {
        print(response.body);
      }
    } catch (e) {
      print("Dashboard error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
