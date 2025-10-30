import 'package:castle/Controlls/AuthController/AuthController.dart';

import 'package:get/get.dart';

import '../../Model/dashboard_model/dashboard_model.dart';
import '../../Model/dashboard_model/data.dart';
import '../../Services/ApiService.dart'; // Replace with your API service file

class DashboardController extends GetxController {
  var isLoading = false.obs;
  final ApiService _apiService = ApiService();
  Rx<DashboardData> dashboardData = DashboardData().obs;

  final statsData = Rxn<StatsModel>();
  final recentComplaints = <Complaint>[].obs;
  final clientStats = <ClientStat>[].obs;
  final workerByDept = [].obs;
  final complaintByPriority = [].obs;

  Future<void> fetchAllDashboardData() async {
    isLoading.value = true;
    await Future.wait([
      fetchStats(),
      fetchRecentComplaints(),
      fetchClientStats(),
      fetchWorkersByDepartment(),
      fetchComplaintByPriority(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchStats() async {
    final res = await _apiService.getRequest('/api/v1/admin/dashboard/stats');
    if (res.isOk) statsData.value = StatsModel.fromJson(res.body);
  }

  Future<void> fetchRecentComplaints() async {
    final res = await _apiService
        .getRequest('/api/v1/admin/dashboard/recent-complaints');
    if (res.isOk)
      recentComplaints.assignAll((res.body['data'] as List)
          .map((e) => Complaint.fromJson(e))
          .toList());
  }

  Future<void> fetchClientStats() async {
    final res =
        await _apiService.getRequest('/api/v1/admin/dashboard/client-stats');
    if (res.isOk)
      clientStats.assignAll((res.body['data'] as List)
          .map((e) => ClientStat.fromJson(e))
          .toList());
  }

  Future<void> fetchWorkersByDepartment() async {
    final res = await _apiService
        .getRequest('/api/v1/admin/dashboard/workers-by-department');
    if (res.isOk) workerByDept.assignAll(res.body['data']);
  }

  Future<void> fetchComplaintByPriority() async {
    final res = await _apiService
        .getRequest('/api/v1/admin/dashboard/complaints-by-priority');
    if (res.isOk) complaintByPriority.assignAll(res.body['data']);
  }

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future fetchDashboardData() async {
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
        print("fghjklsskskkkk");
        print("Raw Response: ${response.bodyString}");

        print(response.statusCode);
      }
    } catch (e) {
      print(e);
      print("Dashboard error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
