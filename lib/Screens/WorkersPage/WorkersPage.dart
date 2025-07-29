import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:castle/Model/workers_model/datum.dart';
import 'package:castle/Screens/WorkersPage/CreateWorker.dart';
import 'package:castle/Screens/WorkersPage/WorkerDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Colors/Colors.dart';
import '../../Widget/CustomAppBarWidget.dart';
import '../../Widget/CustomDrawer.dart';

class WorkersPage extends StatelessWidget {
  WorkersPage({super.key});
  final WorkerController controller = Get.put(WorkerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    suffixIcon:
                        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                    hintText: "Search here..",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: containerColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: shadeColor))),
              ),
              Text(
                "All Workers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Obx(() => SizedBox(
                    height: 660,
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.getWorkers();
                      },
                      child: ListView.builder(
                        itemCount: controller.workerList.length,
                        itemBuilder: (context, index) {
                          final WorkerData worker =
                              controller.workerList[index];
                          return InkWell(
                            onTap: () async {
                              Get.to(WorkerDetailsPage(
                                firstName: worker.firstName,
                                lastName: worker.lastName,
                                phone: worker.phone,
                                workerId: worker.id!,
                                email: worker.email,
                                isActive: worker.isActive,
                                createdAt: worker.createdAt,
                                assignedComplaints:
                                    worker.count?.assignedComplaints,
                                routines: worker.count?.routines,
                              ));
                            },
                            child: ListTile(
                              title: Text(worker.lastName!),
                              subtitle: Text(worker.email!),
                              leading: Icon(Icons.person),
                              trailing: IconButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                    backgroundColor: backgroundColor,
                                    title: "Delete",
                                    middleText: "Are you sure want to delete?",
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[300],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      Obx(
                                        () => controller.isLoading.value
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : ElevatedButton(
                                                onPressed: () async {
                                                  await controller
                                                      .deleteWorker(worker.id!);
                                                  Get.back();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: buttonColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                      )
                                    ],
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: buttonColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: buttonColor,
        onPressed: () {
          Get.to(CreateWorker());
        },
        label: Text(
          "Add New",
          style: TextStyle(color: backgroundColor),
        ),
      ),
    );
  }
}
