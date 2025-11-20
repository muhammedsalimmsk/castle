import 'package:castle/Colors/Colors.dart';
import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:castle/Model/requested_parts_model/datum.dart';
import 'package:castle/Screens/ComplaintsPage/ComplaintDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controlls/PartsController/PartsController.dart';

class RequestedPartDetailPage extends StatelessWidget {
  final RequestedParts partData;
  RequestedPartDetailPage({super.key, required this.partData});
  final PartsController controller = Get.find();
  final List<String> statusOptions = [
    "APPROVED",
    "REJECTED",
    "COLLECTED",
    "DELIVERED"
  ];
  final List<String> statusOptionsClient = [
    "APPROVED",
    "REJECTED",
  ];

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
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Complaint Details Section (NEW)
            if (partData.complaint != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.report_problem_rounded,
                            color: buttonColor, size: 20),
                        SizedBox(width: 8),
                        Text("Complaint Details",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _detailRow("Title", partData.complaint?.title ?? "-"),
                    _detailRow(
                        "Client", partData.complaint?.client?.hotelName ?? "-"),
                    _detailRow("Equipment",
                        partData.complaint?.equipment?.name ?? "-"),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 18),
                        ),
                        onPressed: () {
                          Get.toNamed('/complaintDetails', arguments: {'complaintId': partData.complaintId!});
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 16),
                        label: const Text("View Complaint",
                            style: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            _detailTile("Part Name", partData.part?.partName ?? "-"),
            _detailTile("Quantity", partData.quantity?.toString() ?? "-"),
            _detailTile("Urgency", partData.urgency ?? "-"),
            _detailTile("Reason", partData.reason ?? "-"),
            _detailTile("Requested By", partData.worker?.firstName ?? "-"),
            _detailTile("Status", partData.status ?? "-",
                valueColor: _statusColor(partData.status)),

            const Spacer(),

            if (partData.status == "PENDING") ...[
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 40),
                  ),
                  onPressed: () => _showStatusUpdateSheet(partData.id!),
                  child: const Text("Update Status",
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // 🔹 Helper for compact rows
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _detailTile(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
      case "COLLECTED":
        return Colors.blue;
      case "DELIVERED":
        return Colors.purple;
      case "PENDING":
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  void _showStatusUpdateSheet(String partId) {
    String selectedStatus = "APPROVED";
    final TextEditingController noteController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Update Part Status",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              dropdownColor: backgroundColor,
              value: "APPROVED",
              decoration: const InputDecoration(
                labelText: "Select Status",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: buttonColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: buttonColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: buttonColor, width: 2),
                ),
              ),
              items: userDetailModel!.data!.role == "ADMIN"
                  ? statusOptions
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList()
                  : statusOptionsClient
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
              onChanged: (value) {
                selectedStatus = value!;
              },
            ),
            const SizedBox(height: 14),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Add Note",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: buttonColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: buttonColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: buttonColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(color: buttonColor),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          final note = noteController.text.trim();
                          if (note.isEmpty) {
                            Get.snackbar(
                                "Note Required", "Please enter a note.");
                            return;
                          }

                          if (userDetailModel!.data!.role == "ADMIN") {
                            await controller.updatePartStatusByAdmin(
                                id: partId, status: selectedStatus, note: note);
                          } else {
                            await controller.updatePartStatusByClient(
                                id: partId, status: selectedStatus, note: note);
                          }
                        },
                        child: const Text("Update Status",
                            style: TextStyle(fontSize: 17)),
                      ),
                    ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
