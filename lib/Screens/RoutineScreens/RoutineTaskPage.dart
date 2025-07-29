import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AssignRoutineController/RoutineController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskListPage extends StatelessWidget {
  String routineId;

  final statusOptions = [
    '',
    'PENDING',
    'IN_PROGRESS',
    'COMPLETED',
    'SKIPPED',
  ];

  TaskListPage({super.key, required this.routineId});
  final controller = Get.put(AssignRoutineController());

  Color getStatusColor(String? status) {
    switch (status) {
      case 'PENDING':
        return Colors.orangeAccent;
      case 'IN_PROGRESS':
        return Colors.blueAccent;
      case 'COMPLETED':
        return Colors.green;
      case 'SKIPPED':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    RxString selectedStatus = "".obs;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Routine Tasks"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Task List",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Obx(() => Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: DropdownButton<String>(
                        value: selectedStatus.value,
                        underline: SizedBox(),
                        dropdownColor: Colors.white,
                        items: statusOptions.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(
                              status.isEmpty ? "All" : status,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          print(value);
                          if (value != null) {
                            controller.taskIsRefresh = true;
                            selectedStatus.value = value;
                            await controller.getRoutinetask(
                                selectedStatus.value, routineId);
                          }
                        },
                      ),
                    )),
              ],
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: () async {
                  controller.taskIsRefresh = true;
                  await controller.getRoutinetask(
                      selectedStatus.value, routineId);
                },
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.taskDetails.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final task = controller.taskDetails[index];
                    return GestureDetector(
                      // onTap: () => Get.to(() => TaskDetailPage(task: task)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: shadeColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.grey.shade300,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.status ?? 'N/A',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: getStatusColor(task.status),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Date: ${task.scheduledDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}",
                              style: const TextStyle(color: Colors.black87),
                            ),
                            Text(
                              "Time: ${task.scheduledTime ?? 'N/A'}",
                              style: const TextStyle(color: Colors.black87),
                            ),
                            if (task.routineId != null)
                              Text("Routine ID: ${task.routineId!}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
