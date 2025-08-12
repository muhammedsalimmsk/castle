import 'package:castle/Model/client_dashboard/client_dashboard.dart';
import 'package:castle/Model/client_dashboard/data.dart';
import 'package:get/get.dart';

import '../../Services/ApiService.dart';
import '../AuthController/AuthController.dart';

class ClientDashboardController extends GetxController {
  var isLoading = true.obs;
  final ApiService _apiService = ApiService();
  Rx<ClientDashData> dashboardData = ClientDashData().obs;

  void fetchDashboardData() async {
    final endpoint = "/api/v1/client/dashboard";
    try {
      isLoading.value = true;
      final response = await _apiService.getRequest(endpoint,
          bearerToken: token); // Your API call
      if (response.isOk) {
        final data = ClientDashboard.fromJson(response.body);
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

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchDashboardData();
  }
}
