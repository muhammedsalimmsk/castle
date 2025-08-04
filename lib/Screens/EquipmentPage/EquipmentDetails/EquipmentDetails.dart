import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Controlls/ComplaintController/NewComplaintController/NewComplaintController.dart';
import 'package:castle/Controlls/EquipmentController/EquipmentController.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class EquipmentDetailsPage extends StatelessWidget {
  final String name;
  final String equipmentId;
  final String modelNumber;
  final String serialNumber;
  final String manufacturer;
  final DateTime installationDate;
  final DateTime warrantyExpiry;
  final String location;
  final bool isActive;

  EquipmentDetailsPage({
    super.key,
    required this.name,
    required this.modelNumber,
    required this.serialNumber,
    required this.manufacturer,
    required this.installationDate,
    required this.warrantyExpiry,
    required this.location,
    required this.equipmentId,
    required this.isActive,
  });

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  NewComplaintController controller = Get.put(NewComplaintController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: containerColor,
        title: Text(
          'Equipment Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: buttonShadeColor,
              child: Icon(Icons.precision_manufacturing,
                  color: buttonColor, size: 40),
            ),
            SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              modelNumber,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
            _buildDetailItem("Serial Number", serialNumber),
            _buildDetailItem("Manufacturer", manufacturer),
            _buildDetailItem("Installation Date", formatDate(installationDate)),
            _buildDetailItem("Warranty Expiry", formatDate(warrantyExpiry)),
            _buildDetailItem("Location", location),
            _buildDetailItem("Status", isActive ? "Active" : "Inactive",
                valueColor: isActive ? Colors.green : Colors.red),
            SizedBox(height: 32),
            userDetailModel!.data!.role == "CLIENT"
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: Icon(Icons.report_problem, color: Colors.white),
                      label: Text(
                        "Register Complaint",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      onPressed: () => _showComplaintDialog(context),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(Icons.label_outline, color: buttonColor, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
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
            title: Text("Register Complaint"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Description",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  InputDecorator(
                    decoration: InputDecoration(
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
                child: Text("Cancel", style: TextStyle(color: Colors.black54)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Obx(
                () => controller.isLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(color: backgroundColor),
                        ),
                        onPressed: () async {
                          final title = titleController.text.trim();
                          final description = descriptionController.text.trim();

                          if (title.isEmpty || description.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please fill all fields")),
                            );
                            return;
                          }

                          Navigator.of(context).pop();
                          await controller.complaintRegister(
                              userDetailModel!.data!.role == "ADMIN"
                                  ? "admin"
                                  : "client",
                              title,
                              description,
                              selectedPriority,
                              equipmentId);
                          // TODO: send the complaint to your backend
                          print("Complaint Submitted:");
                          print("Title: $title");
                          print("Description: $description");
                          print("Priority: $selectedPriority");
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}
