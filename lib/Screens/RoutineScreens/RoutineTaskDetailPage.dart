import 'package:castle/Colors/Colors.dart';
import 'package:flutter/material.dart';

import '../../Controlls/AssignRoutineController/RoutineController.dart';
import 'package:get/get.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import '../../Model/routine_task_model/tasked_routine_detail_model/data.dart';
import '../../Utils/ResponsiveHelper.dart';

class TaskDetailPage extends StatefulWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final AssignRoutineController controller = Get.put(AssignRoutineController());
  late Future<WorkerTaskDetail?> _taskFuture;

  @override
  void initState() {
    super.initState();
    // Cache the future to prevent rebuilds
    _taskFuture = controller.fetchRoutineTask(widget.taskId);
  }

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
    print(token);
    print(widget.taskId);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          "Task Detail",
          style: TextStyle(
            color: buttonColor,
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
            child: FutureBuilder<WorkerTaskDetail?>(
              future: _taskFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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
                          "Loading task details...",
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: Padding(
                      padding: ResponsiveHelper.getResponsivePadding(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: searchBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline,
                              size: 64,
                              color: notWorkingTextColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Failed to load task",
                            style: TextStyle(
                              color: containerColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Please try again",
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  buttonColor,
                                  buttonColor.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: buttonColor.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                              ),
                              onPressed: () {
                                setState(() {
                                  _taskFuture = controller
                                      .fetchRoutineTask(widget.taskId);
                                });
                              },
                              child: Text(
                                "Retry",
                                style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final task = snapshot.data!;
                controller.selectedStatus.value = task.status ?? 'PENDING';
                controller.notesController.text = task.notes?.toString() ?? '';

                return _TaskDetailContent(
                  task: task,
                  controller: controller,
                  formatStatus: formatStatus,
                  getStatusColor: getStatusColor,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskDetailContent extends StatefulWidget {
  final WorkerTaskDetail task;
  final AssignRoutineController controller;
  final String Function(String?) formatStatus;
  final Color Function(String?) getStatusColor;

  const _TaskDetailContent({
    required this.task,
    required this.controller,
    required this.formatStatus,
    required this.getStatusColor,
  });

  @override
  State<_TaskDetailContent> createState() => _TaskDetailContentState();
}

class _TaskDetailContentState extends State<_TaskDetailContent> {
  GlobalKey<_ReadingsSectionState>? readingsSectionKey;

  @override
  void initState() {
    super.initState();
    // Create GlobalKey for readings section if needed
    if (widget.task.routine?.readings != null &&
        widget.task.routine!.readings!.isNotEmpty) {
      readingsSectionKey = GlobalKey<_ReadingsSectionState>();
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final controller = widget.controller;

    return SingleChildScrollView(
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
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
                  "Task Details",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: containerColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          // Routine Info Section
          _sectionCard(
            title: "Routine Info",
            icon: Icons.schedule_rounded,
            children: [
              _infoTile("Name", task.routine?.name ?? "-"),
              _infoTile("Frequency", task.routine?.frequency ?? "-"),
              _infoTile("Time Slot", task.routine?.timeSlot ?? "-"),
            ],
          ),
          const SizedBox(height: 16),
          // Equipment Section
          _sectionCard(
            title: "Equipment",
            icon: Icons.precision_manufacturing_outlined,
            children: [
              _infoTile("Name", task.routine?.equipment?.name ?? "-"),
              _infoTile("Model", task.routine?.equipment?.model ?? "-"),
              _infoTile("Location", task.routine?.equipment?.location ?? "-"),
            ],
          ),
          const SizedBox(height: 16),
          // Status Section
          _sectionCard(
            title: "Task Status",
            icon: Icons.task_alt_rounded,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      "Status:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: subtitleColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            widget.getStatusColor(task.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget
                              .getStatusColor(task.status)
                              .withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.formatStatus(task.status),
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.getStatusColor(task.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Readings Section (if routine has readings)
          if (task.routine?.readings != null &&
              task.routine!.readings!.isNotEmpty &&
              readingsSectionKey != null)
            _ReadingsSection(
              key: readingsSectionKey,
              readingTypes: task.routine!.readings!,
              existingReadings: task.readings,
            ),
          if (task.routine?.readings != null &&
              task.routine!.readings!.isNotEmpty)
            const SizedBox(height: 16),
          // Update Status Section
          _sectionCard(
            title: "Update Status",
            icon: Icons.update_rounded,
            children: [
              Obx(() {
                final validStatuses = ["IN_PROGRESS", "COMPLETED", "SKIPPED"];
                if (!validStatuses.contains(controller.selectedStatus.value)) {
                  controller.selectedStatus.value = validStatuses.first;
                }

                return Container(
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
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedStatus.value,
                    decoration: InputDecoration(
                      labelText: "Status",
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
                    items: validStatuses
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(widget.formatStatus(s)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectedStatus.value = val;
                      }
                    },
                  ),
                );
              }),
              const SizedBox(height: 16),
              Container(
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
                child: TextField(
                  controller: controller.notesController,
                  maxLines: 3,
                  style: TextStyle(
                    color: containerColor,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: "Add notes...",
                    hintStyle: TextStyle(
                      color: subtitleColor,
                      fontSize: 15,
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Update Button
          Obx(
            () => controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                      strokeWidth: 3,
                    ),
                  )
                : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          buttonColor,
                          buttonColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: buttonColor.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () async {
                        // Get readings from the readings section widget if it exists
                        List<Map<String, dynamic>>? readingsData;
                        if (readingsSectionKey != null &&
                            readingsSectionKey!.currentState != null) {
                          readingsData = readingsSectionKey!.currentState!
                              .getReadingsData();
                        }

                        await controller.updateRoutineTask(
                          task.id!,
                          controller.selectedStatus.value,
                          controller.notesController.text,
                          readings: readingsData,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.update, color: backgroundColor, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            "Update Task",
                            style: TextStyle(
                              color: backgroundColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      buttonColor,
                      buttonColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: backgroundColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            color: dividerColor,
          ),
          const SizedBox(height: 12),
          ...children
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: subtitleColor,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: containerColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingsSection extends StatefulWidget {
  final List<String> readingTypes;
  final dynamic existingReadings;

  const _ReadingsSection({
    super.key,
    required this.readingTypes,
    required this.existingReadings,
  });

  @override
  State<_ReadingsSection> createState() => _ReadingsSectionState();
}

class _ReadingsSectionState extends State<_ReadingsSection> {
  late Map<String, TextEditingController> readingControllers;

  @override
  void initState() {
    super.initState();
    readingControllers = {};

    // Parse existing readings if available
    Map<String, String> existingReadingsMap = {};
    if (widget.existingReadings != null && widget.existingReadings is List) {
      final readingsList = widget.existingReadings as List;
      if (readingsList.isNotEmpty && readingsList[0] is Map) {
        existingReadingsMap = Map<String, String>.from(readingsList[0] as Map);
      }
    }

    // Initialize controllers (no listeners - we'll get values when needed)
    for (var readingType in widget.readingTypes) {
      readingControllers[readingType] = TextEditingController(
        text: existingReadingsMap[readingType] ?? '',
      );
    }
  }

  // Method to get readings data when updating
  List<Map<String, dynamic>>? getReadingsData() {
    Map<String, dynamic> readingsMap = {};
    for (var readingType in widget.readingTypes) {
      final value = readingControllers[readingType]?.text.trim() ?? '';
      if (value.isNotEmpty) {
        readingsMap[readingType] = value;
      }
    }

    if (readingsMap.isNotEmpty) {
      return [readingsMap];
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    for (var controller in readingControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _sectionCard(
      title: "Readings",
      icon: Icons.speed_rounded,
      children: [
        ...widget.readingTypes.map((readingType) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
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
              child: TextField(
                controller: readingControllers[readingType],
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: containerColor,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  labelText: readingType.toUpperCase(),
                  hintText: "Enter ${readingType} reading...",
                  hintStyle: TextStyle(
                    color: subtitleColor,
                    fontSize: 15,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      buttonColor,
                      buttonColor.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: backgroundColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: containerColor,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            thickness: 1,
            color: dividerColor,
          ),
          const SizedBox(height: 12),
          ...children
        ],
      ),
    );
  }
}
