import 'package:castle/Colors/Colors.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controlls/WorkerRoutineController/WorkerRoutineController.dart';
import '../../Utils/ResponsiveHelper.dart';

class WorkerRoutinePage extends StatelessWidget {
  const WorkerRoutinePage({super.key});

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

  String formatStatus(String? status) {
    if (status == null || status.isEmpty) return "Unknown";
    return status.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkerTaskController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
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
                      Text(
                        "Tasks",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: containerColor,
                          letterSpacing: -0.5,
                        ),
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
                            "${controller.taskDetail.length} Tasks",
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
                // Search Bar and Filter
                Padding(
                  padding:
                      ResponsiveHelper.getResponsivePadding(context).copyWith(
                    top: 12,
                    bottom: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: searchBackgroundColor,
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
                          child: TextField(
                            onChanged: (value) {
                              controller.searchQuery = value;
                              controller.refreshTasks();
                            },
                            decoration: InputDecoration(
                              hintText: "Search tasks...",
                              hintStyle: TextStyle(
                                color: subtitleColor,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: buttonColor,
                                size: 22,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: buttonColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              filled: true,
                              fillColor: searchBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: searchBackgroundColor,
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
                        child: DropdownButton<String>(
                          value: controller.status,
                          underline: const SizedBox(),
                          icon: Icon(Icons.filter_list, color: buttonColor),
                          dropdownColor: backgroundColor,
                          style: TextStyle(
                            color: containerColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          items:
                              ['PENDING', 'IN_PROGRESS', 'COMPLETED', 'SKIPPED']
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(formatStatus(status)),
                                      ))
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.status = value;
                              controller.refreshTasks();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Task List
                Expanded(
                  child: Obx(
                    () => controller.isRefreshing.value &&
                            controller.taskDetail.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      buttonColor),
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
                          )
                        : controller.taskDetail.isEmpty
                            ? RefreshIndicator(
                                onRefresh: () => controller.refreshTasks(),
                                color: buttonColor,
                                child: ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
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
                                            "No tasks available for this status",
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
                              )
                            : ResponsiveHelper.isLargeScreen(context)
                                ? RefreshIndicator(
                                    onRefresh: () => controller.refreshTasks(),
                                    color: buttonColor,
                                    child: GridView.builder(
                                      padding:
                                          ResponsiveHelper.getResponsivePadding(
                                                  context)
                                              .copyWith(
                                        top: 0,
                                      ),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: ResponsiveHelper
                                            .getGridCrossAxisCount(context),
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 12,
                                        childAspectRatio:
                                            ResponsiveHelper.isDesktop(context)
                                                ? 1.3
                                                : 1.2,
                                      ),
                                      itemCount:
                                          controller.taskDetail.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index <
                                            controller.taskDetail.length) {
                                          final task =
                                              controller.taskDetail[index];
                                          return _buildTaskCard(task);
                                        } else {
                                          if (controller
                                              .isMoreDataAvailable.value) {
                                            controller.loadMoreTasks();
                                            return const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        }
                                      },
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () => controller.refreshTasks(),
                                    color: buttonColor,
                                    child: ListView.builder(
                                      padding:
                                          ResponsiveHelper.getResponsivePadding(
                                                  context)
                                              .copyWith(
                                        top: 0,
                                      ),
                                      itemCount:
                                          controller.taskDetail.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index <
                                            controller.taskDetail.length) {
                                          final task =
                                              controller.taskDetail[index];
                                          return _buildTaskCard(task);
                                        } else {
                                          if (controller
                                              .isMoreDataAvailable.value) {
                                            controller.loadMoreTasks();
                                            return const Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            );
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        }
                                      },
                                    ),
                                  ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(dynamic task) {
    final statusColor = getStatusColor(task.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed('/taskDetail', arguments: {'taskId': task.id!});
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        buttonColor,
                        buttonColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: buttonColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.task_alt_rounded,
                    color: backgroundColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        task.routine?.name ?? 'No Title',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: containerColor,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: statusColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              formatStatus(task.status),
                              style: TextStyle(
                                fontSize: 12,
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (task.routine?.equipment?.name != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.precision_manufacturing_outlined,
                              size: 14,
                              color: subtitleColor,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                task.routine!.equipment!.name!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: subtitleColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Actions
                Icon(
                  Icons.chevron_right,
                  color: subtitleColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
