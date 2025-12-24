import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Model/routine_task_model/datum.dart';
import 'package:castle/Model/routine_task_model/routine_task_model.dart';
import 'package:castle/Services/ApiService.dart';
import 'package:get/get.dart';

class WorkerTaskController extends GetxController {
  final ApiService _apiService = ApiService();
  late RoutineTaskModel taskModel = RoutineTaskModel();
  RxList<TaskDetail> taskDetail = <TaskDetail>[].obs;

  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxBool isMoreDataAvailable = true.obs;

  int currentPage = 1;
  final int limit = 10;
  String searchQuery = '';
  String status = 'PENDING';

  // Fetch tasks with pagination & optional refresh
  Future<void> fetchTasks({bool isRefresh = false}) async {
    if (isLoading.value) return;

    if (isRefresh) {
      currentPage = 1;
      isRefreshing.value = true;
      isMoreDataAvailable.value = true;
    }

    isLoading.value = true;

    final url =
        "/api/v1/worker/routine-tasks?page=$currentPage&limit=$limit&search=$searchQuery&status=$status";

    final response = await _apiService.getRequest(url, bearerToken: token);

    if (response.isOk) {
      taskModel = RoutineTaskModel.fromJson(response.body);

      if (isRefresh) {
        taskDetail.value = taskModel.data!;
      } else {
        taskDetail.addAll(taskModel.data!);
      }

      // If fewer than limit, no more data
      if (taskModel.data!.length < limit) {
        isMoreDataAvailable.value = false;
      } else {
        currentPage++;
      }
    } else {
      print("API error: ${response.statusText}");
    }

    isLoading.value = false;
    isRefreshing.value = false;
  }

  // Pull-to-refresh
  Future<void> refreshTasks() async {
    await fetchTasks(isRefresh: true);
  }

  // Load more when scrolling
  Future<void> loadMoreTasks() async {
    if (isMoreDataAvailable.value && !isLoading.value) {
      await fetchTasks();
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchTasks(isRefresh: true);
  }
}
