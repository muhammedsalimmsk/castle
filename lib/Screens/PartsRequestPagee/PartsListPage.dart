import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/PartsController/PartsController.dart';
import 'package:castle/Model/parts_list_model/datum.dart';
import 'package:castle/Screens/PartsRequestPagee/NewPartsPage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PartsListPage extends StatelessWidget {
  PartsListPage({super.key});
  PartsController controller = Get.put(PartsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Parts",
              style: TextStyle(
                  color: buttonColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: 730,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.partsData.length,
                          itemBuilder: (context, index) {
                            PartsDetail parts = controller.partsData[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: buttonColor),
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
                                  parts.partName!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(parts.category!),
                                trailing: Text(
                                  parts.currentStock!.toString(),
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          }),
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: buttonColor,
          onPressed: () {
            Get.to(PartRegisterPage());
          },
          label: Text(
            "New Parts",
            style: TextStyle(color: backgroundColor),
          )),
    );
  }
}
