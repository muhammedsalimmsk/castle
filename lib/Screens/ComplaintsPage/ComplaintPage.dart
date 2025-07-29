import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/ComplaintController/ComplaintController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Controlls/WorkersController/WorkerController.dart';
import 'package:castle/Screens/ComplaintsPage/ComplaintDetailsPage.dart';
import 'package:get/get.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../Controlls/AuthController/AuthController.dart';
import 'Widgets/FilterPage.dart';

class ComplaintPage extends StatelessWidget {
  ComplaintPage({super.key});
  final ComplaintController complaintController =
      Get.put(ComplaintController());
  final WorkerController workerController = Get.put(WorkerController());

  @override
  Widget build(BuildContext context) {
    EquipmentController controller = Get.put(EquipmentController());
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 10,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
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
                        )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    Get.dialog(FilterDialog());
                    // Your action here
                  },
                  icon: Container(
                    padding: EdgeInsets.all(12),
                    // width: 50, // Adjust width
                    // height: 50, // Adjust height
                    decoration: BoxDecoration(
                      border: Border.all(color: shadeColor),
                      color: buttonColor, // Background color
                      borderRadius: BorderRadius.circular(
                          8), // Adjust for rounded corners
                    ),
                    child: Icon(
                      FontAwesomeIcons.sliders,
                      color: backgroundColor,
                    ), // Your icon
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Complaints",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => DropdownButton<String>(
                          isDense: true,
                          padding: EdgeInsets.zero,
                          value: controller.selectedValue.value,
                          icon: Icon(Icons.arrow_drop_down), // Down arrow icon
                          underline: SizedBox(), // Removes default underline
                          borderRadius: BorderRadius.circular(10),
                          style: TextStyle(
                              color: Colors.black), // Customize text style
                          items: controller.sortOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            controller.selectedValue.value = newValue!;
                          },
                        )),
                  ],
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.72,
              child: Obx(() => RefreshIndicator(
                    onRefresh: () async {
                      complaintController.hasMore = true;
                      complaintController.isRefresh = true;
                      await complaintController.getComplaint(
                        role: userDetailModel!.data!.role!.toLowerCase(),
                      );
                      complaintController.isRefresh = false;
                    },
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: buttonColor,
                        );
                      },
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: complaintController.scrollController,
                      itemCount: complaintController.details.length +
                          1, // +1 for loading indicator
                      itemBuilder: (context, index) {
                        if (index < complaintController.details.length) {
                          var datas = complaintController.details[index];
                          return GestureDetector(
                            onTap: () async {
                              await workerController.getWorkers();
                              Get.to(ComplaintDetailsPage(
                                  complaintId:
                                      complaintController.details[index].id!));
                            },
                            child: ListTile(
                              title: Text(
                                datas.equipment!.name!,
                                style: TextStyle(
                                  color: containerColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(datas.title!),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(datas.priority!,
                                          style: TextStyle(color: buttonColor)),
                                      Text(datas.status!),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if (userDetailModel!.data!.role == "ADMIN")
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: datas.status == "OPEN"
                                            ? buttonColor
                                            : Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        datas.status ?? "Assign",
                                        style: TextStyle(
                                          color: datas.status == "OPEN"
                                              ? Colors.red
                                              : Colors.green[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Loading indicator at the bottom
                          return complaintController.hasMore
                              ? Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : SizedBox.shrink();
                        }
                      },
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  // void showAssignWorkerDialog(BuildContext context, String complaintId) async {
  //   await workerController.getWorkers(); // Load worker list
  //   if (workerController.workerList.isEmpty) {
  //     Get.snackbar("No Workers", "No workers found to assign");
  //     return;
  //   }
  //
  //   Get.bottomSheet(
  //     Container(
  //       padding: EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text("Assign to Worker",
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //           SizedBox(height: 10),
  //           ...workerController.workerList.map((worker) => ListTile(
  //                 title: Text(worker.firstName ?? ''),
  //                 subtitle: Text(worker.email ?? ''),
  //                 onTap: () {
  //                   Get.back();
  //                   Get.dialog(
  //                     Dialog(
  //                       backgroundColor: backgroundColor,
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10)),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(20),
  //                         child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           crossAxisAlignment: CrossAxisAlignment.stretch,
  //                           children: [
  //                             Text(
  //                               "Confirm Assignment",
  //                               style: TextStyle(
  //                                 fontSize: 18,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                               textAlign: TextAlign.center,
  //                             ),
  //                             const SizedBox(height: 12),
  //                             Text(
  //                               "Are you sure you want to assign this complaint to ${worker.firstName}?",
  //                               textAlign: TextAlign.center,
  //                             ),
  //                             const SizedBox(height: 24),
  //                             Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceEvenly,
  //                               children: [
  //                                 // ❌ Cancel Button
  //                                 Expanded(
  //                                   child: ElevatedButton(
  //                                     onPressed: () => Get.back(),
  //                                     style: ElevatedButton.styleFrom(
  //                                       backgroundColor: Colors.grey[300],
  //                                       shape: RoundedRectangleBorder(
  //                                         borderRadius:
  //                                             BorderRadius.circular(10),
  //                                       ),
  //                                       padding:
  //                                           EdgeInsets.symmetric(vertical: 12),
  //                                     ),
  //                                     child: Text(
  //                                       "Cancel",
  //                                       style: TextStyle(color: Colors.black),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 SizedBox(width: 16),
  //                                 // ✅ Confirm Button
  //                                 Obx(
  //                                   () => complaintController.isLoading.value
  //                                       ? Center(
  //                                           child: CircularProgressIndicator(),
  //                                         )
  //                                       : Expanded(
  //                                           child: ElevatedButton(
  //                                             onPressed: () async {
  //                                               await complaintController
  //                                                   .assignComplaint(
  //                                                 worker.id!,
  //                                                 complaintId,
  //                                               );
  //                                               Get.back();
  //                                               await complaintController
  //                                                   .getComplaint(
  //                                                       role: userDetailModel!
  //                                                           .data!.role!
  //                                                           .toLowerCase());
  //                                             },
  //                                             style: ElevatedButton.styleFrom(
  //                                               backgroundColor: containerColor,
  //                                               shape: RoundedRectangleBorder(
  //                                                 borderRadius:
  //                                                     BorderRadius.circular(10),
  //                                               ),
  //                                               padding: EdgeInsets.symmetric(
  //                                                   vertical: 12),
  //                                             ),
  //                                             child: Text(
  //                                               "Assign",
  //                                               style: TextStyle(
  //                                                   color: backgroundColor),
  //                                             ),
  //                                           ),
  //                                         ),
  //                                 )
  //                               ],
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   );
  //                 },
  //               )),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
