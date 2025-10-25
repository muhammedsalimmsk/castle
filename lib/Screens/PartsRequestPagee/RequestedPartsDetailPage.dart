import 'package:castle/Colors/Colors.dart';
import 'package:castle/Model/requested_parts_model/datum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestedPartDetailPage extends StatelessWidget {
  final RequestedParts partData;
  const RequestedPartDetailPage({super.key, required this.partData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        surfaceTintColor: backgroundColor,
        backgroundColor: backgroundColor,
        elevation: 0.8,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Requested Part Details",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailTile("Part Name", partData.part?.partName ?? "-"),
            _detailTile("Quantity", partData.quantity?.toString() ?? "-"),
            _detailTile("Urgency", partData.urgency ?? "-"),
            _detailTile("Reason", partData.reason ?? "-"),
            _detailTile("Requested By", partData.worker?.firstName ?? "-"),
            _detailTile("Status", partData.status ?? "-",
                valueColor: _statusColor(partData.status)),
            const Spacer(),
            if (partData.status == "PENDING") ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: buttonColor),
                        foregroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () =>
                          _showNoteDialog(partData.id!, "REJECTED"),
                      child: const Text("Reject"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () =>
                          _showNoteDialog(partData.id!, "APPROVED"),
                      child: const Text("Accept"),
                    ),
                  ),
                ],
              ),
            ] else
              Center(
                child: Text(
                  "This request is already ${partData.status}",
                  style: TextStyle(
                    fontSize: 14,
                    color: _statusColor(partData.status),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailTile(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status) {
      case "APPROVED":
        return Colors.green;
      case "REJECTED":
        return Colors.red;
      case "PENDING":
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  void _showNoteDialog(String partId, String status) {
    final TextEditingController noteController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: backgroundColor,
        title: const Text("Add Note"),
        content: TextField(
          controller: noteController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Enter note...",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: status == "APPROVED" ? buttonColor : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(status == "APPROVED" ? "Accept" : "Reject"),
            onPressed: () async {
              final note = noteController.text.trim();
              if (note.isEmpty) {
                Get.snackbar("Note Required", "Please enter a note.");
                return;
              }
              Get.back();

              // await controller.updateParts(
              //   partId,
              //   status,
              //   note,
              //   userDetailModel!.data!.role!.toLowerCase(),
              // );

              Get.snackbar(
                "Success",
                "Part $status Successfully!",
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }
}
