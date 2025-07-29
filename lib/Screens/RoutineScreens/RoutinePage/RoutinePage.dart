import 'package:castle/Controlls/AssignRoutineController/RoutineController.dart';
import 'package:castle/Screens/RoutineScreens/AssignRoutinePage/AssignRoutinePage.dart';
import 'package:castle/Screens/RoutineScreens/RoutineDetails/RoutineDetails.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../Colors/Colors.dart';
import '../../../Controlls/AuthController/AuthController.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search
            TextFormField(
              decoration: InputDecoration(
                hintText: "Search here..",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: containerColor)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: containerColor)),
              ),
            ),
            const Gap(10),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Routine",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort),
                  onSelected: (value) => print("Selected: $value"),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'name', child: Text('Sort by Name')),
                    PopupMenuItem(value: 'date', child: Text('Sort by Date')),
                    PopupMenuItem(
                        value: 'priority', child: Text('Sort by Priority')),
                  ],
                ),
              ],
            ),

            const Gap(10),

            // Routine List with RefreshIndicator
            Expanded(
              child: Obx(() => RefreshIndicator(
                    onRefresh: () async {
                      controller.isRefresh = true;
                      await controller.getRoutine(role);
                      print(role);
                      controller.isRefresh = false;
                    },
                    child: ListView.builder(
                      itemCount: controller.routineList.length,
                      itemBuilder: (context, index) {
                        final routine = controller.routineList[index];
                        return InkWell(
                          onTap: () async {
                            await controller.getRoutinetask('', routine.id!);
                            Get.to(RoutineDetailsPage(detail: routine));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: shadeColor),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: containerColor
                                      .withOpacity(0.1), // soft shadow
                                  offset: Offset(0, 4), // X and Y offset
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                routine.name ?? "Unnamed",
                                style: TextStyle(color: containerColor),
                              ),
                              subtitle: Text(
                                  routine.assignedWorker?.firstName ??
                                      "Unknown"),
                              trailing: role == "admin"
                                  ? IconButton(
                                      onPressed: () {
                                        showDeleteConfirmationDialog(
                                            onConfirmAsync: () async {
                                          await controller
                                              .deleteRoutine(routine.id!);
                                        });
                                      },
                                      icon: const Icon(Icons.delete))
                                  : SizedBox.shrink(),
                            ),
                          ),
                        );
                      },
                    ),
                  )),
            ),

            // Add New Button
            role == 'admin'
                ? GestureDetector(
                    onTap: () {
                      Get.to(AssignRoutinePage());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: containerColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "New Routine",
                          style: TextStyle(color: backgroundColor),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
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
