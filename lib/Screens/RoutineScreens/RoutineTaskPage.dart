import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AssignRoutineController/RoutineController.dart';
import 'package:castle/Utils/ResponsiveHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskListPage extends StatelessWidget {
  final String routineId;

  final statusOptions = [
    '',
    'PENDING',
    'IN_PROGRESS',
    'COMPLETED',
    'SKIPPED',
  ];

  TaskListPage({super.key, required this.routineId});
  final controller = Get.put(AssignRoutineController());

  String formatStatus(String? status) {
    if (status == null || status.isEmpty) return "Unknown";
    return status.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  Color getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case "PENDING":
        return containerColor;
      case "IN_PROGRESS":
        return workingTextColor;
      case "COMPLETED":
        return Colors.green;
      case "SKIPPED":
        return notWorkingTextColor;
      default:
        return subtitleColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    RxString selectedStatus = "".obs;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          "Routine Tasks",
          style: TextStyle(
            color: containerColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: buttonColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: Column(
              children: [
                // Modern Header Section
                Container(
                  padding: ResponsiveHelper.getResponsivePadding(context),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: cardShadowColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Task List",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: containerColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: buttonColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: buttonColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            "${controller.taskDetails.length} Tasks",
                            style: TextStyle(
                              color: buttonColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Filter Section
                Padding(
                  padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                    top: 12,
                    bottom: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: cardShadowColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Obx(
                            () => DropdownButtonFormField<String>(
                              value: selectedStatus.value,
                              decoration: InputDecoration(
                                labelText: "Filter by Status",
                                labelStyle: TextStyle(
                                  color: subtitleColor,
                                  fontSize: 14,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                filled: true,
                                fillColor: backgroundColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: dividerColor,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: dividerColor,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: buttonColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              dropdownColor: backgroundColor,
                              style: TextStyle(
                                color: containerColor,
                                fontSize: 15,
                              ),
                              icon: Icon(Icons.arrow_drop_down, color: buttonColor),
                              items: statusOptions.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(
                                    status.isEmpty ? "All Status" : formatStatus(status),
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                if (value != null) {
                                  controller.taskIsRefresh = true;
                                  selectedStatus.value = value;
                                  await controller.getRoutinetask(
                                      selectedStatus.value, routineId);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Task List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(buttonColor),
                              strokeWidth: 3,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Loading tasks...",
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (controller.taskDetails.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          controller.taskIsRefresh = true;
                          await controller.getRoutinetask(
                              selectedStatus.value, routineId);
                        },
                        color: buttonColor,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 100),
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: searchBackgroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.task_outlined,
                                      size: 64,
                                      color: subtitleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    "No tasks found",
                                    style: TextStyle(
                                      color: containerColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "No tasks match the selected filter",
                                    style: TextStyle(
                                      color: subtitleColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        controller.taskIsRefresh = true;
                        await controller.getRoutinetask(
                            selectedStatus.value, routineId);
                      },
                      color: buttonColor,
                      child: ListView.separated(
                        padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                          top: 0,
                        ),
                        itemCount: controller.taskDetails.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final task = controller.taskDetails[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Navigate to task detail page if needed
                                // Get.to(() => TaskDetailPage(task: task));
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: dividerColor,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cardShadowColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: getStatusColor(task.status)
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: getStatusColor(task.status)
                                                  .withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            formatStatus(task.status),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: getStatusColor(task.status),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: subtitleColor,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: subtitleColor,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          task.scheduledDate?.toLocal().toString().split(' ')[0] ?? 'N/A',
                                          style: TextStyle(
                                            color: containerColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: subtitleColor,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          task.scheduledTime ?? 'N/A',
                                          style: TextStyle(
                                            color: containerColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (task.routineId != null) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        "Routine ID: ${task.routineId!}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: subtitleColor,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
