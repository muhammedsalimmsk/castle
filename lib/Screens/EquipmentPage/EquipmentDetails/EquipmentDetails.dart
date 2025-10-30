import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Model/equipment_model/datum.dart';
import 'package:castle/Screens/EquipmentPage/UpdatePage/EquipmentUpdatePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../Controlls/ComplaintController/NewComplaintController/NewComplaintController.dart';
import '../../../Controlls/EquipmentController/EquipmentController.dart';

class EquipmentDetailsPage extends StatelessWidget {
  final EquipmentDetailData equipment;

  EquipmentDetailsPage({super.key, required this.equipment});
  final NewComplaintController controller = Get.put(NewComplaintController());

  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        surfaceTintColor: backgroundColor,
        title: const Text(
          'Equipment Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          if (userDetailModel!.data!.role == "ADMIN") ...[
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () {
                // Navigate to edit page
                addToController();
                Get.to(UpdateEquipmentPage(
                  equipmentId: equipment.id!,
                ));
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: const Text(
                      "Delete",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: buttonColor),
                    ),
                    content: const Text(
                        "Are you sure you want to delete this item?"),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text("Cancel"),
                      ),
                      Obx(
                        () => controller.isDeleting.value
                            ? CircularProgressIndicator(
                                color: buttonColor,
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  foregroundColor: backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () async {
                                  // Your delete action here
                                  await controller.deleteEquip(equipment.id!);
                                },
                                child: const Text(
                                  "Delete",
                                ),
                              ),
                      ),
                    ],
                  ),
                );
                // Navigate to edit page
              },
            )
          ]
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circle Avatar
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blue.shade50,
                child: Icon(Icons.precision_manufacturing,
                    color: Colors.blue, size: 40),
              ),
            ),
            const SizedBox(height: 12),

            // Equipment Name
            Center(
              child: Text(
                equipment.name ?? 'Unknown Equipment',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),

            // Equipment Details Section
            _sectionTitle('Equipment Info'),
            _buildDetailItem("Model Number", equipment.modelNumber ?? ''),
            _buildDetailItem("Serial Number", equipment.serialNumber ?? ''),
            _buildDetailItem(
                "Installation Date", formatDate(equipment.installationDate)),
            _buildDetailItem(
                "Warranty Expiry", formatDate(equipment.warrantyExpiry)),
            _buildDetailItem("Location Type", equipment.locationType ?? ''),
            _buildDetailItem(
                "Location Remarks", equipment.locationRemarks ?? ''),
            _buildDetailItem("Category", equipment.category?.name ?? 'N/A'),
            _buildDetailItem(
              "Status",
              equipment.isActive == true ? "Active" : "Inactive",
              valueColor:
                  equipment.isActive == true ? Colors.green : Colors.red,
            ),

            const SizedBox(height: 24),

            // Client Info Section
            _sectionTitle('Client Info'),
            _buildDetailItem(
                "Client Name", equipment.client?.clientName ?? 'N/A'),
            _buildDetailItem(
                "Client Address", equipment.client?.clientAddress ?? 'N/A'),

            const SizedBox(height: 24),

            // Extra Info (optional)
            _sectionTitle('Other Info'),
            _buildDetailItem("Created At", formatDate(equipment.createdAt)),
            _buildDetailItem("Updated At", formatDate(equipment.updatedAt)),
            _buildDetailItem(
                "Complaints",
                equipment.count != null
                    ? equipment.count!.complaints.toString()
                    : 'N/A'),
            SizedBox(
              height: 10,
            ),
            if (userDetailModel?.data?.role?.toUpperCase() == "CLIENT")
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.report_problem, color: Colors.white),
                    label: const Text(
                      "Register Complaint",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    onPressed: () => _showComplaintDialog(context),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showComplaintDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String selectedPriority = 'Medium';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Register Complaint"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: "Priority",
                      border: OutlineInputBorder(),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPriority,
                        items: ["Low", "Medium", "High", "Urgent"]
                            .map((priority) => DropdownMenuItem(
                                  value: priority,
                                  child: Text(priority),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedPriority = value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.black54)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                      ),
                      child: const Text("Submit",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        final title = titleController.text.trim();
                        final description = descriptionController.text.trim();

                        if (title.isEmpty || description.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill all fields")),
                          );
                          return;
                        }

                        Navigator.of(context).pop();
                        await controller.complaintRegister(
                          userDetailModel!.data!.role!.toLowerCase(),
                          title,
                          description,
                          selectedPriority,
                          equipment.id!,
                        );
                      },
                    )),
            ],
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: buttonColor),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Color? valueColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: buttonColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void addToController() {
    final controller = Get.find<EquipmentController>();
    controller.nameController.text = equipment.name ?? '';
    controller.modelController.text = equipment.modelNumber ?? '';
    controller.serialNumberController.text = equipment.serialNumber ?? '';
    controller.locationType.value = equipment.locationType ?? "";
    controller.installationDate.value = equipment.installationDate;
    controller.warrantyExpiry.value = equipment.warrantyExpiry;
    controller.equipmentTypeId.value = equipment.equipmentTypeId ?? '';
    controller.locationType.value = equipment.locationType ?? '';
    controller.locationRemarksController.text = equipment.locationRemarks ?? '';
    controller.categoryId.value = equipment.categoryId ?? '';
    controller.subCategoryId?.value = equipment.subCategoryId ?? '';
    controller.selectedSubCategoryName.value = equipment.category!.name ?? '';
  }
}
