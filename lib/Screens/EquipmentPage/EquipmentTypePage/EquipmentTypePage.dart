import 'package:castle/Controlls/EquipmentController/EquipmentTypeController.dart';
import 'package:castle/Screens/EquipmentPage/EquipmentTypePage/EquipTypeDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Colors/Colors.dart';

import '../../../Controlls/EquipCategoryController/EquipCategoryController.dart';

class EquipmentTypePage extends StatelessWidget {
  const EquipmentTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EquipmentTypeController());

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: backgroundColor,
        iconTheme: IconThemeData(color: buttonColor),
        title: Text("Equipment Types",
            style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.equipType.isEmpty) {
              return const Center(child: Text("No categories found"));
            }

            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: controller.equipType.length,
                itemBuilder: (context, index) {
                  final equipType = controller.equipType[index];
                  return Card(
                    shadowColor: buttonColor,
                    color: backgroundColor,
                    child: ListTile(
                      title: Text(
                        equipType.name ?? "",
                        style: TextStyle(
                            color: buttonColor, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(equipType.description ?? ""),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: buttonColor,
                      ),
                      onTap: () {
                        Get.to(() =>
                            EquipTypeDetails(equipTypeDetails: equipType));
                      },
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        child: Icon(Icons.add, color: backgroundColor),
        onPressed: () {
          showCreateCategoryDialog(context, controller);
          // Open add category page or dialog
        },
      ),
    );
  }

  void showCreateCategoryDialog(
      BuildContext context, EquipmentTypeController controller) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    "Create Category",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: buttonColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name field
                  TextFormField(
                    controller: nameController,
                    cursorColor: buttonColor,
                    decoration: InputDecoration(
                      labelText: "Category Name",
                      labelStyle: TextStyle(color: containerColor),
                      hintText: "Enter category name",
                      hintStyle: TextStyle(color: buttonColor.withOpacity(0.6)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: buttonColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: buttonColor, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter category name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // Description field
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    cursorColor: buttonColor,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: containerColor),
                      hintText: "Enter category description",
                      hintStyle: TextStyle(color: buttonColor.withOpacity(0.6)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: buttonColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: buttonColor, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter description";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: controller.isLoading1.value
                            ? null
                            : () => Get.back(),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onPressed: controller.isLoading1.value
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  controller.createType(
                                    nameController.text.trim(),
                                    descriptionController.text.trim(),
                                  );
                                }
                              },
                        child: controller.isLoading1.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Create",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
