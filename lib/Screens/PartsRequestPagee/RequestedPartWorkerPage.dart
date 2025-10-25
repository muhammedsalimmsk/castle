import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Colors/Colors.dart';
import '../../../Controlls/ComplaintController/ComplaintController.dart';

class RequestedPartsWorkerPage extends StatelessWidget {
  final ComplaintController controller = Get.find();

  RequestedPartsWorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Requested Parts"),
        backgroundColor: backgroundColor,
        foregroundColor: containerColor,
        elevation: 0,
      ),
      body: Obx(() {
        final parts = controller.partsModel;

        if (controller.isLoading3.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (parts.isEmpty) {
          return const Center(child: Text("No parts requested."));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: parts.length,
          itemBuilder: (context, index) {
            final part = parts[index];

            return Card(
              shadowColor: containerColor,
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: buttonColor),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      part.part?.partName ?? 'Unknown',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text("Quantity: ${part.quantity}"),
                    Text("Urgency: ${part.urgency}"),
                    Text("Status: ${part.status ?? 'Pending'}"),
                    const SizedBox(height: 12),

                    // ✅ Conditional Button or Collected Badge
                    part.collectedAt != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.check_circle,
                                    color: Colors.green, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  "Collected",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showCollectedConfirmation(context, part.id);
                              },
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text("Mark as Collected"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showCollectedConfirmation(BuildContext context, String? partRequestId) {
    if (partRequestId == null) return;

    final RxBool isProcessing = false.obs;

    Get.dialog(
      Obx(
        () => Dialog(
          backgroundColor: backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(minHeight: 120),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Confirm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Are you sure you want to mark this part as collected?",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back(); // Close dialog
                      },
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: isProcessing.value
                          ? null
                          : () async {
                              isProcessing.value = true;
                              await controller.updatePartRequestStatus(
                                  partRequestId, "COLLECTED");
                              await controller.getRequestedPartsList();
                              isProcessing.value = false;
                              Get.back(); // Close dialog
                              Get.snackbar("Success", "Marked as collected");
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      child: isProcessing.value
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Yes",
                              style: TextStyle(color: backgroundColor),
                            ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
