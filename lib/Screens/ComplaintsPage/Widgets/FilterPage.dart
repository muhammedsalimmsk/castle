import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/ComplaintController/ComplaintController.dart';
import 'package:castle/Controlls/ClientController/ClientController.dart';
import 'package:castle/Controlls/DepartmentController/DepartmentController.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterDialog extends StatelessWidget {
  final ComplaintController controller = Get.find();
  
  FilterDialog({super.key}) {
    // Initialize client and department controllers
    final clientController = Get.put(ClientRegisterController());
    final departmentController = Get.put(DepartmentController());
    
    // Load clients and departments if admin
    if (userDetailModel!.data!.role == "ADMIN") {
      if (clientController.clientData.isEmpty) {
        clientController.getClientList();
      }
      if (departmentController.departDetails.isEmpty) {
        departmentController.getDepartment();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientController = Get.find<ClientRegisterController>();
    final departmentController = Get.find<DepartmentController>();
    final role = userDetailModel!.data!.role!.toLowerCase();
    
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: backgroundColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter Options',
            style: TextStyle(
              color: containerColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          if (controller.selectedStatus.value.isNotEmpty ||
              controller.selectedPriority.value.isNotEmpty ||
              controller.selectedClientId.value.isNotEmpty ||
              controller.selectedDepartmentId.value.isNotEmpty)
            TextButton(
              onPressed: () {
                controller.clearFilters();
              },
              child: Text(
                'Clear All',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: containerColor,
              ),
            ),
            SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.statuses.map((status) {
                    final isSelected =
                        controller.selectedStatus.value == status;
                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          controller.setStatus('');
                        } else {
                          controller.setStatus(status);
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? buttonColor
                                : dividerColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected
                              ? buttonColor.withOpacity(0.1)
                              : searchBackgroundColor,
                        ),
                        child: Text(
                          status.replaceAll('_', ' '),
                          style: TextStyle(
                            color: isSelected ? buttonColor : containerColor,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
            SizedBox(height: 20),
            Text(
              'Priority',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: containerColor,
              ),
            ),
            SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.priorities.map((priority) {
                    final isSelected =
                        controller.selectedPriority.value == priority;
                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          controller.setPriority('');
                        } else {
                          controller.setPriority(priority);
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? buttonColor
                                : dividerColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected
                              ? buttonColor.withOpacity(0.1)
                              : searchBackgroundColor,
                        ),
                        child: Text(
                          priority,
                          style: TextStyle(
                            color: isSelected ? buttonColor : containerColor,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
            if (userDetailModel!.data!.role == "ADMIN") ...[
              SizedBox(height: 20),
              Text(
                'Client',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: containerColor,
                ),
              ),
              SizedBox(height: 8),
              Obx(() => Container(
                    decoration: BoxDecoration(
                      color: searchBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: dividerColor, width: 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedClientId.value.isEmpty
                          ? null
                          : controller.selectedClientId.value,
                      hint: Text(
                        'Select Client',
                        style: TextStyle(color: subtitleColor, fontSize: 14),
                      ),
                      underline: SizedBox(),
                      icon: Icon(Icons.keyboard_arrow_down, color: buttonColor),
                      items: [
                        DropdownMenuItem<String>(
                          value: '',
                          child: Text(
                            'All Clients',
                            style: TextStyle(color: containerColor),
                          ),
                        ),
                        ...clientController.clientData.map((client) {
                          final clientName = client.clientName ??
                              '${client.firstName ?? ''} ${client.lastName ?? ''}'.trim();
                          return DropdownMenuItem<String>(
                            value: client.id!,
                            child: Text(
                              clientName,
                              style: TextStyle(color: containerColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? value) {
                        controller.setClientId(value ?? '');
                      },
                    ),
                  )),
              SizedBox(height: 20),
              Text(
                'Department',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: containerColor,
                ),
              ),
              SizedBox(height: 8),
              Obx(() => Container(
                    decoration: BoxDecoration(
                      color: searchBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: dividerColor, width: 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedDepartmentId.value.isEmpty
                          ? null
                          : controller.selectedDepartmentId.value,
                      hint: Text(
                        'Select Department',
                        style: TextStyle(color: subtitleColor, fontSize: 14),
                      ),
                      underline: SizedBox(),
                      icon: Icon(Icons.keyboard_arrow_down, color: buttonColor),
                      items: [
                        DropdownMenuItem<String>(
                          value: '',
                          child: Text(
                            'All Departments',
                            style: TextStyle(color: containerColor),
                          ),
                        ),
                        ...departmentController.departDetails
                            .where((dept) => dept.isActive == true)
                            .map((dept) {
                          return DropdownMenuItem<String>(
                            value: dept.id!,
                            child: Text(
                              dept.name ?? '',
                              style: TextStyle(color: containerColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? value) {
                        controller.setDepartmentId(value ?? '');
                      },
                    ),
                  )),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: subtitleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            controller.applyFilters(role: role);
            Get.back();
          },
          child: Text(
            'Apply',
            style: TextStyle(
              color: buttonColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
