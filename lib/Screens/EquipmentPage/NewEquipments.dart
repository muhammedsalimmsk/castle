import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controlls/EquipmentController/EquipmentController.dart';
import '../../Widget/CustomTextField.dart';

class NewEquipmentsRequest extends StatelessWidget {
  final String clientId;
  const NewEquipmentsRequest({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EquipmentController());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: const Text(
          "New Equipment",
          style: TextStyle(color: containerColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
              spacing: 10,
              children: [
                CustomTextField(
                    controller: controller.nameController, hint: "Name"),
                CustomTextField(
                  controller: controller.modelController,
                  hint: "Model",
                ),
                CustomTextField(
                    controller: controller.serialNumberController,
                    hint: "Serial Number"),
                CustomTextField(
                    controller: controller.manufacturerController,
                    hint: "Manufacture"),
                CustomTextField(
                    controller: controller.locationController,
                    hint: "Location"),

                Obx(() => TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: controller.installationDate.value != null
                            ? controller.installationDate.value!
                                .toLocal()
                                .toString()
                                .split(' ')[0]
                            : '',
                      ),
                      onTap: () async {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // to prevent keyboard
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: controller.installationDate.value ??
                              DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          controller.installationDate.value = picked;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Installation Date",
                        hintText: "Select Installation Date",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )),
                Obx(() => TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: controller.warrantyExpiry.value != null
                            ? controller.warrantyExpiry.value!
                                .toLocal()
                                .toString()
                                .split(' ')[0]
                            : '',
                      ),
                      onTap: () async {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // to prevent keyboard
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate:
                              controller.warrantyExpiry.value ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          controller.warrantyExpiry.value = picked;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Warranty Expiry",
                        hintText: "Select Warranty Expiry",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )),
                Text("Specifications",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: controller.specificationInput,
                  decoration: InputDecoration(
                    hintText: "Type and press Enter or Space",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => controller.addSpecificationFromInput(),
                  onChanged: (value) {
                    if (value.endsWith(" ")) {
                      controller.addSpecificationFromInput();
                    }
                  },
                ),
                Obx(() => Wrap(
                      spacing: 8,
                      children: controller.specifications.map((spec) {
                        return Chip(
                          label: Text(spec),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () => controller.removeSpecification(spec),
                        );
                      }).toList(),
                    )),

                // Dropdown for Category
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: "Select Category",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  items: controller.catList.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat.id,
                      child: Text(cat.name ?? 'Unnamed'),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      controller.categoryId.value = value ?? '',
                ),

                // // Only for Admins
                // if (userDetailModel!.data!.role == "ADMIN") ...[
                //   Obx(() => TextFormField(
                //         readOnly: true,
                //         controller: TextEditingController(
                //             text: controller.selectedClientName.value),
                //         decoration: InputDecoration(
                //           labelText: "Select Client",
                //           suffixIcon: Icon(Icons.arrow_drop_down),
                //           border: OutlineInputBorder(),
                //         ),
                //         onTap: () => _showClientDialog(context),
                //       )),
                // ],

                const SizedBox(height: 20),
                Obx(() => controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : InkWell(
                        onTap: () => userDetailModel!.data!.role == "ADMIN"
                            ? controller.createEquipment(clientId)
                            : controller
                                .createEquipment(userDetailModel!.data!.id),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: buttonColor),
                          child: Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))
              ],
            )),
      ),
    );
  }

  void _showClientDialog(BuildContext context) {
    final controller = Get.find<EquipmentController>();

    Get.dialog(
      Dialog(
        child: Container(
          width: double.infinity,
          height: 400,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Search Clients",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => controller.searchQuery.value = value,
              ),
              // SizedBox(height: 10),
              // Expanded(
              //   child: Obx(() {
              //     final clients = controller.filteredClients;
              //     if (clients.isEmpty) {
              //       return Center(child: Text("No clients found"));
              //     }
              //     return ListView.builder(
              //       itemCount: clients.length,
              //       itemBuilder: (_, index) {
              //         final client = clients[index];
              //         return ListTile(
              //           title: Text(
              //               '${client.firstName ?? ''} ${client.lastName ?? ''}'),
              //           onTap: () {
              //             controller.clientIdController.text = client.id ?? '';
              //             controller.selectedClientName.value =
              //                 '${client.firstName ?? ''} ${client.lastName ?? ''}';
              //             Get.back(); // close dialog
              //           },
              //         );
              //       },
              //     );
              //   }),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
