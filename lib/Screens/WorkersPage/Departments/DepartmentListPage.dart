import 'dart:ui';
import 'package:castle/Controlls/DepartmentController/DepartmentController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../Colors/Colors.dart';
import '../../../Widget/CustomAppBarWidget.dart';
import '../../../Widget/CustomDrawer.dart';
import '../../../Utils/ResponsiveHelper.dart';

class DepartmentPage extends StatelessWidget {
  DepartmentPage({super.key});

  final DepartmentController controller = Get.put(DepartmentController());

  @override
  Widget build(BuildContext context) {
    controller.getDepartment();

    return Stack(
      children: [
        Scaffold(
          drawer: CustomDrawer(),
          appBar: CustomAppBar(),
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
                        "Departments",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: containerColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                      GetBuilder<DepartmentController>(
                        builder: (controller) => Container(
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
                            "${controller.departDetails.length} Departments",
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
                        hintText: "Search departments...",
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
                // Departments List
                Expanded(
                  child: GetBuilder<DepartmentController>(
                        builder: (controller) {
                          if (controller.isLoading.value) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                                    strokeWidth: 3,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Loading departments...",
                                    style: TextStyle(
                                      color: subtitleColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (controller.departDetails.isEmpty) {
                            return RefreshIndicator(
                              onRefresh: () async {
                                await controller.getDepartment();
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
                                            Icons.card_travel_outlined,
                                            size: 64,
                                            color: subtitleColor,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        Text(
                                          "No departments found",
                                          style: TextStyle(
                                            color: containerColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Add new departments to get started",
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

                          return ResponsiveHelper.isLargeScreen(context)
                              ? RefreshIndicator(
                                  onRefresh: () async {
                                    await controller.getDepartment();
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
                                    itemCount: controller.departDetails.length,
                                    itemBuilder: (context, index) {
                                      final item = controller.departDetails[index];
                                      return _buildDepartmentCard(context, item);
                                    },
                                  ),
                                )
                              : RefreshIndicator(
                                  onRefresh: () async {
                                    await controller.getDepartment();
                                  },
                                  color: buttonColor,
                                  child: ListView.builder(
                                    padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
                                      top: 0,
                                    ),
                                    itemCount: controller.departDetails.length,
                                    itemBuilder: (context, index) {
                                      final item = controller.departDetails[index];
                                      return _buildDepartmentCard(context, item);
                                    },
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Container(
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
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () => showAddDepartmentSheet(context),
              child: Icon(Icons.add, color: backgroundColor),
            ),
          ),
        ),

        /// Loading Overlay
        Obx(() {
          return controller.isCreating.value || controller.isDeleting.value
              ? Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildDepartmentCard(BuildContext context, dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        key: ValueKey(item.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _showEditSheet(context,
                  item.id!, item.name!, item.description!),
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(16),
            ),
            SlidableAction(
              onPressed: (_) => _confirmDelete(item.id!),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
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
                      Icons.card_travel_rounded,
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
                          item.name ?? "No Name",
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
                        if (item.description != null && item.description!.isNotEmpty)
                          Text(
                            item.description!,
                            style: TextStyle(
                              fontSize: 13,
                              color: subtitleColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Arrow
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
      ),
    );
  }

  void _confirmDelete(String id) {
    Get.defaultDialog(
      backgroundColor: backgroundColor,
      title: "Delete?",
      middleText: "Are you sure you want to delete this department?",
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, // your custom color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // rounded corners
          ),
        ),
        onPressed: () async {
          Get.back();
          await controller.deleteDepartment(id);
        },
        child: const Text("Yes", style: TextStyle(color: Colors.white)),
      ),
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: buttonColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Get.back(),
        child: Text("No", style: TextStyle(color: buttonColor)),
      ),
    );
  }

  void _showEditSheet(
      BuildContext context, String id, String name, String desc) {
    controller.nameCtrl.text = name;
    controller.descCtrl.text = desc;
    showAddDepartmentSheet(context, isEdit: true, editId: id);
  }

  void showAddDepartmentSheet(BuildContext context,
      {bool isEdit = false, String? editId}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          maxChildSize: 0.85,
          minChildSize: 0.35,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      top: 12,
                    ),
                    child: GetBuilder<DepartmentController>(
                      builder: (c) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                  color: buttonColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Text(
                              isEdit ? "Edit Department" : "New Department",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 15),
                            TextField(
                              controller: controller.nameCtrl,
                              decoration: const InputDecoration(
                                labelText: "Department Name",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: controller.descCtrl,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: "Description",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Obx(() {
                              if (controller.isCreating.value) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (isEdit) {
                                      await controller.updateDepartment(
                                        controller.nameCtrl.text,
                                        controller.descCtrl.text,
                                        editId!,
                                      );
                                    } else {
                                      await controller.createDepartment(
                                        controller.nameCtrl.text,
                                        controller.descCtrl.text,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                  child: Text(
                                    isEdit ? "Update" : "Create",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
