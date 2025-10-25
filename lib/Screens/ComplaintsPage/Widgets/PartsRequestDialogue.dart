import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Colors/Colors.dart';
import '../../../Controlls/ComplaintController/ComplaintController.dart';

class PartRequestDialog extends StatelessWidget {
  final String complaintId;
  final String type;
  PartRequestDialog({super.key, required this.complaintId, required this.type});

  final ComplaintController controller = Get.find();

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  final RxString selectedPartId = ''.obs;
  final RxInt selectedStock = 0.obs;
  final RxString urgency = 'MEDIUM'.obs;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Request Spare Parts",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),

                // Part Dropdown
                Obx(() => DropdownButtonFormField<String>(
                      dropdownColor: backgroundColor,
                      value: selectedPartId.value.isNotEmpty
                          ? selectedPartId.value
                          : null,
                      items: controller.partsList.map((part) {
                        return DropdownMenuItem(
                          value: part.id,
                          child: Text(part.partName ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedPartId.value = value;
                          final selected = controller.partsList
                              .firstWhere((p) => p.id == value);
                          selectedStock.value = selected.currentStock ?? 0;
                        }
                      },
                      decoration: _inputDecoration("Select Part"),
                    )),

                Obx(() => selectedPartId.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Available Stock: ${selectedStock.value}",
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 14),
                        ),
                      )
                    : const SizedBox()),

                const SizedBox(height: 20),

                // Quantity Input
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("Quantity"),
                ),
                const SizedBox(height: 20),

                // Reason Input
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: _inputDecoration("Reason for Request"),
                ),
                const SizedBox(height: 20),

                // Urgency Dropdown
                Obx(() => DropdownButtonFormField<String>(
                      value: urgency.value,
                      items: ["LOW", "MEDIUM", "HIGH", "URGENT"]
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) => urgency.value = value ?? 'MEDIUM',
                      decoration: _inputDecoration("Priority Level"),
                    )),

                const SizedBox(height: 24),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (selectedPartId.value.isEmpty ||
                          quantityController.text.isEmpty ||
                          reasonController.text.isEmpty) {
                        Get.snackbar("Incomplete", "Please fill all fields.");
                        return;
                      }

                      controller.addRequestedPart({
                        "partId": selectedPartId.value,
                        "quantity": int.parse(quantityController.text),
                        "reason": reasonController.text,
                        "urgency": urgency.value,
                      });

                      selectedPartId.value = '';
                      selectedStock.value = 0;
                      urgency.value = 'MEDIUM';
                      quantityController.clear();
                      reasonController.clear();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add to List"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Requested Parts List
                Obx(() => controller.requestedParts.isEmpty
                    ? const Text(
                        "No parts added yet.",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.requestedParts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final item = controller.requestedParts[index];
                          final partName = controller.partsList
                                  .firstWhereOrNull(
                                      (e) => e.id == item['partId'])
                                  ?.partName ??
                              'Unknown';
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ListTile(
                              title: Text(partName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  "Qty: ${item['quantity']}  |  Priority: ${item['urgency']}"),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    controller.removeRequestedPart(index),
                              ),
                            ),
                          );
                        },
                      )),

                const SizedBox(height: 28),

                // Submit Button
                Obx(() => controller.isLoading3.value
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: buttonColor,
                      ))
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (controller.requestedParts.isEmpty) {
                              Get.snackbar("Empty",
                                  "Add at least one part before submitting.");
                              return;
                            }
                            await controller.requestMultipleParts(
                                complaintId, type);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            "Submit Request",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 15),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: buttonColor, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
      );
}
