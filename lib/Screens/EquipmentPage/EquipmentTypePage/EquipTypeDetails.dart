import 'package:castle/Controlls/EquipmentController/EquipmentTypeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:castle/Model/equipment_type_list_model/datum.dart';
import 'package:castle/Colors/Colors.dart'; // assuming you have buttonColor/backgroundColor defined

class EquipTypeDetails extends StatelessWidget {
  final EquipmentType equipTypeDetails;

  EquipTypeDetails({super.key, required this.equipTypeDetails});
  final EquipmentTypeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final count = equipTypeDetails.count;
    TextEditingController nameController =
        TextEditingController(text: equipTypeDetails.name);
    TextEditingController descriptionController =
        TextEditingController(text: equipTypeDetails.description);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: buttonColor),
        backgroundColor: backgroundColor,
        title: Text(
          equipTypeDetails.name ?? "Equipment Type",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: buttonColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showUpdateCategoryDialog(context, nameController,
                    descriptionController, equipTypeDetails.id!);
              },
              icon: Icon(
                Icons.edit,
                color: buttonColor,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Title Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: buttonColor.withOpacity(0.15),
                    child: Icon(
                      Icons.category_rounded,
                      color: buttonColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      equipTypeDetails.name ?? "No name available",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          backgroundColor: backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: const Text(
                            "Delete",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                              "Are you sure you want to delete this item?"),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: buttonColor),
                              ),
                            ),
                            Obx(
                              () => controller.isUpdating.value
                                  ? CircularProgressIndicator(
                                      color: buttonColor,
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: buttonColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      onPressed: () async {
                                        // Your delete action here
                                        await controller.deleteEquipType(
                                            equipTypeDetails.id!);
                                      },
                                      child: const Text(
                                        "Delete",
                                        style:
                                            TextStyle(color: backgroundColor),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: buttonColor.withOpacity(0.1),
                        border: Border.all(color: buttonColor.withOpacity(0.3)),
                      ),
                      child: Icon(
                        Icons.delete,
                        color: buttonColor,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Description Section
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: buttonColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    equipTypeDetails.description?.toString().isNotEmpty == true
                        ? equipTypeDetails.description.toString()
                        : "No description provided.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Equipment Count
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
              decoration: BoxDecoration(
                color: buttonColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: buttonColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Equipments",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: buttonColor,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${count?.equipment ?? 0}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Created & Updated Info
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: buttonColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _infoRow(
                    "Created At",
                    _formatDate(equipTypeDetails.createdAt),
                  ),
                  const SizedBox(height: 6),
                  _infoRow(
                    "Updated At",
                    _formatDate(equipTypeDetails.updatedAt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            )),
        Text(value,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            )),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return "${date.day}/${date.month}/${date.year}";
  }

  void showUpdateCategoryDialog(
      BuildContext context,
      TextEditingController nameController,
      TextEditingController descriptionController,
      String id) {
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
                    "Create A Type",
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
                      labelText: "Type Name",
                      labelStyle: TextStyle(color: containerColor),
                      hintText: "Enter Type name",
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
                        return "Please enter type name";
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
                      hintText: "Enter type description",
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
                        onPressed: controller.isUpdating.value
                            ? null
                            : () => Get.back(),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: buttonColor),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Obx(
                        () => controller.isUpdating.value
                            ? CircularProgressIndicator(
                                color: buttonColor,
                              )
                            : ElevatedButton(
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
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.updateEquipType(
                                      id,
                                      name: nameController.text.trim(),
                                      description:
                                          descriptionController.text.trim(),
                                    );
                                  }
                                },
                                child: const Text(
                                  "Create",
                                  style: TextStyle(color: Colors.white),
                                ),
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
