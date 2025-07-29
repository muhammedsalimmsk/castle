import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/PartsController/PartsController.dart';
import 'package:castle/Model/parts_list_model/datum.dart';
import 'package:castle/Screens/PartsRequestPagee/NewPartsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PartsListPage extends StatelessWidget {
  PartsListPage({super.key});
  PartsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: backgroundColor,
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text("Parts List"),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: shadeColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: containerColor)),
                  hintText: "Search here..",
                  suffixIcon:
                      IconButton(onPressed: () {}, icon: Icon(Icons.search))),
            ),
            SizedBox(
              height: 10,
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
          backgroundColor: containerColor,
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
