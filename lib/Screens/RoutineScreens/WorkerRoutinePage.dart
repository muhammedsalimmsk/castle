import 'package:castle/Colors/Colors.dart';
import 'package:castle/Screens/RoutineScreens/RoutineTaskDetailPage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controlls/WorkerRoutineController/WorkerRoutineController.dart';

class WorkerRoutinePage extends StatelessWidget {
  const WorkerRoutinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkerTaskController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search Field
            TextField(
              onChanged: (value) {
                controller.searchQuery = value;
                controller.refreshTasks(); // Debounce can be added optionally
              },
              decoration: InputDecoration(
                hintText: "Search here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: containerColor),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 🔽 Sort Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tasks",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: controller.status,
                  underline: const SizedBox(),
                  items: ['PENDING', 'IN_PROGRESS', 'COMPLETED', 'SKIPPED']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.status = value!;
                    controller.refreshTasks();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 📜 Task List
            Expanded(
              child: Obx(() {
                if (controller.isRefreshing.value &&
                    controller.taskDetail.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return RefreshIndicator(
                  onRefresh: () => controller.refreshTasks(),
                  child: ListView.builder(
                    itemCount: controller.taskDetail.length + 1,
                    itemBuilder: (context, index) {
                      if (index < controller.taskDetail.length) {
                        final task = controller.taskDetail[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: GestureDetector(
                            onTap: () {
                              print(task.id);
                              Get.to(TaskDetailPage(taskId: task.id!));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: shadeColor,
                              ),
                              child: ListTile(
                                title: Text(task.routine?.name ?? 'No Title'),
                                subtitle: Text("Status: ${task.status ?? ''}"),
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (controller.isMoreDataAvailable.value) {
                          controller.loadMoreTasks();
                          return const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }
                    },
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
