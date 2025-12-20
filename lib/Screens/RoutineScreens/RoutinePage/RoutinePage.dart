import 'package:castle/Controlls/AssignRoutineController/RoutineController.dart';

import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Colors/Colors.dart';
import '../../../Controlls/AuthController/AuthController.dart';
import '../../../Utils/ResponsiveHelper.dart';

class RoutinePage extends StatelessWidget {
  RoutinePage({super.key});
  final AssignRoutineController controller = Get.put(AssignRoutineController());

  @override
  Widget build(BuildContext context) {
    final role = userDetailModel!.data!.role == "ADMIN" ? "admin" : "worker";
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      backgroundColor: backgroundColor,
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
                    "Routine",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: buttonColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: buttonColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "${controller.routineList.length} Routines",
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
            // Search Bar
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
                        decoration: InputDecoration(
                          hintText: "Search routines...",
                          hintStyle: TextStyle(
                            color: subtitleColor,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: buttonColor,
                            size: 22,
                          ),
                          suffixIcon: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.sort,
                              color: buttonColor,
                              size: 22,
                            ),
                            onSelected: (value) => print("Selected: $value"),
                            itemBuilder: (_) => const [
                              PopupMenuItem(value: 'name', child: Text('Sort by Name')),
                              PopupMenuItem(value: 'date', child: Text('Sort by Date')),
                              PopupMenuItem(
                                  value: 'priority', child: Text('Sort by Priority')),
                            ],
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
                ],
              ),
            ),
            // Routine List
            Expanded(
              child: Obx(
                    () => controller.isLoading2.value &&
                            controller.routineList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                                  strokeWidth: 3,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Loading routines...",
                                  style: TextStyle(
                                    color: subtitleColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : controller.routineList.isEmpty
                            ? RefreshIndicator(
                                onRefresh: () async {
                                  controller.isRefresh = true;
                                  await controller.getRoutine(role);
                                  controller.isRefresh = false;
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
                                              Icons.schedule_outlined,
                                              size: 64,
                                              color: subtitleColor,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            "No routines found",
                                            style: TextStyle(
                                              color: containerColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            role == "admin"
                                                ? "Add new routines to get started"
                                                : "No routines assigned yet",
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
                                    onRefresh: () async {
                                      controller.isRefresh = true;
                                      await controller.getRoutine(role);
                                      controller.isRefresh = false;
                                    },
                                    color: buttonColor,
                                    child: GridView.builder(
                                      padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                                        top: 0,
                                      ),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: ResponsiveHelper.isDesktop(context) ? 1.3 : 1.2,
                                      ),
                                      itemCount: controller.routineList.length,
                                      itemBuilder: (context, index) {
                                        final routine = controller.routineList[index];
                                        return _buildRoutineCard(routine, role);
                                      },
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      controller.isRefresh = true;
                                      await controller.getRoutine(role);
                                      controller.isRefresh = false;
                                    },
                                    color: buttonColor,
                                    child: ListView.builder(
                                      padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                                        top: 0,
                                      ),
                                      itemCount: controller.routineList.length,
                                      itemBuilder: (context, index) {
                                        final routine = controller.routineList[index];
                                        return _buildRoutineCard(routine, role);
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
      floatingActionButton: role == 'admin'
          ? Container(
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
              child: FloatingActionButton.extended(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () {
                  Get.toNamed('/assignRoutine');
                },
                icon: const Icon(Icons.add, color: backgroundColor),
                label: Text(
                  "New Routine",
                  style: TextStyle(
                    color: backgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildRoutineCard(dynamic routine, String role) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await controller.getRoutinetask('', routine.id!);
            Get.toNamed('/routineDetails', arguments: {'detail': routine});
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
                    Icons.schedule_rounded,
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
                        routine.name ?? "Unnamed",
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
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: subtitleColor,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              routine.assignedWorker?.firstName ?? "Unknown",
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
                      if (routine.frequency != null && routine.frequency!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.repeat,
                              size: 14,
                              color: subtitleColor,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                routine.frequency!,
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
                      if (routine.equipment?.name != null) ...[
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
                                routine.equipment!.name!,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (role == "admin")
                      IconButton(
                        onPressed: () {
                          showDeleteConfirmationDialog(
                            onConfirmAsync: () async {
                              await controller.deleteRoutine(routine.id!);
                            },
                          );
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: notWorkingTextColor,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.chevron_right,
                      color: subtitleColor,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog({
    required Future<void> Function() onConfirmAsync,
    String title = "Are you sure?",
    String message = "Do you really want to delete this item?",
  }) {
    final RxBool isDeleting = false.obs;

    Get.dialog(
      Obx(() => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.white,
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            content: isDeleting.value
                ? SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Text(message),
            actions: isDeleting.value
                ? []
                : [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text("Cancel",
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        isDeleting.value = true;
                        await onConfirmAsync(); // Await async delete logic
                        isDeleting.value = false;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child:
                          Text("Delete", style: TextStyle(color: Colors.white)),
                    ),
                  ],
          )),
      barrierDismissible: false,
    );
  }
}
