import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/PartsController/PartsController.dart';
import 'package:castle/Screens/PartsRequestPagee/NewPartsPage.dart';
import 'package:castle/Screens/PartsRequestPagee/PartsListPage.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RequestedPartsPage extends StatelessWidget {
  RequestedPartsPage({super.key});
  PartsController controller = Get.put(PartsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Search here..",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: containerColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // spacing between field and button
                Container(
                  height: 58,
                  width: 58, // match TextFormField height
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: containerColor),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: backgroundColor,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Gap(10),
            Text(
              "Parts List",
              style: TextStyle(
                  color: containerColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Obx(
              () => SizedBox(
                height: 590,
                child: RefreshIndicator(
                  onRefresh: () async {
                    controller.hasMore2 = true;
                    controller.isRefresh = true;
                    await controller.getRequestedList();
                    controller.isRefresh = false;
                  },
                  child: ListView.builder(
                      itemCount: controller.requestedParts.length,
                      itemBuilder: (context, index) {
                        final data = controller.requestedParts[index];
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
                              data.worker!.firstName!,
                            ),
                            subtitle: Text(data.part!.partName!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  data.status!,
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(PartsListPage());
              },
              child: Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text(
                  "Parts List",
                  style: TextStyle(
                      color: backgroundColor, fontWeight: FontWeight.bold),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
