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
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: containerColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Equipment Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: containerColor,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          if (userDetailModel!.data!.role == "ADMIN") ...[
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: buttonColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.edit, color: buttonColor, size: 20),
              ),
              onPressed: () {
                addToController();
                Get.to(UpdateEquipmentPage(
                  equipmentId: equipment.id!,
                ));
              },
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: notWorkingWidgetColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.delete_outline,
                    color: notWorkingTextColor, size: 20),
              ),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: notWorkingWidgetColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: notWorkingTextColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Delete Equipment",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: containerColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      "Are you sure you want to delete this equipment? This action cannot be undone.",
                      style: TextStyle(color: subtitleColor, fontSize: 14),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: subtitleColor),
                        ),
                      ),
                      Obx(
                        () => controller.isDeleting.value
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  color: buttonColor,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: notWorkingTextColor,
                                  foregroundColor: backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () async {
                                  await controller.deleteEquip(equipment.id!);
                                },
                                child: const Text("Delete"),
                              ),
                      ),
                    ],
                  ),
                );
              },
            )
          ]
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: BoxDecoration(
                color: backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: cardShadowColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Icon Container
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: buttonColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: buttonColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.precision_manufacturing,
                      color: buttonColor,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Equipment Name
                  Text(
                    equipment.name ?? 'Unknown Equipment',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: equipment.isActive == true
                          ? workingWidgetColor
                          : notWorkingWidgetColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: equipment.isActive == true
                                ? workingTextColor
                                : notWorkingTextColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          equipment.isActive == true ? "Active" : "Inactive",
                          style: TextStyle(
                            color: equipment.isActive == true
                                ? workingTextColor
                                : notWorkingTextColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Equipment Details Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: _sectionTitle('Equipment Information'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildDetailItem(
                    Icons.model_training,
                    "Model Number",
                    equipment.modelNumber ?? 'N/A',
                  ),
                  _buildDetailItem(
                    Icons.qr_code,
                    "Serial Number",
                    equipment.serialNumber ?? 'N/A',
                  ),
                  _buildDetailItem(
                    Icons.calendar_today,
                    "Installation Date",
                    formatDate(equipment.installationDate),
                  ),
                  _buildDetailItem(
                    Icons.verified,
                    "Warranty Expiry",
                    formatDate(equipment.warrantyExpiry),
                  ),
                  _buildDetailItem(
                    Icons.location_on,
                    "Location Type",
                    equipment.locationType ?? 'N/A',
                  ),
                  _buildDetailItem(
                    Icons.note,
                    "Location Remarks",
                    equipment.locationRemarks ?? 'N/A',
                  ),
                  _buildDetailItem(
                    Icons.category,
                    "Category",
                    equipment.category?.name ?? 'N/A',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Supervisor Info Section
            if (equipment.supervisor != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: _sectionTitle('Supervisor Information'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildDetailItem(
                      Icons.person,
                      "Name",
                      "${equipment.supervisor?.firstName ?? ''} ${equipment.supervisor?.lastName ?? ''}"
                              .trim()
                              .isEmpty
                          ? 'N/A'
                          : "${equipment.supervisor?.firstName ?? ''} ${equipment.supervisor?.lastName ?? ''}"
                              .trim(),
                    ),
                    _buildDetailItem(
                      Icons.email,
                      "Email",
                      equipment.supervisor?.email ?? 'N/A',
                    ),
                    _buildDetailItem(
                      Icons.phone,
                      "Phone",
                      equipment.supervisor?.phone ?? 'N/A',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Client Info Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: _sectionTitle('Client Information'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildDetailItem(
                    Icons.business,
                    "Client Name",
                    equipment.client?.clientName ?? 'N/A',
                  ),
                  _buildDetailItem(
                    Icons.location_city,
                    "Client Address",
                    equipment.client?.clientAddress ?? 'N/A',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Other Info Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: _sectionTitle('Additional Information'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildDetailItem(
                    Icons.access_time,
                    "Created At",
                    formatDate(equipment.createdAt),
                  ),
                  _buildDetailItem(
                    Icons.update,
                    "Updated At",
                    formatDate(equipment.updatedAt),
                  ),
                  _buildDetailItem(
                    Icons.report_problem,
                    "Total Complaints",
                    equipment.count != null
                        ? equipment.count!.complaints.toString()
                        : '0',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (userDetailModel?.data?.role?.toUpperCase() == "CLIENT")
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: buttonColor.withOpacity(0.3),
                    ),
                    icon: const Icon(Icons.report_problem,
                        color: Colors.white, size: 22),
                    label: const Text(
                      "Register Complaint",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
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
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: buttonColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.report_problem,
                    color: buttonColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Register Complaint",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: containerColor,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: TextStyle(color: subtitleColor),
                      filled: true,
                      fillColor: searchBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: dividerColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: buttonColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    style: TextStyle(color: containerColor),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: subtitleColor),
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: searchBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: dividerColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: buttonColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    style: TextStyle(color: containerColor),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: searchBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: dividerColor),
                    ),
                    child: DropdownButton<String>(
                      value: selectedPriority,
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: Icon(Icons.keyboard_arrow_down, color: buttonColor),
                      style: TextStyle(color: containerColor),
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
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: subtitleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Obx(() => controller.isLoading.value
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(color: buttonColor),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        final title = titleController.text.trim();
                        final description = descriptionController.text.trim();

                        if (title.isEmpty || description.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Please fill all fields"),
                              backgroundColor: notWorkingTextColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: containerColor,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dividerColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cardShadowColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: buttonColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: buttonColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: containerColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
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
