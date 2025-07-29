import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:castle/Model/equipment_model/datum.dart';
import 'package:castle/Screens/EquipmentPage/EquipmentDetails/ClientAddPage.dart';
import 'package:castle/Screens/EquipmentPage/EquipmentDetails/EquipmentDetails.dart';
import 'package:castle/Screens/EquipmentPage/NewEquipments.dart';
import 'package:castle/Widget/CustomAppBarWidget.dart';
import 'package:castle/Widget/CustomDrawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../Model/equipment_model/equipment_model.dart';

class EquipmentPage extends StatefulWidget {
  EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  final EquipmentController controller = Get.put(EquipmentController());

  String role = userDetailModel!.data!.role!.toLowerCase();

  Future<List<EquipmentDetails>?>? _equipmentFuture;
  // Make sure this returns Future<List<EquipmentModel>>
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _equipmentFuture = controller.getEquipmentDetail(role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search & Filter UI
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
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    // filter action
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: shadeColor),
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Icon(FontAwesomeIcons.sliders, color: backgroundColor),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            // 🧾 Title & Sort Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Equipment",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Obx(() => DropdownButton<String>(
                      value: controller.selectedValue.value,
                      underline: SizedBox(),
                      style: const TextStyle(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                      items: controller.sortOptions
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        controller.selectedValue.value = value!;
                        // Optionally refresh list based on sort
                      },
                    )),
              ],
            ),
            const SizedBox(height: 8),

            // 📋 Equipment List using FutureBuilder
            Expanded(
              child: FutureBuilder(
                future: _equipmentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Error: ${snapshot.error}"),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Retry logic
                              controller.getEquipmentDetail(role);
                              (context as Element).reassemble();
                            },
                            icon: Icon(Icons.refresh),
                            label: Text("Retry"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: containerColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        await controller.getEquipmentDetail(role);
                        setState(() {});
                      },
                      child: ListView(
                        physics:
                            const AlwaysScrollableScrollPhysics(), // to allow pull even if empty
                        children: const [
                          SizedBox(height: 200), // space to allow scroll
                          Center(child: Text("No equipment found.")),
                        ],
                      ),
                    );
                  }

                  final equipmentList = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _equipmentFuture = controller.getEquipmentDetail(role);
                      });
                    },
                    child: ListView.builder(
                      itemCount: equipmentList.length,
                      itemBuilder: (context, index) {
                        final datas = equipmentList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: InkWell(
                            onTap: () {
                              Get.to(EquipmentDetailsPage(
                                name: datas.name!,
                                model: datas.model!,
                                serialNumber: datas.serialNumber!,
                                manufacturer: datas.manufacturer!,
                                installationDate: datas.installationDate!,
                                warrantyExpiry: datas.warrantyExpiry!,
                                location: datas.location!,
                                isActive: datas.isActive!,
                                equipmentId: datas.id!,
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xfff0431A4).withOpacity(0.25),
                                    spreadRadius: 0.8,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Text(
                                  datas.name!,
                                  style: TextStyle(color: containerColor),
                                ),
                                subtitle: Text(datas.model!),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(datas.category?.name ?? 'N/A'),
                                        Text(datas.serialNumber!),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: userDetailModel!.data!.role == "ADMIN"
          ? FloatingActionButton.extended(
              onPressed: () => Get.to(ClientAddPage()),
              label: const Icon(Icons.add, color: backgroundColor),
              backgroundColor: buttonColor,
            )
          : const SizedBox.shrink(),
    );
  }
}
