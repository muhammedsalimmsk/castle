import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Colors/Colors.dart';
import '../../../Controlls/ComplaintController/ComplaintController.dart';

class StatusUpdateDialog extends StatelessWidget {
  final String complaintId;
  final ComplaintController controller = Get.find();

  final Map<String, String> statusOptions = {
    "IN_PROGRESS": "In Progress",
    "RESOLVED": "Resolved",
    "CLOSED": "Closed",
  };

  StatusUpdateDialog({super.key, required this.complaintId});

  @override
  Widget build(BuildContext context) {
    final RxString selectedStatus = "IN_PROGRESS".obs;
    final TextEditingController commentController = TextEditingController();

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Update Status",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Obx(() => DropdownButtonFormField<String>(
                      value: selectedStatus.value,
                      items: statusOptions.entries
                          .map((entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) selectedStatus.value = value;
                      },
                      decoration: const InputDecoration(
                        labelText: "Select Status",
                        border: OutlineInputBorder(),
                      ),
                    )),
                const SizedBox(height: 16),
                TextField(
                  controller: commentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: "Comment",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => controller.isLoading2.value
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: containerColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (commentController.text.trim().isEmpty) {
                              Get.snackbar("Error", "Please add a comment");
                              return;
                            }
                            Get.back();
                            await controller.updateComplaint(
                              complaintId,
                              selectedStatus.value,
                              commentController.text.trim(),
                            );
                            Get.snackbar("Success", "Status updated");
                          },
                          child: const Text("Submit"),
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
