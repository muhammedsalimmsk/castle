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
              child: GetBuilder<ComplaintController>(
                builder: (complaintController) {
                  if (complaintController.isLoading.value) {
                    // Show loading while fetching data
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (complaintController.details.isEmpty &&
                      !complaintController.isRefresh) {
                    // Show message when list is empty and not refreshing
                    return const Center(
                      child: Text(
                        "No complaint here",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  // When data is available
                  return RefreshIndicator(
                    onRefresh: () async {
                      complaintController.hasMore = true;
                      complaintController.isRefresh = true;
                      await complaintController.getComplaint(
                        role: userDetailModel!.data!.role!.toLowerCase(),
                      );
                      complaintController.isRefresh = false;
                      complaintController.update(); // update UI after refresh
                    },
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          Divider(color: buttonColor),
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: complaintController.scrollController,
                      itemCount: complaintController.details.length + 1,
                      itemBuilder: (context, index) {
                        if (index < complaintController.details.length) {
                          var datas = complaintController.details[index];
                          return GestureDetector(
                            onTap: () async {
                              Get.to(
                                ComplaintDetailsPage(
                                  complaintId: datas.id!,
                                ),
                              );
                              // await workerController.getWorkers();
                            },
                            child: ListTile(
                              title: Text(
                                datas.equipment!.name!,
                                style: TextStyle(
                                  color: containerColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(datas.title ?? ""),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        datas.priority ?? "",
                                        style: TextStyle(color: buttonColor),
                                      ),
                                      Text(datas.status ?? ""),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  if (userDetailModel!.data!.role == "ADMIN")
                                    Container(
                                      padding: const EdgeInsets.symmetric(
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
                          return complaintController.hasMore
                              ? const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : const SizedBox.shrink();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
