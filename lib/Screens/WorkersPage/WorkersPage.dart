import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:castle/Model/workers_model/datum.dart';
import 'package:castle/Screens/WorkersPage/CreateWorker.dart';
import 'package:castle/Screens/WorkersPage/Departments/DepartmentListPage.dart';
import 'package:castle/Screens/WorkersPage/WorkerDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';

import '../../Colors/Colors.dart';
import '../../Controlls/AuthController/AuthController.dart';
import '../../Widget/CustomAppBarWidget.dart';
import '../../Widget/CustomDrawer.dart';

class WorkersPage extends StatelessWidget {
  WorkersPage({super.key});
  final WorkerController controller = Get.put(WorkerController());
  final _key = GlobalKey<ExpandableFabState>();

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
                        borderSide: BorderSide(color: buttonColor)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: buttonColor))),
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
                                worker: worker,
                              ));
                            },
                            child: ListTile(
                              title: Text(
                                "${worker.firstName} ${worker.lastName ?? ""}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(worker.email ?? ""),
                              leading: Icon(
                                Icons.person,
                                color: buttonColor,
                              ),
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
                                            ? CircularProgressIndicator(
                                                color: buttonColor,
                                              )
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
                                  color: buttonColor.withOpacity(0.7),
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
      floatingActionButton: userDetailModel!.data!.role == "ADMIN"
          ? ExpandableFab(
              openButtonBuilder: RotateFloatingActionButtonBuilder(
                child: const Icon(Icons.menu),
                fabSize: ExpandableFabSize.regular,
                foregroundColor: Colors.white,
                backgroundColor: buttonColor,
              ),
              closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                child: const Icon(Icons.close),
                fabSize: ExpandableFabSize.small,
                foregroundColor: Colors.white,
                backgroundColor: buttonColor,
                shape: const CircleBorder(),
              ),
              key: _key,
              type: ExpandableFabType.up,
              childrenAnimation: ExpandableFabAnimation.none,
              distance: 70,
              overlayStyle: ExpandableFabOverlayStyle(
                color: Colors.white.withOpacity(0.9),
              ),
              children: [
                Row(
                  children: [
                    Text(
                      'Department',
                      style: TextStyle(
                          color: buttonColor, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      heroTag: ":f15",
                      onPressed: () {
                        Get.to(DepartmentPage());
                      },
                      child: Icon(Icons.card_travel),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('New Worker',
                        style: TextStyle(
                            color: buttonColor, fontWeight: FontWeight.bold)),
                    SizedBox(width: 20),
                    FloatingActionButton(
                      foregroundColor: Colors.white,
                      backgroundColor: buttonColor,
                      heroTag: ":f34",
                      onPressed: () {
                        Get.to(CreateWorker());
                      },
                      child: Icon(Icons.person),
                    ),
                  ],
                ),
              ],
            )
          : SizedBox.shrink(),
      floatingActionButtonLocation: ExpandableFab.location,
    );
  }
}
