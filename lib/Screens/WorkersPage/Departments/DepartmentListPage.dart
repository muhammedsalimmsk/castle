import 'dart:ui';
import 'package:castle/Controlls/DepartmentController/DepartmentController.dart';
import 'package:castle/Screens/WorkersPage/Departments/NewDepartmentPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../../Colors/Colors.dart';
import '../../../Widget/CustomAppBarWidget.dart';
import '../../../Widget/CustomDrawer.dart';

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
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search here..",
                    fillColor: backgroundColor,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: shadeColor)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Text(
                  "Department List",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: GetBuilder<DepartmentController>(
                    builder: (controller) {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.departDetails.isEmpty) {
                        return const Center(
                            child: Text("No Departments Found"));
                      }

                      return ListView.separated(
                        itemCount: controller.departDetails.length,
                        itemBuilder: (context, index) {
                          final item = controller.departDetails[index];
                          return Slidable(
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
                                ),
                                SlidableAction(
                                  onPressed: (_) => _confirmDelete(item.id!),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(item.name ?? "No Name"),
                              subtitle: Text(item.description ?? ""),
                              leading:
                                  Icon(Icons.card_travel, color: buttonColor),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: buttonColor,
            foregroundColor: backgroundColor,
            onPressed: () => showAddDepartmentSheet(context),
            child: Icon(Icons.add),
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
