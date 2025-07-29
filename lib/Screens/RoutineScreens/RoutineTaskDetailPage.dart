import 'package:castle/Colors/Colors.dart';
import 'package:flutter/material.dart';

import '../../Controlls/AssignRoutineController/RoutineController.dart';
import 'package:get/get.dart';

import '../../Model/routine_task_model/tasked_routine_detail_model/data.dart';

class TaskDetailPage extends StatelessWidget {
  final String taskId;

  TaskDetailPage({super.key, required this.taskId});

  final AssignRoutineController controller = Get.put(AssignRoutineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Detail"),
        backgroundColor: backgroundColor,
        foregroundColor: containerColor,
      ),
      body: FutureBuilder<WorkerTaskDetail?>(
        future: controller.fetchRoutineTask(taskId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Failed to load task."),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: containerColor),
                    onPressed: () {
                      controller.fetchRoutineTask(taskId);
                    },
                    child: const Text(
                      "Retry",
                      style: TextStyle(color: backgroundColor),
                    ),
                  ),
                ],
              ),
            );
          }

          final task = snapshot.data!;
          controller.selectedStatus.value = task.status ?? 'PENDING';
          controller.notesController.text = task.notes?.toString() ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 First Card: Info Display
                Card(
                  color: shadeColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _section("Routine Info", [
                          _infoTile("Name", task.routine?.name),
                          _infoTile("Frequency", task.routine?.frequency),
                          _infoTile("Time Slot", task.routine?.timeSlot),
                        ]),
                        const SizedBox(height: 16),
                        _section("Equipment", [
                          _infoTile("Name", task.routine?.equipment?.name),
                          _infoTile("Model", task.routine?.equipment?.model),
                          _infoTile(
                              "Location", task.routine?.equipment?.location),
                        ]),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Second Card: Update Section
                Card(
                  color: shadeColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _section("Update Status", [
                          Obx(() {
                            final validStatuses = [
                              "IN_PROGRESS",
                              "COMPLETED",
                              "SKIPPED"
                            ];
                            if (!validStatuses
                                .contains(controller.selectedStatus.value)) {
                              controller.selectedStatus.value =
                                  validStatuses.first;
                            }

                            return DropdownButtonFormField<String>(
                              value: controller.selectedStatus.value,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Status",
                              ),
                              items: validStatuses
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  controller.selectedStatus.value = val;
                                }
                              },
                            );
                          }),
                          const SizedBox(height: 16),
                          TextField(
                            controller: controller.notesController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Add notes...",
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🔹 Separate Update Button
                Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              await controller.updateRoutineTask(
                                task.id!,
                                controller.selectedStatus.value,
                                controller.notesController.text,
                              );
                            },
                            child: const Text(
                              "Update Task",
                              style: TextStyle(color: backgroundColor),
                            ),
                          ),
                        ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _section(String title, List<Widget> children) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 8),
          ...children,
        ],
      );

  Widget _infoTile(String label, String? value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$label: ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
                child: Text(value ?? "-",
                    style: const TextStyle(color: Colors.black54))),
          ],
        ),
      );
}
