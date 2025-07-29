import 'package:flutter/material.dart';

import '../../../Colors/Colors.dart';
import '../../../Controlls/ComplaintController/ComplaintController.dart';
import 'package:get/get.dart';

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
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Request Parts",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            const SizedBox(height: 10),

            // 🔽 Part Dropdown
            Obx(() => DropdownButtonFormField<String>(
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
                      final selected =
                          controller.partsList.firstWhere((p) => p.id == value);
                      selectedStock.value = selected.currentStock ?? 0;
                    }
                  },
                  decoration: _inputDecoration("Select Part"),
                )),

            Obx(() => selectedPartId.value.isNotEmpty
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 8),
                    child: Text("Current Stock: ${selectedStock.value}"),
                  )
                : const SizedBox()),

            const SizedBox(height: 10),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("Quantity"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: reasonController,
              maxLines: 2,
              decoration: _inputDecoration("Reason"),
            ),
            const SizedBox(height: 10),

            // 🔼 Urgency
            Obx(() => DropdownButtonFormField<String>(
                  dropdownColor: backgroundColor,
                  value: urgency.value,
                  items: ["LOW", "MEDIUM", "HIGH", "URGENT"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => urgency.value = value ?? 'MEDIUM',
                  decoration: _inputDecoration("Priority"),
                )),
            const SizedBox(height: 10),

            // ➕ Add to List Button
            ElevatedButton.icon(
              onPressed: () {
                if (selectedPartId.value.isEmpty ||
                    quantityController.text.isEmpty ||
                    reasonController.text.isEmpty) {
                  Get.snackbar("Missing", "Fill all fields to add");
                  return;
                }

                controller.addRequestedPart({
                  "partId": selectedPartId.value,
                  "quantity": int.parse(quantityController.text),
                  "reason": reasonController.text,
                  "urgency": urgency.value,
                });

                // Reset fields
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
              ),
            ),

            const SizedBox(height: 12),

            // 📝 List of Requested Parts
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.requestedParts.length,
                  itemBuilder: (_, index) {
                    final item = controller.requestedParts[index];
                    return Card(
                      color: borderColor,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(
                          controller.partsList
                                  .firstWhere((e) => e.id == item['partId'])
                                  .partName ??
                              'Unknown',
                        ),
                        subtitle: Text(
                            "Qty: ${item['quantity']} | Urgency: ${item['urgency']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              controller.removeRequestedPart(index),
                        ),
                      ),
                    );
                  },
                )),

            const SizedBox(height: 12),

            Obx(() => controller.isLoading3.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (controller.requestedParts.isEmpty) {
                        Get.snackbar("Empty", "No parts added to request");
                        return;
                      }
                      await controller.requestMultipleParts(complaintId, type);
                      Get.back(); // close dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Submit All"),
                  )),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: buttonColor),
            borderRadius: BorderRadius.circular(10)),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: buttonColor),
            borderRadius: BorderRadius.circular(10)),
      );
}
