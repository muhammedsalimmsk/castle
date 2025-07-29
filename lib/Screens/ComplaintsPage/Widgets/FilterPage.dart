import 'package:castle/Colors/Colors.dart'; // ensure AppColor.containerColor is defined
import 'package:castle/Controlls/ComplaintController/ComplaintController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Colors/Colors.dart' as AppColor;

class FilterDialog extends StatelessWidget {
  final ComplaintController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 👈 Rounded corners
      ),
      backgroundColor: backgroundColor,
      title: Text('Filter Options', style: TextStyle(color: Colors.black)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.statuses.map((status) {
                    final isSelected =
                        controller.selectedStatus.value == status;
                    return GestureDetector(
                      onTap: () => controller.setStatus(status),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppColor.containerColor
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected
                              ? AppColor.containerColor
                              : Colors.grey.shade200,
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: isSelected ? backgroundColor : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
            SizedBox(height: 20),
            Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.priorities.map((priority) {
                    final isSelected =
                        controller.selectedPriority.value == priority;
                    return GestureDetector(
                      onTap: () => controller.setPriority(priority),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppColor.containerColor
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected
                              ? AppColor.containerColor
                              : Colors.grey.shade200,
                        ),
                        child: Text(
                          priority,
                          style: TextStyle(
                            color: isSelected ? backgroundColor : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        TextButton(
          // 👈 changed from ElevatedButton
          onPressed: () {
            final status = controller.selectedStatus.value;
            final priority = controller.selectedPriority.value;
            print('Selected Status: $status');
            print('Selected Priority: $priority');
            Get.back();
          },
          child: Text(
            'Apply',
            style: TextStyle(
              color: AppColor.containerColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
