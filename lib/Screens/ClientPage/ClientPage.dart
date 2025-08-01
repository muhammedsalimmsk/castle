import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:castle/Model/client_model/datum.dart';
import 'package:castle/Screens/ClientPage/ClientRegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widget/CustomAppBarWidget.dart';
import '../../Widget/CustomDrawer.dart';

class ClientPage extends StatelessWidget {
  ClientPage({super.key});
  ClientRegisterController controller = Get.put(ClientRegisterController());

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
                "All Clients",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Obx(() {
                return SizedBox(
                  height: 660,
                  child: ListView.builder(
                    itemCount: controller.clientData.length,
                    itemBuilder: (context, index) {
                      final ClientData client = controller.clientData[index];
                      print(client.clientAddress);
                      return ListTile(
                        title: Text(client.clientName!),
                        subtitle:
                            Text("${client.firstName} ${client.lastName}"),
                        leading: Icon(Icons.person),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.more_vert),
                            ),
                            IconButton(
                              onPressed: () async {
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
                                                  CircularProgressIndicator(),
                                            )
                                          : ElevatedButton(
                                              onPressed: () async {
                                                await controller
                                                    .deleteClient(client.id!);
                                                Get.back();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: containerColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                              icon: Icon(Icons.delete),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: containerColor,
        onPressed: () {
          Get.to(ClientRegisterOne());
        },
        label: Text(
          "Add New",
          style: TextStyle(color: backgroundColor),
        ),
      ),
    );
  }
}
